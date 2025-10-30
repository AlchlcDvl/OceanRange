Shader "SR/Slime/Body Puddle" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		[MaterialToggle] _UseOverride ("Use Override", Float) = 0.7294118
		_StripeTexture ("Stripe Texture", 2D) = "white" {}
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_VertexNoise ("Vertex Noise", 2D) = "white" {}
		_VertexOffset ("Vertex Offset", Float) = 0.25
		_OverrideBlend ("Override Blend", Range(0, 1)) = 0
		_CubemapOverride ("Cubemap Override", 2D) = "white" {}
		_StripeSpeed ("Stripe Speed", Float) = 0
		_StripeBoost ("Stripe Boost", Float) = 0
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 49871
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
			float4 _VertexNoise_ST;
			float _VertexOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float _UseOverride;
			float4 _StripeTexture_ST;
			float _Gloss;
			float _GlossPower;
			float _OverrideBlend;
			float4 _CubemapOverride_ST;
			float _StripeSpeed;
			float _StripeBoost;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _VertexNoise;
			// Texture params for Fragment Shader
			sampler2D _StripeTexture;
			sampler2D _CubemapOverride;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.yy * unity_ObjectToWorld._m21_m01;
                tmp0.xy = unity_ObjectToWorld._m20_m00 * v.vertex.xx + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m22_m02 * v.vertex.zz + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m23_m03 * v.vertex.ww + tmp0.xy;
                tmp0.xy = _Time.yy * float2(0.1, 0.1) + tmp0.xy;
                tmp0.xy = tmp0.xy * _VertexNoise_ST.xy + _VertexNoise_ST.zw;
                tmp0 = tex2Dlod(_VertexNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.w = saturate(v.texcoord.y * -4.0 + 1.8);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.normal.xyz * float3(1.0, 0.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _VertexOffset.xxx + v.vertex.xyz;
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
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                tmp0.xy = inp.texcoord1.xz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0.xy = _Time.yy * float2(0.05, 0.05) + tmp0.xy;
                tmp0.xy = tmp0.xy * _CubemapOverride_ST.xy + _CubemapOverride_ST.zw;
                tmp0 = tex2D(_CubemapOverride, tmp0.xy);
                tmp0.xyz = tmp0.xyz * _BottomColor.xyz;
                tmp1.y = _StripeSpeed * _Time.y;
                tmp1.x = 0.0;
                tmp1.xy = tmp1.xy + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _StripeTexture_ST.xy + _StripeTexture_ST.zw;
                tmp1 = tex2D(_StripeTexture, tmp1.xy);
                tmp0.w = _GlossPower * 16.0 + -1.0;
                tmp0.w = exp(tmp0.w);
                tmp1.y = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.y = rsqrt(tmp1.y);
                tmp1.yzw = tmp1.yyy * _WorldSpaceLightPos0.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.www + tmp1.yzw;
                tmp2.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp4.xyz = tmp2.www * inp.texcoord2.xyz;
                tmp2.w = dot(-tmp3.xyz, tmp4.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp5.xyz = tmp4.xyz * -tmp2.www + -tmp3.xyz;
                tmp2.w = dot(tmp4.xyz, tmp3.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp3.x = dot(tmp5.xyz, tmp1.xyz);
                tmp1.y = dot(tmp4.xyz, tmp1.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.z = max(tmp3.x, 0.0);
                tmp1.z = log(tmp1.z);
                tmp0.w = tmp0.w * tmp1.z;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _Gloss;
                tmp1.z = tmp2.w * tmp2.w;
                tmp1.w = min(tmp1.z, 1.0);
                tmp1.z = tmp1.z * tmp1.z;
                tmp1.z = tmp1.z * tmp2.w;
                tmp2.w = saturate(tmp4.y * 0.375 + -0.125);
                tmp1.w = tmp1.w + tmp2.w;
                tmp1.w = tmp1.x * tmp1.w + tmp0.w;
                tmp1.x = _StripeBoost * tmp1.x + tmp1.w;
                tmp1.x = saturate(tmp1.z * 0.5 + tmp1.x);
                tmp3.xyz = tmp0.www * _LightColor0.xyz;
                tmp5.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp5.xyz = tmp1.xxx * tmp5.xyz + _MiddleColor.xyz;
                tmp6.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp6.xyz = tmp1.xxx * tmp6.xyz + _BottomColor.xyz;
                tmp0.w = tmp1.x * 2.0 + -1.0;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xzw = tmp5.xyz - tmp6.xyz;
                tmp1.xzw = tmp0.www * tmp1.xzw + tmp6.xyz;
                tmp0.xyz = saturate(tmp0.xyz * float3(0.25, 0.25, 0.25) + tmp1.xzw);
                tmp0.xyz = -tmp1.xzw * float3(0.8, 0.8, 0.8) + tmp0.xyz;
                tmp5.xyz = tmp1.xzw * float3(0.8, 0.8, 0.8);
                tmp1.xzw = tmp1.xzw * float3(0.2, 0.2, 0.2);
                tmp0.xyz = _UseOverride.xxx * tmp0.xyz + tmp5.xyz;
                tmp0.xyz = tmp3.xyz * _Gloss.xxx + tmp0.xyz;
                tmp3.xy = tmp4.yy * unity_MatrixV._m01_m11;
                tmp3.xy = unity_MatrixV._m00_m10 * tmp4.xx + tmp3.xy;
                tmp3.xy = unity_MatrixV._m02_m12 * tmp4.zz + tmp3.xy;
                tmp3.xy = tmp3.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp3.xy = tmp3.xy * _CubemapOverride_ST.xy + _CubemapOverride_ST.zw;
                tmp3 = tex2D(_CubemapOverride, tmp3.xy);
                tmp3.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.w = tmp3.w * _OverrideBlend;
                tmp0.xyz = tmp0.www * tmp3.xyz + tmp0.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp2.xyz, tmp4.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 32.0;
                tmp0.w = exp(tmp0.w);
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.1, 0.1, 0.1);
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp3.xyz = tmp1.yyy * _LightColor0.xyz + tmp3.xyz;
                tmp1.xyz = tmp3.xyz * tmp1.xzw + tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 0.4;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 111690
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _VertexNoise_ST;
			float _VertexOffset;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _VertexNoise;
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.yy * unity_ObjectToWorld._m21_m01;
                tmp0.xy = unity_ObjectToWorld._m20_m00 * v.vertex.xx + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m22_m02 * v.vertex.zz + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m23_m03 * v.vertex.ww + tmp0.xy;
                tmp0.xy = _Time.yy * float2(0.1, 0.1) + tmp0.xy;
                tmp0.xy = tmp0.xy * _VertexNoise_ST.xy + _VertexNoise_ST.zw;
                tmp0 = tex2Dlod(_VertexNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.w = saturate(v.texcoord.y * -4.0 + 1.8);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.normal.xyz * float3(1.0, 0.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _VertexOffset.xxx + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord1.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
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