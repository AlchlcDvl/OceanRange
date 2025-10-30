Shader "SR/AMP/Slime/Body/Glitter MatCap BoomCracks" {
	Properties {
		_LightingUVHorizontalAdjust ("Lighting UV Horizontal Adjust", Range(0, 1)) = 0
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_LightingUVContribution ("Lighting UV Contribution", Range(0, 1)) = 1
		_CrackNoise ("Crack Noise", 2D) = "white" {}
		_CrackNoiseSpeed ("Crack Noise Speed", Float) = 1
		_Cracks ("Cracks", Cube) = "black" {}
		_Gloss ("Gloss", Range(0, 2)) = 0
		_CrackAmount ("Crack Amount", Range(0, 1)) = 1
		_Char ("Char Amount", Range(0, 1)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_CrackColor ("Crack Color", Color) = (1,0.51,0,1)
		_CrackColorRange ("Crack Color Range", Range(-0.15, 0.15)) = 0.1
		_BodyLightingContribution ("Body Lighting Contribution", Range(0, 1)) = 1
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		_Glitter ("Glitter", Cube) = "black" {}
		[HDR] _GlitterColor ("Glitter Color", Color) = (2.981132,0.6114775,0.3234248,1)
		_GlitterPower ("Glitter Power", Vector) = (0.5,0.3,20,0.5)
		[Toggle] _UseOverride ("Enable Matcap Override", Float) = 0
		[NoScaleOffset] _CubemapOverride ("Matcap Override", 2D) = "black" {}
		[Toggle] _OverrideAlphaUV1 ("Override Alpha UV1", Float) = 0
		_OverrideBlend ("Override Blend", Range(0, 1)) = 1
		[HideInInspector] _texcoord2 ("", 2D) = "white" {}
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 53525
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
			float _CrackColorRange;
			float4 _CrackColor;
			float _CrackNoiseSpeed;
			float4 _CrackNoise_ST;
			float _CrackAmount;
			float4 _BottomColor;
			float4 _MiddleColor;
			float _Gloss;
			float _GlossPower;
			float _LightingUVHorizontalAdjust;
			float _LightingUVContribution;
			float _BodyLightingContribution;
			float4 _TopColor;
			float _UseOverride;
			float _OverrideAlphaUV1;
			float _OverrideBlend;
			float _Char;
			float4 _GlitterColor;
			float4 _GlitterPower;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CrackNoise;
			samplerCUBE _Cracks;
			sampler2D _CubemapOverride;
			samplerCUBE _Glitter;
			
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
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                tmp0.xy = inp.texcoord.xy - float2(0.5, -0.0);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x - 0.25;
                tmp0.x = saturate(tmp0.x * 1.333333);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.y * tmp0.x + -inp.texcoord.y;
                tmp0.x = _LightingUVHorizontalAdjust * tmp0.x + inp.texcoord.y;
                tmp0.x = tmp0.x - 0.5;
                tmp0.y = _LightingUVContribution * tmp0.x + 0.5;
                tmp0.x = tmp0.x * _LightingUVContribution;
                tmp0.x = -tmp0.x * 2.0 + 1.0;
                tmp0.z = tmp0.y > 0.5;
                tmp0.y = tmp0.y + tmp0.y;
                tmp1.x = inp.texcoord1.z;
                tmp1.z = inp.texcoord3.z;
                tmp1.y = inp.texcoord2.z;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.w = tmp1.y * tmp0.w + 1.0;
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = saturate(tmp1.w * 0.75 + -0.5);
                tmp1.w = 1.0 - tmp0.w;
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.x = -tmp0.x * tmp1.w + 1.0;
                tmp0.x = saturate(tmp0.z ? tmp0.x : tmp0.y);
                tmp0.x = tmp0.x * 0.85;
                tmp3.x = inp.texcoord1.w;
                tmp3.y = inp.texcoord2.w;
                tmp3.z = inp.texcoord3.w;
                tmp0.yzw = _WorldSpaceCameraPos - tmp3.xyz;
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = max(tmp1.w, 0.001);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp0.yzw * tmp1.www;
                tmp0.yzw = tmp0.yzw * tmp1.www + float3(0.0, 1.0, 0.0);
                tmp1.w = dot(tmp2.xyz, tmp3.xyz);
                tmp1.w = 1.0 - tmp1.w;
                tmp0.x = tmp1.w * tmp1.w + tmp0.x;
                tmp2.w = dot(tmp0.xyz, tmp0.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp0.yzw = tmp0.yzw * tmp2.www;
                tmp0.y = dot(tmp2.xyz, tmp0.xyz);
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
                tmp0.x = saturate(tmp0.x + 0.15);
                tmp0.z = dot(tmp1.xyz, tmp3.xyz);
                tmp0.z = 1.0 - tmp0.z;
                tmp0.x = tmp0.x - tmp0.z;
                tmp0.x = _BodyLightingContribution * tmp0.x + tmp0.z;
                tmp0.z = tmp0.z * -1.5 + 1.5;
                tmp0.w = tmp0.x * 0.25 + 0.25;
                tmp1.x = 1.0 - tmp0.w;
                tmp4.xyz = tmp3.yyy * unity_MatrixV._m01_m11_m21;
                tmp4.xyz = unity_MatrixV._m00_m10_m20 * tmp3.xxx + tmp4.xyz;
                tmp4.xyz = unity_MatrixV._m02_m12_m22 * tmp3.zzz + tmp4.xyz;
                tmp1.y = tmp4.z * 1.0;
                tmp5.xyz = tmp2.yyy * unity_MatrixV._m01_m11_m21;
                tmp5.xyz = unity_MatrixV._m00_m10_m20 * tmp2.xxx + tmp5.xyz;
                tmp5.xyz = unity_MatrixV._m02_m12_m22 * tmp2.zzz + tmp5.xyz;
                tmp6.z = tmp1.y * tmp5.z;
                tmp6.xy = tmp4.xy * float2(-1.0, -1.0) + tmp5.xy;
                tmp1.y = dot(tmp6.xyz, tmp6.xyz);
                tmp1.y = rsqrt(tmp1.y);
                tmp1.yz = tmp1.yy * tmp6.xy;
                tmp1.yz = tmp1.yz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp4 = tex2D(_CubemapOverride, tmp1.yz);
                tmp5.xyz = tmp4.xyz - float3(0.5, 0.5, 0.5);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp5.xyz * tmp1.xxx + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp0.www * tmp5.xyz;
                tmp1.xyz = saturate(tmp4.xyz ? tmp1.xyz : tmp5.xyz);
                tmp4.xy = inp.texcoord.zw - inp.texcoord.xy;
                tmp4.xy = _OverrideAlphaUV1.xx * tmp4.xy + inp.texcoord.xy;
                tmp4 = tex2D(_CubemapOverride, tmp4.xy);
                tmp0.w = tmp4.w * _OverrideBlend;
                tmp1.xyz = tmp1.xyz * tmp0.www;
                tmp1.xyz = -_UseOverride.xxx * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _TopColor.xyz;
                tmp5.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp4.xyz = _TopColor.www * tmp4.xyz + tmp5.xyz;
                tmp6.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _MiddleColor.xyz;
                tmp6.xyz = _MiddleColor.www * tmp6.xyz + tmp5.xyz;
                tmp4.xyz = tmp4.xyz - tmp6.xyz;
                tmp4.xyz = tmp0.xxx * tmp4.xyz + tmp6.xyz;
                tmp7.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _BottomColor.xyz;
                tmp7.xyz = _BottomColor.www * tmp7.xyz + tmp5.xyz;
                tmp6.xyz = tmp6.xyz - tmp7.xyz;
                tmp6.xyz = tmp0.xxx * tmp6.xyz + tmp7.xyz;
                tmp0.x = saturate(tmp0.x * 2.0 + -1.0);
                tmp4.xyz = tmp4.xyz - tmp6.xyz;
                tmp4.xyz = tmp0.xxx * tmp4.xyz + tmp6.xyz;
                tmp0.xyw = tmp0.yyy * float3(0.625, 0.625, 0.625) + tmp4.xyz;
                tmp0.xyw = -tmp5.xyz * tmp4.xyz + tmp0.xyw;
                tmp4.xyz = tmp4.xyz * tmp5.xyz;
                tmp0.xyw = tmp0.xyw * float3(0.8, 0.8, 0.8) + tmp4.xyz;
                tmp0.xyw = float3(1.0, 1.0, 1.0) - tmp0.xyw;
                tmp0.xyw = saturate(-tmp0.xyw * tmp1.xyz + float3(1.0, 1.0, 1.0));
                tmp1.x = dot(tmp0.xyz, float3(0.299, 0.587, 0.114));
                tmp1.xyz = tmp1.xxx - tmp0.xyw;
                tmp1.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyw;
                tmp4.xyz = inp.texcoord2.zzz * unity_WorldToObject._m01_m11_m21;
                tmp4.xyz = unity_WorldToObject._m00_m10_m20 * inp.texcoord1.zzz + tmp4.xyz;
                tmp4.xyz = unity_WorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp4.xyz;
                tmp5.xy = inp.texcoord.xy * _CrackNoise_ST.xy + _CrackNoise_ST.zw;
                tmp2.w = _CrackNoiseSpeed * _Time.y;
                tmp5.xy = tmp2.ww * float2(0.06, -3.0) + tmp5.xy;
                tmp5 = tex2D(_CrackNoise, tmp5.xy);
                tmp2.w = tmp5.x * 2.0 + -1.0;
                tmp2.w = tmp2.w * _CrackAmount;
                tmp4.xyz = tmp2.www * float3(0.03, 0.03, 0.03) + tmp4.xyz;
                tmp4 = texCUBE(_Cracks, tmp4.xyz);
                tmp2.w = tmp4.x * -0.25 + 1.0;
                tmp0.z = tmp0.z * tmp4.x;
                tmp0.z = tmp0.z * _CrackAmount;
                tmp1.xyz = tmp1.xyz * tmp2.www;
                tmp1.xyz = tmp1.xyz * float3(0.75, 0.75, 0.75) + -tmp0.xyw;
                tmp4.xyw = _Char.xxx * tmp1.yzx + tmp0.ywx;
                tmp0.x = tmp4.x >= tmp4.y;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp6.xy = tmp4.yx;
                tmp7.xy = tmp4.xy - tmp6.xy;
                tmp6.zw = float2(-1.0, 0.6666667);
                tmp7.zw = float2(1.0, -1.0);
                tmp6 = tmp0.xxxx * tmp7 + tmp6;
                tmp0.x = tmp4.w >= tmp6.x;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp4.xyz = tmp6.xyw;
                tmp6.xyw = tmp4.wyx;
                tmp6 = tmp6 - tmp4;
                tmp4 = tmp0.xxxx * tmp6 + tmp4;
                tmp0.x = min(tmp4.y, tmp4.w);
                tmp0.x = tmp4.x - tmp0.x;
                tmp0.y = tmp0.x * 6.0 + 0.0;
                tmp0.w = tmp4.w - tmp4.y;
                tmp0.y = tmp0.w / tmp0.y;
                tmp0.y = tmp0.y + tmp4.z;
                tmp1.xyz = abs(tmp0.yyy) + float3(1.0, 0.6666667, 0.3333333);
                tmp1.xyz = frac(tmp1.xyz);
                tmp1.xyz = tmp1.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp1.xyz = saturate(abs(tmp1.xyz) - float3(1.0, 1.0, 1.0));
                tmp1.xyz = tmp1.xyz - float3(1.0, 1.0, 1.0);
                tmp0.y = tmp4.x + 0.0;
                tmp0.x = tmp0.x / tmp0.y;
                tmp0.y = _CrackAmount + 1.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.xyw = tmp0.xxx * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp1.x = tmp0.z * 40.0;
                tmp1.yz = tmp0.zz * float2(10.0, 10.0) + float2(-0.8, -0.333);
                tmp1.yz = saturate(tmp1.yz * float2(5.0, 2.994012));
                tmp1.x = saturate(tmp1.x);
                tmp0.z = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp0.z = tmp0.z * tmp1.x;
                tmp0.z = tmp0.z * -0.05 + 1.0;
                tmp0.z = tmp0.z * tmp4.x;
                tmp4.xyz = _CrackAmount.xxx * float3(-0.4, -1.3, -0.25) + float3(1.0, 2.0, 1.0);
                tmp0.z = tmp0.z * tmp4.z;
                tmp4.zw = tmp1.yz * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp1.xy = tmp1.yz * tmp1.yz;
                tmp1.xy = tmp1.xy * tmp4.zw;
                tmp1.x = tmp1.y * 0.5 + tmp1.x;
                tmp1.y = 1.0 - tmp1.x;
                tmp1.z = 1.0 - tmp5.x;
                tmp1.y = tmp1.y / tmp1.z;
                tmp1.y = saturate(1.0 - tmp1.y);
                tmp1.y = tmp1.x * 0.667 + tmp1.y;
                tmp2.w = _CrackColor.y >= _CrackColor.z;
                tmp2.w = tmp2.w ? 1.0 : 0.0;
                tmp6.xy = _CrackColor.yz;
                tmp6.zw = float2(0.0, -0.3333333);
                tmp7.xy = _CrackColor.zy;
                tmp7.zw = float2(-1.0, 0.6666667);
                tmp6 = tmp6 - tmp7;
                tmp6 = tmp2.wwww * tmp6.xywz + tmp7.xywz;
                tmp2.w = _CrackColor.x >= tmp6.x;
                tmp2.w = tmp2.w ? 1.0 : 0.0;
                tmp7.z = tmp6.w;
                tmp6.w = _CrackColor.x;
                tmp7.xyw = tmp6.wyx;
                tmp7 = tmp7 - tmp6;
                tmp6 = tmp2.wwww * tmp7 + tmp6;
                tmp2.w = min(tmp6.y, tmp6.w);
                tmp2.w = tmp6.x - tmp2.w;
                tmp3.w = tmp2.w * 6.0 + 0.0;
                tmp4.z = tmp6.w - tmp6.y;
                tmp3.w = tmp4.z / tmp3.w;
                tmp3.w = tmp3.w + tmp6.z;
                tmp4.z = abs(tmp3.w) + _CrackColorRange;
                tmp3.w = abs(tmp3.w) - _CrackColorRange;
                tmp5.yzw = tmp3.www + float3(1.0, 0.6666667, 0.3333333);
                tmp5.yzw = frac(tmp5.yzw);
                tmp5.yzw = tmp5.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp5.yzw = saturate(abs(tmp5.yzw) - float3(1.0, 1.0, 1.0));
                tmp5.yzw = tmp5.yzw - float3(1.0, 1.0, 1.0);
                tmp6.yzw = tmp4.zzz + float3(1.0, 0.6666667, 0.3333333);
                tmp6.yzw = frac(tmp6.yzw);
                tmp6.yzw = tmp6.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp6.yzw = saturate(abs(tmp6.yzw) - float3(1.0, 1.0, 1.0));
                tmp6.yzw = tmp6.yzw - float3(1.0, 1.0, 1.0);
                tmp3.w = tmp6.x + 0.0;
                tmp2.w = tmp2.w / tmp3.w;
                tmp6.yzw = tmp2.www * tmp6.yzw + float3(1.0, 1.0, 1.0);
                tmp5.yzw = tmp2.www * tmp5.yzw + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp6.xxx * tmp6.yzw + -_CrackColor.xyz;
                tmp7.xyz = tmp1.zzz * tmp7.xyz + _CrackColor.xyz;
                tmp8.xyz = -tmp6.xxx * tmp5.yzw + _CrackColor.xyz;
                tmp5.yzw = tmp5.yzw * tmp6.xxx;
                tmp8.xyz = tmp1.zzz * tmp8.xyz + tmp5.yzw;
                tmp7.xyz = tmp7.xyz - tmp8.xyz;
                tmp9.xyz = tmp1.yyy * tmp7.xyz + tmp8.xyz;
                tmp1.y = log(tmp1.w);
                tmp1.y = tmp1.y * 0.9;
                tmp1.y = exp(tmp1.y);
                tmp1.y = tmp1.y * -3.0 + 1.0;
                tmp1.z = tmp1.y * _CrackAmount;
                tmp7.xyz = tmp1.zzz * tmp7.xyz + tmp8.xyz;
                tmp7.xyz = _CrackAmount.xxx * tmp1.yyy + tmp7.xyz;
                tmp7.xyz = saturate(tmp7.xyz - float3(1.0, 1.0, 1.0));
                tmp1.xyz = tmp9.xyz * tmp1.xxx + tmp7.xyz;
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp7.xyz = tmp6.xxx * tmp6.yzw + -tmp5.yzw;
                tmp6.xyz = tmp6.yzw * tmp6.xxx;
                tmp5.yzw = _CrackAmount.xxx * tmp7.xyz + tmp5.yzw;
                tmp5.yzw = tmp5.yzw * _CrackAmount.xxx;
                tmp5.xyz = tmp5.xxx * tmp5.yzw;
                tmp5.xyz = max(tmp5.xyz, float3(0.0, 0.0, 0.0));
                tmp5.xyz = min(tmp5.xyz, float3(1.0, 0.0, 0.0));
                tmp5.xyz = tmp5.xyz * float3(2.0, 2.0, 2.0) + tmp6.xyz;
                tmp2.w = inp.texcoord.y * 0.5 + 0.5;
                tmp1.w = tmp1.w * tmp2.w + -tmp4.x;
                tmp2.w = tmp4.y - tmp4.x;
                tmp2.w = 1.0 / tmp2.w;
                tmp1.w = saturate(tmp1.w * tmp2.w);
                tmp2.w = tmp1.w * -2.0 + 3.0;
                tmp1.w = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.xyz = tmp5.xyz * tmp1.www + tmp1.xyz;
                tmp0.xyz = tmp0.zzz * tmp0.xyw + tmp1.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp3.xyz;
                tmp3.xyz = tmp2.yyy * unity_WorldToObject._m01_m11_m21;
                tmp2.xyw = unity_WorldToObject._m00_m10_m20 * tmp2.xxx + tmp3.xyz;
                tmp2.xyz = unity_WorldToObject._m02_m12_m22 * tmp2.zzz + tmp2.xyw;
                tmp2 = texCUBE(_Glitter, tmp2.xyz);
                tmp2.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xy = tmp2.xy * float2(0.25, 0.25);
                tmp0.w = dot(tmp3.xy, tmp3.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp3.z = sqrt(tmp0.w);
                tmp4.x = dot(inp.texcoord1.xyz, tmp3.xyz);
                tmp4.y = dot(inp.texcoord2.xyz, tmp3.xyz);
                tmp4.z = dot(inp.texcoord3.xyz, tmp3.xyz);
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = dot(tmp3.xyz, tmp1.xyz);
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = log(tmp0.w);
                tmp1.xy = _GlitterPower.yw * float2(16.0, 16.0) + float2(-1.0, -1.0);
                tmp1.xy = exp(tmp1.xy);
                tmp1.xy = tmp0.ww * tmp1.xy;
                tmp1.xy = exp(tmp1.xy);
                tmp1.xy = tmp1.xy * _GlitterPower.xz;
                tmp0.w = tmp1.y + tmp1.x;
                tmp1.x = tmp2.w * tmp2.w;
                tmp1.x = tmp1.x * tmp2.w;
                tmp1.y = tmp2.z - 0.3;
                tmp1.y = saturate(tmp1.y * 10.0);
                tmp1.z = tmp1.y * -2.0 + 3.0;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.xyz = tmp1.xxx * _GlitterColor.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
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
			GpuProgramID 113446
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