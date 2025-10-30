Shader "SR/Slime/Body" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		[MaterialToggle] _UseOverride ("Use Override", Float) = 0.7294118
		_CubemapOverride ("Cubemap Override", 2D) = "white" {}
		_OverrideBlend ("Override Blend", Range(0, 1)) = 1
		_StripeTexture ("Stripe Texture", 2D) = "white" {}
		[MaterialToggle] _StripeUV1 ("Stripe UV1", Float) = 0
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_Normal ("Normal", 2D) = "bump" {}
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 38229
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
				float4 color : COLOR0;
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
			float _OverrideBlend;
			float _StripeUV1;
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
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.x = inp.texcoord.y - 0.5;
                tmp0.x = -tmp0.x * 2.0 + 1.0;
                tmp0.y = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * inp.texcoord3.xyz;
                tmp1.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.xyz = tmp1.yyy * inp.texcoord5.xyz;
                tmp2.xyz = tmp1.xxx * inp.texcoord4.xyz + tmp2.xyz;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = sqrt(tmp1.x);
                tmp0.yzw = tmp1.xxx * tmp0.yzw + tmp2.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.x = saturate(tmp0.z * 0.75 + 0.25);
                tmp1.y = 1.0 - tmp1.x;
                tmp1.x = dot(tmp1.xy, inp.texcoord.xy);
                tmp0.x = -tmp0.x * tmp1.y + 1.0;
                tmp1.y = inp.texcoord.y > 0.5;
                tmp0.x = saturate(tmp1.y ? tmp0.x : tmp1.x);
                tmp0.x = tmp0.x * 0.85 + 0.15;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp1.xyz;
                tmp2.w = dot(tmp0.xyz, tmp2.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp2.w = tmp2.w * tmp2.w;
                tmp2.w = min(tmp2.w, 1.0);
                tmp0.x = tmp0.x + tmp2.w;
                tmp3.xy = inp.texcoord1.xy - inp.texcoord.xy;
                tmp3.xy = _StripeUV1.xx * tmp3.xy + inp.texcoord.xy;
                tmp3.xy = tmp3.xy * _StripeTexture_ST.xy + _StripeTexture_ST.zw;
                tmp3 = tex2D(_StripeTexture, tmp3.xy);
                tmp3.x = saturate(tmp3.x);
                tmp2.w = dot(-tmp2.xyz, tmp0.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp2.xyz = tmp0.yzw * -tmp2.www + -tmp2.xyz;
                tmp2.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.yzw = tmp2.www * _WorldSpaceLightPos0.xyz;
                tmp2.x = dot(tmp2.xyz, tmp3.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.x = log(tmp2.x);
                tmp2.y = _GlossPower * 16.0 + -1.0;
                tmp2.y = exp(tmp2.y);
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.x = exp(tmp2.x);
                tmp2.x = tmp2.x * _Gloss;
                tmp0.x = tmp3.x * tmp0.x + tmp2.x;
                tmp2.xyz = tmp2.xxx * _LightColor0.xyz;
                tmp0.x = inp.color.z * -0.5 + tmp0.x;
                tmp0.x = saturate(tmp0.x + 0.5);
                tmp2.w = tmp0.x * 0.25 + 0.25;
                tmp4.x = 1.0 - tmp2.w;
                tmp4.yz = tmp0.zz * unity_MatrixV._m01_m11;
                tmp4.yz = unity_MatrixV._m00_m10 * tmp0.yy + tmp4.yz;
                tmp4.yz = unity_MatrixV._m02_m12 * tmp0.ww + tmp4.yz;
                tmp4.yz = tmp4.yz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp4.yz = tmp4.yz * _CubemapOverride_ST.xy + _CubemapOverride_ST.zw;
                tmp5 = tex2D(_CubemapOverride, tmp4.yz);
                tmp4.yzw = tmp5.xyz - float3(0.5, 0.5, 0.5);
                tmp4.yzw = -tmp4.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = -tmp4.yzw * tmp4.xxx + float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp2.www * tmp5.xyz;
                tmp6.xyz = tmp6.xyz + tmp6.xyz;
                tmp5.xyz = tmp5.xyz > float3(0.5, 0.5, 0.5);
                tmp2.w = tmp5.w * _OverrideBlend;
                tmp4.xyz = saturate(tmp5.xyz ? tmp4.xyz : tmp6.xyz);
                tmp4.xyz = tmp3.xxx + tmp4.xyz;
                tmp4.xyz = tmp4.xyz - float3(1.0, 1.0, 1.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.0, 0.0, 0.0));
                tmp5.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp5.xyz = tmp0.xxx * tmp5.xyz + _MiddleColor.xyz;
                tmp6.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp6.xyz = tmp0.xxx * tmp6.xyz + _BottomColor.xyz;
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp5.xyz = tmp5.xyz - tmp6.xyz;
                tmp5.xyz = tmp0.xxx * tmp5.xyz + tmp6.xyz;
                tmp6.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp7.xy = inp.color.zz * float2(-0.1784314, -0.1784314) + float2(0.1784314, 0.6784314);
                tmp0.x = -tmp7.x * 2.0 + 1.0;
                tmp6.xyz = -tmp0.xxx * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp0.x = tmp7.y + tmp7.y;
                tmp3.x = tmp7.y > 0.5;
                tmp5.xyz = tmp5.xyz * tmp0.xxx;
                tmp5.xyz = saturate(tmp3.xxx ? tmp6.xyz : tmp5.xyz);
                tmp4.xyz = -tmp5.xyz * float3(0.8, 0.8, 0.8) + tmp4.xyz;
                tmp4.xyz = tmp2.www * tmp4.xyz;
                tmp6.xyz = tmp5.xyz * float3(0.8, 0.8, 0.8);
                tmp5.xyz = tmp5.xyz * float3(0.2, 0.2, 0.2);
                tmp4.xyz = _UseOverride.xxx * tmp4.xyz + tmp6.xyz;
                tmp2.xyz = tmp2.xyz * _Gloss.xxx + tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp3.yzw;
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