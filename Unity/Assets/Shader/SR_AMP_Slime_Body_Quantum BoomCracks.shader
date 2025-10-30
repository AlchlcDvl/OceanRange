Shader "SR/AMP/Slime/Body/Quantum BoomCracks" {
	Properties {
		_LightingUVHorizontalAdjust ("Lighting UV Horizontal Adjust", Range(0, 1)) = 0
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		_BodyLightingContribution ("Body Lighting Contribution", Range(0, 1)) = 1
		_LightingUVContribution ("Lighting UV Contribution", Range(0, 1)) = 1
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		[Toggle] _GhostToggle ("GhostToggle", Float) = 0
		_Gloss ("Gloss", Range(0, 2)) = 0
		_Static ("Static", 2D) = "black" {}
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		[HideInInspector] [NoScaleOffset] _PixelNoise ("Pixel Noise", 2D) = "black" {}
		_AvgCycleLength ("AvgCycleLength", Range(0, 10)) = 3
		_CycleGlitchRatio ("CycleGlitchRatio", Range(0, 1)) = 1
		_Fade ("Fade", Range(0, 1)) = 1
		[Toggle] _HeldInVac ("HeldInVac", Float) = 0
		_CrackNoise ("Crack Noise", 2D) = "white" {}
		_CrackNoiseSpeed ("Crack Noise Speed", Float) = 1
		_Cracks ("Cracks", Cube) = "black" {}
		_CrackAmount ("Crack Amount", Range(0, 1)) = 1
		_Char ("Char Amount", Range(0, 1)) = 0
		_CrackColor ("Crack Color", Color) = (1,0.51,0,1)
		_BoomHueShift ("Crack HueShift", Range(-1, 1)) = 0
		_CrackColorRange ("Crack Color Range", Range(-0.15, 0.15)) = 0.1
		_Cutoff ("Mask Clip Value", Float) = 0.5
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "AlphaTest+0" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+0" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			GpuProgramID 16753
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
				float4 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _Fade;
			float _AvgCycleLength;
			float _HeldInVac;
			float _CycleGlitchRatio;
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
			float _GhostToggle;
			float4 _TopColor;
			float _Char;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _PixelNoise;
			// Texture params for Fragment Shader
			sampler2D _CrackNoise;
			samplerCUBE _Cracks;
			sampler2D _Static;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = unity_WorldToObject._m23 + unity_WorldToObject._m03;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = frac(tmp0.x);
                tmp0.x = round(tmp0.x);
                tmp0.y = tmp0.x + _Time.y;
                tmp0.x = tmp0.x * 10.0 + _Time.y;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 0.5;
                tmp0.z = frac(_Time.y);
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.y = tmp0.y / _AvgCycleLength;
                tmp0.xy = frac(tmp0.xy);
                tmp0.z = 1.0 - _CycleGlitchRatio;
                tmp0.z = _HeldInVac * tmp0.z + _CycleGlitchRatio;
                tmp0.y = tmp0.y >= tmp0.z;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.z = v.color.w * _Fade;
                tmp0.z = tmp0.z * 4.0;
                tmp0.z = round(tmp0.z);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.z = tmp0.x * tmp0.z;
                tmp0.xyz = tmp0.xyz * float3(16.0, 0.25, 80.0);
                tmp0.xz = round(tmp0.xz);
                tmp0.zw = tmp0.zz * float2(0.125, 0.125) + float2(0.0, 0.875);
                tmp1 = tex2Dlod(_PixelNoise, float4(tmp0.zw, 0, 0.0));
                tmp0.y = tmp0.y * tmp1.x;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m21_m01_m21;
                tmp1 = unity_ObjectToWorld._m00_m20_m00_m20 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m22_m02_m22 * v.vertex.zzzz + tmp1;
                tmp1 = unity_ObjectToWorld._m03_m23_m03_m23 * v.vertex.wwww + tmp1;
                tmp1 = tmp0.xxxx + tmp1;
                tmp1 = tmp1 * float4(0.125, 0.125, 0.03125, 0.03125) + float4(0.0, 0.875, 0.0, 0.96875);
                tmp2 = tex2Dlod(_PixelNoise, float4(tmp1.xy, 0, 0.0));
                tmp1 = tex2Dlod(_PixelNoise, float4(tmp1.zw, 0, 0.0));
                tmp0.x = max(tmp1.y, tmp2.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp0.zwy * float3(-0.02, 0.2, -0.02);
                tmp1.xyz = tmp1.xyz * tmp0.xxx + v.vertex.xyz;
                tmp2 = tmp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                o.position = tmp2;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord1.w = tmp1.x;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp4.xyz = tmp0.yzw * tmp3.xyz;
                tmp4.xyz = tmp0.wyz * tmp3.yzx + -tmp4.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.z = tmp0.z;
                o.texcoord1.x = tmp3.z;
                o.texcoord2.w = tmp1.y;
                o.texcoord3.w = tmp1.z;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.z = tmp0.w;
                o.texcoord3.z = tmp0.y;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                tmp0.x = tmp2.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp2.xw * float2(0.5, 0.5);
                o.texcoord4.zw = tmp2.zw;
                o.texcoord4.xy = tmp0.zz + tmp0.xw;
                o.color = v.color;
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
                float4 tmp6;
                float4 tmp7;
                tmp0.x = inp.color.w * _Fade;
                tmp0.x = tmp0.x * 4.0;
                tmp0.y = 1.0 - _CycleGlitchRatio;
                tmp0.y = _HeldInVac * tmp0.y + _CycleGlitchRatio;
                tmp0.z = frac(_Time.y);
                tmp0.w = unity_WorldToObject._m23 + unity_WorldToObject._m03;
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = frac(tmp0.w);
                tmp0.xw = round(tmp0.xw);
                tmp1.x = tmp0.w + _Time.y;
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = tmp1.x * 0.25;
                tmp1.x = frac(tmp1.x);
                tmp1.x = tmp1.x * 4.0;
                tmp1.x = round(tmp1.x);
                tmp1.x = tmp1.x * 0.25;
                tmp0.z = tmp0.z / _AvgCycleLength;
                tmp0.z = frac(tmp0.z);
                tmp0.y = tmp0.z >= tmp0.y;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = tmp0.x * 0.25 + _Time.y;
                tmp0.xy = tmp0.xy * float2(0.25, 0.5);
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.y * 64.0;
                tmp0.y = round(tmp0.y);
                tmp0.y = tmp0.y * 0.015625;
                tmp0.z = tmp0.y >= -tmp0.y;
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.z ? tmp0.y : -tmp0.y;
                tmp0.y = tmp0.y * 64.0;
                tmp0.y = round(tmp0.y);
                tmp0.z = tmp0.y < 0.0;
                tmp0.z = tmp0.z ? 64.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.z = tmp0.y * 0.125;
                tmp1.y = tmp0.z >= -tmp0.z;
                tmp0.z = frac(abs(tmp0.z));
                tmp0.z = tmp1.y ? tmp0.z : -tmp0.z;
                tmp0.z = tmp0.z * 8.0;
                tmp0.z = round(tmp0.z);
                tmp0.y = tmp0.y - tmp0.z;
                tmp2.x = tmp0.z * 0.125;
                tmp0.y = tmp0.y * 0.015625;
                tmp0.z = tmp0.y >= -tmp0.y;
                tmp0.y = frac(abs(tmp0.y));
                tmp0.y = tmp0.z ? tmp0.y : -tmp0.y;
                tmp0.y = tmp0.y * 8.0;
                tmp0.y = round(tmp0.y);
                tmp0.y = 7.0 - tmp0.y;
                tmp2.y = tmp0.y * 0.125;
                tmp0.y = tmp0.w * 10.0 + _Time.y;
                tmp0.y = sin(tmp0.y);
                tmp0.y = tmp0.y * 0.5;
                tmp0.y = frac(tmp0.y);
                tmp0.z = tmp0.y * 16.0;
                tmp0.z = round(tmp0.z);
                tmp1.yz = inp.texcoord2.zz * unity_MatrixV._m01_m11;
                tmp1.yz = unity_MatrixV._m00_m10 * inp.texcoord1.zz + tmp1.yz;
                tmp1.yz = unity_MatrixV._m02_m12 * inp.texcoord3.zz + tmp1.yz;
                tmp1.yz = tmp1.yz + float2(1.0, 1.0);
                tmp3 = tmp1.yzyz * float4(0.5, 0.5, 0.5, 0.5) + tmp0.zzzz;
                tmp2.xy = tmp3.xy * float2(0.125, 0.125) + tmp2.xy;
                tmp2 = tex2D(_Static, tmp2.xy);
                tmp1.w = tmp1.x >= -tmp1.x;
                tmp1.x = frac(tmp1.x);
                tmp1.x = tmp1.w ? tmp1.x : -tmp1.x;
                tmp1.x = tmp1.x * 4.0;
                tmp1.x = round(tmp1.x);
                tmp1.w = tmp1.x < 0.0;
                tmp1.w = tmp1.w ? 4.0 : 0.0;
                tmp1.x = tmp1.w + tmp1.x;
                tmp1.w = tmp1.x * 0.5;
                tmp2.x = tmp1.w >= -tmp1.w;
                tmp1.w = frac(abs(tmp1.w));
                tmp1.w = tmp2.x ? tmp1.w : -tmp1.w;
                tmp1.w = tmp1.w + tmp1.w;
                tmp1.w = round(tmp1.w);
                tmp1.x = tmp1.x - tmp1.w;
                tmp2.x = tmp1.w * 0.5;
                tmp1.x = tmp1.x * 0.25;
                tmp1.w = tmp1.x >= -tmp1.x;
                tmp1.x = frac(abs(tmp1.x));
                tmp1.x = tmp1.w ? tmp1.x : -tmp1.x;
                tmp1.x = tmp1.x + tmp1.x;
                tmp1.x = round(tmp1.x);
                tmp1.x = 1.0 - tmp1.x;
                tmp2.y = tmp1.x * 0.5;
                tmp1.xw = tmp3.zw * float2(0.5, 0.5) + tmp2.xy;
                tmp3 = tex2D(_Static, tmp1.xw);
                tmp1.x = max(tmp2.z, tmp3.z);
                tmp2.xy = tmp1.yz * float2(0.5, 0.5) + tmp0.ww;
                tmp1.yz = tmp1.yz * float2(0.5, 0.5) + float2(-0.5, -0.5);
                tmp2.xy = _Time.yy * float2(0.75, -0.25) + tmp2.xy;
                tmp2 = tex2D(_Static, tmp2.xy);
                tmp0.w = tmp1.x + tmp2.y;
                tmp3.x = inp.texcoord1.w;
                tmp3.y = inp.texcoord2.w;
                tmp3.z = inp.texcoord3.w;
                tmp2.xzw = _WorldSpaceCameraPos - tmp3.xyz;
                tmp1.x = dot(tmp2.xyz, tmp2.xyz);
                tmp1.x = max(tmp1.x, 0.001);
                tmp1.x = rsqrt(tmp1.x);
                tmp3.xyz = tmp1.xxx * tmp2.xzw;
                tmp2.xzw = tmp2.xzw * tmp1.xxx + float3(0.0, 1.0, 0.0);
                tmp4.x = inp.texcoord1.z;
                tmp4.z = inp.texcoord3.z;
                tmp4.y = inp.texcoord2.z;
                tmp1.x = dot(tmp4.xyz, tmp3.xyz);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.w = log(tmp1.x);
                tmp1.w = tmp1.w * 1.25;
                tmp1.w = exp(tmp1.w);
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.w = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp1.w;
                tmp0.y = tmp0.y * 80.0;
                tmp0.y = round(tmp0.y);
                tmp5.xy = tmp0.yy * float2(0.125, 0.125) + float2(0.0, 0.875);
                tmp5 = tex2D(_PixelNoise, tmp5.xy);
                tmp0.y = tmp0.w * tmp5.x;
                tmp0.w = saturate(-tmp0.x * tmp0.y + 1.0);
                tmp0.y = tmp0.y * tmp0.x;
                tmp0.y = tmp0.y * 4.0;
                tmp1.w = rsqrt(tmp1.x);
                tmp1.w = 1.0 / tmp1.w;
                tmp1.w = tmp1.w - 0.2;
                tmp1.w = saturate(tmp1.w * 1.666667);
                tmp0.w = tmp0.w - tmp1.w;
                tmp0.w = tmp0.w + 0.3;
                tmp0.w = saturate(tmp0.w * 20.0);
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.w = inp.texcoord4.w + 0.0;
                tmp3.w = inp.texcoord4.y / tmp1.w;
                tmp3.w = _Time.y * 0.01 + tmp3.w;
                tmp3.w = tmp3.w * _ScreenParams.y;
                tmp3.w = tmp3.w * 0.25;
                tmp3.w = frac(tmp3.w);
                tmp2.y = tmp2.y + tmp3.w;
                tmp2.y = tmp2.y - 0.48;
                tmp2.y = saturate(tmp2.y * 25.00001);
                tmp3.w = tmp2.y * -2.0 + 3.0;
                tmp2.y = tmp2.y * tmp2.y;
                tmp4.w = tmp3.w * tmp2.y + -1.0;
                tmp2.y = -tmp3.w * tmp2.y + 1.0;
                tmp3.w = tmp0.x * tmp4.w + 1.0;
                tmp2.y = -tmp0.w * tmp3.w + tmp2.y;
                tmp0.w = tmp0.w * tmp3.w;
                tmp0.w = _GhostToggle * tmp2.y + tmp0.w;
                tmp0.w = tmp0.w - _Cutoff;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = tmp1.w * 0.5;
                tmp2.y = -tmp1.w * 0.5 + inp.texcoord4.y;
                tmp5.y = -tmp2.y * _ProjectionParams.x + tmp0.w;
                tmp5.x = inp.texcoord4.x;
                tmp5.xy = tmp5.xy / tmp1.ww;
                tmp5.z = tmp5.x * 1.78;
                tmp5 = tmp0.zzzz * float4(10.0, 10.0, 10.0, 10.0) + tmp5.zyzy;
                tmp0.zw = _ScreenParams.yy * float2(0.025, 0.05);
                tmp0.zw = float2(128.0, 128.0) / tmp0.zw;
                tmp6.xy = tmp0.zw - float2(1.0, 1.0);
                tmp7 = float4(1.0, 1.0, 1.0, 1.0) / tmp0.zzww;
                tmp0.zw = trunc(tmp6.xy);
                tmp6.xy = tmp7.xw * tmp0.zw;
                tmp6.z = 0.0;
                tmp5 = tmp5 * tmp7 + tmp6.zxzy;
                tmp6 = tex2D(_PixelNoise, tmp5.xy);
                tmp5 = tex2D(_PixelNoise, tmp5.zw);
                tmp0.z = max(tmp5.x, tmp6.z);
                tmp0.z = tmp0.z * 4.0;
                tmp0.yz = floor(tmp0.yz);
                tmp0.z = tmp0.z * 0.25;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.z = tmp0.z * _GhostToggle;
                tmp0.x = tmp0.x * _GhostToggle;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xzw = tmp0.www * tmp4.xyz;
                tmp0.w = tmp4.y * tmp0.w + 1.0;
                tmp0.w = saturate(tmp0.w * 0.75 + -0.5);
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xzw;
                tmp1.w = dot(tmp4.xyz, tmp2.xyz);
                tmp2.x = dot(tmp4.xyz, tmp3.xyz);
                tmp2.x = 1.0 - tmp2.x;
                tmp1.w = tmp1.w + 1.0;
                tmp1.w = tmp1.w * 0.5;
                tmp1.w = log(tmp1.w);
                tmp2.y = _GlossPower * 16.0 + -1.0;
                tmp2.y = exp(tmp2.y);
                tmp1.w = tmp1.w * tmp2.y;
                tmp1.w = exp(tmp1.w);
                tmp2.y = tmp1.w * tmp1.w;
                tmp2.y = tmp2.y * _Gloss;
                tmp1.w = tmp1.w * tmp2.y;
                tmp2.y = _Time.y * 3.0;
                tmp3.x = sin(tmp2.y);
                tmp4.x = cos(tmp2.y);
                tmp5.z = tmp3.x;
                tmp5.y = tmp4.x;
                tmp5.x = -tmp3.x;
                tmp3.y = dot(tmp1.xy, tmp5.xy);
                tmp3.x = dot(tmp1.xy, tmp5.xy);
                tmp1.yz = tmp3.xy + float2(0.5, 0.5);
                tmp3 = tex2D(_Static, tmp1.yz);
                tmp1.y = tmp3.x - 0.6;
                tmp1.y = tmp1.y * 10.0;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = min(tmp1.y, 0.2);
                tmp1.z = 1.0 - tmp0.w;
                tmp2.yz = inp.texcoord.xy - float2(0.5, -0.0);
                tmp2.y = dot(tmp2.xy, tmp2.xy);
                tmp2.y = sqrt(tmp2.y);
                tmp2.y = tmp2.y - 0.25;
                tmp2.y = saturate(tmp2.y * 1.333333);
                tmp2.z = tmp2.y * -2.0 + 3.0;
                tmp2.y = tmp2.y * tmp2.y;
                tmp2.y = tmp2.z * tmp2.y + -inp.texcoord.y;
                tmp2.y = _LightingUVHorizontalAdjust * tmp2.y + inp.texcoord.y;
                tmp2.y = tmp2.y - 0.5;
                tmp2.z = tmp2.y * _LightingUVContribution;
                tmp2.y = _LightingUVContribution * tmp2.y + 0.5;
                tmp2.z = -tmp2.z * 2.0 + 1.0;
                tmp1.z = -tmp2.z * tmp1.z + 1.0;
                tmp2.z = tmp2.y + tmp2.y;
                tmp2.y = tmp2.y > 0.5;
                tmp0.w = tmp0.w * tmp2.z;
                tmp0.w = saturate(tmp2.y ? tmp1.z : tmp0.w);
                tmp0.w = tmp0.w * 0.85;
                tmp0.w = tmp2.x * tmp2.x + tmp0.w;
                tmp0.w = tmp1.w * 0.625 + tmp0.w;
                tmp0.w = saturate(tmp0.w + 0.15);
                tmp0.w = tmp0.w - tmp1.x;
                tmp0.w = _BodyLightingContribution * tmp0.w + tmp1.x;
                tmp1.x = tmp1.x * -1.5 + 1.5;
                tmp0.y = tmp0.y * 0.25 + tmp0.w;
                tmp0.y = saturate(tmp1.y + tmp0.y);
                tmp0.w = tmp0.y * -2.0 + 1.0;
                tmp0.y = tmp0.z * tmp0.w + tmp0.y;
                tmp0.z = saturate(tmp0.y * 2.0 + -1.0);
                tmp2.yzw = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _TopColor.xyz;
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.yzw = _TopColor.www * tmp2.yzw + tmp3.xyz;
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _MiddleColor.xyz;
                tmp4.xyz = _MiddleColor.www * tmp4.xyz + tmp3.xyz;
                tmp2.yzw = tmp2.yzw - tmp4.xyz;
                tmp2.yzw = tmp0.yyy * tmp2.yzw + tmp4.xyz;
                tmp5.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _BottomColor.xyz;
                tmp5.xyz = _BottomColor.www * tmp5.xyz + tmp3.xyz;
                tmp4.xyz = tmp4.xyz - tmp5.xyz;
                tmp4.xyz = tmp0.yyy * tmp4.xyz + tmp5.xyz;
                tmp2.yzw = tmp2.yzw - tmp4.xyz;
                tmp0.yzw = tmp0.zzz * tmp2.yzw + tmp4.xyz;
                tmp1.yzw = tmp1.www * float3(0.625, 0.625, 0.625) + tmp0.yzw;
                tmp1.yzw = -tmp3.xyz * tmp0.yzw + tmp1.yzw;
                tmp0.yzw = tmp0.yzw * tmp3.xyz;
                tmp0.yzw = tmp1.yzw * float3(0.8, 0.8, 0.8) + tmp0.yzw;
                tmp1.yzw = tmp0.yzw * float3(-2.0, -2.0, -2.0) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xxx * tmp1.yzw + tmp0.yzw;
                tmp0.w = dot(tmp0.xyz, float3(0.299, 0.587, 0.114));
                tmp1.yzw = tmp0.www - tmp0.xyz;
                tmp1.yzw = tmp1.yzw * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp2.yzw = inp.texcoord2.zzz * unity_WorldToObject._m01_m11_m21;
                tmp2.yzw = unity_WorldToObject._m00_m10_m20 * inp.texcoord1.zzz + tmp2.yzw;
                tmp2.yzw = unity_WorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp2.yzw;
                tmp3.xy = inp.texcoord.xy * _CrackNoise_ST.xy + _CrackNoise_ST.zw;
                tmp0.w = _CrackNoiseSpeed * _Time.y;
                tmp3.xy = tmp0.ww * float2(0.06, -3.0) + tmp3.xy;
                tmp3 = tex2D(_CrackNoise, tmp3.xy);
                tmp0.w = tmp3.x * 2.0 + -1.0;
                tmp0.w = tmp0.w * _CrackAmount;
                tmp2.yzw = tmp0.www * float3(0.03, 0.03, 0.03) + tmp2.yzw;
                tmp4 = texCUBE(_Cracks, tmp2.yzw);
                tmp0.w = tmp4.x * -0.25 + 1.0;
                tmp1.x = tmp1.x * tmp4.x;
                tmp1.x = tmp1.x * _CrackAmount;
                tmp1.yzw = tmp1.yzw * tmp0.www;
                tmp1.yzw = tmp1.yzw * float3(0.75, 0.75, 0.75) + -tmp0.xyz;
                tmp0.xyw = _Char.xxx * tmp1.zwy + tmp0.yzx;
                tmp4.xy = tmp0.yx;
                tmp5.xy = tmp0.xy - tmp4.xy;
                tmp1.y = tmp4.y >= tmp0.y;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp4.zw = float2(-1.0, 0.6666667);
                tmp5.zw = float2(1.0, -1.0);
                tmp4 = tmp1.yyyy * tmp5 + tmp4;
                tmp1.y = tmp0.w >= tmp4.x;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp0.xyz = tmp4.xyw;
                tmp4.xyw = tmp0.wyx;
                tmp4 = tmp4 - tmp0;
                tmp0 = tmp1.yyyy * tmp4 + tmp0;
                tmp1.y = tmp0.w - tmp0.y;
                tmp0.y = min(tmp0.y, tmp0.w);
                tmp0.y = tmp0.x - tmp0.y;
                tmp0.w = tmp0.y * 6.0 + 0.0;
                tmp0.w = tmp1.y / tmp0.w;
                tmp0.z = tmp0.w + tmp0.z;
                tmp1.yzw = abs(tmp0.zzz) + float3(1.0, 0.6666667, 0.3333333);
                tmp1.yzw = frac(tmp1.yzw);
                tmp1.yzw = tmp1.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp1.yzw = saturate(abs(tmp1.yzw) - float3(1.0, 1.0, 1.0));
                tmp1.yzw = tmp1.yzw - float3(1.0, 1.0, 1.0);
                tmp0.z = tmp0.x + 0.0;
                tmp0.y = tmp0.y / tmp0.z;
                tmp0.z = _CrackAmount + 1.0;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.yzw = tmp0.yyy * tmp1.yzw + float3(1.0, 1.0, 1.0);
                tmp4.x = tmp1.x * 40.0;
                tmp1.xy = tmp1.xx * float2(10.0, 10.0) + float2(-0.8, -0.333);
                tmp1.xy = saturate(tmp1.xy * float2(5.0, 2.994012));
                tmp4.x = saturate(tmp4.x);
                tmp1.z = tmp4.x * -2.0 + 3.0;
                tmp1.w = tmp4.x * tmp4.x;
                tmp1.z = tmp1.w * tmp1.z;
                tmp1.z = tmp1.z * -0.05 + 1.0;
                tmp0.x = tmp0.x * tmp1.z;
                tmp2.yzw = _CrackAmount.xxx * float3(-0.4, -1.3, -0.25) + float3(1.0, 2.0, 1.0);
                tmp0.x = tmp0.x * tmp2.w;
                tmp1.z = inp.texcoord.y * 0.5 + 0.5;
                tmp1.z = tmp2.x * tmp1.z + -tmp2.y;
                tmp1.w = log(tmp2.x);
                tmp1.w = tmp1.w * 0.9;
                tmp1.w = exp(tmp1.w);
                tmp1.w = tmp1.w * -3.0 + 1.0;
                tmp2.x = tmp2.z - tmp2.y;
                tmp2.x = 1.0 / tmp2.x;
                tmp1.z = saturate(tmp1.z * tmp2.x);
                tmp2.x = tmp1.z * -2.0 + 3.0;
                tmp1.z = tmp1.z * tmp1.z;
                tmp1.z = tmp1.z * tmp2.x;
                tmp2.xy = tmp1.xy * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp1.xy = tmp1.xy * tmp1.xy;
                tmp1.xy = tmp1.xy * tmp2.xy;
                tmp1.x = tmp1.y * 0.5 + tmp1.x;
                tmp1.y = 1.0 - tmp1.x;
                tmp2.x = 1.0 - tmp3.x;
                tmp1.y = tmp1.y / tmp2.x;
                tmp1.y = saturate(1.0 - tmp1.y);
                tmp1.y = tmp1.x * 0.667 + tmp1.y;
                tmp2.y = _CrackColor.y >= _CrackColor.z;
                tmp2.y = tmp2.y ? 1.0 : 0.0;
                tmp4.xy = _CrackColor.yz;
                tmp4.zw = float2(0.0, -0.3333333);
                tmp5.xy = _CrackColor.zy;
                tmp5.zw = float2(-1.0, 0.6666667);
                tmp4 = tmp4 - tmp5;
                tmp4 = tmp2.yyyy * tmp4.xywz + tmp5.xywz;
                tmp2.y = _CrackColor.x >= tmp4.x;
                tmp2.y = tmp2.y ? 1.0 : 0.0;
                tmp5.z = tmp4.w;
                tmp4.w = _CrackColor.x;
                tmp5.xyw = tmp4.wyx;
                tmp5 = tmp5 - tmp4;
                tmp4 = tmp2.yyyy * tmp5 + tmp4;
                tmp2.y = min(tmp4.y, tmp4.w);
                tmp2.y = tmp4.x - tmp2.y;
                tmp2.z = tmp2.y * 6.0 + 0.0;
                tmp2.w = tmp4.w - tmp4.y;
                tmp2.z = tmp2.w / tmp2.z;
                tmp2.z = tmp2.z + tmp4.z;
                tmp2.w = abs(tmp2.z) + _CrackColorRange;
                tmp2.z = abs(tmp2.z) - _CrackColorRange;
                tmp3.yzw = tmp2.zzz + float3(1.0, 0.6666667, 0.3333333);
                tmp3.yzw = frac(tmp3.yzw);
                tmp3.yzw = tmp3.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp3.yzw = saturate(abs(tmp3.yzw) - float3(1.0, 1.0, 1.0));
                tmp3.yzw = tmp3.yzw - float3(1.0, 1.0, 1.0);
                tmp4.yzw = tmp2.www + float3(1.0, 0.6666667, 0.3333333);
                tmp4.yzw = frac(tmp4.yzw);
                tmp4.yzw = tmp4.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp4.yzw = saturate(abs(tmp4.yzw) - float3(1.0, 1.0, 1.0));
                tmp4.yzw = tmp4.yzw - float3(1.0, 1.0, 1.0);
                tmp2.z = tmp4.x + 0.0;
                tmp2.y = tmp2.y / tmp2.z;
                tmp4.yzw = tmp2.yyy * tmp4.yzw + float3(1.0, 1.0, 1.0);
                tmp2.yzw = tmp2.yyy * tmp3.yzw + float3(1.0, 1.0, 1.0);
                tmp3.yzw = tmp4.xxx * tmp4.yzw + -_CrackColor.xyz;
                tmp3.yzw = tmp2.xxx * tmp3.yzw + _CrackColor.xyz;
                tmp5.xyz = -tmp4.xxx * tmp2.yzw + _CrackColor.xyz;
                tmp2.yzw = tmp2.yzw * tmp4.xxx;
                tmp5.xyz = tmp2.xxx * tmp5.xyz + tmp2.yzw;
                tmp3.yzw = tmp3.yzw - tmp5.xyz;
                tmp6.xyz = tmp1.yyy * tmp3.yzw + tmp5.xyz;
                tmp1.y = tmp1.w * _CrackAmount;
                tmp3.yzw = tmp1.yyy * tmp3.yzw + tmp5.xyz;
                tmp3.yzw = _CrackAmount.xxx * tmp1.www + tmp3.yzw;
                tmp3.yzw = saturate(tmp3.yzw - float3(1.0, 1.0, 1.0));
                tmp1.xyw = tmp6.xyz * tmp1.xxx + tmp3.yzw;
                tmp1.xyw = tmp1.xyw + tmp1.xyw;
                tmp3.yzw = tmp4.xxx * tmp4.yzw + -tmp2.yzw;
                tmp4.xyz = tmp4.yzw * tmp4.xxx;
                tmp2.xyz = _CrackAmount.xxx * tmp3.yzw + tmp2.yzw;
                tmp2.xyz = tmp2.xyz * _CrackAmount.xxx;
                tmp2.xyz = tmp3.xxx * tmp2.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = min(tmp2.xyz, float3(1.0, 0.0, 0.0));
                tmp2.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + tmp4.xyz;
                tmp1.xyz = tmp2.xyz * tmp1.zzz + tmp1.xyw;
                tmp0.xyw = tmp0.xxx * tmp0.zwy + tmp1.yzx;
                tmp1.xy = tmp0.yx;
                tmp2.xy = tmp0.xy - tmp1.xy;
                tmp3.x = tmp1.y >= tmp0.y;
                tmp3.x = tmp3.x ? 1.0 : 0.0;
                tmp1.zw = float2(-1.0, 0.6666667);
                tmp2.zw = float2(1.0, -1.0);
                tmp1 = tmp3.xxxx * tmp2 + tmp1;
                tmp2.x = tmp0.w >= tmp1.x;
                tmp2.x = tmp2.x ? 1.0 : 0.0;
                tmp0.xyz = tmp1.xyw;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp2.xxxx * tmp1 + tmp0;
                tmp1.x = tmp0.w - tmp0.y;
                tmp0.y = min(tmp0.y, tmp0.w);
                tmp0.y = tmp0.x - tmp0.y;
                tmp0.w = tmp0.y * 6.0 + 0.0;
                tmp0.w = tmp1.x / tmp0.w;
                tmp0.z = tmp0.w + tmp0.z;
                tmp0.z = abs(tmp0.z) + _BoomHueShift;
                tmp1.xyz = tmp0.zzz + float3(1.0, 0.6666667, 0.3333333);
                tmp1.xyz = frac(tmp1.xyz);
                tmp1.xyz = tmp1.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp1.xyz = saturate(abs(tmp1.xyz) - float3(1.0, 1.0, 1.0));
                tmp1.xyz = tmp1.xyz - float3(1.0, 1.0, 1.0);
                tmp0.z = tmp0.x + 0.0;
                tmp0.y = tmp0.y / tmp0.z;
                tmp0.yzw = tmp0.yyy * tmp1.xyz + float3(1.0, 1.0, 1.0);
                o.sv_target.xyz = tmp0.yzw * tmp0.xxx;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest+0" "RenderType" = "TransparentCutout" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 79342
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
				float4 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
				float3 texcoord5 : TEXCOORD5;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float _Fade;
			float _AvgCycleLength;
			float _HeldInVac;
			float _CycleGlitchRatio;
			// $Globals ConstantBuffers for Fragment Shader
			float _GhostToggle;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _PixelNoise;
			// Texture params for Fragment Shader
			sampler2D _Static;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = unity_WorldToObject._m23 + unity_WorldToObject._m03;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = frac(tmp0.x);
                tmp0.x = round(tmp0.x);
                tmp0.y = tmp0.x + _Time.y;
                tmp0.x = tmp0.x * 10.0 + _Time.y;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 0.5;
                tmp0.z = frac(_Time.y);
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.y = tmp0.y / _AvgCycleLength;
                tmp0.xy = frac(tmp0.xy);
                tmp0.z = 1.0 - _CycleGlitchRatio;
                tmp0.z = _HeldInVac * tmp0.z + _CycleGlitchRatio;
                tmp0.y = tmp0.y >= tmp0.z;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.z = v.color.w * _Fade;
                tmp0.z = tmp0.z * 4.0;
                tmp0.z = round(tmp0.z);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.z = tmp0.x * tmp0.z;
                tmp0.xyz = tmp0.xyz * float3(16.0, 0.25, 80.0);
                tmp0.xz = round(tmp0.xz);
                tmp0.zw = tmp0.zz * float2(0.125, 0.125) + float2(0.0, 0.875);
                tmp1 = tex2Dlod(_PixelNoise, float4(tmp0.zw, 0, 0.0));
                tmp0.y = tmp0.y * tmp1.x;
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m21_m01_m21;
                tmp1 = unity_ObjectToWorld._m00_m20_m00_m20 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m22_m02_m22 * v.vertex.zzzz + tmp1;
                tmp1 = unity_ObjectToWorld._m03_m23_m03_m23 * v.vertex.wwww + tmp1;
                tmp1 = tmp0.xxxx + tmp1;
                tmp1 = tmp1 * float4(0.125, 0.125, 0.03125, 0.03125) + float4(0.0, 0.875, 0.0, 0.96875);
                tmp2 = tex2Dlod(_PixelNoise, float4(tmp1.xy, 0, 0.0));
                tmp1 = tex2Dlod(_PixelNoise, float4(tmp1.zw, 0, 0.0));
                tmp0.x = max(tmp1.y, tmp2.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp0.zwy * float3(-0.02, 0.2, -0.02);
                tmp1.xyz = tmp1.xyz * tmp0.xxx + v.vertex.xyz;
                tmp2 = tmp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                o.position = tmp2;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp4.xyz = tmp0.yzw * tmp3.xyz;
                tmp4.xyz = tmp0.wyz * tmp3.yzx + -tmp4.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                o.texcoord.y = tmp4.x;
                o.texcoord.z = tmp0.z;
                o.texcoord.x = tmp3.z;
                o.texcoord1.x = tmp3.x;
                o.texcoord2.x = tmp3.y;
                o.texcoord1.z = tmp0.w;
                o.texcoord2.z = tmp0.y;
                o.texcoord1.y = tmp4.y;
                o.texcoord2.y = tmp4.z;
                o.texcoord3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                tmp1.x = tmp2.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp2.xw * float2(0.5, 0.5);
                o.texcoord4.zw = tmp2.zw;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                o.color = v.color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = inp.color.w * _Fade;
                tmp0.x = tmp0.x * 4.0;
                tmp0.y = 1.0 - _CycleGlitchRatio;
                tmp0.y = _HeldInVac * tmp0.y + _CycleGlitchRatio;
                tmp0.z = frac(_Time.y);
                tmp0.w = unity_WorldToObject._m23 + unity_WorldToObject._m03;
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = frac(tmp0.w);
                tmp0.xw = round(tmp0.xw);
                tmp1.x = tmp0.w + _Time.y;
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = tmp1.x * 0.25;
                tmp1.x = frac(tmp1.x);
                tmp1.x = tmp1.x * 4.0;
                tmp1.x = round(tmp1.x);
                tmp1.x = tmp1.x * 0.25;
                tmp0.z = tmp0.z / _AvgCycleLength;
                tmp0.z = frac(tmp0.z);
                tmp0.y = tmp0.z >= tmp0.y;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = tmp0.x * 0.25 + _Time.y;
                tmp0.xy = tmp0.xy * float2(0.25, 0.5);
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.y * 64.0;
                tmp0.y = round(tmp0.y);
                tmp0.y = tmp0.y * 0.015625;
                tmp0.z = tmp0.y >= -tmp0.y;
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.z ? tmp0.y : -tmp0.y;
                tmp0.y = tmp0.y * 64.0;
                tmp0.y = round(tmp0.y);
                tmp0.z = tmp0.y < 0.0;
                tmp0.z = tmp0.z ? 64.0 : 0.0;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.z = tmp0.y * 0.125;
                tmp1.y = tmp0.z >= -tmp0.z;
                tmp0.z = frac(abs(tmp0.z));
                tmp0.z = tmp1.y ? tmp0.z : -tmp0.z;
                tmp0.z = tmp0.z * 8.0;
                tmp0.z = round(tmp0.z);
                tmp0.y = tmp0.y - tmp0.z;
                tmp2.x = tmp0.z * 0.125;
                tmp0.y = tmp0.y * 0.015625;
                tmp0.z = tmp0.y >= -tmp0.y;
                tmp0.y = frac(abs(tmp0.y));
                tmp0.y = tmp0.z ? tmp0.y : -tmp0.y;
                tmp0.y = tmp0.y * 8.0;
                tmp0.y = round(tmp0.y);
                tmp0.y = 7.0 - tmp0.y;
                tmp2.y = tmp0.y * 0.125;
                tmp0.y = tmp0.w * 10.0 + _Time.y;
                tmp0.y = sin(tmp0.y);
                tmp0.y = tmp0.y * 0.5;
                tmp0.y = frac(tmp0.y);
                tmp0.z = tmp0.y * 16.0;
                tmp0.z = round(tmp0.z);
                tmp3 = inp.texcoord1.zzzz * unity_MatrixV._m01_m11_m01_m11;
                tmp3 = unity_MatrixV._m00_m10_m00_m10 * inp.texcoord.zzzz + tmp3;
                tmp3 = unity_MatrixV._m02_m12_m02_m12 * inp.texcoord2.zzzz + tmp3;
                tmp3 = tmp3 + float4(1.0, 1.0, 1.0, 1.0);
                tmp4 = tmp3 * float4(0.5, 0.5, 0.5, 0.5) + tmp0.zzzz;
                tmp0.zw = tmp3.zw * float2(0.5, 0.5) + tmp0.ww;
                tmp0.zw = _Time.yy * float2(0.75, -0.25) + tmp0.zw;
                tmp3 = tex2D(_Static, tmp0.zw);
                tmp0.zw = tmp4.xy * float2(0.125, 0.125) + tmp2.xy;
                tmp2 = tex2D(_Static, tmp0.zw);
                tmp0.z = tmp1.x >= -tmp1.x;
                tmp0.w = frac(tmp1.x);
                tmp0.z = tmp0.z ? tmp0.w : -tmp0.w;
                tmp0.z = tmp0.z * 4.0;
                tmp0.z = round(tmp0.z);
                tmp0.w = tmp0.z < 0.0;
                tmp0.w = tmp0.w ? 4.0 : 0.0;
                tmp0.z = tmp0.w + tmp0.z;
                tmp0.w = tmp0.z * 0.5;
                tmp1.x = tmp0.w >= -tmp0.w;
                tmp0.w = frac(abs(tmp0.w));
                tmp0.w = tmp1.x ? tmp0.w : -tmp0.w;
                tmp0.w = tmp0.w + tmp0.w;
                tmp0.w = round(tmp0.w);
                tmp0.z = tmp0.z - tmp0.w;
                tmp1.x = tmp0.w * 0.5;
                tmp0.z = tmp0.z * 0.25;
                tmp0.w = tmp0.z >= -tmp0.z;
                tmp0.z = frac(abs(tmp0.z));
                tmp0.z = tmp0.w ? tmp0.z : -tmp0.z;
                tmp0.z = tmp0.z + tmp0.z;
                tmp0.z = round(tmp0.z);
                tmp0.z = 1.0 - tmp0.z;
                tmp1.y = tmp0.z * 0.5;
                tmp0.zw = tmp4.zw * float2(0.5, 0.5) + tmp1.xy;
                tmp1 = tex2D(_Static, tmp0.zw);
                tmp0.z = max(tmp1.z, tmp2.z);
                tmp0.z = tmp0.z + tmp3.y;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.001);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.x = inp.texcoord.z;
                tmp2.y = inp.texcoord1.z;
                tmp2.z = inp.texcoord2.z;
                tmp0.w = dot(tmp2.xyz, tmp1.xyz);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.x = log(tmp0.w);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - 0.2;
                tmp0.w = saturate(tmp0.w * 1.666667);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.x = tmp1.x * 1.25;
                tmp1.x = exp(tmp1.x);
                tmp0.z = tmp0.z * tmp1.x;
                tmp1.x = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp1.x;
                tmp0.y = tmp0.y * 80.0;
                tmp0.y = round(tmp0.y);
                tmp1.xy = tmp0.yy * float2(0.125, 0.125) + float2(0.0, 0.875);
                tmp1 = tex2D(_PixelNoise, tmp1.xy);
                tmp0.y = tmp0.z * tmp1.x;
                tmp0.y = saturate(-tmp0.x * tmp0.y + 1.0);
                tmp0.y = tmp0.w + tmp0.y;
                tmp0.y = tmp0.y - 0.7;
                tmp0.y = saturate(tmp0.y * 20.0);
                tmp0.z = inp.texcoord4.w + 0.0;
                tmp0.z = inp.texcoord4.y / tmp0.z;
                tmp0.z = _Time.y * 0.01 + tmp0.z;
                tmp0.z = tmp0.z * _ScreenParams.y;
                tmp0.z = tmp0.z * 0.25;
                tmp0.z = frac(tmp0.z);
                tmp0.z = tmp0.z + tmp3.y;
                tmp0.z = tmp0.z - 0.48;
                tmp0.z = saturate(tmp0.z * 25.00001);
                tmp0.w = tmp0.z * -2.0 + 3.0;
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp1.x = tmp0.w * tmp0.z + -1.0;
                tmp0.z = -tmp0.w * tmp0.z + 1.0;
                tmp0.x = tmp0.x * tmp1.x + 1.0;
                tmp0.z = -tmp0.y * tmp0.x + tmp0.z;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = _GhostToggle * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x - _Cutoff;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 1.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}