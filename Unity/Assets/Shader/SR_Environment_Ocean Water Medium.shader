Shader "SR/Environment/Ocean Water Medium" {
	Properties {
		_ColorRamp ("Color Ramp", 2D) = "gray" {}
		_Foam ("Foam", 2D) = "black" {}
		_WavesHeight ("Waves Height", 2D) = "black" {}
		_WavesNormal ("Waves Normal", 2D) = "bump" {}
		_EdgeWidth ("Edge Width", Float) = 1
		_EdgeFade ("EdgeFade", Range(0, 1)) = 1
		_EdgeHardness ("Edge Hardness", Range(0, 1)) = 1
		_EdgeSpeed ("Edge Speed", Float) = 1
		_EdgeClipDistance ("Edge Clip Distance", Float) = 1
		_FallSpeed ("Fall Speed", Float) = 1
		_FallScale ("Fall Scale", Float) = 1
		_WaveFade ("Wave Fade", Range(0, 1)) = 1
		_WaveSpeed ("Wave Speed", Float) = 1
		_WaveNoise ("Wave Noise", Range(0, 2)) = 1
		_WaveHeight ("Wave Height", Float) = 1
		_WaveOffset ("Wave Offset", Float) = 0
		_Density ("Density", Float) = 3
		_RefractedLightFade ("Refracted Light Fade", Range(0, 2)) = 1
		_RefractionAmount ("Refraction Amount", Range(0, 2)) = 1
		_Dirt ("Dirt", 2D) = "gray" {}
		_DirtFade ("Dirt Fade", Float) = 1
		_DirtOffset ("Dirt Offset", Float) = 1
		_SurfacePattern ("SurfacePattern", 2D) = "black" {}
		_SurfacePataternFade ("SurfacePatatern Fade", Float) = 1
		_Alpha ("Alpha", Range(0, 1)) = 1
		_ColorMultiply ("Color Multiply", Vector) = (0,4,2,0)
		_ReflectionDistortionIntensity ("Reflection Distortion Intensity", Float) = 1
		_ReflectionFade ("Reflection Fade", Float) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 550
		Tags { "QUEUE" = "Transparent-250" "RenderType" = "Transparent" }
		GrabPass {
			"Ocean"
		}
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 8840
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Foam_ST;
			float4 _WavesHeight_ST;
			float _WaveHeight;
			float _WaveSpeed;
			float _WaveNoise;
			float _WaveOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float _EdgeWidth;
			float _EdgeSpeed;
			float4 _WavesNormal_ST;
			float _Density;
			float4 _ColorRamp_ST;
			float _EdgeFade;
			float _EdgeHardness;
			float _WaveFade;
			float _RefractedLightFade;
			float _RefractionAmount;
			float4 _Dirt_ST;
			float _FallSpeed;
			float _DirtFade;
			float4 _SurfacePattern_ST;
			float _SurfacePataternFade;
			float _DirtOffset;
			float _Alpha;
			float4 _ColorMultiply;
			float _FallScale;
			float _EdgeClipDistance;
			float _ReflectionDistortionIntensity;
			float _ReflectionFade;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Foam;
			sampler2D _WavesHeight;
			// Texture params for Fragment Shader
			sampler2D _WavesNormal;
			sampler2D _CameraDepthTexture;
			sampler2D Ocean;
			sampler2D _Dirt;
			sampler2D _ColorRamp;
			sampler2D _SurfacePattern;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp1.z = 1.0;
                tmp1.w = _WaveSpeed;
                tmp1.zw = tmp1.zw * _Time.yy;
                tmp2.x = _WaveSpeed;
                tmp1.x = tmp1.z * tmp2.x;
                tmp3 = tmp1.xwxw * float4(3.0, 1.5, -1.0, -0.5) + tmp0.xzxz;
                tmp1.xy = tmp3.zw * _WavesHeight_ST.xy;
                tmp2.zw = tmp3.xy * _Foam_ST.xy;
                tmp2.zw = tmp2.zw * float2(0.1, 0.1) + _Foam_ST.zw;
                tmp3 = tex2Dlod(_Foam, float4(tmp2.zw, 0, 0.0));
                tmp1.xy = tmp1.xy * float2(0.5, 0.5) + _WavesHeight_ST.zw;
                tmp4 = tex2Dlod(_WavesHeight, float4(tmp1.xy, 0, 0.0));
                tmp0.w = tmp4.x - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp2.y = 0.5;
                tmp1.xy = tmp1.zw * tmp2.xy + tmp0.xz;
                tmp0.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 0.02;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * -1.5;
                tmp0.x = exp(tmp0.x);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x * _WaveNoise;
                tmp0.yz = tmp1.xy * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp1 = tex2Dlod(_WavesHeight, float4(tmp0.yz, 0, 0.0));
                tmp0.y = 1.0 - tmp1.x;
                tmp0.z = dot(tmp1.xy, tmp4.xy);
                tmp1.x = tmp4.x > 0.5;
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp0.y = saturate(tmp1.x ? tmp0.y : tmp0.z);
                tmp0.y = tmp0.y + tmp3.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * 0.5;
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp1.xyz = v.normal.xyz * _WaveOffset.xxx;
                tmp0.xyz = tmp0.xyz * _WaveHeight.xxx + tmp1.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                o.texcoord1.xyz = tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp3.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp3.xyz;
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp3.xyz;
                o.texcoord2.xyz = tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx;
                tmp2.xyz = tmp2.yzx * tmp3.zxy + -tmp4.xyz;
                tmp2.xyz = tmp2.xyz * v.tangent.www;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                o.texcoord3.xyz = tmp0.zzz * tmp2.xyz;
                o.color = v.color;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord4.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord4.w = tmp0.w;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
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
                tmp0.x = _FallSpeed * _Time.y;
                tmp0 = tmp0.xxxx * float4(0.1, 25.0, 0.1, 25.0) + inp.texcoord.zyxy;
                tmp1.xz = float2(1.0, 1.0);
                tmp1.yw = _FallScale.xx;
                tmp0 = tmp0 * tmp1;
                tmp1.xz = _FallScale.xx;
                tmp1.yw = float2(0.333, 0.333);
                tmp0 = tmp0 * tmp1;
                tmp0 = tmp0 * _Foam_ST + _Foam_ST;
                tmp1 = tex2D(_Foam, tmp0.xy);
                tmp0 = tex2D(_Foam, tmp0.zw);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = 1.0 - tmp1.x;
                tmp0.x = saturate(-tmp0.y * tmp0.x + 1.0);
                tmp0.y = _EdgeSpeed * _Time.y;
                tmp1 = tmp0.yyyy * float4(-1.5, -0.25, 1.0, 0.5) + inp.texcoord.xzxz;
                tmp0.zw = tmp1.xy * _Foam_ST.xy;
                tmp1.xy = _Foam_ST.xy * tmp1.zw + _Foam_ST.zw;
                tmp1 = tex2D(_Foam, tmp1.xy);
                tmp0.zw = tmp0.zw * float2(0.9, 0.9) + _Foam_ST.zw;
                tmp2 = tex2D(_Foam, tmp0.zw);
                tmp0.z = 1.0 - tmp2.x;
                tmp0.w = dot(tmp2.xy, tmp1.xy);
                tmp1.y = tmp1.x - 0.5;
                tmp1.y = -tmp1.y * 2.0 + 1.0;
                tmp1.y = -tmp1.y * tmp0.z + 1.0;
                tmp1.z = tmp1.x > 0.5;
                tmp1.x = 1.0 - tmp1.x;
                tmp0.z = saturate(-tmp0.z * tmp1.x + 1.0);
                tmp0.w = saturate(tmp1.z ? tmp1.y : tmp0.w);
                tmp0.zw = float2(1.0, 1.0) - tmp0.zw;
                tmp0.z = -tmp0.z * tmp0.w + 1.0;
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp2.xyz = abs(tmp1.xyz) * abs(tmp1.xyz);
                tmp0.w = tmp0.x * tmp2.x;
                tmp0.z = tmp2.y * tmp0.z + tmp0.w;
                tmp0.x = tmp2.z * tmp0.x + tmp0.z;
                tmp0.z = tmp0.x * 0.25 + 0.5;
                tmp0.w = tmp0.z > 0.5;
                tmp1.w = -tmp0.x * 0.5 + 1.0;
                tmp2.x = log(inp.color.x);
                tmp2.x = tmp2.x * 0.667;
                tmp2.x = exp(tmp2.x);
                tmp2.x = tmp2.x * tmp2.x;
                tmp2.y = inp.texcoord4.z - _ProjectionParams.y;
                tmp3.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp4 = tex2D(_CameraDepthTexture, tmp3.xy);
                tmp2.z = _ZBufferParams.z * tmp4.x + _ZBufferParams.w;
                tmp2.z = 1.0 / tmp2.z;
                tmp2.z = tmp2.z - _ProjectionParams.y;
                tmp2.yz = max(tmp2.yz, float2(0.0, 0.0));
                tmp2.z = tmp2.z - tmp2.y;
                tmp2.y = saturate(tmp2.y * -0.0025063 + 1.002506);
                tmp2.w = saturate(tmp2.z / _EdgeClipDistance);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.w = -tmp2.x * 0.667 + 1.0;
                tmp2.x = tmp2.x * 0.667;
                tmp0.z = dot(tmp2.xy, tmp0.xy);
                tmp1.w = -tmp1.w * tmp2.w + 1.0;
                tmp0.z = saturate(tmp0.w ? tmp1.w : tmp0.z);
                tmp0.z = tmp0.z - 0.5;
                tmp0.z = tmp0.z < 0.0;
                if (tmp0.z) {
                    discard;
                }
                tmp0.z = inp.texcoord.z + inp.texcoord.x;
                tmp0.z = tmp0.z * 0.005;
                tmp0.y = tmp0.y * 0.25 + tmp0.z;
                tmp0.z = tmp0.y + 1.0;
                tmp0.yz = tmp0.yz * float2(1.570796, 1.570796);
                tmp0.yz = cos(tmp0.yz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.w = tmp0.z * -1.5 + 1.5;
                tmp0.z = dot(float2(_EdgeWidth.x, _EdgeSpeed.x), tmp0.xy);
                tmp1.w = tmp0.y * -1.5 + 1.5;
                tmp0.y = dot(float2(_EdgeWidth.x, _EdgeSpeed.x), tmp0.xy);
                tmp0.yz = saturate(tmp2.zz / tmp0.yz);
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.w = 1.0 - tmp0.z;
                tmp0.z = tmp0.z * 4.0 + -2.0;
                tmp0.z = -tmp1.w * tmp0.z + 1.0;
                tmp1.w = 1.0 - tmp0.y;
                tmp0.y = tmp0.y * 4.0 + -2.0;
                tmp0.y = -tmp1.w * tmp0.y + 1.0;
                tmp0.y = saturate(-tmp0.y * tmp0.z + 1.0);
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.z = tmp0.y * tmp0.x;
                tmp0.w = tmp0.z * 10.0 + -1.0;
                tmp0.y = -tmp0.x * tmp0.y + tmp0.w;
                tmp0.y = saturate(_EdgeHardness * tmp0.y + tmp0.z);
                tmp0.w = 1.0 - inp.color.x;
                tmp0.w = 1.0 - tmp0.w;
                tmp1.w = saturate(tmp1.y);
                tmp1.w = tmp1.w * -0.25 + 0.25;
                tmp1.w = 1.0 - tmp1.w;
                tmp0.w = saturate(-tmp1.w * tmp0.w + 1.0);
                tmp0.yw = float2(1.0, 1.0) - tmp0.yw;
                tmp1.w = saturate(tmp2.z / _EdgeWidth);
                tmp2.x = 1.0 - tmp1.w;
                tmp2.x = 1.0 - tmp2.x;
                tmp0.w = -tmp0.w * tmp2.x + 1.0;
                tmp2.x = tmp0.w * tmp0.x;
                tmp2.w = tmp2.x * 10.0 + -3.0;
                tmp0.x = -tmp0.x * tmp0.w + tmp2.w;
                tmp0.x = saturate(_EdgeHardness * tmp0.x + tmp2.x);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = -tmp0.x * tmp0.y + 1.0;
                tmp0.y = tmp1.w * _EdgeHardness;
                tmp0.y = saturate(tmp0.y * 3.0 + tmp1.w);
                tmp0.x = tmp0.x * tmp0.y + tmp0.z;
                tmp0.y = -tmp0.x * _EdgeFade + 1.0;
                tmp0.x = tmp0.x * _EdgeFade;
                tmp4.x = _WaveSpeed;
                tmp0.z = 1.0;
                tmp0.w = _WaveSpeed;
                tmp5.zw = tmp0.zw * _Time.yy;
                tmp5.x = tmp4.x * tmp5.z;
                tmp6 = tmp5.xwxw * float4(-1.0, -0.5, 3.0, 1.5) + inp.texcoord.xzxz;
                tmp0.zw = tmp6.xy * float2(0.5, 0.5);
                tmp2.xw = tmp0.zw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp0.zw = tmp0.zw * _WavesNormal_ST.xy + _WavesNormal_ST.zw;
                tmp7 = tex2D(_WavesNormal, tmp0.zw);
                tmp8 = tex2D(_WavesHeight, tmp2.xw);
                tmp0.z = tmp8.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp4.yw = float2(0.5, 0.5);
                tmp2.xw = tmp5.zw * tmp4.xy + inp.texcoord.xz;
                tmp4.xy = tmp2.xw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp9 = tex2D(_WavesHeight, tmp4.xy);
                tmp0.w = 1.0 - tmp9.x;
                tmp1.w = dot(tmp9.xy, tmp8.xy);
                tmp3.w = tmp8.x > 0.5;
                tmp0.z = -tmp0.z * tmp0.w + 1.0;
                tmp0.z = saturate(tmp3.w ? tmp0.z : tmp1.w);
                tmp0.w = tmp0.z - 0.125;
                tmp5.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp5.xyz, tmp5.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp5.xyz = tmp1.www * float3(0.0066667, 0.02, 0.025);
                tmp4.xy = log(tmp5.xy);
                tmp1.w = tmp5.z * tmp5.z;
                tmp1.w = 1.0 / tmp1.w;
                tmp1.w = saturate(tmp1.w);
                tmp4.xy = tmp4.xy * float2(-1.5, -1.5);
                tmp4.xy = exp(tmp4.xy);
                tmp4.xy = min(tmp4.xy, float2(1.0, 1.0));
                tmp3.w = tmp4.y * _WaveNoise;
                tmp5.xy = tmp3.ww * tmp0.ww + float2(0.125, -0.375);
                tmp0.w = -tmp5.y * 2.0 + 1.0;
                tmp5.yz = tmp6.zw * _Foam_ST.xy;
                tmp5.yz = tmp5.yz * float2(0.1, 0.1) + _Foam_ST.zw;
                tmp8 = tex2D(_Foam, tmp5.yz);
                tmp5.y = tmp8.x * 2.0 + -0.5;
                tmp5.z = tmp0.z + tmp8.x;
                tmp5.z = tmp5.z * tmp3.w + -1.0;
                tmp6.z = -tmp5.y * tmp4.x + 1.0;
                tmp4.x = tmp4.x * tmp5.y;
                tmp8.xy = tmp4.yy * float2(-0.25, -0.25) + float2(0.75, 0.25);
                tmp0.w = -tmp0.w * tmp6.z + 1.0;
                tmp4.y = dot(tmp4.xy, tmp5.xy);
                tmp5.x = tmp5.x > 0.5;
                tmp0.w = saturate(tmp5.x ? tmp0.w : tmp4.y);
                tmp0.w = -tmp0.w * 0.5 + 1.0;
                tmp4.y = tmp0.z * tmp3.w;
                tmp0.z = tmp0.z * 2.0 + -1.0;
                tmp0.z = tmp0.z * _ReflectionDistortionIntensity;
                tmp5.xy = saturate(tmp4.yy * float2(5.0, 9.999998) + float2(-2.0, -7.499999));
                tmp5.xy = tmp5.xy * _WaveFade.xx;
                tmp5.xy = -tmp5.xy * float2(0.25, 0.667) + float2(1.0, 1.0);
                tmp4.y = saturate(-tmp5.x * tmp5.y + 1.0);
                tmp4.y = 1.0 - tmp4.y;
                tmp0.w = -tmp0.w * tmp4.y + 1.0;
                tmp7.x = tmp7.w * tmp7.x;
                tmp7.xy = tmp7.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp4.y = dot(tmp7.xy, tmp7.xy);
                tmp4.y = min(tmp4.y, 1.0);
                tmp4.y = 1.0 - tmp4.y;
                tmp7.z = sqrt(tmp4.y);
                tmp5.xy = tmp2.xw * _WavesNormal_ST.xy + _WavesNormal_ST.zw;
                tmp9 = tex2D(_WavesNormal, tmp5.xy);
                tmp9.x = tmp9.w * tmp9.x;
                tmp9.xy = tmp9.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp4.y = dot(tmp9.xy, tmp9.xy);
                tmp4.y = min(tmp4.y, 1.0);
                tmp4.y = 1.0 - tmp4.y;
                tmp9.z = sqrt(tmp4.y);
                tmp7.xyz = tmp7.xyz - tmp9.xyz;
                tmp7.xyz = tmp4.xxx * tmp7.xyz + tmp9.xyz;
                tmp4.x = dot(tmp7.xyz, tmp7.xyz);
                tmp4.x = rsqrt(tmp4.x);
                tmp7.xyz = tmp7.xyz * tmp4.xxx + float3(-0.0, -0.0, -1.0);
                tmp7.xyz = tmp3.www * tmp7.xyz + float3(0.0, 0.0, 1.0);
                tmp3.w = dot(tmp7.xyz, tmp7.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp7.xyz = tmp3.www * tmp7.xyz;
                tmp9.xyz = tmp7.yyy * inp.texcoord3.xyz;
                tmp7.xyw = tmp7.xxx * inp.texcoord2.xyz + tmp9.xyz;
                tmp7.xyz = tmp7.zzz * tmp1.xyz + tmp7.xyw;
                tmp3.w = dot(tmp7.xyz, tmp7.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp7.xyz = tmp3.www * tmp7.xyz;
                tmp9.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp3.w = dot(tmp9.xyz, tmp9.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp10.xyz = tmp3.www * tmp9.xyz;
                tmp4.x = dot(tmp7.xyz, tmp10.xyz);
                tmp4.x = max(tmp4.x, 0.0);
                tmp4.x = 1.0 - tmp4.x;
                tmp4.y = rsqrt(tmp4.x);
                tmp4.y = 1.0 / tmp4.y;
                tmp0.w = tmp4.y * 0.5 + tmp0.w;
                tmp0.w = tmp0.w * 0.75;
                tmp0.w = min(tmp0.w, 1.0);
                tmp4.y = 1.0 - tmp0.w;
                tmp0.w = dot(tmp0.xy, tmp8.xy);
                tmp5.x = -tmp8.y * 2.0 + 1.0;
                tmp5.y = tmp8.x > 0.5;
                tmp4.y = -tmp5.x * tmp4.y + 1.0;
                tmp0.w = tmp5.y ? tmp4.y : tmp0.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp4.y = _WaveOffset + unity_ObjectToWorld._m13;
                tmp4.y = inp.texcoord.y - tmp4.y;
                tmp5.x = _WaveHeight * -0.5;
                tmp4.y = tmp4.y * tmp4.y + tmp5.x;
                tmp4.y = tmp4.y * 0.2 + -0.1;
                tmp4.y = max(tmp4.y, -0.1);
                tmp4.y = min(tmp4.y, 0.1);
                tmp5.x = 1.0 - tmp4.x;
                tmp5.y = _Density + _Density;
                tmp5.y = saturate(tmp2.z / tmp5.y);
                tmp5.y = 1.0 - tmp5.y;
                tmp4.y = tmp5.x * tmp5.y + tmp4.y;
                tmp4.y = 1.0 - tmp4.y;
                tmp0.w = saturate(-tmp0.w * tmp4.y + 1.0);
                tmp4.y = dot(tmp1.xyz, tmp10.xyz);
                tmp4.y = max(tmp4.y, 0.0);
                tmp4.y = 1.0 - tmp4.y;
                tmp5.x = tmp4.y * tmp4.y + 0.25;
                tmp4.y = tmp2.y * tmp4.y;
                tmp2.y = 1.0 - tmp2.y;
                tmp2.y = saturate(tmp2.y * 22.22222 + -1.222222);
                tmp0.w = -tmp5.x * tmp0.w + 1.0;
                tmp4.z = saturate(-tmp0.y * tmp0.w + 1.0);
                tmp0.yw = tmp4.zw * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp8 = tex2D(_ColorRamp, tmp0.yw);
                tmp0.yw = tmp5.ww * float2(0.85, 0.425);
                tmp0.yw = tmp5.zz * _RefractionAmount.xx + tmp0.yw;
                tmp0.yw = tmp0.yw + inp.texcoord.xz;
                tmp0.yw = tmp0.yw * _SurfacePattern_ST.xy + _SurfacePattern_ST.zw;
                tmp11 = tex2D(_SurfacePattern, tmp0.yw);
                tmp0.yw = saturate(tmp4.xx * float2(-2.0, -1.333333) + float2(1.0, 1.0));
                tmp4.x = tmp4.x * tmp4.x;
                tmp11.xyz = tmp0.www * tmp11.xyz;
                tmp11.xyz = tmp1.www * tmp11.xyz;
                tmp8.xyz = saturate(tmp11.xyz * _SurfacePataternFade.xxx + tmp8.xyz);
                tmp0.w = _Density * _DirtOffset;
                tmp11 = tmp0.wwww * float4(0.4, 0.4, 0.8, 0.8);
                tmp11 = -tmp10.xzxz * tmp11 + inp.texcoord.xzxz;
                tmp11 = tmp5.wwww * float4(0.85, 0.425, 0.5, 0.25) + tmp11;
                tmp11 = tmp5.zzzz * _RefractionAmount.xxxx + tmp11;
                tmp0.w = tmp5.z * 0.05;
                tmp5 = tmp11 * _Dirt_ST + _Dirt_ST;
                tmp11 = tex2D(_Dirt, tmp5.xy);
                tmp5 = tex2D(_Dirt, tmp5.zw);
                tmp5.x = saturate(tmp5.x);
                tmp1.w = saturate(tmp11.x * 1.428571 + -0.4285715);
                tmp1.w = tmp5.x * 0.5 + tmp1.w;
                tmp0.y = tmp0.y * tmp1.w;
                tmp5 = _Density.xxxx * float4(0.5, 0.25, 3.0, 0.75);
                tmp5.xyw = saturate(tmp2.zzz / tmp5.ywx);
                tmp1.w = saturate(tmp2.z / _Density);
                tmp0.yw = tmp0.yw * tmp5.xx;
                tmp0.y = tmp0.y * _DirtFade;
                tmp8.xyz = tmp0.yyy * float3(0.375, 0.375, 0.375) + tmp8.xyz;
                tmp2.z = tmp4.z * 0.75 + tmp1.w;
                tmp4.zw = tmp1.ww * tmp10.xz;
                tmp4.zw = -tmp4.zw * tmp5.zz + inp.texcoord.xz;
                tmp1.w = min(tmp2.z, 1.0);
                tmp0.x = tmp1.w * _Alpha + tmp0.x;
                tmp8.xyz = tmp8.xyz * tmp0.xxx;
                tmp1.w = tmp10.y * unity_MatrixV._m21;
                tmp1.w = unity_MatrixV._m20 * tmp10.x + tmp1.w;
                tmp1.w = unity_MatrixV._m22 * tmp10.z + tmp1.w;
                tmp1.w = tmp1.w * 2.0 + -1.0;
                tmp1.y = tmp1.y * unity_MatrixV._m21;
                tmp1.x = unity_MatrixV._m20 * tmp1.x + tmp1.y;
                tmp1.x = unity_MatrixV._m22 * tmp1.z + tmp1.x;
                tmp1.y = _ProjectionParams.x > 0.0;
                tmp1.z = 1.0 - tmp3.y;
                tmp3.z = tmp1.y ? tmp1.z : tmp3.y;
                tmp10.xy = tmp0.zz * float2(0.02, 0.02) + tmp3.xz;
                tmp0.z = 1.0 - tmp10.y;
                tmp0.z = tmp4.y * tmp0.z + tmp1.x;
                tmp10.z = tmp1.w * 0.125 + tmp0.z;
                tmp1 = tex2D(_CameraDepthTexture, tmp10.xz);
                tmp11 = tex2D(Ocean, tmp10.xz);
                tmp0.z = saturate(tmp10.z * -9.999998 + 9.999998);
                tmp1.yzw = tmp2.yyy * tmp11.xyz;
                tmp1.x = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp1.x = 1.0 / tmp1.x;
                tmp1.x = tmp1.x - _ProjectionParams.y;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = saturate(tmp1.x * 0.0011111 + -0.1111111);
                tmp2.y = tmp1.x * tmp2.y;
                tmp1.xyz = tmp1.xxx * tmp1.yzw;
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.z = tmp0.z * tmp2.y;
                tmp0.z = tmp0.z * _ReflectionFade;
                tmp0.z = -tmp0.z * tmp4.x + 1.0;
                tmp1.xyz = tmp4.xxx * tmp1.xyz;
                tmp8.xyz = tmp8.xyz * tmp0.zzz;
                tmp2.yz = tmp0.ww * _RefractionAmount.xx + tmp3.xz;
                tmp10 = tex2D(Ocean, tmp2.yz);
                tmp2.xy = tmp2.xw + tmp4.zw;
                tmp2.zw = tmp6.xy * float2(0.5, 0.5) + tmp4.zw;
                tmp2.zw = tmp2.zw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp4 = tex2D(_WavesHeight, tmp2.zw);
                tmp2.xy = tmp2.xy * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp2 = tex2D(_WavesHeight, tmp2.xy);
                tmp0.w = saturate(tmp4.x * tmp2.x);
                tmp0.w = tmp0.w + tmp0.w;
                tmp0.w = rsqrt(tmp0.w);
                tmp0.w = 1.0 / tmp0.w;
                tmp1.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.w = 1.0 - tmp5.y;
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.w = saturate(tmp0.w * _RefractedLightFade);
                tmp2.xyz = tmp0.www + tmp10.xyz;
                tmp2.xyz = saturate(tmp0.yyy * float3(3.0, 3.0, 3.0) + tmp2.xyz);
                tmp3.xyz = -tmp5.www / _ColorMultiply.xyz;
                tmp3.xyz = saturate(tmp3.xyz + float3(1.0, 1.0, 1.0));
                tmp4.xyz = tmp3.xyz * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * tmp4.xyz + float3(-1.0, -1.0, -1.0);
                tmp3.xyz = tmp5.xxx * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp0.xyw = tmp0.xxx * -tmp2.xyz + tmp2.xyz;
                tmp2.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp0.xyw * float3(0.5, 0.5, 0.5) + float3(1.0, 1.0, 1.0);
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp7.xyz, tmp4.xyz);
                tmp4.xyz = tmp9.xyz * tmp3.www + tmp4.xyz;
                tmp2.xyz = tmp1.www * tmp3.xyz + tmp2.xyz;
                tmp3.xyz = tmp3.xyz * tmp1.www;
                tmp3.xyz = tmp0.xyw * float3(0.5, 0.5, 0.5) + -tmp3.xyz;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = tmp3.xyz * tmp0.xyw + tmp2.xyz;
                tmp0.xyz = tmp0.zzz * tmp0.xyw;
                tmp0.xyz = saturate(_ReflectionFade.xxx * tmp1.xyz + tmp0.xyz);
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp2.xyz * _LightColor0.xyz + tmp1.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = dot(tmp2.xyz, tmp7.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 1024.0;
                tmp0.w = exp(tmp0.w);
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp2.xyz = tmp2.xyz * float3(5.0, 5.0, 5.0);
                tmp1.xyz = tmp1.xyz * tmp8.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 550
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 111212
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
				float4 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _Foam_ST;
			float4 _WavesHeight_ST;
			float _WaveHeight;
			float _WaveSpeed;
			float _WaveNoise;
			float _WaveOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float _EdgeWidth;
			float _EdgeSpeed;
			float4 _WavesNormal_ST;
			float _Density;
			float4 _ColorRamp_ST;
			float _EdgeFade;
			float _EdgeHardness;
			float _WaveFade;
			float _RefractedLightFade;
			float _RefractionAmount;
			float4 _Dirt_ST;
			float _FallSpeed;
			float _DirtFade;
			float4 _SurfacePattern_ST;
			float _SurfacePataternFade;
			float _DirtOffset;
			float _Alpha;
			float4 _ColorMultiply;
			float _FallScale;
			float _EdgeClipDistance;
			float _ReflectionDistortionIntensity;
			float _ReflectionFade;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Foam;
			sampler2D _WavesHeight;
			// Texture params for Fragment Shader
			sampler2D _WavesNormal;
			sampler2D _CameraDepthTexture;
			sampler2D Ocean;
			sampler2D _LightTexture0;
			sampler2D _Dirt;
			sampler2D _ColorRamp;
			sampler2D _SurfacePattern;
			
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
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp1.z = 1.0;
                tmp1.w = _WaveSpeed;
                tmp1.zw = tmp1.zw * _Time.yy;
                tmp2.x = _WaveSpeed;
                tmp1.x = tmp1.z * tmp2.x;
                tmp3 = tmp1.xwxw * float4(3.0, 1.5, -1.0, -0.5) + tmp0.xzxz;
                tmp1.xy = tmp3.zw * _WavesHeight_ST.xy;
                tmp2.zw = tmp3.xy * _Foam_ST.xy;
                tmp2.zw = tmp2.zw * float2(0.1, 0.1) + _Foam_ST.zw;
                tmp3 = tex2Dlod(_Foam, float4(tmp2.zw, 0, 0.0));
                tmp1.xy = tmp1.xy * float2(0.5, 0.5) + _WavesHeight_ST.zw;
                tmp4 = tex2Dlod(_WavesHeight, float4(tmp1.xy, 0, 0.0));
                tmp0.w = tmp4.x - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp2.y = 0.5;
                tmp1.xy = tmp1.zw * tmp2.xy + tmp0.xz;
                tmp0.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 0.02;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * -1.5;
                tmp0.x = exp(tmp0.x);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x * _WaveNoise;
                tmp0.yz = tmp1.xy * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp1 = tex2Dlod(_WavesHeight, float4(tmp0.yz, 0, 0.0));
                tmp0.y = 1.0 - tmp1.x;
                tmp0.z = dot(tmp1.xy, tmp4.xy);
                tmp1.x = tmp4.x > 0.5;
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp0.y = saturate(tmp1.x ? tmp0.y : tmp0.z);
                tmp0.y = tmp0.y + tmp3.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * 0.5;
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp1.xyz = v.normal.xyz * _WaveOffset.xxx;
                tmp0.xyz = tmp0.xyz * _WaveHeight.xxx + tmp1.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
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
                o.texcoord = tmp0;
                tmp3.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp2.z = dot(tmp3.xyz, tmp3.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp3.xyz = tmp2.zzz * tmp3.xyz;
                o.texcoord1.xyz = tmp3.xyz;
                tmp4.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp4.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp4.xyz;
                tmp4.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp4.xyz;
                tmp2.z = dot(tmp4.xyz, tmp4.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp4.xyz = tmp2.zzz * tmp4.xyz;
                o.texcoord2.xyz = tmp4.xyz;
                tmp5.xyz = tmp3.zxy * tmp4.yzx;
                tmp3.xyz = tmp3.yzx * tmp4.zxy + -tmp5.xyz;
                tmp3.xyz = tmp3.xyz * v.tangent.www;
                tmp2.z = dot(tmp3.xyz, tmp3.xyz);
                tmp2.z = rsqrt(tmp2.z);
                o.texcoord3.xyz = tmp2.zzz * tmp3.xyz;
                o.color = v.color;
                tmp1.y = tmp1.y * unity_MatrixV._m21;
                tmp1.x = unity_MatrixV._m20 * tmp1.x + tmp1.y;
                tmp1.x = unity_MatrixV._m22 * tmp1.z + tmp1.x;
                tmp1.x = unity_MatrixV._m23 * tmp1.w + tmp1.x;
                o.texcoord4.z = -tmp1.x;
                tmp1.x = tmp2.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp2.xw * float2(0.5, 0.5);
                o.texcoord4.w = tmp2.w;
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
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
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                float4 tmp11;
                tmp0.x = _FallSpeed * _Time.y;
                tmp0 = tmp0.xxxx * float4(0.1, 25.0, 0.1, 25.0) + inp.texcoord.zyxy;
                tmp1.xz = float2(1.0, 1.0);
                tmp1.yw = _FallScale.xx;
                tmp0 = tmp0 * tmp1;
                tmp1.xz = _FallScale.xx;
                tmp1.yw = float2(0.333, 0.333);
                tmp0 = tmp0 * tmp1;
                tmp0 = tmp0 * _Foam_ST + _Foam_ST;
                tmp1 = tex2D(_Foam, tmp0.xy);
                tmp0 = tex2D(_Foam, tmp0.zw);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = 1.0 - tmp1.x;
                tmp0.x = saturate(-tmp0.y * tmp0.x + 1.0);
                tmp0.y = _EdgeSpeed * _Time.y;
                tmp1 = tmp0.yyyy * float4(-1.5, -0.25, 1.0, 0.5) + inp.texcoord.xzxz;
                tmp0.zw = tmp1.xy * _Foam_ST.xy;
                tmp1.xy = _Foam_ST.xy * tmp1.zw + _Foam_ST.zw;
                tmp1 = tex2D(_Foam, tmp1.xy);
                tmp0.zw = tmp0.zw * float2(0.9, 0.9) + _Foam_ST.zw;
                tmp2 = tex2D(_Foam, tmp0.zw);
                tmp0.z = 1.0 - tmp2.x;
                tmp0.w = dot(tmp2.xy, tmp1.xy);
                tmp1.y = tmp1.x - 0.5;
                tmp1.y = -tmp1.y * 2.0 + 1.0;
                tmp1.y = -tmp1.y * tmp0.z + 1.0;
                tmp1.z = tmp1.x > 0.5;
                tmp1.x = 1.0 - tmp1.x;
                tmp0.z = saturate(-tmp0.z * tmp1.x + 1.0);
                tmp0.w = saturate(tmp1.z ? tmp1.y : tmp0.w);
                tmp0.zw = float2(1.0, 1.0) - tmp0.zw;
                tmp0.z = -tmp0.z * tmp0.w + 1.0;
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp2.xyz = abs(tmp1.xyz) * abs(tmp1.xyz);
                tmp0.w = tmp0.x * tmp2.x;
                tmp0.z = tmp2.y * tmp0.z + tmp0.w;
                tmp0.x = tmp2.z * tmp0.x + tmp0.z;
                tmp0.z = tmp0.x * 0.25 + 0.5;
                tmp0.w = tmp0.z > 0.5;
                tmp1.w = -tmp0.x * 0.5 + 1.0;
                tmp2.x = log(inp.color.x);
                tmp2.x = tmp2.x * 0.667;
                tmp2.x = exp(tmp2.x);
                tmp2.x = tmp2.x * tmp2.x;
                tmp2.y = inp.texcoord4.z - _ProjectionParams.y;
                tmp3.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp4 = tex2D(_CameraDepthTexture, tmp3.xy);
                tmp2.z = _ZBufferParams.z * tmp4.x + _ZBufferParams.w;
                tmp2.z = 1.0 / tmp2.z;
                tmp2.z = tmp2.z - _ProjectionParams.y;
                tmp2.yz = max(tmp2.yz, float2(0.0, 0.0));
                tmp2.z = tmp2.z - tmp2.y;
                tmp2.y = saturate(tmp2.y * -0.0025063 + 1.002506);
                tmp2.w = saturate(tmp2.z / _EdgeClipDistance);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.w = -tmp2.x * 0.667 + 1.0;
                tmp2.x = tmp2.x * 0.667;
                tmp0.z = dot(tmp2.xy, tmp0.xy);
                tmp1.w = -tmp1.w * tmp2.w + 1.0;
                tmp0.z = saturate(tmp0.w ? tmp1.w : tmp0.z);
                tmp0.z = tmp0.z - 0.5;
                tmp0.z = tmp0.z < 0.0;
                if (tmp0.z) {
                    discard;
                }
                tmp0.z = inp.texcoord.z + inp.texcoord.x;
                tmp0.z = tmp0.z * 0.005;
                tmp0.y = tmp0.y * 0.25 + tmp0.z;
                tmp0.z = tmp0.y + 1.0;
                tmp0.yz = tmp0.yz * float2(1.570796, 1.570796);
                tmp0.yz = cos(tmp0.yz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.w = tmp0.z * -1.5 + 1.5;
                tmp0.z = dot(float2(_EdgeWidth.x, _EdgeSpeed.x), tmp0.xy);
                tmp1.w = tmp0.y * -1.5 + 1.5;
                tmp0.y = dot(float2(_EdgeWidth.x, _EdgeSpeed.x), tmp0.xy);
                tmp0.yz = saturate(tmp2.zz / tmp0.yz);
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.w = 1.0 - tmp0.z;
                tmp0.z = tmp0.z * 4.0 + -2.0;
                tmp0.z = -tmp1.w * tmp0.z + 1.0;
                tmp1.w = 1.0 - tmp0.y;
                tmp0.y = tmp0.y * 4.0 + -2.0;
                tmp0.y = -tmp1.w * tmp0.y + 1.0;
                tmp0.y = saturate(-tmp0.y * tmp0.z + 1.0);
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.z = tmp0.y * tmp0.x;
                tmp0.w = tmp0.z * 10.0 + -1.0;
                tmp0.y = -tmp0.x * tmp0.y + tmp0.w;
                tmp0.y = saturate(_EdgeHardness * tmp0.y + tmp0.z);
                tmp0.w = 1.0 - inp.color.x;
                tmp0.w = 1.0 - tmp0.w;
                tmp1.w = saturate(tmp1.y);
                tmp1.w = tmp1.w * -0.25 + 0.25;
                tmp1.w = 1.0 - tmp1.w;
                tmp0.w = saturate(-tmp1.w * tmp0.w + 1.0);
                tmp0.yw = float2(1.0, 1.0) - tmp0.yw;
                tmp1.w = saturate(tmp2.z / _EdgeWidth);
                tmp2.x = 1.0 - tmp1.w;
                tmp2.x = 1.0 - tmp2.x;
                tmp0.w = -tmp0.w * tmp2.x + 1.0;
                tmp2.x = tmp0.w * tmp0.x;
                tmp2.w = tmp2.x * 10.0 + -3.0;
                tmp0.x = -tmp0.x * tmp0.w + tmp2.w;
                tmp0.x = saturate(_EdgeHardness * tmp0.x + tmp2.x);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = -tmp0.x * tmp0.y + 1.0;
                tmp0.y = tmp1.w * _EdgeHardness;
                tmp0.y = saturate(tmp0.y * 3.0 + tmp1.w);
                tmp0.x = tmp0.x * tmp0.y + tmp0.z;
                tmp0.y = -tmp0.x * _EdgeFade + 1.0;
                tmp0.x = tmp0.x * _EdgeFade;
                tmp4.x = _WaveSpeed;
                tmp0.z = 1.0;
                tmp0.w = _WaveSpeed;
                tmp5.zw = tmp0.zw * _Time.yy;
                tmp5.x = tmp4.x * tmp5.z;
                tmp6 = tmp5.xwxw * float4(-1.0, -0.5, 3.0, 1.5) + inp.texcoord.xzxz;
                tmp0.zw = tmp6.xy * float2(0.5, 0.5);
                tmp2.xw = tmp0.zw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp0.zw = tmp0.zw * _WavesNormal_ST.xy + _WavesNormal_ST.zw;
                tmp7 = tex2D(_WavesNormal, tmp0.zw);
                tmp8 = tex2D(_WavesHeight, tmp2.xw);
                tmp0.z = tmp8.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp4.yw = float2(0.5, 0.5);
                tmp2.xw = tmp5.zw * tmp4.xy + inp.texcoord.xz;
                tmp4.xy = tmp2.xw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp9 = tex2D(_WavesHeight, tmp4.xy);
                tmp0.w = 1.0 - tmp9.x;
                tmp1.w = dot(tmp9.xy, tmp8.xy);
                tmp3.w = tmp8.x > 0.5;
                tmp0.z = -tmp0.z * tmp0.w + 1.0;
                tmp0.z = saturate(tmp3.w ? tmp0.z : tmp1.w);
                tmp0.w = tmp0.z - 0.125;
                tmp5.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp5.xyz, tmp5.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp5.xyz = tmp1.www * float3(0.0066667, 0.02, 0.025);
                tmp4.xy = log(tmp5.xy);
                tmp1.w = tmp5.z * tmp5.z;
                tmp1.w = 1.0 / tmp1.w;
                tmp1.w = saturate(tmp1.w);
                tmp4.xy = tmp4.xy * float2(-1.5, -1.5);
                tmp4.xy = exp(tmp4.xy);
                tmp4.xy = min(tmp4.xy, float2(1.0, 1.0));
                tmp3.w = tmp4.y * _WaveNoise;
                tmp5.xy = tmp3.ww * tmp0.ww + float2(0.125, -0.375);
                tmp0.w = -tmp5.y * 2.0 + 1.0;
                tmp5.yz = tmp6.zw * _Foam_ST.xy;
                tmp5.yz = tmp5.yz * float2(0.1, 0.1) + _Foam_ST.zw;
                tmp8 = tex2D(_Foam, tmp5.yz);
                tmp5.y = tmp8.x * 2.0 + -0.5;
                tmp5.z = tmp0.z + tmp8.x;
                tmp5.z = tmp5.z * tmp3.w + -1.0;
                tmp6.z = -tmp5.y * tmp4.x + 1.0;
                tmp4.x = tmp4.x * tmp5.y;
                tmp8.xy = tmp4.yy * float2(-0.25, -0.25) + float2(0.75, 0.25);
                tmp0.w = -tmp0.w * tmp6.z + 1.0;
                tmp4.y = dot(tmp4.xy, tmp5.xy);
                tmp5.x = tmp5.x > 0.5;
                tmp0.w = saturate(tmp5.x ? tmp0.w : tmp4.y);
                tmp0.w = -tmp0.w * 0.5 + 1.0;
                tmp4.y = tmp0.z * tmp3.w;
                tmp0.z = tmp0.z * 2.0 + -1.0;
                tmp0.z = tmp0.z * _ReflectionDistortionIntensity;
                tmp5.xy = saturate(tmp4.yy * float2(5.0, 9.999998) + float2(-2.0, -7.499999));
                tmp5.xy = tmp5.xy * _WaveFade.xx;
                tmp5.xy = -tmp5.xy * float2(0.25, 0.667) + float2(1.0, 1.0);
                tmp4.y = saturate(-tmp5.x * tmp5.y + 1.0);
                tmp4.y = 1.0 - tmp4.y;
                tmp0.w = tmp0.w * tmp4.y;
                tmp7.x = tmp7.w * tmp7.x;
                tmp7.xy = tmp7.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp4.y = dot(tmp7.xy, tmp7.xy);
                tmp4.y = min(tmp4.y, 1.0);
                tmp4.y = 1.0 - tmp4.y;
                tmp7.z = sqrt(tmp4.y);
                tmp5.xy = tmp2.xw * _WavesNormal_ST.xy + _WavesNormal_ST.zw;
                tmp9 = tex2D(_WavesNormal, tmp5.xy);
                tmp9.x = tmp9.w * tmp9.x;
                tmp9.xy = tmp9.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp4.y = dot(tmp9.xy, tmp9.xy);
                tmp4.y = min(tmp4.y, 1.0);
                tmp4.y = 1.0 - tmp4.y;
                tmp9.z = sqrt(tmp4.y);
                tmp7.xyz = tmp7.xyz - tmp9.xyz;
                tmp7.xyz = tmp4.xxx * tmp7.xyz + tmp9.xyz;
                tmp4.x = dot(tmp7.xyz, tmp7.xyz);
                tmp4.x = rsqrt(tmp4.x);
                tmp7.xyz = tmp7.xyz * tmp4.xxx + float3(-0.0, -0.0, -1.0);
                tmp7.xyz = tmp3.www * tmp7.xyz + float3(0.0, 0.0, 1.0);
                tmp3.w = dot(tmp7.xyz, tmp7.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp7.xyz = tmp3.www * tmp7.xyz;
                tmp9.xyz = tmp7.yyy * inp.texcoord3.xyz;
                tmp7.xyw = tmp7.xxx * inp.texcoord2.xyz + tmp9.xyz;
                tmp7.xyz = tmp7.zzz * tmp1.xyz + tmp7.xyw;
                tmp3.w = dot(tmp7.xyz, tmp7.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp7.xyz = tmp3.www * tmp7.xyz;
                tmp9.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp3.w = dot(tmp9.xyz, tmp9.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp10.xyz = tmp3.www * tmp9.xyz;
                tmp4.x = dot(tmp7.xyz, tmp10.xyz);
                tmp4.x = max(tmp4.x, 0.0);
                tmp4.x = 1.0 - tmp4.x;
                tmp4.y = rsqrt(tmp4.x);
                tmp4.y = 1.0 / tmp4.y;
                tmp0.w = tmp4.y * 0.5 + -tmp0.w;
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = tmp0.w * 0.75;
                tmp0.w = min(tmp0.w, 1.0);
                tmp4.y = 1.0 - tmp0.w;
                tmp0.w = dot(tmp0.xy, tmp8.xy);
                tmp5.x = -tmp8.y * 2.0 + 1.0;
                tmp5.y = tmp8.x > 0.5;
                tmp4.y = -tmp5.x * tmp4.y + 1.0;
                tmp0.w = tmp5.y ? tmp4.y : tmp0.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp4.y = _WaveOffset + unity_ObjectToWorld._m13;
                tmp4.y = inp.texcoord.y - tmp4.y;
                tmp5.x = _WaveHeight * -0.5;
                tmp4.y = tmp4.y * tmp4.y + tmp5.x;
                tmp4.y = tmp4.y * 0.2 + -0.1;
                tmp4.y = max(tmp4.y, -0.1);
                tmp4.y = min(tmp4.y, 0.1);
                tmp5.x = 1.0 - tmp4.x;
                tmp5.y = _Density + _Density;
                tmp5.y = saturate(tmp2.z / tmp5.y);
                tmp5.y = 1.0 - tmp5.y;
                tmp4.y = tmp5.x * tmp5.y + tmp4.y;
                tmp4.y = 1.0 - tmp4.y;
                tmp0.w = saturate(-tmp0.w * tmp4.y + 1.0);
                tmp4.y = dot(tmp1.xyz, tmp10.xyz);
                tmp4.y = max(tmp4.y, 0.0);
                tmp4.y = 1.0 - tmp4.y;
                tmp5.x = tmp4.y * tmp4.y + 0.25;
                tmp4.y = tmp2.y * tmp4.y;
                tmp2.y = 1.0 - tmp2.y;
                tmp2.y = saturate(tmp2.y * 22.22222 + -1.222222);
                tmp0.w = -tmp5.x * tmp0.w + 1.0;
                tmp4.z = saturate(-tmp0.y * tmp0.w + 1.0);
                tmp0.yw = tmp4.zw * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp8 = tex2D(_ColorRamp, tmp0.yw);
                tmp0.yw = tmp5.ww * float2(0.85, 0.425);
                tmp0.yw = tmp5.zz * _RefractionAmount.xx + tmp0.yw;
                tmp0.yw = tmp0.yw + inp.texcoord.xz;
                tmp0.yw = tmp0.yw * _SurfacePattern_ST.xy + _SurfacePattern_ST.zw;
                tmp11 = tex2D(_SurfacePattern, tmp0.yw);
                tmp0.yw = saturate(tmp4.xx * float2(-2.0, -1.333333) + float2(1.0, 1.0));
                tmp4.x = tmp4.x * tmp4.x;
                tmp11.xyz = tmp0.www * tmp11.xyz;
                tmp11.xyz = tmp1.www * tmp11.xyz;
                tmp8.xyz = saturate(tmp11.xyz * _SurfacePataternFade.xxx + tmp8.xyz);
                tmp0.w = _Density * _DirtOffset;
                tmp11 = tmp0.wwww * float4(0.4, 0.4, 0.8, 0.8);
                tmp11 = -tmp10.xzxz * tmp11 + inp.texcoord.xzxz;
                tmp11 = tmp5.wwww * float4(0.85, 0.425, 0.5, 0.25) + tmp11;
                tmp11 = tmp5.zzzz * _RefractionAmount.xxxx + tmp11;
                tmp0.w = tmp5.z * 0.05;
                tmp5 = tmp11 * _Dirt_ST + _Dirt_ST;
                tmp11 = tex2D(_Dirt, tmp5.xy);
                tmp5 = tex2D(_Dirt, tmp5.zw);
                tmp5.x = saturate(tmp5.x);
                tmp1.w = saturate(tmp11.x * 1.428571 + -0.4285715);
                tmp1.w = tmp5.x * 0.5 + tmp1.w;
                tmp0.y = tmp0.y * tmp1.w;
                tmp5 = _Density.xxxx * float4(0.5, 0.25, 3.0, 0.75);
                tmp5.xyw = saturate(tmp2.zzz / tmp5.ywx);
                tmp1.w = saturate(tmp2.z / _Density);
                tmp0.y = tmp0.y * tmp5.x;
                tmp0.y = tmp0.y * _DirtFade;
                tmp8.xyz = tmp0.yyy * float3(0.375, 0.375, 0.375) + tmp8.xyz;
                tmp2.z = tmp4.z * 0.75 + tmp1.w;
                tmp4.zw = tmp1.ww * tmp10.xz;
                tmp4.zw = -tmp4.zw * tmp5.zz + inp.texcoord.xz;
                tmp1.w = min(tmp2.z, 1.0);
                tmp0.x = tmp1.w * _Alpha + tmp0.x;
                tmp8.xyz = tmp8.xyz * tmp0.xxx;
                tmp1.w = tmp10.y * unity_MatrixV._m21;
                tmp1.w = unity_MatrixV._m20 * tmp10.x + tmp1.w;
                tmp1.w = unity_MatrixV._m22 * tmp10.z + tmp1.w;
                tmp1.w = tmp1.w * 2.0 + -1.0;
                tmp1.y = tmp1.y * unity_MatrixV._m21;
                tmp1.x = unity_MatrixV._m20 * tmp1.x + tmp1.y;
                tmp1.x = unity_MatrixV._m22 * tmp1.z + tmp1.x;
                tmp1.y = _ProjectionParams.x > 0.0;
                tmp1.z = 1.0 - tmp3.y;
                tmp3.z = tmp1.y ? tmp1.z : tmp3.y;
                tmp10.xy = tmp0.zz * float2(0.02, 0.02) + tmp3.xz;
                tmp0.z = 1.0 - tmp10.y;
                tmp0.z = tmp4.y * tmp0.z + tmp1.x;
                tmp10.z = tmp1.w * 0.125 + tmp0.z;
                tmp1 = tex2D(_CameraDepthTexture, tmp10.xz);
                tmp0.z = saturate(tmp10.z * -9.999998 + 9.999998);
                tmp1.x = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp1.x = 1.0 / tmp1.x;
                tmp1.x = tmp1.x - _ProjectionParams.y;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = saturate(tmp1.x * 0.0011111 + -0.1111111);
                tmp1.x = tmp1.x * tmp2.y;
                tmp0.z = tmp0.z * tmp1.x;
                tmp0.z = tmp0.z * _ReflectionFade;
                tmp0.z = -tmp0.z * tmp4.x + 1.0;
                tmp1.xyz = tmp8.xyz * tmp0.zzz;
                tmp0.z = tmp0.w * tmp5.x;
                tmp0.zw = tmp0.zz * _RefractionAmount.xx + tmp3.xz;
                tmp8 = tex2D(Ocean, tmp0.zw);
                tmp0.zw = tmp2.xw + tmp4.zw;
                tmp2.xy = tmp6.xy * float2(0.5, 0.5) + tmp4.zw;
                tmp2.xy = tmp2.xy * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp2 = tex2D(_WavesHeight, tmp2.xy);
                tmp0.zw = tmp0.zw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp4 = tex2D(_WavesHeight, tmp0.zw);
                tmp0.z = saturate(tmp2.x * tmp4.x);
                tmp0.z = tmp0.z + tmp0.z;
                tmp0.z = rsqrt(tmp0.z);
                tmp0.z = 1.0 / tmp0.z;
                tmp0.w = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.w = 1.0 - tmp5.y;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.z = saturate(tmp0.z * _RefractedLightFade);
                tmp2.xyz = tmp0.zzz + tmp8.xyz;
                tmp0.yzw = saturate(tmp0.yyy * float3(3.0, 3.0, 3.0) + tmp2.xyz);
                tmp2.xyz = -tmp5.www / _ColorMultiply.xyz;
                tmp2.xyz = saturate(tmp2.xyz + float3(1.0, 1.0, 1.0));
                tmp3.xyz = tmp2.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp3.xyz + float3(-1.0, -1.0, -1.0);
                tmp2.xyz = tmp5.xxx * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp0.yzw = tmp0.yzw * tmp2.xyz;
                tmp0.xyz = tmp0.xxx * -tmp0.yzw + tmp0.yzw;
                tmp2.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp0.xyz * float3(0.5, 0.5, 0.5) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = _WorldSpaceLightPos0.www * -inp.texcoord.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = dot(tmp7.xyz, tmp4.xyz);
                tmp4.xyz = tmp9.xyz * tmp3.www + tmp4.xyz;
                tmp2.xyz = tmp0.www * tmp3.xyz + tmp2.xyz;
                tmp3.xyz = tmp3.xyz * tmp0.www;
                tmp3.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5) + -tmp3.xyz;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = tmp3.xyz * tmp0.xyz + tmp2.xyz;
                tmp0.w = dot(inp.texcoord5.xyz, inp.texcoord5.xyz);
                tmp2 = tex2D(_LightTexture0, tmp0.ww);
                tmp2.xyz = tmp2.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = dot(tmp3.xyz, tmp7.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 1024.0;
                tmp0.w = exp(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(5.0, 5.0, 5.0);
                o.sv_target.xyz = tmp0.xyz * tmp1.xyz + tmp2.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			LOD 550
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 145115
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Foam_ST;
			float4 _WavesHeight_ST;
			float _WaveHeight;
			float _WaveSpeed;
			float _WaveNoise;
			float _WaveOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float _EdgeSpeed;
			float _FallSpeed;
			float _FallScale;
			float _EdgeClipDistance;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Foam;
			sampler2D _WavesHeight;
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp1.z = 1.0;
                tmp1.w = _WaveSpeed;
                tmp1.zw = tmp1.zw * _Time.yy;
                tmp2.x = _WaveSpeed;
                tmp1.x = tmp1.z * tmp2.x;
                tmp3 = tmp1.xwxw * float4(3.0, 1.5, -1.0, -0.5) + tmp0.xzxz;
                tmp1.xy = tmp3.zw * _WavesHeight_ST.xy;
                tmp2.zw = tmp3.xy * _Foam_ST.xy;
                tmp2.zw = tmp2.zw * float2(0.1, 0.1) + _Foam_ST.zw;
                tmp3 = tex2Dlod(_Foam, float4(tmp2.zw, 0, 0.0));
                tmp1.xy = tmp1.xy * float2(0.5, 0.5) + _WavesHeight_ST.zw;
                tmp4 = tex2Dlod(_WavesHeight, float4(tmp1.xy, 0, 0.0));
                tmp0.w = tmp4.x - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp2.y = 0.5;
                tmp1.xy = tmp1.zw * tmp2.xy + tmp0.xz;
                tmp0.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 0.02;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * -1.5;
                tmp0.x = exp(tmp0.x);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x * _WaveNoise;
                tmp0.yz = tmp1.xy * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp1 = tex2Dlod(_WavesHeight, float4(tmp0.yz, 0, 0.0));
                tmp0.y = 1.0 - tmp1.x;
                tmp0.z = dot(tmp1.xy, tmp4.xy);
                tmp1.x = tmp4.x > 0.5;
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp0.y = saturate(tmp1.x ? tmp0.y : tmp0.z);
                tmp0.y = tmp0.y + tmp3.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * 0.5;
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp1.xyz = v.normal.xyz * _WaveOffset.xxx;
                tmp0.xyz = tmp0.xyz * _WaveHeight.xxx + tmp1.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp2.x = unity_LightShadowBias.x / tmp0.w;
                tmp2.x = min(tmp2.x, 0.0);
                tmp2.x = max(tmp2.x, -1.0);
                tmp0.z = tmp0.z + tmp2.x;
                tmp2.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp2.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
                tmp0.x = tmp1.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp1.x + tmp0.x;
                tmp0.x = unity_MatrixV._m22 * tmp1.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp1.w + tmp0.x;
                o.texcoord3.z = -tmp0.x;
                tmp0.xyz = tmp1.yyy * unity_MatrixVP._m01_m11_m31;
                tmp0.xyz = unity_MatrixVP._m00_m10_m30 * tmp1.xxx + tmp0.xyz;
                tmp0.xyz = unity_MatrixVP._m02_m12_m32 * tmp1.zzz + tmp0.xyz;
                tmp0.xyz = unity_MatrixVP._m03_m13_m33 * tmp1.www + tmp0.xyz;
                tmp1.xz = tmp0.xz * float2(0.5, 0.5);
                tmp0.x = tmp0.y * _ProjectionParams.x;
                o.texcoord3.w = tmp0.z;
                tmp1.w = tmp0.x * 0.5;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _EdgeSpeed * _Time.y;
                tmp0 = tmp0.xxxx * float4(-1.5, -0.25, 1.0, 0.5) + inp.texcoord1.xzxz;
                tmp0.xy = tmp0.xy * _Foam_ST.xy;
                tmp0.zw = _Foam_ST.xy * tmp0.zw + _Foam_ST.zw;
                tmp1 = tex2D(_Foam, tmp0.zw);
                tmp0.xy = tmp0.xy * float2(0.9, 0.9) + _Foam_ST.zw;
                tmp0 = tex2D(_Foam, tmp0.xy);
                tmp0.y = 1.0 - tmp0.x;
                tmp0.x = dot(tmp0.xy, tmp1.xy);
                tmp0.z = tmp1.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.z = -tmp0.z * tmp0.y + 1.0;
                tmp0.w = tmp1.x > 0.5;
                tmp1.x = 1.0 - tmp1.x;
                tmp0.y = saturate(-tmp0.y * tmp1.x + 1.0);
                tmp0.x = saturate(tmp0.w ? tmp0.z : tmp0.x);
                tmp0.xy = float2(1.0, 1.0) - tmp0.xy;
                tmp0.x = -tmp0.y * tmp0.x + 1.0;
                tmp0.y = _FallSpeed * _Time.y;
                tmp1 = tmp0.yyyy * float4(0.1, 25.0, 0.1, 25.0) + inp.texcoord1.zyxy;
                tmp2.xz = float2(1.0, 1.0);
                tmp2.yw = _FallScale.xx;
                tmp1 = tmp1 * tmp2;
                tmp2.xz = _FallScale.xx;
                tmp2.yw = float2(0.333, 0.333);
                tmp1 = tmp1 * tmp2;
                tmp1 = tmp1 * _Foam_ST + _Foam_ST;
                tmp2 = tex2D(_Foam, tmp1.xy);
                tmp1 = tex2D(_Foam, tmp1.zw);
                tmp0.y = 1.0 - tmp1.x;
                tmp0.z = 1.0 - tmp2.x;
                tmp0.y = saturate(-tmp0.z * tmp0.y + 1.0);
                tmp0.z = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * inp.texcoord2.xyz;
                tmp1.xyz = abs(tmp1.xyz) * abs(tmp1.xyz);
                tmp0.z = tmp0.y * tmp1.x;
                tmp0.x = tmp1.y * tmp0.x + tmp0.z;
                tmp0.x = tmp1.z * tmp0.y + tmp0.x;
                tmp0.y = -tmp0.x * 0.5 + 1.0;
                tmp0.x = tmp0.x * 0.25 + 0.5;
                tmp0.zw = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.zw);
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.z = tmp0.z - _ProjectionParams.y;
                tmp0.w = inp.texcoord3.z - _ProjectionParams.y;
                tmp0.zw = max(tmp0.zw, float2(0.0, 0.0));
                tmp0.z = tmp0.z - tmp0.w;
                tmp0.z = saturate(tmp0.z / _EdgeClipDistance);
                tmp0.w = log(inp.color.x);
                tmp0.w = tmp0.w * 0.667;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.w = -tmp0.z * 0.667 + 1.0;
                tmp0.z = tmp0.z * 0.667;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.x = tmp0.x > 0.5;
                tmp0.y = -tmp0.y * tmp0.w + 1.0;
                tmp0.x = saturate(tmp0.x ? tmp0.y : tmp0.z);
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
	Fallback "SR/Environment/Ocean Water Low"
	CustomEditor "ShaderForgeMaterialInspector"
}