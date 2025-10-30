Shader "SR/Slime/Body Glow" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		_Noise ("Noise", 2D) = "white" {}
		_StripeTexture ("Stripe Texture", 2D) = "white" {}
		[MaterialToggle] _StripeUV1 ("Stripe UV1", Float) = 0
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" }
		Pass {
			Name "Outline"
			Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Cull Front
			GpuProgramID 26106
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TopColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xyz = v.normal.xyz * float3(0.025, 0.025, 0.025) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target.xyz = _TopColor.xyz * float3(1.25, 1.25, 1.25);
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 114048
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float4 _Noise_ST;
			float4 _StripeTexture_ST;
			float _StripeUV1;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Noise;
			sampler2D _StripeTexture;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = _Time * float4(0.1, -0.25, -0.1, -0.1) + inp.texcoord.xyxy;
                tmp0 = tmp0 * _Noise_ST + _Noise_ST;
                tmp1 = tex2D(_Noise, tmp0.zw);
                tmp0 = tex2D(_Noise, tmp0.xy);
                tmp0.y = 1.0 - tmp1.x;
                tmp0.x = tmp0.y / tmp0.x;
                tmp0.x = saturate(1.0 - tmp0.x);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.x = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * inp.texcoord3.xyz;
                tmp1.w = dot(tmp1.xyz, tmp0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp0.x = tmp0.x * tmp1.w;
                tmp1.w = tmp1.w * tmp1.w;
                tmp1.w = min(tmp1.w, 1.0);
                tmp0.x = tmp0.x * 4.5;
                tmp0.x = floor(tmp0.x);
                tmp2.x = saturate(tmp1.y * 0.75 + 0.25);
                tmp1.w = tmp1.w + tmp2.x;
                tmp0.x = tmp0.x * 0.2 + tmp1.w;
                tmp2.xy = inp.texcoord1.xy - inp.texcoord.xy;
                tmp2.xy = _StripeUV1.xx * tmp2.xy + inp.texcoord.xy;
                tmp2.xy = tmp2.xy * _StripeTexture_ST.xy + _StripeTexture_ST.zw;
                tmp2 = tex2D(_StripeTexture, tmp2.xy);
                tmp1.w = tmp2.x * tmp2.x;
                tmp0.x = saturate(tmp0.x * tmp1.w);
                tmp2.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp2.xyz = tmp0.xxx * tmp2.xyz + _MiddleColor.xyz;
                tmp3.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + _BottomColor.xyz;
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = tmp0.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz * float3(1.25, 1.25, 1.25);
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = _WorldSpaceLightPos0.xyz * tmp0.xxx + tmp0.yzw;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 32.0;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                o.sv_target.xyz = tmp0.xyz * float3(0.1, 0.1, 0.1) + tmp2.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}