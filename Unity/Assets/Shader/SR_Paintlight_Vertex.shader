Shader "SR/Paintlight/Vertex" {
	Properties {
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		_DetailTex ("Detail Tex", 2D) = "white" {}
		_PrimaryTexGreen ("PrimaryTex Green", 2D) = "white" {}
		_DetailTexGreen ("Detail Tex Green", 2D) = "white" {}
		_PrimaryTexBlue ("PrimaryTex Blue", 2D) = "white" {}
		_DetailTexBlue ("Detail Tex Blue", 2D) = "white" {}
		_PrimaryTexBlack ("PrimaryTex Black", 2D) = "white" {}
		_DetailTexBlack ("Detail Tex Black", 2D) = "white" {}
		_Topper_MainTex ("Topper _MainTex", 2D) = "white" {}
		_TopperDetail ("Topper Detail", 2D) = "white" {}
		_TopperCoverage ("Topper Coverage", Range(0, 2)) = 1
		_ToporBottom ("Top or Bottom", Range(0, 1)) = 0
		_DetailNoiseMask ("Detail Noise Mask", 2D) = "black" {}
		_TopperDepthStrength ("Topper Depth Strength", Float) = 0
		_RampOffset ("Ramp Offset", Float) = 2
		_RampScale ("Ramp Scale", Float) = 0
		_RampUpper ("RampUpper", Color) = (0.4,0.3,0.5,1)
		_SeaLevelRampOffset ("SeaLevelRamp Offset", Float) = -3
		_SeaLevelRampScale ("SeaLevelRamp Scale", Float) = 1
		_SeaLevelRampLower ("SeaLevelRampLower", Color) = (0.3,0.4,0.3,1)
		[MaterialToggle] _BlueAlphaasEmission ("Blue Alpha as Emission", Float) = 0
		_BlueEmissionColor ("Blue Emission Color", Color) = (1,1,1,1)
		_BlueEmissiveDirection ("Blue Emissive Direction", Range(0, 1)) = 0
		_PaintRim ("Paint Rim", Range(0, 1)) = 1
		[MaterialToggle] _PaintRimDepth ("Paint Rim Depth", Float) = 0
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 45981
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _PrimaryTex_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float4 _PrimaryTexGreen_ST;
			float4 _PrimaryTexBlue_ST;
			float4 _DetailTexBlue_ST;
			float4 _PrimaryTexBlack_ST;
			float4 _DetailTexBlack_ST;
			float _TopperDepthStrength;
			float _TopperCoverage;
			float _ToporBottom;
			float4 _SeaLevelRampLower;
			float4 _RampUpper;
			float _RampOffset;
			float _RampScale;
			float _SeaLevelRampScale;
			float _SeaLevelRampOffset;
			float4 _Topper_MainTex_ST;
			float4 _TopperDetail_ST;
			float _BlueAlphaasEmission;
			float4 _BlueEmissionColor;
			float _BlueEmissiveDirection;
			float4 _DetailTexGreen_ST;
			float _PaintRim;
			float _PaintRimDepth;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _PrimaryTexGreen;
			sampler2D _DetailTexGreen;
			sampler2D _DetailNoiseMask;
			sampler2D _PrimaryTex;
			sampler2D _DetailTex;
			sampler2D _PrimaryTexBlue;
			sampler2D _DetailTexBlue;
			sampler2D _PrimaryTexBlack;
			sampler2D _DetailTexBlack;
			sampler2D _Topper_MainTex;
			sampler2D _TopperDetail;
			
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
                o.texcoord = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
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
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                float4 tmp11;
                tmp0 = inp.texcoord.zxxy * _DetailTex_ST + _DetailTex_ST;
                tmp1 = tex2D(_DetailTex, tmp0.zw);
                tmp0 = tex2D(_DetailTex, tmp0.xy);
                tmp2.xy = inp.texcoord.yz - float2(0.5, 0.5);
                tmp3.x = dot(tmp2.xy, float2(0.0007963, -0.9999997));
                tmp3.y = dot(tmp2.xy, float2(0.9999997, 0.0007963));
                tmp2.xy = tmp3.xy + float2(0.5, 0.5);
                tmp2.zw = tmp2.xy * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp3 = tex2D(_DetailTex, tmp2.zw);
                tmp2.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp4.xyz = tmp2.zzz * inp.texcoord1.xyz;
                tmp5.xyz = abs(tmp4.xyz) * abs(tmp4.xyz);
                tmp0 = tmp0.wxyz * tmp5.yyyy;
                tmp0 = tmp5.xxxx * tmp3.wxyz + tmp0;
                tmp0 = tmp5.zzzz * tmp1.wxyz + tmp0;
                tmp1 = inp.texcoord.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp3 = tex2D(_PrimaryTex, tmp1.zw);
                tmp1 = tex2D(_PrimaryTex, tmp1.xy);
                tmp1 = tmp1.wxyz * tmp5.yyyy;
                tmp2.zw = tmp2.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp6 = tex2D(_PrimaryTex, tmp2.zw);
                tmp1 = tmp5.xxxx * tmp6.wxyz + tmp1;
                tmp1 = tmp5.zzzz * tmp3.wxyz + tmp1;
                tmp0 = tmp0 - tmp1;
                tmp3 = inp.texcoord.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp6 = tex2D(_DetailNoiseMask, tmp3.zw);
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp2.z = tmp3.x * tmp5.y;
                tmp3.xy = tmp2.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp2.z = tmp5.x * tmp3.x + tmp2.z;
                tmp2.z = tmp5.z * tmp6.x + tmp2.z;
                tmp2.z = saturate(tmp2.z * 3.0 + -1.5);
                tmp0 = tmp2.zzzz * tmp0 + tmp1;
                tmp1.xyz = saturate(inp.color.xyz + inp.color.xyz);
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp1.w = tmp3.x / tmp0.x;
                tmp1.w = saturate(1.0 - tmp1.w);
                tmp1.w = 1.0 - tmp1.w;
                tmp6 = inp.texcoord.zxxy * _DetailTexGreen_ST + _DetailTexGreen_ST;
                tmp7 = tex2D(_DetailTexGreen, tmp6.zw);
                tmp6 = tex2D(_DetailTexGreen, tmp6.xy);
                tmp6 = tmp5.yyyy * tmp6.wxyz;
                tmp3.xw = tmp2.xy * _DetailTexGreen_ST.xy + _DetailTexGreen_ST.zw;
                tmp8 = tex2D(_DetailTexGreen, tmp3.xw);
                tmp6 = tmp5.xxxx * tmp8.wxyz + tmp6;
                tmp6 = tmp5.zzzz * tmp7.wxyz + tmp6;
                tmp7 = inp.texcoord.zxxy * _PrimaryTexGreen_ST + _PrimaryTexGreen_ST;
                tmp8 = tex2D(_PrimaryTexGreen, tmp7.zw);
                tmp7 = tex2D(_PrimaryTexGreen, tmp7.xy);
                tmp7 = tmp5.yyyy * tmp7.wxyz;
                tmp3.xw = tmp2.xy * _PrimaryTexGreen_ST.xy + _PrimaryTexGreen_ST.zw;
                tmp9 = tex2D(_PrimaryTexGreen, tmp3.xw);
                tmp7 = tmp5.xxxx * tmp9.wxyz + tmp7;
                tmp7 = tmp5.zzzz * tmp8.wxyz + tmp7;
                tmp6 = tmp6 - tmp7;
                tmp6 = tmp2.zzzz * tmp6 + tmp7;
                tmp1.x = tmp6.x * -0.66 + tmp1.x;
                tmp1.x = saturate(tmp1.x + 0.66);
                tmp1.x = tmp1.w / tmp1.x;
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = tmp1.x * 8.0;
                tmp1.x = min(tmp1.x, 1.0);
                tmp0.x = tmp0.x - tmp6.x;
                tmp0.x = tmp1.x * tmp0.x + tmp6.x;
                tmp1.y = saturate(tmp0.x * 0.66 + tmp1.y);
                tmp7 = inp.texcoord.zxxy * _DetailTexBlue_ST + _DetailTexBlue_ST;
                tmp8 = tex2D(_DetailTexBlue, tmp7.zw);
                tmp7 = tex2D(_DetailTexBlue, tmp7.xy);
                tmp7 = tmp5.yyyy * tmp7.wxyz;
                tmp3.xw = tmp2.xy * _DetailTexBlue_ST.xy + _DetailTexBlue_ST.zw;
                tmp9 = tex2D(_DetailTexBlue, tmp3.xw);
                tmp7 = tmp5.xxxx * tmp9.wxyz + tmp7;
                tmp7 = tmp5.zzzz * tmp8.wxyz + tmp7;
                tmp8 = inp.texcoord.zxxy * _PrimaryTexBlue_ST + _PrimaryTexBlue_ST;
                tmp9 = tex2D(_PrimaryTexBlue, tmp8.zw);
                tmp8 = tex2D(_PrimaryTexBlue, tmp8.xy);
                tmp8 = tmp5.yyyy * tmp8.wxyz;
                tmp3.xw = tmp2.xy * _PrimaryTexBlue_ST.xy + _PrimaryTexBlue_ST.zw;
                tmp10 = tex2D(_PrimaryTexBlue, tmp3.xw);
                tmp8 = tmp5.xxxx * tmp10.wxyz + tmp8;
                tmp8 = tmp5.zzzz * tmp9.wxyz + tmp8;
                tmp7 = tmp7 - tmp8;
                tmp7 = tmp2.zzzz * tmp7 + tmp8;
                tmp1.w = tmp3.y / tmp7.x;
                tmp1.w = saturate(1.0 - tmp1.w);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.y = tmp1.w / tmp1.y;
                tmp1.y = 1.0 - tmp1.y;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = tmp1.y * 8.0;
                tmp1.y = min(tmp1.y, 1.0);
                tmp1.w = 1.0 - tmp1.x;
                tmp1.w = tmp1.y * tmp1.w;
                tmp8 = inp.texcoord.zxxy * _DetailTexBlack_ST + _DetailTexBlack_ST;
                tmp9 = tex2D(_DetailTexBlack, tmp8.zw);
                tmp8 = tex2D(_DetailTexBlack, tmp8.xy);
                tmp8 = tmp5.yyyy * tmp8;
                tmp3.xy = tmp2.xy * _DetailTexBlack_ST.xy + _DetailTexBlack_ST.zw;
                tmp10 = tex2D(_DetailTexBlack, tmp3.xy);
                tmp8 = tmp5.xxxx * tmp10 + tmp8;
                tmp8 = tmp5.zzzz * tmp9 + tmp8;
                tmp9 = inp.texcoord.zxxy * _PrimaryTexBlack_ST + _PrimaryTexBlack_ST;
                tmp10 = tex2D(_PrimaryTexBlack, tmp9.zw);
                tmp9 = tex2D(_PrimaryTexBlack, tmp9.xy);
                tmp9 = tmp5.yyyy * tmp9;
                tmp3.xy = tmp2.xy * _PrimaryTexBlack_ST.xy + _PrimaryTexBlack_ST.zw;
                tmp11 = tex2D(_PrimaryTexBlack, tmp3.xy);
                tmp9 = tmp5.xxxx * tmp11 + tmp9;
                tmp9 = tmp5.zzzz * tmp10 + tmp9;
                tmp8 = tmp8 - tmp9;
                tmp8 = tmp2.zzzz * tmp8 + tmp9;
                tmp0.yzw = tmp0.yzw - tmp8.xyz;
                tmp0.yzw = tmp1.xxx * tmp0.yzw + tmp8.xyz;
                tmp3.xyw = tmp6.yzw - tmp0.yzw;
                tmp0.yzw = tmp1.www * tmp3.xyw + tmp0.yzw;
                tmp3.xyw = tmp7.yzw - tmp0.yzw;
                tmp0.x = tmp0.x - tmp7.x;
                tmp0.x = tmp1.y * tmp0.x + tmp7.x;
                tmp1.x = 1.0 - tmp1.y;
                tmp1.y = saturate(tmp0.x * 0.66 + tmp1.z);
                tmp0.x = tmp0.x - tmp8.w;
                tmp1.z = tmp3.z / tmp8.w;
                tmp1.z = saturate(1.0 - tmp1.z);
                tmp1.z = 1.0 - tmp1.z;
                tmp1.y = tmp1.z / tmp1.y;
                tmp1.y = 1.0 - tmp1.y;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = tmp1.y * 8.0;
                tmp1.y = min(tmp1.y, 1.0);
                tmp1.x = tmp1.y * tmp1.x;
                tmp0.x = saturate(tmp1.y * tmp0.x + tmp8.w);
                tmp0.yzw = tmp1.xxx * tmp3.xyw + tmp0.yzw;
                tmp1.x = tmp1.x * tmp7.x;
                tmp3 = inp.texcoord.zxxy * _TopperDetail_ST + _TopperDetail_ST;
                tmp6 = tex2D(_TopperDetail, tmp3.zw);
                tmp3 = tex2D(_TopperDetail, tmp3.xy);
                tmp3 = tmp3.wxyz * tmp5.yyyy;
                tmp1.yz = tmp2.xy * _TopperDetail_ST.xy + _TopperDetail_ST.zw;
                tmp2.xy = tmp2.xy * _Topper_MainTex_ST.xy + _Topper_MainTex_ST.zw;
                tmp7 = tex2D(_Topper_MainTex, tmp2.xy);
                tmp8 = tex2D(_TopperDetail, tmp1.yz);
                tmp3 = tmp5.xxxx * tmp8.wxyz + tmp3;
                tmp3 = tmp5.zzzz * tmp6.wxyz + tmp3;
                tmp6 = inp.texcoord.zxxy * _Topper_MainTex_ST + _Topper_MainTex_ST;
                tmp8 = tex2D(_Topper_MainTex, tmp6.xy);
                tmp6 = tex2D(_Topper_MainTex, tmp6.zw);
                tmp8 = tmp5.yyyy * tmp8.wxyz;
                tmp7 = tmp5.xxxx * tmp7.wxyz + tmp8;
                tmp5 = tmp5.zzzz * tmp6.wxyz + tmp7;
                tmp3 = tmp3 - tmp5;
                tmp1.y = tmp2.z * tmp3.x + tmp5.x;
                tmp1.zw = tmp1.yy * float2(0.8, 0.8) + float2(-0.4, 0.1);
                tmp1.y = tmp1.y - 0.5;
                tmp1.y = _TopperDepthStrength * tmp1.y + 0.5;
                tmp1.z = -tmp1.z * 2.0 + 1.0;
                tmp2.x = 1.0 - tmp2.z;
                tmp1.z = -tmp1.z * tmp2.x + 1.0;
                tmp2.x = tmp1.w + tmp1.w;
                tmp1.w = tmp1.w > 0.5;
                tmp2.x = tmp2.z * tmp2.x;
                tmp1.z = saturate(tmp1.w ? tmp1.z : tmp2.x);
                tmp2.xyz = tmp1.zzz * tmp3.yzw + tmp5.yzw;
                tmp2.xyz = tmp2.xyz - tmp0.yzw;
                tmp1.z = saturate(_ToporBottom * 2.0 + -1.0);
                tmp1.w = saturate(tmp4.y * -0.5 + 0.5);
                tmp2.w = tmp1.w - abs(tmp4.y);
                tmp1.w = tmp1.w - 1.0;
                tmp1.z = tmp1.z * tmp2.w + abs(tmp4.y);
                tmp2.w = _ToporBottom + _ToporBottom;
                tmp2.w = saturate(tmp2.w);
                tmp3.x = saturate(tmp4.y);
                tmp3.y = abs(tmp4.y) - tmp3.x;
                tmp2.w = tmp2.w * tmp3.y + tmp3.x;
                tmp1.z = tmp1.z - tmp2.w;
                tmp3.y = round(_ToporBottom);
                tmp1.z = tmp3.y * tmp1.z + tmp2.w;
                tmp1.z = tmp1.z * tmp1.z;
                tmp1.z = tmp1.z * _TopperCoverage;
                tmp1.z = tmp1.z * 1.25;
                tmp2.w = tmp0.x * 0.34 + tmp1.z;
                tmp2.w = saturate(tmp2.w + 0.66);
                tmp3.y = 1.0 - tmp1.y;
                tmp1.y = tmp1.y - tmp0.x;
                tmp1.z = tmp3.y / tmp1.z;
                tmp1.z = saturate(1.0 - tmp1.z);
                tmp1.z = 1.0 - tmp1.z;
                tmp1.z = tmp1.z / tmp2.w;
                tmp1.z = 1.0 - tmp1.z;
                tmp1.z = max(tmp1.z, 0.0);
                tmp1.z = tmp1.z * 8.0;
                tmp1.z = min(tmp1.z, 1.0);
                tmp0.yzw = tmp1.zzz * tmp2.xyz + tmp0.yzw;
                tmp0.x = tmp1.z * tmp1.y + tmp0.x;
                tmp2.xyz = tmp0.yzw - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.y = inp.texcoord.y - _SeaLevelRampOffset;
                tmp1.y = tmp1.y * _SeaLevelRampScale;
                tmp1.y = saturate(tmp1.y * 0.2 + 0.5);
                tmp3.yzw = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp3.yzw = tmp1.yyy * tmp3.yzw + _SeaLevelRampLower.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.yzw;
                tmp1.y = inp.texcoord.y - _WorldSpaceCameraPos.y;
                tmp1.y = tmp1.y * _RampScale;
                tmp1.y = tmp1.y * 0.1 + -_RampOffset;
                tmp1.y = saturate(tmp1.y * 0.5 + 0.5);
                tmp6.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp1.yyy * tmp6.xyz;
                tmp6.xyz = tmp1.yyy * tmp6.xyz + float3(0.5, 0.5, 0.5);
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp7.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp6.xyz + tmp6.xyz;
                tmp6.xyz = tmp6.xyz > float3(0.5, 0.5, 0.5);
                tmp3.yzw = tmp3.yzw * tmp7.xyz;
                tmp3.yzw = saturate(tmp6.xyz ? tmp5.xyz : tmp3.yzw);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.yzw;
                tmp2.xyz = -tmp2.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp0.yzw + tmp0.yzw;
                tmp0.yzw = tmp0.yzw > float3(0.5, 0.5, 0.5);
                tmp3.yzw = tmp3.yzw * tmp5.xyz;
                tmp0.yzw = saturate(tmp0.yzw ? tmp2.xyz : tmp3.yzw);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = saturate(tmp0.yzw * tmp2.xyz);
                tmp3.yzw = _BlueEmissionColor.www * _BlueEmissionColor.xyz;
                tmp1.xyz = tmp1.xxx * tmp3.yzw;
                tmp3.yzw = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.yzw = tmp2.www * tmp3.yzw;
                tmp2.w = dot(tmp4.xyz, tmp3.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp3.y = saturate(tmp2.w * -2.5 + 1.0);
                tmp3.y = tmp3.y * 2.0 + tmp2.w;
                tmp1.xyz = tmp1.xyz * tmp3.yyy;
                tmp1.xyz = tmp1.xyz * _BlueAlphaasEmission.xxx;
                tmp5 = tmp0.xxxx * float4(5.0, 0.33, 0.1, 0.5) + float4(-1.0, 0.33, 0.45, 0.25);
                tmp3.y = tmp5.z - tmp5.y;
                tmp3.z = saturate(tmp4.y * 2.0 + -1.0);
                tmp3.y = tmp3.z * tmp3.y + tmp5.y;
                tmp3.w = 1.0 - tmp3.y;
                tmp4.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp4.w = rsqrt(tmp4.w);
                tmp6.xyz = tmp4.www * _WorldSpaceLightPos0.xyz;
                tmp4.y = dot(tmp6.xyz, tmp4.xyz);
                tmp4.x = dot(abs(tmp4.xy), float2(0.333, 0.333));
                tmp4.x = tmp3.x + tmp4.x;
                tmp4.y = max(tmp4.y, 0.0);
                tmp4.z = tmp4.y - 0.5;
                tmp4.z = -tmp4.z * 2.0 + 1.0;
                tmp3.w = -tmp4.z * tmp3.w + 1.0;
                tmp4.z = tmp4.y + tmp4.y;
                tmp4.y = tmp4.y > 0.5;
                tmp3.y = tmp3.y * tmp4.z;
                tmp3.y = saturate(tmp4.y ? tmp3.w : tmp3.y);
                tmp3.w = tmp3.y * -2.0 + 1.0;
                tmp3.w = max(tmp3.w, 0.0);
                tmp4.y = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp4.y = saturate(tmp4.y * -3.333333 + 1.0);
                tmp3.w = tmp3.w + tmp4.y;
                tmp1.xyz = tmp1.xyz * tmp3.www;
                tmp3.w = 1.0 - tmp3.x;
                tmp4.y = _BlueEmissiveDirection + _BlueEmissiveDirection;
                tmp4.y = saturate(tmp4.y);
                tmp3.x = tmp4.y * tmp3.w + tmp3.x;
                tmp3.w = saturate(_BlueEmissiveDirection * 2.0 + -1.0);
                tmp1.w = tmp3.w * tmp1.w + 1.0;
                tmp1.w = tmp1.w - tmp3.x;
                tmp3.w = round(_BlueEmissiveDirection);
                tmp1.w = tmp3.w * tmp1.w + tmp3.x;
                tmp1.w = saturate(tmp1.w * 2.398082 + -0.7985612);
                tmp4.yzw = tmp1.www * tmp1.xyz;
                tmp4.yzw = saturate(tmp4.yzw);
                tmp2.xyz = tmp2.xyz + tmp4.yzw;
                tmp3.x = 1.0 - tmp5.w;
                tmp3.w = log(tmp2.w);
                tmp3.w = tmp3.w * 2.5;
                tmp3.w = exp(tmp3.w);
                tmp4.y = tmp3.w - 0.5;
                tmp4.y = -tmp4.y * 2.0 + 1.0;
                tmp3.x = -tmp4.y * tmp3.x + 1.0;
                tmp4.y = tmp3.w + tmp3.w;
                tmp3.w = tmp3.w > 0.5;
                tmp4.y = tmp5.w * tmp4.y;
                tmp5.x = saturate(tmp5.x);
                tmp4.z = tmp5.x - 1.0;
                tmp4.z = _PaintRimDepth * tmp4.z + 1.0;
                tmp3.x = saturate(tmp3.w ? tmp3.x : tmp4.y);
                tmp3.x = saturate(tmp3.x * 8.0 + -3.0);
                tmp3.zw = float2(1.0, 1.0) - tmp3.zy;
                tmp3.x = tmp3.x * tmp3.w;
                tmp3.x = tmp4.z * tmp3.x;
                tmp3.x = tmp3.z * tmp3.x;
                tmp3.x = tmp3.x * _PaintRim;
                tmp3.x = tmp3.x * 0.25;
                tmp4.yzw = glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _LightColor0.xyz;
                tmp4.yzw = tmp3.xxx * tmp4.yzw + tmp0.yzw;
                tmp3.xzw = tmp3.xxx * tmp4.yzw;
                tmp2.xyz = tmp3.xzw * float3(0.7, 0.7, 0.7) + tmp2.xyz;
                tmp3.x = tmp2.w * tmp2.w;
                tmp2.w = tmp2.w * tmp3.x;
                tmp3.x = tmp4.x * tmp4.x;
                tmp4.xyz = tmp4.xxx * tmp4.xxx + glstate_lightmodel_ambient.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp4.xyz = tmp4.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.75, 0.75, 0.75));
                tmp4.xyz = min(tmp4.xyz, float3(1.0, 1.0, 1.0));
                tmp2.w = tmp2.w * tmp3.x;
                tmp0.x = tmp0.x * tmp2.w;
                tmp3.xzw = tmp0.xxx * float3(0.75, 0.75, 0.75) + tmp4.xyz;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = floor(tmp0.x);
                tmp0.x = tmp3.y * 13.0 + tmp0.x;
                tmp0.x = saturate(tmp0.x - 5.0);
                tmp3.xyz = tmp3.xzw * _LightColor0.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp4.xyz = tmp3.xyz * inp.color.www + float3(-0.5, -0.5, -0.5);
                tmp3.xyz = tmp3.xyz * inp.color.www;
                tmp4.xyz = -tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp0.yzw;
                tmp4.xyz = -tmp4.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.yzw * tmp3.xyz;
                tmp0.xyz = saturate(tmp5.xyz ? tmp4.xyz : tmp0.xyz);
                tmp0.xyz = tmp1.xyz * tmp1.www + tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp2.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 90916
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _PrimaryTex_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float4 _PrimaryTexGreen_ST;
			float4 _PrimaryTexBlue_ST;
			float4 _DetailTexBlue_ST;
			float4 _PrimaryTexBlack_ST;
			float4 _DetailTexBlack_ST;
			float _TopperDepthStrength;
			float _TopperCoverage;
			float _ToporBottom;
			float4 _SeaLevelRampLower;
			float4 _RampUpper;
			float _RampOffset;
			float _RampScale;
			float _SeaLevelRampScale;
			float _SeaLevelRampOffset;
			float4 _Topper_MainTex_ST;
			float4 _TopperDetail_ST;
			float _BlueAlphaasEmission;
			float4 _BlueEmissionColor;
			float _BlueEmissiveDirection;
			float4 _DetailTexGreen_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _PrimaryTexBlue;
			sampler2D _DetailTexBlue;
			sampler2D _DetailNoiseMask;
			sampler2D _PrimaryTexGreen;
			sampler2D _DetailTexGreen;
			sampler2D _PrimaryTex;
			sampler2D _DetailTex;
			sampler2D _PrimaryTexBlack;
			sampler2D _DetailTexBlack;
			sampler2D _Topper_MainTex;
			sampler2D _TopperDetail;
			
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
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.color = v.color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord2.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                tmp0 = inp.texcoord.zxxy * _DetailTex_ST + _DetailTex_ST;
                tmp1 = tex2D(_DetailTex, tmp0.zw);
                tmp0 = tex2D(_DetailTex, tmp0.xy);
                tmp2.xy = inp.texcoord.yz - float2(0.5, 0.5);
                tmp3.x = dot(tmp2.xy, float2(0.0007963, -0.9999997));
                tmp3.y = dot(tmp2.xy, float2(0.9999997, 0.0007963));
                tmp2.xy = tmp3.xy + float2(0.5, 0.5);
                tmp2.zw = tmp2.xy * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp3 = tex2D(_DetailTex, tmp2.zw);
                tmp2.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp4.xyz = tmp2.zzz * inp.texcoord1.xyz;
                tmp5.xyz = abs(tmp4.xyz) * abs(tmp4.xyz);
                tmp0 = tmp0.wxyz * tmp5.yyyy;
                tmp0 = tmp5.xxxx * tmp3.wxyz + tmp0;
                tmp0 = tmp5.zzzz * tmp1.wxyz + tmp0;
                tmp1 = inp.texcoord.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp3 = tex2D(_PrimaryTex, tmp1.zw);
                tmp1 = tex2D(_PrimaryTex, tmp1.xy);
                tmp1 = tmp1.wxyz * tmp5.yyyy;
                tmp2.zw = tmp2.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp6 = tex2D(_PrimaryTex, tmp2.zw);
                tmp1 = tmp5.xxxx * tmp6.wxyz + tmp1;
                tmp1 = tmp5.zzzz * tmp3.wxyz + tmp1;
                tmp0 = tmp0 - tmp1;
                tmp3 = inp.texcoord.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp6 = tex2D(_DetailNoiseMask, tmp3.zw);
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp2.z = tmp3.x * tmp5.y;
                tmp3.xy = tmp2.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp2.z = tmp5.x * tmp3.x + tmp2.z;
                tmp2.z = tmp5.z * tmp6.x + tmp2.z;
                tmp2.z = saturate(tmp2.z * 3.0 + -1.5);
                tmp0 = tmp2.zzzz * tmp0 + tmp1;
                tmp1.xyz = saturate(inp.color.xyz + inp.color.xyz);
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp1.w = tmp3.x / tmp0.x;
                tmp1.w = saturate(1.0 - tmp1.w);
                tmp1.w = 1.0 - tmp1.w;
                tmp6 = inp.texcoord.zxxy * _DetailTexGreen_ST + _DetailTexGreen_ST;
                tmp7 = tex2D(_DetailTexGreen, tmp6.zw);
                tmp6 = tex2D(_DetailTexGreen, tmp6.xy);
                tmp6 = tmp5.yyyy * tmp6.wxyz;
                tmp3.xw = tmp2.xy * _DetailTexGreen_ST.xy + _DetailTexGreen_ST.zw;
                tmp8 = tex2D(_DetailTexGreen, tmp3.xw);
                tmp6 = tmp5.xxxx * tmp8.wxyz + tmp6;
                tmp6 = tmp5.zzzz * tmp7.wxyz + tmp6;
                tmp7 = inp.texcoord.zxxy * _PrimaryTexGreen_ST + _PrimaryTexGreen_ST;
                tmp8 = tex2D(_PrimaryTexGreen, tmp7.zw);
                tmp7 = tex2D(_PrimaryTexGreen, tmp7.xy);
                tmp7 = tmp5.yyyy * tmp7.wxyz;
                tmp3.xw = tmp2.xy * _PrimaryTexGreen_ST.xy + _PrimaryTexGreen_ST.zw;
                tmp9 = tex2D(_PrimaryTexGreen, tmp3.xw);
                tmp7 = tmp5.xxxx * tmp9.wxyz + tmp7;
                tmp7 = tmp5.zzzz * tmp8.wxyz + tmp7;
                tmp6 = tmp6 - tmp7;
                tmp6 = tmp2.zzzz * tmp6 + tmp7;
                tmp1.x = tmp6.x * -0.66 + tmp1.x;
                tmp1.x = saturate(tmp1.x + 0.66);
                tmp1.x = tmp1.w / tmp1.x;
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = tmp1.x * 8.0;
                tmp1.x = min(tmp1.x, 1.0);
                tmp0.x = tmp0.x - tmp6.x;
                tmp0.x = tmp1.x * tmp0.x + tmp6.x;
                tmp1.y = saturate(tmp0.x * 0.66 + tmp1.y);
                tmp7 = inp.texcoord.zxxy * _DetailTexBlue_ST + _DetailTexBlue_ST;
                tmp8 = tex2D(_DetailTexBlue, tmp7.zw);
                tmp7 = tex2D(_DetailTexBlue, tmp7.xy);
                tmp7 = tmp5.yyyy * tmp7.wxyz;
                tmp3.xw = tmp2.xy * _DetailTexBlue_ST.xy + _DetailTexBlue_ST.zw;
                tmp9 = tex2D(_DetailTexBlue, tmp3.xw);
                tmp7 = tmp5.xxxx * tmp9.wxyz + tmp7;
                tmp7 = tmp5.zzzz * tmp8.wxyz + tmp7;
                tmp8 = inp.texcoord.zxxy * _PrimaryTexBlue_ST + _PrimaryTexBlue_ST;
                tmp9 = tex2D(_PrimaryTexBlue, tmp8.zw);
                tmp8 = tex2D(_PrimaryTexBlue, tmp8.xy);
                tmp8 = tmp5.yyyy * tmp8.wxyz;
                tmp3.xw = tmp2.xy * _PrimaryTexBlue_ST.xy + _PrimaryTexBlue_ST.zw;
                tmp10 = tex2D(_PrimaryTexBlue, tmp3.xw);
                tmp8 = tmp5.xxxx * tmp10.wxyz + tmp8;
                tmp8 = tmp5.zzzz * tmp9.wxyz + tmp8;
                tmp7 = tmp7 - tmp8;
                tmp7 = tmp2.zzzz * tmp7 + tmp8;
                tmp1.w = tmp3.y / tmp7.x;
                tmp1.w = saturate(1.0 - tmp1.w);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.y = tmp1.w / tmp1.y;
                tmp1.y = 1.0 - tmp1.y;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = tmp1.y * 8.0;
                tmp1.y = min(tmp1.y, 1.0);
                tmp1.w = 1.0 - tmp1.x;
                tmp1.w = tmp1.y * tmp1.w;
                tmp8 = inp.texcoord.zxxy * _DetailTexBlack_ST + _DetailTexBlack_ST;
                tmp9 = tex2D(_DetailTexBlack, tmp8.zw);
                tmp8 = tex2D(_DetailTexBlack, tmp8.xy);
                tmp8 = tmp5.yyyy * tmp8.wxyz;
                tmp3.xy = tmp2.xy * _DetailTexBlack_ST.xy + _DetailTexBlack_ST.zw;
                tmp10 = tex2D(_DetailTexBlack, tmp3.xy);
                tmp8 = tmp5.xxxx * tmp10.wxyz + tmp8;
                tmp8 = tmp5.zzzz * tmp9.wxyz + tmp8;
                tmp9 = inp.texcoord.zxxy * _PrimaryTexBlack_ST + _PrimaryTexBlack_ST;
                tmp10 = tex2D(_PrimaryTexBlack, tmp9.zw);
                tmp9 = tex2D(_PrimaryTexBlack, tmp9.xy);
                tmp9 = tmp5.yyyy * tmp9.wxyz;
                tmp3.xy = tmp2.xy * _PrimaryTexBlack_ST.xy + _PrimaryTexBlack_ST.zw;
                tmp11 = tex2D(_PrimaryTexBlack, tmp3.xy);
                tmp9 = tmp5.xxxx * tmp11.wxyz + tmp9;
                tmp9 = tmp5.zzzz * tmp10.wxyz + tmp9;
                tmp8 = tmp8 - tmp9;
                tmp8 = tmp2.zzzz * tmp8 + tmp9;
                tmp0.yzw = tmp0.yzw - tmp8.yzw;
                tmp0.yzw = tmp1.xxx * tmp0.yzw + tmp8.yzw;
                tmp3.xyw = tmp6.yzw - tmp0.yzw;
                tmp0.yzw = tmp1.www * tmp3.xyw + tmp0.yzw;
                tmp3.xyw = tmp7.yzw - tmp0.yzw;
                tmp0.x = tmp0.x - tmp7.x;
                tmp0.x = tmp1.y * tmp0.x + tmp7.x;
                tmp1.x = 1.0 - tmp1.y;
                tmp1.y = saturate(tmp0.x * 0.66 + tmp1.z);
                tmp0.x = tmp0.x - tmp8.x;
                tmp1.z = tmp3.z / tmp8.x;
                tmp1.z = saturate(1.0 - tmp1.z);
                tmp1.z = 1.0 - tmp1.z;
                tmp1.y = tmp1.z / tmp1.y;
                tmp1.y = 1.0 - tmp1.y;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = tmp1.y * 8.0;
                tmp1.y = min(tmp1.y, 1.0);
                tmp1.x = tmp1.y * tmp1.x;
                tmp0.x = saturate(tmp1.y * tmp0.x + tmp8.x);
                tmp0.yzw = tmp1.xxx * tmp3.xyw + tmp0.yzw;
                tmp1.x = tmp1.x * tmp7.x;
                tmp3 = inp.texcoord.zxxy * _TopperDetail_ST + _TopperDetail_ST;
                tmp6 = tex2D(_TopperDetail, tmp3.zw);
                tmp3 = tex2D(_TopperDetail, tmp3.xy);
                tmp3 = tmp3.wxyz * tmp5.yyyy;
                tmp1.yz = tmp2.xy * _TopperDetail_ST.xy + _TopperDetail_ST.zw;
                tmp2.xy = tmp2.xy * _Topper_MainTex_ST.xy + _Topper_MainTex_ST.zw;
                tmp7 = tex2D(_Topper_MainTex, tmp2.xy);
                tmp8 = tex2D(_TopperDetail, tmp1.yz);
                tmp3 = tmp5.xxxx * tmp8.wxyz + tmp3;
                tmp3 = tmp5.zzzz * tmp6.wxyz + tmp3;
                tmp6 = inp.texcoord.zxxy * _Topper_MainTex_ST + _Topper_MainTex_ST;
                tmp8 = tex2D(_Topper_MainTex, tmp6.xy);
                tmp6 = tex2D(_Topper_MainTex, tmp6.zw);
                tmp8 = tmp5.yyyy * tmp8.wxyz;
                tmp7 = tmp5.xxxx * tmp7.wxyz + tmp8;
                tmp5 = tmp5.zzzz * tmp6.wxyz + tmp7;
                tmp3 = tmp3 - tmp5;
                tmp1.y = tmp2.z * tmp3.x + tmp5.x;
                tmp1.zw = tmp1.yy * float2(0.8, 0.8) + float2(0.1, -0.4);
                tmp1.y = tmp1.y - 0.5;
                tmp1.y = _TopperDepthStrength * tmp1.y + 0.5;
                tmp1.w = -tmp1.w * 2.0 + 1.0;
                tmp2.x = 1.0 - tmp2.z;
                tmp2.y = dot(tmp2.xy, tmp1.xy);
                tmp1.z = tmp1.z > 0.5;
                tmp1.w = -tmp1.w * tmp2.x + 1.0;
                tmp1.z = saturate(tmp1.z ? tmp1.w : tmp2.y);
                tmp2.xyz = tmp1.zzz * tmp3.yzw + tmp5.yzw;
                tmp2.xyz = tmp2.xyz - tmp0.yzw;
                tmp1.z = saturate(_ToporBottom * 2.0 + -1.0);
                tmp1.w = saturate(tmp4.y * -0.5 + 0.5);
                tmp2.w = tmp1.w - abs(tmp4.y);
                tmp1.w = tmp1.w - 1.0;
                tmp1.z = tmp1.z * tmp2.w + abs(tmp4.y);
                tmp2.w = _ToporBottom + _ToporBottom;
                tmp2.w = saturate(tmp2.w);
                tmp3.x = saturate(tmp4.y);
                tmp3.y = abs(tmp4.y) - tmp3.x;
                tmp2.w = tmp2.w * tmp3.y + tmp3.x;
                tmp1.z = tmp1.z - tmp2.w;
                tmp3.y = round(_ToporBottom);
                tmp1.z = tmp3.y * tmp1.z + tmp2.w;
                tmp1.z = tmp1.z * tmp1.z;
                tmp1.z = tmp1.z * _TopperCoverage;
                tmp1.z = tmp1.z * 1.25;
                tmp2.w = tmp0.x * 0.34 + tmp1.z;
                tmp2.w = saturate(tmp2.w + 0.66);
                tmp3.y = 1.0 - tmp1.y;
                tmp1.y = tmp1.y - tmp0.x;
                tmp1.z = tmp3.y / tmp1.z;
                tmp1.z = saturate(1.0 - tmp1.z);
                tmp1.z = 1.0 - tmp1.z;
                tmp1.z = tmp1.z / tmp2.w;
                tmp1.z = 1.0 - tmp1.z;
                tmp1.z = max(tmp1.z, 0.0);
                tmp1.z = tmp1.z * 8.0;
                tmp1.z = min(tmp1.z, 1.0);
                tmp0.yzw = tmp1.zzz * tmp2.xyz + tmp0.yzw;
                tmp0.x = tmp1.z * tmp1.y + tmp0.x;
                tmp2.xyz = tmp0.yzw - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.y = inp.texcoord.y - _SeaLevelRampOffset;
                tmp1.y = tmp1.y * _SeaLevelRampScale;
                tmp1.y = saturate(tmp1.y * 0.2 + 0.5);
                tmp3.yzw = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp3.yzw = tmp1.yyy * tmp3.yzw + _SeaLevelRampLower.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.yzw;
                tmp1.y = inp.texcoord.y - _WorldSpaceCameraPos.y;
                tmp1.y = tmp1.y * _RampScale;
                tmp1.y = tmp1.y * 0.1 + -_RampOffset;
                tmp1.y = saturate(tmp1.y * 0.5 + 0.5);
                tmp6.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp1.yyy * tmp6.xyz;
                tmp6.xyz = tmp1.yyy * tmp6.xyz + float3(0.5, 0.5, 0.5);
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp7.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp3.yzw = tmp3.yzw * tmp6.xyz;
                tmp6.xyz = tmp6.xyz > float3(0.5, 0.5, 0.5);
                tmp3.yzw = tmp3.yzw + tmp3.yzw;
                tmp3.yzw = saturate(tmp6.xyz ? tmp5.xyz : tmp3.yzw);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.yzw;
                tmp3.yzw = tmp0.yzw * tmp3.yzw;
                tmp0.yzw = tmp0.yzw > float3(0.5, 0.5, 0.5);
                tmp3.yzw = tmp3.yzw + tmp3.yzw;
                tmp2.xyz = -tmp2.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp0.yzw = saturate(tmp0.yzw ? tmp2.xyz : tmp3.yzw);
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp0.yzw;
                tmp1.yz = tmp0.xx * float2(0.33, 0.1) + float2(0.33, 0.45);
                tmp1.z = tmp1.z - tmp1.y;
                tmp2.w = saturate(tmp4.y * 2.0 + -1.0);
                tmp1.y = tmp2.w * tmp1.z + tmp1.y;
                tmp1.z = 1.0 - tmp1.y;
                tmp3.yzw = _WorldSpaceLightPos0.www * -inp.texcoord.xyz + _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.yzw = tmp2.www * tmp3.yzw;
                tmp2.w = dot(tmp3.xyz, tmp4.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp3.y = tmp2.w - 0.5;
                tmp3.y = -tmp3.y * 2.0 + 1.0;
                tmp1.z = -tmp3.y * tmp1.z + 1.0;
                tmp1.y = dot(tmp1.xy, tmp2.xy);
                tmp2.w = tmp2.w > 0.5;
                tmp1.y = saturate(tmp2.w ? tmp1.z : tmp1.y);
                tmp3.yzw = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp1.z = dot(tmp3.xyz, tmp3.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp3.yzw = tmp1.zzz * tmp3.yzw;
                tmp1.z = dot(tmp4.xyz, tmp3.xyz);
                tmp2.w = dot(abs(tmp4.xy), float2(0.333, 0.333));
                tmp2.w = tmp3.x + tmp2.w;
                tmp1.z = max(tmp1.z, 0.0);
                tmp1.z = 1.0 - tmp1.z;
                tmp3.y = tmp1.z * tmp1.z;
                tmp3.y = tmp1.z * tmp3.y;
                tmp3.z = tmp2.w * tmp2.w;
                tmp4.xyz = tmp2.www * tmp2.www + glstate_lightmodel_ambient.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp4.xyz = tmp4.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.75, 0.75, 0.75));
                tmp4.xyz = min(tmp4.xyz, float3(1.0, 1.0, 1.0));
                tmp2.w = tmp3.y * tmp3.z;
                tmp0.x = tmp0.x * tmp2.w;
                tmp2.w = tmp0.x + tmp0.x;
                tmp3.yzw = tmp0.xxx * float3(0.75, 0.75, 0.75) + tmp4.xyz;
                tmp0.x = floor(tmp2.w);
                tmp0.x = tmp1.y * 13.0 + tmp0.x;
                tmp1.y = tmp1.y * -2.0 + 1.0;
                tmp1.y = max(tmp1.y, 0.0);
                tmp0.x = saturate(tmp0.x - 5.0);
                tmp2.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp4 = tex2D(_LightTexture0, tmp2.ww);
                tmp4.xyz = tmp4.xxx * _LightColor0.xyz;
                tmp3.yzw = tmp3.yzw * tmp4.xyz;
                tmp2.w = dot(tmp4.xyz, float3(0.3, 0.59, 0.11));
                tmp2.w = saturate(tmp2.w * -3.333333 + 1.0);
                tmp1.y = tmp1.y + tmp2.w;
                tmp3.yzw = tmp0.xxx * tmp3.yzw;
                tmp4.xyz = tmp3.yzw * inp.color.www + float3(-0.5, -0.5, -0.5);
                tmp3.yzw = tmp3.yzw * inp.color.www;
                tmp4.xyz = -tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp4.xyz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.yzw * tmp3.yzw;
                tmp3.yzw = tmp3.yzw > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = saturate(tmp3.yzw ? tmp2.xyz : tmp0.xyz);
                tmp0.w = saturate(tmp1.z * -2.5 + 1.0);
                tmp0.w = tmp0.w * 2.0 + tmp1.z;
                tmp2.xyz = _BlueEmissionColor.www * _BlueEmissionColor.xyz;
                tmp2.xyz = tmp1.xxx * tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _BlueAlphaasEmission.xxx;
                tmp1.xyz = tmp1.yyy * tmp2.xyz;
                tmp0.w = 1.0 - tmp3.x;
                tmp2.x = _BlueEmissiveDirection + _BlueEmissiveDirection;
                tmp2.x = saturate(tmp2.x);
                tmp0.w = tmp2.x * tmp0.w + tmp3.x;
                tmp2.x = saturate(_BlueEmissiveDirection * 2.0 + -1.0);
                tmp1.w = tmp2.x * tmp1.w + 1.0;
                tmp1.w = tmp1.w - tmp0.w;
                tmp2.x = round(_BlueEmissiveDirection);
                tmp0.w = tmp2.x * tmp1.w + tmp0.w;
                tmp0.w = saturate(tmp0.w * 2.398082 + -0.7985612);
                o.sv_target.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}