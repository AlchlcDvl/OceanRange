Shader "SR/Actor/Slime/Shimmer Body" {
	Properties {
		_Noise ("Noise", 2D) = "black" {}
		_MainTexture ("Main Texture", 2D) = "black" {}
		_Fade ("Fade", Range(0, 1)) = 1
		_Sparkles ("Sparkles", 2D) = "black" {}
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "AlphaTest+0" "RenderType" = "Opaque" }
		GrabPass {
			"_RefractionAlphaClip"
		}
		GrabPass {
			"_Refraction"
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+0" "RenderType" = "Opaque" }
			Blend One Zero, SrcAlpha OneMinusSrcAlpha
			AlphaToMask On
			GpuProgramID 13274
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
				float3 texcoord5 : TEXCOORD5;
				float4 texcoord7 : TEXCOORD7;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _Fade;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RefractionAlphaClip;
			sampler2D _MainTexture;
			sampler2D _Noise;
			sampler2D _Sparkles;
			sampler2D _Refraction;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = dot(v.vertex.xyz, v.vertex.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.vertex.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = v.color.w * _Fade;
                tmp1.x = tmp0.w * tmp0.w;
                tmp0.w = -tmp0.w * tmp1.x + 1.0;
                tmp0.xyz = tmp0.xyz * tmp0.www + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord1.w = tmp0.x;
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp4.xyz = tmp2.xyz * tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx + -tmp4.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord1.z = tmp2.y;
                o.texcoord2.w = tmp0.y;
                o.texcoord3.w = tmp0.z;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.z = tmp2.z;
                o.texcoord3.z = tmp2.x;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord4.zw = tmp1.zw;
                o.texcoord4.xy = tmp0.zz + tmp0.xw;
                o.color = v.color;
                o.texcoord5.xyz = float3(0.0, 0.0, 0.0);
                o.texcoord7 = float4(0.0, 0.0, 0.0, 0.0);
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
                tmp0.xz = float2(0.0, 1.0);
                tmp1.xy = _WorldSpaceCameraPos.xy - unity_ObjectToWorld._m03_m13;
                tmp1.xy = inp.texcoord.xy * float2(10.0, 10.0) + tmp1.xy;
                tmp0.w = dot(tmp1.xy, float2(0.3660254, 0.3660254));
                tmp1.zw = tmp0.ww + tmp1.xy;
                tmp1.zw = floor(tmp1.zw);
                tmp2.xy = tmp1.zw * float2(0.0034602, 0.0034602);
                tmp2.xy = floor(tmp2.xy);
                tmp2.xy = -tmp2.xy * float2(289.0, 289.0) + tmp1.zw;
                tmp1.xy = tmp1.xy - tmp1.zw;
                tmp0.w = dot(tmp1.xy, float2(0.2113249, 0.2113249));
                tmp1.xy = tmp0.ww + tmp1.xy;
                tmp0.w = tmp1.y < tmp1.x;
                tmp3 = tmp0.wwww ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp0.y = tmp3.y;
                tmp0.xyz = tmp0.xyz + tmp2.yyy;
                tmp2.yzw = tmp0.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.yzw;
                tmp2.yzw = tmp0.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp2.yzw = floor(tmp2.yzw);
                tmp0.xyz = -tmp2.yzw * float3(289.0, 289.0, 289.0) + tmp0.xyz;
                tmp0.xyz = tmp2.xxx + tmp0.xyz;
                tmp2.xz = float2(0.0, 1.0);
                tmp2.y = tmp3.x;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp2.xyz = tmp0.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp0.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp2.xyz = floor(tmp2.xyz);
                tmp0.xyz = -tmp2.xyz * float3(289.0, 289.0, 289.0) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp0.xyz = frac(tmp0.xyz);
                tmp2.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp0.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.xyz = floor(tmp2.xyz);
                tmp2.xyz = tmp0.xyz - tmp2.xyz;
                tmp0.xyz = abs(tmp0.xyz) - float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp0.xyz * tmp0.xyz;
                tmp4.xyz = tmp2.xyz * tmp2.xyz + tmp4.xyz;
                tmp4.xyz = -tmp4.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp5.x = dot(tmp1.xy, tmp1.xy);
                tmp6 = tmp1.xyxy + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp6.xy = tmp3.zw + tmp6.xy;
                tmp5.y = dot(tmp6.xy, tmp6.xy);
                tmp5.z = dot(tmp6.xy, tmp6.xy);
                tmp3.xyz = float3(0.5, 0.5, 0.5) - tmp5.xyz;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp3.xyz = tmp3.xyz * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * tmp3.xyz;
                tmp3.xyz = tmp4.xyz * tmp3.xyz;
                tmp0.x = tmp1.y * tmp0.x;
                tmp0.yz = tmp0.yz * tmp6.yw;
                tmp4.yz = tmp2.yz * tmp6.xz + tmp0.yz;
                tmp4.x = tmp2.x * tmp1.x + tmp0.x;
                tmp0.x = dot(tmp3.xyz, tmp4.xyz);
                tmp0.x = saturate(tmp0.x * 130.0);
                tmp1.x = inp.texcoord1.w;
                tmp1.y = inp.texcoord2.w;
                tmp1.z = inp.texcoord3.w;
                tmp0.yzw = _WorldSpaceCameraPos - tmp1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.yzw = tmp0.yzw * tmp1.xxx + float3(0.0, 0.5, 0.0);
                tmp2.x = dot(tmp1.xyz, tmp1.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp1.yzw = tmp1.yzw * tmp2.xxx;
                tmp2.xyz = inp.texcoord2.zzz * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = unity_WorldToObject._m00_m10_m20 * inp.texcoord1.zzz + tmp2.xyz;
                tmp2.xyz = unity_WorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp2.xyz;
                tmp1.y = dot(tmp2.xyz, tmp1.xyz);
                tmp1.y = tmp1.y + 1.0;
                tmp1.y = tmp1.y * 0.5;
                tmp1.y = log(tmp1.y);
                tmp1.y = tmp1.y * 300.0;
                tmp1.y = exp(tmp1.y);
                tmp3.xyz = tmp0.yzw * tmp1.xxx + float3(0.0, -0.5, 0.0);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.x = dot(tmp3.xyz, tmp3.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xzw = tmp1.xxx * tmp3.xyz;
                tmp1.x = dot(tmp2.xyz, tmp1.xyz);
                tmp1.x = tmp1.x + 1.0;
                tmp1.x = tmp1.x * 0.5;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * 300.0;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.x + tmp1.y;
                tmp2.xz = float2(0.0, 1.0);
                tmp3.xz = float2(0.0, 1.0);
                tmp1.yz = _Time.yy * float2(-0.05, -0.5) + inp.texcoord.xy;
                tmp4.x = inp.texcoord1.z;
                tmp4.y = inp.texcoord2.z;
                tmp4.z = inp.texcoord3.z;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp5.xy = tmp1.ww * tmp4.xz;
                tmp2.w = tmp5.y + tmp5.x;
                tmp3.w = _Time.y * -0.25 + tmp5.x;
                tmp5.x = sin(tmp3.w);
                tmp6.x = cos(tmp3.w);
                tmp1.yz = tmp1.yz + tmp2.ww;
                tmp2.w = dot(tmp1.xy, float2(0.3660254, 0.3660254));
                tmp5.yz = tmp1.yz + tmp2.ww;
                tmp5.yz = floor(tmp5.yz);
                tmp1.yz = tmp1.yz - tmp5.yz;
                tmp2.w = dot(tmp5.xy, float2(0.2113249, 0.2113249));
                tmp1.yz = tmp1.yz + tmp2.ww;
                tmp2.w = tmp1.z < tmp1.y;
                tmp7 = tmp2.wwww ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp3.y = tmp7.y;
                tmp6.yz = tmp5.yz * float2(0.0034602, 0.0034602);
                tmp6.yz = floor(tmp6.yz);
                tmp5.yz = -tmp6.yz * float2(289.0, 289.0) + tmp5.yz;
                tmp3.xyz = tmp3.xyz + tmp5.zzz;
                tmp6.yzw = tmp3.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp3.xyz * tmp6.yzw;
                tmp6.yzw = tmp3.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp6.yzw = floor(tmp6.yzw);
                tmp3.xyz = -tmp6.yzw * float3(289.0, 289.0, 289.0) + tmp3.xyz;
                tmp3.xyz = tmp5.yyy + tmp3.xyz;
                tmp2.y = tmp7.x;
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp2.xyz = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp2.xyz = frac(tmp2.xyz);
                tmp3.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3.xyz = floor(tmp3.xyz);
                tmp3.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = abs(tmp2.xyz) - float3(0.5, 0.5, 0.5);
                tmp5.yzw = tmp2.xyz * tmp2.xyz;
                tmp5.yzw = tmp3.xyz * tmp3.xyz + tmp5.yzw;
                tmp5.yzw = -tmp5.yzw * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp8 = tmp1.yzyz + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp8.xy = tmp7.zw + tmp8.xy;
                tmp7.y = dot(tmp8.xy, tmp8.xy);
                tmp7.x = dot(tmp1.xy, tmp1.xy);
                tmp7.z = dot(tmp8.xy, tmp8.xy);
                tmp6.yzw = float3(0.5, 0.5, 0.5) - tmp7.xyz;
                tmp6.yzw = max(tmp6.yzw, float3(0.0, 0.0, 0.0));
                tmp6.yzw = tmp6.yzw * tmp6.yzw;
                tmp6.yzw = tmp6.yzw * tmp6.yzw;
                tmp5.yzw = tmp5.yzw * tmp6.yzw;
                tmp1.z = tmp1.z * tmp2.x;
                tmp2.xy = tmp2.yz * tmp8.yw;
                tmp2.yz = tmp3.yz * tmp8.xz + tmp2.xy;
                tmp2.x = tmp3.x * tmp1.y + tmp1.z;
                tmp1.y = dot(tmp5.xyz, tmp2.xyz);
                tmp2.xy = inp.texcoord2.zz * unity_MatrixV._m01_m11;
                tmp2.xy = unity_MatrixV._m00_m10 * inp.texcoord1.zz + tmp2.xy;
                tmp2.xy = unity_MatrixV._m02_m12 * inp.texcoord3.zz + tmp2.xy;
                tmp2.zw = tmp2.xy * float2(0.5, 0.5);
                tmp2.xy = tmp2.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp3.z = tmp5.x;
                tmp3.y = tmp6.x;
                tmp3.x = -tmp5.x;
                tmp5.y = dot(tmp2.xy, tmp3.xy);
                tmp5.x = dot(tmp2.xy, tmp3.xy);
                tmp3.xy = tmp5.xy + float2(0.5, 0.5);
                tmp3.xy = tmp1.yy * float2(3.9, 3.9) + tmp3.xy;
                tmp3 = tex2D(_MainTexture, tmp3.xy);
                tmp3.xy = _Time.yy * float2(0.3, 0.2);
                tmp1.z = tmp4.z * tmp1.w + tmp3.x;
                tmp1.w = sin(tmp3.y);
                tmp1.w = tmp1.w + 1.0;
                tmp1.w = tmp1.w * 1.5 + -1.0;
                tmp1.xw = min(tmp1.xw, float2(1.0, 1.0));
                tmp5.x = abs(tmp1.w);
                tmp3.x = sin(tmp1.z);
                tmp6.x = cos(tmp1.z);
                tmp7.z = tmp3.x;
                tmp7.y = tmp6.x;
                tmp7.x = -tmp3.x;
                tmp3.y = dot(tmp2.xy, tmp7.xy);
                tmp3.x = dot(tmp2.xy, tmp7.xy);
                tmp1.zw = tmp3.xy + float2(0.5, 0.5);
                tmp1.zw = tmp1.yy * float2(3.9, 3.9) + tmp1.zw;
                tmp6 = tex2D(_MainTexture, tmp1.zw);
                tmp1.z = dot(tmp3.xy, tmp6.xy);
                tmp1.w = 1.0 - tmp3.z;
                tmp2.zw = tmp6.wz - float2(0.03, 0.5);
                tmp3.x = tmp6.z > 0.5;
                tmp2.w = -tmp2.w * 2.0 + 1.0;
                tmp2.z = saturate(tmp2.z * 1.030928);
                tmp1.w = -tmp2.w * tmp1.w + 1.0;
                tmp1.z = saturate(tmp3.x ? tmp1.w : tmp1.z);
                tmp1.w = 1.0 - tmp1.z;
                tmp0.y = dot(tmp4.xyz, tmp0.xyz);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.w = -tmp0.y * tmp0.z + 1.0;
                tmp0.z = tmp0.z * tmp0.y;
                tmp0.z = tmp0.z * 0.5 + 0.5;
                tmp0.w = -tmp0.w * tmp1.w + 1.0;
                tmp1.z = dot(tmp1.xy, tmp0.xy);
                tmp0.z = tmp0.z > 0.5;
                tmp0.z = saturate(tmp0.z ? tmp0.w : tmp1.z);
                tmp0.w = inp.color.w * _Fade;
                tmp1.z = tmp0.w * tmp0.w;
                tmp1.w = tmp0.w * tmp1.z + -0.5;
                tmp0.w = tmp0.w * tmp1.z;
                tmp1.z = tmp1.w * -1.9 + 1.0;
                tmp1.w = -tmp1.w * 2.0 + 1.0;
                tmp1.z = max(tmp1.z, 0.0);
                tmp1.z = min(tmp1.z, 0.25);
                tmp1.z = tmp1.z * tmp2.z;
                tmp2.z = tmp2.z * 0.5;
                tmp0.z = tmp0.z * 0.75 + tmp1.z;
                tmp0.z = tmp1.x + tmp0.z;
                tmp3.xy = _Time.yy * float2(0.2, 0.2) + float2(1.0, 2.0);
                tmp3.xy = sin(tmp3.xy);
                tmp3.xy = tmp3.xy + float2(1.0, 1.0);
                tmp3.xy = tmp3.xy * float2(1.5, 1.5) + float2(-1.0, -1.0);
                tmp3.xy = min(tmp3.xy, float2(1.0, 1.0));
                tmp5.yz = abs(tmp3.xy);
                tmp1.z = dot(tmp5.xyz, float3(0.299, 0.587, 0.114));
                tmp3.xyz = tmp1.zzz - tmp5.xyz;
                tmp3.xyz = tmp3.xyz * float3(0.5, 0.5, 0.5) + tmp5.xyz;
                tmp5.xy = _Time.yy * float2(0.01, -0.05) + tmp2.xy;
                tmp2.xy = _Time.yy * float2(-0.005, 0.025) + -tmp2.xy;
                tmp2.xy = tmp2.xy * float2(0.5, 0.5);
                tmp6 = tex2D(_Noise, tmp2.xy);
                tmp5 = tex2D(_Noise, tmp5.xy);
                tmp2.xyw = tmp5.xyz - tmp6.xyz;
                tmp2.xyz = tmp2.zzz * tmp2.xyw + tmp6.xyz;
                tmp5.xyz = tmp3.xyz - tmp2.xyz;
                tmp1.z = saturate(inp.texcoord2.z);
                tmp2.xyz = tmp1.zzz * tmp5.xyz + tmp2.xyz;
                tmp1.z = dot(tmp2.xyz, float3(0.299, 0.587, 0.114));
                tmp5.xyz = tmp1.zzz - tmp2.xyz;
                tmp5.xyz = tmp5.xyz * float3(0.333, 0.333, 0.333) + tmp2.xyz;
                tmp5.xyz = tmp0.zzz + tmp5.xyz;
                tmp1.z = inp.texcoord4.w + 0.0;
                tmp2.w = tmp1.z * 0.5;
                tmp3.w = -tmp1.z * 0.5 + inp.texcoord4.y;
                tmp6.y = -tmp3.w * _ProjectionParams.x + tmp2.w;
                tmp6.x = inp.texcoord4.x;
                tmp6.xy = tmp6.xy / tmp1.zz;
                tmp6.zw = tmp1.yy * float2(3.9, 3.9) + tmp6.xy;
                tmp1.y = tmp1.y * 3.9 + 0.03;
                tmp1.y = tmp1.y * 11.66667 + 0.3;
                tmp7 = tex2D(_Refraction, tmp6.xy);
                tmp6.xy = tmp6.zw * float2(0.8, 0.8) + float2(0.1, 0.1);
                tmp6 = tex2D(_RefractionAlphaClip, tmp6.xy);
                tmp2.xyz = tmp2.xyz * float3(0.25, 0.25, 0.25) + tmp6.xyz;
                tmp1.z = 1.0 - tmp0.y;
                tmp2.w = tmp1.z * tmp1.z;
                tmp2.w = tmp2.w * tmp2.w;
                tmp1.z = saturate(tmp1.z * tmp2.w);
                tmp6.xyz = tmp1.zzz * tmp3.xyz;
                tmp1.z = -tmp1.z * tmp1.y + 1.0;
                tmp6.xyz = tmp1.yyy * tmp6.xyz;
                tmp2.xyz = tmp2.xyz * tmp1.zzz + tmp6.xyz;
                tmp2.xyz = tmp0.zzz * tmp5.xyz + tmp2.xyz;
                tmp5.xyz = abs(tmp4.xyz) * abs(tmp4.xyz);
                tmp5.xyz = tmp5.xyz * tmp5.xyz;
                tmp5.xyw = abs(tmp4.xyz) * tmp5.xyz;
                tmp0.z = tmp5.y + tmp5.x;
                tmp0.z = abs(tmp4.z) * tmp5.z + tmp0.z;
                tmp5.xyz = tmp5.xyw / tmp0.zzz;
                tmp6.xyz = tmp4.xyz > float3(0.0, 0.0, 0.0);
                tmp4.xyz = tmp4.xyz < float3(0.0, 0.0, 0.0);
                tmp4.xyz = tmp4.xyz - tmp6.xyz;
                tmp4.xyz = floor(tmp4.xyz);
                tmp6.x = tmp4.y * inp.texcoord1.w;
                tmp6.y = inp.texcoord3.w;
                tmp1.yz = tmp6.xy * float2(0.25, 0.25);
                tmp6 = tex2D(_Sparkles, tmp1.yz);
                tmp0.z = tmp5.y * tmp6.x;
                tmp6.x = tmp4.x * inp.texcoord3.w;
                tmp4.x = -tmp4.z;
                tmp6.yw = inp.texcoord2.ww;
                tmp1.yz = tmp6.xy * float2(0.25, 0.25);
                tmp8 = tex2D(_Sparkles, tmp1.yz);
                tmp0.z = tmp8.x * tmp5.x + tmp0.z;
                tmp6.z = inp.texcoord1.w * 0.25;
                tmp4.y = 0.25;
                tmp1.yz = tmp4.xy * tmp6.zw;
                tmp4 = tex2D(_Sparkles, tmp1.yz);
                tmp0.z = tmp4.x * tmp5.z + tmp0.z;
                tmp3.xyz = tmp3.xyz * tmp0.zzz;
                tmp3.xyz = tmp3.xyz * float3(5.0, 5.0, 5.0);
                tmp0.z = log(tmp0.y);
                tmp0.y = max(tmp0.y, 0.01);
                tmp0.y = min(tmp0.y, 0.99);
                tmp0.z = tmp0.z * 0.02;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp0.z * -20.0 + tmp1.x;
                tmp0.z = tmp0.z + 20.0;
                tmp1.xyz = tmp0.zzz * tmp3.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.xxx + tmp2.xyz;
                tmp0.xz = inp.texcoord.xy * float2(3.0, 3.0);
                tmp0.x = dot(tmp0.xy, float2(0.3660254, 0.3660254));
                tmp0.xz = inp.texcoord.xy * float2(3.0, 3.0) + tmp0.xx;
                tmp0.xz = floor(tmp0.xz);
                tmp2.xy = tmp0.xz * float2(0.0034602, 0.0034602);
                tmp2.xy = floor(tmp2.xy);
                tmp2.xy = -tmp2.xy * float2(289.0, 289.0) + tmp0.xz;
                tmp3.xz = float2(0.0, 1.0);
                tmp2.zw = inp.texcoord.xy * float2(3.0, 3.0) + -tmp0.xz;
                tmp0.x = dot(tmp0.xy, float2(0.2113249, 0.2113249));
                tmp0.xz = tmp0.xx + tmp2.zw;
                tmp2.z = tmp0.z < tmp0.x;
                tmp4 = tmp2.zzzz ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp3.y = tmp4.y;
                tmp2.yzw = tmp2.yyy + tmp3.xyz;
                tmp3.xyz = tmp2.yzw * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp2.yzw = tmp2.yzw * tmp3.xyz;
                tmp3.xyz = tmp2.yzw * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp2.yzw = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp2.yzw;
                tmp2.xyz = tmp2.xxx + tmp2.yzw;
                tmp3.xz = float2(0.0, 1.0);
                tmp3.y = tmp4.x;
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp2.xyz = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp2.xyz = frac(tmp2.xyz);
                tmp3.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3.xyz = floor(tmp3.xyz);
                tmp3.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = abs(tmp2.xyz) - float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp2.xyz * tmp2.xyz;
                tmp5.xyz = tmp3.xyz * tmp3.xyz + tmp5.xyz;
                tmp5.xyz = -tmp5.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp6.x = dot(tmp0.xy, tmp0.xy);
                tmp8 = tmp0.xzxz + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp8.xy = tmp4.zw + tmp8.xy;
                tmp6.y = dot(tmp8.xy, tmp8.xy);
                tmp6.z = dot(tmp8.xy, tmp8.xy);
                tmp4.xyz = float3(0.5, 0.5, 0.5) - tmp6.xyz;
                tmp4.xyz = max(tmp4.xyz, float3(0.0, 0.0, 0.0));
                tmp4.xyz = tmp4.xyz * tmp4.xyz;
                tmp4.xyz = tmp4.xyz * tmp4.xyz;
                tmp4.xyz = tmp5.xyz * tmp4.xyz;
                tmp0.z = tmp0.z * tmp2.x;
                tmp2.xy = tmp2.yz * tmp8.yw;
                tmp2.yz = tmp3.yz * tmp8.xz + tmp2.xy;
                tmp2.x = tmp3.x * tmp0.x + tmp0.z;
                tmp0.x = dot(tmp4.xyz, tmp2.xyz);
                tmp0.x = tmp0.x * 130.0 + 1.0;
                tmp0.z = -tmp0.x * 0.5 + 1.0;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp2.x = tmp0.y - 0.5;
                tmp0.y = tmp0.y > 0.5;
                tmp2.x = -tmp2.x * 2.0 + 1.0;
                tmp0.z = -tmp2.x * tmp0.z + 1.0;
                tmp0.x = saturate(tmp0.y ? tmp0.z : tmp0.x);
                tmp0.y = 1.0 - tmp0.x;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.w > 0.5;
                tmp0.y = -tmp1.w * tmp0.y + 1.0;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.xy = tmp0.xx - float2(0.48, 0.5);
                tmp0.xy = saturate(tmp0.xy * float2(25.00001, 9.999998));
                tmp0.zw = tmp0.xy * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp2.xyz = -tmp0.xxx * tmp1.xyz + tmp7.xyz;
                tmp0.xzw = tmp1.xyz * tmp0.xxx;
                o.sv_target.xyz = saturate(tmp0.yyy * tmp2.xyz + tmp0.xzw);
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest+0" "RenderType" = "Opaque" }
			Blend One One, One One
			AlphaToMask On
			ZWrite Off
			GpuProgramID 117327
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
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float _Fade;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = dot(v.vertex.xyz, v.vertex.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.vertex.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = v.color.w * _Fade;
                tmp1.x = tmp0.w * tmp0.w;
                tmp0.w = -tmp0.w * tmp1.x + 1.0;
                tmp0.xyz = tmp0.xyz * tmp0.www + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp3.xyz = tmp1.xyz * tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx + -tmp3.xyz;
                tmp1.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.xyz = tmp1.www * tmp3.xyz;
                o.texcoord.y = tmp3.x;
                o.texcoord.x = tmp2.z;
                o.texcoord.z = tmp1.y;
                o.texcoord1.x = tmp2.x;
                o.texcoord2.x = tmp2.y;
                o.texcoord1.z = tmp1.z;
                o.texcoord2.z = tmp1.x;
                o.texcoord1.y = tmp3.y;
                o.texcoord2.y = tmp3.z;
                o.texcoord3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
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
                o.sv_target = float4(0.0, 0.0, 0.0, 1.0);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "Meta"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "META" "QUEUE" = "AlphaTest+0" "RenderType" = "Opaque" }
			Blend One Zero, SrcAlpha OneMinusSrcAlpha
			AlphaToMask On
			Cull Off
			GpuProgramID 165699
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _Fade;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float unity_MaxOutputValue;
			float unity_UseLinearSpace;
			// Custom ConstantBuffers for Vertex Shader
			CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaVertexControl;
			CBUFFER_END
			// Custom ConstantBuffers for Fragment Shader
			CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaFragmentControl;
			CBUFFER_END
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RefractionAlphaClip;
			sampler2D _MainTexture;
			sampler2D _Noise;
			sampler2D _Sparkles;
			sampler2D _Refraction;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = dot(v.vertex.xyz, v.vertex.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.vertex.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = v.color.w * _Fade;
                tmp1.x = tmp0.w * tmp0.w;
                tmp0.w = -tmp0.w * tmp1.x + 1.0;
                tmp0.xyz = tmp0.xyz * tmp0.www + v.vertex.xyz;
                tmp0.w = tmp0.z > 0.0;
                tmp1.z = tmp0.w ? 0.0001 : 0.0;
                tmp1.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp1.xyz = unity_MetaVertexControl.xxx ? tmp1.xyz : tmp0.xyz;
                tmp0.w = tmp1.z > 0.0;
                tmp2.z = tmp0.w ? 0.0001 : 0.0;
                tmp2.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                tmp1.xyz = unity_MetaVertexControl.yyy ? tmp2.xyz : tmp1.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = tmp1 + unity_MatrixVP._m03_m13_m23_m33;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp2.xyz = tmp0.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyw = unity_ObjectToWorld._m00_m10_m20 * tmp0.xxx + tmp2.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                o.texcoord1.w = tmp0.x;
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp4.xyz = tmp2.xyz * tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx + -tmp4.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord1.z = tmp2.y;
                o.texcoord2.w = tmp0.y;
                o.texcoord3.w = tmp0.z;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.z = tmp2.z;
                o.texcoord3.z = tmp2.x;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord4.zw = tmp1.zw;
                o.texcoord4.xy = tmp0.zz + tmp0.xw;
                o.color = v.color;
                return o;
			}
			// Keywords: 
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
                tmp0.xz = float2(0.0, 1.0);
                tmp1.xy = _WorldSpaceCameraPos.xy - unity_ObjectToWorld._m03_m13;
                tmp1.xy = inp.texcoord.xy * float2(10.0, 10.0) + tmp1.xy;
                tmp0.w = dot(tmp1.xy, float2(0.3660254, 0.3660254));
                tmp1.zw = tmp0.ww + tmp1.xy;
                tmp1.zw = floor(tmp1.zw);
                tmp2.xy = tmp1.zw * float2(0.0034602, 0.0034602);
                tmp2.xy = floor(tmp2.xy);
                tmp2.xy = -tmp2.xy * float2(289.0, 289.0) + tmp1.zw;
                tmp1.xy = tmp1.xy - tmp1.zw;
                tmp0.w = dot(tmp1.xy, float2(0.2113249, 0.2113249));
                tmp1.xy = tmp0.ww + tmp1.xy;
                tmp0.w = tmp1.y < tmp1.x;
                tmp3 = tmp0.wwww ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp0.y = tmp3.y;
                tmp0.xyz = tmp0.xyz + tmp2.yyy;
                tmp2.yzw = tmp0.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.yzw;
                tmp2.yzw = tmp0.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp2.yzw = floor(tmp2.yzw);
                tmp0.xyz = -tmp2.yzw * float3(289.0, 289.0, 289.0) + tmp0.xyz;
                tmp0.xyz = tmp2.xxx + tmp0.xyz;
                tmp2.xz = float2(0.0, 1.0);
                tmp2.y = tmp3.x;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp2.xyz = tmp0.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp0.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp2.xyz = floor(tmp2.xyz);
                tmp0.xyz = -tmp2.xyz * float3(289.0, 289.0, 289.0) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp0.xyz = frac(tmp0.xyz);
                tmp2.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp0.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.xyz = floor(tmp2.xyz);
                tmp2.xyz = tmp0.xyz - tmp2.xyz;
                tmp0.xyz = abs(tmp0.xyz) - float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp0.xyz * tmp0.xyz;
                tmp4.xyz = tmp2.xyz * tmp2.xyz + tmp4.xyz;
                tmp4.xyz = -tmp4.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp5.x = dot(tmp1.xy, tmp1.xy);
                tmp6 = tmp1.xyxy + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp6.xy = tmp3.zw + tmp6.xy;
                tmp5.y = dot(tmp6.xy, tmp6.xy);
                tmp5.z = dot(tmp6.xy, tmp6.xy);
                tmp3.xyz = float3(0.5, 0.5, 0.5) - tmp5.xyz;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp3.xyz = tmp3.xyz * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * tmp3.xyz;
                tmp3.xyz = tmp4.xyz * tmp3.xyz;
                tmp0.x = tmp1.y * tmp0.x;
                tmp0.yz = tmp0.yz * tmp6.yw;
                tmp4.yz = tmp2.yz * tmp6.xz + tmp0.yz;
                tmp4.x = tmp2.x * tmp1.x + tmp0.x;
                tmp0.x = dot(tmp3.xyz, tmp4.xyz);
                tmp0.x = saturate(tmp0.x * 130.0);
                tmp1.x = inp.texcoord1.w;
                tmp1.y = inp.texcoord2.w;
                tmp1.z = inp.texcoord3.w;
                tmp0.yzw = _WorldSpaceCameraPos - tmp1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.yzw = tmp0.yzw * tmp1.xxx + float3(0.0, 0.5, 0.0);
                tmp2.x = dot(tmp1.xyz, tmp1.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp1.yzw = tmp1.yzw * tmp2.xxx;
                tmp2.xyz = inp.texcoord2.zzz * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = unity_WorldToObject._m00_m10_m20 * inp.texcoord1.zzz + tmp2.xyz;
                tmp2.xyz = unity_WorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp2.xyz;
                tmp1.y = dot(tmp2.xyz, tmp1.xyz);
                tmp1.y = tmp1.y + 1.0;
                tmp1.y = tmp1.y * 0.5;
                tmp1.y = log(tmp1.y);
                tmp1.y = tmp1.y * 300.0;
                tmp1.y = exp(tmp1.y);
                tmp3.xyz = tmp0.yzw * tmp1.xxx + float3(0.0, -0.5, 0.0);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.x = dot(tmp3.xyz, tmp3.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xzw = tmp1.xxx * tmp3.xyz;
                tmp1.x = dot(tmp2.xyz, tmp1.xyz);
                tmp1.x = tmp1.x + 1.0;
                tmp1.x = tmp1.x * 0.5;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * 300.0;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.x + tmp1.y;
                tmp2.xz = float2(0.0, 1.0);
                tmp3.xz = float2(0.0, 1.0);
                tmp1.yz = _Time.yy * float2(-0.05, -0.5) + inp.texcoord.xy;
                tmp4.x = inp.texcoord1.z;
                tmp4.y = inp.texcoord2.z;
                tmp4.z = inp.texcoord3.z;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp5.xy = tmp1.ww * tmp4.xz;
                tmp2.w = tmp5.y + tmp5.x;
                tmp3.w = _Time.y * -0.25 + tmp5.x;
                tmp5.x = sin(tmp3.w);
                tmp6.x = cos(tmp3.w);
                tmp1.yz = tmp1.yz + tmp2.ww;
                tmp2.w = dot(tmp1.xy, float2(0.3660254, 0.3660254));
                tmp5.yz = tmp1.yz + tmp2.ww;
                tmp5.yz = floor(tmp5.yz);
                tmp1.yz = tmp1.yz - tmp5.yz;
                tmp2.w = dot(tmp5.xy, float2(0.2113249, 0.2113249));
                tmp1.yz = tmp1.yz + tmp2.ww;
                tmp2.w = tmp1.z < tmp1.y;
                tmp7 = tmp2.wwww ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp3.y = tmp7.y;
                tmp6.yz = tmp5.yz * float2(0.0034602, 0.0034602);
                tmp6.yz = floor(tmp6.yz);
                tmp5.yz = -tmp6.yz * float2(289.0, 289.0) + tmp5.yz;
                tmp3.xyz = tmp3.xyz + tmp5.zzz;
                tmp6.yzw = tmp3.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp3.xyz * tmp6.yzw;
                tmp6.yzw = tmp3.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp6.yzw = floor(tmp6.yzw);
                tmp3.xyz = -tmp6.yzw * float3(289.0, 289.0, 289.0) + tmp3.xyz;
                tmp3.xyz = tmp5.yyy + tmp3.xyz;
                tmp2.y = tmp7.x;
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp2.xyz = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp2.xyz = frac(tmp2.xyz);
                tmp3.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3.xyz = floor(tmp3.xyz);
                tmp3.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = abs(tmp2.xyz) - float3(0.5, 0.5, 0.5);
                tmp5.yzw = tmp2.xyz * tmp2.xyz;
                tmp5.yzw = tmp3.xyz * tmp3.xyz + tmp5.yzw;
                tmp5.yzw = -tmp5.yzw * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp8 = tmp1.yzyz + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp8.xy = tmp7.zw + tmp8.xy;
                tmp7.y = dot(tmp8.xy, tmp8.xy);
                tmp7.x = dot(tmp1.xy, tmp1.xy);
                tmp7.z = dot(tmp8.xy, tmp8.xy);
                tmp6.yzw = float3(0.5, 0.5, 0.5) - tmp7.xyz;
                tmp6.yzw = max(tmp6.yzw, float3(0.0, 0.0, 0.0));
                tmp6.yzw = tmp6.yzw * tmp6.yzw;
                tmp6.yzw = tmp6.yzw * tmp6.yzw;
                tmp5.yzw = tmp5.yzw * tmp6.yzw;
                tmp1.z = tmp1.z * tmp2.x;
                tmp2.xy = tmp2.yz * tmp8.yw;
                tmp2.yz = tmp3.yz * tmp8.xz + tmp2.xy;
                tmp2.x = tmp3.x * tmp1.y + tmp1.z;
                tmp1.y = dot(tmp5.xyz, tmp2.xyz);
                tmp2.xy = inp.texcoord2.zz * unity_MatrixV._m01_m11;
                tmp2.xy = unity_MatrixV._m00_m10 * inp.texcoord1.zz + tmp2.xy;
                tmp2.xy = unity_MatrixV._m02_m12 * inp.texcoord3.zz + tmp2.xy;
                tmp2.zw = tmp2.xy * float2(0.5, 0.5);
                tmp2.xy = tmp2.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp3.z = tmp5.x;
                tmp3.y = tmp6.x;
                tmp3.x = -tmp5.x;
                tmp5.y = dot(tmp2.xy, tmp3.xy);
                tmp5.x = dot(tmp2.xy, tmp3.xy);
                tmp3.xy = tmp5.xy + float2(0.5, 0.5);
                tmp3.xy = tmp1.yy * float2(3.9, 3.9) + tmp3.xy;
                tmp3 = tex2D(_MainTexture, tmp3.xy);
                tmp3.xy = _Time.yy * float2(0.3, 0.2);
                tmp1.z = tmp4.z * tmp1.w + tmp3.x;
                tmp1.w = sin(tmp3.y);
                tmp1.w = tmp1.w + 1.0;
                tmp1.w = tmp1.w * 1.5 + -1.0;
                tmp1.xw = min(tmp1.xw, float2(1.0, 1.0));
                tmp5.x = abs(tmp1.w);
                tmp3.x = sin(tmp1.z);
                tmp6.x = cos(tmp1.z);
                tmp7.z = tmp3.x;
                tmp7.y = tmp6.x;
                tmp7.x = -tmp3.x;
                tmp3.y = dot(tmp2.xy, tmp7.xy);
                tmp3.x = dot(tmp2.xy, tmp7.xy);
                tmp1.zw = tmp3.xy + float2(0.5, 0.5);
                tmp1.zw = tmp1.yy * float2(3.9, 3.9) + tmp1.zw;
                tmp6 = tex2D(_MainTexture, tmp1.zw);
                tmp1.z = dot(tmp3.xy, tmp6.xy);
                tmp1.w = 1.0 - tmp3.z;
                tmp2.zw = tmp6.wz - float2(0.03, 0.5);
                tmp3.x = tmp6.z > 0.5;
                tmp2.w = -tmp2.w * 2.0 + 1.0;
                tmp2.z = saturate(tmp2.z * 1.030928);
                tmp1.w = -tmp2.w * tmp1.w + 1.0;
                tmp1.z = saturate(tmp3.x ? tmp1.w : tmp1.z);
                tmp1.w = 1.0 - tmp1.z;
                tmp0.y = dot(tmp4.xyz, tmp0.xyz);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.w = -tmp0.y * tmp0.z + 1.0;
                tmp0.z = tmp0.z * tmp0.y;
                tmp0.z = tmp0.z * 0.5 + 0.5;
                tmp0.w = -tmp0.w * tmp1.w + 1.0;
                tmp1.z = dot(tmp1.xy, tmp0.xy);
                tmp0.z = tmp0.z > 0.5;
                tmp0.z = saturate(tmp0.z ? tmp0.w : tmp1.z);
                tmp0.w = inp.color.w * _Fade;
                tmp1.z = tmp0.w * tmp0.w;
                tmp1.w = tmp0.w * tmp1.z + -0.5;
                tmp0.w = tmp0.w * tmp1.z;
                tmp1.z = tmp1.w * -1.9 + 1.0;
                tmp1.w = -tmp1.w * 2.0 + 1.0;
                tmp1.z = max(tmp1.z, 0.0);
                tmp1.z = min(tmp1.z, 0.25);
                tmp1.z = tmp1.z * tmp2.z;
                tmp2.z = tmp2.z * 0.5;
                tmp0.z = tmp0.z * 0.75 + tmp1.z;
                tmp0.z = tmp1.x + tmp0.z;
                tmp3.xy = _Time.yy * float2(0.2, 0.2) + float2(1.0, 2.0);
                tmp3.xy = sin(tmp3.xy);
                tmp3.xy = tmp3.xy + float2(1.0, 1.0);
                tmp3.xy = tmp3.xy * float2(1.5, 1.5) + float2(-1.0, -1.0);
                tmp3.xy = min(tmp3.xy, float2(1.0, 1.0));
                tmp5.yz = abs(tmp3.xy);
                tmp1.z = dot(tmp5.xyz, float3(0.299, 0.587, 0.114));
                tmp3.xyz = tmp1.zzz - tmp5.xyz;
                tmp3.xyz = tmp3.xyz * float3(0.5, 0.5, 0.5) + tmp5.xyz;
                tmp5.xy = _Time.yy * float2(0.01, -0.05) + tmp2.xy;
                tmp2.xy = _Time.yy * float2(-0.005, 0.025) + -tmp2.xy;
                tmp2.xy = tmp2.xy * float2(0.5, 0.5);
                tmp6 = tex2D(_Noise, tmp2.xy);
                tmp5 = tex2D(_Noise, tmp5.xy);
                tmp2.xyw = tmp5.xyz - tmp6.xyz;
                tmp2.xyz = tmp2.zzz * tmp2.xyw + tmp6.xyz;
                tmp5.xyz = tmp3.xyz - tmp2.xyz;
                tmp1.z = saturate(inp.texcoord2.z);
                tmp2.xyz = tmp1.zzz * tmp5.xyz + tmp2.xyz;
                tmp1.z = dot(tmp2.xyz, float3(0.299, 0.587, 0.114));
                tmp5.xyz = tmp1.zzz - tmp2.xyz;
                tmp5.xyz = tmp5.xyz * float3(0.333, 0.333, 0.333) + tmp2.xyz;
                tmp5.xyz = tmp0.zzz + tmp5.xyz;
                tmp1.z = inp.texcoord4.w + 0.0;
                tmp2.w = tmp1.z * 0.5;
                tmp3.w = -tmp1.z * 0.5 + inp.texcoord4.y;
                tmp6.y = -tmp3.w * _ProjectionParams.x + tmp2.w;
                tmp6.x = inp.texcoord4.x;
                tmp6.xy = tmp6.xy / tmp1.zz;
                tmp6.zw = tmp1.yy * float2(3.9, 3.9) + tmp6.xy;
                tmp1.y = tmp1.y * 3.9 + 0.03;
                tmp1.y = tmp1.y * 11.66667 + 0.3;
                tmp7 = tex2D(_Refraction, tmp6.xy);
                tmp6.xy = tmp6.zw * float2(0.8, 0.8) + float2(0.1, 0.1);
                tmp6 = tex2D(_RefractionAlphaClip, tmp6.xy);
                tmp2.xyz = tmp2.xyz * float3(0.25, 0.25, 0.25) + tmp6.xyz;
                tmp1.z = 1.0 - tmp0.y;
                tmp2.w = tmp1.z * tmp1.z;
                tmp2.w = tmp2.w * tmp2.w;
                tmp1.z = saturate(tmp1.z * tmp2.w);
                tmp6.xyz = tmp1.zzz * tmp3.xyz;
                tmp1.z = -tmp1.z * tmp1.y + 1.0;
                tmp6.xyz = tmp1.yyy * tmp6.xyz;
                tmp2.xyz = tmp2.xyz * tmp1.zzz + tmp6.xyz;
                tmp2.xyz = tmp0.zzz * tmp5.xyz + tmp2.xyz;
                tmp5.xyz = abs(tmp4.xyz) * abs(tmp4.xyz);
                tmp5.xyz = tmp5.xyz * tmp5.xyz;
                tmp5.xyw = abs(tmp4.xyz) * tmp5.xyz;
                tmp0.z = tmp5.y + tmp5.x;
                tmp0.z = abs(tmp4.z) * tmp5.z + tmp0.z;
                tmp5.xyz = tmp5.xyw / tmp0.zzz;
                tmp6.xyz = tmp4.xyz > float3(0.0, 0.0, 0.0);
                tmp4.xyz = tmp4.xyz < float3(0.0, 0.0, 0.0);
                tmp4.xyz = tmp4.xyz - tmp6.xyz;
                tmp4.xyz = floor(tmp4.xyz);
                tmp6.x = tmp4.y * inp.texcoord1.w;
                tmp6.y = inp.texcoord3.w;
                tmp1.yz = tmp6.xy * float2(0.25, 0.25);
                tmp6 = tex2D(_Sparkles, tmp1.yz);
                tmp0.z = tmp5.y * tmp6.x;
                tmp6.x = tmp4.x * inp.texcoord3.w;
                tmp4.x = -tmp4.z;
                tmp6.yw = inp.texcoord2.ww;
                tmp1.yz = tmp6.xy * float2(0.25, 0.25);
                tmp8 = tex2D(_Sparkles, tmp1.yz);
                tmp0.z = tmp8.x * tmp5.x + tmp0.z;
                tmp6.z = inp.texcoord1.w * 0.25;
                tmp4.y = 0.25;
                tmp1.yz = tmp4.xy * tmp6.zw;
                tmp4 = tex2D(_Sparkles, tmp1.yz);
                tmp0.z = tmp4.x * tmp5.z + tmp0.z;
                tmp3.xyz = tmp3.xyz * tmp0.zzz;
                tmp3.xyz = tmp3.xyz * float3(5.0, 5.0, 5.0);
                tmp0.z = log(tmp0.y);
                tmp0.y = max(tmp0.y, 0.01);
                tmp0.y = min(tmp0.y, 0.99);
                tmp0.z = tmp0.z * 0.02;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp0.z * -20.0 + tmp1.x;
                tmp0.z = tmp0.z + 20.0;
                tmp1.xyz = tmp0.zzz * tmp3.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.xxx + tmp2.xyz;
                tmp0.xz = inp.texcoord.xy * float2(3.0, 3.0);
                tmp0.x = dot(tmp0.xy, float2(0.3660254, 0.3660254));
                tmp0.xz = inp.texcoord.xy * float2(3.0, 3.0) + tmp0.xx;
                tmp0.xz = floor(tmp0.xz);
                tmp2.xy = tmp0.xz * float2(0.0034602, 0.0034602);
                tmp2.xy = floor(tmp2.xy);
                tmp2.xy = -tmp2.xy * float2(289.0, 289.0) + tmp0.xz;
                tmp3.xz = float2(0.0, 1.0);
                tmp2.zw = inp.texcoord.xy * float2(3.0, 3.0) + -tmp0.xz;
                tmp0.x = dot(tmp0.xy, float2(0.2113249, 0.2113249));
                tmp0.xz = tmp0.xx + tmp2.zw;
                tmp2.z = tmp0.z < tmp0.x;
                tmp4 = tmp2.zzzz ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp3.y = tmp4.y;
                tmp2.yzw = tmp2.yyy + tmp3.xyz;
                tmp3.xyz = tmp2.yzw * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp2.yzw = tmp2.yzw * tmp3.xyz;
                tmp3.xyz = tmp2.yzw * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp2.yzw = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp2.yzw;
                tmp2.xyz = tmp2.xxx + tmp2.yzw;
                tmp3.xz = float2(0.0, 1.0);
                tmp3.y = tmp4.x;
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp2.xyz = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp2.xyz = frac(tmp2.xyz);
                tmp3.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3.xyz = floor(tmp3.xyz);
                tmp3.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = abs(tmp2.xyz) - float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp2.xyz * tmp2.xyz;
                tmp5.xyz = tmp3.xyz * tmp3.xyz + tmp5.xyz;
                tmp5.xyz = -tmp5.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp6.x = dot(tmp0.xy, tmp0.xy);
                tmp8 = tmp0.xzxz + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp8.xy = tmp4.zw + tmp8.xy;
                tmp6.y = dot(tmp8.xy, tmp8.xy);
                tmp6.z = dot(tmp8.xy, tmp8.xy);
                tmp4.xyz = float3(0.5, 0.5, 0.5) - tmp6.xyz;
                tmp4.xyz = max(tmp4.xyz, float3(0.0, 0.0, 0.0));
                tmp4.xyz = tmp4.xyz * tmp4.xyz;
                tmp4.xyz = tmp4.xyz * tmp4.xyz;
                tmp4.xyz = tmp5.xyz * tmp4.xyz;
                tmp0.z = tmp0.z * tmp2.x;
                tmp2.xy = tmp2.yz * tmp8.yw;
                tmp2.yz = tmp3.yz * tmp8.xz + tmp2.xy;
                tmp2.x = tmp3.x * tmp0.x + tmp0.z;
                tmp0.x = dot(tmp4.xyz, tmp2.xyz);
                tmp0.x = tmp0.x * 130.0 + 1.0;
                tmp0.z = -tmp0.x * 0.5 + 1.0;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp2.x = tmp0.y - 0.5;
                tmp0.y = tmp0.y > 0.5;
                tmp2.x = -tmp2.x * 2.0 + 1.0;
                tmp0.z = -tmp2.x * tmp0.z + 1.0;
                tmp0.x = saturate(tmp0.y ? tmp0.z : tmp0.x);
                tmp0.y = 1.0 - tmp0.x;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.w > 0.5;
                tmp0.y = -tmp1.w * tmp0.y + 1.0;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.xy = tmp0.xx - float2(0.48, 0.5);
                tmp0.xy = saturate(tmp0.xy * float2(25.00001, 9.999998));
                tmp0.zw = tmp0.xy * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp2.xyz = -tmp0.xxx * tmp1.xyz + tmp7.xyz;
                tmp0.xzw = tmp1.xyz * tmp0.xxx;
                tmp0.xyz = saturate(tmp0.yyy * tmp2.xyz + tmp0.xzw);
                tmp1.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp1.xyz = tmp0.xyz * tmp1.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.w = unity_UseLinearSpace != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp1.xyz = min(unity_MaxOutputValue.xxx, float3(0.0, 0.0, 0.0));
                tmp1.w = 1.0;
                tmp1 = unity_MetaFragmentControl ? tmp1 : float4(0.0, 0.0, 0.0, 0.0);
                tmp0.w = 1.0;
                o.sv_target = unity_MetaFragmentControl ? tmp0 : tmp1;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest+0" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One Zero, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 202381
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _Fade;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH UNITY_PASS_SHADOWCASTER
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = dot(v.vertex.xyz, v.vertex.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * v.vertex.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = v.color.w * _Fade;
                tmp1.x = tmp0.w * tmp0.w;
                tmp0.w = -tmp0.w * tmp1.x + 1.0;
                tmp0.xyz = tmp0.xyz * tmp0.www + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                tmp2.xyz = -tmp1.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp3.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp0.w = dot(tmp3.xyz, tmp2.xyz);
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = tmp0.w * unity_LightShadowBias.z;
                tmp2.xyz = -tmp3.xyz * tmp0.www + tmp1.xyz;
                tmp0.w = unity_LightShadowBias.z != 0.0;
                tmp1.xyz = tmp0.www ? tmp2.xyz : tmp1.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                tmp0.w = unity_LightShadowBias.x / tmp1.w;
                tmp0.w = min(tmp0.w, 0.0);
                tmp0.w = max(tmp0.w, -1.0);
                tmp0.w = tmp0.w + tmp1.z;
                tmp2.x = min(tmp1.w, tmp0.w);
                tmp2.x = tmp2.x - tmp0.w;
                tmp1.z = unity_LightShadowBias.y * tmp2.x + tmp0.w;
                o.position = tmp1;
                o.texcoord2.zw = tmp1.zw;
                o.texcoord1.xy = v.texcoord.xy;
                tmp0.w = tmp1.y * _ProjectionParams.x;
                tmp1.xz = tmp1.xw * float2(0.5, 0.5);
                tmp1.w = tmp0.w * 0.5;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                tmp1.xyz = tmp0.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyw = unity_ObjectToWorld._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                o.texcoord3.w = tmp0.x;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp1.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp1.xyz;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp2.xyz = tmp1.xyz * tmp3.zxy;
                tmp2.xyz = tmp3.yzx * tmp1.yzx + -tmp2.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                o.texcoord3.y = tmp2.x;
                o.texcoord3.z = tmp3.x;
                o.texcoord3.x = tmp1.z;
                o.texcoord4.w = tmp0.y;
                o.texcoord5.w = tmp0.z;
                o.texcoord4.x = tmp1.x;
                o.texcoord5.x = tmp1.y;
                o.texcoord4.z = tmp3.y;
                o.texcoord5.z = tmp3.z;
                o.texcoord4.y = tmp2.y;
                o.texcoord5.y = tmp2.z;
                o.color = v.color;
                return o;
			}
			// Keywords: SHADOWS_DEPTH UNITY_PASS_SHADOWCASTER
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
	CustomEditor "ASEMaterialInspector"
}