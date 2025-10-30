Shader "SR/FX/Projector BuildSite NoDepth" {
	Properties {
		_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
		_Pattern ("Pattern", 2D) = "black" {}
		_PatternColor ("Pattern Color", Color) = (1,1,1,1)
		_MainTex ("MainTex", 2D) = "white" {}
		_Noise ("Noise", 2D) = "black" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+100" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+100" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 56325
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _MainTex_ST;
			float4 _TintColor;
			float4 _Pattern_ST;
			float4 _PatternColor;
			float4 _Noise_ST;
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
                tmp0.xyz = v.vertex.xyz - float3(-0.0, -0.0, 0.2);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp0.x = tmp0.x * 1.5;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 4.0;
                tmp0.x = floor(tmp0.x);
                tmp0.y = tmp0.x * 0.5;
                tmp1.y = floor(tmp0.y);
                tmp1.x = -tmp1.y * 2.0 + tmp0.x;
                tmp0.xy = tmp1.xy + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _Noise_ST.xy;
                tmp0.xy = tmp0.xy * float2(0.5, 0.5) + _Noise_ST.zw;
                tmp0 = tex2D(_Noise, tmp0.xy);
                tmp0.xy = tmp0.xy * float2(0.01, 0.01) + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp1.xy = inp.texcoord1.xz * _Pattern_ST.xy;
                tmp1.xy = tmp1.xy * float2(0.25, 0.25) + _Pattern_ST.zw;
                tmp1 = tex2D(_Pattern, tmp1.xy);
                tmp1.xyz = tmp1.xyz * _PatternColor.xyz;
                tmp0.xyz = tmp1.xyz * _PatternColor.www + tmp0.xyz;
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.w = tmp0.w * _TintColor.w;
                tmp1.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp3.xyz;
                tmp1.w = dot(inp.texcoord2.xyz, tmp3.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.w = tmp1.w * tmp1.w;
                tmp3.x = tmp1.w * tmp2.w;
                tmp2.w = tmp2.w * tmp2.w;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = tmp1.w * -3.333333 + 1.0;
                o.sv_target.w = tmp0.w * tmp1.w;
                tmp0.w = tmp3.x * -0.2 + 0.5;
                tmp1.w = 1.0 - tmp0.w;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp2.xyz = -tmp2.xyz * tmp1.www + float3(1.0, 1.0, 1.0);
                tmp0.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp0.xyz);
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                o.sv_target.xyz = tmp0.xyz * _TintColor.xyz;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}