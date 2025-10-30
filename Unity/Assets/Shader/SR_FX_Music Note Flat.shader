Shader "SR/FX/Music Note Flat" {
	Properties {
		_Noise ("Noise", 2D) = "black" {}
		_Cutoff ("Mask Clip Value", Float) = 0.5
		_Color ("Color", Color) = (0.04460192,0,1,0)
		_MainTexture ("Main Texture", 2D) = "black" {}
		_Normalintensity ("Normal intensity", Float) = -0.02
		[IntRange] _Rune ("Rune", Range(0, 8)) = 0
		[Toggle] _Sharp ("Sharp", Float) = 0
		_Fade ("Fade", Range(0, 1)) = 1
		_StartTime ("StartTime", Float) = 0
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "DisableBatching" = "true" "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Overlay+0" "RenderType" = "Overlay" }
		GrabPass {
			"_RefractionOverlay"
		}
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay+0" "RenderType" = "Overlay" }
			Blend One OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 62331
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _Fade;
			float4 _Color;
			float _StartTime;
			float4 _MainTexture_ST;
			float _Rune;
			float _Sharp;
			float4 _Noise_ST;
			float _Normalintensity;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTexture;
			sampler2D _RefractionOverlay;
			sampler2D _Noise;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.zw = tmp0.zw;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
                o.color = v.color;
                o.texcoord4.xyz = float3(0.0, 0.0, 0.0);
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
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                tmp0.xy = inp.texcoord.xy * float2(3.0, 3.0);
                tmp0.x = dot(tmp0.xy, float2(0.3660254, 0.3660254));
                tmp0.xy = inp.texcoord.xy * float2(3.0, 3.0) + tmp0.xx;
                tmp0.xy = floor(tmp0.xy);
                tmp0.zw = tmp0.xy * float2(0.0034602, 0.0034602);
                tmp0.zw = floor(tmp0.zw);
                tmp0.zw = -tmp0.zw * float2(289.0, 289.0) + tmp0.xy;
                tmp1.xz = float2(0.0, 1.0);
                tmp2.xy = inp.texcoord.xy * float2(3.0, 3.0) + -tmp0.xy;
                tmp0.x = dot(tmp0.xy, float2(0.2113249, 0.2113249));
                tmp0.xy = tmp0.xx + tmp2.xy;
                tmp1.w = tmp0.y < tmp0.x;
                tmp2 = tmp1.wwww ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp1.y = tmp2.y;
                tmp1.xyz = tmp0.www + tmp1.xyz;
                tmp3.xyz = tmp1.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp3.xyz = tmp1.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp1.xyz = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp1.xyz;
                tmp1.xyz = tmp0.zzz + tmp1.xyz;
                tmp3.xz = float2(0.0, 1.0);
                tmp3.y = tmp2.x;
                tmp1.xyz = tmp1.xyz + tmp3.xyz;
                tmp3.xyz = tmp1.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp3.xyz = tmp1.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp1.xyz = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp1.xyz = frac(tmp1.xyz);
                tmp3.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3.xyz = floor(tmp3.xyz);
                tmp3.xyz = tmp1.xyz - tmp3.xyz;
                tmp1.xyz = abs(tmp1.xyz) - float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp1.xyz * tmp1.xyz;
                tmp4.xyz = tmp3.xyz * tmp3.xyz + tmp4.xyz;
                tmp4.xyz = -tmp4.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp5.x = dot(tmp0.xy, tmp0.xy);
                tmp6 = tmp0.xyxy + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp6.xy = tmp2.zw + tmp6.xy;
                tmp5.y = dot(tmp6.xy, tmp6.xy);
                tmp5.z = dot(tmp6.xy, tmp6.xy);
                tmp2.xyz = float3(0.5, 0.5, 0.5) - tmp5.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp2.xyz = tmp4.xyz * tmp2.xyz;
                tmp0.y = tmp0.y * tmp1.x;
                tmp0.zw = tmp1.yz * tmp6.yw;
                tmp1.yz = tmp3.yz * tmp6.xz + tmp0.zw;
                tmp1.x = tmp3.x * tmp0.x + tmp0.y;
                tmp0.x = dot(tmp2.xyz, tmp1.xyz);
                tmp0.x = tmp0.x * 130.0 + 1.0;
                tmp0.y = -tmp0.x * 0.5 + 1.0;
                tmp0.x = tmp0.x * 0.5;
                tmp0.zw = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.zw = tmp0.zw * tmp0.zw;
                tmp0.z = tmp0.w + tmp0.z;
                tmp0.w = max(tmp0.z, 0.01);
                tmp0.z = 1.0 - tmp0.z;
                tmp0.w = min(tmp0.w, 0.99);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = -tmp1.x * 2.0 + 1.0;
                tmp0.y = -tmp1.x * tmp0.y + 1.0;
                tmp1.x = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w > 0.5;
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.x = saturate(tmp0.w ? tmp0.y : tmp0.x);
                tmp0.y = 1.0 - tmp0.x;
                tmp0.w = inp.color.w * _Fade;
                tmp1.x = tmp0.w * tmp0.w;
                tmp1.yz = tmp0.ww * tmp1.xx + float2(-0.8, -0.5);
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = -tmp1.z * 2.0 + 1.0;
                tmp1.yz = tmp1.yz * float2(-5.0, -1.9) + float2(1.0, 1.0);
                tmp0.y = -tmp1.x * tmp0.y + 1.0;
                tmp1.x = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w > 0.5;
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.x = saturate(tmp0.w ? tmp0.y : tmp0.x);
                tmp0.x = tmp0.x - 0.48;
                tmp0.x = saturate(tmp0.x * 25.00001);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = _Time.y - _StartTime;
                tmp0.y = tmp0.y * -2.0 + 0.1;
                tmp0.y = min(abs(tmp0.y), 1.0);
                tmp1.xw = float2(1.0, 2.0) - tmp0.yy;
                tmp0.y = tmp0.y * 4.8 + 0.2;
                tmp0.w = tmp1.w * _Time.y;
                tmp2.xy = tmp0.ww * float2(-0.05, -0.5) + inp.texcoord.xy;
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.zw = tmp0.ww * inp.texcoord1.zx;
                tmp3.xy = inp.texcoord1.xz * tmp0.ww + float2(1.0, 1.0);
                tmp3.xy = tmp3.xy * float2(0.5, 0.5);
                tmp0.w = tmp2.z + tmp2.w;
                tmp2.zw = _Time.yy * float2(0.3, -0.25) + tmp2.zw;
                tmp2.xy = tmp0.ww + tmp2.xy;
                tmp0.w = dot(tmp2.xy, float2(0.3660254, 0.3660254));
                tmp3.zw = tmp0.ww + tmp2.xy;
                tmp3.zw = floor(tmp3.zw);
                tmp4.xy = tmp3.zw * float2(0.0034602, 0.0034602);
                tmp4.xy = floor(tmp4.xy);
                tmp4.xy = -tmp4.xy * float2(289.0, 289.0) + tmp3.zw;
                tmp5.xz = float2(0.0, 1.0);
                tmp2.xy = tmp2.xy - tmp3.zw;
                tmp0.w = dot(tmp3.xy, float2(0.2113249, 0.2113249));
                tmp2.xy = tmp0.ww + tmp2.xy;
                tmp0.w = tmp2.y < tmp2.x;
                tmp6 = tmp0.wwww ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp5.y = tmp6.y;
                tmp4.yzw = tmp4.yyy + tmp5.xyz;
                tmp5.xyz = tmp4.yzw * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp4.yzw = tmp4.yzw * tmp5.xyz;
                tmp5.xyz = tmp4.yzw * float3(0.0034602, 0.0034602, 0.0034602);
                tmp5.xyz = floor(tmp5.xyz);
                tmp4.yzw = -tmp5.xyz * float3(289.0, 289.0, 289.0) + tmp4.yzw;
                tmp4.xyz = tmp4.xxx + tmp4.yzw;
                tmp5.xz = float2(0.0, 1.0);
                tmp5.y = tmp6.x;
                tmp4.xyz = tmp4.xyz + tmp5.xyz;
                tmp5.xyz = tmp4.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp4.xyz * tmp5.xyz;
                tmp5.xyz = tmp4.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp5.xyz = floor(tmp5.xyz);
                tmp4.xyz = -tmp5.xyz * float3(289.0, 289.0, 289.0) + tmp4.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp4.xyz = frac(tmp4.xyz);
                tmp5.xyz = tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp4.xyz = tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp5.xyz = floor(tmp5.xyz);
                tmp5.xyz = tmp4.xyz - tmp5.xyz;
                tmp4.xyz = abs(tmp4.xyz) - float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp4.xyz * tmp4.xyz;
                tmp7.xyz = tmp5.xyz * tmp5.xyz + tmp7.xyz;
                tmp7.xyz = -tmp7.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp8.x = dot(tmp2.xy, tmp2.xy);
                tmp9 = tmp2.xyxy + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp8.z = dot(tmp9.xy, tmp9.xy);
                tmp9.xy = tmp6.zw + tmp9.xy;
                tmp8.y = dot(tmp9.xy, tmp9.xy);
                tmp6.xyz = float3(0.5, 0.5, 0.5) - tmp8.xyz;
                tmp6.xyz = max(tmp6.xyz, float3(0.0, 0.0, 0.0));
                tmp6.xyz = tmp6.xyz * tmp6.xyz;
                tmp6.xyz = tmp6.xyz * tmp6.xyz;
                tmp6.xyz = tmp7.xyz * tmp6.xyz;
                tmp0.w = tmp2.y * tmp4.x;
                tmp3.zw = tmp4.yz * tmp9.yw;
                tmp4.yz = tmp5.yz * tmp9.xz + tmp3.zw;
                tmp4.x = tmp5.x * tmp2.x + tmp0.w;
                tmp0.w = dot(tmp6.xyz, tmp4.xyz);
                tmp2.x = sin(tmp2.w);
                tmp4.x = cos(tmp2.w);
                tmp5.x = sin(tmp2.z);
                tmp6.x = cos(tmp2.z);
                tmp7.z = tmp2.x;
                tmp7.y = tmp4.x;
                tmp7.x = -tmp2.x;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp4.x = dot(tmp2.xy, tmp7.xy);
                tmp4.y = dot(tmp2.xy, tmp7.xy);
                tmp2.zw = tmp4.xy + float2(0.5, 0.5);
                tmp2.zw = saturate(tmp0.ww * float2(3.9, 3.9) + tmp2.zw);
                tmp4 = tex2D(_MainTexture, tmp2.zw);
                tmp7.z = tmp5.x;
                tmp7.y = tmp6.x;
                tmp7.x = -tmp5.x;
                tmp4.y = dot(tmp2.xy, tmp7.xy);
                tmp4.x = dot(tmp2.xy, tmp7.xy);
                tmp2.xy = tmp4.xy + float2(0.5, 0.5);
                tmp2.xy = saturate(tmp0.ww * float2(3.9, 3.9) + tmp2.xy);
                tmp2 = tex2D(_MainTexture, tmp2.xy);
                tmp1.w = tmp2.z + tmp2.z;
                tmp1.w = tmp4.z * tmp1.w;
                tmp2.x = 1.0 - tmp4.z;
                tmp2.yw = tmp2.wz - float2(0.03, 0.5);
                tmp2.z = tmp2.z > 0.5;
                tmp2.w = -tmp2.w * 2.0 + 1.0;
                tmp2.y = saturate(tmp2.y * 1.030928);
                tmp2.x = -tmp2.w * tmp2.x + 1.0;
                tmp1.w = saturate(tmp2.z ? tmp2.x : tmp1.w);
                tmp2.x = tmp2.y + tmp1.w;
                tmp2.x = tmp0.x * tmp2.x;
                tmp2.z = tmp2.x * 10.0 + -_Cutoff;
                o.sv_target.w = tmp2.x;
                tmp2.x = tmp2.z < 0.0;
                if (tmp2.x) {
                    discard;
                }
                tmp2.x = _Rune * 0.1111111;
                tmp2.z = tmp2.x >= -tmp2.x;
                tmp2.x = frac(abs(tmp2.x));
                tmp2.x = tmp2.z ? tmp2.x : -tmp2.x;
                tmp2.x = tmp2.x * 9.0;
                tmp2.x = round(tmp2.x);
                tmp2.z = tmp2.x < 0.0;
                tmp2.z = tmp2.z ? 9.0 : 0.0;
                tmp2.x = tmp2.z + tmp2.x;
                tmp2.z = tmp2.x * 0.3333333;
                tmp2.w = tmp2.z >= -tmp2.z;
                tmp2.z = frac(abs(tmp2.z));
                tmp2.z = tmp2.w ? tmp2.z : -tmp2.z;
                tmp2.z = tmp2.z * 3.0;
                tmp2.z = round(tmp2.z);
                tmp2.x = tmp2.x - tmp2.z;
                tmp4.x = tmp2.z * 0.3333333;
                tmp2.x = tmp2.x * 0.1111111;
                tmp2.z = tmp2.x >= -tmp2.x;
                tmp2.x = frac(abs(tmp2.x));
                tmp2.x = tmp2.z ? tmp2.x : -tmp2.x;
                tmp2.x = tmp2.x * 3.0;
                tmp2.x = round(tmp2.x);
                tmp2.x = 2.0 - tmp2.x;
                tmp4.y = tmp2.x * 0.3333333;
                tmp2.xz = inp.texcoord.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
                tmp2.xz = tmp2.xz * float2(0.3333333, 0.3333333) + tmp4.xy;
                tmp2.xz = tmp0.ww * float2(0.975, 0.975) + tmp2.xz;
                tmp4 = tex2D(_MainTexture, tmp2.xz);
                tmp2.xzw = inp.texcoord2.xyz - _WorldSpaceCameraPos;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2.x = sqrt(tmp2.x);
                tmp2.xz = tmp2.xx * float2(0.3333333, 0.1);
                tmp2.xz = tmp2.xz * tmp2.xz;
                tmp2.xz = min(tmp2.xz, float2(1.0, 1.0));
                tmp2.x = tmp2.x * 0.7 + 0.3;
                tmp2.x = 1.0 / tmp2.x;
                tmp2.xw = saturate(tmp2.xx * tmp4.xy);
                tmp3.zw = tmp2.xw * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp2.xw = tmp2.xw * tmp2.xw;
                tmp4.x = tmp0.z * tmp0.z;
                tmp4.x = tmp4.x * tmp4.x;
                tmp4.x = tmp0.z * tmp4.x;
                tmp0.z = log(tmp0.z);
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp1.x * tmp0.y;
                tmp0.z = tmp4.x * tmp4.x;
                tmp0.z = tmp0.z * tmp0.z;
                tmp4.y = saturate(tmp0.z * tmp4.x);
                tmp4.x = saturate(tmp4.x);
                tmp4.xy = -tmp3.zw * tmp2.xw + tmp4.xy;
                tmp2.xw = tmp2.xw * tmp3.zw;
                tmp1.y = saturate(tmp1.y);
                tmp0.z = max(tmp1.z, 0.0);
                tmp0.z = min(tmp0.z, 0.25);
                tmp0.z = tmp2.y * tmp0.z + tmp1.w;
                tmp1.x = tmp1.y + tmp2.z;
                tmp1.xy = tmp1.xx * tmp4.xy + tmp2.xw;
                tmp1.y = tmp1.y * _Sharp;
                tmp1.xyz = _Color.xyz * tmp1.xxx + tmp1.yyy;
                tmp1.w = inp.texcoord3.w + 0.0;
                tmp2.x = tmp1.w * 0.5;
                tmp2.z = -tmp1.w * 0.5 + inp.texcoord3.y;
                tmp4.y = -tmp2.z * _ProjectionParams.x + tmp2.x;
                tmp4.x = inp.texcoord3.x;
                tmp2.xz = tmp4.xy / tmp1.ww;
                tmp2.xz = tmp0.ww * float2(3.9, 3.9) + tmp2.xz;
                tmp2.xz = tmp2.xz * float2(0.8, 0.8) + float2(0.1, 0.1);
                tmp4 = tex2D(_RefractionOverlay, tmp2.xz);
                tmp1.w = round(tmp3.y);
                tmp1.w = tmp1.w * 2.0 + -1.0;
                tmp1.w = tmp1.w * tmp3.x;
                tmp3 = inp.texcoord.xyxy * _Noise_ST + _Noise_ST;
                tmp5.xy = tmp1.ww * float2(0.5, -0.5) + tmp3.xz;
                tmp3 = _Time * float4(-0.005, 0.025, 0.01, -0.05) + tmp3;
                tmp5.z = 0.0;
                tmp2.xz = tmp3.zw + tmp5.yz;
                tmp3.xy = tmp3.xy * float2(0.5, 0.5) + tmp5.xz;
                tmp3 = tex2D(_Noise, tmp3.xy);
                tmp5 = tex2D(_Noise, tmp2.xz);
                tmp2.xzw = tmp5.xyz - tmp3.xyz;
                tmp1.w = tmp2.y * 0.75;
                tmp2.xzw = tmp1.www * tmp2.xzw + tmp3.xyz;
                tmp2.xzw = tmp2.xzw - _Color.xyz;
                tmp2.xzw = tmp2.xzw * float3(0.5, 0.5, 0.5) + _Color.xyz;
                tmp3.xyz = tmp2.xzw - tmp4.xyz;
                tmp3.xyz = tmp3.xyz * float3(0.3, 0.3, 0.3) + tmp4.xyz;
                tmp3.xyz = tmp2.yyy * tmp3.xyz;
                tmp1.w = tmp0.w * 3.9 + 0.03;
                tmp4.xy = tmp0.ww * float2(3.9, 3.9) + inp.texcoord.xy;
                tmp0.w = tmp1.w * 11.66667 + 0.3;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp3.xyz;
                tmp3.xy = tmp4.xy + _Normalintensity.xx;
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xy = tmp3.xy * tmp3.xy;
                tmp0.w = tmp3.y + tmp3.x;
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp0.w = max(tmp0.w, 0.0);
                tmp3.xy = _Normalintensity.xx * float2(0.0, 1.0) + tmp4.xy;
                tmp3.zw = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.zw = tmp3.zw * tmp3.zw;
                tmp1.w = tmp3.w + tmp3.z;
                tmp1.w = -tmp1.w * tmp1.w + 1.0;
                tmp1.w = max(tmp1.w, 0.0);
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xy = tmp3.xy * tmp3.xy;
                tmp2.y = tmp3.y + tmp3.x;
                tmp2.y = -tmp2.y * tmp2.y + 1.0;
                tmp2.y = max(tmp2.y, 0.0);
                tmp0.w = tmp0.w - tmp2.y;
                tmp2.y = tmp2.y - tmp1.w;
                tmp3.y = tmp2.y + tmp2.y;
                tmp3.x = tmp0.w + tmp0.w;
                tmp0.w = -tmp3.x * tmp3.x + 1.0;
                tmp0.w = -tmp3.y * tmp3.y + tmp0.w;
                tmp3.z = sqrt(tmp0.w);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp4.xyz = tmp3.yyy * unity_MatrixInvV._m01_m11_m21;
                tmp3.xyw = unity_MatrixInvV._m00_m10_m20 * tmp3.xxx + tmp4.xyz;
                tmp3.xyz = unity_MatrixInvV._m02_m12_m22 * tmp3.zzz + tmp3.xyw;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp4.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp4.xyz * tmp0.www + float3(0.0, 0.5, 0.0);
                tmp4.xyz = tmp4.xyz * tmp0.www + float3(0.0, -0.5, 0.0);
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp0.www * tmp5.xyz;
                tmp0.w = dot(tmp3.xyz, tmp5.xyz);
                tmp0.w = tmp0.w + 1.0;
                tmp0.yw = tmp0.yw * float2(3.0, 0.5);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 300.0;
                tmp0.w = exp(tmp0.w);
                tmp2.y = dot(tmp4.xyz, tmp4.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp4.xyz = tmp2.yyy * tmp4.xyz;
                tmp2.y = dot(tmp3.xyz, tmp4.xyz);
                tmp2.y = tmp2.y + 1.0;
                tmp2.y = tmp2.y * 0.5;
                tmp2.y = log(tmp2.y);
                tmp2.y = tmp2.y * 300.0;
                tmp2.y = exp(tmp2.y);
                tmp0.w = tmp0.w + tmp2.y;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.z = tmp0.w * tmp1.w + tmp0.z;
                tmp3.xyz = tmp2.xzw + tmp0.zzz;
                tmp1.xyz = tmp0.zzz * tmp3.xyz + tmp1.xyz;
                tmp0.yzw = tmp0.yyy * tmp2.xzw + tmp1.xyz;
                o.sv_target.xyz = saturate(tmp0.yzw * tmp0.xxx);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Overlay+0" "RenderType" = "Overlay" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 103401
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _Fade;
			float _StartTime;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTexture;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.color = v.color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord3.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                tmp0.x = _Time.y - _StartTime;
                tmp0.x = tmp0.x * -2.0 + 0.1;
                tmp0.x = min(abs(tmp0.x), 1.0);
                tmp0.x = 2.0 - tmp0.x;
                tmp0.x = tmp0.x * _Time.y;
                tmp0.xy = tmp0.xx * float2(-0.05, -0.5) + inp.texcoord.xy;
                tmp0.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp0.zw = tmp0.zz * inp.texcoord1.zx;
                tmp1.x = tmp0.z + tmp0.w;
                tmp0.zw = _Time.yy * float2(0.3, -0.25) + tmp0.zw;
                tmp0.xy = tmp0.xy + tmp1.xx;
                tmp1.x = dot(tmp0.xy, float2(0.3660254, 0.3660254));
                tmp1.xy = tmp0.xy + tmp1.xx;
                tmp1.xy = floor(tmp1.xy);
                tmp1.zw = tmp1.xy * float2(0.0034602, 0.0034602);
                tmp1.zw = floor(tmp1.zw);
                tmp1.zw = -tmp1.zw * float2(289.0, 289.0) + tmp1.xy;
                tmp0.xy = tmp0.xy - tmp1.xy;
                tmp1.x = dot(tmp1.xy, float2(0.2113249, 0.2113249));
                tmp0.xy = tmp0.xy + tmp1.xx;
                tmp1.x = tmp0.y < tmp0.x;
                tmp2 = tmp1.xxxx ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp3.y = tmp2.y;
                tmp3.xz = float2(0.0, 1.0);
                tmp1.xyw = tmp1.www + tmp3.xyz;
                tmp3.xyz = tmp1.xyw * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyw = tmp1.xyw * tmp3.xyz;
                tmp3.xyz = tmp1.xyw * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp1.xyw = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp1.xyw;
                tmp1.xyz = tmp1.zzz + tmp1.xyw;
                tmp3.y = tmp2.x;
                tmp3.xz = float2(0.0, 1.0);
                tmp1.xyz = tmp1.xyz + tmp3.xyz;
                tmp3.xyz = tmp1.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp3.xyz = tmp1.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp1.xyz = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp1.xyz = frac(tmp1.xyz);
                tmp3.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3.xyz = floor(tmp3.xyz);
                tmp3.xyz = tmp1.xyz - tmp3.xyz;
                tmp1.xyz = abs(tmp1.xyz) - float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp1.xyz * tmp1.xyz;
                tmp4.xyz = tmp3.xyz * tmp3.xyz + tmp4.xyz;
                tmp4.xyz = -tmp4.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp5.x = dot(tmp0.xy, tmp0.xy);
                tmp6 = tmp0.xyxy + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp5.z = dot(tmp6.xy, tmp6.xy);
                tmp6.xy = tmp2.zw + tmp6.xy;
                tmp5.y = dot(tmp6.xy, tmp6.xy);
                tmp2.xyz = float3(0.5, 0.5, 0.5) - tmp5.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp2.xyz = tmp4.xyz * tmp2.xyz;
                tmp0.y = tmp0.y * tmp1.x;
                tmp1.xy = tmp1.yz * tmp6.yw;
                tmp1.yz = tmp3.yz * tmp6.xz + tmp1.xy;
                tmp1.x = tmp3.x * tmp0.x + tmp0.y;
                tmp0.x = dot(tmp2.xyz, tmp1.xyz);
                tmp1.x = sin(tmp0.w);
                tmp2.x = cos(tmp0.w);
                tmp3.x = sin(tmp0.z);
                tmp4.x = cos(tmp0.z);
                tmp5.z = tmp1.x;
                tmp5.y = tmp2.x;
                tmp5.x = -tmp1.x;
                tmp0.yz = inp.texcoord.xy - float2(0.5, 0.5);
                tmp1.x = dot(tmp0.xy, tmp5.xy);
                tmp1.y = dot(tmp0.xy, tmp5.xy);
                tmp1.xy = tmp1.xy + float2(0.5, 0.5);
                tmp1.xy = saturate(tmp0.xx * float2(3.9, 3.9) + tmp1.xy);
                tmp1 = tex2D(_MainTexture, tmp1.xy);
                tmp2.z = tmp3.x;
                tmp2.y = tmp4.x;
                tmp2.x = -tmp3.x;
                tmp1.y = dot(tmp0.xy, tmp2.xy);
                tmp1.x = dot(tmp0.xy, tmp2.xy);
                tmp0.yz = tmp1.xy + float2(0.5, 0.5);
                tmp0.xy = saturate(tmp0.xx * float2(3.9, 3.9) + tmp0.yz);
                tmp0 = tex2D(_MainTexture, tmp0.xy);
                tmp0.x = tmp0.z + tmp0.z;
                tmp0.x = tmp1.z * tmp0.x;
                tmp0.y = 1.0 - tmp1.z;
                tmp1.xy = tmp0.wz - float2(0.03, 0.5);
                tmp0.z = tmp0.z > 0.5;
                tmp0.w = -tmp1.y * 2.0 + 1.0;
                tmp1.x = saturate(tmp1.x * 1.030928);
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.x = tmp1.x + tmp0.x;
                tmp0.yz = inp.texcoord.xy * float2(3.0, 3.0);
                tmp0.y = dot(tmp0.xy, float2(0.3660254, 0.3660254));
                tmp0.yz = inp.texcoord.xy * float2(3.0, 3.0) + tmp0.yy;
                tmp0.yz = floor(tmp0.yz);
                tmp1.xy = tmp0.yz * float2(0.0034602, 0.0034602);
                tmp1.xy = floor(tmp1.xy);
                tmp1.xy = -tmp1.xy * float2(289.0, 289.0) + tmp0.yz;
                tmp2.xz = float2(0.0, 1.0);
                tmp1.zw = inp.texcoord.xy * float2(3.0, 3.0) + -tmp0.yz;
                tmp0.y = dot(tmp0.xy, float2(0.2113249, 0.2113249));
                tmp0.yz = tmp0.yy + tmp1.zw;
                tmp0.w = tmp0.z < tmp0.y;
                tmp3 = tmp0.wwww ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp2.y = tmp3.y;
                tmp1.yzw = tmp1.yyy + tmp2.xyz;
                tmp2.xyz = tmp1.yzw * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp1.yzw = tmp1.yzw * tmp2.xyz;
                tmp2.xyz = tmp1.yzw * float3(0.0034602, 0.0034602, 0.0034602);
                tmp2.xyz = floor(tmp2.xyz);
                tmp1.yzw = -tmp2.xyz * float3(289.0, 289.0, 289.0) + tmp1.yzw;
                tmp1.xyz = tmp1.xxx + tmp1.yzw;
                tmp2.xz = float2(0.0, 1.0);
                tmp2.y = tmp3.x;
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp2.xyz = tmp1.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp2.xyz = tmp1.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp2.xyz = floor(tmp2.xyz);
                tmp1.xyz = -tmp2.xyz * float3(289.0, 289.0, 289.0) + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp1.xyz = frac(tmp1.xyz);
                tmp2.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.xyz = floor(tmp2.xyz);
                tmp2.xyz = tmp1.xyz - tmp2.xyz;
                tmp1.xyz = abs(tmp1.xyz) - float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp1.xyz * tmp1.xyz;
                tmp4.xyz = tmp2.xyz * tmp2.xyz + tmp4.xyz;
                tmp4.xyz = -tmp4.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp5.x = dot(tmp0.xy, tmp0.xy);
                tmp6 = tmp0.yzyz + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp6.xy = tmp3.zw + tmp6.xy;
                tmp5.y = dot(tmp6.xy, tmp6.xy);
                tmp5.z = dot(tmp6.xy, tmp6.xy);
                tmp3.xyz = float3(0.5, 0.5, 0.5) - tmp5.xyz;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp3.xyz = tmp3.xyz * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * tmp3.xyz;
                tmp3.xyz = tmp4.xyz * tmp3.xyz;
                tmp0.z = tmp0.z * tmp1.x;
                tmp1.xy = tmp1.yz * tmp6.yw;
                tmp1.yz = tmp2.yz * tmp6.xz + tmp1.xy;
                tmp1.x = tmp2.x * tmp0.y + tmp0.z;
                tmp0.y = dot(tmp3.xyz, tmp1.xyz);
                tmp0.y = tmp0.y * 130.0 + 1.0;
                tmp0.z = -tmp0.y * 0.5 + 1.0;
                tmp0.y = tmp0.y * 0.5;
                tmp1.xy = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.xy = tmp1.xy * tmp1.xy;
                tmp0.w = tmp1.y + tmp1.x;
                tmp0.w = max(tmp0.w, 0.01);
                tmp0.w = min(tmp0.w, 0.99);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = -tmp1.x * 2.0 + 1.0;
                tmp0.z = -tmp1.x * tmp0.z + 1.0;
                tmp1.x = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w > 0.5;
                tmp0.y = tmp0.y * tmp1.x;
                tmp0.y = saturate(tmp0.w ? tmp0.z : tmp0.y);
                tmp0.z = 1.0 - tmp0.y;
                tmp0.w = inp.color.w * _Fade;
                tmp1.x = tmp0.w * tmp0.w;
                tmp1.y = tmp0.w * tmp1.x + -0.5;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = -tmp1.y * 2.0 + 1.0;
                tmp0.z = -tmp1.x * tmp0.z + 1.0;
                tmp1.x = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w > 0.5;
                tmp0.y = tmp0.y * tmp1.x;
                tmp0.y = saturate(tmp0.w ? tmp0.z : tmp0.y);
                tmp0.y = tmp0.y - 0.48;
                tmp0.y = saturate(tmp0.y * 25.00001);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = tmp0.x * 10.0 + -_Cutoff;
                o.sv_target.w = tmp0.x;
                tmp0.x = tmp0.y < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target.xyz = float3(0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "Meta"
			Tags { "DisableBatching" = "true" "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "META" "QUEUE" = "Overlay+0" "RenderType" = "Overlay" }
			Blend One OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			Cull Off
			GpuProgramID 155455
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _Fade;
			float4 _Color;
			float _StartTime;
			float4 _MainTexture_ST;
			float _Rune;
			float _Sharp;
			float4 _Noise_ST;
			float _Normalintensity;
			float _Cutoff;
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
			sampler2D _MainTexture;
			sampler2D _RefractionOverlay;
			sampler2D _Noise;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = v.vertex.z > 0.0;
                tmp0.z = tmp0.x ? 0.0001 : 0.0;
                tmp0.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp0.xyz = unity_MetaVertexControl.xxx ? tmp0.xyz : v.vertex.xyz;
                tmp0.w = tmp0.z > 0.0;
                tmp1.z = tmp0.w ? 0.0001 : 0.0;
                tmp1.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                tmp0.xyz = unity_MetaVertexControl.yyy ? tmp1.xyz : tmp0.xyz;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_MatrixVP._m03_m13_m23_m33;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp1.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.zw = tmp0.zw;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
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
                float4 tmp9;
                tmp0.xy = inp.texcoord.xy * float2(3.0, 3.0);
                tmp0.x = dot(tmp0.xy, float2(0.3660254, 0.3660254));
                tmp0.xy = inp.texcoord.xy * float2(3.0, 3.0) + tmp0.xx;
                tmp0.xy = floor(tmp0.xy);
                tmp0.zw = tmp0.xy * float2(0.0034602, 0.0034602);
                tmp0.zw = floor(tmp0.zw);
                tmp0.zw = -tmp0.zw * float2(289.0, 289.0) + tmp0.xy;
                tmp1.xz = float2(0.0, 1.0);
                tmp2.xy = inp.texcoord.xy * float2(3.0, 3.0) + -tmp0.xy;
                tmp0.x = dot(tmp0.xy, float2(0.2113249, 0.2113249));
                tmp0.xy = tmp0.xx + tmp2.xy;
                tmp1.w = tmp0.y < tmp0.x;
                tmp2 = tmp1.wwww ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp1.y = tmp2.y;
                tmp1.xyz = tmp0.www + tmp1.xyz;
                tmp3.xyz = tmp1.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp3.xyz = tmp1.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp1.xyz = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp1.xyz;
                tmp1.xyz = tmp0.zzz + tmp1.xyz;
                tmp3.xz = float2(0.0, 1.0);
                tmp3.y = tmp2.x;
                tmp1.xyz = tmp1.xyz + tmp3.xyz;
                tmp3.xyz = tmp1.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp3.xyz = tmp1.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp1.xyz = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp1.xyz = frac(tmp1.xyz);
                tmp3.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3.xyz = floor(tmp3.xyz);
                tmp3.xyz = tmp1.xyz - tmp3.xyz;
                tmp1.xyz = abs(tmp1.xyz) - float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp1.xyz * tmp1.xyz;
                tmp4.xyz = tmp3.xyz * tmp3.xyz + tmp4.xyz;
                tmp4.xyz = -tmp4.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp5.x = dot(tmp0.xy, tmp0.xy);
                tmp6 = tmp0.xyxy + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp6.xy = tmp2.zw + tmp6.xy;
                tmp5.y = dot(tmp6.xy, tmp6.xy);
                tmp5.z = dot(tmp6.xy, tmp6.xy);
                tmp2.xyz = float3(0.5, 0.5, 0.5) - tmp5.xyz;
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp2.xyz = tmp4.xyz * tmp2.xyz;
                tmp0.y = tmp0.y * tmp1.x;
                tmp0.zw = tmp1.yz * tmp6.yw;
                tmp1.yz = tmp3.yz * tmp6.xz + tmp0.zw;
                tmp1.x = tmp3.x * tmp0.x + tmp0.y;
                tmp0.x = dot(tmp2.xyz, tmp1.xyz);
                tmp0.x = tmp0.x * 130.0 + 1.0;
                tmp0.y = -tmp0.x * 0.5 + 1.0;
                tmp0.x = tmp0.x * 0.5;
                tmp0.zw = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.zw = tmp0.zw * tmp0.zw;
                tmp0.z = tmp0.w + tmp0.z;
                tmp0.w = max(tmp0.z, 0.01);
                tmp0.z = 1.0 - tmp0.z;
                tmp0.w = min(tmp0.w, 0.99);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = -tmp1.x * 2.0 + 1.0;
                tmp0.y = -tmp1.x * tmp0.y + 1.0;
                tmp1.x = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w > 0.5;
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.x = saturate(tmp0.w ? tmp0.y : tmp0.x);
                tmp0.y = 1.0 - tmp0.x;
                tmp0.w = inp.color.w * _Fade;
                tmp1.x = tmp0.w * tmp0.w;
                tmp1.yz = tmp0.ww * tmp1.xx + float2(-0.8, -0.5);
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = -tmp1.z * 2.0 + 1.0;
                tmp1.yz = tmp1.yz * float2(-5.0, -1.9) + float2(1.0, 1.0);
                tmp0.y = -tmp1.x * tmp0.y + 1.0;
                tmp1.x = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w > 0.5;
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.x = saturate(tmp0.w ? tmp0.y : tmp0.x);
                tmp0.x = tmp0.x - 0.48;
                tmp0.x = saturate(tmp0.x * 25.00001);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = _Time.y - _StartTime;
                tmp0.y = tmp0.y * -2.0 + 0.1;
                tmp0.y = min(abs(tmp0.y), 1.0);
                tmp1.xw = float2(1.0, 2.0) - tmp0.yy;
                tmp0.y = tmp0.y * 4.8 + 0.2;
                tmp0.w = tmp1.w * _Time.y;
                tmp2.xy = tmp0.ww * float2(-0.05, -0.5) + inp.texcoord.xy;
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.zw = tmp0.ww * inp.texcoord1.zx;
                tmp3.xy = inp.texcoord1.xz * tmp0.ww + float2(1.0, 1.0);
                tmp3.xy = tmp3.xy * float2(0.5, 0.5);
                tmp0.w = tmp2.z + tmp2.w;
                tmp2.zw = _Time.yy * float2(0.3, -0.25) + tmp2.zw;
                tmp2.xy = tmp0.ww + tmp2.xy;
                tmp0.w = dot(tmp2.xy, float2(0.3660254, 0.3660254));
                tmp3.zw = tmp0.ww + tmp2.xy;
                tmp3.zw = floor(tmp3.zw);
                tmp4.xy = tmp3.zw * float2(0.0034602, 0.0034602);
                tmp4.xy = floor(tmp4.xy);
                tmp4.xy = -tmp4.xy * float2(289.0, 289.0) + tmp3.zw;
                tmp5.xz = float2(0.0, 1.0);
                tmp2.xy = tmp2.xy - tmp3.zw;
                tmp0.w = dot(tmp3.xy, float2(0.2113249, 0.2113249));
                tmp2.xy = tmp0.ww + tmp2.xy;
                tmp0.w = tmp2.y < tmp2.x;
                tmp6 = tmp0.wwww ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp5.y = tmp6.y;
                tmp4.yzw = tmp4.yyy + tmp5.xyz;
                tmp5.xyz = tmp4.yzw * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp4.yzw = tmp4.yzw * tmp5.xyz;
                tmp5.xyz = tmp4.yzw * float3(0.0034602, 0.0034602, 0.0034602);
                tmp5.xyz = floor(tmp5.xyz);
                tmp4.yzw = -tmp5.xyz * float3(289.0, 289.0, 289.0) + tmp4.yzw;
                tmp4.xyz = tmp4.xxx + tmp4.yzw;
                tmp5.xz = float2(0.0, 1.0);
                tmp5.y = tmp6.x;
                tmp4.xyz = tmp4.xyz + tmp5.xyz;
                tmp5.xyz = tmp4.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp4.xyz * tmp5.xyz;
                tmp5.xyz = tmp4.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp5.xyz = floor(tmp5.xyz);
                tmp4.xyz = -tmp5.xyz * float3(289.0, 289.0, 289.0) + tmp4.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp4.xyz = frac(tmp4.xyz);
                tmp5.xyz = tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp4.xyz = tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp5.xyz = floor(tmp5.xyz);
                tmp5.xyz = tmp4.xyz - tmp5.xyz;
                tmp4.xyz = abs(tmp4.xyz) - float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp4.xyz * tmp4.xyz;
                tmp7.xyz = tmp5.xyz * tmp5.xyz + tmp7.xyz;
                tmp7.xyz = -tmp7.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp8.x = dot(tmp2.xy, tmp2.xy);
                tmp9 = tmp2.xyxy + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp8.z = dot(tmp9.xy, tmp9.xy);
                tmp9.xy = tmp6.zw + tmp9.xy;
                tmp8.y = dot(tmp9.xy, tmp9.xy);
                tmp6.xyz = float3(0.5, 0.5, 0.5) - tmp8.xyz;
                tmp6.xyz = max(tmp6.xyz, float3(0.0, 0.0, 0.0));
                tmp6.xyz = tmp6.xyz * tmp6.xyz;
                tmp6.xyz = tmp6.xyz * tmp6.xyz;
                tmp6.xyz = tmp7.xyz * tmp6.xyz;
                tmp0.w = tmp2.y * tmp4.x;
                tmp3.zw = tmp4.yz * tmp9.yw;
                tmp4.yz = tmp5.yz * tmp9.xz + tmp3.zw;
                tmp4.x = tmp5.x * tmp2.x + tmp0.w;
                tmp0.w = dot(tmp6.xyz, tmp4.xyz);
                tmp2.x = sin(tmp2.w);
                tmp4.x = cos(tmp2.w);
                tmp5.x = sin(tmp2.z);
                tmp6.x = cos(tmp2.z);
                tmp7.z = tmp2.x;
                tmp7.y = tmp4.x;
                tmp7.x = -tmp2.x;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp4.x = dot(tmp2.xy, tmp7.xy);
                tmp4.y = dot(tmp2.xy, tmp7.xy);
                tmp2.zw = tmp4.xy + float2(0.5, 0.5);
                tmp2.zw = saturate(tmp0.ww * float2(3.9, 3.9) + tmp2.zw);
                tmp4 = tex2D(_MainTexture, tmp2.zw);
                tmp7.z = tmp5.x;
                tmp7.y = tmp6.x;
                tmp7.x = -tmp5.x;
                tmp4.y = dot(tmp2.xy, tmp7.xy);
                tmp4.x = dot(tmp2.xy, tmp7.xy);
                tmp2.xy = tmp4.xy + float2(0.5, 0.5);
                tmp2.xy = saturate(tmp0.ww * float2(3.9, 3.9) + tmp2.xy);
                tmp2 = tex2D(_MainTexture, tmp2.xy);
                tmp1.w = tmp2.z + tmp2.z;
                tmp1.w = tmp4.z * tmp1.w;
                tmp2.x = 1.0 - tmp4.z;
                tmp2.yw = tmp2.wz - float2(0.03, 0.5);
                tmp2.z = tmp2.z > 0.5;
                tmp2.w = -tmp2.w * 2.0 + 1.0;
                tmp2.y = saturate(tmp2.y * 1.030928);
                tmp2.x = -tmp2.w * tmp2.x + 1.0;
                tmp1.w = saturate(tmp2.z ? tmp2.x : tmp1.w);
                tmp2.x = tmp2.y + tmp1.w;
                tmp2.x = tmp0.x * tmp2.x;
                tmp2.x = tmp2.x * 10.0 + -_Cutoff;
                tmp2.x = tmp2.x < 0.0;
                if (tmp2.x) {
                    discard;
                }
                tmp2.x = _Rune * 0.1111111;
                tmp2.z = tmp2.x >= -tmp2.x;
                tmp2.x = frac(abs(tmp2.x));
                tmp2.x = tmp2.z ? tmp2.x : -tmp2.x;
                tmp2.x = tmp2.x * 9.0;
                tmp2.x = round(tmp2.x);
                tmp2.z = tmp2.x < 0.0;
                tmp2.z = tmp2.z ? 9.0 : 0.0;
                tmp2.x = tmp2.z + tmp2.x;
                tmp2.z = tmp2.x * 0.3333333;
                tmp2.w = tmp2.z >= -tmp2.z;
                tmp2.z = frac(abs(tmp2.z));
                tmp2.z = tmp2.w ? tmp2.z : -tmp2.z;
                tmp2.z = tmp2.z * 3.0;
                tmp2.z = round(tmp2.z);
                tmp2.x = tmp2.x - tmp2.z;
                tmp4.x = tmp2.z * 0.3333333;
                tmp2.x = tmp2.x * 0.1111111;
                tmp2.z = tmp2.x >= -tmp2.x;
                tmp2.x = frac(abs(tmp2.x));
                tmp2.x = tmp2.z ? tmp2.x : -tmp2.x;
                tmp2.x = tmp2.x * 3.0;
                tmp2.x = round(tmp2.x);
                tmp2.x = 2.0 - tmp2.x;
                tmp4.y = tmp2.x * 0.3333333;
                tmp2.xz = inp.texcoord.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
                tmp2.xz = tmp2.xz * float2(0.3333333, 0.3333333) + tmp4.xy;
                tmp2.xz = tmp0.ww * float2(0.975, 0.975) + tmp2.xz;
                tmp4 = tex2D(_MainTexture, tmp2.xz);
                tmp2.xzw = inp.texcoord2.xyz - _WorldSpaceCameraPos;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2.x = sqrt(tmp2.x);
                tmp2.xz = tmp2.xx * float2(0.3333333, 0.1);
                tmp2.xz = tmp2.xz * tmp2.xz;
                tmp2.xz = min(tmp2.xz, float2(1.0, 1.0));
                tmp2.x = tmp2.x * 0.7 + 0.3;
                tmp2.x = 1.0 / tmp2.x;
                tmp2.xw = saturate(tmp2.xx * tmp4.xy);
                tmp3.zw = tmp2.xw * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp2.xw = tmp2.xw * tmp2.xw;
                tmp4.x = tmp0.z * tmp0.z;
                tmp4.x = tmp4.x * tmp4.x;
                tmp4.x = tmp0.z * tmp4.x;
                tmp0.z = log(tmp0.z);
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp1.x * tmp0.y;
                tmp0.z = tmp4.x * tmp4.x;
                tmp0.z = tmp0.z * tmp0.z;
                tmp4.y = saturate(tmp0.z * tmp4.x);
                tmp4.x = saturate(tmp4.x);
                tmp4.xy = -tmp3.zw * tmp2.xw + tmp4.xy;
                tmp2.xw = tmp2.xw * tmp3.zw;
                tmp1.y = saturate(tmp1.y);
                tmp0.z = max(tmp1.z, 0.0);
                tmp0.z = min(tmp0.z, 0.25);
                tmp0.z = tmp2.y * tmp0.z + tmp1.w;
                tmp1.x = tmp1.y + tmp2.z;
                tmp1.xy = tmp1.xx * tmp4.xy + tmp2.xw;
                tmp1.y = tmp1.y * _Sharp;
                tmp1.xyz = _Color.xyz * tmp1.xxx + tmp1.yyy;
                tmp1.w = inp.texcoord3.w + 0.0;
                tmp2.x = tmp1.w * 0.5;
                tmp2.z = -tmp1.w * 0.5 + inp.texcoord3.y;
                tmp4.y = -tmp2.z * _ProjectionParams.x + tmp2.x;
                tmp4.x = inp.texcoord3.x;
                tmp2.xz = tmp4.xy / tmp1.ww;
                tmp2.xz = tmp0.ww * float2(3.9, 3.9) + tmp2.xz;
                tmp2.xz = tmp2.xz * float2(0.8, 0.8) + float2(0.1, 0.1);
                tmp4 = tex2D(_RefractionOverlay, tmp2.xz);
                tmp1.w = round(tmp3.y);
                tmp1.w = tmp1.w * 2.0 + -1.0;
                tmp1.w = tmp1.w * tmp3.x;
                tmp3 = inp.texcoord.xyxy * _Noise_ST + _Noise_ST;
                tmp5.xy = tmp1.ww * float2(0.5, -0.5) + tmp3.xz;
                tmp3 = _Time * float4(-0.005, 0.025, 0.01, -0.05) + tmp3;
                tmp5.z = 0.0;
                tmp2.xz = tmp3.zw + tmp5.yz;
                tmp3.xy = tmp3.xy * float2(0.5, 0.5) + tmp5.xz;
                tmp3 = tex2D(_Noise, tmp3.xy);
                tmp5 = tex2D(_Noise, tmp2.xz);
                tmp2.xzw = tmp5.xyz - tmp3.xyz;
                tmp1.w = tmp2.y * 0.75;
                tmp2.xzw = tmp1.www * tmp2.xzw + tmp3.xyz;
                tmp2.xzw = tmp2.xzw - _Color.xyz;
                tmp2.xzw = tmp2.xzw * float3(0.5, 0.5, 0.5) + _Color.xyz;
                tmp3.xyz = tmp2.xzw - tmp4.xyz;
                tmp3.xyz = tmp3.xyz * float3(0.3, 0.3, 0.3) + tmp4.xyz;
                tmp3.xyz = tmp2.yyy * tmp3.xyz;
                tmp1.w = tmp0.w * 3.9 + 0.03;
                tmp4.xy = tmp0.ww * float2(3.9, 3.9) + inp.texcoord.xy;
                tmp0.w = tmp1.w * 11.66667 + 0.3;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp3.xyz;
                tmp3.xy = tmp4.xy + _Normalintensity.xx;
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xy = tmp3.xy * tmp3.xy;
                tmp0.w = tmp3.y + tmp3.x;
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp0.w = max(tmp0.w, 0.0);
                tmp3.xy = _Normalintensity.xx * float2(0.0, 1.0) + tmp4.xy;
                tmp3.zw = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.zw = tmp3.zw * tmp3.zw;
                tmp1.w = tmp3.w + tmp3.z;
                tmp1.w = -tmp1.w * tmp1.w + 1.0;
                tmp1.w = max(tmp1.w, 0.0);
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xy = tmp3.xy * tmp3.xy;
                tmp2.y = tmp3.y + tmp3.x;
                tmp2.y = -tmp2.y * tmp2.y + 1.0;
                tmp2.y = max(tmp2.y, 0.0);
                tmp0.w = tmp0.w - tmp2.y;
                tmp2.y = tmp2.y - tmp1.w;
                tmp3.y = tmp2.y + tmp2.y;
                tmp3.x = tmp0.w + tmp0.w;
                tmp0.w = -tmp3.x * tmp3.x + 1.0;
                tmp0.w = -tmp3.y * tmp3.y + tmp0.w;
                tmp3.z = sqrt(tmp0.w);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp4.xyz = tmp3.yyy * unity_MatrixInvV._m01_m11_m21;
                tmp3.xyw = unity_MatrixInvV._m00_m10_m20 * tmp3.xxx + tmp4.xyz;
                tmp3.xyz = unity_MatrixInvV._m02_m12_m22 * tmp3.zzz + tmp3.xyw;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp4.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp4.xyz * tmp0.www + float3(0.0, 0.5, 0.0);
                tmp4.xyz = tmp4.xyz * tmp0.www + float3(0.0, -0.5, 0.0);
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp0.www * tmp5.xyz;
                tmp0.w = dot(tmp3.xyz, tmp5.xyz);
                tmp0.w = tmp0.w + 1.0;
                tmp0.yw = tmp0.yw * float2(3.0, 0.5);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 300.0;
                tmp0.w = exp(tmp0.w);
                tmp2.y = dot(tmp4.xyz, tmp4.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp4.xyz = tmp2.yyy * tmp4.xyz;
                tmp2.y = dot(tmp3.xyz, tmp4.xyz);
                tmp2.y = tmp2.y + 1.0;
                tmp2.y = tmp2.y * 0.5;
                tmp2.y = log(tmp2.y);
                tmp2.y = tmp2.y * 300.0;
                tmp2.y = exp(tmp2.y);
                tmp0.w = tmp0.w + tmp2.y;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.z = tmp0.w * tmp1.w + tmp0.z;
                tmp3.xyz = tmp2.xzw + tmp0.zzz;
                tmp1.xyz = tmp0.zzz * tmp3.xyz + tmp1.xyz;
                tmp0.yzw = tmp0.yyy * tmp2.xzw + tmp1.xyz;
                tmp0.xyz = saturate(tmp0.yzw * tmp0.xxx);
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
	}
	CustomEditor "ASEMaterialInspector"
}