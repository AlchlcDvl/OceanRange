Shader "SR/Environment/Ocean Water Low" {
	Properties {
		_ColorRamp ("Color Ramp", 2D) = "gray" {}
		_Foam ("Foam", 2D) = "black" {}
		_WavesHeight ("Waves Height", 2D) = "black" {}
		_WavesNormal ("Waves Normal", 2D) = "bump" {}
		_EdgeFade ("EdgeFade", Range(0, 1)) = 1
		_EdgeHardness ("Edge Hardness", Range(0, 1)) = 1
		_EdgeSpeed ("Edge Speed", Float) = 1
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
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest+100" "RenderType" = "TransparentCutout" }
		GrabPass {
			"Ocean"
		}
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+100" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 27565
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Foam;
			sampler2D _WavesHeight;
			// Texture params for Fragment Shader
			sampler2D _WavesNormal;
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
                tmp0.yz = tmp1.xy * _Foam_ST.xy;
                tmp1.xy = _Foam_ST.xy * tmp1.zw + _Foam_ST.zw;
                tmp1 = tex2D(_Foam, tmp1.xy);
                tmp0.yz = tmp0.yz * float2(0.9, 0.9) + _Foam_ST.zw;
                tmp2 = tex2D(_Foam, tmp0.yz);
                tmp0.y = 1.0 - tmp2.x;
                tmp0.z = dot(tmp2.xy, tmp1.xy);
                tmp0.w = tmp1.x - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.w = -tmp0.w * tmp0.y + 1.0;
                tmp1.y = tmp1.x > 0.5;
                tmp1.x = 1.0 - tmp1.x;
                tmp0.y = saturate(-tmp0.y * tmp1.x + 1.0);
                tmp0.z = saturate(tmp1.y ? tmp0.w : tmp0.z);
                tmp0.yz = float2(1.0, 1.0) - tmp0.yz;
                tmp0.y = -tmp0.y * tmp0.z + 1.0;
                tmp0.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * inp.texcoord1.xyz;
                tmp2.xyz = abs(tmp1.xyz) * abs(tmp1.xyz);
                tmp0.z = tmp0.x * tmp2.x;
                tmp0.y = tmp2.y * tmp0.y + tmp0.z;
                tmp0.x = tmp2.z * tmp0.x + tmp0.y;
                tmp0.y = -tmp0.x * 0.5 + 1.0;
                tmp0.z = log(inp.color.x);
                tmp0.z = tmp0.z * 0.667;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.w = -tmp0.z * 0.667 + 1.0;
                tmp0.z = tmp0.z * 0.667;
                tmp0.y = -tmp0.y * tmp0.w + 1.0;
                tmp0.w = tmp0.x * 0.25 + 0.5;
                tmp1.w = tmp0.w > 0.5;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.y = saturate(tmp1.w ? tmp0.y : tmp0.z);
                tmp0.y = tmp0.y - 0.5;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.y = saturate(tmp1.y);
                tmp0.y = tmp0.y * -0.25 + 0.25;
                tmp0.z = 1.0 - inp.color.x;
                tmp0.yz = float2(1.0, 1.0) - tmp0.yz;
                tmp0.y = saturate(-tmp0.y * tmp0.z + 1.0);
                tmp0.z = tmp0.y * tmp0.x;
                tmp0.w = tmp0.z * 10.0 + -3.0;
                tmp0.x = -tmp0.x * tmp0.y + tmp0.w;
                tmp0.x = saturate(_EdgeHardness * tmp0.x + tmp0.z);
                tmp0.y = tmp0.x * _EdgeFade;
                tmp0.x = -tmp0.x * _EdgeFade + 1.0;
                tmp2.x = _WaveSpeed;
                tmp0.z = 1.0;
                tmp0.w = _WaveSpeed;
                tmp3.zw = tmp0.zw * _Time.yy;
                tmp3.x = tmp2.x * tmp3.z;
                tmp4 = tmp3.xwxw * float4(-1.0, -0.5, 3.0, 1.5) + inp.texcoord.xzxz;
                tmp0.zw = tmp4.xy * float2(0.5, 0.5);
                tmp3.xy = tmp0.zw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp0.zw = tmp0.zw * _WavesNormal_ST.xy + _WavesNormal_ST.zw;
                tmp5 = tex2D(_WavesNormal, tmp0.zw);
                tmp6 = tex2D(_WavesHeight, tmp3.xy);
                tmp0.z = tmp6.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp2.yw = float2(0.5, 0.5);
                tmp2.xy = tmp3.zw * tmp2.xy + inp.texcoord.xz;
                tmp3.xy = tmp2.xy * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp7 = tex2D(_WavesHeight, tmp3.xy);
                tmp0.w = 1.0 - tmp7.x;
                tmp1.w = dot(tmp7.xy, tmp6.xy);
                tmp3.x = tmp6.x > 0.5;
                tmp0.z = -tmp0.z * tmp0.w + 1.0;
                tmp0.z = saturate(tmp3.x ? tmp0.z : tmp1.w);
                tmp0.w = tmp0.z - 0.125;
                tmp3.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp3.xyz = tmp1.www * float3(0.0066667, 0.02, 0.025);
                tmp3.xy = log(tmp3.xy);
                tmp1.w = tmp3.z * tmp3.z;
                tmp1.w = 1.0 / tmp1.w;
                tmp1.w = saturate(tmp1.w);
                tmp3.xy = tmp3.xy * float2(-1.5, -1.5);
                tmp3.xy = exp(tmp3.xy);
                tmp3.xy = min(tmp3.xy, float2(1.0, 1.0));
                tmp3.z = tmp3.y * _WaveNoise;
                tmp6.xy = tmp3.zz * tmp0.ww + float2(0.125, -0.375);
                tmp0.w = -tmp6.y * 2.0 + 1.0;
                tmp4.zw = tmp4.zw * _Foam_ST.xy;
                tmp4.zw = tmp4.zw * float2(0.1, 0.1) + _Foam_ST.zw;
                tmp7 = tex2D(_Foam, tmp4.zw);
                tmp4.z = tmp7.x * 2.0 + -0.5;
                tmp4.w = tmp0.z + tmp7.x;
                tmp0.z = tmp0.z * tmp3.z;
                tmp6.yz = saturate(tmp0.zz * float2(5.0, 9.999998) + float2(-2.0, -7.499999));
                tmp6.yz = tmp6.yz * _WaveFade.xx;
                tmp6.yz = -tmp6.yz * float2(0.25, 0.667) + float2(1.0, 1.0);
                tmp0.z = saturate(-tmp6.y * tmp6.z + 1.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp4.w = tmp4.w * tmp3.z + -1.0;
                tmp5.z = -tmp4.z * tmp3.x + 1.0;
                tmp3.x = tmp3.x * tmp4.z;
                tmp6.yz = tmp3.yy * float2(-0.25, -0.25) + float2(0.75, 0.25);
                tmp0.w = -tmp0.w * tmp5.z + 1.0;
                tmp3.y = dot(tmp3.xy, tmp6.xy);
                tmp4.z = tmp6.x > 0.5;
                tmp0.w = saturate(tmp4.z ? tmp0.w : tmp3.y);
                tmp0.w = -tmp0.w * 0.5 + 1.0;
                tmp0.z = tmp0.z * tmp0.w;
                tmp5.x = tmp5.w * tmp5.x;
                tmp5.xy = tmp5.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp5.xy, tmp5.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp5.z = sqrt(tmp0.w);
                tmp6.xw = tmp2.xy * _WavesNormal_ST.xy + _WavesNormal_ST.zw;
                tmp7 = tex2D(_WavesNormal, tmp6.xw);
                tmp7.x = tmp7.w * tmp7.x;
                tmp7.xy = tmp7.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp7.xy, tmp7.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp7.z = sqrt(tmp0.w);
                tmp5.xyz = tmp5.xyz - tmp7.xyz;
                tmp5.xyz = tmp3.xxx * tmp5.xyz + tmp7.xyz;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp5.xyz * tmp0.www + float3(-0.0, -0.0, -1.0);
                tmp3.xyz = tmp3.zzz * tmp5.xyz + float3(0.0, 0.0, 1.0);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp5.xyz = tmp3.yyy * inp.texcoord3.xyz;
                tmp5.xyz = tmp3.xxx * inp.texcoord2.xyz + tmp5.xyz;
                tmp3.xyz = tmp3.zzz * tmp1.xyz + tmp5.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp5.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp7.xyz = tmp0.www * tmp5.xyz;
                tmp4.z = dot(tmp3.xyz, tmp7.xyz);
                tmp4.z = max(tmp4.z, 0.0);
                tmp4.z = 1.0 - tmp4.z;
                tmp5.w = rsqrt(tmp4.z);
                tmp5.w = 1.0 / tmp5.w;
                tmp0.z = tmp5.w * 0.5 + -tmp0.z;
                tmp0.z = tmp0.z + 1.0;
                tmp0.z = tmp0.z * 0.75;
                tmp0.z = min(tmp0.z, 1.0);
                tmp5.w = 1.0 - tmp0.z;
                tmp0.z = dot(tmp0.xy, tmp6.xy);
                tmp6.x = -tmp6.z * 2.0 + 1.0;
                tmp6.y = tmp6.y > 0.5;
                tmp5.w = -tmp6.x * tmp5.w + 1.0;
                tmp0.z = tmp6.y ? tmp5.w : tmp0.z;
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp5.w = _WaveOffset + unity_ObjectToWorld._m13;
                tmp5.w = inp.texcoord.y - tmp5.w;
                tmp6.x = _WaveHeight * -0.5;
                tmp5.w = tmp5.w * tmp5.w + tmp6.x;
                tmp5.w = tmp5.w * 0.2 + -0.1;
                tmp5.w = max(tmp5.w, -0.1);
                tmp5.w = min(tmp5.w, 0.1);
                tmp6.x = 1.0 - tmp4.z;
                tmp6.yz = saturate(tmp4.zz * float2(-2.0, -1.333333) + float2(1.0, 1.0));
                tmp4.z = tmp5.w + tmp6.x;
                tmp4.z = 1.0 - tmp4.z;
                tmp0.z = saturate(-tmp0.z * tmp4.z + 1.0);
                tmp1.x = dot(tmp1.xyz, tmp7.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = tmp1.x * tmp1.x + 0.25;
                tmp0.z = -tmp1.x * tmp0.z + 1.0;
                tmp2.z = saturate(-tmp0.x * tmp0.z + 1.0);
                tmp0.x = saturate(_Density * -0.0333333 + 1.0);
                tmp0.z = tmp2.z * 0.75 + tmp0.x;
                tmp1.xy = tmp2.zw * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp8 = tex2D(_ColorRamp, tmp1.xy);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.y = tmp0.z * _Alpha + tmp0.y;
                tmp1.xyz = -tmp0.xxx / _ColorMultiply.xyz;
                tmp1.xyz = saturate(tmp1.xyz + float3(1.0, 1.0, 1.0));
                tmp9.xyz = tmp1.xyz * tmp1.xyz;
                tmp9.xyz = tmp1.xyz * tmp9.xyz + -tmp1.xyz;
                tmp1.xyz = tmp0.xxx * tmp9.xyz + tmp1.xyz;
                tmp0.xz = -tmp7.xz * float2(2.0, 2.0) + inp.texcoord.xz;
                tmp2.xy = tmp0.xz + tmp2.xy;
                tmp0.xz = tmp4.xy * float2(0.5, 0.5) + tmp0.xz;
                tmp0.xz = tmp0.xz * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp9 = tex2D(_WavesHeight, tmp0.xz);
                tmp0.xz = tmp2.xy * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp2 = tex2D(_WavesHeight, tmp0.xz);
                tmp0.x = saturate(tmp9.x * tmp2.x);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = rsqrt(tmp0.x);
                tmp0.x = 1.0 / tmp0.x;
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.x = tmp0.x * _RefractedLightFade;
                tmp0.x = saturate(tmp0.x * 0.5);
                tmp0.z = tmp4.w * _RefractionAmount;
                tmp2.x = _ProjectionParams.x > 0.0;
                tmp4.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2.y = 1.0 - tmp4.y;
                tmp4.z = tmp2.x ? tmp2.y : tmp4.y;
                tmp2.xy = tmp0.zz * float2(0.025, 0.025) + tmp4.xz;
                tmp2.zw = tmp3.ww * float2(0.85, 0.425) + tmp0.zz;
                tmp2.zw = tmp2.zw + inp.texcoord.xz;
                tmp2.zw = tmp2.zw * _SurfacePattern_ST.xy + _SurfacePattern_ST.zw;
                tmp9 = tex2D(_SurfacePattern, tmp2.zw);
                tmp4.xyz = tmp6.zzz * tmp9.xyz;
                tmp4.xyz = tmp1.www * tmp4.xyz;
                tmp4.xyz = saturate(tmp4.xyz * _SurfacePataternFade.xxx + tmp8.xyz);
                tmp2 = tex2D(Ocean, tmp2.xy);
                tmp2.xyz = tmp0.xxx + tmp2.xyz;
                tmp0.x = _Density * _DirtOffset;
                tmp8 = tmp0.xxxx * float4(0.4, 0.4, 0.8, 0.8);
                tmp7 = -tmp7.xzxz * tmp8 + inp.texcoord.xzxz;
                tmp7 = tmp3.wwww * float4(0.85, 0.425, 0.5, 0.25) + tmp7;
                tmp7 = tmp4.wwww * _RefractionAmount.xxxx + tmp7;
                tmp7 = tmp7 * _Dirt_ST + _Dirt_ST;
                tmp8 = tex2D(_Dirt, tmp7.xy);
                tmp7 = tex2D(_Dirt, tmp7.zw);
                tmp7.x = saturate(tmp7.x);
                tmp0.x = saturate(tmp8.x * 1.428571 + -0.4285715);
                tmp0.x = tmp7.x * 0.5 + tmp0.x;
                tmp0.x = tmp6.y * tmp0.x;
                tmp0.x = tmp0.x * _DirtFade;
                tmp2.xyz = saturate(tmp0.xxx * float3(1.5, 1.5, 1.5) + tmp2.xyz);
                tmp4.xyz = tmp0.xxx * float3(0.1875, 0.1875, 0.1875) + tmp4.xyz;
                tmp4.xyz = tmp0.yyy * tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.yyy * -tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp0.xyz * float3(0.5, 0.5, 0.5) + float3(1.0, 1.0, 1.0);
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp6.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp3.xyz, tmp6.xyz);
                tmp5.xyz = tmp5.xyz * tmp0.www + tmp6.xyz;
                tmp1.xyz = tmp1.www * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp2.xyz * tmp1.www;
                tmp2.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5) + -tmp2.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp1.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                tmp1.xyz = tmp2.xyz * tmp0.xyz + tmp1.xyz;
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz + tmp2.xyz;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp5.xyz;
                tmp0.w = dot(tmp2.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 1024.0;
                tmp0.w = exp(tmp0.w);
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp2.xyz = tmp2.xyz * float3(5.0, 5.0, 5.0);
                tmp1.xyz = tmp1.xyz * tmp4.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest+100" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 110721
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Foam;
			sampler2D _WavesHeight;
			// Texture params for Fragment Shader
			sampler2D _WavesNormal;
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
                tmp0.yz = tmp1.xy * _Foam_ST.xy;
                tmp1.xy = _Foam_ST.xy * tmp1.zw + _Foam_ST.zw;
                tmp1 = tex2D(_Foam, tmp1.xy);
                tmp0.yz = tmp0.yz * float2(0.9, 0.9) + _Foam_ST.zw;
                tmp2 = tex2D(_Foam, tmp0.yz);
                tmp0.y = 1.0 - tmp2.x;
                tmp0.z = dot(tmp2.xy, tmp1.xy);
                tmp0.w = tmp1.x - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.w = -tmp0.w * tmp0.y + 1.0;
                tmp1.y = tmp1.x > 0.5;
                tmp1.x = 1.0 - tmp1.x;
                tmp0.y = saturate(-tmp0.y * tmp1.x + 1.0);
                tmp0.z = saturate(tmp1.y ? tmp0.w : tmp0.z);
                tmp0.yz = float2(1.0, 1.0) - tmp0.yz;
                tmp0.y = -tmp0.y * tmp0.z + 1.0;
                tmp0.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * inp.texcoord1.xyz;
                tmp2.xyz = abs(tmp1.xyz) * abs(tmp1.xyz);
                tmp0.z = tmp0.x * tmp2.x;
                tmp0.y = tmp2.y * tmp0.y + tmp0.z;
                tmp0.x = tmp2.z * tmp0.x + tmp0.y;
                tmp0.y = -tmp0.x * 0.5 + 1.0;
                tmp0.z = log(inp.color.x);
                tmp0.z = tmp0.z * 0.667;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.w = -tmp0.z * 0.667 + 1.0;
                tmp0.z = tmp0.z * 0.667;
                tmp0.y = -tmp0.y * tmp0.w + 1.0;
                tmp0.w = tmp0.x * 0.25 + 0.5;
                tmp1.w = tmp0.w > 0.5;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.y = saturate(tmp1.w ? tmp0.y : tmp0.z);
                tmp0.y = tmp0.y - 0.5;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.y = saturate(tmp1.y);
                tmp0.y = tmp0.y * -0.25 + 0.25;
                tmp0.z = 1.0 - inp.color.x;
                tmp0.yz = float2(1.0, 1.0) - tmp0.yz;
                tmp0.y = saturate(-tmp0.y * tmp0.z + 1.0);
                tmp0.z = tmp0.y * tmp0.x;
                tmp0.w = tmp0.z * 10.0 + -3.0;
                tmp0.x = -tmp0.x * tmp0.y + tmp0.w;
                tmp0.x = saturate(_EdgeHardness * tmp0.x + tmp0.z);
                tmp0.y = tmp0.x * _EdgeFade;
                tmp0.x = -tmp0.x * _EdgeFade + 1.0;
                tmp2.x = _WaveSpeed;
                tmp0.z = 1.0;
                tmp0.w = _WaveSpeed;
                tmp3.zw = tmp0.zw * _Time.yy;
                tmp3.x = tmp2.x * tmp3.z;
                tmp4 = tmp3.xwxw * float4(-1.0, -0.5, 3.0, 1.5) + inp.texcoord.xzxz;
                tmp0.zw = tmp4.xy * float2(0.5, 0.5);
                tmp3.xy = tmp0.zw * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp0.zw = tmp0.zw * _WavesNormal_ST.xy + _WavesNormal_ST.zw;
                tmp5 = tex2D(_WavesNormal, tmp0.zw);
                tmp6 = tex2D(_WavesHeight, tmp3.xy);
                tmp0.z = tmp6.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp2.yw = float2(0.5, 0.5);
                tmp2.xy = tmp3.zw * tmp2.xy + inp.texcoord.xz;
                tmp3.xy = tmp2.xy * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp7 = tex2D(_WavesHeight, tmp3.xy);
                tmp0.w = 1.0 - tmp7.x;
                tmp1.w = dot(tmp7.xy, tmp6.xy);
                tmp3.x = tmp6.x > 0.5;
                tmp0.z = -tmp0.z * tmp0.w + 1.0;
                tmp0.z = saturate(tmp3.x ? tmp0.z : tmp1.w);
                tmp0.w = tmp0.z - 0.125;
                tmp3.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp3.xyz = tmp1.www * float3(0.0066667, 0.02, 0.025);
                tmp3.xy = log(tmp3.xy);
                tmp1.w = tmp3.z * tmp3.z;
                tmp1.w = 1.0 / tmp1.w;
                tmp1.w = saturate(tmp1.w);
                tmp3.xy = tmp3.xy * float2(-1.5, -1.5);
                tmp3.xy = exp(tmp3.xy);
                tmp3.xy = min(tmp3.xy, float2(1.0, 1.0));
                tmp3.z = tmp3.y * _WaveNoise;
                tmp6.xy = tmp3.zz * tmp0.ww + float2(0.125, -0.375);
                tmp0.w = -tmp6.y * 2.0 + 1.0;
                tmp4.zw = tmp4.zw * _Foam_ST.xy;
                tmp4.zw = tmp4.zw * float2(0.1, 0.1) + _Foam_ST.zw;
                tmp7 = tex2D(_Foam, tmp4.zw);
                tmp4.z = tmp7.x * 2.0 + -0.5;
                tmp4.w = tmp0.z + tmp7.x;
                tmp0.z = tmp0.z * tmp3.z;
                tmp6.yz = saturate(tmp0.zz * float2(5.0, 9.999998) + float2(-2.0, -7.499999));
                tmp6.yz = tmp6.yz * _WaveFade.xx;
                tmp6.yz = -tmp6.yz * float2(0.25, 0.667) + float2(1.0, 1.0);
                tmp0.z = saturate(-tmp6.y * tmp6.z + 1.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp4.w = tmp4.w * tmp3.z + -1.0;
                tmp5.z = -tmp4.z * tmp3.x + 1.0;
                tmp3.x = tmp3.x * tmp4.z;
                tmp6.yz = tmp3.yy * float2(-0.25, -0.25) + float2(0.75, 0.25);
                tmp0.w = -tmp0.w * tmp5.z + 1.0;
                tmp3.y = dot(tmp3.xy, tmp6.xy);
                tmp4.z = tmp6.x > 0.5;
                tmp0.w = saturate(tmp4.z ? tmp0.w : tmp3.y);
                tmp0.w = -tmp0.w * 0.5 + 1.0;
                tmp0.z = tmp0.z * tmp0.w;
                tmp5.x = tmp5.w * tmp5.x;
                tmp5.xy = tmp5.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp5.xy, tmp5.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp5.z = sqrt(tmp0.w);
                tmp6.xw = tmp2.xy * _WavesNormal_ST.xy + _WavesNormal_ST.zw;
                tmp7 = tex2D(_WavesNormal, tmp6.xw);
                tmp7.x = tmp7.w * tmp7.x;
                tmp7.xy = tmp7.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp7.xy, tmp7.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp7.z = sqrt(tmp0.w);
                tmp5.xyz = tmp5.xyz - tmp7.xyz;
                tmp5.xyz = tmp3.xxx * tmp5.xyz + tmp7.xyz;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp5.xyz * tmp0.www + float3(-0.0, -0.0, -1.0);
                tmp3.xyz = tmp3.zzz * tmp5.xyz + float3(0.0, 0.0, 1.0);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp5.xyz = tmp3.yyy * inp.texcoord3.xyz;
                tmp5.xyz = tmp3.xxx * inp.texcoord2.xyz + tmp5.xyz;
                tmp3.xyz = tmp3.zzz * tmp1.xyz + tmp5.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp5.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp7.xyz = tmp0.www * tmp5.xyz;
                tmp4.z = dot(tmp3.xyz, tmp7.xyz);
                tmp4.z = max(tmp4.z, 0.0);
                tmp4.z = 1.0 - tmp4.z;
                tmp5.w = rsqrt(tmp4.z);
                tmp5.w = 1.0 / tmp5.w;
                tmp0.z = tmp5.w * 0.5 + -tmp0.z;
                tmp0.z = tmp0.z + 1.0;
                tmp0.z = tmp0.z * 0.75;
                tmp0.z = min(tmp0.z, 1.0);
                tmp5.w = 1.0 - tmp0.z;
                tmp0.z = dot(tmp0.xy, tmp6.xy);
                tmp6.x = -tmp6.z * 2.0 + 1.0;
                tmp6.y = tmp6.y > 0.5;
                tmp5.w = -tmp6.x * tmp5.w + 1.0;
                tmp0.z = tmp6.y ? tmp5.w : tmp0.z;
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp5.w = _WaveOffset + unity_ObjectToWorld._m13;
                tmp5.w = inp.texcoord.y - tmp5.w;
                tmp6.x = _WaveHeight * -0.5;
                tmp5.w = tmp5.w * tmp5.w + tmp6.x;
                tmp5.w = tmp5.w * 0.2 + -0.1;
                tmp5.w = max(tmp5.w, -0.1);
                tmp5.w = min(tmp5.w, 0.1);
                tmp6.x = 1.0 - tmp4.z;
                tmp6.yz = saturate(tmp4.zz * float2(-2.0, -1.333333) + float2(1.0, 1.0));
                tmp4.z = tmp5.w + tmp6.x;
                tmp4.z = 1.0 - tmp4.z;
                tmp0.z = saturate(-tmp0.z * tmp4.z + 1.0);
                tmp1.x = dot(tmp1.xyz, tmp7.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = tmp1.x * tmp1.x + 0.25;
                tmp0.z = -tmp1.x * tmp0.z + 1.0;
                tmp2.z = saturate(-tmp0.x * tmp0.z + 1.0);
                tmp0.x = saturate(_Density * -0.0333333 + 1.0);
                tmp0.z = tmp2.z * 0.75 + tmp0.x;
                tmp1.xy = tmp2.zw * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp8 = tex2D(_ColorRamp, tmp1.xy);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.y = tmp0.z * _Alpha + tmp0.y;
                tmp1.xyz = -tmp0.xxx / _ColorMultiply.xyz;
                tmp1.xyz = saturate(tmp1.xyz + float3(1.0, 1.0, 1.0));
                tmp9.xyz = tmp1.xyz * tmp1.xyz;
                tmp9.xyz = tmp1.xyz * tmp9.xyz + -tmp1.xyz;
                tmp1.xyz = tmp0.xxx * tmp9.xyz + tmp1.xyz;
                tmp0.xz = -tmp7.xz * float2(2.0, 2.0) + inp.texcoord.xz;
                tmp2.xy = tmp0.xz + tmp2.xy;
                tmp0.xz = tmp4.xy * float2(0.5, 0.5) + tmp0.xz;
                tmp0.xz = tmp0.xz * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp9 = tex2D(_WavesHeight, tmp0.xz);
                tmp0.xz = tmp2.xy * _WavesHeight_ST.xy + _WavesHeight_ST.zw;
                tmp2 = tex2D(_WavesHeight, tmp0.xz);
                tmp0.x = saturate(tmp9.x * tmp2.x);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = rsqrt(tmp0.x);
                tmp0.x = 1.0 / tmp0.x;
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.x = tmp0.x * _RefractedLightFade;
                tmp0.x = saturate(tmp0.x * 0.5);
                tmp0.z = tmp4.w * _RefractionAmount;
                tmp2.x = _ProjectionParams.x > 0.0;
                tmp4.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp2.y = 1.0 - tmp4.y;
                tmp4.z = tmp2.x ? tmp2.y : tmp4.y;
                tmp2.xy = tmp0.zz * float2(0.025, 0.025) + tmp4.xz;
                tmp2.zw = tmp3.ww * float2(0.85, 0.425) + tmp0.zz;
                tmp2.zw = tmp2.zw + inp.texcoord.xz;
                tmp2.zw = tmp2.zw * _SurfacePattern_ST.xy + _SurfacePattern_ST.zw;
                tmp9 = tex2D(_SurfacePattern, tmp2.zw);
                tmp4.xyz = tmp6.zzz * tmp9.xyz;
                tmp4.xyz = tmp1.www * tmp4.xyz;
                tmp4.xyz = saturate(tmp4.xyz * _SurfacePataternFade.xxx + tmp8.xyz);
                tmp2 = tex2D(Ocean, tmp2.xy);
                tmp2.xyz = tmp0.xxx + tmp2.xyz;
                tmp0.x = _Density * _DirtOffset;
                tmp8 = tmp0.xxxx * float4(0.4, 0.4, 0.8, 0.8);
                tmp7 = -tmp7.xzxz * tmp8 + inp.texcoord.xzxz;
                tmp7 = tmp3.wwww * float4(0.85, 0.425, 0.5, 0.25) + tmp7;
                tmp7 = tmp4.wwww * _RefractionAmount.xxxx + tmp7;
                tmp7 = tmp7 * _Dirt_ST + _Dirt_ST;
                tmp8 = tex2D(_Dirt, tmp7.xy);
                tmp7 = tex2D(_Dirt, tmp7.zw);
                tmp7.x = saturate(tmp7.x);
                tmp0.x = saturate(tmp8.x * 1.428571 + -0.4285715);
                tmp0.x = tmp7.x * 0.5 + tmp0.x;
                tmp0.x = tmp6.y * tmp0.x;
                tmp0.x = tmp0.x * _DirtFade;
                tmp2.xyz = saturate(tmp0.xxx * float3(1.5, 1.5, 1.5) + tmp2.xyz);
                tmp4.xyz = tmp0.xxx * float3(0.1875, 0.1875, 0.1875) + tmp4.xyz;
                tmp4.xyz = tmp0.yyy * tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.yyy * -tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp0.xyz * float3(0.5, 0.5, 0.5) + float3(1.0, 1.0, 1.0);
                tmp6.xyz = _WorldSpaceLightPos0.www * -inp.texcoord.xyz + _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp6.xyz, tmp6.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp6.xyz = tmp1.www * tmp6.xyz;
                tmp1.w = dot(tmp3.xyz, tmp6.xyz);
                tmp5.xyz = tmp5.xyz * tmp0.www + tmp6.xyz;
                tmp1.xyz = tmp1.www * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp2.xyz * tmp1.www;
                tmp2.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5) + -tmp2.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp1.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = tmp2.xyz * tmp0.xyz + tmp1.xyz;
                tmp0.w = dot(inp.texcoord5.xyz, inp.texcoord5.xyz);
                tmp1 = tex2D(_LightTexture0, tmp0.ww);
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp5.xyz;
                tmp0.w = dot(tmp2.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 1024.0;
                tmp0.w = exp(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(5.0, 5.0, 5.0);
                o.sv_target.xyz = tmp0.xyz * tmp4.xyz + tmp1.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest+100" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 177893
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Foam;
			sampler2D _WavesHeight;
			// Texture params for Fragment Shader
			
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
                tmp0.z = log(inp.color.x);
                tmp0.z = tmp0.z * 0.667;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp0.z * tmp0.z;
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
	CustomEditor "ShaderForgeMaterialInspector"
}