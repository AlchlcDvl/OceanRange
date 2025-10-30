Shader "SR/Slime/Body Quantum" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		[MaterialToggle] _UseOverride ("Use Override", Float) = 0.6818095
		_CubemapOverride ("Cubemap Override", 2D) = "gray" {}
		_StripeTexture ("Stripe Texture", 2D) = "white" {}
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		[MaterialToggle] _GhostToggle ("GhostToggle", Float) = 0
		_AvgCycleLength ("AvgCycleLength", Range(1, 10)) = 3
		_CycleGlitchRatio ("CycleGlitchRatio", Range(0, 1)) = 1
		_Fade ("Fade", Range(0, 1)) = 1
		_Static ("Static", 2D) = "black" {}
		_Cracks ("Cracks", Cube) = "_Skybox" {}
		_Char ("Char", Range(0, 1)) = 0
		_CrackAmount ("Crack Amount", Range(0, 1)) = 0
		[MaterialToggle] _RadToggle ("RadToggle", Float) = 0
		_Normal ("Normal", 2D) = "bump" {}
		[MaterialToggle] _PhosToggle ("PhosToggle", Float) = 0
		_NormalSpeed ("NormalSpeed", Float) = 1
		[MaterialToggle] _StripeUV1 ("Stripe UV1", Float) = 0
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 8798
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
				float4 color : COLOR0;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _AvgCycleLength;
			float _CycleGlitchRatio;
			float _Fade;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float _UseOverride;
			float4 _CubemapOverride_ST;
			float4 _StripeTexture_ST;
			float _Gloss;
			float _GlossPower;
			float4 _Static_ST;
			float _CrackAmount;
			float _Char;
			float _RadToggle;
			float4 _Normal_ST;
			float _PhosToggle;
			float _NormalSpeed;
			float _GhostToggle;
			float _StripeUV1;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _Static;
			sampler2D _StripeTexture;
			samplerCUBE _Cracks;
			sampler2D _CubemapOverride;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = unity_ObjectToWorld._m23 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = frac(tmp0.x);
                tmp0.y = tmp0.x + _Time.y;
                tmp0.x = tmp0.x * 10.0 + _Time.z;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 0.5;
                tmp0.xz = frac(tmp0.xy);
                tmp0.y = tmp0.y + tmp0.z;
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
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m21_m01_m21;
                tmp1 = unity_ObjectToWorld._m00_m20_m00_m20 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m22_m02_m22 * v.vertex.zzzz + tmp1;
                tmp1 = unity_ObjectToWorld._m03_m23_m03_m23 * v.vertex.wwww + tmp1;
                tmp1 = tmp0.xxxx + tmp1;
                tmp1 = tmp1 * float4(16.0, 16.0, 4.0, 4.0);
                tmp1 = floor(tmp1);
                tmp0.xz = tmp1.yw * float2(0.0666667, 0.3333333);
                tmp2 = tmp0.xxzz * tmp1.xxzz;
                tmp1 = tmp1 * float4(0.0666667, 0.0666667, 0.3333333, 0.3333333) + float4(0.2127, 0.2127, 0.2127, 0.2127);
                tmp1 = tmp2 * float4(0.0247533, 0.0247533, 0.1237667, 0.1237667) + tmp1;
                tmp2 = tmp1 * float4(489.123, 489.123, 489.123, 489.123);
                tmp0.xz = tmp1.xz + float2(1.0, 1.0);
                tmp1 = sin(tmp2);
                tmp1 = tmp1 * float4(4.789, 4.789, 4.789, 4.789);
                tmp1.xy = tmp1.yw * tmp1.xz;
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = frac(tmp0.xz);
                tmp0.x = max(tmp0.z, tmp0.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = v.normal.xyz * float3(-0.02, 0.2, -0.02);
                tmp0.xyz = tmp0.yzw * tmp0.xxx + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                o.texcoord3.xyz = tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp3.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp3.xyz;
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp3.xyz;
                o.texcoord4.xyz = tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx;
                tmp2.xyz = tmp2.yzx * tmp3.zxy + -tmp4.xyz;
                tmp2.xyz = tmp2.xyz * v.tangent.www;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                o.texcoord5.xyz = tmp0.zzz * tmp2.xyz;
                o.color = v.color;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord6.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord6.w = tmp0.w;
                o.texcoord6.xy = tmp1.zz + tmp1.xw;
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
                tmp0.x = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord3.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = _NormalSpeed * _Time.y;
                tmp3.xy = tmp1.ww * float2(0.05, 0.125) + inp.texcoord.xy;
                tmp3.xy = tmp3.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp3 = tex2D(_Normal, tmp3.xy);
                tmp3.x = tmp3.w * tmp3.x;
                tmp4.xy = tmp3.xy + tmp3.xy;
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp3.xy, tmp3.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp4.z = sqrt(tmp1.w);
                tmp1.w = 1.0 - inp.texcoord.y;
                tmp1.w = tmp1.w + tmp1.w;
                tmp3.xyz = tmp4.xyz - float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp1.www * tmp3.xyz + float3(0.0, 0.0, 1.0);
                tmp4.xyz = tmp3.yyy * inp.texcoord5.xyz;
                tmp3.xyw = tmp3.xxx * inp.texcoord4.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.zzz * tmp0.xyz + tmp3.xyw;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp3.xyz;
                tmp1.w = dot(-tmp2.xyz, tmp3.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp4.xyz = tmp3.xyz * -tmp1.www + -tmp2.xyz;
                tmp5.xy = inp.texcoord6.xy / inp.texcoord6.ww;
                tmp1.w = inp.color.w * _Fade;
                tmp2.w = unity_ObjectToWorld._m23 + unity_ObjectToWorld._m03;
                tmp2.w = tmp2.w * 0.5;
                tmp2.w = frac(tmp2.w);
                tmp3.w = tmp2.w + _Time.y;
                tmp4.w = frac(tmp3.w);
                tmp4.w = tmp3.w + tmp4.w;
                tmp4.w = tmp4.w / _AvgCycleLength;
                tmp4.w = frac(tmp4.w);
                tmp5.w = _CycleGlitchRatio >= tmp4.w;
                tmp5.w = tmp5.w ? 1.0 : 0.0;
                tmp4.w = tmp4.w >= _CycleGlitchRatio;
                tmp6.x = tmp4.w ? 1.0 : 0.0;
                tmp1.w = tmp1.w * 4.0;
                tmp1.w = round(tmp1.w);
                tmp5.w = tmp5.w * tmp6.x;
                tmp4.w = tmp4.w ? 0.0 : tmp5.w;
                tmp4.w = tmp4.w + tmp6.x;
                tmp1.w = tmp1.w * tmp4.w;
                tmp1.w = tmp1.w * 0.25;
                tmp4.w = tmp2.w * 10.0 + _Time.z;
                tmp4.w = sin(tmp4.w);
                tmp4.w = tmp4.w * 0.5;
                tmp4.w = frac(tmp4.w);
                tmp5.w = tmp4.w * tmp4.w;
                tmp5.w = tmp4.w * tmp5.w;
                tmp5.zw = tmp5.xw * float2(1.78, 80.0);
                tmp5.w = round(tmp5.w);
                tmp6.x = tmp5.w + 0.2127;
                tmp5.w = tmp5.w * tmp5.w;
                tmp5.w = tmp5.w * 0.3713 + tmp6.x;
                tmp6.x = tmp5.w * 489.123;
                tmp6.x = sin(tmp6.x);
                tmp6.x = tmp6.x * 4.789;
                tmp6.x = tmp6.x * tmp6.x;
                tmp5.w = tmp5.w + 1.0;
                tmp5.w = tmp5.w * tmp6.x;
                tmp5.w = frac(tmp5.w);
                tmp6.xy = tmp0.yy * unity_MatrixV._m01_m11;
                tmp6.xy = unity_MatrixV._m00_m10 * tmp0.xx + tmp6.xy;
                tmp6.xy = unity_MatrixV._m02_m12 * tmp0.zz + tmp6.xy;
                tmp6.zw = tmp6.xy * float2(0.5, 0.5);
                tmp6.xy = tmp6.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp7.xy = tmp2.ww + tmp6.xy;
                tmp2.w = _Time.y * 3.0;
                tmp7.xy = _Time.yy * float2(0.75, -0.25) + tmp7.xy;
                tmp7.xy = tmp7.xy * _Static_ST.xy + _Static_ST.zw;
                tmp7 = tex2D(_Static, tmp7.xy);
                tmp7.xz = tmp3.ww * float2(0.5, 0.25);
                tmp7.xz = frac(tmp7.xz);
                tmp7.xz = tmp7.xz * float2(64.0, 4.0);
                tmp7.xz = round(tmp7.xz);
                tmp8.xy = tmp7.xz * float2(0.125, 0.5);
                tmp8.zw = floor(tmp8.xy);
                tmp8.y = -tmp8.z * 8.0 + tmp7.x;
                tmp3.w = tmp4.w * 16.0;
                tmp3.w = round(tmp3.w);
                tmp7.xw = tmp6.xy + tmp3.ww;
                tmp8.yz = tmp8.yz + tmp7.xw;
                tmp8.yz = tmp8.yz * _Static_ST.xy;
                tmp8.yz = tmp8.yz * float2(0.125, 0.125) + _Static_ST.zw;
                tmp9 = tex2D(_Static, tmp8.yz);
                tmp8.x = -tmp8.w * 2.0 + tmp7.z;
                tmp7.xz = tmp8.xw + tmp7.xw;
                tmp7.xz = tmp7.xz * _Static_ST.xy;
                tmp7.xz = tmp7.xz * float2(0.5, 0.5) + _Static_ST.zw;
                tmp8 = tex2D(_Static, tmp7.xz);
                tmp4.w = max(tmp8.z, tmp9.z);
                tmp2.x = dot(tmp3.xyz, tmp2.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.x = 1.0 - tmp2.x;
                tmp2.y = log(tmp2.x);
                tmp2.yz = tmp2.yy * float2(1.25, 0.9);
                tmp2.yz = exp(tmp2.yz);
                tmp4.w = tmp4.w + tmp7.y;
                tmp2.y = tmp2.y * tmp4.w;
                tmp2.y = tmp2.y * tmp5.w;
                tmp4.w = tmp1.w * tmp2.y;
                tmp2.y = saturate(-tmp1.w * tmp2.y + 1.0);
                tmp5.w = rsqrt(tmp2.x);
                tmp5.w = 1.0 / tmp5.w;
                tmp5.w = saturate(tmp5.w * 1.666667 + -0.3333333);
                tmp2.y = tmp2.y - tmp5.w;
                tmp2.y = tmp2.y + 1.0;
                tmp2.y = saturate(tmp2.y * 20.0 + -14.0);
                tmp5.w = _Time.y * 0.01 + tmp5.y;
                tmp5.w = tmp5.w * _ScreenParams.y;
                tmp5.w = tmp5.w * 0.25;
                tmp5.w = frac(tmp5.w);
                tmp5.w = tmp5.w + tmp7.y;
                tmp5.w = tmp5.w + tmp5.w;
                tmp5.w = floor(tmp5.w);
                tmp7.x = tmp5.w - 1.0;
                tmp7.x = tmp1.w * tmp7.x + 1.0;
                tmp2.y = tmp2.y * tmp2.y;
                tmp7.y = tmp7.x * tmp2.y;
                tmp5.w = 1.0 - tmp5.w;
                tmp2.y = -tmp2.y * tmp7.x + tmp5.w;
                tmp2.y = _GhostToggle * tmp2.y + tmp7.y;
                tmp2.y = tmp2.y - 0.5;
                tmp2.y = tmp2.y < 0.0;
                if (tmp2.y) {
                    discard;
                }
                tmp2.y = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp7.xyz = tmp2.yyy * _WorldSpaceLightPos0.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp7.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 32.0;
                tmp0.w = exp(tmp0.w);
                tmp1.xyz = tmp0.www * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.1, 0.1, 0.1);
                tmp0.w = dot(tmp3.xyz, tmp7.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp8 = _Time * float4(0.01, -0.5, -0.01, -0.25) + inp.texcoord.xyxy;
                tmp8 = tmp8 * float4(6.0, 6.0, 4.0, 4.0);
                tmp2.y = 0.0;
                tmp5.w = 0.0;
                while (true) {
                    tmp7.w = i >= 6;
                    if (tmp7.w) {
                        break;
                    }
                    i = i + 1;
                    tmp9.xy = tmp7.ww * tmp8.xy;
                    tmp9.zw = floor(tmp9.xy);
                    tmp9.xy = frac(tmp9.xy);
                    tmp10.xy = tmp9.xy * tmp9.xy;
                    tmp9.xy = -tmp9.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp9.xy = tmp9.xy * tmp10.xy;
                    tmp7.w = tmp9.w * 57.0 + tmp9.z;
                    tmp10.xyz = tmp7.www + float3(1.0, 57.0, 58.0);
                    tmp11.x = sin(tmp7.w);
                    tmp11.yzw = sin(tmp10.xyz);
                    tmp10 = tmp11 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp10 = frac(tmp10);
                    tmp9.zw = tmp10.yw - tmp10.xz;
                    tmp9.xz = tmp9.xx * tmp9.zw + tmp10.xz;
                    tmp7.w = tmp9.z - tmp9.x;
                    tmp7.w = tmp9.y * tmp7.w + tmp9.x;
                    tmp9.x = null.x / 6;
                    tmp2.y = tmp7.w * tmp9.x + tmp2.y;
                }
                tmp2.y = tmp2.y * 0.1666667;
                tmp5.w = tmp2.y * tmp2.y;
                tmp7.w = tmp2.y * tmp5.w;
                tmp8.xy = float2(0.0, 0.0);
                while (true) {
                    tmp9.x = i >= 4;
                    if (tmp9.x) {
                        break;
                    }
                    i = i + 1;
                    tmp9.xy = tmp8.zw * tmp9.xx;
                    tmp9.zw = floor(tmp9.xy);
                    tmp9.xy = frac(tmp9.xy);
                    tmp10.xy = tmp9.xy * tmp9.xy;
                    tmp9.xy = -tmp9.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp9.xy = tmp9.xy * tmp10.xy;
                    tmp9.z = tmp9.w * 57.0 + tmp9.z;
                    tmp10.xyz = tmp9.zzz + float3(1.0, 57.0, 58.0);
                    tmp11.x = sin(tmp9.z);
                    tmp11.yzw = sin(tmp10.xyz);
                    tmp10 = tmp11 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp10 = frac(tmp10);
                    tmp9.zw = tmp10.yw - tmp10.xz;
                    tmp9.xz = tmp9.xx * tmp9.zw + tmp10.xz;
                    tmp9.z = tmp9.z - tmp9.x;
                    tmp9.x = tmp9.y * tmp9.z + tmp9.x;
                    tmp9.y = null.y / 4;
                    tmp8.x = tmp9.x * tmp9.y + tmp8.x;
                }
                tmp8.x = tmp8.x * 0.25;
                tmp4.x = dot(tmp4.xyz, tmp7.xyz);
                tmp4.x = max(tmp4.x, 0.0);
                tmp4.y = _GlossPower * 16.0 + -1.0;
                tmp4.y = exp(tmp4.y);
                tmp4.x = log(tmp4.x);
                tmp4.x = tmp4.x * tmp4.y;
                tmp4.x = exp(tmp4.x);
                tmp4.x = tmp4.x * _Gloss;
                tmp4.yz = inp.texcoord1.xy - inp.texcoord.xy;
                tmp4.yz = _StripeUV1.xx * tmp4.yz + inp.texcoord.xy;
                tmp4.yz = tmp4.yz * _StripeTexture_ST.xy + _StripeTexture_ST.zw;
                tmp9 = tex2D(_StripeTexture, tmp4.yz);
                tmp9.x = saturate(tmp9.x);
                tmp4.y = tmp4.w * 4.0;
                tmp4.y = floor(tmp4.y);
                tmp7.x = sin(tmp2.w);
                tmp10.x = cos(tmp2.w);
                tmp11.x = -tmp7.x;
                tmp11.y = tmp10.x;
                tmp11.z = tmp7.x;
                tmp7.x = dot(tmp6.xy, tmp11.xy);
                tmp7.y = dot(tmp6.xy, tmp11.xy);
                tmp4.zw = tmp7.xy + float2(0.5, 0.5);
                tmp4.zw = tmp4.zw * _Static_ST.xy + _Static_ST.zw;
                tmp10 = tex2D(_Static, tmp4.zw);
                tmp2.w = tmp10.x * 10.0 + -6.000002;
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = min(tmp2.w, 0.25);
                tmp2.z = tmp2.z * -3.0 + 1.0;
                tmp4.z = _Time.y * 0.8;
                tmp4.z = sin(tmp4.z);
                tmp4.z = tmp4.z * 2.0 + -1.0;
                tmp4.z = max(tmp4.z, 0.0);
                tmp4.z = tmp2.z * tmp4.z;
                tmp4.w = tmp4.z * _PhosToggle;
                tmp6.z = tmp8.x * tmp8.x;
                tmp6.w = tmp8.x * tmp6.z;
                tmp7.x = tmp6.w > 0.5;
                tmp6.z = tmp6.z * tmp8.x + -0.5;
                tmp6.z = -tmp6.z * 2.0 + 1.0;
                tmp2.y = -tmp5.w * tmp2.y + 1.0;
                tmp5.w = -tmp6.z * tmp2.y + 1.0;
                tmp6.z = dot(tmp7.xy, tmp6.xy);
                tmp5.w = saturate(tmp7.x ? tmp5.w : tmp6.z);
                tmp5.w = tmp2.x * tmp5.w;
                tmp5.w = tmp5.w * 3.0;
                tmp5.w = floor(tmp5.w);
                tmp5.w = tmp5.w * 0.2;
                tmp5.w = tmp5.w * _RadToggle;
                tmp6.z = saturate(tmp0.y * 0.75 + 0.25);
                tmp6.z = tmp6.z * 0.85 + 0.15;
                tmp6.w = tmp2.x * tmp2.x;
                tmp6.w = min(tmp6.w, 1.0);
                tmp6.z = tmp6.w + tmp6.z;
                tmp6.z = tmp6.z * tmp9.x;
                tmp7.xyz = float3(_CrackAmount.x, _RadToggle.xx) * float3(-0.5, -0.2, 0.45) + float3(1.0, 0.2, 0.8);
                tmp6.z = tmp6.z * tmp7.x + tmp4.x;
                tmp4.y = tmp4.y * 0.3333333 + tmp6.z;
                tmp2.w = tmp2.w + tmp4.y;
                tmp2.w = tmp5.w * 0.5 + tmp2.w;
                tmp2.w = saturate(tmp4.z * _PhosToggle + tmp2.w);
                tmp5 = tmp3.wwww * float4(10.0, 10.0, 10.0, 10.0) + tmp5.zyzy;
                tmp8 = _ScreenParams * float4(0.025, 0.025, 0.05, 0.05);
                tmp5 = tmp5 * tmp8;
                tmp5 = floor(tmp5);
                tmp8 = _ScreenParams * float4(0.025, 0.025, 0.05, 0.05) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp5 = tmp5 / tmp8;
                tmp8 = tmp5 + float4(0.2127, 0.2127, 0.2127, 0.2127);
                tmp5 = tmp5.yyww * tmp5.xxzz;
                tmp5 = tmp5 * float4(0.3713, 0.3713, 0.3713, 0.3713) + tmp8;
                tmp8 = tmp5 * float4(489.123, 489.123, 489.123, 489.123);
                tmp8 = sin(tmp8);
                tmp8 = tmp8 * float4(4.789, 4.789, 4.789, 4.789);
                tmp4.yz = tmp8.yw * tmp8.xz;
                tmp5.xy = tmp5.xz + float2(1.0, 1.0);
                tmp4.yz = tmp4.yz * tmp5.xy;
                tmp4.yz = frac(tmp4.yz);
                tmp3.w = max(tmp4.z, tmp4.y);
                tmp3.w = tmp3.w * 4.0;
                tmp3.w = floor(tmp3.w);
                tmp3.w = tmp3.w * 0.3333333;
                tmp3.w = tmp3.w * _GhostToggle;
                tmp4.yz = tmp2.ww * float2(-2.0, 0.25) + float2(1.0, 0.25);
                tmp2.w = tmp3.w * tmp4.y + tmp2.w;
                tmp5.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp5.xyz = tmp2.www * tmp5.xyz + _BottomColor.xyz;
                tmp8.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp8.xyz = tmp2.www * tmp8.xyz + _MiddleColor.xyz;
                tmp2.w = saturate(tmp2.w * 2.0 + -1.0);
                tmp8.xyz = tmp8.xyz - tmp5.xyz;
                tmp5.xyz = tmp2.www * tmp8.xyz + tmp5.xyz;
                tmp8.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp8.xyz = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp8.xyz;
                tmp0.xyz = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp8.xyz;
                tmp8 = texCUBE(_Cracks, tmp0.xyz);
                tmp4.w = saturate(tmp4.w);
                tmp0.xyz = tmp8.xyz * float3(-0.25, -0.25, -0.25) + float3(1.0, 1.0, 1.0);
                tmp2.w = dot(tmp5.xyz, float3(0.3, 0.59, 0.11));
                tmp8.yzw = tmp2.www - tmp5.xyz;
                tmp8.yzw = tmp8.yzw * float3(0.5, 0.5, 0.5) + tmp5.xyz;
                tmp0.xyz = tmp0.xyz * tmp8.yzw;
                tmp0.xyz = tmp0.xyz * float3(0.75, 0.75, 0.75) + -tmp5.xyz;
                tmp0.xyz = _Char.xxx * tmp0.xyz + tmp5.xyz;
                tmp0.xyz = tmp4.www * float3(1.0, 1.0, 0.0) + tmp0.xyz;
                tmp5.xyz = tmp7.yyy * tmp0.xyz;
                tmp3.xyz = tmp0.www * _LightColor0.xyz + tmp3.xyz;
                tmp7.xyw = tmp7.zzz * tmp0.xyz;
                tmp4.yw = tmp6.xy * _CubemapOverride_ST.xy + _CubemapOverride_ST.zw;
                tmp6 = tex2D(_CubemapOverride, tmp4.yw);
                tmp10.x = tmp2.z * _CrackAmount;
                tmp0.w = tmp2.x * -1.5 + 1.5;
                tmp0.w = tmp0.w * tmp8.x;
                tmp0.w = tmp0.w * _CrackAmount;
                tmp0.w = tmp0.w * 10.0;
                tmp2.x = tmp9.x * 9.999998 + -8.999998;
                tmp0.w = dot(tmp0.xy, tmp2.xy);
                tmp0.w = floor(tmp0.w);
                tmp2.xzw = tmp4.xxx * _LightColor0.xyz;
                tmp4.xyw = tmp6.xyz > float3(0.5, 0.5, 0.5);
                tmp8.xyz = tmp6.xyz - float3(0.5, 0.5, 0.5);
                tmp8.xyz = -tmp8.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.w = 1.0 - tmp4.z;
                tmp8.xyz = -tmp8.xyz * tmp5.www + float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp4.zzz * tmp6.xyz;
                tmp6.xyz = tmp6.xyz + tmp6.xyz;
                tmp4.xyz = saturate(tmp4.xyw ? tmp8.xyz : tmp6.xyz);
                tmp4.xyz = tmp9.xxx + tmp4.xyz;
                tmp4.xyz = tmp4.xyz - float3(1.0, 1.0, 1.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = -tmp0.xyz * tmp7.zzz + tmp4.xyz;
                tmp0.xyz = tmp0.xyz * tmp6.www;
                tmp0.xyz = _UseOverride.xxx * tmp0.xyz + tmp7.xyw;
                tmp0.xyz = tmp2.xzw * _Gloss.xxx + tmp0.xyz;
                tmp10.yzw = tmp2.yyy * float3(0.0, 0.3310345, 0.0) + float3(1.0, 0.1862069, 0.0);
                tmp2.xzw = tmp2.yyy * float3(0.0, 0.3724138, 0.0) + float3(1.0, 0.5172414, 0.0);
                tmp2.xzw = tmp2.xzw - tmp10.yzw;
                tmp4.xyz = tmp10.xxx * tmp2.xzw + tmp10.xzx;
                tmp4.xyz = tmp10.yxw + tmp4.xyz;
                tmp4.xyz = saturate(tmp4.xyz - float3(1.0, 1.0, 1.0));
                tmp4.w = 1.0 - tmp0.w;
                tmp2.y = tmp4.w / tmp2.y;
                tmp2.y = saturate(1.0 - tmp2.y);
                tmp2.y = tmp0.w * 0.667 + tmp2.y;
                tmp2.xyz = tmp2.yyy * tmp2.xzw + tmp10.yzw;
                tmp2.xyz = saturate(tmp0.www * tmp2.xyz);
                tmp2.xyz = tmp2.xyz + tmp4.xyz;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp0.w = tmp1.w * tmp3.w;
                tmp2.xyz = tmp0.xyz * float3(-2.0, -2.0, -2.0) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.www * tmp2.xyz + tmp0.xyz;
                tmp1.xyz = tmp3.xyz * tmp5.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 103043
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
			float _AvgCycleLength;
			float _CycleGlitchRatio;
			float _Fade;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Static_ST;
			float _GhostToggle;
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
                tmp0.x = unity_ObjectToWorld._m23 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = frac(tmp0.x);
                tmp0.y = tmp0.x + _Time.y;
                tmp0.x = tmp0.x * 10.0 + _Time.z;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 0.5;
                tmp0.xz = frac(tmp0.xy);
                tmp0.y = tmp0.y + tmp0.z;
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
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m21_m01_m21;
                tmp1 = unity_ObjectToWorld._m00_m20_m00_m20 * v.vertex.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m22_m02_m22 * v.vertex.zzzz + tmp1;
                tmp1 = unity_ObjectToWorld._m03_m23_m03_m23 * v.vertex.wwww + tmp1;
                tmp1 = tmp0.xxxx + tmp1;
                tmp1 = tmp1 * float4(16.0, 16.0, 4.0, 4.0);
                tmp1 = floor(tmp1);
                tmp0.xz = tmp1.yw * float2(0.0666667, 0.3333333);
                tmp2 = tmp0.xxzz * tmp1.xxzz;
                tmp1 = tmp1 * float4(0.0666667, 0.0666667, 0.3333333, 0.3333333) + float4(0.2127, 0.2127, 0.2127, 0.2127);
                tmp1 = tmp2 * float4(0.0247533, 0.0247533, 0.1237667, 0.1237667) + tmp1;
                tmp2 = tmp1 * float4(489.123, 489.123, 489.123, 489.123);
                tmp0.xz = tmp1.xz + float2(1.0, 1.0);
                tmp1 = sin(tmp2);
                tmp1 = tmp1 * float4(4.789, 4.789, 4.789, 4.789);
                tmp1.xy = tmp1.yw * tmp1.xz;
                tmp0.xz = tmp0.xz * tmp1.xy;
                tmp0.xz = frac(tmp0.xz);
                tmp0.x = max(tmp0.z, tmp0.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = v.normal.xyz * float3(-0.02, 0.2, -0.02);
                tmp0.xyz = tmp0.yzw * tmp0.xxx + v.vertex.xyz;
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
                tmp1.z = tmp0.w * 10.0 + _Time.z;
                tmp1.z = sin(tmp1.z);
                tmp1.z = tmp1.z * 0.5;
                tmp1.z = frac(tmp1.z);
                tmp1.w = tmp1.z * 16.0;
                tmp1.w = round(tmp1.w);
                tmp2.xy = tmp1.xy + tmp1.ww;
                tmp1.xy = tmp0.ww + tmp1.xy;
                tmp0.w = tmp0.w + _Time.y;
                tmp1.xy = _Time.yy * float2(0.75, -0.25) + tmp1.xy;
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
                tmp0.z = tmp1.z * tmp1.z;
                tmp0.yz = tmp1.xz * tmp0.yz;
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
                tmp0.y = _Time.y * 0.01 + tmp0.y;
                tmp0.y = tmp0.y * _ScreenParams.y;
                tmp0.y = tmp0.y * 0.25;
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.y + tmp3.y;
                tmp0.y = tmp0.y + tmp0.y;
                tmp0.y = floor(tmp0.y);
                tmp0.w = tmp0.y - 1.0;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.z = tmp0.z * tmp0.w + 1.0;
                tmp0.y = -tmp0.x * tmp0.z + tmp0.y;
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.x = _GhostToggle * tmp0.y + tmp0.x;
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