Shader "SR/Paintlight/Triplanar Topper Phase" {
	Properties {
		[MaterialToggle] _UseMeshUVs ("Use Mesh UVs", Float) = 0
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		_Depth ("Depth", 2D) = "gray" {}
		_Topper_MainTex ("Topper _MainTex", 2D) = "white" {}
		_TopperDepth ("Topper Depth", 2D) = "gray" {}
		_TopperCoverage ("Topper Coverage", Range(0, 2)) = 1
		_ToporBottom ("Top or Bottom", Range(0, 1)) = 0
		[MaterialToggle] _EnableDetailTex ("Enable Detail Tex", Float) = 0
		_DetailTex ("Detail Tex", 2D) = "white" {}
		[MaterialToggle] _TopperEnableDetailTex ("Topper Enable Detail Tex", Float) = 0
		_TopperDetailTex ("Topper Detail Tex", 2D) = "white" {}
		_DetailNoiseMask ("Detail Noise Mask", 2D) = "black" {}
		_TopperDepthStrength ("Topper Depth Strength", Float) = 1
		_RampOffset ("Ramp Offset", Float) = 2
		_RampScale ("Ramp Scale", Float) = 1
		_RampUpper ("RampUpper", Color) = (0.4431373,0.3921569,0.5686275,1)
		_SeaLevelRampOffset ("SeaLevelRamp Offset", Float) = -3
		_SeaLevelRampScale ("SeaLevelRamp Scale", Float) = 1
		_SeaLevelRampLower ("SeaLevelRampLower", Color) = (0.3098039,0.4078431,0.3921569,1)
		_TopperSpecular ("Topper Specular", 2D) = "black" {}
		_SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_Gloss ("Gloss", Range(0, 1)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_TopperSpecularNoiseAdjust ("Topper Specular Noise Adjust", Range(0, 1)) = 0.5
		_VerticalRamp ("Vertical Ramp", 2D) = "gray" {}
		_PaintRim ("Paint Rim", Range(0, 1)) = 1
		_EmissiveColor ("Emissive Color", Color) = (0,0,0,0)
		_DifHue ("Dif Hue", Range(0, 1)) = 0
		_DifSat ("Dif Sat", Range(-1, 1)) = 0
		_DifVal ("Dif Val", Range(-1, 1)) = 0
		_DifContrast ("Dif Contrast", Range(0, 1)) = 1
		_DifOverlay ("Dif Overlay", Color) = (0.5,0.5,0.5,1)
		_TopRampOffset ("TopRamp Offset", Float) = 30
		_TopRampScale ("TopRamp Scale", Float) = 1
		_RampTop ("RampTop", Color) = (0.5,0.5,0.5,1)
		_Fade ("Fade", Range(0, 1)) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 49656
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
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _TimeEditor;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			float4 _TopperDepth_ST;
			float4 _Topper_MainTex_ST;
			float4 _TopperDetailTex_ST;
			float _TopperEnableDetailTex;
			float _TopperCoverage;
			float _TopperDepthStrength;
			float _RampOffset;
			float _RampScale;
			float4 _RampUpper;
			float _SeaLevelRampOffset;
			float _SeaLevelRampScale;
			float4 _SeaLevelRampLower;
			float4 _TopperSpecular_ST;
			float _Gloss;
			float _GlossPower;
			float _TopperSpecularNoiseAdjust;
			float4 _SpecularColor;
			float4 _VerticalRamp_ST;
			float _ToporBottom;
			float _UseMeshUVs;
			float _PaintRim;
			float4 _EmissiveColor;
			float _DifHue;
			float _DifSat;
			float _DifVal;
			float _DifContrast;
			float4 _DifOverlay;
			float _TopRampOffset;
			float _TopRampScale;
			float4 _RampTop;
			float _Fade;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _VerticalRamp;
			sampler2D _Depth;
			sampler2D _TopperDepth;
			sampler2D _PrimaryTex;
			sampler2D _DetailTex;
			sampler2D _DetailNoiseMask;
			sampler2D _Topper_MainTex;
			sampler2D _TopperDetailTex;
			sampler2D _TopperSpecular;
			
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
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord3 = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.x = inp.texcoord3.y / inp.texcoord3.w;
                tmp0.y = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.x = tmp0.x * _ScreenParams.y;
                tmp0.x = tmp0.x * 0.25;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 4.0;
                tmp0.x = floor(tmp0.x);
                tmp0.x = tmp0.x * 0.3333333;
                tmp0.y = _Fade + _Fade;
                tmp0.x = tmp0.x * tmp0.y + -0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = inp.texcoord1.y - _SeaLevelRampOffset;
                tmp0.x = tmp0.x * _SeaLevelRampScale;
                tmp0.x = saturate(tmp0.x * 0.2 + 0.5);
                tmp0.yzw = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + _SeaLevelRampLower.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp0.w = inp.texcoord1.y - _WorldSpaceCameraPos.y;
                tmp0.w = tmp0.w * _RampScale;
                tmp0.w = tmp0.w * 0.1 + -_RampOffset;
                tmp0.w = saturate(tmp0.w * 0.5 + 0.5);
                tmp2.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz + float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                tmp0.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp0.xyz);
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp0.w = -_TopRampScale * 0.5 + _TopRampOffset;
                tmp1.w = _TopRampScale * 0.5 + _TopRampOffset;
                tmp0.w = tmp0.w - tmp1.w;
                tmp1.w = inp.texcoord1.y - tmp1.w;
                tmp0.w = saturate(tmp1.w / tmp0.w);
                tmp2.xyz = _RampTop.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = _RampTop.www * tmp2.xyz + float3(0.5, 0.5, 0.5);
                tmp3.xyz = float3(0.5, 0.5, 0.5) - tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp3.xyz + tmp2.xyz;
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp4.xyz = _DifOverlay.xyz - float3(0.5, 0.5, 0.5);
                tmp4.xyz = _DifOverlay.www * tmp4.xyz + float3(0.5, 0.5, 0.5);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp6.zw = float2(-1.0, 0.6666667);
                tmp7.zw = float2(1.0, -1.0);
                tmp0.w = _UseMeshUVs >= 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp1.w = _UseMeshUVs <= 0.0;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp2.w = tmp0.w * tmp1.w;
                tmp8.xy = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp8 = tex2D(_PrimaryTex, tmp8.xy);
                tmp9 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp10 = tex2D(_PrimaryTex, tmp9.zw);
                tmp9 = tex2D(_PrimaryTex, tmp9.xy);
                tmp11.xy = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp12.x = dot(tmp11.xy, float2(0.0000003, -1.0));
                tmp12.y = dot(tmp11.xy, float2(1.0, 0.0000003));
                tmp11.zw = tmp12.xy + float2(0.5, 0.5);
                tmp12.xy = tmp11.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp12 = tex2D(_PrimaryTex, tmp12.xy);
                tmp3.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp13.xyz = tmp3.www * inp.texcoord2.xyz;
                tmp14.xyz = abs(tmp13.xyz) * abs(tmp13.xyz);
                tmp9.xyz = tmp9.xyz * tmp14.yyy;
                tmp9.xyz = tmp14.xxx * tmp12.xyz + tmp9.xyz;
                tmp9.xyz = tmp14.zzz * tmp10.xyz + tmp9.xyz;
                tmp10.xyz = tmp1.www * tmp9.xyz;
                tmp8.xyz = tmp0.www * tmp8.xyz + tmp10.xyz;
                tmp9.xyz = tmp9.xyz - tmp8.xyz;
                tmp8.xyz = tmp2.www * tmp9.xyz + tmp8.xyz;
                tmp9 = inp.texcoord1.zxxy * _DetailTex_ST + _DetailTex_ST;
                tmp10 = tex2D(_DetailTex, tmp9.zw);
                tmp9 = tex2D(_DetailTex, tmp9.xy);
                tmp9.xyz = tmp9.xyz * tmp14.yyy;
                tmp12.xy = tmp11.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp12 = tex2D(_DetailTex, tmp12.xy);
                tmp9.xyz = tmp14.xxx * tmp12.xyz + tmp9.xyz;
                tmp9.xyz = tmp14.zzz * tmp10.xyz + tmp9.xyz;
                tmp9.xyz = tmp9.xyz - tmp8.xyz;
                tmp10 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp12 = tex2D(_DetailNoiseMask, tmp10.zw);
                tmp10 = tex2D(_DetailNoiseMask, tmp10.xy);
                tmp3.w = tmp10.x * tmp14.y;
                tmp10.xy = tmp11.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp10 = tex2D(_DetailNoiseMask, tmp10.xy);
                tmp3.w = tmp14.x * tmp10.x + tmp3.w;
                tmp3.w = tmp14.z * tmp12.x + tmp3.w;
                tmp3.w = saturate(tmp3.w * 3.0 + -1.5);
                tmp9.xyz = tmp9.xyz * tmp3.www;
                tmp8.xyw = _EnableDetailTex.xxx * tmp9.yzx + tmp8.yzx;
                tmp4.w = tmp8.x >= tmp8.y;
                tmp4.w = tmp4.w ? 1.0 : 0.0;
                tmp6.xy = tmp8.yx;
                tmp7.xy = tmp8.xy - tmp6.xy;
                tmp6 = tmp4.wwww * tmp7 + tmp6;
                tmp8.xyz = tmp6.xyw;
                tmp4.w = tmp8.w >= tmp8.x;
                tmp4.w = tmp4.w ? 1.0 : 0.0;
                tmp6.xyw = tmp8.wyx;
                tmp6 = tmp6 - tmp8;
                tmp6 = tmp4.wwww * tmp6 + tmp8;
                tmp4.w = min(tmp6.y, tmp6.w);
                tmp4.w = tmp6.x - tmp4.w;
                tmp5.w = tmp4.w * 6.0 + 0.0;
                tmp6.y = tmp6.w - tmp6.y;
                tmp5.w = tmp6.y / tmp5.w;
                tmp5.w = tmp5.w + tmp6.z;
                tmp5.w = abs(tmp5.w) + _DifHue;
                tmp5.w = frac(tmp5.w);
                tmp6.yzw = tmp5.www + float3(0.0, -0.3333333, 0.3333333);
                tmp6.yzw = frac(tmp6.yzw);
                tmp6.yzw = -tmp6.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp6.yzw = saturate(abs(tmp6.yzw) * float3(3.0, 3.0, 3.0) + float3(-1.0, -1.0, -1.0));
                tmp6.yzw = tmp6.yzw - float3(1.0, 1.0, 1.0);
                tmp5.w = tmp6.x + 0.0;
                tmp6.x = tmp6.x + _DifVal;
                tmp4.w = tmp4.w / tmp5.w;
                tmp4.w = tmp4.w + _DifSat;
                tmp6.yzw = tmp4.www * tmp6.yzw + float3(1.0, 1.0, 1.0);
                tmp4.w = 1.0 - _DifContrast;
                tmp5.w = _DifContrast - tmp4.w;
                tmp4.w = tmp6.x * tmp5.w + tmp4.w;
                tmp7.xyz = tmp6.yzw * tmp4.www + float3(-0.5, -0.5, -0.5);
                tmp6.xyz = tmp4.www * tmp6.yzw;
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp7.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp6.xyz + tmp6.xyz;
                tmp6.xyz = tmp6.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz * tmp7.xyz;
                tmp4.xyz = saturate(tmp6.xyz ? tmp5.xyz : tmp4.xyz);
                tmp5.xyz = tmp4.xyz - float3(0.5, 0.5, 0.5);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = -tmp5.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz * tmp5.xyz;
                tmp2.xyz = saturate(tmp4.xyz ? tmp3.xyz : tmp2.xyz);
                tmp4 = inp.texcoord1.zxxy * _TopperDetailTex_ST + _TopperDetailTex_ST;
                tmp5 = tex2D(_TopperDetailTex, tmp4.zw);
                tmp4 = tex2D(_TopperDetailTex, tmp4.xy);
                tmp3.xyz = tmp4.xyz * tmp14.yyy;
                tmp4.xy = tmp11.zw * _TopperDetailTex_ST.xy + _TopperDetailTex_ST.zw;
                tmp4 = tex2D(_TopperDetailTex, tmp4.xy);
                tmp3.xyz = tmp14.xxx * tmp4.xyz + tmp3.xyz;
                tmp3.xyz = tmp14.zzz * tmp5.xyz + tmp3.xyz;
                tmp4 = inp.texcoord1.zxxy * _Topper_MainTex_ST + _Topper_MainTex_ST;
                tmp5 = tex2D(_Topper_MainTex, tmp4.zw);
                tmp4 = tex2D(_Topper_MainTex, tmp4.xy);
                tmp4.xyz = tmp4.xyz * tmp14.yyy;
                tmp6.xy = tmp11.zw * _Topper_MainTex_ST.xy + _Topper_MainTex_ST.zw;
                tmp6 = tex2D(_Topper_MainTex, tmp6.xy);
                tmp4.xyz = tmp14.xxx * tmp6.xyz + tmp4.xyz;
                tmp4.xyz = tmp14.zzz * tmp5.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp3.xyz = tmp3.xyz * tmp3.www;
                tmp3.xyz = _TopperEnableDetailTex.xxx * tmp3.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.xyz - tmp2.xyz;
                tmp4.x = saturate(_ToporBottom * 2.0 + -1.0);
                tmp4.y = saturate(-tmp13.y);
                tmp4.y = tmp4.y - abs(tmp13.y);
                tmp4.x = tmp4.x * tmp4.y + abs(tmp13.y);
                tmp4.y = _ToporBottom + _ToporBottom;
                tmp4.y = saturate(tmp4.y);
                tmp4.z = saturate(tmp13.y);
                tmp4.w = abs(tmp13.y) - tmp4.z;
                tmp4.y = tmp4.y * tmp4.w + tmp4.z;
                tmp4.x = tmp4.x - tmp4.y;
                tmp4.w = round(_ToporBottom);
                tmp4.x = tmp4.w * tmp4.x + tmp4.y;
                tmp4.x = tmp4.x * tmp4.x;
                tmp4.x = tmp4.x * _TopperCoverage;
                tmp4.x = tmp4.x * 1.25;
                tmp4.yw = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp5 = tex2D(_Depth, tmp4.yw);
                tmp6 = inp.texcoord1.zxxy * _Depth_ST + _Depth_ST;
                tmp7 = tex2D(_Depth, tmp6.zw);
                tmp6 = tex2D(_Depth, tmp6.xy);
                tmp4.y = tmp6.x * tmp14.y;
                tmp5.yz = tmp11.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp6 = tex2D(_Depth, tmp5.yz);
                tmp4.y = tmp14.x * tmp6.x + tmp4.y;
                tmp4.y = tmp14.z * tmp7.x + tmp4.y;
                tmp1.w = tmp1.w * tmp4.y;
                tmp0.w = tmp0.w * tmp5.x + tmp1.w;
                tmp1.w = tmp4.y - tmp0.w;
                tmp0.w = tmp2.w * tmp1.w + tmp0.w;
                tmp1.w = saturate(tmp0.w);
                tmp1.w = tmp1.w * -0.667 + tmp4.x;
                tmp1.w = tmp1.w + 0.667;
                tmp5 = inp.texcoord1.zxxy * _TopperDepth_ST + _TopperDepth_ST;
                tmp6 = tex2D(_TopperDepth, tmp5.zw);
                tmp5 = tex2D(_TopperDepth, tmp5.xy);
                tmp2.w = tmp5.x * tmp14.y;
                tmp4.yw = tmp11.zw * _TopperDepth_ST.xy + _TopperDepth_ST.zw;
                tmp5.xy = tmp11.zw * _TopperSpecular_ST.xy + _TopperSpecular_ST.zw;
                tmp5 = tex2D(_TopperSpecular, tmp5.xy);
                tmp7 = tex2D(_TopperDepth, tmp4.yw);
                tmp2.w = tmp14.x * tmp7.x + tmp2.w;
                tmp2.w = tmp14.z * tmp6.x + tmp2.w;
                tmp2.w = tmp2.w - 0.5;
                tmp2.w = _TopperDepthStrength * tmp2.w + 0.5;
                tmp4.y = 1.0 - tmp2.w;
                tmp2.w = tmp2.w - tmp0.w;
                tmp4.x = tmp4.y / tmp4.x;
                tmp4.x = saturate(1.0 - tmp4.x);
                tmp4.x = 1.0 - tmp4.x;
                tmp1.w = tmp4.x / tmp1.w;
                tmp1.w = saturate(1.0 - tmp1.w);
                tmp1.w = tmp1.w * 8.0;
                tmp1.w = min(tmp1.w, 1.0);
                tmp2.xyz = tmp1.www * tmp3.xyz + tmp2.xyz;
                tmp3.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                tmp0.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp0.xyz);
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = saturate(tmp0.xyz * tmp1.xyz);
                tmp2.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xy = inp.texcoord1.xy * float2(-1.0, 1.0) + float2(1.0, 0.0);
                tmp3.xy = tmp3.xy * _VerticalRamp_ST.xy + _VerticalRamp_ST.zw;
                tmp6 = tex2D(_VerticalRamp, tmp3.xy);
                tmp3.x = dot(tmp11.xy, float2(0.0000003, -1.0));
                tmp3.y = dot(tmp11.xy, float2(1.0, 0.0000003));
                tmp3.xy = tmp3.xy + float2(0.5, 0.5);
                tmp3.xy = tmp3.xy * _VerticalRamp_ST.xy + _VerticalRamp_ST.zw;
                tmp7 = tex2D(_VerticalRamp, tmp3.xy);
                tmp3.x = tmp14.y * 0.5;
                tmp3.xyz = tmp14.xxx * tmp7.xyz + tmp3.xxx;
                tmp3.xyz = tmp14.zzz * tmp6.xyz + tmp3.xyz;
                tmp4.xyw = float3(0.5, 0.5, 0.5) - tmp3.xyz;
                tmp3.xyz = tmp1.www * tmp4.xyw + tmp3.xyz;
                tmp4.xyw = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp2.xyz = -tmp2.xyz * tmp4.xyw + float3(1.0, 1.0, 1.0);
                tmp4.xyw = tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz * tmp4.xyw;
                tmp1.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp3.xyz);
                tmp6 = inp.texcoord1.zxxy * _TopperSpecular_ST + _TopperSpecular_ST;
                tmp7 = tex2D(_TopperSpecular, tmp6.xy);
                tmp6 = tex2D(_TopperSpecular, tmp6.zw);
                tmp2.xyz = tmp7.xyz * tmp14.yyy;
                tmp2.xyz = tmp14.xxx * tmp5.xyz + tmp2.xyz;
                tmp2.xyz = tmp14.zzz * tmp6.xyz + tmp2.xyz;
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp4.x = dot(tmp3.xyz, tmp3.xyz);
                tmp4.x = rsqrt(tmp4.x);
                tmp3.xyz = tmp3.xyz * tmp4.xxx;
                tmp4.x = dot(tmp13.xyz, tmp3.xyz);
                tmp4.x = max(tmp4.x, 0.0);
                tmp4.x = 1.0 - tmp4.x;
                tmp4.y = tmp1.w * tmp4.x + tmp1.w;
                tmp0.w = tmp1.w * tmp2.w + tmp0.w;
                tmp1.w = tmp4.y * 0.5;
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp1.w = 1.0 - _TopperSpecularNoiseAdjust;
                tmp2.w = _TopperSpecularNoiseAdjust - tmp1.w;
                tmp1.w = tmp3.w * tmp2.w + tmp1.w;
                tmp1.w = saturate(tmp1.w + tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp1.w = dot(-tmp3.xyz, tmp13.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp3.xyz = tmp13.xyz * -tmp1.www + -tmp3.xyz;
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp5.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp5.xyz, tmp3.xyz);
                tmp2.w = dot(tmp5.xyz, tmp13.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = log(tmp1.w);
                tmp3.x = _GlossPower * 16.0 + -1.0;
                tmp3.x = exp(tmp3.x);
                tmp1.w = tmp1.w * tmp3.x;
                tmp1.w = exp(tmp1.w);
                tmp1.w = tmp1.w * _Gloss;
                tmp3.xyz = tmp1.www * _LightColor0.xyz;
                tmp3.xyz = tmp3.xyz * _Gloss.xxx;
                tmp3.xyz = tmp2.xyz * tmp3.xyz;
                tmp3.xyz = saturate(tmp3.xyz * float3(50.0, 50.0, 50.0));
                tmp5.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp6.xyz = float3(1.0, 1.0, 1.0) - _SpecularColor.xyz;
                tmp5.xyz = -tmp5.xyz * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp3.xyz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp6.xyz = tmp6.xyz * _SpecularColor.xyz;
                tmp3.xyz = saturate(tmp3.xyz ? tmp5.xyz : tmp6.xyz);
                tmp1.w = _EmissiveColor.w * 10.0;
                tmp5.xyz = tmp1.www * _EmissiveColor.xyz;
                tmp2.xyz = tmp2.xyz * tmp5.xyz;
                tmp1.w = _TimeEditor.y + _Time.y;
                tmp1.w = tmp1.w + inp.texcoord1.x;
                tmp1.w = tmp1.w + inp.texcoord1.y;
                tmp1.w = tmp1.w + inp.texcoord1.z;
                tmp1.w = sin(tmp1.w);
                tmp1.w = tmp1.w * 0.875 + 1.125;
                tmp2.xyz = tmp2.xyz * tmp1.www + tmp3.xyz;
                tmp1.xyz = tmp1.xyz + tmp2.xyz;
                tmp3 = tmp0.wwww * float4(5.0, 0.33, 0.1, 0.5) + float4(-1.0, 0.33, 0.45, 0.25);
                tmp1.w = tmp3.z - tmp3.y;
                tmp3.z = saturate(tmp13.y * 2.0 + -1.0);
                tmp4.y = dot(abs(tmp13.xy), float2(0.333, 0.333));
                tmp4.y = tmp4.z + tmp4.y;
                tmp1.w = tmp3.z * tmp1.w + tmp3.y;
                tmp3.y = 1.0 - tmp3.z;
                tmp3.z = 1.0 - tmp1.w;
                tmp4.z = tmp2.w - 0.5;
                tmp4.z = -tmp4.z * 2.0 + 1.0;
                tmp3.z = -tmp4.z * tmp3.z + 1.0;
                tmp4.z = tmp2.w + tmp2.w;
                tmp2.w = tmp2.w > 0.5;
                tmp1.w = tmp1.w * tmp4.z;
                tmp1.w = saturate(tmp2.w ? tmp3.z : tmp1.w);
                tmp2.w = 1.0 - tmp1.w;
                tmp3.z = 1.0 - tmp3.w;
                tmp4.z = log(tmp4.x);
                tmp4.z = tmp4.z * 2.5;
                tmp4.z = exp(tmp4.z);
                tmp4.w = tmp4.z - 0.5;
                tmp4.w = -tmp4.w * 2.0 + 1.0;
                tmp3.z = -tmp4.w * tmp3.z + 1.0;
                tmp4.w = tmp4.z + tmp4.z;
                tmp4.z = tmp4.z > 0.5;
                tmp3.w = tmp3.w * tmp4.w;
                tmp3.x = saturate(tmp3.x);
                tmp3.z = saturate(tmp4.z ? tmp3.z : tmp3.w);
                tmp3.z = saturate(tmp3.z * 8.0 + -3.0);
                tmp2.w = tmp2.w * tmp3.z;
                tmp2.w = tmp3.x * tmp2.w;
                tmp2.w = tmp3.y * tmp2.w;
                tmp2.w = tmp2.w * _PaintRim;
                tmp2.w = tmp2.w * 0.25;
                tmp3.xyz = glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _LightColor0.xyz;
                tmp3.xyz = tmp2.www * tmp3.xyz + tmp0.xyz;
                tmp3.xyz = tmp2.www * tmp3.xyz;
                tmp1.xyz = tmp3.xyz * float3(0.7, 0.7, 0.7) + tmp1.xyz;
                tmp2.w = tmp4.x * tmp4.x;
                tmp2.w = tmp2.w * tmp4.x;
                tmp3.x = tmp4.y * tmp4.y;
                tmp3.yzw = tmp4.yyy * tmp4.yyy + glstate_lightmodel_ambient.xyz;
                tmp3.yzw = tmp3.yzw * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp3.yzw = tmp3.yzw * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp3.yzw = max(tmp3.yzw, float3(0.75, 0.75, 0.75));
                tmp3.yzw = min(tmp3.yzw, float3(1.0, 1.0, 1.0));
                tmp2.w = tmp2.w * tmp3.x;
                tmp0.w = tmp0.w * tmp2.w;
                tmp3.xyz = tmp0.www * float3(0.75, 0.75, 0.75) + tmp3.yzw;
                tmp0.w = tmp0.w + tmp0.w;
                tmp0.w = floor(tmp0.w);
                tmp0.w = tmp1.w * 13.0 + tmp0.w;
                tmp0.w = saturate(tmp0.w - 5.0);
                tmp3.xyz = tmp3.xyz * _LightColor0.xyz;
                tmp4.xyz = tmp0.www * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * tmp0.www + float3(-0.5, -0.5, -0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp0.xyz * tmp4.xyz;
                tmp0.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp0.xyz = -tmp3.xyz * tmp0.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = saturate(tmp5.xyz ? tmp0.xyz : tmp4.xyz);
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 130985
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
				float4 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _TimeEditor;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			float4 _TopperDepth_ST;
			float4 _Topper_MainTex_ST;
			float4 _TopperDetailTex_ST;
			float _TopperEnableDetailTex;
			float _TopperCoverage;
			float _TopperDepthStrength;
			float _RampOffset;
			float _RampScale;
			float4 _RampUpper;
			float _SeaLevelRampOffset;
			float _SeaLevelRampScale;
			float4 _SeaLevelRampLower;
			float4 _TopperSpecular_ST;
			float _Gloss;
			float _GlossPower;
			float _TopperSpecularNoiseAdjust;
			float4 _SpecularColor;
			float _ToporBottom;
			float _UseMeshUVs;
			float4 _EmissiveColor;
			float _DifHue;
			float _DifSat;
			float _DifVal;
			float _DifContrast;
			float4 _DifOverlay;
			float _TopRampOffset;
			float _TopRampScale;
			float4 _RampTop;
			float _Fade;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _TopperSpecular;
			sampler2D _Depth;
			sampler2D _TopperDepth;
			sampler2D _DetailNoiseMask;
			sampler2D _PrimaryTex;
			sampler2D _DetailTex;
			sampler2D _Topper_MainTex;
			sampler2D _TopperDetailTex;
			
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
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord3 = tmp1;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                tmp0.x = inp.texcoord3.y / inp.texcoord3.w;
                tmp0.y = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.x = tmp0.x * _ScreenParams.y;
                tmp0.x = tmp0.x * 0.25;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 4.0;
                tmp0.x = floor(tmp0.x);
                tmp0.x = tmp0.x * _Fade;
                tmp0.x = tmp0.x * 0.6666667 + -0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = inp.texcoord1.y - _SeaLevelRampOffset;
                tmp0.x = tmp0.x * _SeaLevelRampScale;
                tmp0.x = saturate(tmp0.x * 0.2 + 0.5);
                tmp0.yzw = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + _SeaLevelRampLower.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp0.w = inp.texcoord1.y - _WorldSpaceCameraPos.y;
                tmp0.w = tmp0.w * _RampScale;
                tmp0.w = tmp0.w * 0.1 + -_RampOffset;
                tmp0.w = saturate(tmp0.w * 0.5 + 0.5);
                tmp2.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz + float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp0.xyz);
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp0.w = -_TopRampScale * 0.5 + _TopRampOffset;
                tmp1.w = _TopRampScale * 0.5 + _TopRampOffset;
                tmp0.w = tmp0.w - tmp1.w;
                tmp1.w = inp.texcoord1.y - tmp1.w;
                tmp0.w = saturate(tmp1.w / tmp0.w);
                tmp2.xyz = _RampTop.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = _RampTop.www * tmp2.xyz + float3(0.5, 0.5, 0.5);
                tmp3.xyz = float3(0.5, 0.5, 0.5) - tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp3.xyz + tmp2.xyz;
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp4.zw = float2(-1.0, 0.6666667);
                tmp5.zw = float2(1.0, -1.0);
                tmp0.w = _UseMeshUVs >= 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp1.w = _UseMeshUVs <= 0.0;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp2.w = tmp0.w * tmp1.w;
                tmp6.xy = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp6 = tex2D(_PrimaryTex, tmp6.xy);
                tmp7 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp8 = tex2D(_PrimaryTex, tmp7.zw);
                tmp7 = tex2D(_PrimaryTex, tmp7.xy);
                tmp9.xy = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp10.x = dot(tmp9.xy, float2(0.0000003, -1.0));
                tmp10.y = dot(tmp9.xy, float2(1.0, 0.0000003));
                tmp9.xy = tmp10.xy + float2(0.5, 0.5);
                tmp9.zw = tmp9.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp10 = tex2D(_PrimaryTex, tmp9.zw);
                tmp3.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp11.xyz = tmp3.www * inp.texcoord2.xyz;
                tmp12.xyz = abs(tmp11.xyz) * abs(tmp11.xyz);
                tmp7.xyz = tmp7.xyz * tmp12.yyy;
                tmp7.xyz = tmp12.xxx * tmp10.xyz + tmp7.xyz;
                tmp7.xyz = tmp12.zzz * tmp8.xyz + tmp7.xyz;
                tmp8.xyz = tmp1.www * tmp7.xyz;
                tmp6.xyz = tmp0.www * tmp6.xyz + tmp8.xyz;
                tmp7.xyz = tmp7.xyz - tmp6.xyz;
                tmp6.xyz = tmp2.www * tmp7.xyz + tmp6.xyz;
                tmp7 = inp.texcoord1.zxxy * _DetailTex_ST + _DetailTex_ST;
                tmp8 = tex2D(_DetailTex, tmp7.zw);
                tmp7 = tex2D(_DetailTex, tmp7.xy);
                tmp7.xyz = tmp7.xyz * tmp12.yyy;
                tmp9.zw = tmp9.xy * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp10 = tex2D(_DetailTex, tmp9.zw);
                tmp7.xyz = tmp12.xxx * tmp10.xyz + tmp7.xyz;
                tmp7.xyz = tmp12.zzz * tmp8.xyz + tmp7.xyz;
                tmp7.xyz = tmp7.xyz - tmp6.xyz;
                tmp8 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp10 = tex2D(_DetailNoiseMask, tmp8.zw);
                tmp8 = tex2D(_DetailNoiseMask, tmp8.xy);
                tmp3.w = tmp8.x * tmp12.y;
                tmp8.xy = tmp9.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp8 = tex2D(_DetailNoiseMask, tmp8.xy);
                tmp3.w = tmp12.x * tmp8.x + tmp3.w;
                tmp3.w = tmp12.z * tmp10.x + tmp3.w;
                tmp3.w = saturate(tmp3.w * 3.0 + -1.5);
                tmp7.xyz = tmp7.xyz * tmp3.www;
                tmp6.xyw = _EnableDetailTex.xxx * tmp7.yzx + tmp6.yzx;
                tmp7.x = tmp6.x >= tmp6.y;
                tmp7.x = tmp7.x ? 1.0 : 0.0;
                tmp4.xy = tmp6.yx;
                tmp5.xy = tmp6.xy - tmp4.xy;
                tmp4 = tmp7.xxxx * tmp5 + tmp4;
                tmp6.xyz = tmp4.xyw;
                tmp5.x = tmp6.w >= tmp6.x;
                tmp5.x = tmp5.x ? 1.0 : 0.0;
                tmp4.xyw = tmp6.wyx;
                tmp4 = tmp4 - tmp6;
                tmp4 = tmp5.xxxx * tmp4 + tmp6;
                tmp5.x = min(tmp4.y, tmp4.w);
                tmp5.x = tmp4.x - tmp5.x;
                tmp5.y = tmp5.x * 6.0 + 0.0;
                tmp4.y = tmp4.w - tmp4.y;
                tmp4.y = tmp4.y / tmp5.y;
                tmp4.y = tmp4.y + tmp4.z;
                tmp4.y = abs(tmp4.y) + _DifHue;
                tmp4.y = frac(tmp4.y);
                tmp4.yzw = tmp4.yyy + float3(0.0, -0.3333333, 0.3333333);
                tmp4.yzw = frac(tmp4.yzw);
                tmp4.yzw = -tmp4.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp4.yzw = saturate(abs(tmp4.yzw) * float3(3.0, 3.0, 3.0) + float3(-1.0, -1.0, -1.0));
                tmp4.yzw = tmp4.yzw - float3(1.0, 1.0, 1.0);
                tmp5.y = tmp4.x + 0.0;
                tmp4.x = tmp4.x + _DifVal;
                tmp5.x = tmp5.x / tmp5.y;
                tmp5.x = tmp5.x + _DifSat;
                tmp4.yzw = tmp5.xxx * tmp4.yzw + float3(1.0, 1.0, 1.0);
                tmp5.x = 1.0 - _DifContrast;
                tmp5.y = _DifContrast - tmp5.x;
                tmp4.x = tmp4.x * tmp5.y + tmp5.x;
                tmp5.xyz = tmp4.yzw * tmp4.xxx + float3(-0.5, -0.5, -0.5);
                tmp4.xyz = tmp4.xxx * tmp4.yzw;
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp6.xyz = _DifOverlay.xyz - float3(0.5, 0.5, 0.5);
                tmp6.xyz = _DifOverlay.www * tmp6.xyz + float3(0.5, 0.5, 0.5);
                tmp7.xyz = float3(1.0, 1.0, 1.0) - tmp6.xyz;
                tmp6.xyz = tmp4.xyz * tmp6.xyz;
                tmp4.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp6.xyz = tmp6.xyz + tmp6.xyz;
                tmp5.xyz = -tmp5.xyz * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = saturate(tmp4.xyz ? tmp5.xyz : tmp6.xyz);
                tmp5.xyz = tmp4.xyz - float3(0.5, 0.5, 0.5);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = -tmp5.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.xyz * tmp4.xyz;
                tmp4.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = saturate(tmp4.xyz ? tmp3.xyz : tmp2.xyz);
                tmp4 = inp.texcoord1.zxxy * _TopperDetailTex_ST + _TopperDetailTex_ST;
                tmp5 = tex2D(_TopperDetailTex, tmp4.zw);
                tmp4 = tex2D(_TopperDetailTex, tmp4.xy);
                tmp3.xyz = tmp4.xyz * tmp12.yyy;
                tmp4.xy = tmp9.xy * _TopperDetailTex_ST.xy + _TopperDetailTex_ST.zw;
                tmp4 = tex2D(_TopperDetailTex, tmp4.xy);
                tmp3.xyz = tmp12.xxx * tmp4.xyz + tmp3.xyz;
                tmp3.xyz = tmp12.zzz * tmp5.xyz + tmp3.xyz;
                tmp4 = inp.texcoord1.zxxy * _Topper_MainTex_ST + _Topper_MainTex_ST;
                tmp5 = tex2D(_Topper_MainTex, tmp4.zw);
                tmp4 = tex2D(_Topper_MainTex, tmp4.xy);
                tmp4.xyz = tmp4.xyz * tmp12.yyy;
                tmp6.xy = tmp9.xy * _Topper_MainTex_ST.xy + _Topper_MainTex_ST.zw;
                tmp6 = tex2D(_Topper_MainTex, tmp6.xy);
                tmp4.xyz = tmp12.xxx * tmp6.xyz + tmp4.xyz;
                tmp4.xyz = tmp12.zzz * tmp5.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp3.xyz = tmp3.xyz * tmp3.www;
                tmp3.xyz = _TopperEnableDetailTex.xxx * tmp3.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.xyz - tmp2.xyz;
                tmp4.x = saturate(_ToporBottom * 2.0 + -1.0);
                tmp4.y = saturate(-tmp11.y);
                tmp4.y = tmp4.y - abs(tmp11.y);
                tmp4.x = tmp4.x * tmp4.y + abs(tmp11.y);
                tmp4.y = _ToporBottom + _ToporBottom;
                tmp4.y = saturate(tmp4.y);
                tmp4.z = saturate(tmp11.y);
                tmp4.w = abs(tmp11.y) - tmp4.z;
                tmp4.y = tmp4.y * tmp4.w + tmp4.z;
                tmp4.x = tmp4.x - tmp4.y;
                tmp4.w = round(_ToporBottom);
                tmp4.x = tmp4.w * tmp4.x + tmp4.y;
                tmp4.x = tmp4.x * tmp4.x;
                tmp4.x = tmp4.x * _TopperCoverage;
                tmp4.x = tmp4.x * 1.25;
                tmp4.yw = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp5 = tex2D(_Depth, tmp4.yw);
                tmp6 = inp.texcoord1.zxxy * _Depth_ST + _Depth_ST;
                tmp7 = tex2D(_Depth, tmp6.zw);
                tmp6 = tex2D(_Depth, tmp6.xy);
                tmp4.y = tmp6.x * tmp12.y;
                tmp5.yz = tmp9.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp6 = tex2D(_Depth, tmp5.yz);
                tmp4.y = tmp12.x * tmp6.x + tmp4.y;
                tmp4.y = tmp12.z * tmp7.x + tmp4.y;
                tmp1.w = tmp1.w * tmp4.y;
                tmp0.w = tmp0.w * tmp5.x + tmp1.w;
                tmp1.w = tmp4.y - tmp0.w;
                tmp0.w = tmp2.w * tmp1.w + tmp0.w;
                tmp1.w = saturate(tmp0.w);
                tmp1.w = tmp1.w * -0.667 + tmp4.x;
                tmp1.w = tmp1.w + 0.667;
                tmp5 = inp.texcoord1.zxxy * _TopperDepth_ST + _TopperDepth_ST;
                tmp6 = tex2D(_TopperDepth, tmp5.zw);
                tmp5 = tex2D(_TopperDepth, tmp5.xy);
                tmp2.w = tmp5.x * tmp12.y;
                tmp4.yw = tmp9.xy * _TopperDepth_ST.xy + _TopperDepth_ST.zw;
                tmp5.xy = tmp9.xy * _TopperSpecular_ST.xy + _TopperSpecular_ST.zw;
                tmp5 = tex2D(_TopperSpecular, tmp5.xy);
                tmp7 = tex2D(_TopperDepth, tmp4.yw);
                tmp2.w = tmp12.x * tmp7.x + tmp2.w;
                tmp2.w = tmp12.z * tmp6.x + tmp2.w;
                tmp2.w = tmp2.w - 0.5;
                tmp2.w = _TopperDepthStrength * tmp2.w + 0.5;
                tmp4.y = 1.0 - tmp2.w;
                tmp2.w = tmp2.w - tmp0.w;
                tmp4.x = tmp4.y / tmp4.x;
                tmp4.x = saturate(1.0 - tmp4.x);
                tmp4.x = 1.0 - tmp4.x;
                tmp1.w = tmp4.x / tmp1.w;
                tmp1.w = saturate(1.0 - tmp1.w);
                tmp1.w = tmp1.w * 8.0;
                tmp1.w = min(tmp1.w, 1.0);
                tmp2.xyz = tmp1.www * tmp3.xyz + tmp2.xyz;
                tmp3.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp0.xyz);
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp0.w = tmp1.w * tmp2.w + tmp0.w;
                tmp2.xy = tmp0.ww * float2(0.33, 0.1) + float2(0.33, 0.45);
                tmp2.y = tmp2.y - tmp2.x;
                tmp2.z = saturate(tmp11.y * 2.0 + -1.0);
                tmp2.x = tmp2.z * tmp2.y + tmp2.x;
                tmp2.y = 1.0 - tmp2.x;
                tmp3.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp2.z = dot(tmp3.xyz, tmp3.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp3.xyz = tmp2.zzz * tmp3.xyz;
                tmp2.z = dot(tmp3.xyz, tmp11.xyz);
                tmp2.z = max(tmp2.z, 0.0);
                tmp2.w = tmp2.z - 0.5;
                tmp2.w = -tmp2.w * 2.0 + 1.0;
                tmp2.y = -tmp2.w * tmp2.y + 1.0;
                tmp2.x = dot(tmp2.xy, tmp2.xy);
                tmp2.z = tmp2.z > 0.5;
                tmp2.x = saturate(tmp2.z ? tmp2.y : tmp2.x);
                tmp2.y = dot(abs(tmp11.xy), float2(0.333, 0.333));
                tmp2.y = tmp4.z + tmp2.y;
                tmp2.z = tmp2.y * tmp2.y;
                tmp4.xyz = tmp2.yyy * tmp2.yyy + glstate_lightmodel_ambient.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp4.xyz = tmp4.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.75, 0.75, 0.75));
                tmp4.xyz = min(tmp4.xyz, float3(1.0, 1.0, 1.0));
                tmp6.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp2.y = dot(tmp6.xyz, tmp6.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp6.xyz = tmp2.yyy * tmp6.xyz;
                tmp2.y = dot(tmp11.xyz, tmp6.xyz);
                tmp2.y = max(tmp2.y, 0.0);
                tmp2.y = 1.0 - tmp2.y;
                tmp2.w = tmp2.y * tmp2.y;
                tmp2.w = tmp2.w * tmp2.y;
                tmp1.w = tmp1.w * tmp2.y + tmp1.w;
                tmp1.w = tmp1.w * 0.5;
                tmp2.y = tmp2.w * tmp2.z;
                tmp2.y = tmp0.w * tmp2.y;
                tmp2.z = tmp2.y + tmp2.y;
                tmp4.xyz = tmp2.yyy * float3(0.75, 0.75, 0.75) + tmp4.xyz;
                tmp2.y = floor(tmp2.z);
                tmp2.x = tmp2.x * 13.0 + tmp2.y;
                tmp2.x = saturate(tmp2.x - 5.0);
                tmp2.y = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp7 = tex2D(_LightTexture0, tmp2.yy);
                tmp2.yzw = tmp7.xxx * _LightColor0.xyz;
                tmp4.xyz = tmp4.xyz * tmp2.yzw;
                tmp7.xyz = tmp4.xyz * tmp2.xxx + float3(-0.5, -0.5, -0.5);
                tmp4.xyz = tmp2.xxx * tmp4.xyz;
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp7.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp4.xyz;
                tmp4.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = saturate(tmp4.xyz ? tmp1.xyz : tmp0.xyz);
                tmp1.x = dot(-tmp6.xyz, tmp11.xyz);
                tmp1.x = tmp1.x + tmp1.x;
                tmp1.xyz = tmp11.xyz * -tmp1.xxx + -tmp6.xyz;
                tmp1.x = dot(tmp3.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = log(tmp1.x);
                tmp1.y = _GlossPower * 16.0 + -1.0;
                tmp1.y = exp(tmp1.y);
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.x * _Gloss;
                tmp1.xyz = tmp1.xxx * tmp2.yzw;
                tmp1.xyz = tmp1.xyz * _Gloss.xxx;
                tmp2 = inp.texcoord1.zxxy * _TopperSpecular_ST + _TopperSpecular_ST;
                tmp4 = tex2D(_TopperSpecular, tmp2.xy);
                tmp2 = tex2D(_TopperSpecular, tmp2.zw);
                tmp3.xyz = tmp4.xyz * tmp12.yyy;
                tmp3.xyz = tmp12.xxx * tmp5.xyz + tmp3.xyz;
                tmp2.xyz = tmp12.zzz * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = 1.0 - _TopperSpecularNoiseAdjust;
                tmp1.w = _TopperSpecularNoiseAdjust - tmp0.w;
                tmp0.w = tmp3.w * tmp1.w + tmp0.w;
                tmp0.w = saturate(tmp0.w + tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp1.xyz = saturate(tmp1.xyz * float3(50.0, 50.0, 50.0));
                tmp3.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp1.xyz * _SpecularColor.xyz;
                tmp1.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp1.xyz = -tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - _SpecularColor.xyz;
                tmp1.xyz = -tmp1.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp3.xyz ? tmp1.xyz : tmp4.xyz);
                tmp0.w = _EmissiveColor.w * 10.0;
                tmp3.xyz = tmp0.www * _EmissiveColor.xyz;
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp0.w = tmp0.w + inp.texcoord1.x;
                tmp0.w = tmp0.w + inp.texcoord1.y;
                tmp0.w = tmp0.w + inp.texcoord1.z;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 0.875 + 1.125;
                tmp1.xyz = tmp2.xyz * tmp0.www + tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 134787
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _Fade;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp1.x = tmp0.z + tmp1.x;
                tmp1.y = min(tmp0.w, tmp1.x);
                tmp1.y = tmp1.y - tmp1.x;
                o.position.z = unity_LightShadowBias.y * tmp1.y + tmp1.x;
                o.position.xyw = tmp0.xyw;
                o.texcoord1 = tmp0;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.x = inp.texcoord1.y / inp.texcoord1.w;
                tmp0.y = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.x = tmp0.x * _ScreenParams.y;
                tmp0.x = tmp0.x * 0.25;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 4.0;
                tmp0.x = floor(tmp0.x);
                tmp0.x = tmp0.x * _Fade;
                tmp0.x = tmp0.x * 0.6666667 + -0.5;
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