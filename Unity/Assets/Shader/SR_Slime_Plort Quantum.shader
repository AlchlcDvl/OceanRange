Shader "SR/Slime/Plort Quantum" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_AvgCycleLength ("AvgCycleLength", Range(1, 10)) = 3
		_CycleGlitchRatio ("CycleGlitchRatio", Range(0, 1)) = 1
		_Fade ("Fade", Range(0, 1)) = 1
		_Static ("Static", 2D) = "black" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 11345
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			float _AvgCycleLength;
			float _CycleGlitchRatio;
			float _Fade;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float _Gloss;
			float _GlossPower;
			float4 _Static_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Static;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = unity_ObjectToWorld._m23 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = frac(tmp0.x);
                tmp0.yz = _TimeEditor.yz + _Time.yz;
                tmp0.w = tmp0.x + tmp0.y;
                tmp0.x = tmp0.x * 10.0 + tmp0.z;
                tmp0.y = tmp0.y * 5.0;
                tmp0.xy = sin(tmp0.xy);
                tmp0.y = tmp0.y + tmp0.y;
                tmp0.y = abs(tmp0.y) * 0.05;
                tmp1.xyz = tmp0.yyy * v.normal.xyz;
                tmp0.x = tmp0.x * 0.5;
                tmp0.xy = frac(tmp0.xw);
                tmp0.y = tmp0.w + tmp0.y;
                tmp0.y = tmp0.y / _AvgCycleLength;
                tmp0.y = frac(tmp0.y);
                tmp0.z = _CycleGlitchRatio >= tmp0.y;
                tmp0.y = tmp0.y >= _CycleGlitchRatio;
                tmp0.zw = tmp0.zy ? 1.0 : 0.0;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.y = tmp0.y ? 0.0 : tmp0.z;
                tmp0.y = tmp0.y + tmp0.w;
                tmp0.z = v.color.w * _Fade;
                tmp0.z = tmp0.z * 4.0;
                tmp0.z = round(tmp0.z);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.z = tmp0.x * tmp0.z;
                tmp0.xyz = tmp0.xyz * float3(16.0, 0.25, 80.0);
                tmp0.xz = round(tmp0.xz);
                tmp0.w = tmp0.z + 0.2127;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * 0.3713 + tmp0.w;
                tmp0.w = tmp0.z * 489.123;
                tmp0.z = tmp0.z + 1.0;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 4.789;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = frac(tmp0.z);
                tmp0.y = tmp0.z * tmp0.y;
                tmp2 = v.vertex.yyyy * unity_ObjectToWorld._m01_m21_m01_m21;
                tmp2 = unity_ObjectToWorld._m00_m20_m00_m20 * v.vertex.xxxx + tmp2;
                tmp2 = unity_ObjectToWorld._m02_m22_m02_m22 * v.vertex.zzzz + tmp2;
                tmp2 = unity_ObjectToWorld._m03_m23_m03_m23 * v.vertex.wwww + tmp2;
                tmp2 = tmp0.xxxx + tmp2;
                tmp2 = tmp2 * float4(16.0, 16.0, 4.0, 4.0);
                tmp2 = floor(tmp2);
                tmp0.xz = tmp2.yw * float2(0.0666667, 0.3333333);
                tmp3 = tmp0.xxzz * tmp2.xxzz;
                tmp2 = tmp2 * float4(0.0666667, 0.0666667, 0.3333333, 0.3333333) + float4(0.2127, 0.2127, 0.2127, 0.2127);
                tmp2 = tmp3 * float4(0.0247533, 0.0247533, 0.1237667, 0.1237667) + tmp2;
                tmp3 = tmp2 * float4(489.123, 489.123, 489.123, 489.123);
                tmp0.xz = tmp2.xz + float2(1.0, 1.0);
                tmp2 = sin(tmp3);
                tmp2 = tmp2 * float4(4.789, 4.789, 4.789, 4.789);
                tmp2.xy = tmp2.yw * tmp2.xz;
                tmp0.xz = tmp0.xz * tmp2.xy;
                tmp0.xz = frac(tmp0.xz);
                tmp0.x = max(tmp0.z, tmp0.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = v.normal.xyz * float3(-0.02, 0.2, -0.02);
                tmp0.xyz = tmp0.yzw * tmp0.xxx + tmp1.xyz;
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
                o.texcoord2 = tmp0;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.x = unity_ObjectToWorld._m23 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = frac(tmp0.x);
                tmp0.yz = _TimeEditor.yz + _Time.yz;
                tmp0.z = tmp0.x * 10.0 + tmp0.z;
                tmp0.z = sin(tmp0.z);
                tmp0.z = tmp0.z * 0.5;
                tmp0.z = frac(tmp0.z);
                tmp0.w = tmp0.z * tmp0.z;
                tmp0.w = tmp0.z * tmp0.w;
                tmp0.zw = tmp0.zw * float2(16.0, 80.0);
                tmp0.zw = round(tmp0.zw);
                tmp1.x = tmp0.w + 0.2127;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * 0.3713 + tmp1.x;
                tmp1.x = tmp0.w * 489.123;
                tmp0.w = tmp0.w + 1.0;
                tmp1.x = sin(tmp1.x);
                tmp1.x = tmp1.x * 4.789;
                tmp1.x = tmp1.x * tmp1.x;
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.w = frac(tmp0.w);
                tmp1.x = tmp0.x + tmp0.y;
                tmp1.yz = tmp1.xx * float2(0.5, 0.25);
                tmp1.yz = frac(tmp1.yz);
                tmp1.yz = tmp1.yz * float2(64.0, 4.0);
                tmp1.yz = round(tmp1.yz);
                tmp2.xy = tmp1.yz * float2(0.125, 0.5);
                tmp2.zw = floor(tmp2.xy);
                tmp2.y = -tmp2.z * 8.0 + tmp1.y;
                tmp2.x = -tmp2.w * 2.0 + tmp1.z;
                tmp1.y = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp1.y = rsqrt(tmp1.y);
                tmp1.yzw = tmp1.yyy * inp.texcoord1.xyz;
                tmp3.xy = tmp1.zz * unity_MatrixV._m01_m11;
                tmp3.xy = unity_MatrixV._m00_m10 * tmp1.yy + tmp3.xy;
                tmp3.xy = unity_MatrixV._m02_m12 * tmp1.ww + tmp3.xy;
                tmp3.zw = tmp3.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp4.xy = tmp0.zz + tmp3.zw;
                tmp0.xz = tmp0.xx + tmp3.zw;
                tmp0.xz = tmp0.yy * float2(0.75, -0.25) + tmp0.xz;
                tmp0.xz = tmp0.xz * _Static_ST.xy + _Static_ST.zw;
                tmp5 = tex2D(_Static, tmp0.xz);
                tmp0.xz = tmp2.yz + tmp4.xy;
                tmp2.xy = tmp2.xw + tmp4.xy;
                tmp2.xy = tmp2.xy * _Static_ST.xy;
                tmp2.xy = tmp2.xy * float2(0.5, 0.5) + _Static_ST.zw;
                tmp2 = tex2D(_Static, tmp2.xy);
                tmp0.xz = tmp0.xz * _Static_ST.xy;
                tmp0.xz = tmp0.xz * float2(0.125, 0.125) + _Static_ST.zw;
                tmp4 = tex2D(_Static, tmp0.xz);
                tmp0.x = max(tmp2.z, tmp4.z);
                tmp0.x = tmp0.x + tmp5.y;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp4.xyz = tmp0.zzz * tmp2.xyz;
                tmp2.w = dot(tmp1.xyz, tmp4.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp3.z = log(tmp2.w);
                tmp3.xyz = tmp3.xyz * float3(0.5, 0.5, 1.25);
                tmp3.z = exp(tmp3.z);
                tmp0.x = tmp0.x * tmp3.z;
                tmp0.x = tmp0.x * tmp0.w;
                tmp0.w = frac(tmp1.x);
                tmp0.w = tmp1.x + tmp0.w;
                tmp0.w = tmp0.w / _AvgCycleLength;
                tmp0.w = frac(tmp0.w);
                tmp1.x = _CycleGlitchRatio >= tmp0.w;
                tmp0.w = tmp0.w >= _CycleGlitchRatio;
                tmp1.x = tmp1.x ? 1.0 : 0.0;
                tmp3.z = tmp0.w ? 1.0 : 0.0;
                tmp1.x = tmp1.x * tmp3.z;
                tmp0.w = tmp0.w ? 0.0 : tmp1.x;
                tmp0.w = tmp0.w + tmp3.z;
                tmp1.x = inp.color.w * _Fade;
                tmp1.x = tmp1.x * 4.0;
                tmp1.x = round(tmp1.x);
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.w = tmp0.w * 0.25;
                tmp1.x = saturate(-tmp0.w * tmp0.x + 1.0);
                tmp0.x = tmp0.x * tmp0.w;
                tmp0.x = tmp0.x * 4.0;
                tmp0.x = floor(tmp0.x);
                tmp3.z = rsqrt(tmp2.w);
                tmp2.w = tmp2.w * tmp2.w;
                tmp2.w = min(tmp2.w, 1.0);
                tmp3.z = 1.0 / tmp3.z;
                tmp3.w = saturate(tmp3.z * 1.666667 + -0.3333333);
                tmp1.x = tmp1.x - tmp3.w;
                tmp1.x = tmp1.x + 1.0;
                tmp1.x = saturate(tmp1.x * 20.0 + -14.0);
                tmp1.x = tmp1.x * tmp1.x;
                tmp3.w = inp.texcoord2.y / inp.texcoord2.w;
                tmp4.w = _ProjectionParams.x * -_ProjectionParams.x;
                tmp3.w = tmp3.w * tmp4.w;
                tmp3.w = tmp3.w * 0.5 + 0.5;
                tmp3.w = tmp0.y * 0.01 + tmp3.w;
                tmp3.w = tmp3.w * _ScreenParams.y;
                tmp3.w = tmp3.w * 0.25;
                tmp3.w = frac(tmp3.w);
                tmp3.w = tmp3.w + tmp5.y;
                tmp3.w = tmp3.w + tmp3.w;
                tmp3.w = floor(tmp3.w);
                tmp3.w = tmp3.w - 1.0;
                tmp0.w = tmp0.w * tmp3.w + 1.0;
                tmp0.w = tmp1.x * tmp0.w + -0.5;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = dot(-tmp4.xyz, tmp1.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp4.xyz = tmp1.yzw * -tmp0.www + -tmp4.xyz;
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp4.xyz, tmp5.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp1.x = _GlossPower * 16.0 + -1.0;
                tmp1.x = exp(tmp1.x);
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.w = exp(tmp0.w);
                tmp1.x = saturate(tmp1.z * 0.75 + 0.25);
                tmp1.x = tmp1.x * 0.85 + 0.15;
                tmp1.x = tmp2.w + tmp1.x;
                tmp1.x = _Gloss * tmp0.w + tmp1.x;
                tmp0.w = tmp0.w * _Gloss;
                tmp4.xyz = tmp0.www * _LightColor0.xyz;
                tmp0.x = tmp0.x * 0.3333333 + tmp1.x;
                tmp0.w = tmp0.y * 3.0;
                tmp0.y = tmp0.y * 5.0;
                tmp0.y = sin(tmp0.y);
                tmp0.y = tmp0.y + tmp0.y;
                tmp0.y = tmp3.z * -abs(tmp0.y) + abs(tmp0.y);
                tmp0.y = tmp0.y * 0.333;
                tmp1.x = sin(tmp0.w);
                tmp6.x = cos(tmp0.w);
                tmp7.z = tmp1.x;
                tmp7.y = tmp6.x;
                tmp7.x = -tmp1.x;
                tmp6.y = dot(tmp3.xy, tmp7.xy);
                tmp6.x = dot(tmp3.xy, tmp7.xy);
                tmp3.xy = tmp6.xy + float2(0.5, 0.5);
                tmp3.xy = tmp3.xy * _Static_ST.xy + _Static_ST.zw;
                tmp3 = tex2D(_Static, tmp3.xy);
                tmp0.w = tmp3.x * 10.0 + -6.000002;
                tmp0.yw = max(tmp0.yw, float2(0.0, 0.0));
                tmp0.w = min(tmp0.w, 0.25);
                tmp0.x = tmp0.w + tmp0.x;
                tmp0.x = saturate(tmp0.y * 0.5 + tmp0.x);
                tmp0.y = tmp0.x * 2.0 + -1.0;
                tmp0.y = max(tmp0.y, 0.0);
                tmp3.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + _MiddleColor.xyz;
                tmp6.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp6.xyz = tmp0.xxx * tmp6.xyz + _BottomColor.xyz;
                tmp3.xyz = tmp3.xyz - tmp6.xyz;
                tmp0.xyw = tmp0.yyy * tmp3.xyz + tmp6.xyz;
                tmp3.xyz = tmp0.xyw * float3(0.2, 0.2, 0.2);
                tmp0.xyw = tmp0.xyw * float3(0.8, 0.8, 0.8);
                tmp0.xyw = tmp4.xyz * _Gloss.xxx + tmp0.xyw;
                tmp2.xyz = tmp2.xyz * tmp0.zzz + tmp5.xyz;
                tmp0.z = dot(tmp1.xyz, tmp5.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp1.x = dot(tmp2.xyz, tmp2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp2.xyz = tmp1.xxx * tmp2.xyz;
                tmp1.x = dot(tmp2.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * 32.0;
                tmp1.x = exp(tmp1.x);
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.1, 0.1, 0.1);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = tmp0.zzz * _LightColor0.xyz + tmp2.xyz;
                tmp1.xyz = tmp2.xyz * tmp3.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp0.xyw + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 66414
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			float _AvgCycleLength;
			float _CycleGlitchRatio;
			float _Fade;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Static_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Static;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = unity_ObjectToWorld._m23 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = frac(tmp0.x);
                tmp0.yz = _TimeEditor.yz + _Time.yz;
                tmp0.w = tmp0.x + tmp0.y;
                tmp0.x = tmp0.x * 10.0 + tmp0.z;
                tmp0.y = tmp0.y * 5.0;
                tmp0.xy = sin(tmp0.xy);
                tmp0.y = tmp0.y + tmp0.y;
                tmp0.y = abs(tmp0.y) * 0.05;
                tmp1.xyz = tmp0.yyy * v.normal.xyz;
                tmp0.x = tmp0.x * 0.5;
                tmp0.xy = frac(tmp0.xw);
                tmp0.y = tmp0.w + tmp0.y;
                tmp0.y = tmp0.y / _AvgCycleLength;
                tmp0.y = frac(tmp0.y);
                tmp0.z = _CycleGlitchRatio >= tmp0.y;
                tmp0.y = tmp0.y >= _CycleGlitchRatio;
                tmp0.zw = tmp0.zy ? 1.0 : 0.0;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.y = tmp0.y ? 0.0 : tmp0.z;
                tmp0.y = tmp0.y + tmp0.w;
                tmp0.z = v.color.w * _Fade;
                tmp0.z = tmp0.z * 4.0;
                tmp0.z = round(tmp0.z);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.z = tmp0.x * tmp0.z;
                tmp0.xyz = tmp0.xyz * float3(16.0, 0.25, 80.0);
                tmp0.xz = round(tmp0.xz);
                tmp0.w = tmp0.z + 0.2127;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * 0.3713 + tmp0.w;
                tmp0.w = tmp0.z * 489.123;
                tmp0.z = tmp0.z + 1.0;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 4.789;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = frac(tmp0.z);
                tmp0.y = tmp0.z * tmp0.y;
                tmp2 = v.vertex.yyyy * unity_ObjectToWorld._m01_m21_m01_m21;
                tmp2 = unity_ObjectToWorld._m00_m20_m00_m20 * v.vertex.xxxx + tmp2;
                tmp2 = unity_ObjectToWorld._m02_m22_m02_m22 * v.vertex.zzzz + tmp2;
                tmp2 = unity_ObjectToWorld._m03_m23_m03_m23 * v.vertex.wwww + tmp2;
                tmp2 = tmp0.xxxx + tmp2;
                tmp2 = tmp2 * float4(16.0, 16.0, 4.0, 4.0);
                tmp2 = floor(tmp2);
                tmp0.xz = tmp2.yw * float2(0.0666667, 0.3333333);
                tmp3 = tmp0.xxzz * tmp2.xxzz;
                tmp2 = tmp2 * float4(0.0666667, 0.0666667, 0.3333333, 0.3333333) + float4(0.2127, 0.2127, 0.2127, 0.2127);
                tmp2 = tmp3 * float4(0.0247533, 0.0247533, 0.1237667, 0.1237667) + tmp2;
                tmp3 = tmp2 * float4(489.123, 489.123, 489.123, 489.123);
                tmp0.xz = tmp2.xz + float2(1.0, 1.0);
                tmp2 = sin(tmp3);
                tmp2 = tmp2 * float4(4.789, 4.789, 4.789, 4.789);
                tmp2.xy = tmp2.yw * tmp2.xz;
                tmp0.xz = tmp0.xz * tmp2.xy;
                tmp0.xz = frac(tmp0.xz);
                tmp0.x = max(tmp0.z, tmp0.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = v.normal.xyz * float3(-0.02, 0.2, -0.02);
                tmp0.xyz = tmp0.yzw * tmp0.xxx + tmp1.xyz;
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
                tmp1.x = tmp0.z + tmp1.x;
                tmp1.y = min(tmp0.w, tmp1.x);
                tmp1.y = tmp1.y - tmp1.x;
                o.position.z = unity_LightShadowBias.y * tmp1.y + tmp1.x;
                o.position.xyw = tmp0.xyw;
                o.texcoord3 = tmp0;
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
                float4 tmp3;
                float4 tmp4;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xy = tmp0.yy * unity_MatrixV._m01_m11;
                tmp1.xy = unity_MatrixV._m00_m10 * tmp0.xx + tmp1.xy;
                tmp1.xy = unity_MatrixV._m02_m12 * tmp0.zz + tmp1.xy;
                tmp1.xy = tmp1.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0.w = unity_ObjectToWorld._m23 + unity_ObjectToWorld._m03;
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = frac(tmp0.w);
                tmp1.zw = _TimeEditor.yz + _Time.yz;
                tmp1.w = tmp0.w * 10.0 + tmp1.w;
                tmp1.w = sin(tmp1.w);
                tmp1.w = tmp1.w * 0.5;
                tmp1.w = frac(tmp1.w);
                tmp2.x = tmp1.w * 16.0;
                tmp2.x = round(tmp2.x);
                tmp2.xy = tmp1.xy + tmp2.xx;
                tmp1.xy = tmp0.ww + tmp1.xy;
                tmp0.w = tmp0.w + tmp1.z;
                tmp1.xy = tmp1.zz * float2(0.75, -0.25) + tmp1.xy;
                tmp1.xy = tmp1.xy * _Static_ST.xy + _Static_ST.zw;
                tmp3 = tex2D(_Static, tmp1.xy);
                tmp1.xy = tmp0.ww * float2(0.5, 0.25);
                tmp1.xy = frac(tmp1.xy);
                tmp1.xy = tmp1.xy * float2(64.0, 4.0);
                tmp1.xy = round(tmp1.xy);
                tmp2.zw = tmp1.xy * float2(0.125, 0.5);
                tmp4.zw = floor(tmp2.zw);
                tmp4.y = -tmp4.z * 8.0 + tmp1.x;
                tmp4.x = -tmp4.w * 2.0 + tmp1.y;
                tmp1.xy = tmp2.xy + tmp4.xw;
                tmp2.xy = tmp2.xy + tmp4.yz;
                tmp2.xy = tmp2.xy * _Static_ST.xy;
                tmp2.xy = tmp2.xy * float2(0.125, 0.125) + _Static_ST.zw;
                tmp2 = tex2D(_Static, tmp2.xy);
                tmp1.xy = tmp1.xy * _Static_ST.xy;
                tmp1.xy = tmp1.xy * float2(0.5, 0.5) + _Static_ST.zw;
                tmp4 = tex2D(_Static, tmp1.xy);
                tmp1.x = max(tmp2.z, tmp4.z);
                tmp1.x = tmp1.x + tmp3.y;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.y = dot(tmp2.xyz, tmp2.xyz);
                tmp1.y = rsqrt(tmp1.y);
                tmp2.xyz = tmp1.yyy * tmp2.xyz;
                tmp0.x = dot(tmp0.xyz, tmp2.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = log(tmp0.x);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = saturate(tmp0.x * 1.666667 + -0.3333333);
                tmp0.y = tmp0.y * 1.25;
                tmp0.y = exp(tmp0.y);
                tmp0.z = tmp1.w * tmp1.w;
                tmp0.yz = tmp1.xw * tmp0.yz;
                tmp0.z = tmp0.z * 80.0;
                tmp0.z = round(tmp0.z);
                tmp1.x = tmp0.z + 0.2127;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * 0.3713 + tmp1.x;
                tmp1.x = tmp0.z * 489.123;
                tmp0.z = tmp0.z + 1.0;
                tmp1.x = sin(tmp1.x);
                tmp1.x = tmp1.x * 4.789;
                tmp1.x = tmp1.x * tmp1.x;
                tmp0.z = tmp0.z * tmp1.x;
                tmp0.z = frac(tmp0.z);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = frac(tmp0.w);
                tmp0.z = tmp0.w + tmp0.z;
                tmp0.z = tmp0.z / _AvgCycleLength;
                tmp0.z = frac(tmp0.z);
                tmp0.w = _CycleGlitchRatio >= tmp0.z;
                tmp0.z = tmp0.z >= _CycleGlitchRatio;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp1.x = tmp0.z ? 1.0 : 0.0;
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.z = tmp0.z ? 0.0 : tmp0.w;
                tmp0.z = tmp0.z + tmp1.x;
                tmp0.w = inp.color.w * _Fade;
                tmp0.w = tmp0.w * 4.0;
                tmp0.w = round(tmp0.w);
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = tmp0.z * 0.25;
                tmp0.y = saturate(-tmp0.z * tmp0.y + 1.0);
                tmp0.x = tmp0.y - tmp0.x;
                tmp0.x = tmp0.x + 1.0;
                tmp0.x = saturate(tmp0.x * 20.0 + -14.0);
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.y = inp.texcoord3.y / inp.texcoord3.w;
                tmp0.w = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.y = tmp0.y * 0.5 + 0.5;
                tmp0.y = tmp1.z * 0.01 + tmp0.y;
                tmp0.y = tmp0.y * _ScreenParams.y;
                tmp0.y = tmp0.y * 0.25;
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.y + tmp3.y;
                tmp0.y = tmp0.y + tmp0.y;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y - 1.0;
                tmp0.y = tmp0.z * tmp0.y + 1.0;
                tmp0.x = tmp0.x * tmp0.y + -0.5;
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