Shader "SR/Environment/Depth Water" {
	Properties {
		_WaveMap ("Wave Map", 2D) = "white" {}
		_NormalStrength ("Normal Strength", Float) = 5
		_WaveSpeed ("Wave Speed", Float) = 0.25
		_WaveEnergy ("Wave Energy", Float) = 1
		_WaveScale ("Wave Scale", Float) = 0.4
		_WaveOffset ("Wave Offset", Float) = 0
		_ColorFadeStart ("Color Fade Start", Float) = 1
		_ColorFadeEnd ("Color Fade End", Float) = 8
		_ColorDensity ("Color Density", Float) = 0.4
		_Gradientmap ("Gradient map", 2D) = "white" {}
		[MaterialToggle] _Refraction ("Refraction", Float) = 0
		[MaterialToggle] _DepthBlend ("Depth Blend", Float) = 0.1111111
		_BlurOffset ("Blur Offset", Float) = 0
		_RefractedLight ("Refracted Light", 2D) = "white" {}
		[MaterialToggle] _FreshWater ("Fresh Water", Float) = 1
		_WaveNoise ("Wave Noise", 2D) = "white" {}
		[MaterialToggle] _Relections ("Relections", Float) = 0
		_ReflectionProbe ("Reflection Probe", Cube) = "_Skybox" {}
		_FresnelStrength ("Fresnel Strength", Float) = 0
		_DisperseSizeSpeed ("Disperse Size/Speed", Vector) = (10,10,0,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 750
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" }
		GrabPass {
			"waterSceneColor"
		}
		Pass {
			Name "FORWARD"
			LOD 750
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			GpuProgramID 60122
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
			float _BlurOffset;
			float4 _RefractedLight_ST;
			float _FreshWater;
			float4 _DisperseSizeSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _WaveNoise;
			// Texture params for Fragment Shader
			sampler2D _WaveMap;
			sampler2D waterSceneColor;
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
                tmp0.x = tmp0.x * _WaveScale;
                tmp1.xz = tmp0.xx * v.normal.xz;
                tmp1.y = tmp0.x * v.normal.y + _WaveOffset;
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
                float4 tmp11;
                float4 tmp12;
                float4 tmp13;
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
                tmp4.z = 1.0 - tmp0.w;
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
                tmp5.z = 1.0 - tmp0.w;
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
                tmp5.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.x = dot(tmp5.xyz, tmp5.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp6.xyz = tmp1.xxx * tmp5.xyz;
                tmp1.y = dot(tmp4.xyz, tmp6.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = 1.0 - tmp1.y;
                tmp2.z = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp2.z;
                tmp0.w = tmp0.w * tmp1.y;
                tmp0.w = tmp1.z * tmp0.w;
                tmp7 = tex2D(_WaveMap, tmp3.xy);
                tmp3 = tex2D(_WaveMap, tmp3.zw);
                tmp8 = float4(1.0, 1.0, 1.0, 1.0) - tmp7.xyxy;
                tmp7 = tmp3.xyxy * tmp7.xyxy;
                tmp7 = tmp7 + tmp7;
                tmp9 = tmp3.xyxy - float4(0.5, 0.5, 0.5, 0.5);
                tmp3 = tmp3.xyxy > float4(0.5, 0.5, 0.5, 0.5);
                tmp9 = -tmp9 * float4(2.0, 2.0, 2.0, 2.0) + float4(1.0, 1.0, 1.0, 1.0);
                tmp8 = -tmp9 * tmp8 + float4(1.0, 1.0, 1.0, 1.0);
                tmp3 = saturate(tmp3 ? tmp8 : tmp7);
                tmp0.y = tmp0.y * -tmp3.z + tmp3.z;
                tmp3 = tmp3 * float4(0.125, 0.125, 0.125, 0.125);
                tmp1.z = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp1.z = dot(tmp1.xyz, float3(0.3, 0.59, 0.11));
                tmp1.z = saturate(tmp1.z + tmp1.z);
                tmp0.y = tmp0.y * tmp1.z + tmp0.w;
                tmp0.w = 1.0 - _FreshWater;
                tmp0.y = tmp0.w * tmp0.z + tmp0.y;
                tmp0.yz = tmp0.yy * _Gradientmap_ST.xy + _Gradientmap_ST.zw;
                tmp7 = tex2D(_Gradientmap, tmp0.yz);
                tmp0.yz = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp8 = tex2D(_CameraDepthTexture, tmp0.yz);
                tmp9.xy = _Refraction.xx * tmp3.xy + tmp0.yz;
                tmp3 = tmp3 * _Refraction.xxxx;
                tmp0.y = _ZBufferParams.z * tmp8.x + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.y = tmp0.y - _ProjectionParams.y;
                tmp0.z = inp.texcoord5.z - _ProjectionParams.y;
                tmp0.yz = max(tmp0.yz, float2(0.0, 0.0));
                tmp0.y = tmp0.y - tmp0.z;
                tmp0.z = _ColorDensity * tmp0.y + 1.0;
                tmp0.w = _ColorFadeEnd + 1.0;
                tmp0.z = saturate(tmp0.z / tmp0.w);
                tmp0.z = log(tmp0.z);
                tmp0.z = tmp0.z * _ColorFadeStart;
                tmp0.z = exp(tmp0.z);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.z = tmp0.z - 1.0;
                tmp0.z = _DepthBlend * tmp0.z + 1.0;
                tmp7.xyz = tmp0.zzz * tmp7.xyz;
                tmp0.w = tmp0.z * 1.49925;
                tmp0.w = saturate(tmp0.w);
                tmp8 = tmp0.wwww * _BlurOffset.xxxx + tmp9.xyxy;
                tmp10 = -tmp0.wwww * _BlurOffset.xxxx + tmp9.xyxy;
                tmp9.zw = tmp8.xy;
                tmp8 = tex2D(waterSceneColor, tmp8.zw);
                tmp11 = tex2D(waterSceneColor, tmp9.zy);
                tmp12 = tex2D(waterSceneColor, tmp9.xy);
                tmp11.xyz = tmp11.xyz + tmp12.xyz;
                tmp12 = tex2D(waterSceneColor, tmp9.xw);
                tmp11.xyz = tmp11.xyz + tmp12.xyz;
                tmp12.yz = tmp9.yw;
                tmp12.x = tmp10.x;
                tmp13 = tex2D(waterSceneColor, tmp12.xy);
                tmp12 = tex2D(waterSceneColor, tmp12.xz);
                tmp11.xyz = tmp11.xyz + tmp13.xyz;
                tmp9.y = tmp10.y;
                tmp10 = tex2D(waterSceneColor, tmp10.zw);
                tmp8.xyz = tmp8.xyz + tmp10.xyz;
                tmp10 = tex2D(waterSceneColor, tmp9.xy);
                tmp9 = tex2D(waterSceneColor, tmp9.zy);
                tmp8.xyz = tmp8.xyz + tmp9.xyz;
                tmp8.xyz = tmp12.xyz + tmp8.xyz;
                tmp8.xyz = tmp8.xyz * float3(0.25, 0.25, 0.25);
                tmp9.xyz = tmp10.xyz + tmp11.xyz;
                tmp8.xyz = tmp9.xyz * float3(0.2, 0.2, 0.2) + tmp8.xyz;
                tmp8.xyz = tmp8.xyz * float3(0.5, 0.5, 0.5);
                tmp2.zw = tmp0.yy * float2(0.5555556, 0.1) + float2(-0.1111111, 0.1);
                tmp6 = -tmp6.xzxz * tmp0.yyyy + inp.texcoord1.xzxz;
                tmp6 = tmp6 * float4(0.15, 0.15, 0.15, 0.15) + tmp1.wwww;
                tmp3 = tmp3 * float4(20.0, 20.0, 20.0, 20.0) + tmp6;
                tmp3 = tmp2.xyxy + tmp3;
                tmp3 = _Time * float4(0.067, 0.1, -0.1, -0.075) + tmp3;
                tmp3 = tmp3 * _RefractedLight_ST + _RefractedLight_ST;
                tmp6 = tex2D(_Gradientmap, _Gradientmap_ST.zw);
                tmp9.xyz = tmp6.xyz * float3(10.0, 10.0, 10.0) + float3(0.1, 0.1, 0.1);
                tmp2.xyw = -tmp2.www / tmp9.xyz;
                tmp2.z = saturate(tmp2.z);
                tmp2.xyw = saturate(tmp2.xyw + float3(1.0, 1.0, 1.0));
                tmp9.xyz = tmp2.xyw * tmp2.xyw;
                tmp2.xyw = tmp2.xyw * tmp9.xyz;
                tmp9.xyz = tmp8.xyz * tmp2.xyw + float3(-0.5, -0.5, -0.5);
                tmp2.xyw = tmp2.xyw * tmp8.xyz;
                tmp8.xyz = -tmp9.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp9.xyz = float3(1.0, 1.0, 1.0) - tmp6.xyz;
                tmp8.xyz = -tmp8.xyz * tmp9.xyz + float3(1.0, 1.0, 1.0);
                tmp9.xyz = tmp2.xyw * tmp6.xyz;
                tmp2.xyw = tmp2.xyw > float3(0.5, 0.5, 0.5);
                tmp9.xyz = tmp9.xyz + tmp9.xyz;
                tmp2.xyw = saturate(tmp2.xyw ? tmp8.xyz : tmp9.xyz);
                tmp0.y = 1.0 - tmp0.z;
                tmp0.z = tmp0.z * -2.0 + 1.0;
                tmp2.xyw = tmp2.xyw * tmp0.yyy;
                tmp8.xyz = saturate(tmp1.yyy * float3(1.25, 1.25, 1.25) + tmp6.xyz);
                tmp2.xyw = tmp7.xyz * tmp8.xyz + tmp2.xyw;
                tmp7 = tex2D(_RefractedLight, tmp3.xy);
                tmp3 = tex2D(_RefractedLight, tmp3.zw);
                tmp3.xyz = tmp3.xyz * tmp7.xyz;
                tmp3.xyz = saturate(tmp3.xyz * float3(0.5, 0.5, 0.5));
                tmp0.yzw = tmp0.zzz * tmp3.xyz;
                tmp0.yzw = tmp1.zzz * tmp0.yzw;
                tmp0.yzw = saturate(tmp2.zzz * tmp0.yzw);
                tmp0.yzw = tmp0.yzw + tmp2.xyw;
                tmp1.y = inp.color.x * -4.0 + 4.0;
                tmp0.x = saturate(tmp0.x * tmp1.y);
                tmp1.yz = _Gradientmap_ST.zw + _Gradientmap_ST.xy;
                tmp2 = tex2D(_Gradientmap, tmp1.yz);
                tmp1.yzw = tmp2.xyz - tmp6.xyz;
                tmp1.yzw = tmp0.xxx * tmp1.yzw + tmp6.xyz;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = floor(tmp0.x);
                tmp1.yzw = tmp0.xxx * tmp1.yzw;
                tmp0.xyz = tmp1.yzw * float3(0.333, 0.333, 0.333) + tmp0.yzw;
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.yzw = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp4.xyz, tmp1.xyz);
                tmp1.xyz = tmp5.xyz * tmp1.xxx + tmp1.yzw;
                tmp0.w = max(tmp0.w, 0.0);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = tmp0.www * _LightColor0.xyz + tmp2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp4.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 362.0387;
                tmp0.w = exp(tmp0.w);
                tmp1.xyz = tmp0.www * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * float3(5.0, 5.0, 5.0);
                o.sv_target.xyz = tmp2.xyz * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 750
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" }
			Blend One One, One One
			GpuProgramID 81781
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
			float _BlurOffset;
			float4 _RefractedLight_ST;
			float _FreshWater;
			float4 _DisperseSizeSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _WaveNoise;
			// Texture params for Fragment Shader
			sampler2D _WaveMap;
			sampler2D waterSceneColor;
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
                tmp0.x = tmp0.x * _WaveScale;
                tmp1.xz = tmp0.xx * v.normal.xz;
                tmp1.y = tmp0.x * v.normal.y + _WaveOffset;
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
                float4 tmp10;
                float4 tmp11;
                float4 tmp12;
                float4 tmp13;
                float4 tmp14;
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
                tmp5.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.x = dot(tmp5.xyz, tmp5.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp6.xyz = tmp1.xxx * tmp5.xyz;
                tmp1.y = dot(tmp4.xyz, tmp6.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = 1.0 - tmp1.y;
                tmp2.z = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * tmp2.z;
                tmp0.w = tmp0.w * tmp1.y;
                tmp0.w = tmp1.z * tmp0.w;
                tmp7 = tex2D(_WaveMap, tmp3.xy);
                tmp3 = tex2D(_WaveMap, tmp3.zw);
                tmp8 = float4(1.0, 1.0, 1.0, 1.0) - tmp7.xyxy;
                tmp7 = tmp3.xyxy * tmp7.xyxy;
                tmp7 = tmp7 + tmp7;
                tmp9 = tmp3.xyxy - float4(0.5, 0.5, 0.5, 0.5);
                tmp3 = tmp3.xyxy > float4(0.5, 0.5, 0.5, 0.5);
                tmp9 = -tmp9 * float4(2.0, 2.0, 2.0, 2.0) + float4(1.0, 1.0, 1.0, 1.0);
                tmp8 = -tmp9 * tmp8 + float4(1.0, 1.0, 1.0, 1.0);
                tmp3 = saturate(tmp3 ? tmp8 : tmp7);
                tmp0.y = tmp0.y * -tmp3.z + tmp3.z;
                tmp3 = tmp3 * float4(0.125, 0.125, 0.125, 0.125);
                tmp1.z = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp2.z = dot(inp.texcoord6.xyz, inp.texcoord6.xyz);
                tmp7 = tex2D(_LightTexture0, tmp2.zz);
                tmp1.z = tmp1.z * tmp7.x;
                tmp7.xyz = tmp7.xxx * _LightColor0.xyz;
                tmp1.z = dot(tmp1.xyz, float3(0.3, 0.59, 0.11));
                tmp1.z = saturate(tmp1.z + tmp1.z);
                tmp0.y = tmp0.y * tmp1.z + tmp0.w;
                tmp0.w = 1.0 - _FreshWater;
                tmp0.y = tmp0.w * tmp0.z + tmp0.y;
                tmp0.yz = tmp0.yy * _Gradientmap_ST.xy + _Gradientmap_ST.zw;
                tmp8 = tex2D(_Gradientmap, tmp0.yz);
                tmp0.yz = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp9 = tex2D(_CameraDepthTexture, tmp0.yz);
                tmp10.xy = _Refraction.xx * tmp3.xy + tmp0.yz;
                tmp3 = tmp3 * _Refraction.xxxx;
                tmp0.y = _ZBufferParams.z * tmp9.x + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.y = tmp0.y - _ProjectionParams.y;
                tmp0.z = inp.texcoord5.z - _ProjectionParams.y;
                tmp0.yz = max(tmp0.yz, float2(0.0, 0.0));
                tmp0.y = tmp0.y - tmp0.z;
                tmp0.z = _ColorDensity * tmp0.y + 1.0;
                tmp0.w = _ColorFadeEnd + 1.0;
                tmp0.z = saturate(tmp0.z / tmp0.w);
                tmp0.z = log(tmp0.z);
                tmp0.z = tmp0.z * _ColorFadeStart;
                tmp0.z = exp(tmp0.z);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.z = tmp0.z - 1.0;
                tmp0.z = _DepthBlend * tmp0.z + 1.0;
                tmp8.xyz = tmp0.zzz * tmp8.xyz;
                tmp0.w = tmp0.z * 1.49925;
                tmp0.w = saturate(tmp0.w);
                tmp9 = tmp0.wwww * _BlurOffset.xxxx + tmp10.xyxy;
                tmp11 = -tmp0.wwww * _BlurOffset.xxxx + tmp10.xyxy;
                tmp10.zw = tmp9.xy;
                tmp9 = tex2D(waterSceneColor, tmp9.zw);
                tmp12 = tex2D(waterSceneColor, tmp10.zy);
                tmp13 = tex2D(waterSceneColor, tmp10.xy);
                tmp12.xyz = tmp12.xyz + tmp13.xyz;
                tmp13 = tex2D(waterSceneColor, tmp10.xw);
                tmp12.xyz = tmp12.xyz + tmp13.xyz;
                tmp13.yz = tmp10.yw;
                tmp13.x = tmp11.x;
                tmp14 = tex2D(waterSceneColor, tmp13.xy);
                tmp13 = tex2D(waterSceneColor, tmp13.xz);
                tmp12.xyz = tmp12.xyz + tmp14.xyz;
                tmp10.y = tmp11.y;
                tmp11 = tex2D(waterSceneColor, tmp11.zw);
                tmp9.xyz = tmp9.xyz + tmp11.xyz;
                tmp11 = tex2D(waterSceneColor, tmp10.xy);
                tmp10 = tex2D(waterSceneColor, tmp10.zy);
                tmp9.xyz = tmp9.xyz + tmp10.xyz;
                tmp9.xyz = tmp13.xyz + tmp9.xyz;
                tmp9.xyz = tmp9.xyz * float3(0.25, 0.25, 0.25);
                tmp10.xyz = tmp11.xyz + tmp12.xyz;
                tmp9.xyz = tmp10.xyz * float3(0.2, 0.2, 0.2) + tmp9.xyz;
                tmp9.xyz = tmp9.xyz * float3(0.5, 0.5, 0.5);
                tmp2.zw = tmp0.yy * float2(0.5555556, 0.1) + float2(-0.1111111, 0.1);
                tmp6 = -tmp6.xzxz * tmp0.yyyy + inp.texcoord1.xzxz;
                tmp6 = tmp6 * float4(0.15, 0.15, 0.15, 0.15) + tmp1.wwww;
                tmp3 = tmp3 * float4(20.0, 20.0, 20.0, 20.0) + tmp6;
                tmp3 = tmp2.xyxy + tmp3;
                tmp3 = _Time * float4(0.067, 0.1, -0.1, -0.075) + tmp3;
                tmp3 = tmp3 * _RefractedLight_ST + _RefractedLight_ST;
                tmp6 = tex2D(_Gradientmap, _Gradientmap_ST.zw);
                tmp10.xyz = tmp6.xyz * float3(10.0, 10.0, 10.0) + float3(0.1, 0.1, 0.1);
                tmp2.xyw = -tmp2.www / tmp10.xyz;
                tmp2.z = saturate(tmp2.z);
                tmp2.xyw = saturate(tmp2.xyw + float3(1.0, 1.0, 1.0));
                tmp10.xyz = tmp2.xyw * tmp2.xyw;
                tmp2.xyw = tmp2.xyw * tmp10.xyz;
                tmp10.xyz = tmp9.xyz * tmp2.xyw + float3(-0.5, -0.5, -0.5);
                tmp2.xyw = tmp2.xyw * tmp9.xyz;
                tmp9.xyz = -tmp10.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp10.xyz = float3(1.0, 1.0, 1.0) - tmp6.xyz;
                tmp9.xyz = -tmp9.xyz * tmp10.xyz + float3(1.0, 1.0, 1.0);
                tmp10.xyz = tmp2.xyw * tmp6.xyz;
                tmp2.xyw = tmp2.xyw > float3(0.5, 0.5, 0.5);
                tmp10.xyz = tmp10.xyz + tmp10.xyz;
                tmp2.xyw = saturate(tmp2.xyw ? tmp9.xyz : tmp10.xyz);
                tmp0.y = 1.0 - tmp0.z;
                tmp0.z = tmp0.z * -2.0 + 1.0;
                tmp2.xyw = tmp2.xyw * tmp0.yyy;
                tmp9.xyz = saturate(tmp1.yyy * float3(1.25, 1.25, 1.25) + tmp6.xyz);
                tmp2.xyw = tmp8.xyz * tmp9.xyz + tmp2.xyw;
                tmp8 = tex2D(_RefractedLight, tmp3.xy);
                tmp3 = tex2D(_RefractedLight, tmp3.zw);
                tmp3.xyz = tmp3.xyz * tmp8.xyz;
                tmp3.xyz = saturate(tmp3.xyz * float3(0.5, 0.5, 0.5));
                tmp0.yzw = tmp0.zzz * tmp3.xyz;
                tmp0.yzw = tmp1.zzz * tmp0.yzw;
                tmp0.yzw = saturate(tmp2.zzz * tmp0.yzw);
                tmp0.yzw = tmp0.yzw + tmp2.xyw;
                tmp1.y = inp.color.x * -4.0 + 4.0;
                tmp0.x = saturate(tmp0.x * tmp1.y);
                tmp1.yz = _Gradientmap_ST.zw + _Gradientmap_ST.xy;
                tmp2 = tex2D(_Gradientmap, tmp1.yz);
                tmp1.yzw = tmp2.xyz - tmp6.xyz;
                tmp1.yzw = tmp0.xxx * tmp1.yzw + tmp6.xyz;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = floor(tmp0.x);
                tmp1.yzw = tmp0.xxx * tmp1.yzw;
                tmp0.xyz = tmp1.yzw * float3(0.333, 0.333, 0.333) + tmp0.yzw;
                tmp1.yzw = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.yzw = tmp0.www * tmp1.yzw;
                tmp0.w = dot(tmp4.xyz, tmp1.xyz);
                tmp1.xyz = tmp5.xyz * tmp1.xxx + tmp1.yzw;
                tmp0.w = max(tmp0.w, 0.0);
                tmp2.xyz = tmp7.xyz * tmp0.www;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp4.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 362.0387;
                tmp0.w = exp(tmp0.w);
                tmp1.xyz = tmp0.www * tmp7.xyz;
                tmp1.xyz = tmp1.xyz * float3(5.0, 5.0, 5.0);
                o.sv_target.xyz = tmp2.xyz * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			LOD 750
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 189788
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
                tmp0.x = tmp0.x * _WaveScale;
                tmp1.xz = tmp0.xx * v.normal.xz;
                tmp1.y = tmp0.x * v.normal.y + _WaveOffset;
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
	Fallback "SR/Environment/Depth Water No Refraction"
	CustomEditor "ShaderForgeMaterialInspector"
}