Shader "SR/Slime/Plort" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		[MaterialToggle] _ToggleOverride ("Toggle Override", Float) = 0.9117647
		_CubemapOverride ("Cubemap Override", 2D) = "white" {}
		_DecalTexture ("Decal Texture", 2D) = "white" {}
		_StripeSpeed ("Stripe Speed", Float) = 0
		_OverrideBlend ("Override Blend", Range(0, 1)) = 1
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 28561
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float _ToggleOverride;
			float4 _CubemapOverride_ST;
			float4 _DecalTexture_ST;
			float _StripeSpeed;
			float _OverrideBlend;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DecalTexture;
			sampler2D _CubemapOverride;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _Time.y * 5.0;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = abs(tmp0.x) * 0.05;
                tmp0.xyz = tmp0.xxx * v.normal.xyz + v.vertex.xyz;
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
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp0.w = dot(-tmp0.xyz, tmp1.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp2.xyz = tmp1.xyz * -tmp0.www + -tmp0.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = dot(tmp1.xyz, tmp2.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * 128.0;
                tmp0.y = exp(tmp0.y);
                tmp0.z = tmp0.x + inp.texcoord.y;
                tmp0.x = rsqrt(tmp0.x);
                tmp0.x = 1.0 / tmp0.x;
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.z = _Time.y * 5.0;
                tmp0.z = sin(tmp0.z);
                tmp0.z = tmp0.z + tmp0.z;
                tmp0.x = tmp0.x * -abs(tmp0.z) + abs(tmp0.z);
                tmp0.x = tmp0.x * 0.333;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = tmp0.x * 0.5 + tmp0.y;
                tmp2.y = _StripeSpeed * _Time.y;
                tmp2.x = 0.0;
                tmp0.yz = tmp2.xy + inp.texcoord.xy;
                tmp0.yz = tmp0.yz * _DecalTexture_ST.xy + _DecalTexture_ST.zw;
                tmp2 = tex2D(_DecalTexture, tmp0.yz);
                tmp0.x = tmp0.x * tmp2.x;
                tmp0.y = tmp2.x * 0.334 + 0.333;
                tmp2.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp2.xyz = tmp0.xxx * tmp2.xyz + _MiddleColor.xyz;
                tmp3.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + _BottomColor.xyz;
                tmp0.x = saturate(tmp0.x * 2.0 + -1.0);
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp0.xzw = tmp0.xxx * tmp2.xyz + tmp3.xyz;
                tmp1.yw = tmp1.yy * unity_MatrixV._m01_m11;
                tmp1.xy = unity_MatrixV._m00_m10 * tmp1.xx + tmp1.yw;
                tmp1.xy = unity_MatrixV._m02_m12 * tmp1.zz + tmp1.xy;
                tmp1.xy = tmp1.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp1.xy = tmp1.xy * _CubemapOverride_ST.xy + _CubemapOverride_ST.zw;
                tmp1 = tex2D(_CubemapOverride, tmp1.xy);
                tmp2.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp0.yyy * tmp1.xyz;
                tmp0.y = 1.0 - tmp0.y;
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = -tmp3.xyz * tmp0.yyy + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp2.xyz ? tmp3.xyz : tmp1.xyz);
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + -tmp0.xzw;
                tmp1.xyz = tmp1.xyz * _OverrideBlend.xxx;
                o.sv_target.xyz = _ToggleOverride.xxx * tmp1.xyz + tmp0.xzw;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 85816
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
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
                tmp0.x = _Time.y * 5.0;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = abs(tmp0.x) * 0.05;
                tmp0.xyz = tmp0.xxx * v.normal.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}