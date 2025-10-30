Shader "SR/Slime/Body Core" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3333333,0.3333333,1,1)
		_MiddleColor ("Middle Color", Color) = (0.6666667,0.6666667,1,1)
		_TopColor ("Top Color", Color) = (0.8627451,0.8627451,1,1)
		_GlowTop ("Glow Top", Color) = (1,1,0,1)
		_GlowMid ("Glow Mid", Color) = (0.67,0.67,0,1)
		_GlowBottom ("Glow Bottom", Color) = (0.33,0.33,0,1)
		_Alpha ("Alpha", Float) = 1
		_StripeTexture ("Stripe Texture", 2D) = "white" {}
		[MaterialToggle] _StripeUV1 ("Stripe UV1", Float) = 0
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "AlphaTest-10" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest-10" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 30781
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
			float4 _GlowTop;
			float4 _GlowMid;
			float4 _GlowBottom;
			float _Alpha;
			float4 _StripeTexture_ST;
			float _StripeUV1;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
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
                float4 tmp4;
                float4 tmp5;
                tmp0.xy = inp.texcoord1.xy - inp.texcoord.xy;
                tmp0.xy = _StripeUV1.xx * tmp0.xy + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * _StripeTexture_ST.xy + _StripeTexture_ST.zw;
                tmp0 = tex2D(_StripeTexture, tmp0.xy);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.yzw = tmp0.yzw * tmp1.xxx;
                tmp2.x = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp2.xxx * inp.texcoord3.xyz;
                tmp1.y = dot(tmp2.xyz, tmp1.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = 1.0 - tmp1.y;
                tmp1.z = tmp1.y * tmp1.y;
                tmp1.y = log(tmp1.y);
                tmp1.y = tmp1.y * 0.9;
                tmp1.y = exp(tmp1.y);
                tmp1.y = tmp1.y * -3.0 + 1.0;
                tmp1.z = min(tmp1.z, 1.0);
                tmp1.w = saturate(tmp2.y * 0.75 + 0.25);
                tmp1.z = tmp1.z + tmp1.w;
                tmp0.x = tmp0.x * tmp1.z;
                tmp3.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + _MiddleColor.xyz;
                tmp4.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp4.xyz = tmp0.xxx * tmp4.xyz + _BottomColor.xyz;
                tmp0.x = saturate(tmp0.x * 2.0 + -1.0);
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + tmp4.xyz;
                tmp4.xyz = tmp3.xyz * float3(0.2, 0.2, 0.2);
                tmp3.xyz = tmp3.xyz * float3(0.8, 0.8, 0.8);
                tmp1.z = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp5.xyz = tmp1.zzz * _WorldSpaceLightPos0.xyz;
                tmp0.yzw = tmp0.yzw * tmp1.xxx + tmp5.xyz;
                tmp1.x = dot(tmp2.xyz, tmp5.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.z = dot(tmp0.xyz, tmp0.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp0.yzw = tmp0.yzw * tmp1.zzz;
                tmp0.y = dot(tmp0.xyz, tmp2.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * 32.0;
                tmp0.y = exp(tmp0.y);
                tmp0.yzw = tmp0.yyy * _LightColor0.xyz;
                tmp0.yzw = tmp0.yzw * float3(0.1, 0.1, 0.1);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xzw = tmp1.xxx * _LightColor0.xyz + tmp2.xyz;
                tmp0.yzw = tmp1.xzw * tmp4.xyz + tmp0.yzw;
                tmp1.xzw = _GlowTop.xyz - _GlowMid.xyz;
                tmp1.xzw = tmp1.yyy * tmp1.xzw + _GlowMid.xyz;
                tmp2.xyz = _GlowMid.xyz - _GlowBottom.xyz;
                tmp2.xyz = tmp1.yyy * tmp2.xyz + _GlowBottom.xyz;
                tmp1.xzw = tmp1.xzw - tmp2.xyz;
                tmp1.xzw = tmp1.yyy * tmp1.xzw + tmp2.xyz;
                tmp1.xzw = tmp1.yyy + tmp1.xzw;
                tmp1.xzw = saturate(tmp1.xzw - float3(1.0, 1.0, 1.0));
                tmp2.x = _Time.y * 0.8;
                tmp2.x = sin(tmp2.x);
                tmp2.x = tmp2.x * 2.0 + -1.0;
                tmp2.x = max(tmp2.x, 0.0);
                tmp1.y = tmp1.y * tmp2.x;
                tmp1.y = max(tmp1.y, 0.0);
                tmp2.xyz = tmp1.yyy * tmp1.xzw;
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = max(tmp3.xyz, tmp2.xyz);
                tmp1.xzw = tmp1.xzw - tmp2.xyz;
                tmp1.xzw = tmp1.yyy * tmp1.xzw + tmp2.xyz;
                tmp0.x = tmp1.y * 0.2 + tmp0.x;
                tmp0.x = tmp0.x + 0.8;
                o.sv_target.w = tmp0.x * _Alpha;
                o.sv_target.xyz = tmp0.yzw + tmp1.xzw;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}