Shader "SR/AMP/Slime/Body/Quantum Attachment" {
	Properties {
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		_Gloss ("Gloss", Range(0, 2)) = 0
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		[NoScaleOffset] _Diffuse ("Attachment AO", 2D) = "white" {}
		[NoScaleOffset] _SaturationMask ("Attachment Mask", 2D) = "white" {}
		[Toggle] _ColorMask ("Attachment Mask Toggle (RGB : R)", Float) = 0
		_RedMask ("Attachment Red Mask", Color) = (1,0,0,1)
		_GreenMask ("Attachment Green Mask", Color) = (0,1,0,1)
		_BlueMask ("Attachment Blue Mask", Color) = (0,0,1,1)
		[Toggle] _GhostToggle ("GhostToggle", Float) = 0
		_Static ("Static", 2D) = "black" {}
		[HideInInspector] [NoScaleOffset] _PixelNoise ("Pixel Noise", 2D) = "black" {}
		_AvgCycleLength ("AvgCycleLength", Range(0, 10)) = 3
		_CycleGlitchRatio ("CycleGlitchRatio", Range(0, 1)) = 1
		_Fade ("Fade", Range(0, 1)) = 1
		[Toggle] _HeldInVac ("HeldInVac", Float) = 0
		_NormalPanSpeed ("Normal Pan Speed", Vector) = (0,0,0,0)
		[Toggle] _NormalSmoothTop ("Normal Smooth Top", Float) = 0
		[Toggle] _NormalUV1 ("Normal UV1", Float) = 0
		[NoScaleOffset] [Normal] _Normal ("Normal", 2D) = "bump" {}
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
			GpuProgramID 52241
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
			float _ColorMask;
			float4 _BottomColor;
			float4 _MiddleColor;
			float _Gloss;
			float _NormalSmoothTop;
			float2 _NormalPanSpeed;
			float _NormalUV1;
			float _GlossPower;
			float4 _TopColor;
			float4 _BlueMask;
			float4 _RedMask;
			float4 _GreenMask;
			float _GhostToggle;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _PixelNoise;
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _Diffuse;
			sampler2D _SaturationMask;
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
                tmp3 = inp.texcoord2.zzzz * unity_MatrixV._m01_m11_m01_m11;
                tmp3 = unity_MatrixV._m00_m10_m00_m10 * inp.texcoord1.zzzz + tmp3;
                tmp3 = unity_MatrixV._m02_m12_m02_m12 * inp.texcoord3.zzzz + tmp3;
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
                tmp1.x = inp.texcoord1.w;
                tmp1.y = inp.texcoord2.w;
                tmp1.z = inp.texcoord3.w;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.001);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + float3(0.0, 1.0, 0.0);
                tmp4.x = inp.texcoord1.z;
                tmp4.y = inp.texcoord2.z;
                tmp4.z = inp.texcoord3.z;
                tmp0.w = dot(tmp4.xyz, tmp2.xyz);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.w = log(tmp0.w);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - 0.2;
                tmp0.w = saturate(tmp0.w * 1.666667);
                tmp1.w = tmp1.w * 1.25;
                tmp1.w = exp(tmp1.w);
                tmp0.z = tmp0.z * tmp1.w;
                tmp1.w = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp1.w;
                tmp0.y = tmp0.y * 80.0;
                tmp0.y = round(tmp0.y);
                tmp3.xz = tmp0.yy * float2(0.125, 0.125) + float2(0.0, 0.875);
                tmp4 = tex2D(_PixelNoise, tmp3.xz);
                tmp0.y = tmp0.z * tmp4.x;
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
                tmp1.w = tmp0.w * tmp0.z + -1.0;
                tmp0.z = -tmp0.w * tmp0.z + 1.0;
                tmp0.x = tmp0.x * tmp1.w + 1.0;
                tmp0.z = -tmp0.y * tmp0.x + tmp0.z;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = _GhostToggle * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x - _Cutoff;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp1.xyz;
                tmp0.w = inp.texcoord.y - 1.0;
                tmp0.w = saturate(tmp0.w * -1.333333);
                tmp1.x = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.xy = inp.texcoord.zw - inp.texcoord.xy;
                tmp1.xy = _NormalUV1.xx * tmp1.xy + inp.texcoord.xy;
                tmp1.xy = _Time.yy * _NormalPanSpeed + tmp1.xy;
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.zw = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xy = tmp1.xy + tmp1.xy;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp3.z = sqrt(tmp1.x);
                tmp1.xyz = tmp3.xyz - float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp3.xyz - float3(1.0, 1.0, -0.0);
                tmp1.xyz = tmp0.www * tmp1.xyz + float3(0.0, 0.0, 1.0);
                tmp1.xyz = tmp1.xyz - tmp3.xyz;
                tmp1.xyz = _NormalSmoothTop.xxx * tmp1.xyz + tmp3.xyz;
                tmp3.x = dot(inp.texcoord1.xyz, tmp1.xyz);
                tmp3.y = dot(inp.texcoord2.xyz, tmp1.xyz);
                tmp3.z = dot(inp.texcoord3.xyz, tmp1.xyz);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp3.yxz;
                tmp0.w = dot(tmp3.xyz, tmp2.xyz);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp1.x = saturate(tmp1.x);
                tmp0.y = tmp1.x * 0.25;
                tmp0.x = tmp0.x + 1.0;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = log(tmp0.x);
                tmp0.z = _GlossPower * 16.0 + -1.0;
                tmp0.z = exp(tmp0.z);
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.x = exp(tmp0.x);
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.z = tmp0.z * _Gloss;
                tmp0.x = tmp0.x * tmp0.z;
                tmp1 = tex2D(_Diffuse, inp.texcoord.xy);
                tmp0.z = tmp0.x * 0.625 + tmp1.x;
                tmp0.x = tmp0.x * 0.625;
                tmp1.y = tmp0.w * tmp0.w;
                tmp1.y = min(tmp1.y, 1.0);
                tmp0.y = saturate(tmp1.y * tmp0.y + tmp0.z);
                tmp0.y = tmp0.w * tmp0.w + tmp0.y;
                tmp2.zw = float2(-1.0, 0.6666667);
                tmp3.zw = float2(1.0, -1.0);
                tmp4 = _RedMask - _BlueMask;
                tmp5 = tex2D(_SaturationMask, inp.texcoord.xy);
                tmp4 = tmp5.xxxx * tmp4 + _BlueMask;
                tmp6 = _GreenMask - tmp4;
                tmp4 = tmp5.yyyy * tmp6 + tmp4;
                tmp6 = _BlueMask - tmp4;
                tmp4 = tmp5.zzzz * tmp6 + tmp4;
                tmp0.z = tmp4.y >= tmp4.z;
                tmp0.z = tmp0.z ? 1.0 : 0.0;
                tmp2.xy = tmp4.zy;
                tmp3.xy = tmp4.yz - tmp2.xy;
                tmp2 = tmp0.zzzz * tmp3.xywz + tmp2.xywz;
                tmp3.z = tmp2.w;
                tmp0.z = tmp4.x >= tmp2.x;
                tmp0.z = tmp0.z ? 1.0 : 0.0;
                tmp2.w = tmp4.x;
                tmp3.xyw = tmp2.wyx;
                tmp3 = tmp3 - tmp2;
                tmp2 = tmp0.zzzz * tmp3 + tmp2;
                tmp0.z = min(tmp2.y, tmp2.w);
                tmp0.z = tmp2.x - tmp0.z;
                tmp0.w = tmp0.z * 6.0 + 0.0;
                tmp1.y = tmp2.w - tmp2.y;
                tmp0.w = tmp1.y / tmp0.w;
                tmp0.w = tmp0.w + tmp2.z;
                tmp1.yzw = abs(tmp0.www) + float3(0.95, 0.6166667, 0.2833333);
                tmp1.yzw = frac(tmp1.yzw);
                tmp1.yzw = tmp1.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp1.yzw = saturate(abs(tmp1.yzw) - float3(1.0, 1.0, 1.0));
                tmp1.yzw = tmp1.yzw - float3(1.0, 1.0, 1.0);
                tmp0.w = tmp2.x + 0.0;
                tmp2.x = tmp4.w * -0.75 + tmp2.x;
                tmp0.z = tmp0.z / tmp0.w;
                tmp0.z = tmp4.w * 0.75 + tmp0.z;
                tmp1.yzw = tmp0.zzz * tmp1.yzw + float3(1.0, 1.0, 1.0);
                tmp2.yzw = -tmp2.xxx * tmp1.yzw + tmp4.xyz;
                tmp1.yzw = tmp1.yzw * tmp2.xxx;
                tmp1.yzw = tmp0.yyy * tmp2.yzw + tmp1.yzw;
                tmp0.z = saturate(tmp0.y * 2.0 + -1.0);
                tmp2.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp2.xyz = tmp0.zzz * tmp2.xyz + _MiddleColor.xyz;
                tmp0.z = tmp0.y + tmp0.y;
                tmp0.z = min(tmp0.z, 1.0);
                tmp3.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp3.xyz = tmp0.zzz * tmp3.xyz + _BottomColor.xyz;
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp0.yzw = tmp0.yyy * tmp2.xyz + tmp3.xyz;
                tmp2.x = dot(tmp0.xyz, float3(0.299, 0.587, 0.114));
                tmp2.xyz = tmp2.xxx - tmp0.yzw;
                tmp0.yzw = tmp5.xxx * tmp2.xyz + tmp0.yzw;
                tmp1.yzw = tmp1.yzw - tmp0.yzw;
                tmp2.x = tmp5.y + tmp5.x;
                tmp2.x = tmp5.z + tmp2.x;
                tmp1.yzw = tmp2.xxx * tmp1.yzw + tmp0.yzw;
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp0.yzw;
                tmp2.w = tmp5.x * -0.5 + 0.5;
                tmp3.xyz = tmp5.xxx * float3(0.4, 0.32, 0.3) + tmp2.www;
                tmp4.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp4.xyz = -tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp4.xyz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp3.xyz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp0.yzw = tmp0.yzw * tmp4.xyz;
                tmp0.yzw = saturate(tmp3.xyz ? tmp2.xyz : tmp0.yzw);
                tmp0.yzw = tmp0.yzw - tmp1.yzw;
                tmp0.yzw = _ColorMask.xxx * tmp0.yzw + tmp1.yzw;
                tmp1.xyz = tmp0.xxx * tmp1.xxx + tmp0.yzw;
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = -tmp2.xyz * tmp0.yzw + tmp1.xyz;
                tmp0.xyz = tmp0.yzw * tmp2.xyz;
                o.sv_target.xyz = tmp1.xyz * float3(0.8, 0.8, 0.8) + tmp0.xyz;
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
			GpuProgramID 90860
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