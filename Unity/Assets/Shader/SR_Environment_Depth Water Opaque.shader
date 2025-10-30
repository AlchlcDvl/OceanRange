Shader "SR/Environment/Depth Water Opaque" {
	Properties {
		_WaveMap ("Wave Map", 2D) = "white" {}
		_NormalStrength ("Normal Strength", Float) = 5
		_WaveSpeed ("Wave Speed", Float) = 0.25
		_WaveEnergy ("Wave Energy", Float) = 1
		_WaveScale ("Wave Scale", Float) = 0.4
		_WaveOffset ("Wave Offset", Float) = 0
		_Gradientmap ("Gradient map", 2D) = "white" {}
		[MaterialToggle] _Refraction ("Refraction", Float) = 0
		[MaterialToggle] _FreshWater ("Fresh Water", Float) = 1
		_WaveNoise ("Wave Noise", 2D) = "white" {}
		_FresnelStrength ("Fresnel Strength", Float) = 0
		_RefractedLight ("Refracted Light", 2D) = "white" {}
		_DisperseSizeSpeed ("Disperse Size/Speed", Vector) = (10,10,0,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 7185
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
			float4 _Gradientmap_ST;
			float _Refraction;
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
			sampler2D _RefractedLight;
			
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
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp0.yz = tmp0.xx * _DisperseSizeSpeed.zw;
                tmp0.yz = inp.texcoord.xy * _DisperseSizeSpeed.xy + tmp0.yz;
                tmp1.xy = floor(tmp0.yz);
                tmp2 = tmp1.xyxy + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp0.w = tmp2.w * tmp2.z;
                tmp1.zw = tmp1.xy + float2(1.2127, 1.2127);
                tmp1.zw = tmp0.ww * float2(0.3713, 0.3713) + tmp1.zw;
                tmp2.zw = tmp1.zw * float2(489.123, 489.123);
                tmp0.w = tmp1.z + 1.0;
                tmp1.zw = sin(tmp2.zw);
                tmp1.zw = tmp1.zw * float2(4.789, 4.789);
                tmp1.z = tmp1.w * tmp1.z;
                tmp0.w = tmp0.w * tmp1.z;
                tmp0.yzw = frac(tmp0.yzw);
                tmp3 = tmp1.xyxy + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp1.z = tmp3.w * tmp3.z;
                tmp1.zw = tmp1.zz * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.xy = tmp1.zw * float2(489.123, 489.123);
                tmp1.z = tmp1.z + 1.0;
                tmp2.xy = sin(tmp2.xy);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp1.w = tmp2.y * tmp2.x;
                tmp1.z = tmp1.z * tmp1.w;
                tmp1.z = frac(tmp1.z);
                tmp0.w = tmp0.w - tmp1.z;
                tmp2.xy = -tmp0.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.yz = tmp2.xy * tmp0.yz;
                tmp0.w = tmp0.y * tmp0.w + tmp1.z;
                tmp2 = tmp1.xyxy + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.xy = tmp1.xx * float2(0.3713, 0.3713) + tmp2.xy;
                tmp1.z = tmp2.w * tmp2.z;
                tmp1.zw = tmp1.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp2.xy = tmp1.zw * float2(489.123, 489.123);
                tmp1.z = tmp1.z + 1.0;
                tmp2.xy = sin(tmp2.xy);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp1.w = tmp2.y * tmp2.x;
                tmp1.z = tmp1.z * tmp1.w;
                tmp1.yw = tmp1.xy * float2(489.123, 489.123);
                tmp1.x = tmp1.x + 1.0;
                tmp1.yw = sin(tmp1.yw);
                tmp1.yw = tmp1.yw * float2(4.789, 4.789);
                tmp1.y = tmp1.w * tmp1.y;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.xz = frac(tmp1.xz);
                tmp1.y = tmp1.z - tmp1.x;
                tmp0.y = tmp0.y * tmp1.y + tmp1.x;
                tmp0.w = tmp0.w - tmp0.y;
                tmp0.y = tmp0.z * tmp0.w + tmp0.y;
                tmp0.z = 1.0 - tmp0.y;
                tmp0.w = inp.color.x - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.z = -tmp0.w * tmp0.z + 1.0;
                tmp0.w = dot(tmp0.xy, inp.color.xy);
                tmp1.x = inp.color.x > 0.5;
                tmp0.z = saturate(tmp1.x ? tmp0.z : tmp0.w);
                tmp0.z = tmp0.z - 0.5;
                tmp0.zw = tmp0.zx < float2(0.0, 0.0);
                if (tmp0.z) {
                    discard;
                }
                tmp0.z = tmp0.x > 0.0;
                tmp0.z = tmp0.w - tmp0.z;
                tmp0.z = floor(tmp0.z);
                tmp1.xy = inp.texcoord1.zx * float2(0.0125, 0.0125);
                tmp1.zw = tmp0.xx * float2(0.0025, 0.0167);
                tmp2 = inp.texcoord1.zxzx * float4(0.0125, 0.0125, 0.0125, 0.0125) + tmp1.zzww;
                tmp2 = tmp2 * _WaveNoise_ST + _WaveNoise_ST;
                tmp3 = tex2D(_WaveNoise, tmp2.xy);
                tmp2 = tex2D(_WaveNoise, tmp2.zw);
                tmp1.zw = inp.texcoord1.zx * float2(0.025, 0.025) + tmp2.xx;
                tmp1.zw = tmp0.xx * float2(-0.1, -0.1) + tmp1.zw;
                tmp0.x = tmp0.x * _WaveSpeed;
                tmp2.xyz = tmp0.xxx * float3(-0.15, 0.3, 0.45);
                tmp0.xw = tmp1.zw * _WaveEnergy.xx;
                tmp1.xy = tmp3.xx * float2(0.2, 0.2) + tmp1.xy;
                tmp1.xy = tmp0.zz * float2(0.1, 0.1) + tmp1.xy;
                tmp3 = inp.texcoord1.zxzx * float4(0.0125, 0.0125, 0.025, 0.025) + tmp2.xxyy;
                tmp2.xy = inp.texcoord1.xz * float2(0.1, 0.1) + tmp2.zz;
                tmp2.xy = tmp1.xy + tmp2.xy;
                tmp1.zw = float2(0.0, 0.04);
                tmp4 = tmp1.xzzx + tmp3.xyxy;
                tmp4 = tmp1.wxxw + tmp4;
                tmp4 = tmp4 * _WaveMap_ST + _WaveMap_ST;
                tmp5 = tex2D(_WaveMap, tmp4.xy);
                tmp4 = tex2D(_WaveMap, tmp4.zw);
                tmp6 = tmp1.xxxx + tmp3;
                tmp6 = tmp6 * _WaveMap_ST + _WaveMap_ST;
                tmp7 = tex2D(_WaveMap, tmp6.xy);
                tmp6 = tex2D(_WaveMap, tmp6.zw);
                tmp0.z = tmp7.x - tmp5.x;
                tmp1.y = tmp7.x - tmp4.x;
                tmp2.z = saturate(_NormalStrength);
                tmp4.x = tmp0.z * tmp2.z;
                tmp4.y = tmp1.y * tmp2.z;
                tmp0.z = dot(tmp4.xy, tmp4.xy);
                tmp0.z = 1.0 - tmp0.z;
                tmp5 = tmp1.xzzx + tmp3.zwzw;
                tmp1 = tmp1.wxxw + tmp5;
                tmp1 = tmp1 * _WaveMap_ST + _WaveMap_ST;
                tmp3 = tmp3 * _WaveMap_ST + _WaveMap_ST;
                tmp5 = tex2D(_WaveMap, tmp1.xy);
                tmp1 = tex2D(_WaveMap, tmp1.zw);
                tmp1.x = tmp6.x - tmp1.x;
                tmp1.y = tmp6.x - tmp5.x;
                tmp5.x = tmp2.z * tmp1.y;
                tmp5.y = tmp1.x * tmp2.z;
                tmp1.x = dot(tmp5.xy, tmp5.xy);
                tmp5.z = tmp0.z - tmp1.x;
                tmp4.z = 1.0;
                tmp1.xyz = tmp4.xyz + tmp5.xyz;
                tmp4.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5);
                tmp1.xyz = -tmp1.xyz * float3(0.5, 0.5, 0.5) + float3(0.0, 0.0, 1.0);
                tmp2.zw = floor(tmp0.xw);
                tmp0.z = tmp2.w * 57.0 + tmp2.z;
                tmp5.xyz = tmp0.zzz + float3(1.0, 57.0, 58.0);
                tmp6.x = sin(tmp0.z);
                tmp6.yzw = sin(tmp5.xyz);
                tmp5 = tmp6 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp5 = frac(tmp5);
                tmp2.zw = tmp5.yw - tmp5.xz;
                tmp5.yw = frac(tmp0.xw);
                tmp0.xz = tmp0.xw + tmp0.xw;
                tmp6.xy = tmp5.yw * tmp5.yw;
                tmp5.yw = -tmp5.yw * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp5.yw = tmp5.yw * tmp6.xy;
                tmp2.zw = tmp5.yy * tmp2.zw + tmp5.xz;
                tmp0.w = tmp2.w - tmp2.z;
                tmp0.w = tmp5.w * tmp0.w + tmp2.z;
                tmp2.zw = floor(tmp0.xz);
                tmp0.xz = frac(tmp0.xz);
                tmp1.w = tmp2.w * 57.0 + tmp2.z;
                tmp5.xyz = tmp1.www + float3(1.0, 57.0, 58.0);
                tmp6.x = sin(tmp1.w);
                tmp6.yzw = sin(tmp5.xyz);
                tmp5 = tmp6 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp5 = frac(tmp5);
                tmp2.zw = tmp5.yw - tmp5.xz;
                tmp5.yw = tmp0.xz * tmp0.xz;
                tmp0.xz = -tmp0.xz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xz = tmp0.xz * tmp5.yw;
                tmp2.zw = tmp0.xx * tmp2.zw + tmp5.xz;
                tmp0.x = tmp2.w - tmp2.z;
                tmp0.x = tmp0.z * tmp0.x + tmp2.z;
                tmp0.x = tmp0.w * 2.0 + tmp0.x;
                tmp0.z = tmp0.x * 0.5;
                tmp5.xyz = tmp0.xxx * float3(-0.125, -16.66666, -1.25) + float3(1.0, 5.0, 1.0);
                tmp1.xyz = saturate(tmp0.zzz * tmp1.xyz + tmp4.xyz);
                tmp0.z = saturate(tmp0.z);
                tmp4.xyz = tmp1.yyy * inp.texcoord4.xyz;
                tmp1.xyw = tmp1.xxx * inp.texcoord3.xyz + tmp4.xyz;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp4.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xyz = tmp1.zzz * tmp4.xyz + tmp1.xyw;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp0.x = saturate(tmp1.y);
                tmp4.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp6.xyz = tmp0.www * tmp4.xyz;
                tmp1.w = dot(tmp1.xyz, tmp6.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.z = tmp1.w * tmp1.w;
                tmp2.z = tmp1.w * tmp2.z;
                tmp0.x = tmp0.x * tmp2.z;
                tmp5.xy = saturate(tmp5.xy);
                tmp0.x = tmp0.x * tmp5.x;
                tmp2.w = tmp5.y * 0.5;
                tmp2.w = saturate(tmp5.z * 0.5 + tmp2.w);
                tmp5 = tex2D(_WaveMap, tmp3.xy);
                tmp3 = tex2D(_WaveMap, tmp3.zw);
                tmp6.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp5.xyz = tmp3.xyz * tmp5.xyz;
                tmp5.xyz = tmp5.xyz + tmp5.xyz;
                tmp7.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp6.xyz = -tmp7.xyz * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = saturate(tmp3.xyz ? tmp6.xyz : tmp5.xyz);
                tmp5.xyz = tmp0.zzz * -tmp3.xyz + tmp3.xyz;
                tmp3.xy = tmp3.xy * float2(0.125, 0.125);
                tmp3.xy = tmp3.xy * _Refraction.xx;
                tmp2.xy = tmp3.xy * float2(20.0, 20.0) + tmp2.xy;
                tmp2.xy = tmp2.xy * _RefractedLight_ST.xy;
                tmp2.xy = tmp2.xy * float2(0.5, 0.5) + _RefractedLight_ST.zw;
                tmp3 = tex2D(_RefractedLight, tmp2.xy);
                tmp3.xyz = saturate(tmp3.xyz * float3(0.6, 0.6, 0.6) + float3(-0.3, -0.3, -0.3));
                tmp0.z = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp0.z = saturate(tmp0.z * 10.0);
                tmp0.x = tmp5.x * tmp0.z + tmp0.x;
                tmp5.xyz = max(tmp5.xyz, float3(0.0, 0.0, 0.0));
                tmp0.z = 1.0 - _FreshWater;
                tmp0.x = tmp0.z * tmp2.w + tmp0.x;
                tmp0.xz = tmp0.xx * _Gradientmap_ST.xy + _Gradientmap_ST.zw;
                tmp6 = tex2D(_Gradientmap, tmp0.xz);
                tmp0.x = tmp1.w * 6.666668 + -5.000001;
                tmp2.xy = _Gradientmap_ST.zw + _Gradientmap_ST.xy;
                tmp7 = tex2D(_Gradientmap, tmp2.xy);
                tmp8 = tex2D(_Gradientmap, _Gradientmap_ST.zw);
                tmp2.xyw = tmp7.xyz - tmp8.xyz;
                tmp7.xyz = tmp0.xxx * tmp2.xyw + tmp8.xyz;
                tmp7.xyz = tmp1.www * tmp7.xyz;
                tmp7.xyz = saturate(tmp7.xyz * _FresnelStrength.xxx);
                tmp3.xyz = _FreshWater.xxx * tmp3.xyz + tmp7.xyz;
                tmp3.xyz = tmp5.xyz * tmp6.xyz + tmp3.xyz;
                tmp0.x = inp.color.x * -4.0 + 4.0;
                tmp0.x = saturate(tmp0.y * tmp0.x);
                tmp2.xyw = tmp0.xxx * tmp2.xyw + tmp8.xyz;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = floor(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp2.xyw;
                tmp0.xyz = tmp0.xyz * float3(0.333, 0.333, 0.333) + tmp3.xyz;
                tmp2.xyz = saturate(tmp2.zzz * float3(1.25, 1.25, 1.25) + tmp8.xyz);
                tmp2.xyz = tmp2.xyz * tmp6.xyz;
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp4.xyz = tmp4.xyz * tmp0.www + tmp3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp4.xyz;
                tmp1.x = dot(tmp3.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * 362.0387;
                tmp1.x = exp(tmp1.x);
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * float3(5.0, 5.0, 5.0);
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp3.xyz = tmp0.www * _LightColor0.xyz + tmp3.xyz;
                tmp1.xyz = tmp3.xyz * tmp2.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" }
			Blend One One, One One
			GpuProgramID 87003
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
				float3 texcoord5 : TEXCOORD5;
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
			float4 _Gradientmap_ST;
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
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord3.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord4.xyz = tmp1.www * tmp1.xyz;
                o.color = v.color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp0.yz = tmp0.xx * _DisperseSizeSpeed.zw;
                tmp0.yz = inp.texcoord.xy * _DisperseSizeSpeed.xy + tmp0.yz;
                tmp1.xy = floor(tmp0.yz);
                tmp2 = tmp1.xyxy + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp0.w = tmp2.w * tmp2.z;
                tmp1.zw = tmp1.xy + float2(1.2127, 1.2127);
                tmp1.zw = tmp0.ww * float2(0.3713, 0.3713) + tmp1.zw;
                tmp2.zw = tmp1.zw * float2(489.123, 489.123);
                tmp0.w = tmp1.z + 1.0;
                tmp1.zw = sin(tmp2.zw);
                tmp1.zw = tmp1.zw * float2(4.789, 4.789);
                tmp1.z = tmp1.w * tmp1.z;
                tmp0.w = tmp0.w * tmp1.z;
                tmp0.yzw = frac(tmp0.yzw);
                tmp3 = tmp1.xyxy + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp1.z = tmp3.w * tmp3.z;
                tmp1.zw = tmp1.zz * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.xy = tmp1.zw * float2(489.123, 489.123);
                tmp1.z = tmp1.z + 1.0;
                tmp2.xy = sin(tmp2.xy);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp1.w = tmp2.y * tmp2.x;
                tmp1.z = tmp1.z * tmp1.w;
                tmp1.z = frac(tmp1.z);
                tmp0.w = tmp0.w - tmp1.z;
                tmp2.xy = -tmp0.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.yz = tmp2.xy * tmp0.yz;
                tmp0.w = tmp0.y * tmp0.w + tmp1.z;
                tmp2 = tmp1.xyxy + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.xy = tmp1.xx * float2(0.3713, 0.3713) + tmp2.xy;
                tmp1.z = tmp2.w * tmp2.z;
                tmp1.zw = tmp1.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp2.xy = tmp1.zw * float2(489.123, 489.123);
                tmp1.z = tmp1.z + 1.0;
                tmp2.xy = sin(tmp2.xy);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp1.w = tmp2.y * tmp2.x;
                tmp1.z = tmp1.z * tmp1.w;
                tmp1.yw = tmp1.xy * float2(489.123, 489.123);
                tmp1.x = tmp1.x + 1.0;
                tmp1.yw = sin(tmp1.yw);
                tmp1.yw = tmp1.yw * float2(4.789, 4.789);
                tmp1.y = tmp1.w * tmp1.y;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.xz = frac(tmp1.xz);
                tmp1.y = tmp1.z - tmp1.x;
                tmp0.y = tmp0.y * tmp1.y + tmp1.x;
                tmp0.w = tmp0.w - tmp0.y;
                tmp0.y = tmp0.z * tmp0.w + tmp0.y;
                tmp0.z = 1.0 - tmp0.y;
                tmp0.y = dot(tmp0.xy, inp.color.xy);
                tmp0.w = inp.color.x - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.z = -tmp0.w * tmp0.z + 1.0;
                tmp0.w = inp.color.x > 0.5;
                tmp0.y = saturate(tmp0.w ? tmp0.z : tmp0.y);
                tmp0.y = tmp0.y - 0.5;
                tmp0.yz = tmp0.yx < float2(0.0, 0.0);
                if (tmp0.y) {
                    discard;
                }
                tmp0.y = tmp0.x > 0.0;
                tmp0.y = tmp0.z - tmp0.y;
                tmp0.y = floor(tmp0.y);
                tmp0.zw = tmp0.xx * float2(0.0025, 0.0167);
                tmp1 = inp.texcoord1.zxzx * float4(0.0125, 0.0125, 0.0125, 0.0125) + tmp0.zzww;
                tmp1 = tmp1 * _WaveNoise_ST + _WaveNoise_ST;
                tmp2 = tex2D(_WaveNoise, tmp1.xy);
                tmp1 = tex2D(_WaveNoise, tmp1.zw);
                tmp0.zw = inp.texcoord1.zx * float2(0.025, 0.025) + tmp1.xx;
                tmp0.zw = tmp0.xx * float2(-0.1, -0.1) + tmp0.zw;
                tmp0.x = tmp0.x * _WaveSpeed;
                tmp0.zw = tmp0.zw * _WaveEnergy.xx;
                tmp1 = inp.texcoord1.zxzx * float4(0.0125, 0.0125, 0.025, 0.025);
                tmp2.x = tmp2.x * 0.2 + tmp1.x;
                tmp1 = tmp0.xxxx * float4(-0.15, -0.15, 0.3, 0.3) + tmp1;
                tmp2.x = tmp0.y * 0.1 + tmp2.x;
                tmp2.yz = float2(0.0, 0.04);
                tmp3 = tmp1.xyxy + tmp2.xyyx;
                tmp3 = tmp2.zxxz + tmp3;
                tmp3 = tmp3 * _WaveMap_ST + _WaveMap_ST;
                tmp4 = tex2D(_WaveMap, tmp3.xy);
                tmp3 = tex2D(_WaveMap, tmp3.zw);
                tmp5 = tmp1 + tmp2.xxxx;
                tmp5 = tmp5 * _WaveMap_ST + _WaveMap_ST;
                tmp6 = tex2D(_WaveMap, tmp5.xy);
                tmp5 = tex2D(_WaveMap, tmp5.zw);
                tmp0.x = tmp6.x - tmp4.x;
                tmp0.y = tmp6.x - tmp3.x;
                tmp2.w = saturate(_NormalStrength);
                tmp3.x = tmp0.x * tmp2.w;
                tmp3.y = tmp0.y * tmp2.w;
                tmp0.x = dot(tmp3.xy, tmp3.xy);
                tmp0.x = 1.0 - tmp0.x;
                tmp4 = tmp1.zwzw + tmp2.xyyx;
                tmp4 = tmp2.zxxz + tmp4;
                tmp4 = tmp4 * _WaveMap_ST + _WaveMap_ST;
                tmp1 = tmp1 * _WaveMap_ST + _WaveMap_ST;
                tmp6 = tex2D(_WaveMap, tmp4.xy);
                tmp4 = tex2D(_WaveMap, tmp4.zw);
                tmp0.y = tmp5.x - tmp4.x;
                tmp2.x = tmp5.x - tmp6.x;
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.y = tmp0.y * tmp2.w;
                tmp0.y = dot(tmp2.xy, tmp2.xy);
                tmp2.z = tmp0.x - tmp0.y;
                tmp3.z = 1.0;
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(0.5, 0.5, 0.5) + float3(0.0, 0.0, 1.0);
                tmp0.xy = floor(tmp0.zw);
                tmp0.x = tmp0.y * 57.0 + tmp0.x;
                tmp4.xyz = tmp0.xxx + float3(1.0, 57.0, 58.0);
                tmp5.x = sin(tmp0.x);
                tmp5.yzw = sin(tmp4.xyz);
                tmp4 = tmp5 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp4 = frac(tmp4);
                tmp0.xy = tmp4.yw - tmp4.xz;
                tmp4.yw = frac(tmp0.zw);
                tmp0.zw = tmp0.zw + tmp0.zw;
                tmp5.xy = tmp4.yw * tmp4.yw;
                tmp4.yw = -tmp4.yw * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp4.yw = tmp4.yw * tmp5.xy;
                tmp0.xy = tmp4.yy * tmp0.xy + tmp4.xz;
                tmp0.y = tmp0.y - tmp0.x;
                tmp0.x = tmp4.w * tmp0.y + tmp0.x;
                tmp4.xy = floor(tmp0.zw);
                tmp0.yz = frac(tmp0.zw);
                tmp0.w = tmp4.y * 57.0 + tmp4.x;
                tmp4.xyz = tmp0.www + float3(1.0, 57.0, 58.0);
                tmp5.x = sin(tmp0.w);
                tmp5.yzw = sin(tmp4.xyz);
                tmp4 = tmp5 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                tmp4 = frac(tmp4);
                tmp4.yw = tmp4.yw - tmp4.xz;
                tmp5.xy = tmp0.yz * tmp0.yz;
                tmp0.yz = -tmp0.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.yz = tmp0.yz * tmp5.xy;
                tmp0.yw = tmp0.yy * tmp4.yw + tmp4.xz;
                tmp0.w = tmp0.w - tmp0.y;
                tmp0.y = tmp0.z * tmp0.w + tmp0.y;
                tmp0.x = tmp0.x * 2.0 + tmp0.y;
                tmp0.y = tmp0.x * 0.5;
                tmp0.xzw = tmp0.xxx * float3(-0.125, -16.66666, -1.25) + float3(1.0, 5.0, 1.0);
                tmp2.xyz = saturate(tmp0.yyy * tmp2.xyz + tmp3.xyz);
                tmp3.xyz = tmp2.yyy * inp.texcoord4.xyz;
                tmp2.xyw = tmp2.xxx * inp.texcoord3.xyz + tmp3.xyz;
                tmp3.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp3.xyz = tmp3.xxx * inp.texcoord2.xyz;
                tmp2.xyz = tmp2.zzz * tmp3.xyz + tmp2.xyw;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.w = saturate(tmp2.y);
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp3.w = dot(tmp3.xyz, tmp3.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp4.xyz = tmp3.www * tmp3.xyz;
                tmp4.x = dot(tmp2.xyz, tmp4.xyz);
                tmp4.x = max(tmp4.x, 0.0);
                tmp4.x = 1.0 - tmp4.x;
                tmp4.y = tmp4.x * tmp4.x;
                tmp4.x = tmp4.y * tmp4.x;
                tmp2.w = tmp2.w * tmp4.x;
                tmp0.xyz = saturate(tmp0.xyz);
                tmp0.x = tmp0.x * tmp2.w;
                tmp0.z = tmp0.z * 0.5;
                tmp0.z = saturate(tmp0.w * 0.5 + tmp0.z);
                tmp5 = tex2D(_WaveMap, tmp1.xy);
                tmp1 = tex2D(_WaveMap, tmp1.zw);
                tmp0.w = 1.0 - tmp5.x;
                tmp1.y = dot(tmp5.xy, tmp1.xy);
                tmp1.z = tmp1.x - 0.5;
                tmp1.x = tmp1.x > 0.5;
                tmp1.z = -tmp1.z * 2.0 + 1.0;
                tmp0.w = -tmp1.z * tmp0.w + 1.0;
                tmp0.w = saturate(tmp1.x ? tmp0.w : tmp1.y);
                tmp0.y = tmp0.y * -tmp0.w + tmp0.w;
                tmp0.w = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp1.x = dot(inp.texcoord5.xyz, inp.texcoord5.xyz);
                tmp1 = tex2D(_LightTexture0, tmp1.xx);
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp0.w = saturate(tmp0.w * 10.0);
                tmp0.x = tmp0.y * tmp0.w + tmp0.x;
                tmp0.y = 1.0 - _FreshWater;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.xy = tmp0.xx * _Gradientmap_ST.xy + _Gradientmap_ST.zw;
                tmp0 = tex2D(_Gradientmap, tmp0.xy);
                tmp5 = tex2D(_Gradientmap, _Gradientmap_ST.zw);
                tmp4.xyz = saturate(tmp4.xxx * float3(1.25, 1.25, 1.25) + tmp5.xyz);
                tmp0.xyz = tmp0.xyz * tmp4.xyz;
                tmp4.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = dot(tmp2.xyz, tmp4.xyz);
                tmp3.xyz = tmp3.xyz * tmp3.www + tmp4.xyz;
                tmp0.w = max(tmp0.w, 0.0);
                tmp4.xyz = tmp1.xyz * tmp0.www;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp0.w = dot(tmp3.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 362.0387;
                tmp0.w = exp(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(5.0, 5.0, 5.0);
                o.sv_target.xyz = tmp4.xyz * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 194354
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
			float4 _TimeEditor;
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
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp0.xy = tmp0.xx * _DisperseSizeSpeed.zw;
                tmp0.xy = inp.texcoord1.xy * _DisperseSizeSpeed.xy + tmp0.xy;
                tmp0.zw = floor(tmp0.xy);
                tmp0.xy = frac(tmp0.xy);
                tmp1.xy = tmp0.zw + float2(1.2127, 1.2127);
                tmp2 = tmp0.zwzw + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp1.z = tmp2.w * tmp2.z;
                tmp1.xy = tmp1.zz * float2(0.3713, 0.3713) + tmp1.xy;
                tmp1.yz = tmp1.xy * float2(489.123, 489.123);
                tmp1.x = tmp1.x + 1.0;
                tmp1.yz = sin(tmp1.yz);
                tmp1.yz = tmp1.yz * float2(4.789, 4.789);
                tmp1.y = tmp1.z * tmp1.y;
                tmp1.x = tmp1.x * tmp1.y;
                tmp3 = tmp0.zwzw + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp1.y = tmp3.w * tmp3.z;
                tmp1.yz = tmp1.yy * float2(0.3713, 0.3713) + tmp2.xy;
                tmp1.zw = tmp1.yz * float2(489.123, 489.123);
                tmp1.y = tmp1.y + 1.0;
                tmp1.zw = sin(tmp1.zw);
                tmp1.zw = tmp1.zw * float2(4.789, 4.789);
                tmp1.z = tmp1.w * tmp1.z;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.xy = frac(tmp1.xy);
                tmp1.x = tmp1.x - tmp1.y;
                tmp1.zw = -tmp0.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.xy = tmp1.zw * tmp0.xy;
                tmp1.x = tmp0.x * tmp1.x + tmp1.y;
                tmp2 = tmp0.zwzw + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.zw = tmp0.zz * float2(0.3713, 0.3713) + tmp2.xy;
                tmp1.y = tmp2.w * tmp2.z;
                tmp1.yz = tmp1.yy * float2(0.3713, 0.3713) + tmp3.xy;
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
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}