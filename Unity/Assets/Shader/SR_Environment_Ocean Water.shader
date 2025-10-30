Shader "SR/Environment/Ocean Water" {
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
		_BlurAmount ("Blur Amount", Range(0, 2)) = 1
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
		LOD 750
		Tags { "QUEUE" = "Transparent-250" "RenderType" = "Transparent" }
		GrabPass {
			"Ocean"
		}
		Pass {
			Name "FORWARD"
			LOD 750
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent-250" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 58199
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
				float4 texcoord5 : TEXCOORD5;
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
			float _BlurAmount;
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
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                o.texcoord1.xyz = tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp3.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp3.xyz;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * tmp3.xyz;
                o.texcoord2.xyz = tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx;
                tmp2.xyz = tmp2.yzx * tmp3.zxy + -tmp4.xyz;
                tmp2.xyz = tmp2.xyz * v.tangent.www;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                o.texcoord3.xyz = tmp2.www * tmp2.xyz;
                o.color = v.color;
                tmp1.y = tmp1.y * unity_MatrixV._m21;
                tmp1.x = unity_MatrixV._m20 * tmp1.x + tmp1.y;
                tmp1.x = unity_MatrixV._m22 * tmp1.z + tmp1.x;
                tmp1.x = unity_MatrixV._m23 * tmp1.w + tmp1.x;
                o.texcoord4.z = -tmp1.x;
                tmp1.x = tmp0.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp0.xw * float2(0.5, 0.5);
                o.texcoord4.xy = tmp1.zz + tmp1.xw;
                o.texcoord5.xy = tmp0.xy * float2(0.5, -0.5) + tmp1.zz;
                o.texcoord4.w = tmp0.w;
                o.texcoord5.zw = tmp0.zw;
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
                float4 tmp14;
                float4 tmp15;
                float4 tmp16;
                float4 tmp17;
                float4 tmp18;
                float4 tmp19;
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
                tmp2.yz = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp3 = tex2D(_CameraDepthTexture, tmp2.yz);
                tmp2.y = _ZBufferParams.z * tmp3.x + _ZBufferParams.w;
                tmp2.y = 1.0 / tmp2.y;
                tmp2.y = tmp2.y - _ProjectionParams.y;
                tmp2.z = inp.texcoord4.z - _ProjectionParams.y;
                tmp2.yz = max(tmp2.yz, float2(0.0, 0.0));
                tmp2.y = tmp2.y - tmp2.z;
                tmp2.z = saturate(tmp2.z * -0.0025063 + 1.002506);
                tmp2.w = saturate(tmp2.y / _EdgeClipDistance);
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
                tmp0.w = dot(float2(_EdgeWidth.x, _EdgeSpeed.x), tmp0.xy);
                tmp0.z = tmp0.z * -1.5 + 1.5;
                tmp0.w = saturate(tmp2.y / tmp0.w);
                tmp1.w = 1.0 - tmp0.w;
                tmp0.w = tmp0.w * 4.0 + -2.0;
                tmp0.w = -tmp1.w * tmp0.w + 1.0;
                tmp1.w = dot(float2(_EdgeWidth.x, _EdgeSpeed.x), tmp0.xy);
                tmp0.y = tmp0.y * -1.5 + 1.5;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.z = saturate(tmp2.y / tmp1.w);
                tmp1.w = 1.0 - tmp0.z;
                tmp0.z = tmp0.z * 4.0 + -2.0;
                tmp0.z = -tmp1.w * tmp0.z + 1.0;
                tmp0.z = saturate(-tmp0.z * tmp0.w + 1.0);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.y * tmp0.x;
                tmp0.w = tmp0.z * 10.0 + -1.0;
                tmp0.y = -tmp0.x * tmp0.y + tmp0.w;
                tmp0.y = saturate(_EdgeHardness * tmp0.y + tmp0.z);
                tmp0.w = saturate(tmp2.y / _EdgeWidth);
                tmp1.w = 1.0 - tmp0.w;
                tmp1.w = 1.0 - tmp1.w;
                tmp2.x = 1.0 - inp.color.x;
                tmp2.w = saturate(tmp1.y);
                tmp2.w = tmp2.w * -0.25 + 0.25;
                tmp2.xw = float2(1.0, 1.0) - tmp2.xw;
                tmp2.x = saturate(-tmp2.w * tmp2.x + 1.0);
                tmp2.x = 1.0 - tmp2.x;
                tmp1.w = -tmp2.x * tmp1.w + 1.0;
                tmp2.x = tmp0.x * tmp1.w;
                tmp2.w = tmp2.x * 10.0 + -3.0;
                tmp0.x = -tmp0.x * tmp1.w + tmp2.w;
                tmp0.x = saturate(_EdgeHardness * tmp0.x + tmp2.x);
                tmp0.xy = float2(1.0, 1.0) - tmp0.xy;
                tmp0.x = -tmp0.x * tmp0.y + 1.0;
                tmp0.y = tmp0.w * _EdgeHardness;
                tmp0.y = saturate(tmp0.y * 3.0 + tmp0.w);
                tmp0.x = tmp0.x * tmp0.y + tmp0.z;
                tmp0.y = tmp0.x * _EdgeFade;
                tmp0.x = -tmp0.x * _EdgeFade + 1.0;
                tmp3.x = _WaveSpeed;
                tmp0.z = 1.0;
                tmp0.w = _WaveSpeed;
                tmp4.zw = tmp0.zw * _Time.yy;
                tmp4.x = tmp3.x * tmp4.z;
                tmp5 = tmp4.xwxw * float4(-1.0, -0.5, 3.0, 1.5) + inp.texcoord.xzxz;
                tmp0.zw = tmp5.xy * float2(0.5, 0.5);
                tmp2.xw = tmp0.zw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp0.zw = tmp0.zw * _WavesNormal_ST.xy + _WavesNormal_ST.zw;
                tmp6 = tex2D(_WavesNormal, tmp0.zw);
                tmp7 = tex2D(_WavesHeight, tmp2.xw);
                tmp0.z = tmp7.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp3.yw = float2(0.5, 0.5);
                tmp2.xw = tmp4.zw * tmp3.xy + inp.texcoord.xz;
                tmp3.xy = tmp2.xw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp8 = tex2D(_WavesHeight, tmp3.xy);
                tmp0.w = 1.0 - tmp8.x;
                tmp1.w = dot(tmp8.xy, tmp7.xy);
                tmp3.x = tmp7.x > 0.5;
                tmp0.z = -tmp0.z * tmp0.w + 1.0;
                tmp0.z = saturate(tmp3.x ? tmp0.z : tmp1.w);
                tmp0.w = tmp0.z - 0.125;
                tmp4.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp4.xyz = tmp1.www * float3(0.0066667, 0.02, 0.025);
                tmp3.xy = log(tmp4.xy);
                tmp1.w = tmp4.z * tmp4.z;
                tmp1.w = 1.0 / tmp1.w;
                tmp1.w = saturate(tmp1.w);
                tmp3.xy = tmp3.xy * float2(-1.5, -1.5);
                tmp3.xy = exp(tmp3.xy);
                tmp3.xy = min(tmp3.xy, float2(1.0, 1.0));
                tmp4.x = tmp3.y * _WaveNoise;
                tmp4.yz = tmp4.xx * tmp0.ww + float2(0.125, -0.375);
                tmp0.w = -tmp4.z * 2.0 + 1.0;
                tmp5.zw = tmp5.zw * _Foam_ST.xy;
                tmp5.zw = tmp5.zw * float2(0.1, 0.1) + _Foam_ST.zw;
                tmp7 = tex2D(_Foam, tmp5.zw);
                tmp4.z = tmp7.x * 2.0 + -0.5;
                tmp5.z = tmp0.z + tmp7.x;
                tmp5.z = tmp5.z * tmp4.x + -1.0;
                tmp5.w = -tmp4.z * tmp3.x + 1.0;
                tmp3.x = tmp3.x * tmp4.z;
                tmp7.xy = tmp3.yy * float2(-0.25, -0.25) + float2(0.75, 0.25);
                tmp0.w = -tmp0.w * tmp5.w + 1.0;
                tmp3.y = dot(tmp3.xy, tmp4.xy);
                tmp4.y = tmp4.y > 0.5;
                tmp0.w = saturate(tmp4.y ? tmp0.w : tmp3.y);
                tmp0.w = -tmp0.w * 0.5 + 1.0;
                tmp3.y = tmp0.z * tmp4.x;
                tmp0.z = tmp0.z * 2.0 + -1.0;
                tmp0.z = tmp0.z * _ReflectionDistortionIntensity;
                tmp4.yz = saturate(tmp3.yy * float2(5.0, 9.999998) + float2(-2.0, -7.499999));
                tmp4.yz = tmp4.yz * _WaveFade.xx;
                tmp4.yz = -tmp4.yz * float2(0.25, 0.667) + float2(1.0, 1.0);
                tmp3.y = saturate(-tmp4.y * tmp4.z + 1.0);
                tmp3.y = 1.0 - tmp3.y;
                tmp0.w = -tmp0.w * tmp3.y + 1.0;
                tmp6.x = tmp6.w * tmp6.x;
                tmp6.xy = tmp6.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.y = dot(tmp6.xy, tmp6.xy);
                tmp3.y = min(tmp3.y, 1.0);
                tmp3.y = 1.0 - tmp3.y;
                tmp6.z = sqrt(tmp3.y);
                tmp4.yz = tmp2.xw * _WavesNormal_ST.xy + _WavesNormal_ST.zw;
                tmp8 = tex2D(_WavesNormal, tmp4.yz);
                tmp8.x = tmp8.w * tmp8.x;
                tmp8.xy = tmp8.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.y = dot(tmp8.xy, tmp8.xy);
                tmp3.y = min(tmp3.y, 1.0);
                tmp3.y = 1.0 - tmp3.y;
                tmp8.z = sqrt(tmp3.y);
                tmp6.xyz = tmp6.xyz - tmp8.xyz;
                tmp6.xyz = tmp3.xxx * tmp6.xyz + tmp8.xyz;
                tmp3.x = dot(tmp6.xyz, tmp6.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp6.xyz = tmp6.xyz * tmp3.xxx + float3(-0.0, -0.0, -1.0);
                tmp4.xyz = tmp4.xxx * tmp6.xyz + float3(0.0, 0.0, 1.0);
                tmp3.x = dot(tmp4.xyz, tmp4.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp4.xyz = tmp3.xxx * tmp4.xyz;
                tmp6.xyz = tmp4.yyy * inp.texcoord3.xyz;
                tmp6.xyz = tmp4.xxx * inp.texcoord2.xyz + tmp6.xyz;
                tmp4.xyz = tmp4.zzz * tmp1.xyz + tmp6.xyz;
                tmp3.x = dot(tmp4.xyz, tmp4.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp4.xyz = tmp3.xxx * tmp4.xyz;
                tmp6.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp3.x = dot(tmp6.xyz, tmp6.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp8.xyz = tmp3.xxx * tmp6.xyz;
                tmp3.y = dot(tmp4.xyz, tmp8.xyz);
                tmp3.y = max(tmp3.y, 0.0);
                tmp3.y = 1.0 - tmp3.y;
                tmp5.w = rsqrt(tmp3.y);
                tmp5.w = 1.0 / tmp5.w;
                tmp0.w = tmp5.w * 0.5 + tmp0.w;
                tmp0.w = tmp0.w * 0.75;
                tmp0.w = min(tmp0.w, 1.0);
                tmp5.w = 1.0 - tmp0.w;
                tmp0.w = dot(tmp0.xy, tmp7.xy);
                tmp6.w = -tmp7.y * 2.0 + 1.0;
                tmp7.x = tmp7.x > 0.5;
                tmp5.w = -tmp6.w * tmp5.w + 1.0;
                tmp0.w = tmp7.x ? tmp5.w : tmp0.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp5.w = _WaveOffset + unity_ObjectToWorld._m13;
                tmp5.w = inp.texcoord.y - tmp5.w;
                tmp6.w = _WaveHeight * -0.5;
                tmp5.w = tmp5.w * tmp5.w + tmp6.w;
                tmp5.w = tmp5.w * 0.2 + -0.1;
                tmp5.w = max(tmp5.w, -0.1);
                tmp5.w = min(tmp5.w, 0.1);
                tmp6.w = _Density + _Density;
                tmp6.w = saturate(tmp2.y / tmp6.w);
                tmp6.w = 1.0 - tmp6.w;
                tmp7.x = 1.0 - tmp3.y;
                tmp5.w = tmp7.x * tmp6.w + tmp5.w;
                tmp5.w = 1.0 - tmp5.w;
                tmp0.w = saturate(-tmp0.w * tmp5.w + 1.0);
                tmp5.w = dot(tmp1.xyz, tmp8.xyz);
                tmp5.w = max(tmp5.w, 0.0);
                tmp5.w = 1.0 - tmp5.w;
                tmp6.w = tmp5.w * tmp5.w + 0.25;
                tmp5.w = tmp2.z * tmp5.w;
                tmp2.z = 1.0 - tmp2.z;
                tmp2.z = saturate(tmp2.z * 20.0 + -1.0);
                tmp0.w = -tmp6.w * tmp0.w + 1.0;
                tmp3.z = saturate(-tmp0.x * tmp0.w + 1.0);
                tmp0.x = saturate(tmp2.y / _Density);
                tmp0.w = tmp3.z * 0.75 + tmp0.x;
                tmp3.zw = tmp3.zw * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp7 = tex2D(_ColorRamp, tmp3.zw);
                tmp3.zw = tmp0.xx * tmp8.xz;
                tmp0.x = min(tmp0.w, 1.0);
                tmp0.x = tmp0.x * _Alpha + tmp0.y;
                tmp0.y = tmp5.z * 0.05;
                tmp9 = _Density.xxxx * float4(0.5, 0.25, 3.0, 0.75);
                tmp9.xyw = saturate(tmp2.yyy / tmp9.yxw);
                tmp3.zw = -tmp3.zw * tmp9.zz + inp.texcoord.xz;
                tmp0.y = tmp0.y * tmp9.x;
                tmp10.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp11.xy = tmp0.yy * _RefractionAmount.xx + tmp10.xy;
                tmp12.w = tmp11.y;
                tmp0.y = tmp9.y * _BlurAmount;
                tmp12.xyz = -tmp0.yyy * float3(0.0019531, 0.0039063, 0.0058594) + tmp11.xxx;
                tmp13 = tex2D(Ocean, tmp12.xw);
                tmp13.xyz = tmp13.xyz + tmp13.xyz;
                tmp14 = tex2D(Ocean, tmp12.yw);
                tmp13.xyz = tmp14.xyz * float3(0.75, 0.75, 0.75) + tmp13.xyz;
                tmp14 = tex2D(Ocean, tmp12.zw);
                tmp15.w = tmp12.w;
                tmp13.xyz = tmp14.xyz * float3(0.5, 0.5, 0.5) + tmp13.xyz;
                tmp15.xyz = tmp0.yyy * float3(0.0019531, 0.0039063, 0.0058594) + tmp11.xxx;
                tmp14 = tex2D(Ocean, tmp15.xw);
                tmp14.xyz = tmp14.xyz + tmp14.xyz;
                tmp16 = tex2D(Ocean, tmp15.yw);
                tmp17 = tex2D(Ocean, tmp15.zw);
                tmp14.xyz = tmp16.xyz * float3(0.75, 0.75, 0.75) + tmp14.xyz;
                tmp14.xyz = tmp17.xyz * float3(0.5, 0.5, 0.5) + tmp14.xyz;
                tmp13.xyz = tmp13.xyz + tmp14.xyz;
                tmp14 = tex2D(Ocean, tmp11.xy);
                tmp13.xyz = tmp13.xyz + tmp14.xyz;
                tmp0.w = _ScreenParams.y / _ScreenParams.x;
                tmp0.w = tmp0.w * 1024.0;
                tmp0.y = tmp0.y / tmp0.w;
                tmp11.z = tmp0.y * 2.0 + tmp11.y;
                tmp14 = tex2D(Ocean, tmp11.xz);
                tmp16.w = tmp11.z;
                tmp14.xyz = tmp14.xyz + tmp14.xyz;
                tmp17.xz = tmp0.yy * float2(4.0, 6.0) + tmp11.yy;
                tmp11.w = tmp17.x;
                tmp18 = tex2D(Ocean, tmp11.xw);
                tmp14.xyz = tmp18.xyz * float3(0.75, 0.75, 0.75) + tmp14.xyz;
                tmp17.y = tmp11.x;
                tmp18 = tex2D(Ocean, tmp17.yz);
                tmp14.xyz = tmp18.xyz * float3(0.5, 0.5, 0.5) + tmp14.xyz;
                tmp18 = tex2D(Ocean, tmp10.xy);
                tmp10.xy = tmp0.zz * float2(0.02, 0.02) + tmp10.xy;
                tmp14.xyz = tmp18.xyz * float3(3.25, 3.25, 3.25) + tmp14.xyz;
                tmp13.xyz = tmp13.xyz + tmp14.xyz;
                tmp16.x = -tmp0.y * 2.0 + tmp11.y;
                tmp14.xy = -tmp0.yy * float2(4.0, 6.0) + tmp11.yy;
                tmp16.y = tmp12.x;
                tmp14.zw = tmp12.yz;
                tmp12 = tex2D(Ocean, tmp16.yx);
                tmp18 = tex2D(Ocean, tmp16.yw);
                tmp0.yzw = tmp18.xyz + tmp18.xyz;
                tmp12.xyz = tmp12.xyz + tmp12.xyz;
                tmp18 = tex2D(Ocean, tmp14.zx);
                tmp12.xyz = tmp18.xyz * float3(0.75, 0.75, 0.75) + tmp12.xyz;
                tmp18 = tex2D(Ocean, tmp14.wy);
                tmp12.xyz = tmp18.xyz * float3(0.5, 0.5, 0.5) + tmp12.xyz;
                tmp16.z = tmp15.x;
                tmp18 = tex2D(Ocean, tmp16.zx);
                tmp16 = tex2D(Ocean, tmp16.zw);
                tmp16.xyz = tmp16.xyz + tmp16.xyz;
                tmp18.xyz = tmp18.xyz + tmp18.xyz;
                tmp11.yz = tmp14.xz;
                tmp17.yw = tmp14.yw;
                tmp14 = tex2D(Ocean, tmp17.wz);
                tmp11.x = tmp15.y;
                tmp17.x = tmp15.z;
                tmp15 = tex2D(Ocean, tmp11.xy);
                tmp19 = tex2D(Ocean, tmp11.zw);
                tmp11 = tex2D(Ocean, tmp11.xw);
                tmp11.xyz = tmp11.xyz * float3(0.75, 0.75, 0.75) + tmp16.xyz;
                tmp0.yzw = tmp19.xyz * float3(0.75, 0.75, 0.75) + tmp0.yzw;
                tmp0.yzw = tmp14.xyz * float3(0.5, 0.5, 0.5) + tmp0.yzw;
                tmp14.xyz = tmp15.xyz * float3(0.75, 0.75, 0.75) + tmp18.xyz;
                tmp15 = tex2D(Ocean, tmp17.xy);
                tmp16 = tex2D(Ocean, tmp17.xz);
                tmp11.xyz = tmp16.xyz * float3(0.5, 0.5, 0.5) + tmp11.xyz;
                tmp0.yzw = tmp0.yzw + tmp11.xyz;
                tmp11.xyz = tmp15.xyz * float3(0.5, 0.5, 0.5) + tmp14.xyz;
                tmp11.xyz = tmp11.xyz + tmp12.xyz;
                tmp11.xyz = tmp11.xyz + tmp13.xyz;
                tmp0.yzw = tmp0.yzw + tmp11.xyz;
                tmp2.xy = tmp2.xw + tmp3.zw;
                tmp3.zw = tmp5.xy * float2(0.5, 0.5) + tmp3.zw;
                tmp3.zw = tmp3.zw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp11 = tex2D(_WavesHeight, tmp3.zw);
                tmp2.xy = tmp2.xy * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp12 = tex2D(_WavesHeight, tmp2.xy);
                tmp2.x = saturate(tmp11.x * tmp12.x);
                tmp2.x = tmp2.x + tmp2.x;
                tmp2.x = rsqrt(tmp2.x);
                tmp2.x = 1.0 / tmp2.x;
                tmp2.y = tmp2.x * tmp2.x;
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.y = 1.0 - tmp9.w;
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.x = saturate(tmp2.x * _RefractedLightFade);
                tmp0.yzw = tmp0.yzw * float3(0.0416667, 0.0416667, 0.0416667) + tmp2.xxx;
                tmp2.x = _Density * _DirtOffset;
                tmp11 = tmp2.xxxx * float4(0.4, 0.4, 0.8, 0.8);
                tmp11 = -tmp8.xzxz * tmp11 + inp.texcoord.xzxz;
                tmp11 = tmp4.wwww * float4(0.85, 0.425, 0.5, 0.25) + tmp11;
                tmp2.xy = tmp4.ww * float2(0.85, 0.425);
                tmp2.xy = tmp5.zz * _RefractionAmount.xx + tmp2.xy;
                tmp11 = tmp5.zzzz * _RefractionAmount.xxxx + tmp11;
                tmp11 = tmp11 * _Dirt_ST + _Dirt_ST;
                tmp2.xy = tmp2.xy + inp.texcoord.xz;
                tmp2.xy = tmp2.xy * _SurfacePattern_ST.xy + _SurfacePattern_ST.zw;
                tmp12 = tex2D(_SurfacePattern, tmp2.xy);
                tmp13 = tex2D(_Dirt, tmp11.xy);
                tmp11 = tex2D(_Dirt, tmp11.zw);
                tmp11.x = saturate(tmp11.x);
                tmp2.x = saturate(tmp13.x * 1.428571 + -0.4285715);
                tmp2.x = tmp11.x * 0.5 + tmp2.x;
                tmp2.yw = saturate(tmp3.yy * float2(-2.0, -1.333333) + float2(1.0, 1.0));
                tmp3.y = tmp3.y * tmp3.y;
                tmp2.x = tmp2.y * tmp2.x;
                tmp5.xyz = tmp2.www * tmp12.xyz;
                tmp5.xyz = tmp1.www * tmp5.xyz;
                tmp5.xyz = saturate(tmp5.xyz * _SurfacePataternFade.xxx + tmp7.xyz);
                tmp1.w = tmp9.x * tmp2.x;
                tmp1.w = tmp1.w * _DirtFade;
                tmp0.yzw = saturate(tmp1.www * float3(3.0, 3.0, 3.0) + tmp0.yzw);
                tmp2.xyw = tmp1.www * float3(0.375, 0.375, 0.375) + tmp5.xyz;
                tmp2.xyw = tmp0.xxx * tmp2.xyw;
                tmp5.xyz = -tmp9.yyy / _ColorMultiply.xyz;
                tmp5.xyz = saturate(tmp5.xyz + float3(1.0, 1.0, 1.0));
                tmp7.xyz = tmp5.xyz * tmp5.xyz;
                tmp5.xyz = tmp5.xyz * tmp7.xyz + float3(-1.0, -1.0, -1.0);
                tmp5.xyz = tmp9.xxx * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp0.yzw = tmp0.yzw * tmp5.xyz;
                tmp0.xyz = tmp0.xxx * -tmp0.yzw + tmp0.yzw;
                tmp5.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp7.xyz = -tmp0.xyz * float3(0.5, 0.5, 0.5) + float3(1.0, 1.0, 1.0);
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp9.xyz = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp4.xyz, tmp9.xyz);
                tmp3.xzw = tmp6.xyz * tmp3.xxx + tmp9.xyz;
                tmp5.xyz = tmp0.www * tmp7.xyz + tmp5.xyz;
                tmp6.xyz = tmp7.xyz * tmp0.www;
                tmp6.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5) + -tmp6.xyz;
                tmp6.xyz = max(tmp6.xyz, float3(0.0, 0.0, 0.0));
                tmp5.xyz = max(tmp5.xyz, float3(0.0, 0.0, 0.0));
                tmp5.xyz = tmp6.xyz * tmp0.xyz + tmp5.xyz;
                tmp6.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp5.xyz = tmp5.xyz * _LightColor0.xyz + tmp6.xyz;
                tmp0.w = tmp8.y * unity_MatrixV._m21;
                tmp0.w = unity_MatrixV._m20 * tmp8.x + tmp0.w;
                tmp0.w = unity_MatrixV._m22 * tmp8.z + tmp0.w;
                tmp0.w = tmp0.w * 2.0 + -1.0;
                tmp1.y = tmp1.y * unity_MatrixV._m21;
                tmp1.x = unity_MatrixV._m20 * tmp1.x + tmp1.y;
                tmp1.x = unity_MatrixV._m22 * tmp1.z + tmp1.x;
                tmp1.y = 1.0 - tmp10.y;
                tmp1.x = tmp5.w * tmp1.y + tmp1.x;
                tmp10.z = tmp0.w * 0.125 + tmp1.x;
                tmp1 = tex2D(_CameraDepthTexture, tmp10.xz);
                tmp6 = tex2D(Ocean, tmp10.xz);
                tmp0.w = saturate(tmp10.z * -9.999998 + 9.999998);
                tmp1.yzw = tmp2.zzz * tmp6.xyz;
                tmp1.x = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp1.x = 1.0 / tmp1.x;
                tmp1.x = tmp1.x - _ProjectionParams.y;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = saturate(tmp1.x * 0.0011111 + -0.1111111);
                tmp2.z = tmp1.x * tmp2.z;
                tmp1.xyz = tmp1.xxx * tmp1.yzw;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = tmp0.w * tmp2.z;
                tmp0.w = tmp0.w * _ReflectionFade;
                tmp0.w = -tmp0.w * tmp3.y + 1.0;
                tmp1.xyz = tmp3.yyy * tmp1.xyz;
                tmp2.xyz = tmp2.xyw * tmp0.www;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = saturate(_ReflectionFade.xxx * tmp1.xyz + tmp0.xyz);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp3.xzw;
                tmp0.w = dot(tmp1.xyz, tmp4.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 1024.0;
                tmp0.w = exp(tmp0.w);
                tmp1.xyz = tmp0.www * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * float3(5.0, 5.0, 5.0);
                tmp1.xyz = tmp5.xyz * tmp2.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/Environment/Ocean Water Medium"
	CustomEditor "ShaderForgeMaterialInspector"
}