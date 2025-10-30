Shader "SR/Paintlight/SandSea" {
	Properties {
		_WaveMap ("Wave Map", 2D) = "white" {}
		_NormalStrength ("Normal Strength", Float) = 5
		_WaveSpeed ("Wave Speed", Float) = 0.25
		_WaveEnergy ("Wave Energy", Float) = 1
		_WaveScale ("Wave Scale", Float) = 0.4
		_WaveOffset ("Wave Offset", Float) = 0
		_WaveNoise ("Wave Noise", 2D) = "white" {}
		_DetailNoiseMask ("Detail Noise Mask", 2D) = "black" {}
		_TopperDepth ("Topper Depth", 2D) = "gray" {}
		_Topper_MainTex ("Topper _MainTex", 2D) = "white" {}
		_TopperDetailTex ("Topper Detail Tex", 2D) = "white" {}
		[MaterialToggle] _TopperEnableDetailTex ("Topper Enable Detail Tex", Float) = 0
		_TopperCoverage ("Topper Coverage", Range(0, 2)) = 1
		_TopperDepthStrength ("Topper Depth Strength", Float) = 1
		_TopperSpecular ("Topper Specular", 2D) = "black" {}
		_Gloss ("Gloss", Range(0, 1)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_TopperSpecularNoiseAdjust ("Topper Specular Noise Adjust", Range(0, 1)) = 0.5
		_SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_WindTurbulance ("Wind Turbulance", Float) = 2
		_WindStrength ("Wind Strength", Float) = 0
		_WindSpeed ("Wind Speed", Float) = 1
		_CrestSpeed ("CrestSpeed", Float) = 1
		_ColorTop ("Color Top", Color) = (0.5,0.5,0.5,1)
		_ColorBottom ("Color Bottom", Color) = (0.5,0.5,0.5,1)
		_LowDetail ("LowDetail", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 22569
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			float _WaveScale;
			float4 _WaveNoise_ST;
			float _WaveEnergy;
			float _WaveOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _WaveMap_ST;
			float _WaveSpeed;
			float _NormalStrength;
			float4 _DetailNoiseMask_ST;
			float4 _TopperDepth_ST;
			float4 _Topper_MainTex_ST;
			float4 _TopperDetailTex_ST;
			float _TopperEnableDetailTex;
			float _TopperCoverage;
			float _TopperDepthStrength;
			float4 _TopperSpecular_ST;
			float _Gloss;
			float _GlossPower;
			float _TopperSpecularNoiseAdjust;
			float4 _SpecularColor;
			float _WindTurbulance;
			float _WindStrength;
			float _WindSpeed;
			float _CrestSpeed;
			float4 _ColorTop;
			float4 _ColorBottom;
			float4 _LowDetail_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _WaveNoise;
			// Texture params for Fragment Shader
			sampler2D _WaveMap;
			sampler2D _Topper_MainTex;
			sampler2D _LowDetail;
			sampler2D _TopperDetailTex;
			sampler2D _TopperSpecular;
			sampler2D _TopperDepth;
			sampler2D _DetailNoiseMask;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m21_m01_m21_m01;
                tmp0 = unity_ObjectToWorld._m20_m00_m20_m00 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m22_m02_m22_m02 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m23_m03_m23_m03 * v.vertex.wwww + tmp0;
                tmp1.x = _TimeEditor.y + _Time.y;
                tmp1.y = tmp1.x * 0.0167;
                tmp0.xy = tmp0.xy * float2(0.0125, 0.0125) + tmp1.yy;
                tmp0.xy = tmp0.xy * _WaveNoise_ST.xy + _WaveNoise_ST.zw;
                tmp2 = tex2Dlod(_WaveNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.xy = tmp0.zw * float2(0.025, 0.025) + tmp2.xx;
                tmp0.xy = tmp1.xx * float2(-0.1, -0.1) + tmp0.xy;
                tmp0.xy = tmp0.xy * _WaveEnergy.xx;
                tmp0.zw = floor(tmp0.xy);
                tmp0.z = tmp0.w * 57.0 + tmp0.z;
                tmp1.xyz = tmp0.zzz + float3(1.0, 57.0, 58.0);
                tmp2.x = sin(tmp0.z);
                tmp2.yzw = sin(tmp1.xyz);
                tmp1 = tmp2 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp1 = frac(tmp1);
                tmp0.zw = tmp1.yw - tmp1.xz;
                tmp1.yw = frac(tmp0.xy);
                tmp0.xy = tmp0.xy + tmp0.xy;
                tmp2.xy = tmp1.yw * tmp1.yw;
                tmp1.yw = -tmp1.yw * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp1.yw = tmp1.yw * tmp2.xy;
                tmp0.zw = tmp1.yy * tmp0.zw + tmp1.xz;
                tmp0.w = tmp0.w - tmp0.z;
                tmp0.z = tmp1.w * tmp0.w + tmp0.z;
                tmp1.xy = floor(tmp0.xy);
                tmp0.xy = frac(tmp0.xy);
                tmp0.w = tmp1.y * 57.0 + tmp1.x;
                tmp1.xyz = tmp0.www + float3(1.0, 57.0, 58.0);
                tmp2.x = sin(tmp0.w);
                tmp2.yzw = sin(tmp1.xyz);
                tmp1 = tmp2 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp1 = frac(tmp1);
                tmp1.yw = tmp1.yw - tmp1.xz;
                tmp2.xy = tmp0.xy * tmp0.xy;
                tmp0.xy = -tmp0.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp2.xy;
                tmp0.xw = tmp0.xx * tmp1.yw + tmp1.xz;
                tmp0.w = tmp0.w - tmp0.x;
                tmp0.x = tmp0.y * tmp0.w + tmp0.x;
                tmp0.x = tmp0.z * 2.0 + tmp0.x;
                tmp0.x = saturate(tmp0.x * 0.5);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.yzw = v.normal.xyz * _WaveScale.xxx;
                tmp1.xz = tmp0.xx * tmp0.yw;
                tmp1.y = tmp0.z * tmp0.x + _WaveOffset;
                tmp0.xyz = tmp1.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp8;
                float4 tmp9;
                tmp0 = _TimeEditor + _Time;
                tmp1.x = tmp0.x > 0.0;
                tmp1.y = tmp0.x < 0.0;
                tmp1.x = tmp1.y - tmp1.x;
                tmp1.x = floor(tmp1.x);
                tmp1.yz = tmp0.xx * float2(0.0025, 0.0167);
                tmp2 = inp.texcoord.zxzx * float4(0.0125, 0.0125, 0.0125, 0.0125) + tmp1.yyzz;
                tmp2 = tmp2 * _WaveNoise_ST + _WaveNoise_ST;
                tmp3 = tex2D(_WaveNoise, tmp2.xy);
                tmp2 = tex2D(_WaveNoise, tmp2.zw);
                tmp1.yz = inp.texcoord.zx * float2(0.025, 0.025) + tmp2.xx;
                tmp1.yz = tmp0.xx * float2(-0.1, -0.1) + tmp1.yz;
                tmp1.yz = tmp1.yz * _WaveEnergy.xx;
                tmp2 = inp.texcoord.zxzx * float4(0.0125, 0.0125, 0.025, 0.025);
                tmp1.w = tmp3.x * 0.2 + tmp2.x;
                tmp3.x = tmp1.x * 0.1 + tmp1.w;
                tmp0.x = tmp0.x * _WaveSpeed;
                tmp2 = tmp0.xxxx * float4(-0.15, -0.15, 0.3, 0.3) + tmp2;
                tmp3.yz = float2(0.0, 0.04);
                tmp4 = tmp2.xyxy + tmp3.xyyx;
                tmp4 = tmp3.zxxz + tmp4;
                tmp4 = tmp4 * _WaveMap_ST + _WaveMap_ST;
                tmp5 = tex2D(_WaveMap, tmp4.xy);
                tmp4 = tex2D(_WaveMap, tmp4.zw);
                tmp6 = tmp3.xxxx + tmp2;
                tmp6 = tmp6 * _WaveMap_ST + _WaveMap_ST;
                tmp7 = tex2D(_WaveMap, tmp6.xy);
                tmp6 = tex2D(_WaveMap, tmp6.zw);
                tmp0.x = tmp7.x - tmp5.x;
                tmp1.x = tmp7.x - tmp4.x;
                tmp1.w = saturate(_NormalStrength);
                tmp4.x = tmp0.x * tmp1.w;
                tmp4.y = tmp1.x * tmp1.w;
                tmp0.x = dot(tmp4.xy, tmp4.xy);
                tmp0.x = 1.0 - tmp0.x;
                tmp5 = tmp2.zwzw + tmp3.xyyx;
                tmp3 = tmp3.zxxz + tmp5;
                tmp3 = tmp3 * _WaveMap_ST + _WaveMap_ST;
                tmp2 = tmp2 * _WaveMap_ST + _WaveMap_ST;
                tmp5 = tex2D(_WaveMap, tmp3.xy);
                tmp3 = tex2D(_WaveMap, tmp3.zw);
                tmp1.x = tmp6.x - tmp3.x;
                tmp3.x = tmp6.x - tmp5.x;
                tmp3.x = tmp1.w * tmp3.x;
                tmp3.y = tmp1.x * tmp1.w;
                tmp1.x = dot(tmp3.xy, tmp3.xy);
                tmp3.z = tmp0.x - tmp1.x;
                tmp4.z = 1.0;
                tmp3.xyz = tmp3.xyz + tmp4.xyz;
                tmp4.xyz = tmp3.xyz * float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(0.5, 0.5, 0.5) + float3(0.0, 0.0, 1.0);
                tmp1.xw = floor(tmp1.yz);
                tmp0.x = tmp1.w * 57.0 + tmp1.x;
                tmp5.xyz = tmp0.xxx + float3(1.0, 57.0, 58.0);
                tmp6.x = sin(tmp0.x);
                tmp6.yzw = sin(tmp5.xyz);
                tmp5 = tmp6 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp5 = frac(tmp5);
                tmp1.xw = tmp5.yw - tmp5.xz;
                tmp5.yw = frac(tmp1.yz);
                tmp1.yz = tmp1.yz + tmp1.yz;
                tmp6.xy = tmp5.yw * tmp5.yw;
                tmp5.yw = -tmp5.yw * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp5.yw = tmp5.yw * tmp6.xy;
                tmp1.xw = tmp5.yy * tmp1.xw + tmp5.xz;
                tmp0.x = tmp1.w - tmp1.x;
                tmp0.x = tmp5.w * tmp0.x + tmp1.x;
                tmp1.xw = floor(tmp1.yz);
                tmp1.yz = frac(tmp1.yz);
                tmp1.x = tmp1.w * 57.0 + tmp1.x;
                tmp5.xyz = tmp1.xxx + float3(1.0, 57.0, 58.0);
                tmp6.x = sin(tmp1.x);
                tmp6.yzw = sin(tmp5.xyz);
                tmp5 = tmp6 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp5 = frac(tmp5);
                tmp1.xw = tmp5.yw - tmp5.xz;
                tmp5.yw = tmp1.yz * tmp1.yz;
                tmp1.yz = -tmp1.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp1.yz = tmp1.yz * tmp5.yw;
                tmp1.xy = tmp1.yy * tmp1.xw + tmp5.xz;
                tmp1.y = tmp1.y - tmp1.x;
                tmp1.x = tmp1.z * tmp1.y + tmp1.x;
                tmp0.x = tmp0.x * 2.0 + tmp1.x;
                tmp1.x = tmp0.x * 0.5;
                tmp1.yzw = tmp0.xxx * float3(-0.125, -16.66666, -1.25) + float3(1.0, 5.0, 1.0);
                tmp3.xyz = saturate(tmp1.xxx * tmp3.xyz + tmp4.xyz);
                tmp1.xyz = saturate(tmp1.xyz);
                tmp4.xyz = tmp3.yyy * inp.texcoord3.xyz;
                tmp3.xyw = tmp3.xxx * inp.texcoord2.xyz + tmp4.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp4.xyz = tmp0.xxx * inp.texcoord1.xyz;
                tmp3.xyz = tmp3.zzz * tmp4.xyz + tmp3.xyw;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.x = saturate(tmp3.y);
                tmp5.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp3.w = dot(tmp5.xyz, tmp5.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp5.xyz = tmp3.www * tmp5.xyz;
                tmp3.w = dot(tmp3.xyz, tmp5.xyz);
                tmp3.w = max(tmp3.w, 0.0);
                tmp3.w = 1.0 - tmp3.w;
                tmp4.w = tmp3.w * tmp3.w;
                tmp4.w = tmp3.w * tmp4.w;
                tmp0.x = tmp0.x * tmp4.w;
                tmp6 = tex2D(_WaveMap, tmp2.xy);
                tmp2 = tex2D(_WaveMap, tmp2.zw);
                tmp2.y = 1.0 - tmp6.x;
                tmp2.z = dot(tmp6.xy, tmp2.xy);
                tmp2.w = tmp2.x - 0.5;
                tmp2.x = tmp2.x > 0.5;
                tmp2.w = -tmp2.w * 2.0 + 1.0;
                tmp2.y = -tmp2.w * tmp2.y + 1.0;
                tmp2.x = saturate(tmp2.x ? tmp2.y : tmp2.z);
                tmp1.x = tmp1.x * -tmp2.x + tmp2.x;
                tmp0.x = tmp0.x * tmp1.y + tmp1.x;
                tmp1.x = tmp1.z * 0.5;
                tmp1.x = saturate(tmp1.w * 0.5 + tmp1.x);
                tmp0.x = tmp0.x + tmp1.x;
                tmp1.xyz = _ColorTop.xyz - _ColorBottom.xyz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz + _ColorBottom.xyz;
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp0.w = tmp0.w * _WindSpeed;
                tmp1.w = inp.texcoord.x * _WindTurbulance;
                tmp0.w = tmp0.w * 5.0 + tmp1.w;
                tmp0.w = tmp0.w * 0.1061033;
                tmp1.w = sin(tmp0.w);
                tmp0.w = -tmp1.w * 0.5 + tmp0.w;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * _WindStrength;
                tmp6.xy = tmp0.ww * float2(0.1, 0.1) + inp.texcoord.zx;
                tmp7 = _CrestSpeed.xxxx * tmp0.yyzz + tmp6.xyxy;
                tmp0.yz = tmp7.xy * _LowDetail_ST.xy + _LowDetail_ST.zw;
                tmp8 = tex2D(_LowDetail, tmp0.yz);
                tmp0.yz = tmp7.xy * _Topper_MainTex_ST.xy + _Topper_MainTex_ST.zw;
                tmp9 = tex2D(_Topper_MainTex, tmp0.yz);
                tmp0.yzw = tmp8.xyz - tmp9.xyz;
                tmp8.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp8.xyz, tmp8.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp6.zw = tmp1.ww * float2(0.005, 0.01);
                tmp8.xy = tmp6.zw * tmp6.zw;
                tmp1.w = min(tmp8.x, 1.0);
                tmp2.w = tmp8.y * tmp8.y;
                tmp2.w = tmp2.w * tmp6.w;
                tmp2.w = min(tmp2.w, 1.0);
                tmp0.yzw = tmp1.www * tmp0.yzw + tmp9.xyz;
                tmp6.zw = tmp7.zw * _TopperDetailTex_ST.xy + _TopperDetailTex_ST.zw;
                tmp7.xy = tmp7.xy * _TopperSpecular_ST.xy + _TopperSpecular_ST.zw;
                tmp7 = tex2D(_TopperSpecular, tmp7.xy);
                tmp8 = tex2D(_TopperDetailTex, tmp6.zw);
                tmp8.xyz = tmp8.xyz - tmp0.yzw;
                tmp8.xyz = tmp0.xxx * tmp8.xyz;
                tmp0.xyz = _TopperEnableDetailTex.xxx * tmp8.xyz + tmp0.yzw;
                tmp8.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp8.xyz = -tmp8.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp8.xyz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp0.xyz = saturate(tmp0.xyz ? tmp2.xyz : tmp1.xyz);
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp2.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.w = tmp0.w > 0.5;
                tmp5.w = tmp0.w - 0.5;
                tmp5.w = -tmp5.w * 2.0 + 1.0;
                tmp6.zw = tmp6.xy * _TopperDepth_ST.xy + _TopperDepth_ST.zw;
                tmp6.xy = tmp6.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp8 = tex2D(_DetailNoiseMask, tmp6.xy);
                tmp6.x = saturate(tmp8.x * 3.0 + -1.5);
                tmp6.x = tmp2.w * -tmp6.x + tmp6.x;
                tmp8 = tex2D(_TopperDepth, tmp6.zw);
                tmp6.y = tmp8.x - 0.5;
                tmp6.y = _TopperDepthStrength * tmp6.y + 0.5;
                tmp6.zw = tmp6.yy * float2(0.33, 0.1) + float2(0.33, 0.45);
                tmp6.w = tmp6.w - tmp6.z;
                tmp7.w = saturate(tmp4.y * 2.0 + -1.0);
                tmp6.z = tmp7.w * tmp6.w + tmp6.z;
                tmp6.w = 1.0 - tmp6.z;
                tmp0.w = dot(tmp6.xy, tmp0.xy);
                tmp5.w = -tmp5.w * tmp6.w + 1.0;
                tmp0.w = saturate(tmp1.w ? tmp5.w : tmp0.w);
                tmp1.w = saturate(tmp4.y);
                tmp4.x = dot(abs(tmp4.xy), float2(0.333, 0.333));
                tmp4.y = tmp4.y * tmp4.y;
                tmp4.y = tmp4.y * _TopperCoverage;
                tmp4.y = tmp4.y * inp.color.x;
                tmp4.y = tmp4.y * 1.25;
                tmp1.w = tmp1.w + tmp4.x;
                tmp4.x = tmp1.w * tmp1.w;
                tmp8.xyz = tmp1.www * tmp1.www + glstate_lightmodel_ambient.xyz;
                tmp8.xyz = tmp8.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp8.xyz = tmp8.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp8.xyz = max(tmp8.xyz, float3(0.75, 0.75, 0.75));
                tmp8.xyz = min(tmp8.xyz, float3(1.0, 1.0, 1.0));
                tmp1.w = tmp4.w * tmp4.x;
                tmp1.w = tmp2.w * -tmp1.w + tmp1.w;
                tmp1.w = tmp6.y * tmp1.w;
                tmp2.w = tmp1.w + tmp1.w;
                tmp4.xzw = tmp1.www * float3(0.75, 0.75, 0.75) + tmp8.xyz;
                tmp4.xzw = tmp4.xzw * _LightColor0.xyz;
                tmp1.w = floor(tmp2.w);
                tmp0.w = tmp0.w * 13.0 + tmp1.w;
                tmp0.w = saturate(tmp0.w - 5.0);
                tmp8.xyz = tmp4.xzw * tmp0.www + float3(-0.5, -0.5, -0.5);
                tmp4.xzw = tmp0.www * tmp4.xzw;
                tmp8.xyz = -tmp8.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp8.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp8.xyz = tmp0.xyz * tmp4.xzw;
                tmp4.xzw = tmp4.xzw > float3(0.5, 0.5, 0.5);
                tmp8.xyz = tmp8.xyz + tmp8.xyz;
                tmp1.xyz = saturate(tmp4.xzw ? tmp1.xyz : tmp8.xyz);
                tmp0.w = dot(-tmp5.xyz, tmp3.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp3.xyz = tmp3.xyz * -tmp0.www + -tmp5.xyz;
                tmp0.w = dot(tmp2.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp1.w = _GlossPower * 16.0 + -1.0;
                tmp1.w = exp(tmp1.w);
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _Gloss;
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp2.xyz = tmp2.xyz * _Gloss.xxx;
                tmp2.xyz = tmp2.xyz * float3(50.0, 50.0, 50.0);
                tmp0.w = 1.0 - tmp6.y;
                tmp0.w = tmp0.w / tmp4.y;
                tmp0.w = saturate(1.0 - tmp0.w);
                tmp0.w = tmp0.w * inp.color.x;
                tmp0.w = saturate(tmp0.w * 8.0);
                tmp0.w = tmp0.w * tmp3.w + tmp0.w;
                tmp0.w = tmp0.w * 0.5;
                tmp3.xyz = tmp0.www * tmp7.xyz;
                tmp3.xyz = tmp6.yyy * tmp3.xyz;
                tmp0.w = 1.0 - _TopperSpecularNoiseAdjust;
                tmp1.w = _TopperSpecularNoiseAdjust - tmp0.w;
                tmp0.w = tmp6.x * tmp1.w + tmp0.w;
                tmp0.w = saturate(tmp0.w + tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp2.xyz = saturate(tmp2.xyz * tmp3.xyz);
                tmp3.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp2.xyz * _SpecularColor.xyz;
                tmp2.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - _SpecularColor.xyz;
                tmp2.xyz = -tmp2.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = saturate(tmp3.xyz ? tmp2.xyz : tmp4.xyz);
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.xyz = saturate(tmp0.xyz * tmp3.xyz);
                tmp3.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = -tmp3.xyz * float3(0.5, 0.5, 0.5) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp4.xyz ? tmp3.xyz : tmp0.xyz;
                tmp0.xyz = tmp2.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 90738
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _TimeEditor;
			float _WaveScale;
			float4 _WaveNoise_ST;
			float _WaveEnergy;
			float _WaveOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _WaveMap_ST;
			float _WaveSpeed;
			float _NormalStrength;
			float4 _DetailNoiseMask_ST;
			float4 _TopperDepth_ST;
			float4 _Topper_MainTex_ST;
			float4 _TopperDetailTex_ST;
			float _TopperEnableDetailTex;
			float _TopperCoverage;
			float _TopperDepthStrength;
			float4 _TopperSpecular_ST;
			float _Gloss;
			float _GlossPower;
			float _TopperSpecularNoiseAdjust;
			float4 _SpecularColor;
			float _WindTurbulance;
			float _WindStrength;
			float _WindSpeed;
			float _CrestSpeed;
			float4 _ColorTop;
			float4 _ColorBottom;
			float4 _LowDetail_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _WaveNoise;
			// Texture params for Fragment Shader
			sampler2D _WaveMap;
			sampler2D _LightTexture0;
			sampler2D _TopperSpecular;
			sampler2D _TopperDepth;
			sampler2D _DetailNoiseMask;
			sampler2D _Topper_MainTex;
			sampler2D _LowDetail;
			sampler2D _TopperDetailTex;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m21_m01_m21_m01;
                tmp0 = unity_ObjectToWorld._m20_m00_m20_m00 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m22_m02_m22_m02 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m23_m03_m23_m03 * v.vertex.wwww + tmp0;
                tmp1.x = _TimeEditor.y + _Time.y;
                tmp1.y = tmp1.x * 0.0167;
                tmp0.xy = tmp0.xy * float2(0.0125, 0.0125) + tmp1.yy;
                tmp0.xy = tmp0.xy * _WaveNoise_ST.xy + _WaveNoise_ST.zw;
                tmp2 = tex2Dlod(_WaveNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.xy = tmp0.zw * float2(0.025, 0.025) + tmp2.xx;
                tmp0.xy = tmp1.xx * float2(-0.1, -0.1) + tmp0.xy;
                tmp0.xy = tmp0.xy * _WaveEnergy.xx;
                tmp0.zw = floor(tmp0.xy);
                tmp0.z = tmp0.w * 57.0 + tmp0.z;
                tmp1.xyz = tmp0.zzz + float3(1.0, 57.0, 58.0);
                tmp2.x = sin(tmp0.z);
                tmp2.yzw = sin(tmp1.xyz);
                tmp1 = tmp2 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp1 = frac(tmp1);
                tmp0.zw = tmp1.yw - tmp1.xz;
                tmp1.yw = frac(tmp0.xy);
                tmp0.xy = tmp0.xy + tmp0.xy;
                tmp2.xy = tmp1.yw * tmp1.yw;
                tmp1.yw = -tmp1.yw * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp1.yw = tmp1.yw * tmp2.xy;
                tmp0.zw = tmp1.yy * tmp0.zw + tmp1.xz;
                tmp0.w = tmp0.w - tmp0.z;
                tmp0.z = tmp1.w * tmp0.w + tmp0.z;
                tmp1.xy = floor(tmp0.xy);
                tmp0.xy = frac(tmp0.xy);
                tmp0.w = tmp1.y * 57.0 + tmp1.x;
                tmp1.xyz = tmp0.www + float3(1.0, 57.0, 58.0);
                tmp2.x = sin(tmp0.w);
                tmp2.yzw = sin(tmp1.xyz);
                tmp1 = tmp2 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp1 = frac(tmp1);
                tmp1.yw = tmp1.yw - tmp1.xz;
                tmp2.xy = tmp0.xy * tmp0.xy;
                tmp0.xy = -tmp0.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp2.xy;
                tmp0.xw = tmp0.xx * tmp1.yw + tmp1.xz;
                tmp0.w = tmp0.w - tmp0.x;
                tmp0.x = tmp0.y * tmp0.w + tmp0.x;
                tmp0.x = tmp0.z * 2.0 + tmp0.x;
                tmp0.x = saturate(tmp0.x * 0.5);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.yzw = v.normal.xyz * _WaveScale.xxx;
                tmp1.xz = tmp0.xx * tmp0.yw;
                tmp1.y = tmp0.z * tmp0.x + _WaveOffset;
                tmp0.xyz = tmp1.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord2.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord3.xyz = tmp1.www * tmp1.xyz;
                o.color = v.color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                tmp0 = _TimeEditor + _Time;
                tmp1.x = tmp0.x > 0.0;
                tmp1.y = tmp0.x < 0.0;
                tmp1.x = tmp1.y - tmp1.x;
                tmp1.x = floor(tmp1.x);
                tmp1.yz = tmp0.xx * float2(0.0025, 0.0167);
                tmp2 = inp.texcoord.zxzx * float4(0.0125, 0.0125, 0.0125, 0.0125) + tmp1.yyzz;
                tmp2 = tmp2 * _WaveNoise_ST + _WaveNoise_ST;
                tmp3 = tex2D(_WaveNoise, tmp2.xy);
                tmp2 = tex2D(_WaveNoise, tmp2.zw);
                tmp1.yz = inp.texcoord.zx * float2(0.025, 0.025) + tmp2.xx;
                tmp1.yz = tmp0.xx * float2(-0.1, -0.1) + tmp1.yz;
                tmp1.yz = tmp1.yz * _WaveEnergy.xx;
                tmp2 = inp.texcoord.zxzx * float4(0.0125, 0.0125, 0.025, 0.025);
                tmp1.w = tmp3.x * 0.2 + tmp2.x;
                tmp3.x = tmp1.x * 0.1 + tmp1.w;
                tmp0.x = tmp0.x * _WaveSpeed;
                tmp2 = tmp0.xxxx * float4(-0.15, -0.15, 0.3, 0.3) + tmp2;
                tmp3.yz = float2(0.0, 0.04);
                tmp4 = tmp2.xyxy + tmp3.xyyx;
                tmp4 = tmp3.zxxz + tmp4;
                tmp4 = tmp4 * _WaveMap_ST + _WaveMap_ST;
                tmp5 = tex2D(_WaveMap, tmp4.xy);
                tmp4 = tex2D(_WaveMap, tmp4.zw);
                tmp6 = tmp3.xxxx + tmp2;
                tmp6 = tmp6 * _WaveMap_ST + _WaveMap_ST;
                tmp7 = tex2D(_WaveMap, tmp6.xy);
                tmp6 = tex2D(_WaveMap, tmp6.zw);
                tmp0.x = tmp7.x - tmp5.x;
                tmp1.x = tmp7.x - tmp4.x;
                tmp1.w = saturate(_NormalStrength);
                tmp4.x = tmp0.x * tmp1.w;
                tmp4.y = tmp1.x * tmp1.w;
                tmp0.x = dot(tmp4.xy, tmp4.xy);
                tmp0.x = 1.0 - tmp0.x;
                tmp5 = tmp2.zwzw + tmp3.xyyx;
                tmp3 = tmp3.zxxz + tmp5;
                tmp3 = tmp3 * _WaveMap_ST + _WaveMap_ST;
                tmp2 = tmp2 * _WaveMap_ST + _WaveMap_ST;
                tmp5 = tex2D(_WaveMap, tmp3.xy);
                tmp3 = tex2D(_WaveMap, tmp3.zw);
                tmp1.x = tmp6.x - tmp3.x;
                tmp3.x = tmp6.x - tmp5.x;
                tmp3.x = tmp1.w * tmp3.x;
                tmp3.y = tmp1.x * tmp1.w;
                tmp1.x = dot(tmp3.xy, tmp3.xy);
                tmp3.z = tmp0.x - tmp1.x;
                tmp4.z = 1.0;
                tmp3.xyz = tmp3.xyz + tmp4.xyz;
                tmp4.xyz = tmp3.xyz * float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(0.5, 0.5, 0.5) + float3(0.0, 0.0, 1.0);
                tmp1.xw = floor(tmp1.yz);
                tmp0.x = tmp1.w * 57.0 + tmp1.x;
                tmp5.xyz = tmp0.xxx + float3(1.0, 57.0, 58.0);
                tmp6.x = sin(tmp0.x);
                tmp6.yzw = sin(tmp5.xyz);
                tmp5 = tmp6 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp5 = frac(tmp5);
                tmp1.xw = tmp5.yw - tmp5.xz;
                tmp5.yw = frac(tmp1.yz);
                tmp1.yz = tmp1.yz + tmp1.yz;
                tmp6.xy = tmp5.yw * tmp5.yw;
                tmp5.yw = -tmp5.yw * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp5.yw = tmp5.yw * tmp6.xy;
                tmp1.xw = tmp5.yy * tmp1.xw + tmp5.xz;
                tmp0.x = tmp1.w - tmp1.x;
                tmp0.x = tmp5.w * tmp0.x + tmp1.x;
                tmp1.xw = floor(tmp1.yz);
                tmp1.yz = frac(tmp1.yz);
                tmp1.x = tmp1.w * 57.0 + tmp1.x;
                tmp5.xyz = tmp1.xxx + float3(1.0, 57.0, 58.0);
                tmp6.x = sin(tmp1.x);
                tmp6.yzw = sin(tmp5.xyz);
                tmp5 = tmp6 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp5 = frac(tmp5);
                tmp1.xw = tmp5.yw - tmp5.xz;
                tmp5.yw = tmp1.yz * tmp1.yz;
                tmp1.yz = -tmp1.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp1.yz = tmp1.yz * tmp5.yw;
                tmp1.xy = tmp1.yy * tmp1.xw + tmp5.xz;
                tmp1.y = tmp1.y - tmp1.x;
                tmp1.x = tmp1.z * tmp1.y + tmp1.x;
                tmp0.x = tmp0.x * 2.0 + tmp1.x;
                tmp1.x = tmp0.x * 0.5;
                tmp1.yzw = tmp0.xxx * float3(-0.125, -16.66666, -1.25) + float3(1.0, 5.0, 1.0);
                tmp3.xyz = saturate(tmp1.xxx * tmp3.xyz + tmp4.xyz);
                tmp1.xyz = saturate(tmp1.xyz);
                tmp4.xyz = tmp3.yyy * inp.texcoord3.xyz;
                tmp3.xyw = tmp3.xxx * inp.texcoord2.xyz + tmp4.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp4.xyz = tmp0.xxx * inp.texcoord1.xyz;
                tmp3.xyz = tmp3.zzz * tmp4.xyz + tmp3.xyw;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.x = saturate(tmp3.y);
                tmp5.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp3.w = dot(tmp5.xyz, tmp5.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp5.xyz = tmp3.www * tmp5.xyz;
                tmp3.w = dot(tmp3.xyz, tmp5.xyz);
                tmp3.w = max(tmp3.w, 0.0);
                tmp3.w = 1.0 - tmp3.w;
                tmp4.w = tmp3.w * tmp3.w;
                tmp4.w = tmp3.w * tmp4.w;
                tmp0.x = tmp0.x * tmp4.w;
                tmp6 = tex2D(_WaveMap, tmp2.xy);
                tmp2 = tex2D(_WaveMap, tmp2.zw);
                tmp2.y = 1.0 - tmp6.x;
                tmp2.z = dot(tmp6.xy, tmp2.xy);
                tmp2.w = tmp2.x - 0.5;
                tmp2.x = tmp2.x > 0.5;
                tmp2.w = -tmp2.w * 2.0 + 1.0;
                tmp2.y = -tmp2.w * tmp2.y + 1.0;
                tmp2.x = saturate(tmp2.x ? tmp2.y : tmp2.z);
                tmp1.x = tmp1.x * -tmp2.x + tmp2.x;
                tmp0.x = tmp0.x * tmp1.y + tmp1.x;
                tmp1.x = tmp1.z * 0.5;
                tmp1.x = saturate(tmp1.w * 0.5 + tmp1.x);
                tmp0.x = tmp0.x + tmp1.x;
                tmp1.xyz = _ColorTop.xyz - _ColorBottom.xyz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz + _ColorBottom.xyz;
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp0.w = tmp0.w * _WindSpeed;
                tmp1.w = inp.texcoord.x * _WindTurbulance;
                tmp0.w = tmp0.w * 5.0 + tmp1.w;
                tmp0.w = tmp0.w * 0.1061033;
                tmp1.w = sin(tmp0.w);
                tmp0.w = -tmp1.w * 0.5 + tmp0.w;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * _WindStrength;
                tmp6.xy = tmp0.ww * float2(0.1, 0.1) + inp.texcoord.zx;
                tmp7 = _CrestSpeed.xxxx * tmp0.yyzz + tmp6.xyxy;
                tmp0.yz = tmp7.xy * _LowDetail_ST.xy + _LowDetail_ST.zw;
                tmp8 = tex2D(_LowDetail, tmp0.yz);
                tmp0.yz = tmp7.xy * _Topper_MainTex_ST.xy + _Topper_MainTex_ST.zw;
                tmp9 = tex2D(_Topper_MainTex, tmp0.yz);
                tmp0.yzw = tmp8.xyz - tmp9.xyz;
                tmp8.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp8.xyz, tmp8.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp6.zw = tmp1.ww * float2(0.01, 0.005);
                tmp8.xy = tmp6.zw * tmp6.zw;
                tmp1.w = min(tmp8.y, 1.0);
                tmp2.w = tmp8.x * tmp8.x;
                tmp2.w = tmp2.w * tmp6.z;
                tmp2.w = min(tmp2.w, 1.0);
                tmp0.yzw = tmp1.www * tmp0.yzw + tmp9.xyz;
                tmp6.zw = tmp7.zw * _TopperDetailTex_ST.xy + _TopperDetailTex_ST.zw;
                tmp7.xy = tmp7.xy * _TopperSpecular_ST.xy + _TopperSpecular_ST.zw;
                tmp7 = tex2D(_TopperSpecular, tmp7.xy);
                tmp8 = tex2D(_TopperDetailTex, tmp6.zw);
                tmp8.xyz = tmp8.xyz - tmp0.yzw;
                tmp8.xyz = tmp0.xxx * tmp8.xyz;
                tmp0.xyz = _TopperEnableDetailTex.xxx * tmp8.xyz + tmp0.yzw;
                tmp8.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp8.xyz = -tmp8.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp8.xyz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp0.xyz = saturate(tmp0.xyz ? tmp2.xyz : tmp1.xyz);
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp2.xyz = _WorldSpaceLightPos0.www * -inp.texcoord.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp2.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.w = tmp0.w > 0.5;
                tmp5.w = tmp0.w - 0.5;
                tmp5.w = -tmp5.w * 2.0 + 1.0;
                tmp6.zw = tmp6.xy * _TopperDepth_ST.xy + _TopperDepth_ST.zw;
                tmp6.xy = tmp6.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp8 = tex2D(_DetailNoiseMask, tmp6.xy);
                tmp6.x = saturate(tmp8.x * 3.0 + -1.5);
                tmp6.x = tmp2.w * -tmp6.x + tmp6.x;
                tmp8 = tex2D(_TopperDepth, tmp6.zw);
                tmp6.y = tmp8.x - 0.5;
                tmp6.y = _TopperDepthStrength * tmp6.y + 0.5;
                tmp6.zw = tmp6.yy * float2(0.33, 0.1) + float2(0.33, 0.45);
                tmp6.w = tmp6.w - tmp6.z;
                tmp7.w = saturate(tmp4.y * 2.0 + -1.0);
                tmp6.z = tmp7.w * tmp6.w + tmp6.z;
                tmp6.w = 1.0 - tmp6.z;
                tmp0.w = dot(tmp6.xy, tmp0.xy);
                tmp5.w = -tmp5.w * tmp6.w + 1.0;
                tmp0.w = saturate(tmp1.w ? tmp5.w : tmp0.w);
                tmp1.w = saturate(tmp4.y);
                tmp4.x = dot(abs(tmp4.xy), float2(0.333, 0.333));
                tmp4.y = tmp4.y * tmp4.y;
                tmp4.y = tmp4.y * _TopperCoverage;
                tmp4.y = tmp4.y * inp.color.x;
                tmp4.y = tmp4.y * 1.25;
                tmp1.w = tmp1.w + tmp4.x;
                tmp4.x = tmp1.w * tmp1.w;
                tmp8.xyz = tmp1.www * tmp1.www + glstate_lightmodel_ambient.xyz;
                tmp8.xyz = tmp8.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp8.xyz = tmp8.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp8.xyz = max(tmp8.xyz, float3(0.75, 0.75, 0.75));
                tmp8.xyz = min(tmp8.xyz, float3(1.0, 1.0, 1.0));
                tmp1.w = tmp4.w * tmp4.x;
                tmp1.w = tmp2.w * -tmp1.w + tmp1.w;
                tmp1.w = tmp6.y * tmp1.w;
                tmp2.w = tmp1.w + tmp1.w;
                tmp4.xzw = tmp1.www * float3(0.75, 0.75, 0.75) + tmp8.xyz;
                tmp1.w = floor(tmp2.w);
                tmp0.w = tmp0.w * 13.0 + tmp1.w;
                tmp0.w = saturate(tmp0.w - 5.0);
                tmp1.w = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp8 = tex2D(_LightTexture0, tmp1.ww);
                tmp8.xyz = tmp8.xxx * _LightColor0.xyz;
                tmp4.xzw = tmp4.xzw * tmp8.xyz;
                tmp9.xyz = tmp4.xzw * tmp0.www + float3(-0.5, -0.5, -0.5);
                tmp4.xzw = tmp0.www * tmp4.xzw;
                tmp9.xyz = -tmp9.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp9.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp4.xzw;
                tmp4.xzw = tmp4.xzw > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = saturate(tmp4.xzw ? tmp1.xyz : tmp0.xyz);
                tmp0.w = dot(-tmp5.xyz, tmp3.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp1.xyz = tmp3.xyz * -tmp0.www + -tmp5.xyz;
                tmp0.w = dot(tmp2.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp1.x = _GlossPower * 16.0 + -1.0;
                tmp1.x = exp(tmp1.x);
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _Gloss;
                tmp1.xyz = tmp0.www * tmp8.xyz;
                tmp1.xyz = tmp1.xyz * _Gloss.xxx;
                tmp1.xyz = tmp1.xyz * float3(50.0, 50.0, 50.0);
                tmp0.w = 1.0 - tmp6.y;
                tmp0.w = tmp0.w / tmp4.y;
                tmp0.w = saturate(1.0 - tmp0.w);
                tmp0.w = tmp0.w * inp.color.x;
                tmp0.w = saturate(tmp0.w * 8.0);
                tmp0.w = tmp0.w * tmp3.w + tmp0.w;
                tmp0.w = tmp0.w * 0.5;
                tmp2.xyz = tmp0.www * tmp7.xyz;
                tmp2.xyz = tmp6.yyy * tmp2.xyz;
                tmp0.w = 1.0 - _TopperSpecularNoiseAdjust;
                tmp1.w = _TopperSpecularNoiseAdjust - tmp0.w;
                tmp0.w = tmp6.x * tmp1.w + tmp0.w;
                tmp0.w = saturate(tmp0.w + tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp1.xyz = saturate(tmp1.xyz * tmp2.xyz);
                tmp2.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp1.xyz * _SpecularColor.xyz;
                tmp1.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp1.xyz = -tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - _SpecularColor.xyz;
                tmp1.xyz = -tmp1.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp3.xyz);
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 190965
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			float _WaveScale;
			float4 _WaveNoise_ST;
			float _WaveEnergy;
			float _WaveOffset;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _WaveNoise;
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m21_m01_m21_m01;
                tmp0 = unity_ObjectToWorld._m20_m00_m20_m00 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m22_m02_m22_m02 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m23_m03_m23_m03 * v.vertex.wwww + tmp0;
                tmp1.x = _TimeEditor.y + _Time.y;
                tmp1.y = tmp1.x * 0.0167;
                tmp0.xy = tmp0.xy * float2(0.0125, 0.0125) + tmp1.yy;
                tmp0.xy = tmp0.xy * _WaveNoise_ST.xy + _WaveNoise_ST.zw;
                tmp2 = tex2Dlod(_WaveNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.xy = tmp0.zw * float2(0.025, 0.025) + tmp2.xx;
                tmp0.xy = tmp1.xx * float2(-0.1, -0.1) + tmp0.xy;
                tmp0.xy = tmp0.xy * _WaveEnergy.xx;
                tmp0.zw = floor(tmp0.xy);
                tmp0.z = tmp0.w * 57.0 + tmp0.z;
                tmp1.xyz = tmp0.zzz + float3(1.0, 57.0, 58.0);
                tmp2.x = sin(tmp0.z);
                tmp2.yzw = sin(tmp1.xyz);
                tmp1 = tmp2 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp1 = frac(tmp1);
                tmp0.zw = tmp1.yw - tmp1.xz;
                tmp1.yw = frac(tmp0.xy);
                tmp0.xy = tmp0.xy + tmp0.xy;
                tmp2.xy = tmp1.yw * tmp1.yw;
                tmp1.yw = -tmp1.yw * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp1.yw = tmp1.yw * tmp2.xy;
                tmp0.zw = tmp1.yy * tmp0.zw + tmp1.xz;
                tmp0.w = tmp0.w - tmp0.z;
                tmp0.z = tmp1.w * tmp0.w + tmp0.z;
                tmp1.xy = floor(tmp0.xy);
                tmp0.xy = frac(tmp0.xy);
                tmp0.w = tmp1.y * 57.0 + tmp1.x;
                tmp1.xyz = tmp0.www + float3(1.0, 57.0, 58.0);
                tmp2.x = sin(tmp0.w);
                tmp2.yzw = sin(tmp1.xyz);
                tmp1 = tmp2 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp1 = frac(tmp1);
                tmp1.yw = tmp1.yw - tmp1.xz;
                tmp2.xy = tmp0.xy * tmp0.xy;
                tmp0.xy = -tmp0.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp2.xy;
                tmp0.xw = tmp0.xx * tmp1.yw + tmp1.xz;
                tmp0.w = tmp0.w - tmp0.x;
                tmp0.x = tmp0.y * tmp0.w + tmp0.x;
                tmp0.x = tmp0.z * 2.0 + tmp0.x;
                tmp0.x = saturate(tmp0.x * 0.5);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.yzw = v.normal.xyz * _WaveScale.xxx;
                tmp1.xz = tmp0.xx * tmp0.yw;
                tmp1.y = tmp0.z * tmp0.x + _WaveOffset;
                tmp0.xyz = tmp1.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}