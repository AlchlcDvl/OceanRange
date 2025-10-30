Shader "SR/AMP/Slime/Body/Quantum Galaxy" {
	Properties {
		_LightingUVHorizontalAdjust ("Lighting UV Horizontal Adjust", Range(0, 1)) = 0
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		[NoScaleOffset] _Stars ("Stars", Cube) = "black" {}
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_LightingUVContribution ("Lighting UV Contribution", Range(0, 1)) = 1
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		_SpiralGalaxy ("Spiral Galaxy", 2D) = "black" {}
		_PivotOffset ("Pivot Offset", Vector) = (0,0.5,0,0)
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GalaxyLargoScale ("Galaxy Largo Scale", Range(0, 1)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_BodyLightingContribution ("Body Lighting Contribution", Range(0, 1)) = 1
		_Cutoff ("Mask Clip Value", Float) = 0.5
		[Toggle] _GhostToggle ("GhostToggle", Float) = 0
		_Static ("Static", 2D) = "black" {}
		[HideInInspector] [NoScaleOffset] _PixelNoise ("Pixel Noise", 2D) = "black" {}
		_AvgCycleLength ("AvgCycleLength", Range(0, 10)) = 3
		_CycleGlitchRatio ("CycleGlitchRatio", Range(0, 1)) = 1
		_Fade ("Fade", Range(0, 1)) = 1
		[Toggle] _HeldInVac ("HeldInVac", Float) = 0
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "AlphaTest+0" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+0" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			GpuProgramID 33744
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
			float4 _BottomColor;
			float4 _MiddleColor;
			float4 _PivotOffset;
			float _GalaxyLargoScale;
			float _Gloss;
			float _GlossPower;
			float _LightingUVHorizontalAdjust;
			float _LightingUVContribution;
			float _BodyLightingContribution;
			float _GhostToggle;
			float4 _TopColor;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _PixelNoise;
			// Texture params for Fragment Shader
			samplerCUBE _Stars;
			sampler2D _SpiralGalaxy;
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
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                float4 tmp11;
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
                tmp3.y = inp.texcoord2.w;
                tmp3.x = inp.texcoord1.w;
                tmp3.z = inp.texcoord3.w;
                tmp2.xzw = _WorldSpaceCameraPos - tmp3.xyz;
                tmp1.xw = tmp3.xz - unity_ObjectToWorld._m03_m23;
                tmp3.x = dot(tmp2.xyz, tmp2.xyz);
                tmp3.x = max(tmp3.x, 0.001);
                tmp3.x = rsqrt(tmp3.x);
                tmp3.yzw = tmp2.xzw * tmp3.xxx;
                tmp2.xzw = tmp2.xzw * tmp3.xxx + float3(0.0, 1.0, 0.0);
                tmp4.x = inp.texcoord1.z;
                tmp4.z = inp.texcoord3.z;
                tmp4.y = inp.texcoord2.z;
                tmp3.x = dot(tmp4.xyz, tmp3.xyz);
                tmp3.x = 1.0 - tmp3.x;
                tmp4.w = log(tmp3.x);
                tmp4.w = tmp4.w * 1.25;
                tmp4.w = exp(tmp4.w);
                tmp0.w = tmp0.w * tmp4.w;
                tmp4.w = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp4.w;
                tmp0.y = tmp0.y * 80.0;
                tmp0.y = round(tmp0.y);
                tmp5.xy = tmp0.yy * float2(0.125, 0.125) + float2(0.0, 0.875);
                tmp5 = tex2D(_PixelNoise, tmp5.xy);
                tmp0.y = tmp0.w * tmp5.x;
                tmp0.w = saturate(-tmp0.x * tmp0.y + 1.0);
                tmp0.y = tmp0.y * tmp0.x;
                tmp0.y = tmp0.y * 4.0;
                tmp4.w = rsqrt(tmp3.x);
                tmp4.w = 1.0 / tmp4.w;
                tmp4.w = tmp4.w - 0.2;
                tmp4.w = saturate(tmp4.w * 1.666667);
                tmp0.w = tmp0.w - tmp4.w;
                tmp0.w = tmp0.w + 0.3;
                tmp0.w = saturate(tmp0.w * 20.0);
                tmp0.w = tmp0.w * tmp0.w;
                tmp4.w = inp.texcoord4.w + 0.0;
                tmp5.xy = inp.texcoord4.xy / tmp4.ww;
                tmp5.z = _Time.y * 0.01 + tmp5.y;
                tmp5.z = tmp5.z * _ScreenParams.y;
                tmp5.z = tmp5.z * 0.25;
                tmp5.z = frac(tmp5.z);
                tmp2.y = tmp2.y + tmp5.z;
                tmp2.y = tmp2.y - 0.48;
                tmp2.y = saturate(tmp2.y * 25.00001);
                tmp5.z = tmp2.y * -2.0 + 3.0;
                tmp2.y = tmp2.y * tmp2.y;
                tmp5.w = tmp5.z * tmp2.y + -1.0;
                tmp2.y = -tmp5.z * tmp2.y + 1.0;
                tmp5.z = tmp0.x * tmp5.w + 1.0;
                tmp2.y = -tmp0.w * tmp5.z + tmp2.y;
                tmp0.w = tmp0.w * tmp5.z;
                tmp0.w = _GhostToggle * tmp2.y + tmp0.w;
                tmp0.w = tmp0.w - _Cutoff;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = tmp4.w * 0.5;
                tmp2.y = -tmp4.w * 0.5 + inp.texcoord4.y;
                tmp6.y = -tmp2.y * _ProjectionParams.x + tmp0.w;
                tmp6.x = inp.texcoord4.x;
                tmp6.xy = tmp6.xy / tmp4.ww;
                tmp6.z = tmp6.x * 1.78;
                tmp6 = tmp0.zzzz * float4(10.0, 10.0, 10.0, 10.0) + tmp6.zyzy;
                tmp0.zw = _ScreenParams.yy * float2(0.025, 0.05);
                tmp0.zw = float2(128.0, 128.0) / tmp0.zw;
                tmp5.zw = tmp0.zw - float2(1.0, 1.0);
                tmp7 = float4(1.0, 1.0, 1.0, 1.0) / tmp0.zzww;
                tmp0.zw = trunc(tmp5.zw);
                tmp8.xy = tmp7.xw * tmp0.zw;
                tmp8.z = 0.0;
                tmp6 = tmp6 * tmp7 + tmp8.zxzy;
                tmp7 = tex2D(_PixelNoise, tmp6.xy);
                tmp6 = tex2D(_PixelNoise, tmp6.zw);
                tmp0.z = max(tmp6.x, tmp7.z);
                tmp0.z = tmp0.z * 4.0;
                tmp0.yz = floor(tmp0.yz);
                tmp0.z = tmp0.z * 0.25;
                tmp0.w = tmp0.z * _GhostToggle;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.x = tmp0.x * _GhostToggle;
                tmp0.z = dot(tmp4.xyz, tmp4.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp4.xzw = tmp0.zzz * tmp4.xyz;
                tmp0.z = tmp4.y * tmp0.z + 1.0;
                tmp0.z = saturate(tmp0.z * 0.75 + -0.5);
                tmp2.y = dot(tmp4.xyz, tmp3.xyz);
                tmp6 = texCUBE(_Stars, tmp3.yzw);
                tmp3.y = saturate(tmp6.x * 5.0);
                tmp2.y = 1.0 - tmp2.y;
                tmp3.z = 1.0 - tmp0.z;
                tmp5.zw = inp.texcoord.xy - float2(0.5, -0.0);
                tmp3.w = dot(tmp5.xy, tmp5.xy);
                tmp3.w = sqrt(tmp3.w);
                tmp3.w = tmp3.w - 0.25;
                tmp3.w = saturate(tmp3.w * 1.333333);
                tmp4.y = tmp3.w * -2.0 + 3.0;
                tmp3.w = tmp3.w * tmp3.w;
                tmp3.w = tmp4.y * tmp3.w + -inp.texcoord.y;
                tmp3.w = _LightingUVHorizontalAdjust * tmp3.w + inp.texcoord.y;
                tmp3.w = tmp3.w - 0.5;
                tmp4.y = tmp3.w * _LightingUVContribution;
                tmp3.w = _LightingUVContribution * tmp3.w + 0.5;
                tmp4.y = -tmp4.y * 2.0 + 1.0;
                tmp3.z = -tmp4.y * tmp3.z + 1.0;
                tmp4.y = tmp3.w + tmp3.w;
                tmp3.w = tmp3.w > 0.5;
                tmp0.z = tmp0.z * tmp4.y;
                tmp0.z = saturate(tmp3.w ? tmp3.z : tmp0.z);
                tmp0.z = tmp0.z * 0.85;
                tmp0.z = tmp2.y * tmp2.y + tmp0.z;
                tmp2.y = dot(tmp2.xyz, tmp2.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.xyz = tmp2.yyy * tmp2.xzw;
                tmp2.x = dot(tmp4.xyz, tmp2.xyz);
                tmp2.x = tmp2.x + 1.0;
                tmp2.x = tmp2.x * 0.5;
                tmp2.x = log(tmp2.x);
                tmp4 = float4(_GalaxyLargoScale.xxx, _GlossPower.x) * float4(-0.5, -0.15, -0.133, 16.0) + float4(1.0, 0.4, 0.8, -1.0);
                tmp2.y = exp(tmp4.w);
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.x = exp(tmp2.x);
                tmp2.y = tmp2.x * tmp2.x;
                tmp2.y = tmp2.y * _Gloss;
                tmp2.x = tmp2.x * tmp2.y;
                tmp0.z = tmp2.x * 0.625 + tmp0.z;
                tmp0.z = saturate(tmp0.z + 0.15);
                tmp0.z = tmp0.z - tmp3.x;
                tmp0.z = _BodyLightingContribution * tmp0.z + tmp3.x;
                tmp0.z = tmp0.z * -0.75 + 1.0;
                tmp1.xw = tmp1.xw - tmp4.zz;
                tmp1.xw = tmp4.yy * tmp1.xw + tmp4.zz;
                tmp1.xw = tmp1.xw - float2(0.5, 0.5);
                tmp2.yz = _Time.yy * float2(-2.5, -3.0);
                tmp6.x = sin(tmp2.z);
                tmp7.x = cos(tmp2.z);
                tmp8.x = sin(tmp2.y);
                tmp9.x = cos(tmp2.y);
                tmp10.z = tmp6.x;
                tmp10.y = tmp7.x;
                tmp10.x = -tmp6.x;
                tmp6.y = dot(tmp1.xy, tmp10.xy);
                tmp6.x = dot(tmp1.xy, tmp10.xy);
                tmp1.xw = tmp6.xy + float2(0.5, 0.5);
                tmp6 = tex2D(_SpiralGalaxy, tmp1.xw);
                tmp7.x = unity_ObjectToWorld._m00;
                tmp7.y = unity_ObjectToWorld._m01;
                tmp7.z = unity_ObjectToWorld._m02;
                tmp1.x = dot(tmp7.xyz, tmp7.xyz);
                tmp7.x = unity_ObjectToWorld._m10;
                tmp7.y = unity_ObjectToWorld._m11;
                tmp7.z = unity_ObjectToWorld._m12;
                tmp1.w = dot(tmp7.xyz, tmp7.xyz);
                tmp1.xw = sqrt(tmp1.xw);
                tmp1.x = tmp1.w + tmp1.x;
                tmp7.x = unity_ObjectToWorld._m20;
                tmp7.y = unity_ObjectToWorld._m21;
                tmp7.z = unity_ObjectToWorld._m22;
                tmp1.w = dot(tmp7.xyz, tmp7.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp1.x = tmp1.w + tmp1.x;
                tmp7.xy = tmp1.xx * float2(0.3333333, 0.1666667);
                tmp2.yzw = _PivotOffset.xyz + unity_ObjectToWorld._m03_m13_m23;
                tmp7.z = 0.0;
                tmp2.yzw = tmp2.yzw + tmp7.zyz;
                tmp4.yzw = tmp2.zzz * unity_MatrixVP._m01_m11_m31;
                tmp4.yzw = unity_MatrixVP._m00_m10_m30 * tmp2.yyy + tmp4.yzw;
                tmp2.yzw = unity_MatrixVP._m02_m12_m32 * tmp2.www + tmp4.yzw;
                tmp2.yzw = tmp2.yzw + unity_MatrixVP._m03_m13_m33;
                tmp10.xy = tmp2.yz / tmp2.ww;
                tmp11.y = _ScreenParams.y / _ScreenParams.x;
                tmp10.z = tmp10.y * tmp11.y;
                tmp1.xw = tmp10.xz * float2(0.5, -0.5);
                tmp10.xy = tmp5.xy - float2(0.5, 0.5);
                tmp5 = tmp5.xyxy * float4(1.1, 1.1, 0.8, 0.8);
                tmp5 = _Time * float4(0.134, 0.066, -0.2, -0.1) + tmp5;
                tmp10.z = tmp10.y * 2.0;
                tmp11.x = 2.0;
                tmp2.yz = tmp10.xz * tmp11.xy + float2(1.0, 1.0);
                tmp1.xw = tmp2.yz * float2(0.5, 0.5) + -tmp1.xw;
                tmp1.xw = tmp1.xw - float2(0.5, 0.5);
                tmp2.y = unity_ObjectToWorld._m13 * unity_MatrixV._m21;
                tmp2.y = unity_MatrixV._m20 * unity_ObjectToWorld._m03 + tmp2.y;
                tmp2.y = unity_MatrixV._m22 * unity_ObjectToWorld._m23 + tmp2.y;
                tmp2.y = tmp2.y + unity_MatrixV._m23;
                tmp2.y = tmp2.y / tmp7.x;
                tmp2.y = tmp2.y * 0.75;
                tmp1.xw = tmp1.xw * tmp2.yy;
                tmp1.xw = tmp4.xx * tmp1.xw;
                tmp4.z = tmp8.x;
                tmp4.y = tmp9.x;
                tmp4.x = -tmp8.x;
                tmp7.y = dot(tmp1.xy, tmp4.xy);
                tmp7.x = dot(tmp1.xy, tmp4.xy);
                tmp1.xw = tmp7.xy + float2(0.5, 0.5);
                tmp4 = tex2D(_SpiralGalaxy, tmp1.xw);
                tmp1.x = tmp4.z + 0.5;
                tmp4 = tex2D(_SpiralGalaxy, tmp5.xy);
                tmp5 = tex2D(_SpiralGalaxy, tmp5.zw);
                tmp1.w = tmp4.y * tmp5.y;
                tmp2.y = tmp1.w * 0.5 + 0.5;
                tmp1.w = saturate(dot(tmp3.xy, tmp1.xy));
                tmp1.x = tmp1.x * tmp2.y;
                tmp1.x = tmp6.x * tmp1.x;
                tmp1.x = tmp1.x * 4.0;
                tmp0.z = tmp0.z * tmp1.x;
                tmp1.x = tmp1.w * -2.0 + 3.0;
                tmp1.w = tmp1.w * tmp1.w;
                tmp0.z = tmp1.x * tmp1.w + tmp0.z;
                tmp0.z = tmp3.x * tmp3.x + tmp0.z;
                tmp0.y = tmp0.y * 0.25 + tmp0.z;
                tmp0.z = _Time.y * 3.0;
                tmp1.x = sin(tmp0.z);
                tmp3.x = cos(tmp0.z);
                tmp4.z = tmp1.x;
                tmp4.y = tmp3.x;
                tmp4.x = -tmp1.x;
                tmp3.y = dot(tmp1.xy, tmp4.xy);
                tmp3.x = dot(tmp1.xy, tmp4.xy);
                tmp1.xy = tmp3.xy + float2(0.5, 0.5);
                tmp1 = tex2D(_Static, tmp1.xy);
                tmp0.z = tmp1.x - 0.6;
                tmp0.z = tmp0.z * 10.0;
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = min(tmp0.z, 0.2);
                tmp0.y = saturate(tmp0.z + tmp0.y);
                tmp0.z = tmp0.y * -2.0 + 1.0;
                tmp0.y = tmp0.w * tmp0.z + tmp0.y;
                tmp0.z = saturate(tmp0.y * 2.0 + -1.0);
                tmp1.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _TopColor.xyz;
                tmp2.yzw = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = _TopColor.www * tmp1.xyz + tmp2.yzw;
                tmp3.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _MiddleColor.xyz;
                tmp3.xyz = _MiddleColor.www * tmp3.xyz + tmp2.yzw;
                tmp1.xyz = tmp1.xyz - tmp3.xyz;
                tmp1.xyz = tmp0.yyy * tmp1.xyz + tmp3.xyz;
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _BottomColor.xyz;
                tmp4.xyz = _BottomColor.www * tmp4.xyz + tmp2.yzw;
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp3.xyz = tmp0.yyy * tmp3.xyz + tmp4.xyz;
                tmp1.xyz = tmp1.xyz - tmp3.xyz;
                tmp0.yzw = tmp0.zzz * tmp1.xyz + tmp3.xyz;
                tmp1.xyz = tmp2.xxx * float3(0.625, 0.625, 0.625) + tmp0.yzw;
                tmp1.xyz = -tmp2.yzw * tmp0.yzw + tmp1.xyz;
                tmp0.yzw = tmp0.yzw * tmp2.yzw;
                tmp0.yzw = tmp1.xyz * float3(0.8, 0.8, 0.8) + tmp0.yzw;
                tmp1.xyz = tmp0.yzw * float3(-2.0, -2.0, -2.0) + float3(1.0, 1.0, 1.0);
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
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
			GpuProgramID 123030
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
                tmp0.y = tmp0.y - tmp0.w;
                tmp0.y = tmp0.y + 0.3;
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