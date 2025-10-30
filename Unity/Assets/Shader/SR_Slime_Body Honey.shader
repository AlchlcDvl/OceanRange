Shader "SR/Slime/Body Honey" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		[MaterialToggle] _UseOverride ("Use Override", Float) = 0.7294118
		_CubemapOverride ("Cubemap Override", 2D) = "white" {}
		_StripeTexture ("Stripe Texture", 2D) = "white" {}
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_Normal ("Normal", 2D) = "bump" {}
		[MaterialToggle] _StripeUV1 ("Stripe UV1", Float) = 0
		_OverrideBlend ("Override Blend", Range(0, 1)) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 65406
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
				float3 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
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
			float4 _Normal_ST;
			float _StripeUV1;
			float _OverrideBlend;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _StripeTexture;
			sampler2D _CubemapOverride;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord4.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord5.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.xy = inp.texcoord1.xy - inp.texcoord.xy;
                tmp0.xy = _StripeUV1.xx * tmp0.xy + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _StripeTexture_ST.xy + _StripeTexture_ST.zw;
                tmp0 = tex2D(_StripeTexture, tmp0.xy);
                tmp0.yz = _Time.yy * float2(0.05, 0.125) + inp.texcoord.xy;
                tmp0.yz = tmp0.yz * _Normal_ST.xy + _Normal_ST.zw;
                tmp1 = tex2D(_Normal, tmp0.yz);
                tmp1.x = tmp1.w * tmp1.x;
                tmp0.yz = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.xy = tmp1.xy + tmp1.xy;
                tmp0.y = dot(tmp0.xy, tmp0.xy);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp1.z = sqrt(tmp0.y);
                tmp0.yzw = tmp1.xyz - float3(1.0, 1.0, 1.0);
                tmp1.x = 1.0 - inp.texcoord.y;
                tmp1.x = tmp1.x + tmp1.x;
                tmp0.yzw = tmp1.xxx * tmp0.yzw + float3(0.0, 0.0, 1.0);
                tmp1.xyz = tmp0.zzz * inp.texcoord5.xyz;
                tmp1.xyz = tmp0.yyy * inp.texcoord4.xyz + tmp1.xyz;
                tmp0.y = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp2.xyz = tmp0.yyy * inp.texcoord3.xyz;
                tmp0.yzw = tmp0.www * tmp2.xyz + tmp1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp1.xyz;
                tmp2.w = dot(-tmp3.xyz, tmp0.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp4.xyz = tmp0.yzw * -tmp2.www + -tmp3.xyz;
                tmp2.w = dot(tmp0.xyz, tmp3.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp2.w = tmp2.w * tmp2.w;
                tmp2.w = min(tmp2.w, 1.0);
                tmp2.w = tmp2.w + inp.texcoord.y;
                tmp3.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp3.xyz = tmp3.xxx * _WorldSpaceLightPos0.xyz;
                tmp3.w = dot(tmp4.xyz, tmp3.xyz);
                tmp3.w = max(tmp3.w, 0.0);
                tmp3.w = log(tmp3.w);
                tmp4.x = _GlossPower * 16.0 + -1.0;
                tmp4.x = exp(tmp4.x);
                tmp3.w = tmp3.w * tmp4.x;
                tmp3.w = exp(tmp3.w);
                tmp3.w = tmp3.w * _Gloss;
                tmp0.x = saturate(tmp0.x * tmp2.w + tmp3.w);
                tmp4.xyz = tmp3.www * _LightColor0.xyz;
                tmp2.w = 1.0 - tmp0.x;
                tmp5.xy = tmp2.yy * unity_MatrixV._m01_m11;
                tmp2.xy = unity_MatrixV._m00_m10 * tmp2.xx + tmp5.xy;
                tmp2.xy = unity_MatrixV._m02_m12 * tmp2.zz + tmp2.xy;
                tmp2.xy = tmp2.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp2.xy = tmp2.xy * _CubemapOverride_ST.xy + _CubemapOverride_ST.zw;
                tmp5 = tex2D(_CubemapOverride, tmp2.xy);
                tmp2.xyz = tmp5.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp2.xyz * tmp2.www + float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp5.xyz + tmp5.xyz;
                tmp6.xyz = tmp0.xxx * tmp6.xyz;
                tmp5.xyz = tmp5.xyz > float3(0.5, 0.5, 0.5);
                tmp2.w = tmp5.w * _OverrideBlend;
                tmp2.xyz = saturate(tmp5.xyz ? tmp2.xyz : tmp6.xyz);
                tmp5.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp5.xyz = tmp0.xxx * tmp5.xyz + _MiddleColor.xyz;
                tmp6.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp6.xyz = tmp0.xxx * tmp6.xyz + _BottomColor.xyz;
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp5.xyz = tmp5.xyz - tmp6.xyz;
                tmp5.xyz = tmp0.xxx * tmp5.xyz + tmp6.xyz;
                tmp2.xyz = -tmp5.xyz * float3(0.8, 0.8, 0.8) + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.www;
                tmp6.xyz = tmp5.xyz * float3(0.8, 0.8, 0.8);
                tmp5.xyz = tmp5.xyz * float3(0.2, 0.2, 0.2);
                tmp2.xyz = _UseOverride.xxx * tmp2.xyz + tmp6.xyz;
                tmp2.xyz = tmp4.xyz * _Gloss.xxx + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp3.xyz;
                tmp0.x = dot(tmp0.xyz, tmp3.xyz);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.y = dot(tmp1.xyz, tmp0.xyz);
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * 32.0;
                tmp0.y = exp(tmp0.y);
                tmp0.yzw = tmp0.yyy * _LightColor0.xyz;
                tmp0.yzw = tmp0.yzw * float3(0.1, 0.1, 0.1);
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xxx * _LightColor0.xyz + tmp1.xyz;
                tmp0.xyz = tmp1.xyz * tmp5.xyz + tmp0.yzw;
                o.sv_target.xyz = tmp2.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}