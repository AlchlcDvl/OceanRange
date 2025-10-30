Shader "SR/Paintlight/Triplanar Topper" {
	Properties {
		[MaterialToggle] _UseMeshUVs ("Use Mesh UVs", Float) = 0
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		_Depth ("Depth", 2D) = "gray" {}
		_Topper_MainTex ("Topper _MainTex", 2D) = "white" {}
		_TopperDepth ("Topper Depth", 2D) = "gray" {}
		_TopperCoverage ("Topper Coverage", Range(0, 2)) = 1
		_TopperSides ("Topper Sides", Range(0, 1)) = 0
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
		[MaterialToggle] _PrimeLowerToggle ("PrimeLowerToggle", Float) = 0
		_PrimaryLowerTex ("PrimaryLowerTex", 2D) = "white" {}
		_PrimeLowerOffset ("PrimeLowerOffset", Float) = 30
		_PrimeLowerScale ("PrimeLowerScale", Float) = 1
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 42069
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
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
			float _TopperSides;
			float4 _PrimaryLowerTex_ST;
			float _PrimeLowerOffset;
			float _PrimeLowerScale;
			float _PrimeLowerToggle;
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
			sampler2D _PrimaryLowerTex;
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
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
                tmp0.x = _UseMeshUVs >= 0.0;
                tmp0.y = _UseMeshUVs <= 0.0;
                tmp0.xy = tmp0.xy ? 1.0 : 0.0;
                tmp0.z = tmp0.y * tmp0.x;
                tmp1.xy = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp1 = tex2D(_PrimaryTex, tmp1.xy);
                tmp2 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp3 = tex2D(_PrimaryTex, tmp2.zw);
                tmp2 = tex2D(_PrimaryTex, tmp2.xy);
                tmp4.xy = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp5.x = dot(tmp4.xy, float2(0.0000003, -1.0));
                tmp5.y = dot(tmp4.xy, float2(1.0, 0.0000003));
                tmp4.zw = tmp5.xy + float2(0.5, 0.5);
                tmp5.xy = tmp4.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp5 = tex2D(_PrimaryTex, tmp5.xy);
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp6.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp7.xyz = abs(tmp6.xyz) * abs(tmp6.xyz);
                tmp2.xyz = tmp2.xyz * tmp7.yyy;
                tmp2.xyz = tmp7.xxx * tmp5.xyz + tmp2.xyz;
                tmp2.xyz = tmp7.zzz * tmp3.xyz + tmp2.xyz;
                tmp3.xyz = tmp0.yyy * tmp2.xyz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp1.xyz = tmp0.zzz * tmp2.xyz + tmp1.xyz;
                tmp2 = inp.texcoord1.zxxy * _DetailTex_ST + _DetailTex_ST;
                tmp3 = tex2D(_DetailTex, tmp2.zw);
                tmp2 = tex2D(_DetailTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz * tmp7.yyy;
                tmp5.xy = tmp4.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp5 = tex2D(_DetailTex, tmp5.xy);
                tmp2.xyz = tmp7.xxx * tmp5.xyz + tmp2.xyz;
                tmp2.xyz = tmp7.zzz * tmp3.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp3 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp5 = tex2D(_DetailNoiseMask, tmp3.zw);
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp0.w = tmp3.x * tmp7.y;
                tmp3.xy = tmp4.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp0.w = tmp7.x * tmp3.x + tmp0.w;
                tmp0.w = tmp7.z * tmp5.x + tmp0.w;
                tmp0.w = saturate(tmp0.w * 3.0 + -1.5);
                tmp2.xyz = tmp2.xyz * tmp0.www;
                tmp1.xyz = _EnableDetailTex.xxx * tmp2.xyz + tmp1.xyz;
                tmp2 = inp.texcoord1.zxxy * _PrimaryLowerTex_ST + _PrimaryLowerTex_ST;
                tmp3 = tex2D(_PrimaryLowerTex, tmp2.zw);
                tmp2 = tex2D(_PrimaryLowerTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz * tmp7.yyy;
                tmp5.xy = tmp4.zw * _PrimaryLowerTex_ST.xy + _PrimaryLowerTex_ST.zw;
                tmp5 = tex2D(_PrimaryLowerTex, tmp5.xy);
                tmp2.xyz = tmp7.xxx * tmp5.xyz + tmp2.xyz;
                tmp2.xyz = tmp7.zzz * tmp3.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp1.w = inp.texcoord1.y * 0.0010101;
                tmp1.w = trunc(tmp1.w);
                tmp2.w = tmp1.w * 990.0 + _PrimeLowerOffset;
                tmp3.x = -_PrimeLowerScale * 0.5 + tmp2.w;
                tmp2.w = _PrimeLowerScale * 0.5 + tmp2.w;
                tmp3.x = tmp3.x - tmp2.w;
                tmp2.w = inp.texcoord1.y - tmp2.w;
                tmp2.w = saturate(tmp2.w / tmp3.x);
                tmp3.x = tmp2.w > 0.5;
                tmp3.y = tmp2.w - 0.5;
                tmp2.w = tmp2.w + tmp2.w;
                tmp3.y = -tmp3.y * 2.0 + 1.0;
                tmp3.zw = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp5 = tex2D(_Depth, tmp3.zw);
                tmp8 = inp.texcoord1.zxxy * _Depth_ST + _Depth_ST;
                tmp9 = tex2D(_Depth, tmp8.zw);
                tmp8 = tex2D(_Depth, tmp8.xy);
                tmp3.z = tmp7.y * tmp8.x;
                tmp5.yz = tmp4.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp8 = tex2D(_Depth, tmp5.yz);
                tmp3.z = tmp7.x * tmp8.x + tmp3.z;
                tmp3.z = tmp7.z * tmp9.x + tmp3.z;
                tmp0.y = tmp0.y * tmp3.z;
                tmp0.x = tmp0.x * tmp5.x + tmp0.y;
                tmp0.y = tmp3.z - tmp0.x;
                tmp0.x = tmp0.z * tmp0.y + tmp0.x;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.z = 1.0 - tmp0.y;
                tmp0.y = tmp0.y * tmp2.w;
                tmp0.z = -tmp3.y * tmp0.z + 1.0;
                tmp0.y = saturate(tmp3.x ? tmp0.z : tmp0.y);
                tmp0.y = saturate(tmp0.y * 9.999998 + -4.499999);
                tmp2.xyz = tmp2.xyz * tmp0.yyy;
                tmp2.xyw = _PrimeLowerToggle.xxx * tmp2.yzx + tmp1.yzx;
                tmp0.y = tmp2.x >= tmp2.y;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp3.xy = tmp2.yx;
                tmp5.xy = tmp2.xy - tmp3.xy;
                tmp3.zw = float2(-1.0, 0.6666667);
                tmp5.zw = float2(1.0, -1.0);
                tmp3 = tmp0.yyyy * tmp5 + tmp3;
                tmp2.xyz = tmp3.xyw;
                tmp0.y = tmp2.w >= tmp2.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp3.xyw = tmp2.wyx;
                tmp3 = tmp3 - tmp2;
                tmp2 = tmp0.yyyy * tmp3 + tmp2;
                tmp0.y = min(tmp2.y, tmp2.w);
                tmp0.y = tmp2.x - tmp0.y;
                tmp0.z = tmp0.y * 6.0 + 0.0;
                tmp1.x = tmp2.w - tmp2.y;
                tmp0.z = tmp1.x / tmp0.z;
                tmp0.z = tmp0.z + tmp2.z;
                tmp0.z = abs(tmp0.z) + _DifHue;
                tmp0.z = frac(tmp0.z);
                tmp1.xyz = tmp0.zzz + float3(0.0, -0.3333333, 0.3333333);
                tmp1.xyz = frac(tmp1.xyz);
                tmp1.xyz = -tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(abs(tmp1.xyz) * float3(3.0, 3.0, 3.0) + float3(-1.0, -1.0, -1.0));
                tmp1.xyz = tmp1.xyz - float3(1.0, 1.0, 1.0);
                tmp0.z = tmp2.x + 0.0;
                tmp2.x = tmp2.x + _DifVal;
                tmp0.y = tmp0.y / tmp0.z;
                tmp0.y = tmp0.y + _DifSat;
                tmp1.xyz = tmp0.yyy * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp0.y = 1.0 - _DifContrast;
                tmp0.z = _DifContrast - tmp0.y;
                tmp0.y = tmp2.x * tmp0.z + tmp0.y;
                tmp2.xyz = tmp1.xyz * tmp0.yyy + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp0.yyy * tmp1.xyz;
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = _DifOverlay.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = _DifOverlay.www * tmp3.xyz + float3(0.5, 0.5, 0.5);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp2.xyz = -tmp2.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz * tmp5.xyz;
                tmp1.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp3.xyz);
                tmp2.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.y = tmp1.w * 990.0 + _TopRampOffset;
                tmp0.z = -_TopRampScale * 0.5 + tmp0.y;
                tmp0.y = _TopRampScale * 0.5 + tmp0.y;
                tmp0.z = tmp0.z - tmp0.y;
                tmp0.y = inp.texcoord1.y - tmp0.y;
                tmp0.y = saturate(tmp0.y / tmp0.z);
                tmp3.xyz = _RampTop.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = _RampTop.www * tmp3.xyz + float3(0.5, 0.5, 0.5);
                tmp5.xyz = float3(0.5, 0.5, 0.5) - tmp3.xyz;
                tmp3.xyz = tmp0.yyy * tmp5.xyz + tmp3.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp2.xyz = -tmp2.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz * tmp5.xyz;
                tmp1.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp3.xyz);
                tmp2 = inp.texcoord1.zxxy * _TopperDetailTex_ST + _TopperDetailTex_ST;
                tmp3 = tex2D(_TopperDetailTex, tmp2.zw);
                tmp2 = tex2D(_TopperDetailTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz * tmp7.yyy;
                tmp0.yz = tmp4.zw * _TopperDetailTex_ST.xy + _TopperDetailTex_ST.zw;
                tmp5 = tex2D(_TopperDetailTex, tmp0.yz);
                tmp2.xyz = tmp7.xxx * tmp5.xyz + tmp2.xyz;
                tmp2.xyz = tmp7.zzz * tmp3.xyz + tmp2.xyz;
                tmp3 = inp.texcoord1.zxxy * _Topper_MainTex_ST + _Topper_MainTex_ST;
                tmp5 = tex2D(_Topper_MainTex, tmp3.zw);
                tmp3 = tex2D(_Topper_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * tmp7.yyy;
                tmp0.yz = tmp4.zw * _Topper_MainTex_ST.xy + _Topper_MainTex_ST.zw;
                tmp8 = tex2D(_Topper_MainTex, tmp0.yz);
                tmp3.xyz = tmp7.xxx * tmp8.xyz + tmp3.xyz;
                tmp3.xyz = tmp7.zzz * tmp5.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = _TopperEnableDetailTex.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp0.y = saturate(_ToporBottom * 2.0 + -1.0);
                tmp0.z = saturate(-tmp6.y);
                tmp0.z = tmp0.z - abs(tmp6.y);
                tmp0.y = tmp0.y * tmp0.z + abs(tmp6.y);
                tmp0.z = _ToporBottom + _ToporBottom;
                tmp0.z = saturate(tmp0.z);
                tmp2.w = saturate(tmp6.y);
                tmp3.x = abs(tmp6.y) - tmp2.w;
                tmp0.z = tmp0.z * tmp3.x + tmp2.w;
                tmp0.y = tmp0.y - tmp0.z;
                tmp3.x = round(_ToporBottom);
                tmp0.y = tmp3.x * tmp0.y + tmp0.z;
                tmp0.y = max(tmp0.y, _TopperSides);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * _TopperCoverage;
                tmp0.y = tmp0.y * 1.25;
                tmp3 = inp.texcoord1.zxxy * _TopperDepth_ST + _TopperDepth_ST;
                tmp5 = tex2D(_TopperDepth, tmp3.zw);
                tmp3 = tex2D(_TopperDepth, tmp3.xy);
                tmp0.z = tmp3.x * tmp7.y;
                tmp3.xy = tmp4.zw * _TopperDepth_ST.xy + _TopperDepth_ST.zw;
                tmp3.zw = tmp4.zw * _TopperSpecular_ST.xy + _TopperSpecular_ST.zw;
                tmp8 = tex2D(_TopperSpecular, tmp3.zw);
                tmp3 = tex2D(_TopperDepth, tmp3.xy);
                tmp0.z = tmp7.x * tmp3.x + tmp0.z;
                tmp0.z = tmp7.z * tmp5.x + tmp0.z;
                tmp0.z = tmp0.z - 0.5;
                tmp0.z = _TopperDepthStrength * tmp0.z + 0.5;
                tmp3.x = 1.0 - tmp0.z;
                tmp0.z = tmp0.z - tmp0.x;
                tmp3.x = tmp3.x / tmp0.y;
                tmp3.x = saturate(1.0 - tmp3.x);
                tmp3.x = 1.0 - tmp3.x;
                tmp3.y = saturate(tmp0.x);
                tmp0.y = tmp3.y * -0.667 + tmp0.y;
                tmp0.y = tmp0.y + 0.667;
                tmp0.y = tmp3.x / tmp0.y;
                tmp0.y = saturate(1.0 - tmp0.y);
                tmp0.y = tmp0.y * 8.0;
                tmp0.y = min(tmp0.y, 1.0);
                tmp1.xyz = tmp0.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.x = tmp1.w * 990.0 + _SeaLevelRampOffset;
                tmp1.w = tmp1.w * 990.0 + _RampOffset;
                tmp3.x = inp.texcoord1.y - tmp3.x;
                tmp3.x = tmp3.x * _SeaLevelRampScale;
                tmp3.x = saturate(tmp3.x * 0.2 + 0.5);
                tmp3.yzw = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp3.xyz = tmp3.xxx * tmp3.yzw + _SeaLevelRampLower.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp3.w = inp.texcoord1.y - _WorldSpaceCameraPos.y;
                tmp3.w = tmp3.w * _RampScale;
                tmp1.w = tmp3.w * 0.1 + -tmp1.w;
                tmp1.w = saturate(tmp1.w * 0.5 + 0.5);
                tmp9.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp10.xyz = tmp1.www * tmp9.xyz;
                tmp9.xyz = tmp1.www * tmp9.xyz + float3(0.5, 0.5, 0.5);
                tmp10.xyz = -tmp10.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp10.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp10.xyz = tmp9.xyz + tmp9.xyz;
                tmp9.xyz = tmp9.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz * tmp10.xyz;
                tmp3.xyz = saturate(tmp9.xyz ? tmp5.xyz : tmp3.xyz);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp2.xyz = -tmp2.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz * tmp5.xyz;
                tmp1.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp3.xyz);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = saturate(tmp1.xyz * tmp2.xyz);
                tmp3.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp4.zw = inp.texcoord1.xy * float2(-1.0, 1.0) + float2(1.0, 0.0);
                tmp4.zw = tmp4.zw * _VerticalRamp_ST.xy + _VerticalRamp_ST.zw;
                tmp5 = tex2D(_VerticalRamp, tmp4.zw);
                tmp9.x = dot(tmp4.xy, float2(0.0000003, -1.0));
                tmp9.y = dot(tmp4.xy, float2(1.0, 0.0000003));
                tmp4.xy = tmp9.xy + float2(0.5, 0.5);
                tmp4.xy = tmp4.xy * _VerticalRamp_ST.xy + _VerticalRamp_ST.zw;
                tmp4 = tex2D(_VerticalRamp, tmp4.xy);
                tmp1.w = tmp7.y * 0.5;
                tmp4.xyz = tmp7.xxx * tmp4.xyz + tmp1.www;
                tmp4.xyz = tmp7.zzz * tmp5.xyz + tmp4.xyz;
                tmp5.xyz = float3(0.5, 0.5, 0.5) - tmp4.xyz;
                tmp4.xyz = tmp0.yyy * tmp5.xyz + tmp4.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp3.xyz = -tmp3.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz * tmp5.xyz;
                tmp2.xyz = saturate(tmp2.xyz ? tmp3.xyz : tmp4.xyz);
                tmp3 = inp.texcoord1.zxxy * _TopperSpecular_ST + _TopperSpecular_ST;
                tmp4 = tex2D(_TopperSpecular, tmp3.xy);
                tmp3 = tex2D(_TopperSpecular, tmp3.zw);
                tmp4.xyz = tmp4.xyz * tmp7.yyy;
                tmp4.xyz = tmp7.xxx * tmp8.xyz + tmp4.xyz;
                tmp3.xyz = tmp7.zzz * tmp3.xyz + tmp4.xyz;
                tmp4.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp1.www * tmp4.xyz;
                tmp1.w = dot(tmp6.xyz, tmp4.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp3.w = tmp0.y * tmp1.w + tmp0.y;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.y = tmp3.w * 0.5;
                tmp3.xyz = tmp0.yyy * tmp3.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.y = 1.0 - _TopperSpecularNoiseAdjust;
                tmp0.z = _TopperSpecularNoiseAdjust - tmp0.y;
                tmp0.y = tmp0.w * tmp0.z + tmp0.y;
                tmp5.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp0.y = saturate(tmp0.y + tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp3.xyz;
                tmp3.x = dot(-tmp4.xyz, tmp6.xyz);
                tmp3.x = tmp3.x + tmp3.x;
                tmp3.xyz = tmp6.xyz * -tmp3.xxx + -tmp4.xyz;
                tmp3.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp4.xyz = tmp3.www * _WorldSpaceLightPos0.xyz;
                tmp3.x = dot(tmp4.xyz, tmp3.xyz);
                tmp3.y = dot(tmp4.xyz, tmp6.xyz);
                tmp3.xy = max(tmp3.xy, float2(0.0, 0.0));
                tmp3.x = log(tmp3.x);
                tmp3.z = _GlossPower * 16.0 + -1.0;
                tmp3.z = exp(tmp3.z);
                tmp3.x = tmp3.x * tmp3.z;
                tmp3.x = exp(tmp3.x);
                tmp3.x = tmp3.x * _Gloss;
                tmp3.xzw = tmp3.xxx * _LightColor0.xyz;
                tmp3.xzw = tmp3.xzw * _Gloss.xxx;
                tmp3.xzw = tmp0.yzw * tmp3.xzw;
                tmp3.xzw = saturate(tmp3.xzw * float3(50.0, 50.0, 50.0));
                tmp4.xyz = tmp3.xzw - float3(0.5, 0.5, 0.5);
                tmp4.xyz = -tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp7.xyz = float3(1.0, 1.0, 1.0) - _SpecularColor.xyz;
                tmp4.xyz = -tmp4.xyz * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp3.xzw + tmp3.xzw;
                tmp3.xzw = tmp3.xzw > float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp7.xyz * _SpecularColor.xyz;
                tmp3.xzw = saturate(tmp3.xzw ? tmp4.xyz : tmp7.xyz);
                tmp4.x = _EmissiveColor.w * 10.0;
                tmp4.xyz = tmp4.xxx * _EmissiveColor.xyz;
                tmp0.yzw = tmp0.yzw * tmp4.xyz;
                tmp4.x = tmp5.x * 0.01 + _Time.y;
                tmp4.x = tmp5.y * 0.01 + tmp4.x;
                tmp4.x = tmp5.z * 0.01 + tmp4.x;
                tmp4.x = sin(tmp4.x);
                tmp4.x = tmp4.x * 0.75 + 0.75;
                tmp0.yzw = tmp0.yzw * tmp4.xxx + tmp3.xzw;
                tmp2.xyz = tmp0.yzw + tmp2.xyz;
                tmp4 = tmp0.xxxx * float4(5.0, 0.33, 0.1, 0.5) + float4(-1.0, 0.33, 0.45, 0.25);
                tmp3.x = tmp4.z - tmp4.y;
                tmp3.z = saturate(tmp6.y * 2.0 + -1.0);
                tmp3.w = dot(abs(tmp6.xy), float2(0.333, 0.333));
                tmp2.w = tmp2.w + tmp3.w;
                tmp3.x = tmp3.z * tmp3.x + tmp4.y;
                tmp3.w = 1.0 - tmp3.x;
                tmp4.y = tmp3.y - 0.5;
                tmp4.y = -tmp4.y * 2.0 + 1.0;
                tmp3.w = -tmp4.y * tmp3.w + 1.0;
                tmp4.y = tmp3.y + tmp3.y;
                tmp3.y = tmp3.y > 0.5;
                tmp3.x = tmp3.x * tmp4.y;
                tmp3.x = saturate(tmp3.y ? tmp3.w : tmp3.x);
                tmp3.yz = float2(1.0, 1.0) - tmp3.xz;
                tmp3.w = 1.0 - tmp4.w;
                tmp4.y = log(tmp1.w);
                tmp4.y = tmp4.y * 2.5;
                tmp4.y = exp(tmp4.y);
                tmp4.z = tmp4.y - 0.5;
                tmp4.z = -tmp4.z * 2.0 + 1.0;
                tmp3.w = -tmp4.z * tmp3.w + 1.0;
                tmp4.z = tmp4.y + tmp4.y;
                tmp4.y = tmp4.y > 0.5;
                tmp4.z = tmp4.w * tmp4.z;
                tmp4.x = saturate(tmp4.x);
                tmp3.w = saturate(tmp4.y ? tmp3.w : tmp4.z);
                tmp3.w = saturate(tmp3.w * 8.0 + -3.0);
                tmp3.y = tmp3.w * tmp3.y;
                tmp3.y = tmp4.x * tmp3.y;
                tmp3.y = tmp3.z * tmp3.y;
                tmp3.y = tmp3.y * _PaintRim;
                tmp3.y = tmp3.y * 0.25;
                tmp4.xyz = glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _LightColor0.xyz;
                tmp4.xyz = tmp3.yyy * tmp4.xyz + tmp1.xyz;
                tmp3.yzw = tmp3.yyy * tmp4.xyz;
                tmp2.xyz = tmp3.yzw * float3(0.7, 0.7, 0.7) + tmp2.xyz;
                tmp3.y = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp3.y;
                tmp3.y = tmp2.w * tmp2.w;
                tmp4.xyz = tmp2.www * tmp2.www + glstate_lightmodel_ambient.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp4.xyz = tmp4.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.75, 0.75, 0.75));
                tmp4.xyz = min(tmp4.xyz, float3(1.0, 1.0, 1.0));
                tmp1.w = tmp1.w * tmp3.y;
                tmp0.x = tmp0.x * tmp1.w;
                tmp3.yzw = tmp0.xxx * float3(0.75, 0.75, 0.75) + tmp4.xyz;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = floor(tmp0.x);
                tmp0.x = tmp3.x * 13.0 + tmp0.x;
                tmp0.x = saturate(tmp0.x - 5.0);
                tmp3.xyz = tmp3.yzw * _LightColor0.xyz;
                tmp4.xyz = tmp0.xxx * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * tmp0.xxx + float3(-0.5, -0.5, -0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp1.xyz * tmp4.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp5.xyz ? tmp1.xyz : tmp4.xyz);
                tmp0.xyz = tmp0.yzw + tmp1.xyz;
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
			GpuProgramID 89483
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
			float _TopperSides;
			float4 _PrimaryLowerTex_ST;
			float _PrimeLowerOffset;
			float _PrimeLowerScale;
			float _PrimeLowerToggle;
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
			sampler2D _PrimaryLowerTex;
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
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
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                tmp0.x = _UseMeshUVs >= 0.0;
                tmp0.y = _UseMeshUVs <= 0.0;
                tmp0.xy = tmp0.xy ? 1.0 : 0.0;
                tmp0.z = tmp0.y * tmp0.x;
                tmp1.xy = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp1 = tex2D(_PrimaryTex, tmp1.xy);
                tmp2 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp3 = tex2D(_PrimaryTex, tmp2.zw);
                tmp2 = tex2D(_PrimaryTex, tmp2.xy);
                tmp4.xy = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp5.x = dot(tmp4.xy, float2(0.0000003, -1.0));
                tmp5.y = dot(tmp4.xy, float2(1.0, 0.0000003));
                tmp4.xy = tmp5.xy + float2(0.5, 0.5);
                tmp4.zw = tmp4.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp5 = tex2D(_PrimaryTex, tmp4.zw);
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp6.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp7.xyz = abs(tmp6.xyz) * abs(tmp6.xyz);
                tmp2.xyz = tmp2.xyz * tmp7.yyy;
                tmp2.xyz = tmp7.xxx * tmp5.xyz + tmp2.xyz;
                tmp2.xyz = tmp7.zzz * tmp3.xyz + tmp2.xyz;
                tmp3.xyz = tmp0.yyy * tmp2.xyz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp1.xyz = tmp0.zzz * tmp2.xyz + tmp1.xyz;
                tmp2 = inp.texcoord1.zxxy * _DetailTex_ST + _DetailTex_ST;
                tmp3 = tex2D(_DetailTex, tmp2.zw);
                tmp2 = tex2D(_DetailTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz * tmp7.yyy;
                tmp4.zw = tmp4.xy * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp5 = tex2D(_DetailTex, tmp4.zw);
                tmp2.xyz = tmp7.xxx * tmp5.xyz + tmp2.xyz;
                tmp2.xyz = tmp7.zzz * tmp3.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp3 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp5 = tex2D(_DetailNoiseMask, tmp3.zw);
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp0.w = tmp3.x * tmp7.y;
                tmp3.xy = tmp4.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp0.w = tmp7.x * tmp3.x + tmp0.w;
                tmp0.w = tmp7.z * tmp5.x + tmp0.w;
                tmp0.w = saturate(tmp0.w * 3.0 + -1.5);
                tmp2.xyz = tmp2.xyz * tmp0.www;
                tmp1.xyz = _EnableDetailTex.xxx * tmp2.xyz + tmp1.xyz;
                tmp2 = inp.texcoord1.zxxy * _PrimaryLowerTex_ST + _PrimaryLowerTex_ST;
                tmp3 = tex2D(_PrimaryLowerTex, tmp2.zw);
                tmp2 = tex2D(_PrimaryLowerTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz * tmp7.yyy;
                tmp4.zw = tmp4.xy * _PrimaryLowerTex_ST.xy + _PrimaryLowerTex_ST.zw;
                tmp5 = tex2D(_PrimaryLowerTex, tmp4.zw);
                tmp2.xyz = tmp7.xxx * tmp5.xyz + tmp2.xyz;
                tmp2.xyz = tmp7.zzz * tmp3.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp1.w = inp.texcoord1.y * 0.0010101;
                tmp1.w = trunc(tmp1.w);
                tmp2.w = tmp1.w * 990.0 + _PrimeLowerOffset;
                tmp3.x = -_PrimeLowerScale * 0.5 + tmp2.w;
                tmp2.w = _PrimeLowerScale * 0.5 + tmp2.w;
                tmp3.x = tmp3.x - tmp2.w;
                tmp2.w = inp.texcoord1.y - tmp2.w;
                tmp2.w = saturate(tmp2.w / tmp3.x);
                tmp3.x = tmp2.w > 0.5;
                tmp3.y = tmp2.w - 0.5;
                tmp3.y = -tmp3.y * 2.0 + 1.0;
                tmp3.zw = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp5 = tex2D(_Depth, tmp3.zw);
                tmp8 = inp.texcoord1.zxxy * _Depth_ST + _Depth_ST;
                tmp9 = tex2D(_Depth, tmp8.zw);
                tmp8 = tex2D(_Depth, tmp8.xy);
                tmp3.z = tmp7.y * tmp8.x;
                tmp4.zw = tmp4.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp8 = tex2D(_Depth, tmp4.zw);
                tmp3.z = tmp7.x * tmp8.x + tmp3.z;
                tmp3.z = tmp7.z * tmp9.x + tmp3.z;
                tmp0.y = tmp0.y * tmp3.z;
                tmp0.x = tmp0.x * tmp5.x + tmp0.y;
                tmp0.y = tmp3.z - tmp0.x;
                tmp0.x = tmp0.z * tmp0.y + tmp0.x;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.z = 1.0 - tmp0.y;
                tmp0.y = dot(tmp0.xy, tmp2.xy);
                tmp0.z = -tmp3.y * tmp0.z + 1.0;
                tmp0.y = saturate(tmp3.x ? tmp0.z : tmp0.y);
                tmp0.y = saturate(tmp0.y * 9.999998 + -4.499999);
                tmp2.xyz = tmp2.xyz * tmp0.yyy;
                tmp2.xyw = _PrimeLowerToggle.xxx * tmp2.yzx + tmp1.yzx;
                tmp0.y = tmp2.x >= tmp2.y;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp3.xy = tmp2.yx;
                tmp5.xy = tmp2.xy - tmp3.xy;
                tmp3.zw = float2(-1.0, 0.6666667);
                tmp5.zw = float2(1.0, -1.0);
                tmp3 = tmp0.yyyy * tmp5 + tmp3;
                tmp2.xyz = tmp3.xyw;
                tmp0.y = tmp2.w >= tmp2.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp3.xyw = tmp2.wyx;
                tmp3 = tmp3 - tmp2;
                tmp2 = tmp0.yyyy * tmp3 + tmp2;
                tmp0.y = min(tmp2.y, tmp2.w);
                tmp0.y = tmp2.x - tmp0.y;
                tmp0.z = tmp0.y * 6.0 + 0.0;
                tmp1.x = tmp2.w - tmp2.y;
                tmp0.z = tmp1.x / tmp0.z;
                tmp0.z = tmp0.z + tmp2.z;
                tmp0.z = abs(tmp0.z) + _DifHue;
                tmp0.z = frac(tmp0.z);
                tmp1.xyz = tmp0.zzz + float3(0.0, -0.3333333, 0.3333333);
                tmp1.xyz = frac(tmp1.xyz);
                tmp1.xyz = -tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(abs(tmp1.xyz) * float3(3.0, 3.0, 3.0) + float3(-1.0, -1.0, -1.0));
                tmp1.xyz = tmp1.xyz - float3(1.0, 1.0, 1.0);
                tmp0.z = tmp2.x + 0.0;
                tmp2.x = tmp2.x + _DifVal;
                tmp0.y = tmp0.y / tmp0.z;
                tmp0.y = tmp0.y + _DifSat;
                tmp1.xyz = tmp0.yyy * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp0.y = 1.0 - _DifContrast;
                tmp0.z = _DifContrast - tmp0.y;
                tmp0.y = tmp2.x * tmp0.z + tmp0.y;
                tmp2.xyz = tmp1.xyz * tmp0.yyy + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp0.yyy * tmp1.xyz;
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = _DifOverlay.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = _DifOverlay.www * tmp3.xyz + float3(0.5, 0.5, 0.5);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp3.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp2.xyz = -tmp2.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp3.xyz);
                tmp2.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.y = tmp1.w * 990.0 + _TopRampOffset;
                tmp0.z = -_TopRampScale * 0.5 + tmp0.y;
                tmp0.y = _TopRampScale * 0.5 + tmp0.y;
                tmp0.z = tmp0.z - tmp0.y;
                tmp0.y = inp.texcoord1.y - tmp0.y;
                tmp0.y = saturate(tmp0.y / tmp0.z);
                tmp3.xyz = _RampTop.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = _RampTop.www * tmp3.xyz + float3(0.5, 0.5, 0.5);
                tmp5.xyz = float3(0.5, 0.5, 0.5) - tmp3.xyz;
                tmp3.xyz = tmp0.yyy * tmp5.xyz + tmp3.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp3.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp2.xyz = -tmp2.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp3.xyz);
                tmp2 = inp.texcoord1.zxxy * _TopperDetailTex_ST + _TopperDetailTex_ST;
                tmp3 = tex2D(_TopperDetailTex, tmp2.zw);
                tmp2 = tex2D(_TopperDetailTex, tmp2.xy);
                tmp2.xyz = tmp2.xyz * tmp7.yyy;
                tmp0.yz = tmp4.xy * _TopperDetailTex_ST.xy + _TopperDetailTex_ST.zw;
                tmp5 = tex2D(_TopperDetailTex, tmp0.yz);
                tmp2.xyz = tmp7.xxx * tmp5.xyz + tmp2.xyz;
                tmp2.xyz = tmp7.zzz * tmp3.xyz + tmp2.xyz;
                tmp3 = inp.texcoord1.zxxy * _Topper_MainTex_ST + _Topper_MainTex_ST;
                tmp5 = tex2D(_Topper_MainTex, tmp3.zw);
                tmp3 = tex2D(_Topper_MainTex, tmp3.xy);
                tmp3.xyz = tmp3.xyz * tmp7.yyy;
                tmp0.yz = tmp4.xy * _Topper_MainTex_ST.xy + _Topper_MainTex_ST.zw;
                tmp8 = tex2D(_Topper_MainTex, tmp0.yz);
                tmp3.xyz = tmp7.xxx * tmp8.xyz + tmp3.xyz;
                tmp3.xyz = tmp7.zzz * tmp5.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = _TopperEnableDetailTex.xxx * tmp2.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp0.y = saturate(_ToporBottom * 2.0 + -1.0);
                tmp0.z = saturate(-tmp6.y);
                tmp0.z = tmp0.z - abs(tmp6.y);
                tmp0.y = tmp0.y * tmp0.z + abs(tmp6.y);
                tmp0.z = _ToporBottom + _ToporBottom;
                tmp0.z = saturate(tmp0.z);
                tmp2.w = saturate(tmp6.y);
                tmp3.x = abs(tmp6.y) - tmp2.w;
                tmp0.z = tmp0.z * tmp3.x + tmp2.w;
                tmp0.y = tmp0.y - tmp0.z;
                tmp3.x = round(_ToporBottom);
                tmp0.y = tmp3.x * tmp0.y + tmp0.z;
                tmp0.y = max(tmp0.y, _TopperSides);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * _TopperCoverage;
                tmp0.y = tmp0.y * 1.25;
                tmp3 = inp.texcoord1.zxxy * _TopperDepth_ST + _TopperDepth_ST;
                tmp5 = tex2D(_TopperDepth, tmp3.zw);
                tmp3 = tex2D(_TopperDepth, tmp3.xy);
                tmp0.z = tmp3.x * tmp7.y;
                tmp3.xy = tmp4.xy * _TopperDepth_ST.xy + _TopperDepth_ST.zw;
                tmp3.zw = tmp4.xy * _TopperSpecular_ST.xy + _TopperSpecular_ST.zw;
                tmp4 = tex2D(_TopperSpecular, tmp3.zw);
                tmp3 = tex2D(_TopperDepth, tmp3.xy);
                tmp0.z = tmp7.x * tmp3.x + tmp0.z;
                tmp0.z = tmp7.z * tmp5.x + tmp0.z;
                tmp0.z = tmp0.z - 0.5;
                tmp0.z = _TopperDepthStrength * tmp0.z + 0.5;
                tmp3.x = 1.0 - tmp0.z;
                tmp0.z = tmp0.z - tmp0.x;
                tmp3.x = tmp3.x / tmp0.y;
                tmp3.x = saturate(1.0 - tmp3.x);
                tmp3.x = 1.0 - tmp3.x;
                tmp3.y = saturate(tmp0.x);
                tmp0.y = tmp3.y * -0.667 + tmp0.y;
                tmp0.y = tmp0.y + 0.667;
                tmp0.y = tmp3.x / tmp0.y;
                tmp0.y = saturate(1.0 - tmp0.y);
                tmp0.y = tmp0.y * 8.0;
                tmp0.y = min(tmp0.y, 1.0);
                tmp1.xyz = tmp0.yyy * tmp2.xyz + tmp1.xyz;
                tmp2.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.x = tmp1.w * 990.0 + _SeaLevelRampOffset;
                tmp1.w = tmp1.w * 990.0 + _RampOffset;
                tmp3.x = inp.texcoord1.y - tmp3.x;
                tmp3.x = tmp3.x * _SeaLevelRampScale;
                tmp3.x = saturate(tmp3.x * 0.2 + 0.5);
                tmp3.yzw = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp3.xyz = tmp3.xxx * tmp3.yzw + _SeaLevelRampLower.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp3.w = inp.texcoord1.y - _WorldSpaceCameraPos.y;
                tmp3.w = tmp3.w * _RampScale;
                tmp1.w = tmp3.w * 0.1 + -tmp1.w;
                tmp1.w = saturate(tmp1.w * 0.5 + 0.5);
                tmp8.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp9.xyz = tmp1.www * tmp8.xyz;
                tmp8.xyz = tmp1.www * tmp8.xyz + float3(0.5, 0.5, 0.5);
                tmp9.xyz = -tmp9.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp9.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp3.xyz * tmp8.xyz;
                tmp8.xyz = tmp8.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp3.xyz = saturate(tmp8.xyz ? tmp5.xyz : tmp3.xyz);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp3.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp2.xyz = -tmp2.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp3.xyz);
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp3.xy = tmp0.xx * float2(0.33, 0.1) + float2(0.33, 0.45);
                tmp0.z = tmp3.y - tmp3.x;
                tmp1.w = saturate(tmp6.y * 2.0 + -1.0);
                tmp0.z = tmp1.w * tmp0.z + tmp3.x;
                tmp1.w = 1.0 - tmp0.z;
                tmp3.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp3.w = dot(tmp3.xyz, tmp3.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp3.w = dot(tmp3.xyz, tmp6.xyz);
                tmp3.w = max(tmp3.w, 0.0);
                tmp4.w = tmp3.w - 0.5;
                tmp4.w = -tmp4.w * 2.0 + 1.0;
                tmp1.w = -tmp4.w * tmp1.w + 1.0;
                tmp0.z = dot(tmp0.xy, tmp3.xy);
                tmp3.w = tmp3.w > 0.5;
                tmp0.z = saturate(tmp3.w ? tmp1.w : tmp0.z);
                tmp1.w = dot(abs(tmp6.xy), float2(0.333, 0.333));
                tmp1.w = tmp2.w + tmp1.w;
                tmp2.w = tmp1.w * tmp1.w;
                tmp5.xyz = tmp1.www * tmp1.www + glstate_lightmodel_ambient.xyz;
                tmp5.xyz = tmp5.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp5.xyz = tmp5.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp5.xyz = max(tmp5.xyz, float3(0.75, 0.75, 0.75));
                tmp5.xyz = min(tmp5.xyz, float3(1.0, 1.0, 1.0));
                tmp8.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp8.xyz, tmp8.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp8.xyz = tmp1.www * tmp8.xyz;
                tmp1.w = dot(tmp6.xyz, tmp8.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp3.w = tmp1.w * tmp1.w;
                tmp3.w = tmp1.w * tmp3.w;
                tmp0.y = tmp0.y * tmp1.w + tmp0.y;
                tmp0.y = tmp0.y * 0.5;
                tmp1.w = tmp2.w * tmp3.w;
                tmp1.w = tmp0.x * tmp1.w;
                tmp2.w = tmp1.w + tmp1.w;
                tmp5.xyz = tmp1.www * float3(0.75, 0.75, 0.75) + tmp5.xyz;
                tmp1.w = floor(tmp2.w);
                tmp0.z = tmp0.z * 13.0 + tmp1.w;
                tmp0.z = saturate(tmp0.z - 5.0);
                tmp1.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp9 = tex2D(_LightTexture0, tmp1.ww);
                tmp9.xyz = tmp9.xxx * _LightColor0.xyz;
                tmp5.xyz = tmp5.xyz * tmp9.xyz;
                tmp10.xyz = tmp5.xyz * tmp0.zzz + float3(-0.5, -0.5, -0.5);
                tmp5.xyz = tmp0.zzz * tmp5.xyz;
                tmp10.xyz = -tmp10.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp10.xyz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.xyz * tmp5.xyz;
                tmp5.xyz = tmp5.xyz > float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp1.xyz = saturate(tmp5.xyz ? tmp2.xyz : tmp1.xyz);
                tmp0.z = dot(-tmp8.xyz, tmp6.xyz);
                tmp0.z = tmp0.z + tmp0.z;
                tmp2.xyz = tmp6.xyz * -tmp0.zzz + -tmp8.xyz;
                tmp0.z = dot(tmp3.xyz, tmp2.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = log(tmp0.z);
                tmp1.w = _GlossPower * 16.0 + -1.0;
                tmp1.w = exp(tmp1.w);
                tmp0.z = tmp0.z * tmp1.w;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp0.z * _Gloss;
                tmp2.xyz = tmp0.zzz * tmp9.xyz;
                tmp2.xyz = tmp2.xyz * _Gloss.xxx;
                tmp3 = inp.texcoord1.zxxy * _TopperSpecular_ST + _TopperSpecular_ST;
                tmp5 = tex2D(_TopperSpecular, tmp3.xy);
                tmp3 = tex2D(_TopperSpecular, tmp3.zw);
                tmp5.xyz = tmp5.xyz * tmp7.yyy;
                tmp4.xyz = tmp7.xxx * tmp4.xyz + tmp5.xyz;
                tmp3.xyz = tmp7.zzz * tmp3.xyz + tmp4.xyz;
                tmp3.xyz = tmp0.yyy * tmp3.xyz;
                tmp0.xyz = tmp0.xxx * tmp3.xyz;
                tmp1.w = 1.0 - _TopperSpecularNoiseAdjust;
                tmp2.w = _TopperSpecularNoiseAdjust - tmp1.w;
                tmp1.w = tmp0.w * tmp2.w + tmp1.w;
                tmp3.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp0.w = saturate(tmp1.w + tmp1.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp2.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = saturate(tmp2.xyz * float3(50.0, 50.0, 50.0));
                tmp4.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp2.xyz * _SpecularColor.xyz;
                tmp2.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp5.xyz + tmp5.xyz;
                tmp6.xyz = float3(1.0, 1.0, 1.0) - _SpecularColor.xyz;
                tmp2.xyz = -tmp2.xyz * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = saturate(tmp4.xyz ? tmp2.xyz : tmp5.xyz);
                tmp0.w = _EmissiveColor.w * 10.0;
                tmp4.xyz = tmp0.www * _EmissiveColor.xyz;
                tmp0.xyz = tmp0.xyz * tmp4.xyz;
                tmp0.w = tmp3.x * 0.01 + _Time.y;
                tmp0.w = tmp3.y * 0.01 + tmp0.w;
                tmp0.w = tmp3.z * 0.01 + tmp0.w;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 0.75 + 0.75;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp2.xyz;
                o.sv_target.xyz = tmp1.xyz + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}