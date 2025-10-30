Shader "SR/AMP/Slime/Body/BoomCracks" {
	Properties {
		_LightingUVHorizontalAdjust ("Lighting UV Horizontal Adjust", Range(0, 1)) = 0
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_LightingUVContribution ("Lighting UV Contribution", Range(0, 1)) = 1
		_BodyLightingContribution ("Body Lighting Contribution", Range(0, 1)) = 1
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		_Gloss ("Gloss", Range(0, 2)) = 0
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_CrackNoise ("Crack Noise", 2D) = "white" {}
		_CrackNoiseSpeed ("Crack Noise Speed", Float) = 1
		_Cracks ("Cracks", Cube) = "black" {}
		_CrackAmount ("Crack Amount", Range(0, 1)) = 1
		_Char ("Char Amount", Range(0, 1)) = 0
		_CrackColor ("Crack Color", Color) = (1,0.51,0,1)
		_BoomHueShift ("Crack HueShift", Range(-1, 1)) = 0
		_CrackColorRange ("Crack Color Range", Range(-0.15, 0.15)) = 0.1
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 48378
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
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
			// $Globals ConstantBuffers for Fragment Shader
			float _BoomHueShift;
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
			float _Char;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CrackNoise;
			samplerCUBE _Cracks;
			
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
                tmp1.x = dot(tmp1.xyz, tmp3.xyz);
                tmp1.xy = float2(1.0, 1.0) - tmp1.xw;
                tmp0.x = tmp1.y * tmp1.y + tmp0.x;
                tmp1.z = dot(tmp0.xyz, tmp0.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp0.yzw = tmp0.yzw * tmp1.zzz;
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
                tmp0.x = tmp0.x - tmp1.x;
                tmp0.x = _BodyLightingContribution * tmp0.x + tmp1.x;
                tmp0.z = tmp1.x * -1.5 + 1.5;
                tmp0.w = saturate(tmp0.x * 2.0 + -1.0);
                tmp1.xzw = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _TopColor.xyz;
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xzw = _TopColor.www * tmp1.xzw + tmp2.xyz;
                tmp3.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _MiddleColor.xyz;
                tmp3.xyz = _MiddleColor.www * tmp3.xyz + tmp2.xyz;
                tmp1.xzw = tmp1.xzw - tmp3.xyz;
                tmp1.xzw = tmp0.xxx * tmp1.xzw + tmp3.xyz;
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _BottomColor.xyz;
                tmp4.xyz = _BottomColor.www * tmp4.xyz + tmp2.xyz;
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + tmp4.xyz;
                tmp1.xzw = tmp1.xzw - tmp3.xyz;
                tmp1.xzw = tmp0.www * tmp1.xzw + tmp3.xyz;
                tmp0.xyw = tmp0.yyy * float3(0.625, 0.625, 0.625) + tmp1.xzw;
                tmp0.xyw = -tmp2.xyz * tmp1.xzw + tmp0.xyw;
                tmp1.xzw = tmp1.xzw * tmp2.xyz;
                tmp0.xyw = tmp0.xyw * float3(0.8, 0.8, 0.8) + tmp1.xzw;
                tmp1.x = dot(tmp0.xyz, float3(0.299, 0.587, 0.114));
                tmp1.xzw = tmp1.xxx - tmp0.xyw;
                tmp1.xzw = tmp1.xzw * float3(0.5, 0.5, 0.5) + tmp0.xyw;
                tmp2.xyz = inp.texcoord2.zzz * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = unity_WorldToObject._m00_m10_m20 * inp.texcoord1.zzz + tmp2.xyz;
                tmp2.xyz = unity_WorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp2.xyz;
                tmp3.xy = inp.texcoord.xy * _CrackNoise_ST.xy + _CrackNoise_ST.zw;
                tmp2.w = _CrackNoiseSpeed * _Time.y;
                tmp3.xy = tmp2.ww * float2(0.06, -3.0) + tmp3.xy;
                tmp3 = tex2D(_CrackNoise, tmp3.xy);
                tmp2.w = tmp3.x * 2.0 + -1.0;
                tmp2.w = tmp2.w * _CrackAmount;
                tmp2.xyz = tmp2.www * float3(0.03, 0.03, 0.03) + tmp2.xyz;
                tmp2 = texCUBE(_Cracks, tmp2.xyz);
                tmp2.y = tmp2.x * -0.25 + 1.0;
                tmp0.z = tmp0.z * tmp2.x;
                tmp0.z = tmp0.z * _CrackAmount;
                tmp1.xzw = tmp1.xzw * tmp2.yyy;
                tmp1.xzw = tmp1.xzw * float3(0.75, 0.75, 0.75) + -tmp0.xyw;
                tmp2.xyw = _Char.xxx * tmp1.zwx + tmp0.ywx;
                tmp0.x = tmp2.x >= tmp2.y;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp4.xy = tmp2.yx;
                tmp5.xy = tmp2.xy - tmp4.xy;
                tmp4.zw = float2(-1.0, 0.6666667);
                tmp5.zw = float2(1.0, -1.0);
                tmp4 = tmp0.xxxx * tmp5 + tmp4;
                tmp0.x = tmp2.w >= tmp4.x;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp2.xyz = tmp4.xyw;
                tmp4.xyw = tmp2.wyx;
                tmp4 = tmp4 - tmp2;
                tmp2 = tmp0.xxxx * tmp4 + tmp2;
                tmp0.x = min(tmp2.y, tmp2.w);
                tmp0.x = tmp2.x - tmp0.x;
                tmp0.y = tmp0.x * 6.0 + 0.0;
                tmp0.w = tmp2.w - tmp2.y;
                tmp0.y = tmp0.w / tmp0.y;
                tmp0.y = tmp0.y + tmp2.z;
                tmp1.xzw = abs(tmp0.yyy) + float3(1.0, 0.6666667, 0.3333333);
                tmp1.xzw = frac(tmp1.xzw);
                tmp1.xzw = tmp1.xzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp1.xzw = saturate(abs(tmp1.xzw) - float3(1.0, 1.0, 1.0));
                tmp1.xzw = tmp1.xzw - float3(1.0, 1.0, 1.0);
                tmp0.y = tmp2.x + 0.0;
                tmp0.x = tmp0.x / tmp0.y;
                tmp0.y = _CrackAmount + 1.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.xyw = tmp0.xxx * tmp1.xzw + float3(1.0, 1.0, 1.0);
                tmp1.xz = tmp0.zz * float2(10.0, 10.0) + float2(-0.8, -0.333);
                tmp4.x = tmp0.z * 40.0;
                tmp4.x = saturate(tmp4.x);
                tmp1.xz = saturate(tmp1.xz * float2(5.0, 2.994012));
                tmp2.yz = tmp1.xz * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp1.xz = tmp1.xz * tmp1.xz;
                tmp1.xz = tmp1.xz * tmp2.yz;
                tmp0.z = tmp1.z * 0.5 + tmp1.x;
                tmp1.x = 1.0 - tmp0.z;
                tmp1.z = 1.0 - tmp3.x;
                tmp1.x = tmp1.x / tmp1.z;
                tmp1.x = saturate(1.0 - tmp1.x);
                tmp1.x = tmp0.z * 0.667 + tmp1.x;
                tmp1.w = _CrackColor.y >= _CrackColor.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp5.xy = _CrackColor.yz;
                tmp5.zw = float2(0.0, -0.3333333);
                tmp6.xy = _CrackColor.zy;
                tmp6.zw = float2(-1.0, 0.6666667);
                tmp5 = tmp5 - tmp6;
                tmp5 = tmp1.wwww * tmp5.xywz + tmp6.xywz;
                tmp1.w = _CrackColor.x >= tmp5.x;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp6.z = tmp5.w;
                tmp5.w = _CrackColor.x;
                tmp6.xyw = tmp5.wyx;
                tmp6 = tmp6 - tmp5;
                tmp5 = tmp1.wwww * tmp6 + tmp5;
                tmp1.w = min(tmp5.y, tmp5.w);
                tmp1.w = tmp5.x - tmp1.w;
                tmp2.y = tmp1.w * 6.0 + 0.0;
                tmp2.z = tmp5.w - tmp5.y;
                tmp2.y = tmp2.z / tmp2.y;
                tmp2.y = tmp2.y + tmp5.z;
                tmp2.z = abs(tmp2.y) + _CrackColorRange;
                tmp2.y = abs(tmp2.y) - _CrackColorRange;
                tmp3.yzw = tmp2.yyy + float3(1.0, 0.6666667, 0.3333333);
                tmp3.yzw = frac(tmp3.yzw);
                tmp3.yzw = tmp3.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp3.yzw = saturate(abs(tmp3.yzw) - float3(1.0, 1.0, 1.0));
                tmp3.yzw = tmp3.yzw - float3(1.0, 1.0, 1.0);
                tmp2.yzw = tmp2.zzz + float3(1.0, 0.6666667, 0.3333333);
                tmp2.yzw = frac(tmp2.yzw);
                tmp2.yzw = tmp2.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp2.yzw = saturate(abs(tmp2.yzw) - float3(1.0, 1.0, 1.0));
                tmp2.yzw = tmp2.yzw - float3(1.0, 1.0, 1.0);
                tmp4.y = tmp5.x + 0.0;
                tmp1.w = tmp1.w / tmp4.y;
                tmp2.yzw = tmp1.www * tmp2.yzw + float3(1.0, 1.0, 1.0);
                tmp3.yzw = tmp1.www * tmp3.yzw + float3(1.0, 1.0, 1.0);
                tmp4.yzw = tmp5.xxx * tmp2.yzw + -_CrackColor.xyz;
                tmp4.yzw = tmp1.zzz * tmp4.yzw + _CrackColor.xyz;
                tmp5.yzw = -tmp5.xxx * tmp3.yzw + _CrackColor.xyz;
                tmp3.yzw = tmp3.yzw * tmp5.xxx;
                tmp5.yzw = tmp1.zzz * tmp5.yzw + tmp3.yzw;
                tmp4.yzw = tmp4.yzw - tmp5.yzw;
                tmp1.xzw = tmp1.xxx * tmp4.yzw + tmp5.yzw;
                tmp6.x = log(tmp1.y);
                tmp6.x = tmp6.x * 0.9;
                tmp6.x = exp(tmp6.x);
                tmp6.x = tmp6.x * -3.0 + 1.0;
                tmp6.y = tmp6.x * _CrackAmount;
                tmp4.yzw = tmp6.yyy * tmp4.yzw + tmp5.yzw;
                tmp4.yzw = _CrackAmount.xxx * tmp6.xxx + tmp4.yzw;
                tmp4.yzw = saturate(tmp4.yzw - float3(1.0, 1.0, 1.0));
                tmp1.xzw = tmp1.xzw * tmp0.zzz + tmp4.yzw;
                tmp1.xzw = tmp1.xzw + tmp1.xzw;
                tmp0.z = inp.texcoord.y * 0.5 + 0.5;
                tmp4.yzw = _CrackAmount.xxx * float3(-0.4, -1.3, -0.25) + float3(1.0, 2.0, 1.0);
                tmp0.z = tmp1.y * tmp0.z + -tmp4.y;
                tmp1.y = tmp4.z - tmp4.y;
                tmp1.y = 1.0 / tmp1.y;
                tmp0.z = saturate(tmp0.z * tmp1.y);
                tmp1.y = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp1.y;
                tmp5.yzw = tmp5.xxx * tmp2.yzw + -tmp3.yzw;
                tmp2.yzw = tmp2.yzw * tmp5.xxx;
                tmp3.yzw = _CrackAmount.xxx * tmp5.yzw + tmp3.yzw;
                tmp3.yzw = tmp3.yzw * _CrackAmount.xxx;
                tmp3.xyz = tmp3.xxx * tmp3.yzw;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp3.xyz = min(tmp3.xyz, float3(1.0, 0.0, 0.0));
                tmp2.yzw = tmp3.xyz * float3(2.0, 2.0, 2.0) + tmp2.yzw;
                tmp1.xyz = tmp2.yzw * tmp0.zzz + tmp1.xzw;
                tmp0.z = tmp4.x * -2.0 + 3.0;
                tmp1.w = tmp4.x * tmp4.x;
                tmp0.z = tmp0.z * tmp1.w;
                tmp0.z = tmp0.z * -0.05 + 1.0;
                tmp0.z = tmp0.z * tmp2.x;
                tmp0.z = tmp4.w * tmp0.z;
                tmp0.xyw = tmp0.zzz * tmp0.ywx + tmp1.yzx;
                tmp1.x = tmp0.x >= tmp0.y;
                tmp1.x = tmp1.x ? 1.0 : 0.0;
                tmp2.xy = tmp0.yx;
                tmp3.xy = tmp0.xy - tmp2.xy;
                tmp2.zw = float2(-1.0, 0.6666667);
                tmp3.zw = float2(1.0, -1.0);
                tmp1 = tmp1.xxxx * tmp3 + tmp2;
                tmp2.x = tmp0.w >= tmp1.x;
                tmp2.x = tmp2.x ? 1.0 : 0.0;
                tmp0.xyz = tmp1.xyw;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp2.xxxx * tmp1 + tmp0;
                tmp1.x = min(tmp0.y, tmp0.w);
                tmp1.x = tmp0.x - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.y = tmp0.w - tmp0.y;
                tmp0.y = tmp0.y / tmp1.y;
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.y = abs(tmp0.y) + _BoomHueShift;
                tmp0.yzw = tmp0.yyy + float3(1.0, 0.6666667, 0.3333333);
                tmp0.yzw = frac(tmp0.yzw);
                tmp0.yzw = tmp0.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.yzw = saturate(abs(tmp0.yzw) - float3(1.0, 1.0, 1.0));
                tmp0.yzw = tmp0.yzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.x + 0.0;
                tmp1.x = tmp1.x / tmp1.y;
                tmp0.yzw = tmp1.xxx * tmp0.yzw + float3(1.0, 1.0, 1.0);
                o.sv_target.xyz = tmp0.yzw * tmp0.xxx;
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
			GpuProgramID 78344
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