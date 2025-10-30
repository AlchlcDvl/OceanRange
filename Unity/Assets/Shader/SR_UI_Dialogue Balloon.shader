Shader "SR/UI/Dialogue Balloon" {
	Properties {
		_MainTex ("MainTex", 2D) = "black" {}
		_Color ("Color", Color) = (0.9490197,0.9490197,0.9490197,1)
		_Transition ("Transition", Range(0, 1)) = 1
		_Noise ("Noise", 2D) = "black" {}
		_Pattern ("Pattern", 2D) = "gray" {}
		_UnscaledTime ("Unscaled Time", Float) = 0
		_PatternSpeed ("Pattern Speed", Float) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
	}
	SubShader {
		Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Cull Off
			Stencil {
				Ref 128
			}
			GpuProgramID 34705
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
			float4 _MainTex_ST;
			float4 _Color;
			float _Transition;
			float4 _Noise_ST;
			float4 _Pattern_ST;
			float _UnscaledTime;
			float _PatternSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Pattern;
			sampler2D _Noise;
			sampler2D _MainTex;
			
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
                tmp0.x = _UnscaledTime + _Time.y;
                tmp0.y = tmp0.x * 0.25;
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.y * 4.0;
                tmp0.z = floor(tmp0.y);
                tmp0.y = frac(tmp0.y);
                tmp0.w = tmp0.z + 1.0;
                tmp1.x = tmp0.w * 0.5;
                tmp1.y = floor(tmp1.x);
                tmp1.x = -tmp1.y * 2.0 + tmp0.w;
                tmp0.w = sin(tmp0.x);
                tmp0.x = tmp0.x * _PatternSpeed;
                tmp1.zw = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp2.xy = tmp0.ww * float2(-0.2, 0.1) + tmp1.zw;
                tmp3.yz = tmp1.zw * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.xy = tmp1.xy + tmp2.xy;
                tmp1.xy = tmp1.xy * _Noise_ST.xy;
                tmp1.xy = tmp1.xy * float2(0.5, 0.5) + _Noise_ST.zw;
                tmp1 = tex2D(_Noise, tmp1.xy);
                tmp0.w = tmp0.z * 0.5;
                tmp4.y = floor(tmp0.w);
                tmp4.x = -tmp4.y * 2.0 + tmp0.z;
                tmp0.zw = tmp2.xy + tmp4.xy;
                tmp0.zw = tmp0.zw * _Noise_ST.xy;
                tmp0.zw = tmp0.zw * float2(0.5, 0.5) + _Noise_ST.zw;
                tmp2 = tex2D(_Noise, tmp0.zw);
                tmp0.zw = tmp1.xy - tmp2.xy;
                tmp1.x = tmp0.y * tmp0.y;
                tmp0.y = -tmp0.y * 2.0 + 3.0;
                tmp0.y = tmp0.y * tmp1.x;
                tmp0.y = frac(tmp0.y);
                tmp0.yz = tmp0.yy * tmp0.zw + tmp2.xy;
                tmp0.yz = tmp0.yz * float2(0.015, 0.015) + inp.texcoord.xy;
                tmp0.yz = tmp0.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.yz);
                tmp0.y = _ScreenParams.x / _ScreenParams.y;
                tmp3.x = tmp0.y * tmp3.y;
                tmp0.xy = tmp0.xx * float2(-0.02, 0.02) + tmp3.xz;
                tmp0.xy = tmp0.xy * _Pattern_ST.xy + _Pattern_ST.zw;
                tmp0 = tex2D(_Pattern, tmp0.xy);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp1.y * tmp0.x + 0.5;
                tmp0.x = tmp0.x * 0.2 + 0.4;
                tmp0.y = 1.0 - tmp0.x;
                tmp2.xyz = tmp1.xxx * _Color.xyz;
                tmp3.xyz = tmp2.xyz * inp.color.xyz + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp2.xyz * inp.color.xyz;
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.yzw = -tmp3.xyz * tmp0.yyy + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp0.xxx * tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                o.sv_target.xyz = saturate(tmp2.xyz ? tmp0.yzw : tmp3.xyz);
                tmp0.x = inp.color.w * _Color.w;
                tmp0.x = tmp0.x * _Transition;
                tmp0.x = tmp0.x * -0.98 + 0.98;
                tmp0.x = tmp1.z - tmp0.x;
                tmp0.x = saturate(tmp0.x * 50.0);
                o.sv_target.w = tmp0.x * tmp1.w;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}