Shader "SR/Environment/Depth Water No Refraction" {
	Properties {
		_WaveMap ("Wave Map", 2D) = "white" {}
		_NormalStrength ("Normal Strength", Float) = 5
		_WaveSpeed ("Wave Speed", Float) = 0.25
		_WaveEnergy ("Wave Energy", Float) = 1
		_WaveScale ("Wave Scale", Float) = 0.4
		_ColorFadeStart ("Color Fade Start", Float) = 1
		_ColorFadeEnd ("Color Fade End", Float) = 8
		_ColorDensity ("Color Density", Float) = 0.4
		_Gradientmap ("Gradient map", 2D) = "white" {}
		[MaterialToggle] _Refraction ("Refraction", Float) = 0
		[MaterialToggle] _DepthBlend ("Depth Blend", Float) = 0.1111111
		_RefractedLight ("Refracted Light", 2D) = "white" {}
		[MaterialToggle] _FreshWater ("Fresh Water", Float) = 1
		_WaveNoise ("Wave Noise", 2D) = "white" {}
		_FresnelStrength ("Fresnel Strength", Float) = 0
		_WaveOffset ("Wave Offset", Float) = 0
		_DisperseSizeSpeed ("Disperse Size/Speed", Vector) = (10,10,0,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 550
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 63906
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _WaveScale;
			float4 _WaveNoise_ST;
			float _WaveEnergy;
			float _WaveOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float _ColorFadeStart;
			float4 _WaveMap_ST;
			float _WaveSpeed;
			float _NormalStrength;
			float _ColorFadeEnd;
			float _ColorDensity;
			float4 _Gradientmap_ST;
			float _Refraction;
			float _DepthBlend;
			float4 _RefractedLight_ST;
			float _FreshWater;
			float _FresnelStrength;
			float4 _DisperseSizeSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _WaveNoise;
			// Texture params for Fragment Shader
			sampler2D _WaveMap;
			sampler2D _Gradientmap;
			sampler2D _CameraDepthTexture;
			sampler2D _RefractedLight;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m21_m01_m21_m01;
                tmp0 = unity_ObjectToWorld._m20_m00_m20_m00 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m22_m02_m22_m02 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m23_m03_m23_m03 * v.vertex.wwww + tmp0;
                tmp1.x = _Time.y * 0.0167;
                tmp0.xy = tmp0.xy * float2(0.0125, 0.0125) + tmp1.xx;
                tmp0.xy = tmp0.xy * _WaveNoise_ST.xy + _WaveNoise_ST.zw;
                tmp1 = tex2Dlod(_WaveNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.xy = tmp0.zw * float2(0.025, 0.025) + tmp1.xx;
                tmp0.xy = _Time.yy * float2(-0.1, -0.1) + tmp0.xy;
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
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                o.texcoord2.xyz = tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp3.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp3.xyz;
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp3.xyz;
                o.texcoord3.xyz = tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx;
                tmp2.xyz = tmp2.yzx * tmp3.zxy + -tmp4.xyz;
                tmp2.xyz = tmp2.xyz * v.tangent.www;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                o.texcoord4.xyz = tmp0.zzz * tmp2.xyz;
                o.color = v.color;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord5.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.w = tmp0.w;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
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
                tmp0.xy = _DisperseSizeSpeed.zw * _Time.yy;
                tmp0.xy = inp.texcoord.xy * _DisperseSizeSpeed.xy + tmp0.xy;
                tmp0.zw = floor(tmp0.xy);
                tmp0.xy = frac(tmp0.xy);
                tmp1 = tmp0.zwzw + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp1.z = tmp1.w * tmp1.z;
                tmp2.xy = tmp0.zw + float2(1.2127, 1.2127);
                tmp1.zw = tmp1.zz * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.xy = tmp1.zw * float2(489.123, 489.123);
                tmp1.z = tmp1.z + 1.0;
                tmp2.xy = sin(tmp2.xy);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp1.w = tmp2.y * tmp2.x;
                tmp1.z = tmp1.z * tmp1.w;
                tmp2 = tmp0.zwzw + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp1.w = tmp2.w * tmp2.z;
                tmp1.xy = tmp1.ww * float2(0.3713, 0.3713) + tmp1.xy;
                tmp1.yw = tmp1.xy * float2(489.123, 489.123);
                tmp1.x = tmp1.x + 1.0;
                tmp1.yw = sin(tmp1.yw);
                tmp1.yw = tmp1.yw * float2(4.789, 4.789);
                tmp1.y = tmp1.w * tmp1.y;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.xz = frac(tmp1.xz);
                tmp1.y = tmp1.z - tmp1.x;
                tmp1.zw = -tmp0.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.xy = tmp1.zw * tmp0.xy;
                tmp1.x = tmp0.x * tmp1.y + tmp1.x;
                tmp3 = tmp0.zwzw + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.zw = tmp0.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp1.y = tmp3.w * tmp3.z;
                tmp1.yz = tmp1.yy * float2(0.3713, 0.3713) + tmp2.xy;
                tmp1.zw = tmp1.yz * float2(489.123, 489.123);
                tmp1.y = tmp1.y + 1.0;
                tmp1.zw = sin(tmp1.zw);
                tmp1.zw = tmp1.zw * float2(4.789, 4.789);
                tmp1.z = tmp1.w * tmp1.z;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.y = frac(tmp1.y);
                tmp1.zw = tmp0.zw * float2(489.123, 489.123);
                tmp0.z = tmp0.z + 1.0;
                tmp1.zw = sin(tmp1.zw);
                tmp1.zw = tmp1.zw * float2(4.789, 4.789);
                tmp0.w = tmp1.w * tmp1.z;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = frac(tmp0.z);
                tmp0.w = tmp1.y - tmp0.z;
                tmp0.x = tmp0.x * tmp0.w + tmp0.z;
                tmp0.z = tmp1.x - tmp0.x;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.z = inp.color.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.y = -tmp0.z * tmp0.y + 1.0;
                tmp0.z = dot(tmp0.xy, inp.color.xy);
                tmp0.w = inp.color.x > 0.5;
                tmp0.y = saturate(tmp0.w ? tmp0.y : tmp0.z);
                tmp0.y = tmp0.y - 0.5;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.yz = _Time.yy * float2(0.0025, 0.0167);
                tmp1 = inp.texcoord1.zxzx * float4(0.0125, 0.0125, 0.0125, 0.0125) + tmp0.yyzz;
                tmp1 = tmp1 * _WaveNoise_ST + _WaveNoise_ST;
                tmp2 = tex2D(_WaveNoise, tmp1.zw);
                tmp1 = tex2D(_WaveNoise, tmp1.xy);
                tmp0.yz = inp.texcoord1.zx * float2(0.025, 0.025) + tmp2.xx;
                tmp0.yz = _Time.yy * float2(-0.1, -0.1) + tmp0.yz;
                tmp0.yz = tmp0.yz * _WaveEnergy.xx;
                tmp1.yz = floor(tmp0.yz);
                tmp0.w = tmp1.z * 57.0 + tmp1.y;
                tmp1.yzw = tmp0.www + float3(1.0, 57.0, 58.0);
                tmp2.x = sin(tmp0.w);
                tmp2.yzw = sin(tmp1.yzw);
                tmp2 = tmp2 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp2 = frac(tmp2);
                tmp1.yz = tmp2.yw - tmp2.xz;
                tmp2.yw = frac(tmp0.yz);
                tmp0.yz = tmp0.yz + tmp0.yz;
                tmp3.xy = tmp2.yw * tmp2.yw;
                tmp2.yw = -tmp2.yw * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp2.yw = tmp2.yw * tmp3.xy;
                tmp1.yz = tmp2.yy * tmp1.yz + tmp2.xz;
                tmp0.w = tmp1.z - tmp1.y;
                tmp0.w = tmp2.w * tmp0.w + tmp1.y;
                tmp1.yz = floor(tmp0.yz);
                tmp0.yz = frac(tmp0.yz);
                tmp1.y = tmp1.z * 57.0 + tmp1.y;
                tmp2.xyz = tmp1.yyy + float3(1.0, 57.0, 58.0);
                tmp3.x = sin(tmp1.y);
                tmp3.yzw = sin(tmp2.xyz);
                tmp2 = tmp3 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp2 = frac(tmp2);
                tmp1.yz = tmp2.yw - tmp2.xz;
                tmp2.yw = tmp0.yz * tmp0.yz;
                tmp0.yz = -tmp0.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.yz = tmp0.yz * tmp2.yw;
                tmp1.yz = tmp0.yy * tmp1.yz + tmp2.xz;
                tmp0.y = tmp1.z - tmp1.y;
                tmp0.y = tmp0.z * tmp0.y + tmp1.y;
                tmp0.y = tmp0.w * 2.0 + tmp0.y;
                tmp1.yzw = tmp0.yyy * float3(-16.66666, -0.125, -1.25) + float3(5.0, 1.0, 1.0);
                tmp0.y = tmp0.y * 0.5;
                tmp1.yz = saturate(tmp1.yz);
                tmp0.z = tmp1.y * 0.5;
                tmp0.z = saturate(tmp1.w * 0.5 + tmp0.z);
                tmp1.yw = inp.texcoord1.zx * float2(0.0125, 0.0125);
                tmp1.xy = tmp1.xx * float2(0.2, 0.2) + tmp1.yw;
                tmp0.w = _Time.z > 0.0;
                tmp1.w = _Time.z < 0.0;
                tmp0.w = tmp1.w - tmp0.w;
                tmp0.w = floor(tmp0.w);
                tmp2.xy = tmp0.ww * float2(0.1, 0.1) + tmp1.xy;
                tmp1.xyw = _WaveSpeed.xxx * _Time.zzy;
                tmp1.xyw = tmp1.xyw * float3(-0.15, 0.3, 0.45);
                tmp3 = inp.texcoord1.zxzx * float4(0.0125, 0.0125, 0.025, 0.025) + tmp1.xxyy;
                tmp2.zw = float2(0.0, 0.04);
                tmp4 = tmp2.xzzx + tmp3.xyxy;
                tmp4 = tmp2.wxxw + tmp4;
                tmp4 = tmp4 * _WaveMap_ST + _WaveMap_ST;
                tmp5 = tex2D(_WaveMap, tmp4.xy);
                tmp4 = tex2D(_WaveMap, tmp4.zw);
                tmp6 = tmp2.xxxx + tmp3;
                tmp6 = tmp6 * _WaveMap_ST + _WaveMap_ST;
                tmp7 = tex2D(_WaveMap, tmp6.xy);
                tmp6 = tex2D(_WaveMap, tmp6.zw);
                tmp0.w = tmp7.x - tmp5.x;
                tmp1.x = tmp7.x - tmp4.x;
                tmp4.y = tmp1.x * _NormalStrength;
                tmp4.x = tmp0.w * _NormalStrength;
                tmp0.w = dot(tmp4.xy, tmp4.xy);
                tmp0.w = 1.0 - tmp0.w;
                tmp5 = tmp2.xzzx + tmp3.zwzw;
                tmp3 = tmp3 * _WaveMap_ST + _WaveMap_ST;
                tmp5 = tmp2.wxxw + tmp5;
                tmp5 = tmp5 * _WaveMap_ST + _WaveMap_ST;
                tmp7 = tex2D(_WaveMap, tmp5.xy);
                tmp5 = tex2D(_WaveMap, tmp5.zw);
                tmp1.x = tmp6.x - tmp5.x;
                tmp1.y = tmp6.x - tmp7.x;
                tmp5.x = tmp1.y * _NormalStrength;
                tmp5.y = tmp1.x * _NormalStrength;
                tmp1.x = dot(tmp5.xy, tmp5.xy);
                tmp5.z = tmp0.w - tmp1.x;
                tmp4.z = 1.0;
                tmp4.xyz = tmp4.xyz + tmp5.xyz;
                tmp5.xyz = tmp4.xyz * float3(0.5, 0.5, 0.5);
                tmp4.xyz = -tmp4.xyz * float3(0.5, 0.5, 0.5) + float3(0.0, 0.0, 1.0);
                tmp4.xyz = tmp0.yyy * tmp4.xyz + tmp5.xyz;
                tmp0.y = saturate(tmp0.y);
                tmp5.xyz = tmp4.yyy * inp.texcoord4.xyz;
                tmp4.xyw = tmp4.xxx * inp.texcoord3.xyz + tmp5.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp4.xyz = tmp4.zzz * tmp5.xyz + tmp4.xyw;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = saturate(tmp4.y);
                tmp6.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.x = dot(tmp6.xyz, tmp6.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp7.xyz = tmp1.xxx * tmp6.xyz;
                tmp1.y = dot(tmp4.xyz, tmp7.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = 1.0 - tmp1.y;
                tmp2.z = tmp1.y * tmp1.y;
                tmp2.z = tmp1.y * tmp2.z;
                tmp0.w = tmp0.w * tmp2.z;
                tmp0.w = tmp1.z * tmp0.w;
                tmp8 = tex2D(_WaveMap, tmp3.xy);
                tmp3 = tex2D(_WaveMap, tmp3.zw);
                tmp9.xyz = float3(1.0, 1.0, 1.0) - tmp8.xyz;
                tmp8.xyz = tmp3.xyz * tmp8.xyz;
                tmp8.xyz = tmp8.xyz + tmp8.xyz;
                tmp10.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp10.xyz = -tmp10.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp9.xyz = -tmp10.xyz * tmp9.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = saturate(tmp3.xyz ? tmp9.xyz : tmp8.xyz);
                tmp8.xyz = tmp0.yyy * -tmp3.xyz + tmp3.xyz;
                tmp2.zw = tmp3.xy * float2(0.125, 0.125);
                tmp2.zw = tmp2.zw * _Refraction.xx;
                tmp0.y = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp0.y = saturate(tmp0.y * 10.0);
                tmp0.w = tmp8.x * tmp0.y + tmp0.w;
                tmp3.xyz = max(tmp8.xyz, float3(0.0, 0.0, 0.0));
                tmp1.z = 1.0 - _FreshWater;
                tmp0.w = tmp1.z * tmp0.z + tmp0.w;
                tmp0.z = tmp0.z * tmp1.z;
                tmp8.xy = tmp0.ww * _Gradientmap_ST.xy + _Gradientmap_ST.zw;
                tmp8 = tex2D(_Gradientmap, tmp8.xy);
                tmp9.xy = tmp2.xy * _WaveMap_ST.xy;
                tmp9.xy = tmp9.xy * float2(5.0, 5.0) + _WaveMap_ST.zw;
                tmp9 = tex2D(_WaveMap, tmp9.xy);
                tmp9.xyz = saturate(tmp9.xyz * float3(-3.5, -3.5, -3.5) + float3(1.0, 1.0, 1.0));
                tmp10.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp10 = tex2D(_CameraDepthTexture, tmp10.xy);
                tmp0.w = _ZBufferParams.z * tmp10.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - _ProjectionParams.y;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.z = inp.texcoord5.z - _ProjectionParams.y;
                tmp1.z = max(tmp1.z, 0.0);
                tmp0.w = tmp0.w - tmp1.z;
                tmp10.xyz = _ColorDensity.xxx * tmp0.www + float3(1.0, 0.4, 0.8);
                tmp10.yz = tmp10.yz * float2(-0.8333333, -5.0) + float2(0.8333333, 5.0);
                tmp9.xyz = tmp9.xyz * tmp10.yyy;
                tmp1.z = 1.0 - tmp10.z;
                tmp9.xyz = saturate(tmp9.xyz * tmp1.zzz + tmp0.zzz);
                tmp9.xyz = tmp9.xyz * float3(6.0, 6.0, 6.0);
                tmp9.xyz = floor(tmp9.xyz);
                tmp9.xyz = tmp9.xyz * float3(0.2, 0.2, 0.2);
                tmp0.z = dot(tmp9.xyz, float3(0.3, 0.59, 0.11));
                tmp3.xyz = tmp3.xyz * tmp8.xyz + tmp0.zzz;
                tmp9.xy = -tmp7.xz * tmp0.ww + inp.texcoord1.xz;
                tmp0.zw = tmp0.ww * float2(0.5555556, 0.1) + float2(-0.1111111, 0.1);
                tmp1.z = dot(tmp5.xyz, tmp7.xyz);
                tmp1.z = max(tmp1.z, 0.0);
                tmp1.z = 1.0 - tmp1.z;
                tmp5.xy = tmp9.xy * float2(0.15, 0.15) + tmp1.ww;
                tmp5.zw = inp.texcoord1.xz * float2(0.15, 0.15) + tmp1.ww;
                tmp5.zw = tmp2.zw * float2(20.0, 20.0) + tmp5.zw;
                tmp2.zw = tmp2.zw * float2(20.0, 20.0) + tmp5.xy;
                tmp2.zw = tmp2.xy + tmp2.zw;
                tmp2.xy = tmp2.xy + tmp5.zw;
                tmp2.xy = tmp2.xy * _RefractedLight_ST.xy;
                tmp2.xy = tmp2.xy * float2(0.5, 0.5) + _RefractedLight_ST.zw;
                tmp5 = tex2D(_RefractedLight, tmp2.xy);
                tmp5.xyz = saturate(tmp5.xyz * float3(0.6, 0.6, 0.6) + float3(-0.3, -0.3, -0.3));
                tmp2.xy = tmp2.zw * _RefractedLight_ST.xy + _RefractedLight_ST.zw;
                tmp2 = tex2D(_RefractedLight, tmp2.xy);
                tmp2.xyz = saturate(tmp2.xyz * float3(0.5, 0.5, 0.5) + float3(-0.25, -0.25, -0.25));
                tmp1.w = _ColorFadeEnd + 1.0;
                tmp1.w = saturate(tmp10.x / tmp1.w);
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * _ColorFadeStart;
                tmp1.w = exp(tmp1.w);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = tmp1.w - 1.0;
                tmp1.w = _DepthBlend * tmp1.w + 1.0;
                tmp7.xy = tmp1.ww * float2(-2.0, 0.5) + float2(1.0, 0.5);
                tmp2.xyz = tmp2.xyz * tmp7.xxx;
                tmp2.w = max(tmp7.y, 0.5);
                o.sv_target.w = min(tmp2.w, 1.0);
                tmp2.xyz = tmp0.yyy * tmp2.xyz;
                tmp0.z = saturate(tmp0.z);
                tmp2.xyz = saturate(tmp0.zzz * tmp2.xyz);
                tmp3.xyz = tmp2.xyz + tmp3.xyz;
                tmp0.y = tmp1.y * 6.666668 + -5.000001;
                tmp7.xy = _Gradientmap_ST.zw + _Gradientmap_ST.xy;
                tmp7 = tex2D(_Gradientmap, tmp7.xy);
                tmp9 = tex2D(_Gradientmap, _Gradientmap_ST.zw);
                tmp7.xyz = tmp7.xyz - tmp9.xyz;
                tmp10.xyz = tmp0.yyy * tmp7.xyz + tmp9.xyz;
                tmp10.xyz = tmp1.yyy * tmp10.xyz;
                tmp10.xyz = saturate(tmp10.xyz * _FresnelStrength.xxx);
                tmp5.xyz = _FreshWater.xxx * tmp5.xyz + tmp10.xyz;
                tmp3.xyz = tmp3.xyz + tmp5.xyz;
                tmp0.y = inp.color.x * -4.0 + 4.0;
                tmp0.x = saturate(tmp0.x * tmp0.y);
                tmp0.y = tmp0.x + tmp0.x;
                tmp5.xyz = tmp0.xxx * tmp7.xyz + tmp9.xyz;
                tmp0.x = floor(tmp0.y);
                tmp0.xyz = tmp0.xxx * tmp5.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.333, 0.333, 0.333) + tmp3.xyz;
                tmp3.xyz = tmp9.xyz * float3(10.0, 10.0, 10.0) + float3(0.1, 0.1, 0.1);
                tmp3.xyz = -tmp0.www / tmp3.xyz;
                tmp3.xyz = saturate(tmp3.xyz + float3(1.0, 1.0, 1.0));
                tmp5.xyz = tmp3.xyz * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * tmp5.xyz;
                tmp5.xyz = tmp9.xyz * float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp5.xyz * tmp3.xyz + float3(-0.5, -0.5, -0.5);
                tmp3.xyz = tmp3.xyz * tmp5.xyz;
                tmp5.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp7.xyz = float3(1.0, 1.0, 1.0) - tmp9.xyz;
                tmp5.xyz = -tmp5.xyz * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp3.xyz * tmp9.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp7.xyz + tmp7.xyz;
                tmp3.xyz = saturate(tmp3.xyz ? tmp5.xyz : tmp7.xyz);
                tmp0.w = 1.0 - tmp1.w;
                tmp5.xyz = tmp1.www * tmp8.xyz;
                tmp3.xyz = tmp3.xyz * tmp0.www;
                tmp0.w = tmp1.z * tmp1.z;
                tmp0.w = tmp0.w * tmp1.z;
                tmp1.yzw = saturate(tmp0.www * float3(1.25, 1.25, 1.25) + tmp9.xyz);
                tmp1.yzw = tmp5.xyz * tmp1.yzw + tmp3.xyz;
                tmp1.yzw = tmp2.xyz + tmp1.yzw;
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp3.xyz = tmp6.xyz * tmp1.xxx + tmp2.xyz;
                tmp0.w = dot(tmp4.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.x = dot(tmp3.xyz, tmp3.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp2.xyz = tmp1.xxx * tmp3.xyz;
                tmp1.x = dot(tmp2.xyz, tmp4.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * 362.0387;
                tmp1.x = exp(tmp1.x);
                tmp2.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp2.xyz = tmp2.xyz * float3(5.0, 5.0, 5.0);
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp3.xyz = tmp0.www * _LightColor0.xyz + tmp3.xyz;
                tmp1.xyz = tmp3.xyz * tmp1.yzw + tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" }
			Blend One One, One One
			GpuProgramID 115750
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
				float4 texcoord5 : TEXCOORD5;
				float3 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float _WaveScale;
			float4 _WaveNoise_ST;
			float _WaveEnergy;
			float _WaveOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float _ColorFadeStart;
			float4 _WaveMap_ST;
			float _WaveSpeed;
			float _NormalStrength;
			float _ColorFadeEnd;
			float _ColorDensity;
			float4 _Gradientmap_ST;
			float _Refraction;
			float _DepthBlend;
			float4 _RefractedLight_ST;
			float _FreshWater;
			float4 _DisperseSizeSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _WaveNoise;
			// Texture params for Fragment Shader
			sampler2D _WaveMap;
			sampler2D _LightTexture0;
			sampler2D _Gradientmap;
			sampler2D _CameraDepthTexture;
			sampler2D _RefractedLight;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m21_m01_m21_m01;
                tmp0 = unity_ObjectToWorld._m20_m00_m20_m00 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m22_m02_m22_m02 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m23_m03_m23_m03 * v.vertex.wwww + tmp0;
                tmp1.x = _Time.y * 0.0167;
                tmp0.xy = tmp0.xy * float2(0.0125, 0.0125) + tmp1.xx;
                tmp0.xy = tmp0.xy * _WaveNoise_ST.xy + _WaveNoise_ST.zw;
                tmp1 = tex2Dlod(_WaveNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.xy = tmp0.zw * float2(0.025, 0.025) + tmp1.xx;
                tmp0.xy = _Time.yy * float2(-0.1, -0.1) + tmp0.xy;
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
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp2;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = tmp0;
                tmp3.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp2.z = dot(tmp3.xyz, tmp3.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp3.xyz = tmp2.zzz * tmp3.xyz;
                o.texcoord2.xyz = tmp3.xyz;
                tmp4.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp4.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp4.xyz;
                tmp4.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp4.xyz;
                tmp2.z = dot(tmp4.xyz, tmp4.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp4.xyz = tmp2.zzz * tmp4.xyz;
                o.texcoord3.xyz = tmp4.xyz;
                tmp5.xyz = tmp3.zxy * tmp4.yzx;
                tmp3.xyz = tmp3.yzx * tmp4.zxy + -tmp5.xyz;
                tmp3.xyz = tmp3.xyz * v.tangent.www;
                tmp2.z = dot(tmp3.xyz, tmp3.xyz);
                tmp2.z = rsqrt(tmp2.z);
                o.texcoord4.xyz = tmp2.zzz * tmp3.xyz;
                o.color = v.color;
                tmp1.y = tmp1.y * unity_MatrixV._m21;
                tmp1.x = unity_MatrixV._m20 * tmp1.x + tmp1.y;
                tmp1.x = unity_MatrixV._m22 * tmp1.z + tmp1.x;
                tmp1.x = unity_MatrixV._m23 * tmp1.w + tmp1.x;
                o.texcoord5.z = -tmp1.x;
                tmp1.x = tmp2.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp2.xw * float2(0.5, 0.5);
                o.texcoord5.w = tmp2.w;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord6.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                tmp0.xy = _DisperseSizeSpeed.zw * _Time.yy;
                tmp0.xy = inp.texcoord.xy * _DisperseSizeSpeed.xy + tmp0.xy;
                tmp0.zw = floor(tmp0.xy);
                tmp0.xy = frac(tmp0.xy);
                tmp1 = tmp0.zwzw + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp1.z = tmp1.w * tmp1.z;
                tmp2.xy = tmp0.zw + float2(1.2127, 1.2127);
                tmp1.zw = tmp1.zz * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.xy = tmp1.zw * float2(489.123, 489.123);
                tmp1.z = tmp1.z + 1.0;
                tmp2.xy = sin(tmp2.xy);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp1.w = tmp2.y * tmp2.x;
                tmp1.z = tmp1.z * tmp1.w;
                tmp2 = tmp0.zwzw + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp1.w = tmp2.w * tmp2.z;
                tmp1.xy = tmp1.ww * float2(0.3713, 0.3713) + tmp1.xy;
                tmp1.yw = tmp1.xy * float2(489.123, 489.123);
                tmp1.x = tmp1.x + 1.0;
                tmp1.yw = sin(tmp1.yw);
                tmp1.yw = tmp1.yw * float2(4.789, 4.789);
                tmp1.y = tmp1.w * tmp1.y;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.xz = frac(tmp1.xz);
                tmp1.y = tmp1.z - tmp1.x;
                tmp1.zw = -tmp0.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.xy = tmp1.zw * tmp0.xy;
                tmp1.x = tmp0.x * tmp1.y + tmp1.x;
                tmp3 = tmp0.zwzw + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.zw = tmp0.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp1.y = tmp3.w * tmp3.z;
                tmp1.yz = tmp1.yy * float2(0.3713, 0.3713) + tmp2.xy;
                tmp1.zw = tmp1.yz * float2(489.123, 489.123);
                tmp1.y = tmp1.y + 1.0;
                tmp1.zw = sin(tmp1.zw);
                tmp1.zw = tmp1.zw * float2(4.789, 4.789);
                tmp1.z = tmp1.w * tmp1.z;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.y = frac(tmp1.y);
                tmp1.zw = tmp0.zw * float2(489.123, 489.123);
                tmp0.z = tmp0.z + 1.0;
                tmp1.zw = sin(tmp1.zw);
                tmp1.zw = tmp1.zw * float2(4.789, 4.789);
                tmp0.w = tmp1.w * tmp1.z;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = frac(tmp0.z);
                tmp0.w = tmp1.y - tmp0.z;
                tmp0.x = tmp0.x * tmp0.w + tmp0.z;
                tmp0.z = tmp1.x - tmp0.x;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.x = dot(tmp0.xy, inp.color.xy);
                tmp0.z = inp.color.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.y = -tmp0.z * tmp0.y + 1.0;
                tmp0.z = inp.color.x > 0.5;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.xy = _Time.yy * float2(0.0025, 0.0167);
                tmp0 = inp.texcoord1.zxzx * float4(0.0125, 0.0125, 0.0125, 0.0125) + tmp0.xxyy;
                tmp0 = tmp0 * _WaveNoise_ST + _WaveNoise_ST;
                tmp1 = tex2D(_WaveNoise, tmp0.zw);
                tmp0 = tex2D(_WaveNoise, tmp0.xy);
                tmp0.yz = inp.texcoord1.zx * float2(0.025, 0.025) + tmp1.xx;
                tmp0.yz = _Time.yy * float2(-0.1, -0.1) + tmp0.yz;
                tmp0.yz = tmp0.yz * _WaveEnergy.xx;
                tmp1.xy = floor(tmp0.yz);
                tmp0.w = tmp1.y * 57.0 + tmp1.x;
                tmp1.xyz = tmp0.www + float3(1.0, 57.0, 58.0);
                tmp2.x = sin(tmp0.w);
                tmp2.yzw = sin(tmp1.xyz);
                tmp1 = tmp2 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp1 = frac(tmp1);
                tmp1.yw = tmp1.yw - tmp1.xz;
                tmp2.xy = frac(tmp0.yz);
                tmp0.yz = tmp0.yz + tmp0.yz;
                tmp2.zw = tmp2.xy * tmp2.xy;
                tmp2.xy = -tmp2.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp2.xy = tmp2.xy * tmp2.zw;
                tmp1.xy = tmp2.xx * tmp1.yw + tmp1.xz;
                tmp0.w = tmp1.y - tmp1.x;
                tmp0.w = tmp2.y * tmp0.w + tmp1.x;
                tmp1.xy = floor(tmp0.yz);
                tmp0.yz = frac(tmp0.yz);
                tmp1.x = tmp1.y * 57.0 + tmp1.x;
                tmp1.yzw = tmp1.xxx + float3(1.0, 57.0, 58.0);
                tmp2 = sin(tmp1);
                tmp1 = tmp2 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp1 = frac(tmp1);
                tmp1.yw = tmp1.yw - tmp1.xz;
                tmp2.xy = tmp0.yz * tmp0.yz;
                tmp0.yz = -tmp0.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.yz = tmp0.yz * tmp2.xy;
                tmp1.xy = tmp0.yy * tmp1.yw + tmp1.xz;
                tmp0.y = tmp1.y - tmp1.x;
                tmp0.y = tmp0.z * tmp0.y + tmp1.x;
                tmp0.y = tmp0.w * 2.0 + tmp0.y;
                tmp1.xyz = tmp0.yyy * float3(-16.66666, -0.125, -1.25) + float3(5.0, 1.0, 1.0);
                tmp0.y = tmp0.y * 0.5;
                tmp1.xy = saturate(tmp1.xy);
                tmp0.z = tmp1.x * 0.5;
                tmp0.z = saturate(tmp1.z * 0.5 + tmp0.z);
                tmp1.xz = inp.texcoord1.zx * float2(0.0125, 0.0125);
                tmp0.xw = tmp0.xx * float2(0.2, 0.2) + tmp1.xz;
                tmp1.x = _Time.z > 0.0;
                tmp1.z = _Time.z < 0.0;
                tmp1.x = tmp1.z - tmp1.x;
                tmp1.x = floor(tmp1.x);
                tmp2.xy = tmp1.xx * float2(0.1, 0.1) + tmp0.xw;
                tmp1.xzw = _WaveSpeed.xxx * _Time.zzy;
                tmp1.xzw = tmp1.xzw * float3(-0.15, 0.3, 0.45);
                tmp3 = inp.texcoord1.zxzx * float4(0.0125, 0.0125, 0.025, 0.025) + tmp1.xxzz;
                tmp2.zw = float2(0.0, 0.04);
                tmp4 = tmp2.xzzx + tmp3.xyxy;
                tmp4 = tmp2.wxxw + tmp4;
                tmp4 = tmp4 * _WaveMap_ST + _WaveMap_ST;
                tmp5 = tex2D(_WaveMap, tmp4.xy);
                tmp4 = tex2D(_WaveMap, tmp4.zw);
                tmp6 = tmp2.xxxx + tmp3;
                tmp6 = tmp6 * _WaveMap_ST + _WaveMap_ST;
                tmp7 = tex2D(_WaveMap, tmp6.xy);
                tmp6 = tex2D(_WaveMap, tmp6.zw);
                tmp0.x = tmp7.x - tmp5.x;
                tmp0.w = tmp7.x - tmp4.x;
                tmp4.y = tmp0.w * _NormalStrength;
                tmp4.x = tmp0.x * _NormalStrength;
                tmp0.x = dot(tmp4.xy, tmp4.xy);
                tmp0.x = 1.0 - tmp0.x;
                tmp5 = tmp2.xzzx + tmp3.zwzw;
                tmp3 = tmp3 * _WaveMap_ST + _WaveMap_ST;
                tmp5 = tmp2.wxxw + tmp5;
                tmp5 = tmp5 * _WaveMap_ST + _WaveMap_ST;
                tmp7 = tex2D(_WaveMap, tmp5.xy);
                tmp5 = tex2D(_WaveMap, tmp5.zw);
                tmp0.w = tmp6.x - tmp5.x;
                tmp1.x = tmp6.x - tmp7.x;
                tmp5.x = tmp1.x * _NormalStrength;
                tmp5.y = tmp0.w * _NormalStrength;
                tmp0.w = dot(tmp5.xy, tmp5.xy);
                tmp5.z = tmp0.x - tmp0.w;
                tmp4.z = 1.0;
                tmp4.xyz = tmp4.xyz + tmp5.xyz;
                tmp5.xyz = tmp4.xyz * float3(0.5, 0.5, 0.5);
                tmp4.xyz = -tmp4.xyz * float3(0.5, 0.5, 0.5) + float3(0.0, 0.0, 1.0);
                tmp4.xyz = tmp0.yyy * tmp4.xyz + tmp5.xyz;
                tmp0.y = saturate(tmp0.y);
                tmp5.xyz = tmp4.yyy * inp.texcoord4.xyz;
                tmp4.xyw = tmp4.xxx * inp.texcoord3.xyz + tmp5.xyz;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp5.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp4.xyz = tmp4.zzz * tmp5.xyz + tmp4.xyw;
                tmp0.x = dot(tmp4.xyz, tmp4.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                tmp0.x = saturate(tmp4.y);
                tmp6.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp6.xyz, tmp6.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp7.xyz = tmp0.www * tmp6.xyz;
                tmp1.x = dot(tmp4.xyz, tmp7.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.z = tmp1.x * tmp1.x;
                tmp1.x = tmp1.z * tmp1.x;
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.x = tmp1.y * tmp0.x;
                tmp8 = tex2D(_WaveMap, tmp3.xy);
                tmp3 = tex2D(_WaveMap, tmp3.zw);
                tmp1.xy = float2(1.0, 1.0) - tmp8.xy;
                tmp2.zw = tmp3.xy * tmp8.xy;
                tmp2.zw = tmp2.zw + tmp2.zw;
                tmp3.zw = tmp3.xy - float2(0.5, 0.5);
                tmp3.xy = tmp3.xy > float2(0.5, 0.5);
                tmp3.zw = -tmp3.zw * float2(2.0, 2.0) + float2(1.0, 1.0);
                tmp1.xy = -tmp3.zw * tmp1.xy + float2(1.0, 1.0);
                tmp1.xy = saturate(tmp3.xy ? tmp1.xy : tmp2.zw);
                tmp0.y = tmp0.y * -tmp1.x + tmp1.x;
                tmp1.xy = tmp1.xy * float2(0.125, 0.125);
                tmp1.xy = tmp1.xy * _Refraction.xx;
                tmp1.z = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp2.z = dot(inp.texcoord6.xyz, inp.texcoord6.xyz);
                tmp3 = tex2D(_LightTexture0, tmp2.zz);
                tmp1.z = tmp1.z * tmp3.x;
                tmp3.xyz = tmp3.xxx * _LightColor0.xyz;
                tmp1.z = saturate(tmp1.z * 10.0);
                tmp0.x = tmp0.y * tmp1.z + tmp0.x;
                tmp0.y = 1.0 - _FreshWater;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.xy = tmp0.xx * _Gradientmap_ST.xy + _Gradientmap_ST.zw;
                tmp8 = tex2D(_Gradientmap, tmp0.xy);
                tmp0.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp9 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.x = _ZBufferParams.z * tmp9.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - _ProjectionParams.y;
                tmp0.y = inp.texcoord5.z - _ProjectionParams.y;
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.y = _ColorDensity * tmp0.x + 1.0;
                tmp0.z = _ColorFadeEnd + 1.0;
                tmp0.y = saturate(tmp0.y / tmp0.z);
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * _ColorFadeStart;
                tmp0.y = exp(tmp0.y);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.y = tmp0.y - 1.0;
                tmp0.y = _DepthBlend * tmp0.y + 1.0;
                tmp8.xyz = tmp0.yyy * tmp8.xyz;
                tmp2.zw = tmp0.xx * float2(0.5555556, 0.1) + float2(-0.1111111, 0.1);
                tmp0.xz = -tmp7.xz * tmp0.xx + inp.texcoord1.xz;
                tmp3.w = dot(tmp5.xyz, tmp7.xyz);
                tmp3.w = max(tmp3.w, 0.0);
                tmp3.w = 1.0 - tmp3.w;
                tmp0.xz = tmp0.xz * float2(0.15, 0.15) + tmp1.ww;
                tmp0.xz = tmp1.xy * float2(20.0, 20.0) + tmp0.xz;
                tmp0.xz = tmp2.xy + tmp0.xz;
                tmp0.xz = tmp0.xz * _RefractedLight_ST.xy + _RefractedLight_ST.zw;
                tmp5 = tex2D(_RefractedLight, tmp0.xz);
                tmp1.xyw = saturate(tmp5.xyz * float3(0.5, 0.5, 0.5) + float3(-0.25, -0.25, -0.25));
                tmp5 = tex2D(_Gradientmap, _Gradientmap_ST.zw);
                tmp7.xyz = tmp5.xyz * float3(10.0, 10.0, 10.0) + float3(0.1, 0.1, 0.1);
                tmp2.xyw = -tmp2.www / tmp7.xyz;
                tmp2.z = saturate(tmp2.z);
                tmp2.xyw = saturate(tmp2.xyw + float3(1.0, 1.0, 1.0));
                tmp7.xyz = tmp2.xyw * tmp2.xyw;
                tmp2.xyw = tmp2.xyw * tmp7.xyz;
                tmp7.xyz = tmp5.xyz * float3(0.5, 0.5, 0.5);
                tmp9.xyz = tmp7.xyz * tmp2.xyw + float3(-0.5, -0.5, -0.5);
                tmp2.xyw = tmp2.xyw * tmp7.xyz;
                tmp7.xyz = -tmp9.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp9.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp7.xyz = -tmp7.xyz * tmp9.xyz + float3(1.0, 1.0, 1.0);
                tmp9.xyz = tmp2.xyw * tmp5.xyz;
                tmp2.xyw = tmp2.xyw > float3(0.5, 0.5, 0.5);
                tmp9.xyz = tmp9.xyz + tmp9.xyz;
                tmp2.xyw = saturate(tmp2.xyw ? tmp7.xyz : tmp9.xyz);
                tmp0.x = 1.0 - tmp0.y;
                tmp0.yz = tmp0.yy * float2(-2.0, 0.5) + float2(1.0, 0.5);
                tmp2.xyw = tmp2.xyw * tmp0.xxx;
                tmp0.x = tmp3.w * tmp3.w;
                tmp0.x = tmp0.x * tmp3.w;
                tmp5.xyz = saturate(tmp0.xxx * float3(1.25, 1.25, 1.25) + tmp5.xyz);
                tmp2.xyw = tmp8.xyz * tmp5.xyz + tmp2.xyw;
                tmp1.xyw = tmp0.yyy * tmp1.xyw;
                tmp0.x = max(tmp0.z, 0.5);
                tmp0.x = min(tmp0.x, 1.0);
                tmp1.xyz = tmp1.zzz * tmp1.xyw;
                tmp1.xyz = saturate(tmp2.zzz * tmp1.xyz);
                tmp1.xyz = tmp1.xyz + tmp2.xyw;
                tmp2.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.y = dot(tmp2.xyz, tmp2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp2.xyz = tmp0.yyy * tmp2.xyz;
                tmp0.y = dot(tmp4.xyz, tmp2.xyz);
                tmp2.xyz = tmp6.xyz * tmp0.www + tmp2.xyz;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.yzw = tmp3.xyz * tmp0.yyy;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp4.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * 362.0387;
                tmp1.w = exp(tmp1.w);
                tmp2.xyz = tmp1.www * tmp3.xyz;
                tmp2.xyz = tmp2.xyz * float3(5.0, 5.0, 5.0);
                tmp0.yzw = tmp0.yzw * tmp1.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 157243
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _WaveScale;
			float4 _WaveNoise_ST;
			float _WaveEnergy;
			float _WaveOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _DisperseSizeSpeed;
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
                tmp1.x = _Time.y * 0.0167;
                tmp0.xy = tmp0.xy * float2(0.0125, 0.0125) + tmp1.xx;
                tmp0.xy = tmp0.xy * _WaveNoise_ST.xy + _WaveNoise_ST.zw;
                tmp1 = tex2Dlod(_WaveNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.xy = tmp0.zw * float2(0.025, 0.025) + tmp1.xx;
                tmp0.xy = _Time.yy * float2(-0.1, -0.1) + tmp0.xy;
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
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
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
                o.texcoord1.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = _DisperseSizeSpeed.zw * _Time.yy;
                tmp0.xy = inp.texcoord1.xy * _DisperseSizeSpeed.xy + tmp0.xy;
                tmp0.zw = floor(tmp0.xy);
                tmp0.xy = frac(tmp0.xy);
                tmp1 = tmp0.zwzw + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp1.z = tmp1.w * tmp1.z;
                tmp2.xy = tmp0.zw + float2(1.2127, 1.2127);
                tmp1.zw = tmp1.zz * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.xy = tmp1.zw * float2(489.123, 489.123);
                tmp1.z = tmp1.z + 1.0;
                tmp2.xy = sin(tmp2.xy);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp1.w = tmp2.y * tmp2.x;
                tmp1.z = tmp1.z * tmp1.w;
                tmp2 = tmp0.zwzw + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp1.w = tmp2.w * tmp2.z;
                tmp1.xy = tmp1.ww * float2(0.3713, 0.3713) + tmp1.xy;
                tmp1.yw = tmp1.xy * float2(489.123, 489.123);
                tmp1.x = tmp1.x + 1.0;
                tmp1.yw = sin(tmp1.yw);
                tmp1.yw = tmp1.yw * float2(4.789, 4.789);
                tmp1.y = tmp1.w * tmp1.y;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.xz = frac(tmp1.xz);
                tmp1.y = tmp1.z - tmp1.x;
                tmp1.zw = -tmp0.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.xy = tmp1.zw * tmp0.xy;
                tmp1.x = tmp0.x * tmp1.y + tmp1.x;
                tmp3 = tmp0.zwzw + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.zw = tmp0.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp1.y = tmp3.w * tmp3.z;
                tmp1.yz = tmp1.yy * float2(0.3713, 0.3713) + tmp2.xy;
                tmp1.zw = tmp1.yz * float2(489.123, 489.123);
                tmp1.y = tmp1.y + 1.0;
                tmp1.zw = sin(tmp1.zw);
                tmp1.zw = tmp1.zw * float2(4.789, 4.789);
                tmp1.z = tmp1.w * tmp1.z;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.y = frac(tmp1.y);
                tmp1.zw = tmp0.zw * float2(489.123, 489.123);
                tmp0.z = tmp0.z + 1.0;
                tmp1.zw = sin(tmp1.zw);
                tmp1.zw = tmp1.zw * float2(4.789, 4.789);
                tmp0.w = tmp1.w * tmp1.z;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = frac(tmp0.z);
                tmp0.w = tmp1.y - tmp0.z;
                tmp0.x = tmp0.x * tmp0.w + tmp0.z;
                tmp0.z = tmp1.x - tmp0.x;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.x = dot(tmp0.xy, inp.color.xy);
                tmp0.z = inp.color.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.y = -tmp0.z * tmp0.y + 1.0;
                tmp0.z = inp.color.x > 0.5;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/Environment/Depth Water Opaque"
	CustomEditor "ShaderForgeMaterialInspector"
}