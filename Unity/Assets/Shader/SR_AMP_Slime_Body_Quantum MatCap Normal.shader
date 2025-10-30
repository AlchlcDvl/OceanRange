Shader "SR/AMP/Slime/Body/Quantum MatCap Normal" {
	Properties {
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		_LightingUVHorizontalAdjust ("Lighting UV Horizontal Adjust", Range(0, 1)) = 0
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		[Toggle] _GhostToggle ("GhostToggle", Float) = 0
		_LightingUVContribution ("Lighting UV Contribution", Range(0, 1)) = 1
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_Static ("Static", 2D) = "black" {}
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		[HideInInspector] [NoScaleOffset] _PixelNoise ("Pixel Noise", 2D) = "black" {}
		_AvgCycleLength ("AvgCycleLength", Range(0, 10)) = 3
		_Gloss ("Gloss", Range(0, 2)) = 0
		_CycleGlitchRatio ("CycleGlitchRatio", Range(0, 1)) = 1
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_Fade ("Fade", Range(0, 1)) = 1
		[Toggle] _HeldInVac ("HeldInVac", Float) = 0
		[Toggle] _UseOverride ("Enable Matcap Override", Float) = 0
		[NoScaleOffset] _CubemapOverride ("Matcap Override", 2D) = "black" {}
		[Toggle] _OverrideAlphaUV1 ("Override Alpha UV1", Float) = 0
		_OverrideBlend ("Override Blend", Range(0, 1)) = 1
		_NormalPanSpeed ("Normal Pan Speed", Vector) = (0,0,0,0)
		[Toggle] _NormalSmoothTop ("Normal Smooth Top", Float) = 0
		[Toggle] _NormalUV1 ("Normal UV1", Float) = 0
		[NoScaleOffset] [Normal] _Normal ("Normal", 2D) = "bump" {}
		_BodyLightingContribution ("Body Lighting Contribution", Range(0, 1)) = 1
		_Cutoff ("Mask Clip Value", Float) = 0.5
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] _texcoord2 ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "AlphaTest+0" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+0" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			GpuProgramID 19930
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
			float _GhostToggle;
			float4 _TopColor;
			float _OverrideAlphaUV1;
			float _OverrideBlend;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _PixelNoise;
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _Static;
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
                o.texcoord.zw = v.texcoord1.xy * _texcoord2_ST.xy + _texcoord2_ST.zw;
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
                tmp3.x = inp.texcoord1.z;
                tmp3.y = inp.texcoord2.z;
                tmp3.z = inp.texcoord3.z;
                tmp4.x = inp.texcoord1.w;
                tmp4.y = inp.texcoord2.w;
                tmp4.z = inp.texcoord3.w;
                tmp2.xzw = _WorldSpaceCameraPos - tmp4.xyz;
                tmp1.x = dot(tmp2.xyz, tmp2.xyz);
                tmp1.x = max(tmp1.x, 0.001);
                tmp1.x = rsqrt(tmp1.x);
                tmp4.xyz = tmp1.xxx * tmp2.xzw;
                tmp2.xzw = tmp2.xzw * tmp1.xxx + float3(0.0, 1.0, 0.0);
                tmp1.x = dot(tmp3.xyz, tmp4.xyz);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.w = log(tmp1.x);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.x = 1.0 / tmp1.x;
                tmp1.x = tmp1.x - 0.2;
                tmp1.x = saturate(tmp1.x * 1.666667);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.w = tmp1.w * 1.25;
                tmp1.w = exp(tmp1.w);
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.w = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp1.w;
                tmp0.y = tmp0.y * 80.0;
                tmp0.y = round(tmp0.y);
                tmp3.xy = tmp0.yy * float2(0.125, 0.125) + float2(0.0, 0.875);
                tmp3 = tex2D(_PixelNoise, tmp3.xy);
                tmp0.y = tmp0.w * tmp3.x;
                tmp0.w = saturate(-tmp0.x * tmp0.y + 1.0);
                tmp0.y = tmp0.y * tmp0.x;
                tmp0.y = tmp0.y * 4.0;
                tmp0.y = floor(tmp0.y);
                tmp0.w = tmp1.x + tmp0.w;
                tmp0.w = tmp0.w - 0.7;
                tmp0.w = saturate(tmp0.w * 20.0);
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.x = inp.texcoord4.w + 0.0;
                tmp1.w = inp.texcoord4.y / tmp1.x;
                tmp1.w = _Time.y * 0.01 + tmp1.w;
                tmp1.w = tmp1.w * _ScreenParams.y;
                tmp1.w = tmp1.w * 0.25;
                tmp1.w = frac(tmp1.w);
                tmp1.w = tmp1.w + tmp2.y;
                tmp1.w = tmp1.w - 0.48;
                tmp1.w = saturate(tmp1.w * 25.00001);
                tmp2.y = tmp1.w * -2.0 + 3.0;
                tmp1.w = tmp1.w * tmp1.w;
                tmp3.x = tmp2.y * tmp1.w + -1.0;
                tmp1.w = -tmp2.y * tmp1.w + 1.0;
                tmp2.y = tmp0.x * tmp3.x + 1.0;
                tmp1.w = -tmp0.w * tmp2.y + tmp1.w;
                tmp0.w = tmp0.w * tmp2.y;
                tmp0.w = _GhostToggle * tmp1.w + tmp0.w;
                tmp0.w = tmp0.w - _Cutoff;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp3.xyz = inp.texcoord.yxy - float3(1.0, 0.5, -0.0);
                tmp0.w = dot(tmp3.xy, tmp3.xy);
                tmp1.w = saturate(tmp3.x * -1.333333);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = tmp0.w - 0.25;
                tmp0.w = saturate(tmp0.w * 1.333333);
                tmp2.y = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp2.y * tmp0.w + -inp.texcoord.y;
                tmp0.w = _LightingUVHorizontalAdjust * tmp0.w + inp.texcoord.y;
                tmp0.w = tmp0.w - 0.5;
                tmp2.y = tmp0.w * _LightingUVContribution;
                tmp0.w = _LightingUVContribution * tmp0.w + 0.5;
                tmp2.y = -tmp2.y * 2.0 + 1.0;
                tmp3.x = tmp1.w * -2.0 + 3.0;
                tmp1.w = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp3.x;
                tmp3.xy = inp.texcoord.zw - inp.texcoord.xy;
                tmp3.zw = _NormalUV1.xx * tmp3.xy + inp.texcoord.xy;
                tmp3.xy = _OverrideAlphaUV1.xx * tmp3.xy + inp.texcoord.xy;
                tmp5 = tex2D(_CubemapOverride, tmp3.xy);
                tmp3.x = tmp5.w * _OverrideBlend;
                tmp3.yz = _Time.yy * _NormalPanSpeed + tmp3.zw;
                tmp5 = tex2D(_Normal, tmp3.yz);
                tmp5.x = tmp5.w * tmp5.x;
                tmp3.yz = tmp5.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp5.xy = tmp5.xy + tmp5.xy;
                tmp3.y = dot(tmp3.xy, tmp3.xy);
                tmp3.y = min(tmp3.y, 1.0);
                tmp3.y = 1.0 - tmp3.y;
                tmp5.z = sqrt(tmp3.y);
                tmp3.yzw = tmp5.xyz - float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp5.xyz - float3(1.0, 1.0, -0.0);
                tmp3.yzw = tmp1.www * tmp3.yzw + float3(0.0, 0.0, 1.0);
                tmp3.yzw = tmp3.yzw - tmp5.xyz;
                tmp3.yzw = _NormalSmoothTop.xxx * tmp3.yzw + tmp5.xyz;
                tmp5.y = dot(inp.texcoord2.xyz, tmp3.xyz);
                tmp5.x = dot(inp.texcoord1.xyz, tmp3.xyz);
                tmp5.z = dot(inp.texcoord3.xyz, tmp3.xyz);
                tmp1.w = dot(tmp5.xyz, tmp5.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.y = tmp5.y * tmp1.w + 1.0;
                tmp6.xyz = tmp1.www * tmp5.xyz;
                tmp1.w = dot(tmp5.xyz, tmp4.xyz);
                tmp1.w = 1.0 - tmp1.w;
                tmp3.y = saturate(tmp3.y * 0.75 + -0.5);
                tmp3.z = 1.0 - tmp3.y;
                tmp2.y = -tmp2.y * tmp3.z + 1.0;
                tmp3.z = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w > 0.5;
                tmp3.y = tmp3.y * tmp3.z;
                tmp0.w = saturate(tmp0.w ? tmp2.y : tmp3.y);
                tmp0.w = tmp0.w * 0.85;
                tmp2.y = dot(tmp6.xyz, tmp4.xyz);
                tmp2.y = 1.0 - tmp2.y;
                tmp0.w = tmp2.y * tmp2.y + tmp0.w;
                tmp2.y = dot(tmp2.xyz, tmp2.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.xyz = tmp2.yyy * tmp2.xzw;
                tmp2.x = dot(tmp6.xyz, tmp2.xyz);
                tmp2.x = tmp2.x + 1.0;
                tmp2.x = tmp2.x * 0.5;
                tmp2.x = log(tmp2.x);
                tmp2.y = _GlossPower * 16.0 + -1.0;
                tmp2.y = exp(tmp2.y);
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.x = exp(tmp2.x);
                tmp2.y = tmp2.x * tmp2.x;
                tmp2.y = tmp2.y * _Gloss;
                tmp2.x = tmp2.x * tmp2.y;
                tmp0.w = tmp2.x * 0.625 + tmp0.w;
                tmp0.w = saturate(tmp0.w + 0.15);
                tmp0.w = tmp0.w - tmp1.w;
                tmp0.w = _BodyLightingContribution * tmp0.w + tmp1.w;
                tmp1.w = tmp0.w * 0.25 + 0.25;
                tmp0.y = tmp0.y * 0.25 + tmp0.w;
                tmp0.w = 1.0 - tmp1.w;
                tmp2.yzw = tmp4.yyy * unity_MatrixV._m01_m11_m21;
                tmp2.yzw = unity_MatrixV._m00_m10_m20 * tmp4.xxx + tmp2.yzw;
                tmp2.yzw = unity_MatrixV._m02_m12_m22 * tmp4.zzz + tmp2.yzw;
                tmp2.w = tmp2.w * 1.0;
                tmp3.yzw = tmp6.yyy * unity_MatrixV._m01_m11_m21;
                tmp3.yzw = unity_MatrixV._m00_m10_m20 * tmp6.xxx + tmp3.yzw;
                tmp3.yzw = unity_MatrixV._m02_m12_m22 * tmp6.zzz + tmp3.yzw;
                tmp4.z = tmp2.w * tmp3.w;
                tmp4.xy = tmp2.yz * float2(-1.0, -1.0) + tmp3.yz;
                tmp2.y = dot(tmp4.xyz, tmp4.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.yz = tmp2.yy * tmp4.xy;
                tmp2.yz = tmp2.yz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp4 = tex2D(_CubemapOverride, tmp2.yz);
                tmp2.yzw = tmp4.xyz - float3(0.5, 0.5, 0.5);
                tmp2.yzw = -tmp2.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.yzw = -tmp2.yzw * tmp0.www + float3(1.0, 1.0, 1.0);
                tmp3.yzw = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp3.yzw = tmp1.www * tmp3.yzw;
                tmp2.yzw = saturate(tmp4.xyz ? tmp2.yzw : tmp3.yzw);
                tmp0.w = tmp1.x * 0.5;
                tmp1.w = -tmp1.x * 0.5 + inp.texcoord4.y;
                tmp4.y = -tmp1.w * _ProjectionParams.x + tmp0.w;
                tmp4.x = inp.texcoord4.x;
                tmp4.xy = tmp4.xy / tmp1.xx;
                tmp4.z = tmp4.x * 1.78;
                tmp4 = tmp0.zzzz * float4(10.0, 10.0, 10.0, 10.0) + tmp4.zyzy;
                tmp0.zw = _ScreenParams.yy * float2(0.025, 0.05);
                tmp0.zw = float2(128.0, 128.0) / tmp0.zw;
                tmp1.xw = tmp0.zw - float2(1.0, 1.0);
                tmp5 = float4(1.0, 1.0, 1.0, 1.0) / tmp0.zzww;
                tmp0.zw = trunc(tmp1.xw);
                tmp6.xy = tmp5.xw * tmp0.zw;
                tmp6.z = 0.0;
                tmp4 = tmp4 * tmp5 + tmp6.zxzy;
                tmp5 = tex2D(_PixelNoise, tmp4.xy);
                tmp4 = tex2D(_PixelNoise, tmp4.zw);
                tmp0.z = max(tmp4.x, tmp5.z);
                tmp0.z = tmp0.z * 4.0;
                tmp0.z = floor(tmp0.z);
                tmp0.z = tmp0.z * 0.25;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.z = tmp0.z * _GhostToggle;
                tmp0.x = tmp0.x * _GhostToggle;
                tmp0.w = _Time.y * 3.0;
                tmp1.x = sin(tmp0.w);
                tmp4.x = cos(tmp0.w);
                tmp5.z = tmp1.x;
                tmp5.y = tmp4.x;
                tmp5.x = -tmp1.x;
                tmp4.y = dot(tmp1.xy, tmp5.xy);
                tmp4.x = dot(tmp1.xy, tmp5.xy);
                tmp1.xy = tmp4.xy + float2(0.5, 0.5);
                tmp1 = tex2D(_Static, tmp1.xy);
                tmp0.w = tmp1.x - 0.6;
                tmp0.w = tmp0.w * 10.0;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = min(tmp0.w, 0.2);
                tmp0.y = saturate(tmp0.w + tmp0.y);
                tmp0.w = 1.0 - tmp0.y;
                tmp0.w = tmp0.w - tmp0.y;
                tmp0.y = tmp0.z * tmp0.w + tmp0.y;
                tmp0.z = saturate(tmp0.y * 2.0 + -1.0);
                tmp1.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _TopColor.xyz;
                tmp3.yzw = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = _TopColor.www * tmp1.xyz + tmp3.yzw;
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _MiddleColor.xyz;
                tmp4.xyz = _MiddleColor.www * tmp4.xyz + tmp3.yzw;
                tmp1.xyz = tmp1.xyz - tmp4.xyz;
                tmp1.xyz = tmp0.yyy * tmp1.xyz + tmp4.xyz;
                tmp5.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _BottomColor.xyz;
                tmp5.xyz = _BottomColor.www * tmp5.xyz + tmp3.yzw;
                tmp4.xyz = tmp4.xyz - tmp5.xyz;
                tmp4.xyz = tmp0.yyy * tmp4.xyz + tmp5.xyz;
                tmp1.xyz = tmp1.xyz - tmp4.xyz;
                tmp0.yzw = tmp0.zzz * tmp1.xyz + tmp4.xyz;
                tmp1.xyz = tmp2.xxx * float3(0.625, 0.625, 0.625) + tmp0.yzw;
                tmp1.xyz = -tmp3.yzw * tmp0.yzw + tmp1.xyz;
                tmp0.yzw = tmp0.yzw * tmp3.yzw;
                tmp0.yzw = tmp1.xyz * float3(0.8, 0.8, 0.8) + tmp0.yzw;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.yzw;
                tmp1.xyz = tmp1.xyz - tmp0.yzw;
                tmp0.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                tmp1.xyz = tmp2.yzw - tmp0.xyz;
                tmp1.xyz = tmp1.xyz * tmp3.xxx;
                o.sv_target.xyz = _UseOverride.xxx * tmp1.xyz + tmp0.xyz;
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
			GpuProgramID 113494
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