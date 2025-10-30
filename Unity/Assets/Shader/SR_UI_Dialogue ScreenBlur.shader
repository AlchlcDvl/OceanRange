Shader "SR/UI/Dialogue ScreenBlur" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_BlurAmount ("Blur Amount", Range(0, 25)) = 1
		_Transition ("Transition", Range(0, 1)) = 1
		_MainTex ("MainTex", 2D) = "black" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
	}
	SubShader {
		Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		GrabPass {
		}
		Pass {
			Name "FORWARD"
			Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Cull Off
			GpuProgramID 36906
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float _BlurAmount;
			float _Transition;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _GrabTexture;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy;
                o.color = v.color;
                tmp0.y = tmp0.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp0.x + tmp0.y;
                tmp0.x = unity_MatrixV._m22 * tmp0.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp0.w + tmp0.x;
                o.texcoord1.z = -tmp0.x;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord1.w = tmp1.w;
                o.texcoord1.xy = tmp0.zz + tmp0.xw;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                tmp0.x = inp.color.w * _Color.w;
                tmp0.x = tmp0.x * _Transition;
                tmp0.y = tmp0.x * _BlurAmount;
                tmp1.yz = inp.texcoord1.yx / inp.texcoord1.ww;
                tmp2.xyz = -tmp0.yyy * float3(0.0058594, 0.0019531, 0.0039063) + tmp1.zzz;
                tmp2.w = 1.0 - tmp1.y;
                tmp3 = tex2D(_GrabTexture, tmp2.yw);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp4 = tex2D(_GrabTexture, tmp2.zw);
                tmp3.xyz = tmp4.xyz * float3(0.75, 0.75, 0.75) + tmp3.xyz;
                tmp4 = tex2D(_GrabTexture, tmp2.xw);
                tmp5.w = tmp2.w;
                tmp3.xyz = tmp4.xyz * float3(0.5, 0.5, 0.5) + tmp3.xyz;
                tmp5.xyz = tmp0.yyy * float3(0.0019531, 0.0039063, 0.0058594) + tmp1.zzz;
                tmp4 = tex2D(_GrabTexture, tmp5.xw);
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp6 = tex2D(_GrabTexture, tmp5.yw);
                tmp7 = tex2D(_GrabTexture, tmp5.zw);
                tmp4.xyz = tmp6.xyz * float3(0.75, 0.75, 0.75) + tmp4.xyz;
                tmp4.xyz = tmp7.xyz * float3(0.5, 0.5, 0.5) + tmp4.xyz;
                tmp3.xyz = tmp3.xyz + tmp4.xyz;
                tmp1.x = 1.0 - tmp1.y;
                tmp4 = tex2D(_GrabTexture, tmp1.zx);
                tmp3.xyz = tmp3.xyz + tmp4.xyz;
                tmp0.z = _ScreenParams.y / _ScreenParams.x;
                tmp0.z = tmp0.z * 1024.0;
                tmp0.y = tmp0.y / tmp0.z;
                tmp0.z = 1.0 - tmp1.y;
                tmp1.w = -tmp0.y * 2.0 + tmp0.z;
                tmp4 = tex2D(_GrabTexture, tmp1.zw);
                tmp6.y = tmp1.w;
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp1.xy = -tmp0.yy * float2(6.0, 4.0) + tmp0.zz;
                tmp7 = tex2D(_GrabTexture, tmp1.zy);
                tmp4.xyz = tmp7.xyz * float3(0.75, 0.75, 0.75) + tmp4.xyz;
                tmp7 = tex2D(_GrabTexture, tmp1.zx);
                tmp4.xyz = tmp7.xyz * float3(0.5, 0.5, 0.5) + tmp4.xyz;
                tmp1.w = tmp0.y * 2.0 + tmp0.z;
                tmp7.xy = tmp0.yy * float2(4.0, 6.0) + tmp0.zz;
                tmp8 = tex2D(_GrabTexture, tmp1.zw);
                tmp6.w = tmp1.w;
                tmp7.z = tmp1.z;
                tmp0.yzw = tmp8.xyz + tmp8.xyz;
                tmp8 = tex2D(_GrabTexture, tmp7.zx);
                tmp9 = tex2D(_GrabTexture, tmp7.zy);
                tmp0.yzw = tmp8.xyz * float3(0.75, 0.75, 0.75) + tmp0.yzw;
                tmp0.yzw = tmp9.xyz * float3(0.5, 0.5, 0.5) + tmp0.yzw;
                tmp0.yzw = tmp0.yzw + tmp4.xyz;
                tmp0.yzw = tmp0.yzw + tmp3.xyz;
                tmp6.x = tmp2.y;
                tmp3 = tex2D(_GrabTexture, tmp6.xy);
                tmp4 = tex2D(_GrabTexture, tmp6.xw);
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp2.y = tmp1.x;
                tmp1.x = tmp2.z;
                tmp8 = tex2D(_GrabTexture, tmp1.xy);
                tmp3.xyz = tmp8.xyz * float3(0.75, 0.75, 0.75) + tmp3.xyz;
                tmp8 = tex2D(_GrabTexture, tmp2.xy);
                tmp3.xyz = tmp8.xyz * float3(0.5, 0.5, 0.5) + tmp3.xyz;
                tmp6.z = tmp5.x;
                tmp8 = tex2D(_GrabTexture, tmp6.zy);
                tmp6 = tex2D(_GrabTexture, tmp6.zw);
                tmp6.xyz = tmp6.xyz + tmp6.xyz;
                tmp8.xyz = tmp8.xyz + tmp8.xyz;
                tmp1.z = tmp5.y;
                tmp2.z = tmp5.z;
                tmp5 = tex2D(_GrabTexture, tmp1.zy);
                tmp5.xyz = tmp5.xyz * float3(0.75, 0.75, 0.75) + tmp8.xyz;
                tmp8 = tex2D(_GrabTexture, tmp2.zy);
                tmp5.xyz = tmp8.xyz * float3(0.5, 0.5, 0.5) + tmp5.xyz;
                tmp3.xyz = tmp3.xyz + tmp5.xyz;
                tmp0.yzw = tmp0.yzw + tmp3.xyz;
                tmp1.w = tmp7.x;
                tmp2.w = tmp7.y;
                tmp3 = tex2D(_GrabTexture, tmp1.xw);
                tmp1 = tex2D(_GrabTexture, tmp1.zw);
                tmp1.xyz = tmp1.xyz * float3(0.75, 0.75, 0.75) + tmp6.xyz;
                tmp3.xyz = tmp3.xyz * float3(0.75, 0.75, 0.75) + tmp4.xyz;
                tmp4 = tex2D(_GrabTexture, tmp2.xw);
                tmp2 = tex2D(_GrabTexture, tmp2.zw);
                tmp1.xyz = tmp2.xyz * float3(0.5, 0.5, 0.5) + tmp1.xyz;
                tmp2.xyz = tmp4.xyz * float3(0.5, 0.5, 0.5) + tmp3.xyz;
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp0.yzw = tmp0.yzw + tmp1.xyz;
                tmp1.x = inp.texcoord.y * 1.666667;
                tmp1.x = max(tmp1.x, 0.25);
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.x = tmp1.x - 1.0;
                tmp1.x = tmp0.x * tmp1.x + 1.0;
                o.sv_target.w = tmp0.x;
                tmp0.xyz = tmp0.yzw * tmp1.xxx;
                o.sv_target.xyz = tmp0.xyz * float3(0.0416667, 0.0416667, 0.0416667);
                return o;
			}
			ENDCG
		}
	}
	Fallback "UI/Unlit/Transparent"
	CustomEditor "ShaderForgeMaterialInspector"
}