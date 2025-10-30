Shader "SR/Slime/SlimeLamp Body" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		[MaterialToggle] _UseOverride ("Use Override", Float) = 1.002941
		_CubemapOverride ("Cubemap Override", 2D) = "white" {}
		_StripeTexture ("Stripe Texture", 2D) = "white" {}
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 49066
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
			float4 _LightColor0;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float _UseOverride;
			float4 _CubemapOverride_ST;
			float4 _StripeTexture_ST;
			float _Gloss;
			float _GlossPower;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _StripeTexture;
			sampler2D _CubemapOverride;
			
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
                tmp0.xy = inp.texcoord.xy * _StripeTexture_ST.xy + _StripeTexture_ST.zw;
                tmp0 = tex2D(_StripeTexture, tmp0.xy);
                tmp0.x = saturate(tmp0.x);
                tmp0.y = _GlossPower * 16.0 + -1.0;
                tmp0.y = exp(tmp0.y);
                tmp0.z = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * _WorldSpaceLightPos0.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp0.zzz + tmp1.xyz;
                tmp0.z = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp4.xyz = tmp0.zzz * inp.texcoord2.xyz;
                tmp0.z = saturate(-inp.texcoord2.y * tmp0.z + 0.5);
                tmp0.z = tmp0.z * 0.85 + 0.15;
                tmp0.w = dot(-tmp3.xyz, tmp4.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp5.xyz = tmp4.xyz * -tmp0.www + -tmp3.xyz;
                tmp0.w = dot(tmp4.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.z = tmp0.w + tmp0.z;
                tmp0.w = dot(tmp5.xyz, tmp1.xyz);
                tmp1.x = dot(tmp4.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp0.y * _Gloss;
                tmp0.z = saturate(tmp0.x * tmp0.z + tmp0.y);
                tmp1.yzw = tmp0.yyy * _LightColor0.xyz;
                tmp0.y = tmp0.z * 0.25 + 0.25;
                tmp0.w = 1.0 - tmp0.y;
                tmp3.xy = tmp4.yy * unity_MatrixV._m01_m11;
                tmp3.xy = unity_MatrixV._m00_m10 * tmp4.xx + tmp3.xy;
                tmp3.xy = unity_MatrixV._m02_m12 * tmp4.zz + tmp3.xy;
                tmp3.xy = tmp3.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp3.xy = tmp3.xy * _CubemapOverride_ST.xy + _CubemapOverride_ST.zw;
                tmp3 = tex2D(_CubemapOverride, tmp3.xy);
                tmp5.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp5.xyz * tmp0.www + float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp0.yyy * tmp3.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp6.xyz = tmp6.xyz + tmp6.xyz;
                tmp3.xyz = saturate(tmp3.xyz ? tmp5.xyz : tmp6.xyz);
                tmp0.xyw = tmp0.xxx + tmp3.xyz;
                tmp0.xyw = tmp0.xyw - float3(1.0, 1.0, 1.0);
                tmp3.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp3.xyz = tmp0.zzz * tmp3.xyz + _MiddleColor.xyz;
                tmp5.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp5.xyz = tmp0.zzz * tmp5.xyz + _BottomColor.xyz;
                tmp0.z = tmp0.z * 2.0 + -1.0;
                tmp0 = max(tmp0, float4(0.0, 0.0, 0.0, 0.0));
                tmp3.xyz = tmp3.xyz - tmp5.xyz;
                tmp3.xyz = tmp0.zzz * tmp3.xyz + tmp5.xyz;
                tmp0.xyz = -tmp3.xyz * float3(1.1, 1.1, 1.1) + tmp0.xyw;
                tmp5.xyz = tmp3.xyz * float3(1.1, 1.1, 1.1);
                tmp3.xyz = tmp3.xyz * float3(0.2, 0.2, 0.2);
                tmp0.xyz = _UseOverride.xxx * tmp0.xyz + tmp5.xyz;
                tmp0.xyz = tmp1.yzw * _Gloss.xxx + tmp0.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.yzw = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp4.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 32.0;
                tmp0.w = exp(tmp0.w);
                tmp1.yzw = tmp0.www * _LightColor0.xyz;
                tmp1.yzw = tmp1.yzw * float3(0.1, 0.1, 0.1);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = tmp1.xxx * _LightColor0.xyz + tmp2.xyz;
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.yzw;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}