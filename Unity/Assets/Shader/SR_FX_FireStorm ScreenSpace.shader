Shader "SR/FX/FireStorm ScreenSpace" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("MainTex", 2D) = "white" {}
		_Refraction ("Refraction", 2D) = "white" {}
		_RefractionStrength ("Refraction Strength", Range(0, 2)) = 1
		_AberationStrength ("Aberation Strength", Range(0, 2)) = 1
		_Intensity ("Intensity", Float) = 5
	}
	SubShader {
		LOD 550
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay" "RenderType" = "Overlay" }
		GrabPass {
		}
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Overlay" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			ZTest Always
			ZWrite Off
			Cull Off
			Offset 1, -100
			GpuProgramID 14099
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _Color;
			float4 _Refraction_ST;
			float _AberationStrength;
			float _RefractionStrength;
			float _Intensity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _GrabTexture;
			sampler2D _Refraction;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xzw = v.vertex.xzw;
                tmp0.y = v.vertex.y * _ProjectionParams.x;
                o.position = tmp0;
                o.texcoord2 = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.color = v.color;
                tmp0.w = tmp1.y * unity_MatrixV._m21;
                tmp0.w = unity_MatrixV._m20 * tmp1.x + tmp0.w;
                tmp0.w = unity_MatrixV._m22 * tmp1.z + tmp0.w;
                tmp0.w = unity_MatrixV._m23 * tmp1.w + tmp0.w;
                o.texcoord3.z = -tmp0.w;
                tmp0.xz = v.vertex.xw;
                tmp1.xz = float2(0.5, 0.5);
                tmp1.y = _ProjectionParams.x;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.w = tmp0.y * 0.5;
                o.texcoord3.xy = tmp0.zz + tmp0.xw;
                o.texcoord3.w = v.vertex.w;
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
                tmp0.x = _ProjectionParams.x * -_ProjectionParams.x;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1.z = tmp0.x * tmp1.y;
                tmp0.xy = tmp1.xz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0.zw = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.zw);
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.z = tmp0.z - _ProjectionParams.y;
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = tmp0.z * 0.02;
                tmp0.z = min(tmp0.z, 1.0);
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.yzw = tmp0.www * tmp1.xyz;
                tmp1.x = tmp1.w + tmp1.y;
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp2 = tmp0.wwww * float4(0.5, 0.1, -0.5, 0.05) + tmp1.xzxz;
                tmp1.x = saturate(tmp1.z * 1.25 + 0.75);
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = sin(tmp0.w);
                tmp2 = tmp2 * _Refraction_ST + _Refraction_ST;
                tmp3 = tex2D(_Refraction, tmp2.xy);
                tmp2 = tex2D(_Refraction, tmp2.zw);
                tmp4.x = tmp2.x * tmp3.x;
                tmp1.y = saturate(-tmp3.x * tmp2.x + 1.0);
                tmp1.x = tmp1.y * 0.2 + tmp1.x;
                tmp1.x = min(tmp1.x, 1.0);
                tmp4.yz = _Color.ww;
                tmp1.yz = tmp0.zz * tmp4.xy;
                tmp4.w = 0.0;
                tmp1.yz = tmp1.yz * tmp4.zw;
                tmp1.w = _RefractionStrength * 0.01;
                tmp0.xy = tmp1.yz * tmp1.ww + tmp0.xy;
                tmp1.yz = tmp0.xy - float2(0.5, 0.5);
                tmp1.w = _Color.w * _AberationStrength;
                tmp2.x = tmp1.w * 0.025;
                tmp1.w = tmp0.w * tmp1.w;
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.x = sin(tmp0.w);
                tmp3.x = cos(tmp0.w);
                tmp4.z = tmp2.x;
                tmp4.y = tmp3.x;
                tmp4.x = -tmp2.x;
                tmp2.y = dot(tmp1.xy, tmp4.xy);
                tmp2.x = dot(tmp1.xy, tmp4.xy);
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp2 = tex2D(_GrabTexture, tmp2.xy);
                tmp0.w = tmp1.w * -0.0025 + 1.0;
                tmp3.xy = tmp1.ww * float2(-0.025, -0.00125);
                tmp3.yz = tmp0.xy * tmp0.ww + -tmp3.yy;
                tmp4 = tex2D(_GrabTexture, tmp0.xy);
                tmp0.x = sin(tmp3.x);
                tmp3.x = cos(tmp3.x);
                tmp5 = tex2D(_GrabTexture, tmp3.yz);
                tmp2.y = tmp5.y;
                tmp5.z = tmp0.x;
                tmp5.y = tmp3.x;
                tmp5.x = -tmp0.x;
                tmp0.y = dot(tmp1.xy, tmp5.xy);
                tmp0.x = dot(tmp1.xy, tmp5.xy);
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp3 = tex2D(_GrabTexture, tmp0.xy);
                tmp2.x = tmp3.x;
                tmp0.xyw = tmp2.xyz - tmp4.xyz;
                tmp1.yz = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.y = dot(tmp1.xy, tmp1.xy);
                tmp1.y = sqrt(tmp1.y);
                tmp1.y = tmp1.y * 1.25;
                tmp0.xyw = tmp1.yyy * tmp0.xyw + tmp4.xyz;
                tmp1.y = tmp1.x * 0.7142857 + -0.2142857;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.x = tmp1.x * 0.333 + tmp1.y;
                tmp1.xyz = tmp1.xxx * _Color.xyz;
                tmp1.xyz = tmp1.xyz * _Color.www;
                tmp1.xyz = tmp1.xyz * _Intensity.xxx;
                o.sv_target.xyz = tmp1.xyz * tmp0.zzz + tmp0.xyw;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/FX/FireStorm ScreenSpace NoRefraction"
	CustomEditor "ShaderForgeMaterialInspector"
}