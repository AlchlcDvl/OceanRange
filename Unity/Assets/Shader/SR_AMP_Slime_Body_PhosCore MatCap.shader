Shader "SR/AMP/Slime/Body/PhosCore MatCap" {
	Properties {
		_LightingUVHorizontalAdjust ("Lighting UV Horizontal Adjust", Range(0, 1)) = 0
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		[Toggle] _UseOverride ("Enable Matcap Override", Float) = 0
		_LightingUVContribution ("Lighting UV Contribution", Range(0, 1)) = 1
		[NoScaleOffset] _CubemapOverride ("Matcap Override", 2D) = "black" {}
		[Toggle] _OverrideAlphaUV1 ("Override Alpha UV1", Float) = 0
		_OverrideBlend ("Override Blend", Range(0, 1)) = 1
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_NormalPanSpeed ("Normal Pan Speed", Vector) = (0,0,0,0)
		[Toggle] _NormalSmoothTop ("Normal Smooth Top", Float) = 0
		[Toggle] _NormalUV1 ("Normal UV1", Float) = 0
		[NoScaleOffset] [Normal] _Normal ("Normal", 2D) = "bump" {}
		_BodyLightingContribution ("Body Lighting Contribution", Range(0, 1)) = 1
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		[HDR] _GlowTop ("Glow Color", Color) = (1,1,0,1)
		_GlowMin ("Glow Min", Range(0, 1)) = 0
		_GlowMax ("Glow Max", Range(0, 1)) = 1
		_RadExoticCore ("Rad Exotic Core", Range(0, 1)) = 0
		_GlowSpeed ("Glow Speed", Float) = 0.8
		_Alpha ("Translucency", Range(0, 1)) = 1
		[HideInInspector] _texcoord2 ("", 2D) = "white" {}
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "AlphaTest+0" "RenderType" = "Opaque" }
		GrabPass {
			"_RefractionSlime"
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+0" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 65208
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
				float4 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
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
			float _LightingUVHorizontalAdjust;
			float _LightingUVContribution;
			float _BodyLightingContribution;
			float4 _TopColor;
			float _OverrideAlphaUV1;
			float _OverrideBlend;
			float _Alpha;
			float4 _GlowTop;
			float _RadExoticCore;
			float _GlowSpeed;
			float _GlowMin;
			float _GlowMax;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RefractionSlime;
			sampler2D _Normal;
			sampler2D _CubemapOverride;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord.zw = v.texcoord1.xy * _texcoord2_ST.xy + _texcoord2_ST.zw;
                o.texcoord1.w = tmp0.x;
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp4.xyz = tmp2.xyz * tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx + -tmp4.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord1.z = tmp2.y;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.z = tmp2.z;
                o.texcoord3.z = tmp2.x;
                o.texcoord2.w = tmp0.y;
                o.texcoord3.w = tmp0.z;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord4.zw = tmp1.zw;
                o.texcoord4.xy = tmp0.zz + tmp0.xw;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
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
                tmp0.xyz = inp.texcoord.yxy - float3(1.0, 0.5, -0.0);
                tmp0.y = dot(tmp0.xy, tmp0.xy);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y - 0.25;
                tmp0.xy = saturate(tmp0.xy * float2(-1.333333, 1.333333));
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.z * tmp0.y + -inp.texcoord.y;
                tmp0.y = _LightingUVHorizontalAdjust * tmp0.y + inp.texcoord.y;
                tmp0.y = tmp0.y - 0.5;
                tmp0.z = tmp0.y * _LightingUVContribution;
                tmp0.y = _LightingUVContribution * tmp0.y + 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.w = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.w;
                tmp1.xy = inp.texcoord.zw - inp.texcoord.xy;
                tmp1.zw = _NormalUV1.xx * tmp1.xy + inp.texcoord.xy;
                tmp1.xy = _OverrideAlphaUV1.xx * tmp1.xy + inp.texcoord.xy;
                tmp2 = tex2D(_CubemapOverride, tmp1.xy);
                tmp0.w = tmp2.w * _OverrideBlend;
                tmp1.xy = _Time.yy * _NormalPanSpeed + tmp1.zw;
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.zw = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.xy = tmp1.xy + tmp1.xy;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp2.z = sqrt(tmp1.x);
                tmp1.xyz = tmp2.xyz - float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.xyz - float3(1.0, 1.0, -0.0);
                tmp1.xyz = tmp0.xxx * tmp1.xyz + float3(0.0, 0.0, 1.0);
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp1.xyz = _NormalSmoothTop.xxx * tmp1.xyz + tmp2.xyz;
                tmp2.y = dot(inp.texcoord2.xyz, tmp1.xyz);
                tmp2.x = dot(inp.texcoord1.xyz, tmp1.xyz);
                tmp2.z = dot(inp.texcoord3.xyz, tmp1.xyz);
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.x = tmp2.y * tmp0.x + 1.0;
                tmp1.yzw = tmp0.xxx * tmp2.xyz;
                tmp0.x = saturate(tmp1.x * 0.75 + -0.5);
                tmp1.x = 1.0 - tmp0.x;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.y = tmp0.y > 0.5;
                tmp0.z = -tmp0.z * tmp1.x + 1.0;
                tmp0.x = saturate(tmp0.y ? tmp0.z : tmp0.x);
                tmp0.x = tmp0.x * 0.85;
                tmp3.x = inp.texcoord1.w;
                tmp3.y = inp.texcoord2.w;
                tmp3.z = inp.texcoord3.w;
                tmp3.xyz = _WorldSpaceCameraPos - tmp3.xyz;
                tmp0.y = dot(tmp3.xyz, tmp3.xyz);
                tmp0.y = max(tmp0.y, 0.001);
                tmp0.y = rsqrt(tmp0.y);
                tmp4.xyz = tmp0.yyy * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * tmp0.yyy + float3(0.0, 1.0, 0.0);
                tmp0.y = dot(tmp1.xyz, tmp4.xyz);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.x = tmp0.y * tmp0.y + tmp0.x;
                tmp0.y = dot(tmp3.xyz, tmp3.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp3.xyz = tmp0.yyy * tmp3.xyz;
                tmp0.y = dot(tmp1.xyz, tmp3.xyz);
                tmp0.y = tmp0.y + 1.0;
                tmp0.y = tmp0.y * 0.5;
                tmp0.y = log(tmp0.y);
                tmp0.z = _GlossPower * 16.0 + -1.0;
                tmp0.z = exp(tmp0.z);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = exp(tmp0.y);
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.z = tmp0.z * _Gloss;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.x = tmp0.y * 0.625 + tmp0.x;
                tmp0.x = tmp0.x + 0.15;
                tmp0.z = saturate(tmp0.x);
                tmp0.x = _Alpha * 0.5 + tmp0.x;
                tmp0.x = saturate(tmp0.x + 0.5);
                tmp1.x = dot(tmp2.xyz, tmp4.xyz);
                tmp1.x = 1.0 - tmp1.x;
                tmp0.z = tmp0.z - tmp1.x;
                tmp0.z = _BodyLightingContribution * tmp0.z + tmp1.x;
                tmp1.x = saturate(tmp0.z * 2.0 + -1.0);
                tmp1.yzw = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _TopColor.xyz;
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.yzw = _TopColor.www * tmp1.yzw + tmp2.xyz;
                tmp3.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _MiddleColor.xyz;
                tmp3.xyz = _MiddleColor.www * tmp3.xyz + tmp2.xyz;
                tmp1.yzw = tmp1.yzw - tmp3.xyz;
                tmp1.yzw = tmp0.zzz * tmp1.yzw + tmp3.xyz;
                tmp5.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _BottomColor.xyz;
                tmp5.xyz = _BottomColor.www * tmp5.xyz + tmp2.xyz;
                tmp3.xyz = tmp3.xyz - tmp5.xyz;
                tmp3.xyz = tmp0.zzz * tmp3.xyz + tmp5.xyz;
                tmp0.z = tmp0.z * 0.25 + 0.25;
                tmp1.yzw = tmp1.yzw - tmp3.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + tmp3.xyz;
                tmp3.xyz = tmp0.yyy * float3(0.625, 0.625, 0.625) + tmp1.xyz;
                tmp3.xyz = -tmp2.xyz * tmp1.xyz + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp1.xyz = tmp3.xyz * float3(0.8, 0.8, 0.8) + tmp1.xyz;
                tmp0.y = 1.0 - tmp0.z;
                tmp2.xyz = tmp4.yyy * unity_MatrixV._m01_m11_m21;
                tmp2.xyz = unity_MatrixV._m00_m10_m20 * tmp4.xxx + tmp2.xyz;
                tmp2.xyz = unity_MatrixV._m02_m12_m22 * tmp4.zzz + tmp2.xyz;
                tmp1.w = tmp2.z * 1.0;
                tmp3.x = inp.texcoord1.z;
                tmp3.y = inp.texcoord2.z;
                tmp3.z = inp.texcoord3.z;
                tmp2.z = dot(tmp3.xyz, tmp3.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp5.xyz = tmp2.zzz * tmp3.xyz;
                tmp2.z = dot(tmp3.xyz, tmp4.xyz);
                tmp2.w = dot(tmp5.xyz, tmp4.xyz);
                tmp2.zw = float2(1.0, 1.0) - tmp2.zw;
                tmp2.w = log(tmp2.w);
                tmp2.w = tmp2.w * 0.9;
                tmp2.w = exp(tmp2.w);
                tmp2.w = tmp2.w * 3.0;
                tmp3.xyz = tmp5.yyy * unity_MatrixV._m01_m11_m21;
                tmp3.xyz = unity_MatrixV._m00_m10_m20 * tmp5.xxx + tmp3.xyz;
                tmp3.xyz = unity_MatrixV._m02_m12_m22 * tmp5.zzz + tmp3.xyz;
                tmp4.z = tmp1.w * tmp3.z;
                tmp4.xy = tmp2.xy * float2(-1.0, -1.0) + tmp3.xy;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xy = tmp1.ww * tmp4.xy;
                tmp2.xy = tmp2.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp3 = tex2D(_CubemapOverride, tmp2.xy);
                tmp4.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp4.xyz = -tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = -tmp4.xyz * tmp0.yyy + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp0.zzz * tmp3.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp5.xyz + tmp5.xyz;
                tmp3.xyz = saturate(tmp3.xyz ? tmp4.xyz : tmp5.xyz);
                tmp3.xyz = tmp3.xyz - tmp1.xyz;
                tmp0.yzw = tmp0.www * tmp3.xyz;
                tmp0.yzw = _UseOverride.xxx * tmp0.yzw + tmp1.xyz;
                tmp1.x = inp.texcoord4.w + 0.0;
                tmp1.y = tmp1.x * 0.5;
                tmp1.z = -tmp1.x * 0.5 + inp.texcoord4.y;
                tmp3.yw = -tmp1.zz * _ProjectionParams.xx + tmp1.yy;
                tmp3.xz = inp.texcoord4.xx;
                tmp1 = tmp3 / tmp1.xxxx;
                tmp1 = tmp1 - float4(0.5, 0.5, 0.5, 0.5);
                tmp1 = tmp1 * float4(0.5, 0.5, 1.5, 1.5) + float4(0.5, 0.5, 0.5, 0.5);
                tmp1.zw = tmp1.zw - tmp1.xy;
                tmp1.xy = tmp2.zz * tmp1.zw + tmp1.xy;
                tmp1.z = tmp2.z * 3.0 + -_Time.y;
                tmp1.z = frac(tmp1.z);
                tmp1.z = tmp1.z * 2.0 + -1.0;
                tmp1.z = abs(tmp1.z) * _RadExoticCore;
                tmp1.zw = tmp1.zz * float2(0.4, 0.4) + float2(0.4, -0.1);
                tmp3 = tex2D(_RefractionSlime, tmp1.xy);
                tmp0.yzw = tmp0.yzw - tmp3.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + tmp3.xyz;
                tmp1.xy = _RadExoticCore.xx * float2(1.46, 0.11) + float2(1.0, -1.0);
                tmp0.w = tmp1.y * tmp2.w;
                tmp0.w = tmp0.w / tmp1.x;
                tmp0.w = tmp0.w + 1.0;
                tmp1.x = 1.0 - tmp0.w;
                tmp0.w = dot(tmp0.xy, tmp1.xy);
                tmp1.y = -tmp1.w * 2.0 + 1.0;
                tmp1.z = tmp1.z > 0.5;
                tmp1.x = -tmp1.y * tmp1.x + 1.0;
                tmp0.w = saturate(tmp1.z ? tmp1.x : tmp0.w);
                tmp1.xyz = _GlowTop.xyz * float3(0.333, 0.333, 0.333);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = _GlowTop.xyz * float3(0.667, 0.667, 0.667) + tmp2.xyz;
                tmp3.xyz = tmp0.www * _GlowTop.xyz;
                tmp1.xyz = tmp3.xyz * float3(0.334, 0.334, 0.334) + tmp1.xyz;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp1.xyz = tmp0.www * tmp2.xyz + tmp1.xyz;
                tmp1.w = _GlowSpeed * _Time.y;
                tmp1.w = sin(tmp1.w);
                tmp1.w = tmp1.w + 1.0;
                tmp1.w = tmp1.w * 2.0 + -3.0;
                tmp1.w = max(tmp1.w, 0.0);
                tmp2.x = _GlowMax - _GlowMin;
                tmp1.w = tmp1.w * tmp2.x + _GlowMin;
                tmp0.w = saturate(tmp0.w * tmp1.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = max(tmp0.xyz, tmp2.xyz);
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz + tmp2.xyz;
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                o.sv_target.xyz = _GlowTop.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest+0" "RenderType" = "Opaque" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 117848
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