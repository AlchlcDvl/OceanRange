Shader "SR/AMP/Slime/Body/MatCap Normal Stripe" {
	Properties {
		_LightingUVHorizontalAdjust ("Lighting UV Horizontal Adjust", Range(0, 1)) = 0
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_BodyLightingContribution ("Body Lighting Contribution", Range(0, 1)) = 1
		_LightingUVContribution ("Lighting UV Contribution", Range(0, 1)) = 1
		[Toggle] _UseOverride ("Enable Matcap Override", Float) = 0
		_Gloss ("Gloss", Range(0, 2)) = 0
		[NoScaleOffset] _CubemapOverride ("Matcap Override", 2D) = "black" {}
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		[Toggle] _OverrideAlphaUV1 ("Override Alpha UV1", Float) = 0
		_OverrideBlend ("Override Blend", Range(0, 1)) = 1
		[NoScaleOffset] _StripeTexture ("Stripe Texture", 2D) = "white" {}
		[Toggle] _StripeUV1 ("Stripe UV1", Float) = 0
		_StripeRemap1 ("Stripe Remap (Min/Max)(Min/Max)", Vector) = (0,1,0,1)
		[NoScaleOffset] _Stripe2Texture ("Stripe2 Texture", 2D) = "white" {}
		[Toggle] _Stripe2UV1 ("Stripe2 UV1", Float) = 0
		_StripeRemap2 ("Stripe2 Remap (Min/Max)(Min/Max)", Vector) = (0,1,0,1)
		_StripeSpeed ("Stripe Speed Y", Float) = 0
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		_NormalPanSpeed ("Normal Pan Speed", Vector) = (0,0,0,0)
		[Toggle] _NormalSmoothTop ("Normal Smooth Top", Float) = 0
		[Toggle] _NormalUV1 ("Normal UV1", Float) = 0
		[NoScaleOffset] [Normal] _Normal ("Normal", 2D) = "bump" {}
		[HideInInspector] _texcoord2 ("", 2D) = "white" {}
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 28718
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord_ST;
			float4 _texcoord2_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _UseOverride;
			float4 _BottomColor;
			float4 _MiddleColor;
			float _NormalSmoothTop;
			float2 _NormalPanSpeed;
			float _NormalUV1;
			float _Gloss;
			float _GlossPower;
			float _StripeSpeed;
			float _StripeUV1;
			float4 _StripeRemap1;
			float _Stripe2UV1;
			float4 _StripeRemap2;
			float _LightingUVHorizontalAdjust;
			float _LightingUVContribution;
			float _BodyLightingContribution;
			float4 _TopColor;
			float _OverrideAlphaUV1;
			float _OverrideBlend;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _StripeTexture;
			sampler2D _Stripe2Texture;
			sampler2D _CubemapOverride;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord.zw = v.texcoord1.xy * _texcoord2_ST.xy + _texcoord2_ST.zw;
                o.texcoord1.w = tmp0.x;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = tmp1.xyz * tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx + -tmp3.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord1.y = tmp3.x;
                o.texcoord1.x = tmp2.z;
                o.texcoord1.z = tmp1.y;
                o.texcoord2.x = tmp2.x;
                o.texcoord3.x = tmp2.y;
                o.texcoord2.z = tmp1.z;
                o.texcoord3.z = tmp1.x;
                o.texcoord2.w = tmp0.y;
                o.texcoord3.w = tmp0.z;
                o.texcoord2.y = tmp3.y;
                o.texcoord3.y = tmp3.z;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
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
                tmp0.x = 0.0;
                tmp0.y = _StripeSpeed * _Time.y;
                tmp0.zw = inp.texcoord.zw - inp.texcoord.xy;
                tmp1.xy = _StripeUV1.xx * tmp0.zw + inp.texcoord.xy;
                tmp1.xy = tmp0.xy + tmp1.xy;
                tmp1 = tex2D(_StripeTexture, tmp1.xy);
                tmp1.x = tmp1.x - _StripeRemap1.x;
                tmp1.yz = _StripeRemap1.wy - _StripeRemap1.zx;
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.x = tmp1.x / tmp1.z;
                tmp1.x = saturate(tmp1.x + _StripeRemap1.z);
                tmp1.yz = _Stripe2UV1.xx * tmp0.zw + inp.texcoord.xy;
                tmp0.xy = tmp0.xy + tmp1.yz;
                tmp2 = tex2D(_Stripe2Texture, tmp0.xy);
                tmp0.x = tmp2.x - _StripeRemap2.x;
                tmp1.yz = _StripeRemap2.wy - _StripeRemap2.zx;
                tmp0.x = tmp0.x * tmp1.y;
                tmp0.x = tmp0.x / tmp1.z;
                tmp0.x = saturate(tmp0.x + _StripeRemap2.z);
                tmp0.y = tmp0.x * tmp1.x;
                tmp1.yzw = inp.texcoord.yxy - float3(1.0, 0.5, -0.0);
                tmp1.z = dot(tmp1.xy, tmp1.xy);
                tmp1.z = sqrt(tmp1.z);
                tmp1.z = tmp1.z - 0.25;
                tmp1.yz = saturate(tmp1.yz * float2(-1.333333, 1.333333));
                tmp1.w = tmp1.z * -2.0 + 3.0;
                tmp1.z = tmp1.z * tmp1.z;
                tmp1.z = tmp1.w * tmp1.z + -inp.texcoord.y;
                tmp1.z = _LightingUVHorizontalAdjust * tmp1.z + inp.texcoord.y;
                tmp1.z = tmp1.z - 0.5;
                tmp1.w = tmp1.z * _LightingUVContribution;
                tmp1.z = _LightingUVContribution * tmp1.z + 0.5;
                tmp1.w = -tmp1.w * 2.0 + 1.0;
                tmp2.x = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp2.x;
                tmp2.xy = _NormalUV1.xx * tmp0.zw + inp.texcoord.xy;
                tmp0.zw = _OverrideAlphaUV1.xx * tmp0.zw + inp.texcoord.xy;
                tmp3 = tex2D(_CubemapOverride, tmp0.zw);
                tmp0.z = tmp3.w * _OverrideBlend;
                tmp2.xy = _Time.yy * _NormalPanSpeed + tmp2.xy;
                tmp2 = tex2D(_Normal, tmp2.xy);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.zw = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xy = tmp2.xy + tmp2.xy;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp3.z = sqrt(tmp0.w);
                tmp2.xyz = tmp3.xyz - float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp3.xyz - float3(1.0, 1.0, -0.0);
                tmp2.xyz = tmp1.yyy * tmp2.xyz + float3(0.0, 0.0, 1.0);
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = _NormalSmoothTop.xxx * tmp2.xyz + tmp3.xyz;
                tmp3.y = dot(inp.texcoord2.xyz, tmp2.xyz);
                tmp3.x = dot(inp.texcoord1.xyz, tmp2.xyz);
                tmp3.z = dot(inp.texcoord3.xyz, tmp2.xyz);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.y = tmp3.y * tmp0.w + 1.0;
                tmp2.xyz = tmp0.www * tmp3.xyz;
                tmp0.w = saturate(tmp1.y * 0.75 + -0.5);
                tmp1.y = 1.0 - tmp0.w;
                tmp1.y = -tmp1.w * tmp1.y + 1.0;
                tmp1.w = tmp1.z + tmp1.z;
                tmp1.z = tmp1.z > 0.5;
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.w = saturate(tmp1.z ? tmp1.y : tmp0.w);
                tmp0.w = tmp0.w * 0.85;
                tmp4.x = inp.texcoord1.w;
                tmp4.y = inp.texcoord2.w;
                tmp4.z = inp.texcoord3.w;
                tmp1.yzw = _WorldSpaceCameraPos - tmp4.xyz;
                tmp2.w = dot(tmp1.xyz, tmp1.xyz);
                tmp2.w = max(tmp2.w, 0.001);
                tmp2.w = rsqrt(tmp2.w);
                tmp4.xyz = tmp1.yzw * tmp2.www;
                tmp1.yzw = tmp1.yzw * tmp2.www + float3(0.0, 1.0, 0.0);
                tmp2.w = dot(tmp2.xyz, tmp4.xyz);
                tmp2.w = 1.0 - tmp2.w;
                tmp0.w = tmp2.w * tmp2.w + tmp0.w;
                tmp0.w = tmp0.w + 0.15;
                tmp2.w = dot(tmp1.xyz, tmp1.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp1.yzw = tmp1.yzw * tmp2.www;
                tmp1.y = dot(tmp2.xyz, tmp1.xyz);
                tmp1.y = tmp1.y + 1.0;
                tmp1.y = tmp1.y * 0.5;
                tmp1.y = log(tmp1.y);
                tmp1.z = _GlossPower * 16.0 + -1.0;
                tmp1.z = exp(tmp1.z);
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.y = exp(tmp1.y);
                tmp1.z = tmp1.y * tmp1.y;
                tmp1.z = tmp1.z * _Gloss;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.z = tmp1.y * 0.625;
                tmp0.y = saturate(tmp0.y * tmp0.w + tmp1.z);
                tmp0.w = dot(tmp3.xyz, tmp4.xyz);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.y = tmp0.y - tmp0.w;
                tmp0.y = _BodyLightingContribution * tmp0.y + tmp0.w;
                tmp0.w = tmp0.y * 0.25 + 0.25;
                tmp1.z = 1.0 - tmp0.w;
                tmp3.xyz = tmp4.yyy * unity_MatrixV._m01_m11_m21;
                tmp3.xyz = unity_MatrixV._m00_m10_m20 * tmp4.xxx + tmp3.xyz;
                tmp3.xyz = unity_MatrixV._m02_m12_m22 * tmp4.zzz + tmp3.xyz;
                tmp1.w = tmp3.z * 1.0;
                tmp4.xyz = tmp2.yyy * unity_MatrixV._m01_m11_m21;
                tmp2.xyw = unity_MatrixV._m00_m10_m20 * tmp2.xxx + tmp4.xyz;
                tmp2.xyz = unity_MatrixV._m02_m12_m22 * tmp2.zzz + tmp2.xyw;
                tmp4.z = tmp1.w * tmp2.z;
                tmp4.xy = tmp3.xy * float2(-1.0, -1.0) + tmp2.xy;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xy = tmp1.ww * tmp4.xy;
                tmp2.xy = tmp2.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp2 = tex2D(_CubemapOverride, tmp2.xy);
                tmp3.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = -tmp3.xyz * tmp1.zzz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp0.www * tmp4.xyz;
                tmp2.xyz = saturate(tmp2.xyz ? tmp3.xyz : tmp4.xyz);
                tmp1.xzw = tmp1.xxx * tmp0.xxx + tmp2.xyz;
                tmp1.xzw = tmp1.xzw - float3(1.0, 1.0, 1.0);
                tmp1.xzw = max(tmp1.xzw, float3(0.0, 0.0, 0.0));
                tmp0.x = saturate(tmp0.y * 2.0 + -1.0);
                tmp2.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _TopColor.xyz;
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = _TopColor.www * tmp2.xyz + tmp3.xyz;
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _MiddleColor.xyz;
                tmp4.xyz = _MiddleColor.www * tmp4.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp2.xyz = tmp0.yyy * tmp2.xyz + tmp4.xyz;
                tmp5.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _BottomColor.xyz;
                tmp5.xyz = _BottomColor.www * tmp5.xyz + tmp3.xyz;
                tmp4.xyz = tmp4.xyz - tmp5.xyz;
                tmp4.xyz = tmp0.yyy * tmp4.xyz + tmp5.xyz;
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp0.xyw = tmp0.xxx * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = tmp1.yyy * float3(0.625, 0.625, 0.625) + tmp0.xyw;
                tmp2.xyz = -tmp3.xyz * tmp0.xyw + tmp2.xyz;
                tmp0.xyw = tmp0.xyw * tmp3.xyz;
                tmp0.xyw = tmp2.xyz * float3(0.8, 0.8, 0.8) + tmp0.xyw;
                tmp1.xyz = tmp1.xzw - tmp0.xyw;
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                o.sv_target.xyz = _UseOverride.xxx * tmp1.xyz + tmp0.xyw;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 79816
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp3.xyz = tmp1.xyz * tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx + -tmp3.xyz;
                tmp1.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.xyz = tmp1.www * tmp3.xyz;
                o.texcoord.y = tmp3.x;
                o.texcoord.x = tmp2.z;
                o.texcoord.z = tmp1.y;
                o.texcoord1.x = tmp2.x;
                o.texcoord2.x = tmp2.y;
                o.texcoord1.z = tmp1.z;
                o.texcoord2.z = tmp1.x;
                o.texcoord1.y = tmp3.y;
                o.texcoord2.y = tmp3.z;
                o.texcoord3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 1.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}