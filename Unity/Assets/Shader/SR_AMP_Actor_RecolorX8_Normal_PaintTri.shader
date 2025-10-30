Shader "SR/AMP/Actor/RecolorX8_Normal_PaintTri" {
	Properties {
		[Toggle(_AOUV1_ON)] _AOUV1 ("AO UV 1", Float) = 0
		[NoScaleOffset] _AmbientOcclusion ("Ambient Occlusion", 2D) = "white" {}
		[Toggle(_OVERRIDEUV1_ON)] _OverrideUV1 ("Override UV 1", Float) = 0
		[NoScaleOffset] _Override ("Override", 2D) = "black" {}
		[Toggle(_NRMUV1_ON)] _NRMUV1 ("NRM UV 1", Float) = 0
		[NoScaleOffset] _Normal ("Normal", 2D) = "bump" {}
		[NoScaleOffset] _ColorMask ("Color Mask", 2D) = "black" {}
		_Color00 ("Red Dark (Glow)", Color) = (0.5,0,0,0)
		_Color01 ("Red Light (Gloss)", Color) = (1,0,0,0)
		_Color10 ("Green Dark (Glow)", Color) = (0,0.5,0,0)
		_Color11 ("Green Light (Gloss)", Color) = (0,1,0,0)
		_Color20 ("Blue Dark (Glow)", Color) = (0,0,0.5,0)
		_Color21 ("Blue Light (Gloss)", Color) = (0,0,1,0)
		_Color30 ("Black Dark (Glow)", Color) = (0,0,0,0)
		_Color31 ("Black Light (Gloss)", Color) = (0.5,0.5,0.5,0)
		_Color40 ("Magenta Dark (Glow)", Color) = (0.5,0,0.5,0)
		_Color41 ("Magenta Light (Gloss)", Color) = (1,0,1,0)
		_Color50 ("Yellow Dark (Glow)", Color) = (0.5,0.5,0,0)
		_Color51 ("Yellow Light (Gloss)", Color) = (1,1,0,0)
		_Color60 ("Cyan Dark (Glow)", Color) = (0,0.5,0.5,0)
		_Color61 ("Cyan Light (Gloss)", Color) = (0,1,1,0)
		_Color70 ("White Dark (Glow)", Color) = (0.5,0.5,0.5,0)
		_Color71 ("White Light (Gloss)", Color) = (1,1,1,0)
		[NoScaleOffset] _RampAlphaGlow ("Ramp Alpha (Glow)", 2D) = "black" {}
		_SpiralColor ("Glow Shift", Range(0, 1)) = 0.5
		_GlowMultiplier ("Glow Multiplier", Float) = 1
		_GlowSpeed ("Glow Speed", Float) = 0
		[NoScaleOffset] _Rim ("Rim", 2D) = "black" {}
		_RimStrength ("Rim Strength", Range(0, 1)) = 0
		_PaintStrokes ("PaintStrokes", 2D) = "gray" {}
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] _texcoord2 ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "DisableBatching" = "true" "IsEmissive" = "true" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 876
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
				float4 texcoord6 : TEXCOORD6;
				float4 texcoord7 : TEXCOORD7;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord2_ST;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _SpecColor;
			float4 _Color30;
			float4 _Color00;
			float4 _Color10;
			float4 _Color20;
			float4 _Color40;
			float4 _Color50;
			float4 _Color60;
			float4 _Color70;
			float4 _Color31;
			float4 _Color01;
			float4 _Color11;
			float4 _Color21;
			float4 _Color51;
			float4 _Color61;
			float4 _Color71;
			float _SpiralColor;
			float _GlowSpeed;
			float _GlowMultiplier;
			float4 _PaintStrokes_ST;
			float _RimStrength;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			CBUFFER_START(SRAMPActorRecolorX8_Normal_PaintTri)
				float4 _Color41;
			CBUFFER_END
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _ColorMask;
			sampler2D _AmbientOcclusion;
			sampler2D _Override;
			sampler2D _RampAlphaGlow;
			sampler2D _PaintStrokes;
			sampler2D _Rim;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord1.xy * _texcoord2_ST.xy + _texcoord2_ST.zw;
                o.texcoord.zw = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord1.w = tmp0.x;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = tmp1.xyz * tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx + -tmp3.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord1.y = tmp3.x;
                o.texcoord1.x = tmp2.z;
                o.texcoord1.z = tmp1.y;
                o.texcoord2.x = tmp2.x;
                o.texcoord3.x = tmp2.y;
                o.texcoord2.z = tmp1.z;
                o.texcoord3.z = tmp1.x;
                o.texcoord2.w = tmp0.y;
                o.texcoord3.w = tmp0.z;
                o.texcoord2.y = tmp3.y;
                o.texcoord3.y = tmp3.z;
                o.color = v.color;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
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
                float4 tmp9;
                float4 tmp10;
                tmp0.y = inp.texcoord1.w;
                tmp0.z = inp.texcoord2.w;
                tmp0.w = inp.texcoord3.w;
                tmp1.xyz = _WorldSpaceCameraPos - tmp0.yzw;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp1.xyz;
                tmp3 = tex2D(_Normal, inp.texcoord.xy);
                tmp3.x = tmp3.w * tmp3.x;
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp3.xy, tmp3.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp3.z = sqrt(tmp1.w);
                tmp4 = tex2D(_ColorMask, inp.texcoord.zw);
                tmp1.w = tmp4.y * tmp4.x;
                tmp1.w = tmp4.z * tmp1.w;
                tmp5 = _Color00 - _Color30;
                tmp5 = tmp4.xxxx * tmp5 + _Color30;
                tmp6 = _Color10 - tmp5;
                tmp5 = tmp4.yyyy * tmp6 + tmp5;
                tmp6 = _Color20 - tmp5;
                tmp5 = tmp4.zzzz * tmp6 + tmp5;
                tmp6.xyz = tmp4.xxy * tmp4.zyz + -tmp1.www;
                tmp7 = _Color40 - tmp5;
                tmp5 = tmp6.xxxx * tmp7 + tmp5;
                tmp7 = _Color50 - tmp5;
                tmp5 = tmp6.yyyy * tmp7 + tmp5;
                tmp7 = _Color60 - tmp5;
                tmp5 = tmp6.zzzz * tmp7 + tmp5;
                tmp7 = _Color70 - tmp5;
                tmp5 = tmp1.wwww * tmp7 + tmp5;
                tmp7 = _Color01 - _Color31;
                tmp7 = tmp4.xxxx * tmp7 + _Color31;
                tmp8 = _Color11 - tmp7;
                tmp7 = tmp4.yyyy * tmp8 + tmp7;
                tmp8 = _Color21 - tmp7;
                tmp7 = tmp4.zzzz * tmp8 + tmp7;
                tmp8 = _Color41 - tmp7;
                tmp7 = tmp6.xxxx * tmp8 + tmp7;
                tmp8 = _Color51 - tmp7;
                tmp7 = tmp6.yyyy * tmp8 + tmp7;
                tmp8 = _Color61 - tmp7;
                tmp6 = tmp6.zzzz * tmp8 + tmp7;
                tmp7 = _Color71 - tmp6;
                tmp6 = tmp1.wwww * tmp7 + tmp6;
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.x = dot(inp.texcoord1.xyz, tmp3.xyz);
                tmp4.y = dot(inp.texcoord2.xyz, tmp3.xyz);
                tmp4.z = dot(inp.texcoord3.xyz, tmp3.xyz);
                tmp3.xyz = _WorldSpaceLightPos0.xyz * tmp1.www + tmp2.xyz;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp3.xyz;
                tmp1.w = dot(tmp4.xyz, tmp3.xyz);
                tmp3.xy = tmp6.ww * float2(0.75, 3.0);
                tmp2.w = tmp6.w + tmp6.w;
                tmp7.xyz = tmp6.www * float3(8.0, 0.75, -0.1) + float3(-1.0, 0.25, 0.6);
                tmp2.w = saturate(tmp2.w * tmp7.y);
                tmp1.w = max(tmp1.w, 0.0);
                tmp3.z = exp(tmp7.x);
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * tmp3.z;
                tmp1.w = exp(tmp1.w);
                tmp1.w = tmp2.w * tmp1.w;
                tmp1.w = saturate(tmp3.y * tmp1.w);
                tmp8 = tex2D(_AmbientOcclusion, inp.texcoord.xy);
                tmp2.w = tmp8.x * inp.color.x;
                tmp3.z = tmp2.w * tmp2.w;
                tmp3.z = saturate(tmp5.w * tmp3.z);
                tmp6.xyz = tmp6.xyz - tmp5.xyz;
                tmp5.xyz = tmp3.zzz * tmp6.xyz + tmp5.xyz;
                tmp9 = tex2D(_Override, inp.texcoord.xy);
                tmp6.xyz = tmp9.xyz - tmp5.xyz;
                tmp5.xyz = tmp9.www * tmp6.xyz + tmp5.xyz;
                tmp3.w = tmp5.y >= tmp5.z;
                tmp3.w = tmp3.w ? 1.0 : 0.0;
                tmp9.xy = tmp5.zy;
                tmp9.zw = float2(-1.0, 0.6666667);
                tmp10.xy = tmp5.yz - tmp9.xy;
                tmp10.zw = float2(1.0, -1.0);
                tmp9 = tmp3.wwww * tmp10 + tmp9;
                tmp3.w = tmp5.x >= tmp9.x;
                tmp3.w = tmp3.w ? 1.0 : 0.0;
                tmp10.xyz = tmp9.xyw;
                tmp10.w = tmp5.x;
                tmp9.xyw = tmp10.wyx;
                tmp9 = tmp9 - tmp10;
                tmp9 = tmp3.wwww * tmp9 + tmp10;
                tmp3.w = min(tmp9.y, tmp9.w);
                tmp3.w = tmp9.x - tmp3.w;
                tmp6.x = tmp9.w - tmp9.y;
                tmp6.y = tmp3.w * 6.0 + 0.0;
                tmp6.x = tmp6.x / tmp6.y;
                tmp6.x = tmp6.x + tmp9.z;
                tmp6.y = tmp9.x + 0.0;
                tmp3.w = tmp3.w / tmp6.y;
                tmp7.xyw = abs(tmp6.xxx) + float3(0.95, 0.6166667, 0.2833333);
                tmp7.xyw = frac(tmp7.xyw);
                tmp7.xyw = tmp7.xyw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp7.xyw = saturate(abs(tmp7.xyw) - float3(1.0, 1.0, 1.0));
                tmp7.xyw = tmp7.xyw - float3(1.0, 1.0, 1.0);
                tmp7.xyw = tmp3.www * tmp7.xyw + float3(1.0, 1.0, 1.0);
                tmp8.xyz = tmp7.xyw * tmp9.xxx;
                tmp6.y = dot(tmp8.xyz, float3(0.299, 0.587, 0.114));
                tmp9.yzw = -tmp9.xxx * tmp7.xyw + tmp6.yyy;
                tmp8.xyz = tmp9.yzw * float3(0.2, 0.2, 0.2) + tmp8.xyz;
                tmp8.xyz = saturate(tmp7.zzz * tmp8.xyz);
                tmp7.xyz = tmp9.xxx * tmp7.xyw + -tmp9.yzw;
                tmp6.yz = tmp6.ww * float2(-0.1, 0.3) + float2(0.5, 1.2);
                tmp7.xyz = saturate(tmp6.yyy * tmp7.xyz);
                tmp6.y = tmp1.w * tmp2.w;
                tmp6.y = tmp6.y * 0.5 + -tmp3.z;
                tmp3.z = tmp5.w * tmp6.y + tmp3.z;
                tmp6.y = tmp6.w * 2.0 + 1.0;
                tmp7.w = log(tmp3.z);
                tmp6.y = tmp6.y * tmp7.w;
                tmp6.y = exp(tmp6.y);
                tmp6.y = min(tmp6.y, 1.0);
                tmp10.xy = tmp3.zz * float2(2.666667, 5.0);
                tmp10.xy = saturate(tmp10.xy);
                tmp7.w = saturate(tmp3.z * -2.181818 + 1.2);
                tmp7.w = tmp7.w * tmp10.x;
                tmp3.y = saturate(tmp3.y * tmp7.w);
                tmp3.y = tmp6.y - tmp3.y;
                tmp3.y = max(tmp3.y, 0.0);
                tmp3.z = tmp3.z - 0.1;
                tmp3.z = saturate(tmp3.z * -1.111111 + 1.0);
                tmp3.z = tmp3.z * tmp10.y;
                tmp3.x = tmp3.x * tmp3.z;
                tmp9.yz = tmp6.ww + float2(2.0, -0.5);
                tmp3.x = log(tmp3.x);
                tmp3.x = tmp3.x * tmp9.y;
                tmp3.x = exp(tmp3.x);
                tmp3.x = min(tmp3.x, 1.0);
                tmp3.y = tmp3.x + tmp3.y;
                tmp3.y = min(tmp3.y, 1.0);
                tmp9.yw = tmp3.yy * float2(1.515152, 3.030303);
                tmp9.yw = min(tmp9.yw, float2(1.0, 1.0));
                tmp10.xyz = tmp5.xyz - tmp7.xyz;
                tmp7.xyz = tmp9.yyy * tmp10.xyz + tmp7.xyz;
                tmp7.xyz = tmp7.xyz - tmp8.xyz;
                tmp7.xyz = tmp9.www * tmp7.xyz + tmp8.xyz;
                tmp8.xyz = abs(tmp6.xxx) + float3(1.01, 0.6766667, 0.3433333);
                tmp8.xyz = frac(tmp8.xyz);
                tmp8.xyz = tmp8.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp8.xyz = saturate(abs(tmp8.xyz) - float3(1.0, 1.0, 1.0));
                tmp8.xyz = tmp8.xyz - float3(1.0, 1.0, 1.0);
                tmp8.xyz = tmp3.www * tmp8.xyz + float3(1.0, 1.0, 1.0);
                tmp10.xyz = tmp8.xyz * tmp9.xxx;
                tmp3.z = dot(tmp10.xyz, float3(0.299, 0.587, 0.114));
                tmp8.xyz = -tmp9.xxx * tmp8.xyz + tmp3.zzz;
                tmp8.xyz = tmp8.xyz * float3(0.05, 0.05, 0.05) + tmp10.xyz;
                tmp6.xyz = saturate(tmp6.zzz * tmp8.xyz);
                tmp3.z = tmp3.y - 0.33;
                tmp3.z = tmp3.z * 1.492537;
                tmp3.z = max(tmp3.z, 0.0);
                tmp6.xyz = tmp6.xyz - tmp5.xyz;
                tmp5.xyz = tmp3.zzz * tmp6.xyz + tmp5.xyz;
                tmp5.xyz = tmp5.xyz - tmp7.xyz;
                tmp3.yzw = tmp3.yyy * tmp5.xyz + tmp7.xyz;
                tmp5.x = tmp3.z >= tmp3.w;
                tmp5.x = tmp5.x ? 1.0 : 0.0;
                tmp7.xy = tmp3.wz;
                tmp7.zw = float2(-1.0, 0.6666667);
                tmp10.xy = tmp3.zw - tmp7.xy;
                tmp10.zw = float2(1.0, -1.0);
                tmp7 = tmp5.xxxx * tmp10 + tmp7;
                tmp5.x = tmp3.y >= tmp7.x;
                tmp5.x = tmp5.x ? 1.0 : 0.0;
                tmp10.xyz = tmp7.xyw;
                tmp10.w = tmp3.y;
                tmp7.xyw = tmp10.wyx;
                tmp7 = tmp7 - tmp10;
                tmp7 = tmp5.xxxx * tmp7 + tmp10;
                tmp5.x = min(tmp7.y, tmp7.w);
                tmp5.x = tmp7.x - tmp5.x;
                tmp5.y = tmp7.w - tmp7.y;
                tmp5.z = tmp5.x * 6.0 + 0.0;
                tmp5.y = tmp5.y / tmp5.z;
                tmp5.y = tmp5.y + tmp7.z;
                tmp5.z = tmp7.x + 0.0;
                tmp5.x = tmp5.x / tmp5.z;
                tmp6.xyz = abs(tmp5.yyy) + float3(0.88, 0.5466667, 0.2133333);
                tmp6.xyz = frac(tmp6.xyz);
                tmp6.xyz = tmp6.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp6.xyz = saturate(abs(tmp6.xyz) - float3(1.0, 1.0, 1.0));
                tmp6.xyz = tmp6.xyz - float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp5.xxx * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp5.xyz * tmp7.xxx;
                tmp7.y = dot(tmp6.xyz, float3(0.299, 0.587, 0.114));
                tmp5.xyz = -tmp7.xxx * tmp5.xyz + tmp7.yyy;
                tmp5.xyz = tmp5.xyz * float3(0.1, 0.1, 0.1) + tmp6.xyz;
                tmp5.xyz = tmp5.xyz - tmp3.yzw;
                tmp3.xyz = tmp3.xxx * tmp5.xyz + tmp3.yzw;
                tmp5.xyz = tmp3.xyz * float3(1.333, 1.333, 1.333);
                tmp3.w = saturate(tmp9.z * 1.6);
                tmp6.x = dot(tmp5.xyz, float3(0.299, 0.587, 0.114));
                tmp3.xyz = -tmp3.xyz * float3(1.333, 1.333, 1.333) + tmp6.xxx;
                tmp3.xyz = tmp3.xyz * tmp3.www;
                tmp3.xyz = tmp1.www * tmp3.xyz + tmp5.xyz;
                tmp1.w = tmp3.y >= tmp3.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp7.xy = tmp3.zy;
                tmp7.zw = float2(-1.0, 0.6666667);
                tmp9.xy = tmp3.yz - tmp7.xy;
                tmp9.zw = float2(1.0, -1.0);
                tmp7 = tmp1.wwww * tmp9 + tmp7;
                tmp1.w = tmp3.x >= tmp7.x;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp9.xyz = tmp7.xyw;
                tmp9.w = tmp3.x;
                tmp7.xyw = tmp9.wyx;
                tmp7 = tmp7 - tmp9;
                tmp7 = tmp1.wwww * tmp7 + tmp9;
                tmp1.w = min(tmp7.y, tmp7.w);
                tmp1.w = tmp7.x - tmp1.w;
                tmp3.w = tmp7.w - tmp7.y;
                tmp5.x = tmp1.w * 6.0 + 0.0;
                tmp3.w = tmp3.w / tmp5.x;
                tmp3.w = tmp3.w + tmp7.z;
                tmp5.xy = tmp7.xx + float2(0.0, 0.1);
                tmp1.w = tmp1.w / tmp5.x;
                tmp1.w = tmp1.w - 0.5;
                tmp6.xyz = abs(tmp3.www) + float3(1.0, 0.6666667, 0.3333333);
                tmp6.xyz = frac(tmp6.xyz);
                tmp6.xyz = tmp6.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp6.xyz = saturate(abs(tmp6.xyz) - float3(1.0, 1.0, 1.0));
                tmp6.xyz = tmp6.xyz - float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp1.www * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp1.w = 1.0 - tmp8.w;
                tmp5.xyz = tmp5.yyy * tmp6.xyz + -tmp3.xyz;
                tmp3.xyz = tmp1.www * tmp5.xyz + tmp3.xyz;
                tmp1.w = tmp3.y >= tmp3.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp7.xy = tmp3.zy;
                tmp7.zw = float2(-1.0, 0.6666667);
                tmp8.xy = tmp3.yz - tmp7.xy;
                tmp8.zw = float2(1.0, -1.0);
                tmp7 = tmp1.wwww * tmp8 + tmp7;
                tmp1.w = tmp3.x >= tmp7.x;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp8.xyz = tmp7.xyw;
                tmp8.w = tmp3.x;
                tmp7.xyw = tmp8.wyx;
                tmp7 = tmp7 - tmp8;
                tmp7 = tmp1.wwww * tmp7 + tmp8;
                tmp1.w = min(tmp7.y, tmp7.w);
                tmp1.w = tmp7.x - tmp1.w;
                tmp3.w = tmp7.w - tmp7.y;
                tmp5.x = tmp1.w * 6.0 + 0.0;
                tmp3.w = tmp3.w / tmp5.x;
                tmp3.w = tmp3.w + tmp7.z;
                tmp5.xy = tmp7.xx + float2(0.0, -0.1);
                tmp1.w = tmp1.w / tmp5.x;
                tmp5.x = max(tmp5.y, 0.1);
                tmp5.x = min(tmp5.x, 1.0);
                tmp1.w = tmp1.w + 0.2;
                tmp6.xyz = abs(tmp3.www) + float3(1.05, 0.7166667, 0.3833334);
                tmp6.xyz = frac(tmp6.xyz);
                tmp6.xyz = tmp6.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp6.xyz = saturate(abs(tmp6.xyz) - float3(1.0, 1.0, 1.0));
                tmp6.xyz = tmp6.xyz - float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp1.www * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp5.xxx * tmp6.xyz;
                tmp3.xyz = -tmp5.xxx * tmp6.xyz + tmp3.xyz;
                tmp3.xyz = saturate(tmp2.www * tmp3.xyz + tmp7.xyz);
                tmp1.w = _Time.y * 6.283;
                tmp1.w = sin(tmp1.w);
                tmp1.w = tmp1.w + 1.0;
                tmp5.xy = tmp1.ww * float2(0.35, 0.05) + float2(0.5, 0.9);
                tmp1.w = _SpiralColor * 2.0 + -1.0;
                tmp3.w = tmp5.y - tmp5.x;
                tmp1.w = abs(tmp1.w) * tmp3.w + tmp5.x;
                tmp5.x = tmp2.w * tmp1.w;
                tmp1.w = _GlowSpeed * _Time.y;
                tmp6.y = frac(tmp1.w);
                tmp5.y = _SpiralColor;
                tmp6.x = 0.0;
                tmp5.xy = tmp5.xy + tmp6.xy;
                tmp7 = tex2D(_RampAlphaGlow, tmp5.xy);
                tmp1.w = 1.0 - tmp4.w;
                tmp3.w = tmp1.w * _GlowMultiplier;
                tmp3.w = tmp3.w * 3.0;
                tmp5.xyz = tmp7.xyz * tmp3.www + -tmp3.xyz;
                tmp3.xyz = tmp1.www * tmp5.xyz + tmp3.xyz;
                tmp5.xyz = tmp3.xyz * _GlowMultiplier.xxx + -tmp3.xyz;
                tmp3.xyz = tmp1.www * tmp5.xyz + tmp3.xyz;
                tmp1.w = max(tmp5.w, tmp1.w);
                tmp5.xyw = tmp1.www * -tmp3.yzx + tmp3.yzx;
                tmp3.w = tmp5.x >= tmp5.y;
                tmp3.w = tmp3.w ? 1.0 : 0.0;
                tmp7.xy = tmp5.yx;
                tmp7.zw = float2(-1.0, 0.6666667);
                tmp8.xy = tmp5.xy - tmp7.xy;
                tmp8.zw = float2(1.0, -1.0);
                tmp7 = tmp3.wwww * tmp8 + tmp7;
                tmp3.w = tmp5.w >= tmp7.x;
                tmp3.w = tmp3.w ? 1.0 : 0.0;
                tmp5.xyz = tmp7.xyw;
                tmp7.xyw = tmp5.wyx;
                tmp7 = tmp7 - tmp5;
                tmp5 = tmp3.wwww * tmp7 + tmp5;
                tmp3.w = min(tmp5.y, tmp5.w);
                tmp3.w = tmp5.x - tmp3.w;
                tmp4.w = tmp5.w - tmp5.y;
                tmp5.y = tmp3.w * 6.0 + 0.0;
                tmp4.w = tmp4.w / tmp5.y;
                tmp4.w = tmp4.w + tmp5.z;
                tmp5.y = tmp5.x + 0.0;
                tmp3.w = tmp3.w / tmp5.y;
                tmp6.x = inp.texcoord1.z;
                tmp6.y = inp.texcoord2.z;
                tmp6.z = inp.texcoord3.z;
                tmp5.yzw = abs(tmp6.xyz) * abs(tmp6.xyz);
                tmp7 = _PaintStrokes_ST * tmp0.wzwy + _PaintStrokes_ST;
                tmp8 = tex2D(_PaintStrokes, tmp7.xy);
                tmp7 = tex2D(_PaintStrokes, tmp7.zw);
                tmp6.xyz = tmp5.zzz * tmp7.xyz;
                tmp6.xyz = tmp5.yyy * tmp8.xyz + tmp6.xyz;
                tmp5.yz = _PaintStrokes_ST.xy * tmp0.yz + _PaintStrokes_ST.zw;
                tmp7 = tex2D(_PaintStrokes, tmp5.yz);
                tmp5.yzw = tmp5.www * tmp7.xyz + tmp6.xyz;
                tmp5.yzw = tmp5.yzw - float3(0.5, 0.5, 0.5);
                tmp4.w = tmp5.y * 0.04 + abs(tmp4.w);
                tmp3.w = tmp5.z * 0.05 + tmp3.w;
                tmp5.x = tmp5.w * 0.075 + tmp5.x;
                tmp5.yzw = tmp4.www + float3(1.0, 0.6666667, 0.3333333);
                tmp5.yzw = frac(tmp5.yzw);
                tmp5.yzw = tmp5.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp5.yzw = saturate(abs(tmp5.yzw) - float3(1.0, 1.0, 1.0));
                tmp5.yzw = tmp5.yzw - float3(1.0, 1.0, 1.0);
                tmp5.yzw = tmp3.www * tmp5.yzw + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp5.yzw * tmp5.xxx;
                tmp6.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp7.xyz = glstate_lightmodel_ambient.xyz * float3(0.2, 0.2, 0.2);
                tmp8.xyz = tmp3.xyz * tmp7.xyz;
                tmp3.xyz = -tmp7.xyz * tmp3.xyz + tmp3.xyz;
                tmp3.xyz = tmp1.www * tmp3.xyz + tmp8.xyz;
                tmp7.xyz = tmp2.yyy * unity_MatrixV._m01_m11_m21;
                tmp7.xyz = unity_MatrixV._m00_m10_m20 * tmp2.xxx + tmp7.xyz;
                tmp2.xyz = unity_MatrixV._m02_m12_m22 * tmp2.zzz + tmp7.xyz;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp1.www * tmp4.xyz;
                tmp7.xyz = tmp4.yyy * unity_MatrixV._m01_m11_m21;
                tmp7.xyz = unity_MatrixV._m00_m10_m20 * tmp4.xxx + tmp7.xyz;
                tmp7.xyz = unity_MatrixV._m02_m12_m22 * tmp4.zzz + tmp7.xyz;
                tmp1.w = tmp2.z * 1.0;
                tmp2.xy = tmp2.xy * float2(-1.0, -1.0) + tmp7.xy;
                tmp2.z = tmp7.z * tmp1.w;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xy = tmp1.ww * tmp2.xy;
                tmp2.xy = tmp2.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp7 = tex2D(_Rim, tmp2.xy);
                tmp1.w = dot(tmp6.xyz, float3(0.299, 0.587, 0.114));
                tmp2.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + tmp1.www;
                tmp2.xyz = tmp2.xyz * float3(0.5, 0.5, 0.5) + tmp6.xyz;
                tmp6.xyz = tmp7.www * tmp7.xyz;
                tmp6.xyz = tmp6.xyz * _RimStrength.xxx;
                tmp2.xyz = tmp2.xyz * tmp6.xyz;
                tmp2.xyz = tmp2.www * tmp2.xyz + tmp3.xyz;
                tmp1.w = max(tmp6.w, 0.001);
                tmp1.w = min(tmp1.w, 1.0);
                tmp2.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp2.w) {
                    tmp2.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp3.xyz = inp.texcoord2.www * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord1.www + tmp3.xyz;
                    tmp3.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord3.www + tmp3.xyz;
                    tmp3.xyz = tmp3.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp0.yzw = tmp2.www ? tmp3.xyz : tmp0.yzw;
                    tmp0.yzw = tmp0.yzw - unity_ProbeVolumeMin;
                    tmp3.yzw = tmp0.yzw * unity_ProbeVolumeSizeInv;
                    tmp0.y = tmp3.y * 0.25 + 0.75;
                    tmp0.z = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp3.x = max(tmp0.z, tmp0.y);
                    tmp3 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp3.xzw);
                } else {
                    tmp3 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp0.y = saturate(dot(tmp3, unity_OcclusionMaskSelector));
                tmp0.yzw = tmp0.yyy * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.xxx + _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp0.x = dot(tmp4.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp1.x = dot(tmp4.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.y = tmp1.w * 128.0;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.yzw = tmp0.yzw * tmp5.xyz;
                tmp0.yzw = tmp0.yzw * _SpecColor.xyz;
                tmp0.yzw = tmp1.xxx * tmp0.yzw;
                tmp0.xyz = tmp1.yzw * tmp0.xxx + tmp0.yzw;
                o.sv_target.xyz = tmp2.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 94053
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
				float3 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
				float3 texcoord5 : TEXCOORD5;
				float4 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _texcoord2_ST;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _SpecColor;
			float4 _Color30;
			float4 _Color00;
			float4 _Color10;
			float4 _Color20;
			float4 _Color40;
			float4 _Color50;
			float4 _Color60;
			float4 _Color70;
			float4 _Color31;
			float4 _Color01;
			float4 _Color11;
			float4 _Color21;
			float4 _Color51;
			float4 _Color61;
			float4 _Color71;
			float _SpiralColor;
			float _GlowSpeed;
			float _GlowMultiplier;
			float4 _PaintStrokes_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			CBUFFER_START(SRAMPActorRecolorX8_Normal_PaintTri)
				float4 _Color41;
			CBUFFER_END
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _ColorMask;
			sampler2D _AmbientOcclusion;
			sampler2D _Override;
			sampler2D _RampAlphaGlow;
			sampler2D _PaintStrokes;
			sampler2D _LightTexture0;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord1.xy * _texcoord2_ST.xy + _texcoord2_ST.zw;
                o.texcoord.zw = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
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
                o.texcoord1.y = tmp3.x;
                o.texcoord1.x = tmp2.z;
                o.texcoord1.z = tmp1.y;
                o.texcoord2.x = tmp2.x;
                o.texcoord3.x = tmp2.y;
                o.texcoord2.z = tmp1.z;
                o.texcoord3.z = tmp1.x;
                o.texcoord2.y = tmp3.y;
                o.texcoord3.y = tmp3.z;
                o.texcoord4.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.color = v.color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord6 = float4(0.0, 0.0, 0.0, 0.0);
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
                tmp0.xyz = _WorldSpaceLightPos0.xyz - inp.texcoord4.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord4.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2 = tex2D(_Normal, inp.texcoord.xy);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = dot(tmp2.xy, tmp2.xy);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.z = sqrt(tmp1.w);
                tmp3 = tex2D(_ColorMask, inp.texcoord.zw);
                tmp1.w = tmp3.y * tmp3.x;
                tmp1.w = tmp3.z * tmp1.w;
                tmp4 = _Color00 - _Color30;
                tmp4 = tmp3.xxxx * tmp4 + _Color30;
                tmp5 = _Color10 - tmp4;
                tmp4 = tmp3.yyyy * tmp5 + tmp4;
                tmp5 = _Color20 - tmp4;
                tmp4 = tmp3.zzzz * tmp5 + tmp4;
                tmp5.xyz = tmp3.xxy * tmp3.zyz + -tmp1.www;
                tmp6 = _Color40 - tmp4;
                tmp4 = tmp5.xxxx * tmp6 + tmp4;
                tmp6 = _Color50 - tmp4;
                tmp4 = tmp5.yyyy * tmp6 + tmp4;
                tmp6 = _Color60 - tmp4;
                tmp4 = tmp5.zzzz * tmp6 + tmp4;
                tmp6 = _Color70 - tmp4;
                tmp4 = tmp1.wwww * tmp6 + tmp4;
                tmp6 = _Color01 - _Color31;
                tmp6 = tmp3.xxxx * tmp6 + _Color31;
                tmp7 = _Color11 - tmp6;
                tmp6 = tmp3.yyyy * tmp7 + tmp6;
                tmp7 = _Color21 - tmp6;
                tmp6 = tmp3.zzzz * tmp7 + tmp6;
                tmp7 = _Color41 - tmp6;
                tmp6 = tmp5.xxxx * tmp7 + tmp6;
                tmp7 = _Color51 - tmp6;
                tmp6 = tmp5.yyyy * tmp7 + tmp6;
                tmp7 = _Color61 - tmp6;
                tmp5 = tmp5.zzzz * tmp7 + tmp6;
                tmp6 = _Color71 - tmp5;
                tmp5 = tmp1.wwww * tmp6 + tmp5;
                tmp3.x = dot(inp.texcoord1.xyz, tmp2.xyz);
                tmp3.y = dot(inp.texcoord2.xyz, tmp2.xyz);
                tmp3.z = dot(inp.texcoord3.xyz, tmp2.xyz);
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp3.xyz, tmp1.xyz);
                tmp2.xy = tmp5.ww * float2(0.75, 3.0);
                tmp1.w = tmp5.w + tmp5.w;
                tmp6.xyz = tmp5.www * float3(8.0, 0.75, -0.1) + float3(-1.0, 0.25, 0.6);
                tmp1.w = saturate(tmp1.w * tmp6.y);
                tmp0.w = max(tmp0.w, 0.0);
                tmp2.z = exp(tmp6.x);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * tmp2.z;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp1.w * tmp0.w;
                tmp0.w = saturate(tmp2.y * tmp0.w);
                tmp7 = tex2D(_AmbientOcclusion, inp.texcoord.xy);
                tmp1.w = tmp7.x * inp.color.x;
                tmp2.z = tmp1.w * tmp1.w;
                tmp2.z = saturate(tmp4.w * tmp2.z);
                tmp5.xyz = tmp5.xyz - tmp4.xyz;
                tmp4.xyz = tmp2.zzz * tmp5.xyz + tmp4.xyz;
                tmp8 = tex2D(_Override, inp.texcoord.xy);
                tmp5.xyz = tmp8.xyz - tmp4.xyz;
                tmp4.xyz = tmp8.www * tmp5.xyz + tmp4.xyz;
                tmp2.w = tmp4.y >= tmp4.z;
                tmp2.w = tmp2.w ? 1.0 : 0.0;
                tmp8.xy = tmp4.zy;
                tmp8.zw = float2(-1.0, 0.6666667);
                tmp9.xy = tmp4.yz - tmp8.xy;
                tmp9.zw = float2(1.0, -1.0);
                tmp8 = tmp2.wwww * tmp9 + tmp8;
                tmp2.w = tmp4.x >= tmp8.x;
                tmp2.w = tmp2.w ? 1.0 : 0.0;
                tmp9.xyz = tmp8.xyw;
                tmp9.w = tmp4.x;
                tmp8.xyw = tmp9.wyx;
                tmp8 = tmp8 - tmp9;
                tmp8 = tmp2.wwww * tmp8 + tmp9;
                tmp2.w = min(tmp8.y, tmp8.w);
                tmp2.w = tmp8.x - tmp2.w;
                tmp5.x = tmp8.w - tmp8.y;
                tmp5.y = tmp2.w * 6.0 + 0.0;
                tmp5.x = tmp5.x / tmp5.y;
                tmp5.x = tmp5.x + tmp8.z;
                tmp5.y = tmp8.x + 0.0;
                tmp2.w = tmp2.w / tmp5.y;
                tmp6.xyw = abs(tmp5.xxx) + float3(0.95, 0.6166667, 0.2833333);
                tmp6.xyw = frac(tmp6.xyw);
                tmp6.xyw = tmp6.xyw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp6.xyw = saturate(abs(tmp6.xyw) - float3(1.0, 1.0, 1.0));
                tmp6.xyw = tmp6.xyw - float3(1.0, 1.0, 1.0);
                tmp6.xyw = tmp2.www * tmp6.xyw + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp6.xyw * tmp8.xxx;
                tmp5.y = dot(tmp7.xyz, float3(0.299, 0.587, 0.114));
                tmp8.yzw = -tmp8.xxx * tmp6.xyw + tmp5.yyy;
                tmp7.xyz = tmp8.yzw * float3(0.2, 0.2, 0.2) + tmp7.xyz;
                tmp7.xyz = saturate(tmp6.zzz * tmp7.xyz);
                tmp6.xyz = tmp8.xxx * tmp6.xyw + -tmp8.yzw;
                tmp5.yz = tmp5.ww * float2(-0.1, 0.3) + float2(0.5, 1.2);
                tmp6.xyz = saturate(tmp5.yyy * tmp6.xyz);
                tmp5.y = tmp0.w * tmp1.w;
                tmp5.y = tmp5.y * 0.5 + -tmp2.z;
                tmp2.z = tmp4.w * tmp5.y + tmp2.z;
                tmp5.y = tmp5.w * 2.0 + 1.0;
                tmp6.w = log(tmp2.z);
                tmp5.y = tmp5.y * tmp6.w;
                tmp5.y = exp(tmp5.y);
                tmp5.y = min(tmp5.y, 1.0);
                tmp9.xy = tmp2.zz * float2(2.666667, 5.0);
                tmp9.xy = saturate(tmp9.xy);
                tmp6.w = saturate(tmp2.z * -2.181818 + 1.2);
                tmp6.w = tmp6.w * tmp9.x;
                tmp2.y = saturate(tmp2.y * tmp6.w);
                tmp2.y = tmp5.y - tmp2.y;
                tmp2.y = max(tmp2.y, 0.0);
                tmp2.z = tmp2.z - 0.1;
                tmp2.z = saturate(tmp2.z * -1.111111 + 1.0);
                tmp2.z = tmp2.z * tmp9.y;
                tmp2.x = tmp2.x * tmp2.z;
                tmp8.yz = tmp5.ww + float2(2.0, -0.5);
                tmp2.x = log(tmp2.x);
                tmp2.x = tmp2.x * tmp8.y;
                tmp2.x = exp(tmp2.x);
                tmp2.x = min(tmp2.x, 1.0);
                tmp2.y = tmp2.x + tmp2.y;
                tmp2.y = min(tmp2.y, 1.0);
                tmp8.yw = tmp2.yy * float2(1.515152, 3.030303);
                tmp8.yw = min(tmp8.yw, float2(1.0, 1.0));
                tmp9.xyz = tmp4.xyz - tmp6.xyz;
                tmp6.xyz = tmp8.yyy * tmp9.xyz + tmp6.xyz;
                tmp6.xyz = tmp6.xyz - tmp7.xyz;
                tmp6.xyz = tmp8.www * tmp6.xyz + tmp7.xyz;
                tmp7.xyz = abs(tmp5.xxx) + float3(1.01, 0.6766667, 0.3433333);
                tmp7.xyz = frac(tmp7.xyz);
                tmp7.xyz = tmp7.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp7.xyz = saturate(abs(tmp7.xyz) - float3(1.0, 1.0, 1.0));
                tmp7.xyz = tmp7.xyz - float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp2.www * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp9.xyz = tmp7.xyz * tmp8.xxx;
                tmp2.z = dot(tmp9.xyz, float3(0.299, 0.587, 0.114));
                tmp7.xyz = -tmp8.xxx * tmp7.xyz + tmp2.zzz;
                tmp7.xyz = tmp7.xyz * float3(0.05, 0.05, 0.05) + tmp9.xyz;
                tmp5.xyz = saturate(tmp5.zzz * tmp7.xyz);
                tmp2.z = tmp2.y - 0.33;
                tmp2.z = tmp2.z * 1.492537;
                tmp2.z = max(tmp2.z, 0.0);
                tmp5.xyz = tmp5.xyz - tmp4.xyz;
                tmp4.xyz = tmp2.zzz * tmp5.xyz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz - tmp6.xyz;
                tmp2.yzw = tmp2.yyy * tmp4.xyz + tmp6.xyz;
                tmp4.x = tmp2.z >= tmp2.w;
                tmp4.x = tmp4.x ? 1.0 : 0.0;
                tmp6.xy = tmp2.wz;
                tmp6.zw = float2(-1.0, 0.6666667);
                tmp9.xy = tmp2.zw - tmp6.xy;
                tmp9.zw = float2(1.0, -1.0);
                tmp6 = tmp4.xxxx * tmp9 + tmp6;
                tmp4.x = tmp2.y >= tmp6.x;
                tmp4.x = tmp4.x ? 1.0 : 0.0;
                tmp9.xyz = tmp6.xyw;
                tmp9.w = tmp2.y;
                tmp6.xyw = tmp9.wyx;
                tmp6 = tmp6 - tmp9;
                tmp6 = tmp4.xxxx * tmp6 + tmp9;
                tmp4.x = min(tmp6.y, tmp6.w);
                tmp4.x = tmp6.x - tmp4.x;
                tmp4.y = tmp6.w - tmp6.y;
                tmp4.z = tmp4.x * 6.0 + 0.0;
                tmp4.y = tmp4.y / tmp4.z;
                tmp4.y = tmp4.y + tmp6.z;
                tmp4.z = tmp6.x + 0.0;
                tmp4.x = tmp4.x / tmp4.z;
                tmp5.xyz = abs(tmp4.yyy) + float3(0.88, 0.5466667, 0.2133333);
                tmp5.xyz = frac(tmp5.xyz);
                tmp5.xyz = tmp5.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp5.xyz = saturate(abs(tmp5.xyz) - float3(1.0, 1.0, 1.0));
                tmp5.xyz = tmp5.xyz - float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp4.xxx * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp4.xyz * tmp6.xxx;
                tmp6.y = dot(tmp5.xyz, float3(0.299, 0.587, 0.114));
                tmp4.xyz = -tmp6.xxx * tmp4.xyz + tmp6.yyy;
                tmp4.xyz = tmp4.xyz * float3(0.1, 0.1, 0.1) + tmp5.xyz;
                tmp4.xyz = tmp4.xyz - tmp2.yzw;
                tmp2.xyz = tmp2.xxx * tmp4.xyz + tmp2.yzw;
                tmp4.xyz = tmp2.xyz * float3(1.333, 1.333, 1.333);
                tmp2.w = saturate(tmp8.z * 1.6);
                tmp5.x = dot(tmp4.xyz, float3(0.299, 0.587, 0.114));
                tmp2.xyz = -tmp2.xyz * float3(1.333, 1.333, 1.333) + tmp5.xxx;
                tmp2.xyz = tmp2.xyz * tmp2.www;
                tmp2.xyz = tmp0.www * tmp2.xyz + tmp4.xyz;
                tmp0.w = tmp2.y >= tmp2.z;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp6.xy = tmp2.zy;
                tmp6.zw = float2(-1.0, 0.6666667);
                tmp8.xy = tmp2.yz - tmp6.xy;
                tmp8.zw = float2(1.0, -1.0);
                tmp6 = tmp0.wwww * tmp8 + tmp6;
                tmp0.w = tmp2.x >= tmp6.x;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp8.xyz = tmp6.xyw;
                tmp8.w = tmp2.x;
                tmp6.xyw = tmp8.wyx;
                tmp6 = tmp6 - tmp8;
                tmp6 = tmp0.wwww * tmp6 + tmp8;
                tmp0.w = min(tmp6.y, tmp6.w);
                tmp0.w = tmp6.x - tmp0.w;
                tmp2.w = tmp6.w - tmp6.y;
                tmp4.x = tmp0.w * 6.0 + 0.0;
                tmp2.w = tmp2.w / tmp4.x;
                tmp2.w = tmp2.w + tmp6.z;
                tmp4.xy = tmp6.xx + float2(0.0, 0.1);
                tmp0.w = tmp0.w / tmp4.x;
                tmp0.w = tmp0.w - 0.5;
                tmp5.xyz = abs(tmp2.www) + float3(1.0, 0.6666667, 0.3333333);
                tmp5.xyz = frac(tmp5.xyz);
                tmp5.xyz = tmp5.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp5.xyz = saturate(abs(tmp5.xyz) - float3(1.0, 1.0, 1.0));
                tmp5.xyz = tmp5.xyz - float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp0.www * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp0.w = 1.0 - tmp7.w;
                tmp4.xyz = tmp4.yyy * tmp5.xyz + -tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp4.xyz + tmp2.xyz;
                tmp0.w = tmp2.y >= tmp2.z;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp6.xy = tmp2.zy;
                tmp6.zw = float2(-1.0, 0.6666667);
                tmp7.xy = tmp2.yz - tmp6.xy;
                tmp7.zw = float2(1.0, -1.0);
                tmp6 = tmp0.wwww * tmp7 + tmp6;
                tmp0.w = tmp2.x >= tmp6.x;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp7.xyz = tmp6.xyw;
                tmp7.w = tmp2.x;
                tmp6.xyw = tmp7.wyx;
                tmp6 = tmp6 - tmp7;
                tmp6 = tmp0.wwww * tmp6 + tmp7;
                tmp0.w = min(tmp6.y, tmp6.w);
                tmp0.w = tmp6.x - tmp0.w;
                tmp2.w = tmp6.w - tmp6.y;
                tmp4.x = tmp0.w * 6.0 + 0.0;
                tmp2.w = tmp2.w / tmp4.x;
                tmp2.w = tmp2.w + tmp6.z;
                tmp4.xy = tmp6.xx + float2(0.0, -0.1);
                tmp0.w = tmp0.w / tmp4.x;
                tmp4.x = max(tmp4.y, 0.1);
                tmp4.x = min(tmp4.x, 1.0);
                tmp0.w = tmp0.w + 0.2;
                tmp5.xyz = abs(tmp2.www) + float3(1.05, 0.7166667, 0.3833334);
                tmp5.xyz = frac(tmp5.xyz);
                tmp5.xyz = tmp5.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp5.xyz = saturate(abs(tmp5.xyz) - float3(1.0, 1.0, 1.0));
                tmp5.xyz = tmp5.xyz - float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp0.www * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp4.xxx * tmp5.xyz;
                tmp2.xyz = -tmp4.xxx * tmp5.xyz + tmp2.xyz;
                tmp2.xyz = saturate(tmp1.www * tmp2.xyz + tmp6.xyz);
                tmp0.w = _Time.y * 6.283;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w + 1.0;
                tmp4.xy = tmp0.ww * float2(0.35, 0.05) + float2(0.5, 0.9);
                tmp0.w = _SpiralColor * 2.0 + -1.0;
                tmp2.w = tmp4.y - tmp4.x;
                tmp0.w = abs(tmp0.w) * tmp2.w + tmp4.x;
                tmp4.x = tmp1.w * tmp0.w;
                tmp0.w = _GlowSpeed * _Time.y;
                tmp5.y = frac(tmp0.w);
                tmp4.y = _SpiralColor;
                tmp5.x = 0.0;
                tmp4.xy = tmp4.xy + tmp5.xy;
                tmp6 = tex2D(_RampAlphaGlow, tmp4.xy);
                tmp0.w = 1.0 - tmp3.w;
                tmp1.w = tmp0.w * _GlowMultiplier;
                tmp1.w = tmp1.w * 3.0;
                tmp4.xyz = tmp6.xyz * tmp1.www + -tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp4.xyz + tmp2.xyz;
                tmp4.xyz = tmp2.xyz * _GlowMultiplier.xxx + -tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp4.xyz + tmp2.xyz;
                tmp0.w = max(tmp4.w, tmp0.w);
                tmp2.xyw = tmp0.www * -tmp2.yzx + tmp2.yzx;
                tmp0.w = tmp2.x >= tmp2.y;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp4.xy = tmp2.yx;
                tmp4.zw = float2(-1.0, 0.6666667);
                tmp6.xy = tmp2.xy - tmp4.xy;
                tmp6.zw = float2(1.0, -1.0);
                tmp4 = tmp0.wwww * tmp6 + tmp4;
                tmp0.w = tmp2.w >= tmp4.x;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp2.xyz = tmp4.xyw;
                tmp4.xyw = tmp2.wyx;
                tmp4 = tmp4 - tmp2;
                tmp2 = tmp0.wwww * tmp4 + tmp2;
                tmp0.w = min(tmp2.y, tmp2.w);
                tmp0.w = tmp2.x - tmp0.w;
                tmp1.w = tmp2.w - tmp2.y;
                tmp2.y = tmp0.w * 6.0 + 0.0;
                tmp1.w = tmp1.w / tmp2.y;
                tmp1.w = tmp1.w + tmp2.z;
                tmp2.y = tmp2.x + 0.0;
                tmp0.w = tmp0.w / tmp2.y;
                tmp4.x = inp.texcoord1.z;
                tmp4.y = inp.texcoord2.z;
                tmp4.z = inp.texcoord3.z;
                tmp2.yzw = abs(tmp4.xyz) * abs(tmp4.xyz);
                tmp4 = _PaintStrokes_ST * inp.texcoord4.zyzx + _PaintStrokes_ST;
                tmp6 = tex2D(_PaintStrokes, tmp4.xy);
                tmp4 = tex2D(_PaintStrokes, tmp4.zw);
                tmp4.xyz = tmp2.zzz * tmp4.xyz;
                tmp4.xyz = tmp2.yyy * tmp6.xyz + tmp4.xyz;
                tmp2.yz = _PaintStrokes_ST.xy * inp.texcoord4.xy + _PaintStrokes_ST.zw;
                tmp6 = tex2D(_PaintStrokes, tmp2.yz);
                tmp2.yzw = tmp2.www * tmp6.xyz + tmp4.xyz;
                tmp2.yzw = tmp2.yzw - float3(0.5, 0.5, 0.5);
                tmp1.w = tmp2.y * 0.04 + abs(tmp1.w);
                tmp0.w = tmp2.z * 0.05 + tmp0.w;
                tmp2.x = tmp2.w * 0.075 + tmp2.x;
                tmp2.yzw = tmp1.www + float3(1.0, 0.6666667, 0.3333333);
                tmp2.yzw = frac(tmp2.yzw);
                tmp2.yzw = tmp2.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp2.yzw = saturate(abs(tmp2.yzw) - float3(1.0, 1.0, 1.0));
                tmp2.yzw = tmp2.yzw - float3(1.0, 1.0, 1.0);
                tmp2.yzw = tmp0.www * tmp2.yzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.yzw * tmp2.xxx;
                tmp0.w = max(tmp5.w, 0.001);
                tmp0.w = min(tmp0.w, 1.0);
                tmp4.xyz = inp.texcoord4.yyy * unity_WorldToLight._m01_m11_m21;
                tmp4.xyz = unity_WorldToLight._m00_m10_m20 * inp.texcoord4.xxx + tmp4.xyz;
                tmp4.xyz = unity_WorldToLight._m02_m12_m22 * inp.texcoord4.zzz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz + unity_WorldToLight._m03_m13_m23;
                tmp1.w = unity_ProbeVolumeParams.x == 1.0;
                if (tmp1.w) {
                    tmp1.w = unity_ProbeVolumeParams.y == 1.0;
                    tmp5.xyz = inp.texcoord4.yyy * unity_ProbeVolumeWorldToObject._m01_m11_m21;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m00_m10_m20 * inp.texcoord4.xxx + tmp5.xyz;
                    tmp5.xyz = unity_ProbeVolumeWorldToObject._m02_m12_m22 * inp.texcoord4.zzz + tmp5.xyz;
                    tmp5.xyz = tmp5.xyz + unity_ProbeVolumeWorldToObject._m03_m13_m23;
                    tmp5.xyz = tmp1.www ? tmp5.xyz : inp.texcoord4.xyz;
                    tmp5.xyz = tmp5.xyz - unity_ProbeVolumeMin;
                    tmp5.yzw = tmp5.xyz * unity_ProbeVolumeSizeInv;
                    tmp1.w = tmp5.y * 0.25 + 0.75;
                    tmp2.w = unity_ProbeVolumeParams.z * 0.5 + 0.75;
                    tmp5.x = max(tmp1.w, tmp2.w);
                    tmp5 = UNITY_SAMPLE_TEX3D_SAMPLER(unity_ProbeVolumeSH, unity_ProbeVolumeSH, tmp5.xzw);
                } else {
                    tmp5 = float4(1.0, 1.0, 1.0, 1.0);
                }
                tmp1.w = saturate(dot(tmp5, unity_OcclusionMaskSelector));
                tmp2.w = dot(tmp4.xyz, tmp4.xyz);
                tmp4 = tex2D(_LightTexture0, tmp2.ww);
                tmp1.w = tmp1.w * tmp4.x;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * tmp3.xyz;
                tmp4.xyz = tmp1.www * _LightColor0.xyz;
                tmp0.x = dot(tmp3.xyz, tmp0.xyz);
                tmp0.y = dot(tmp3.xyz, tmp1.xyz);
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.z = tmp0.w * 128.0;
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp0.w * tmp0.y;
                tmp1.xyz = tmp2.xyz * tmp4.xyz;
                tmp2.xyz = tmp4.xyz * _SpecColor.xyz;
                tmp0.yzw = tmp0.yyy * tmp2.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp0.xxx + tmp0.yzw;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "PREPASS"
			Tags { "DisableBatching" = "true" "IsEmissive" = "true" "LIGHTMODE" = "PREPASSBASE" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
			GpuProgramID 146176
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord2_ST;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color31;
			float4 _Color01;
			float4 _Color11;
			float4 _Color21;
			float4 _Color51;
			float4 _Color61;
			float4 _Color71;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			CBUFFER_START(SRAMPActorRecolorX8_Normal_PaintTri)
				float4 _Color41;
			CBUFFER_END
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _ColorMask;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord1.xy * _texcoord2_ST.xy + _texcoord2_ST.zw;
                o.texcoord.zw = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord1.w = tmp0.x;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = tmp1.xyz * tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx + -tmp3.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord1.y = tmp3.x;
                o.texcoord1.x = tmp2.z;
                o.texcoord1.z = tmp1.y;
                o.texcoord2.x = tmp2.x;
                o.texcoord3.x = tmp2.y;
                o.texcoord2.z = tmp1.z;
                o.texcoord3.z = tmp1.x;
                o.texcoord2.w = tmp0.y;
                o.texcoord3.w = tmp0.z;
                o.texcoord2.y = tmp3.y;
                o.texcoord3.y = tmp3.z;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _Color01.w - _Color31.w;
                tmp1 = tex2D(_ColorMask, inp.texcoord.zw);
                tmp0.x = tmp1.x * tmp0.x + _Color31.w;
                tmp0.y = _Color11.w - tmp0.x;
                tmp0.x = tmp1.y * tmp0.y + tmp0.x;
                tmp0.y = _Color21.w - tmp0.x;
                tmp0.x = tmp1.z * tmp0.y + tmp0.x;
                tmp0.y = _Color41.w - tmp0.x;
                tmp0.z = tmp1.y * tmp1.x;
                tmp0.z = tmp1.z * tmp0.z;
                tmp1.xyz = tmp1.xxy * tmp1.zyz + -tmp0.zzz;
                tmp0.x = tmp1.x * tmp0.y + tmp0.x;
                tmp0.y = _Color51.w - tmp0.x;
                tmp0.x = tmp1.y * tmp0.y + tmp0.x;
                tmp0.y = _Color61.w - tmp0.x;
                tmp0.x = tmp1.z * tmp0.y + tmp0.x;
                tmp0.y = _Color71.w - tmp0.x;
                tmp0.x = tmp0.z * tmp0.y + tmp0.x;
                tmp0.x = max(tmp0.x, 0.001);
                o.sv_target.w = min(tmp0.x, 1.0);
                tmp0 = tex2D(_Normal, inp.texcoord.xy);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.z = sqrt(tmp0.w);
                tmp1.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp1.y = dot(inp.texcoord2.xyz, tmp0.xyz);
                tmp1.z = dot(inp.texcoord3.xyz, tmp0.xyz);
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5) + float3(0.5, 0.5, 0.5);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "PREPASS"
			Tags { "DisableBatching" = "true" "IsEmissive" = "true" "LIGHTMODE" = "PREPASSFINAL" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
			ZWrite Off
			GpuProgramID 217547
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
				float4 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
				float3 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord2_ST;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _SpecColor;
			float4 _Color30;
			float4 _Color00;
			float4 _Color10;
			float4 _Color20;
			float4 _Color40;
			float4 _Color50;
			float4 _Color60;
			float4 _Color70;
			float4 _Color31;
			float4 _Color01;
			float4 _Color11;
			float4 _Color21;
			float4 _Color51;
			float4 _Color61;
			float4 _Color71;
			float _SpiralColor;
			float _GlowSpeed;
			float _GlowMultiplier;
			float4 _PaintStrokes_ST;
			float _RimStrength;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			CBUFFER_START(SRAMPActorRecolorX8_Normal_PaintTri)
				float4 _Color41;
			CBUFFER_END
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _ColorMask;
			sampler2D _AmbientOcclusion;
			sampler2D _Override;
			sampler2D _RampAlphaGlow;
			sampler2D _PaintStrokes;
			sampler2D _Rim;
			sampler2D _LightBuffer;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord1.xy * _texcoord2_ST.xy + _texcoord2_ST.zw;
                o.texcoord.zw = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord1.w = tmp0.x;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                o.texcoord1.x = tmp2.z;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp4.xyz = tmp2.xyz * tmp3.zxy;
                tmp4.xyz = tmp3.yzx * tmp2.yzx + -tmp4.xyz;
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.z = tmp3.x;
                o.texcoord2.x = tmp2.x;
                o.texcoord3.x = tmp2.y;
                o.texcoord2.w = tmp0.y;
                o.texcoord3.w = tmp0.z;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                o.texcoord2.z = tmp3.y;
                o.texcoord3.z = tmp3.z;
                o.color = v.color;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord4.zw = tmp1.zw;
                o.texcoord4.xy = tmp0.zz + tmp0.xw;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.x = tmp3.y * tmp3.y;
                tmp0.x = tmp3.x * tmp3.x + -tmp0.x;
                tmp1 = tmp3.yzzx * tmp3.xyzz;
                tmp2.x = dot(unity_SHBr, tmp1);
                tmp2.y = dot(unity_SHBg, tmp1);
                tmp2.z = dot(unity_SHBb, tmp1);
                tmp0.xyz = unity_SHC.xyz * tmp0.xxx + tmp2.xyz;
                tmp3.w = 1.0;
                tmp1.x = dot(unity_SHAr, tmp3);
                tmp1.y = dot(unity_SHAg, tmp3);
                tmp1.z = dot(unity_SHAb, tmp3);
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp0.xyz = exp(tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                o.texcoord6.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
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
                float4 tmp10;
                float4 tmp11;
                tmp0.z = inp.texcoord3.w;
                tmp0.x = inp.texcoord1.w;
                tmp0.y = inp.texcoord2.w;
                tmp1.xyz = -tmp0.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp3 = _PaintStrokes_ST * tmp0.zyzx + _PaintStrokes_ST;
                tmp0.xy = _PaintStrokes_ST.xy * tmp0.xy + _PaintStrokes_ST.zw;
                tmp4 = tex2D(_PaintStrokes, tmp0.xy);
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp2.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2 = tex2D(_Normal, inp.texcoord.xy);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp2.z = sqrt(tmp0.w);
                tmp5.x = dot(inp.texcoord1.xyz, tmp2.xyz);
                tmp5.y = dot(inp.texcoord2.xyz, tmp2.xyz);
                tmp5.z = dot(inp.texcoord3.xyz, tmp2.xyz);
                tmp0.w = dot(tmp5.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp1 = _Color01 - _Color31;
                tmp2 = tex2D(_ColorMask, inp.texcoord.zw);
                tmp1 = tmp2.xxxx * tmp1 + _Color31;
                tmp6 = _Color11 - tmp1;
                tmp1 = tmp2.yyyy * tmp6 + tmp1;
                tmp6 = _Color21 - tmp1;
                tmp1 = tmp2.zzzz * tmp6 + tmp1;
                tmp6 = _Color41 - tmp1;
                tmp4.w = tmp2.y * tmp2.x;
                tmp4.w = tmp2.z * tmp4.w;
                tmp7.xyz = tmp2.xxy * tmp2.zyz + -tmp4.www;
                tmp1 = tmp7.xxxx * tmp6 + tmp1;
                tmp6 = _Color51 - tmp1;
                tmp1 = tmp7.yyyy * tmp6 + tmp1;
                tmp6 = _Color61 - tmp1;
                tmp1 = tmp7.zzzz * tmp6 + tmp1;
                tmp6 = _Color71 - tmp1;
                tmp1 = tmp4.wwww * tmp6 + tmp1;
                tmp6.xyz = tmp1.www * float3(8.0, 0.75, -0.1) + float3(-1.0, 0.25, 0.6);
                tmp5.w = exp(tmp6.x);
                tmp0.w = tmp0.w * tmp5.w;
                tmp0.w = exp(tmp0.w);
                tmp5.w = tmp1.w + tmp1.w;
                tmp5.w = saturate(tmp6.y * tmp5.w);
                tmp0.w = tmp0.w * tmp5.w;
                tmp6.xy = tmp1.ww * float2(0.75, 3.0);
                tmp0.w = saturate(tmp0.w * tmp6.y);
                tmp8 = tex2D(_AmbientOcclusion, inp.texcoord.xy);
                tmp5.w = tmp8.x * inp.color.x;
                tmp6.w = 1.0 - tmp8.w;
                tmp7.w = tmp0.w * tmp5.w;
                tmp8 = _Color00 - _Color30;
                tmp8 = tmp2.xxxx * tmp8 + _Color30;
                tmp9 = _Color10 - tmp8;
                tmp8 = tmp2.yyyy * tmp9 + tmp8;
                tmp9 = _Color20 - tmp8;
                tmp8 = tmp2.zzzz * tmp9 + tmp8;
                tmp2.x = 1.0 - tmp2.w;
                tmp9 = _Color40 - tmp8;
                tmp8 = tmp7.xxxx * tmp9 + tmp8;
                tmp9 = _Color50 - tmp8;
                tmp8 = tmp7.yyyy * tmp9 + tmp8;
                tmp9 = _Color60 - tmp8;
                tmp8 = tmp7.zzzz * tmp9 + tmp8;
                tmp9 = _Color70 - tmp8;
                tmp8 = tmp4.wwww * tmp9 + tmp8;
                tmp2.y = tmp5.w * tmp5.w;
                tmp2.y = saturate(tmp8.w * tmp2.y);
                tmp2.z = tmp7.w * 0.5 + -tmp2.y;
                tmp2.z = tmp8.w * tmp2.z + tmp2.y;
                tmp2.w = log(tmp2.z);
                tmp4.w = tmp1.w * 2.0 + 1.0;
                tmp2.w = tmp2.w * tmp4.w;
                tmp2.w = exp(tmp2.w);
                tmp2.w = min(tmp2.w, 1.0);
                tmp4.w = saturate(tmp2.z * -2.181818 + 1.2);
                tmp7.xy = tmp2.zz * float2(2.666667, 5.0);
                tmp2.z = tmp2.z - 0.1;
                tmp2.z = saturate(tmp2.z * -1.111111 + 1.0);
                tmp7.xy = saturate(tmp7.xy);
                tmp4.w = tmp4.w * tmp7.x;
                tmp2.z = tmp2.z * tmp7.y;
                tmp2.z = tmp6.x * tmp2.z;
                tmp4.w = saturate(tmp6.y * tmp4.w);
                tmp2.w = tmp2.w - tmp4.w;
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.z = log(tmp2.z);
                tmp6.xy = tmp1.ww + float2(2.0, -0.5);
                tmp2.z = tmp2.z * tmp6.x;
                tmp4.w = saturate(tmp6.y * 1.6);
                tmp2.z = exp(tmp2.z);
                tmp2.z = min(tmp2.z, 1.0);
                tmp2.w = tmp2.z + tmp2.w;
                tmp2.w = min(tmp2.w, 1.0);
                tmp6.xy = tmp2.ww * float2(1.515152, 3.030303);
                tmp6.xy = min(tmp6.xy, float2(1.0, 1.0));
                tmp7.xy = tmp1.ww * float2(-0.1, 0.3) + float2(0.5, 1.2);
                tmp1.xyz = tmp1.xyz - tmp8.xyz;
                tmp1.w = max(tmp1.w, 0.001);
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.xyz = tmp2.yyy * tmp1.xyz + tmp8.xyz;
                tmp2.y = max(tmp2.x, tmp8.w);
                tmp8 = tex2D(_Override, inp.texcoord.xy);
                tmp8.xyz = tmp8.xyz - tmp1.xyz;
                tmp1.xyz = tmp8.www * tmp8.xyz + tmp1.xyz;
                tmp7.z = tmp1.y >= tmp1.z;
                tmp7.z = tmp7.z ? 1.0 : 0.0;
                tmp8.xy = tmp1.zy;
                tmp9.xy = tmp1.yz - tmp8.xy;
                tmp8.zw = float2(-1.0, 0.6666667);
                tmp9.zw = float2(1.0, -1.0);
                tmp8 = tmp7.zzzz * tmp9.xywz + tmp8.xywz;
                tmp7.z = tmp1.x >= tmp8.x;
                tmp7.z = tmp7.z ? 1.0 : 0.0;
                tmp9.z = tmp8.w;
                tmp8.w = tmp1.x;
                tmp9.xyw = tmp8.wyx;
                tmp9 = tmp9 - tmp8;
                tmp8 = tmp7.zzzz * tmp9 + tmp8;
                tmp7.z = min(tmp8.y, tmp8.w);
                tmp7.z = tmp8.x - tmp7.z;
                tmp7.w = tmp7.z * 6.0 + 0.0;
                tmp8.y = tmp8.w - tmp8.y;
                tmp7.w = tmp8.y / tmp7.w;
                tmp7.w = tmp7.w + tmp8.z;
                tmp8.yzw = abs(tmp7.www) + float3(0.95, 0.6166667, 0.2833333);
                tmp9.xyz = abs(tmp7.www) + float3(1.01, 0.6766667, 0.3433333);
                tmp9.xyz = frac(tmp9.xyz);
                tmp9.xyz = tmp9.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp9.xyz = saturate(abs(tmp9.xyz) - float3(1.0, 1.0, 1.0));
                tmp9.xyz = tmp9.xyz - float3(1.0, 1.0, 1.0);
                tmp8.yzw = frac(tmp8.yzw);
                tmp8.yzw = tmp8.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp8.yzw = saturate(abs(tmp8.yzw) - float3(1.0, 1.0, 1.0));
                tmp8.yzw = tmp8.yzw - float3(1.0, 1.0, 1.0);
                tmp7.w = tmp8.x + 0.0;
                tmp7.z = tmp7.z / tmp7.w;
                tmp8.yzw = tmp7.zzz * tmp8.yzw + float3(1.0, 1.0, 1.0);
                tmp9.xyz = tmp7.zzz * tmp9.xyz + float3(1.0, 1.0, 1.0);
                tmp10.xyz = tmp8.yzw * tmp8.xxx;
                tmp7.z = dot(tmp10.xyz, float3(0.299, 0.587, 0.114));
                tmp11.xyz = -tmp8.xxx * tmp8.yzw + tmp7.zzz;
                tmp8.yzw = tmp8.xxx * tmp8.yzw + -tmp11.xyz;
                tmp10.xyz = tmp11.xyz * float3(0.2, 0.2, 0.2) + tmp10.xyz;
                tmp10.xyz = saturate(tmp6.zzz * tmp10.xyz);
                tmp7.xzw = saturate(tmp7.xxx * tmp8.yzw);
                tmp8.yzw = tmp1.xyz - tmp7.xzw;
                tmp7.xzw = tmp6.xxx * tmp8.yzw + tmp7.xzw;
                tmp7.xzw = tmp7.xzw - tmp10.xyz;
                tmp6.xyz = tmp6.yyy * tmp7.xzw + tmp10.xyz;
                tmp7.xzw = tmp8.xxx * tmp9.xyz;
                tmp8.y = dot(tmp7.xyz, float3(0.299, 0.587, 0.114));
                tmp8.xyz = -tmp8.xxx * tmp9.xyz + tmp8.yyy;
                tmp7.xzw = tmp8.xyz * float3(0.05, 0.05, 0.05) + tmp7.xzw;
                tmp7.xyz = saturate(tmp7.yyy * tmp7.xzw);
                tmp7.xyz = tmp7.xyz - tmp1.xyz;
                tmp7.w = tmp2.w - 0.33;
                tmp7.w = tmp7.w * 1.492537;
                tmp7.w = max(tmp7.w, 0.0);
                tmp1.xyz = tmp7.www * tmp7.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz - tmp6.xyz;
                tmp1.xyz = tmp2.www * tmp1.xyz + tmp6.xyz;
                tmp2.w = tmp1.y >= tmp1.z;
                tmp2.w = tmp2.w ? 1.0 : 0.0;
                tmp7.xy = tmp1.zy;
                tmp8.xy = tmp1.yz - tmp7.xy;
                tmp7.zw = float2(-1.0, 0.6666667);
                tmp8.zw = float2(1.0, -1.0);
                tmp7 = tmp2.wwww * tmp8.xywz + tmp7.xywz;
                tmp2.w = tmp1.x >= tmp7.x;
                tmp2.w = tmp2.w ? 1.0 : 0.0;
                tmp8.z = tmp7.w;
                tmp7.w = tmp1.x;
                tmp8.xyw = tmp7.wyx;
                tmp8 = tmp8 - tmp7;
                tmp7 = tmp2.wwww * tmp8 + tmp7;
                tmp2.w = min(tmp7.y, tmp7.w);
                tmp2.w = tmp7.x - tmp2.w;
                tmp6.x = tmp2.w * 6.0 + 0.0;
                tmp6.y = tmp7.w - tmp7.y;
                tmp6.x = tmp6.y / tmp6.x;
                tmp6.x = tmp6.x + tmp7.z;
                tmp6.xyz = abs(tmp6.xxx) + float3(0.88, 0.5466667, 0.2133333);
                tmp6.xyz = frac(tmp6.xyz);
                tmp6.xyz = tmp6.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp6.xyz = saturate(abs(tmp6.xyz) - float3(1.0, 1.0, 1.0));
                tmp6.xyz = tmp6.xyz - float3(1.0, 1.0, 1.0);
                tmp7.y = tmp7.x + 0.0;
                tmp2.w = tmp2.w / tmp7.y;
                tmp6.xyz = tmp2.www * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp7.yzw = tmp6.xyz * tmp7.xxx;
                tmp2.w = dot(tmp7.xyz, float3(0.299, 0.587, 0.114));
                tmp6.xyz = -tmp7.xxx * tmp6.xyz + tmp2.www;
                tmp6.xyz = tmp6.xyz * float3(0.1, 0.1, 0.1) + tmp7.yzw;
                tmp6.xyz = tmp6.xyz - tmp1.xyz;
                tmp1.xyz = tmp2.zzz * tmp6.xyz + tmp1.xyz;
                tmp6.xyz = tmp1.xyz * float3(1.333, 1.333, 1.333);
                tmp2.z = dot(tmp6.xyz, float3(0.299, 0.587, 0.114));
                tmp1.xyz = -tmp1.xyz * float3(1.333, 1.333, 1.333) + tmp2.zzz;
                tmp1.xyz = tmp1.xyz * tmp4.www;
                tmp1.xyz = tmp0.www * tmp1.xyz + tmp6.xyz;
                tmp0.w = tmp1.y >= tmp1.z;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp7.xy = tmp1.zy;
                tmp8.xy = tmp1.yz - tmp7.xy;
                tmp7.zw = float2(-1.0, 0.6666667);
                tmp8.zw = float2(1.0, -1.0);
                tmp7 = tmp0.wwww * tmp8.xywz + tmp7.xywz;
                tmp0.w = tmp1.x >= tmp7.x;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp8.z = tmp7.w;
                tmp7.w = tmp1.x;
                tmp8.xyw = tmp7.wyx;
                tmp8 = tmp8 - tmp7;
                tmp7 = tmp0.wwww * tmp8 + tmp7;
                tmp0.w = min(tmp7.y, tmp7.w);
                tmp0.w = tmp7.x - tmp0.w;
                tmp2.z = tmp0.w * 6.0 + 0.0;
                tmp2.w = tmp7.w - tmp7.y;
                tmp2.z = tmp2.w / tmp2.z;
                tmp2.z = tmp2.z + tmp7.z;
                tmp6.xy = tmp7.xx + float2(0.0, 0.1);
                tmp7.xyz = abs(tmp2.zzz) + float3(1.0, 0.6666667, 0.3333333);
                tmp7.xyz = frac(tmp7.xyz);
                tmp7.xyz = tmp7.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp7.xyz = saturate(abs(tmp7.xyz) - float3(1.0, 1.0, 1.0));
                tmp7.xyz = tmp7.xyz - float3(1.0, 1.0, 1.0);
                tmp0.w = tmp0.w / tmp6.x;
                tmp0.w = tmp0.w - 0.5;
                tmp7.xyz = tmp0.www * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp6.yyy * tmp7.xyz + -tmp1.xyz;
                tmp1.xyz = tmp6.www * tmp6.xyz + tmp1.xyz;
                tmp0.w = tmp1.y >= tmp1.z;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp6.xy = tmp1.zy;
                tmp7.xy = tmp1.yz - tmp6.xy;
                tmp6.zw = float2(-1.0, 0.6666667);
                tmp7.zw = float2(1.0, -1.0);
                tmp6 = tmp0.wwww * tmp7.xywz + tmp6.xywz;
                tmp0.w = tmp1.x >= tmp6.x;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp7.z = tmp6.w;
                tmp6.w = tmp1.x;
                tmp7.xyw = tmp6.wyx;
                tmp7 = tmp7 - tmp6;
                tmp6 = tmp0.wwww * tmp7 + tmp6;
                tmp0.w = min(tmp6.y, tmp6.w);
                tmp0.w = tmp6.x - tmp0.w;
                tmp2.z = tmp0.w * 6.0 + 0.0;
                tmp2.w = tmp6.w - tmp6.y;
                tmp2.z = tmp2.w / tmp2.z;
                tmp2.z = tmp2.z + tmp6.z;
                tmp6.xy = tmp6.xx + float2(0.0, -0.1);
                tmp7.xyz = abs(tmp2.zzz) + float3(1.05, 0.7166667, 0.3833334);
                tmp7.xyz = frac(tmp7.xyz);
                tmp7.xyz = tmp7.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp7.xyz = saturate(abs(tmp7.xyz) - float3(1.0, 1.0, 1.0));
                tmp7.xyz = tmp7.xyz - float3(1.0, 1.0, 1.0);
                tmp0.w = tmp0.w / tmp6.x;
                tmp2.z = max(tmp6.y, 0.1);
                tmp2.z = min(tmp2.z, 1.0);
                tmp0.w = tmp0.w + 0.2;
                tmp6.xyz = tmp0.www * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp2.zzz * tmp6.xyz + tmp1.xyz;
                tmp6.xyz = tmp2.zzz * tmp6.xyz;
                tmp1.xyz = saturate(tmp5.www * tmp1.xyz + tmp6.xyz);
                tmp0.w = _Time.y * 6.283;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w + 1.0;
                tmp2.zw = tmp0.ww * float2(0.35, 0.05) + float2(0.5, 0.9);
                tmp0.w = tmp2.w - tmp2.z;
                tmp2.w = _SpiralColor * 2.0 + -1.0;
                tmp0.w = abs(tmp2.w) * tmp0.w + tmp2.z;
                tmp6.x = tmp5.w * tmp0.w;
                tmp0.w = _GlowSpeed * _Time.y;
                tmp7.y = frac(tmp0.w);
                tmp6.y = _SpiralColor;
                tmp7.xzw = float3(0.0, -1.0, 0.6666667);
                tmp2.zw = tmp6.xy + tmp7.xy;
                tmp6 = tex2D(_RampAlphaGlow, tmp2.zw);
                tmp0.w = tmp2.x * _GlowMultiplier;
                tmp0.w = tmp0.w * 3.0;
                tmp6.xyz = tmp6.xyz * tmp0.www + -tmp1.xyz;
                tmp1.xyz = tmp2.xxx * tmp6.xyz + tmp1.xyz;
                tmp6.xyz = tmp1.xyz * _GlowMultiplier.xxx + -tmp1.xyz;
                tmp1.xyz = tmp2.xxx * tmp6.xyz + tmp1.xyz;
                tmp6.xyw = tmp2.yyy * -tmp1.yzx + tmp1.yzx;
                tmp0.w = tmp6.x >= tmp6.y;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp7.xy = tmp6.yx;
                tmp8.xy = tmp6.xy - tmp7.xy;
                tmp8.zw = float2(1.0, -1.0);
                tmp7 = tmp0.wwww * tmp8 + tmp7;
                tmp0.w = tmp6.w >= tmp7.x;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp6.xyz = tmp7.xyw;
                tmp7.xyw = tmp6.wyx;
                tmp7 = tmp7 - tmp6;
                tmp6 = tmp0.wwww * tmp7 + tmp6;
                tmp0.w = min(tmp6.y, tmp6.w);
                tmp0.w = tmp6.x - tmp0.w;
                tmp2.x = tmp6.w - tmp6.y;
                tmp2.z = tmp0.w * 6.0 + 0.0;
                tmp2.x = tmp2.x / tmp2.z;
                tmp2.z = tmp6.x + 0.0;
                tmp0.w = tmp0.w / tmp2.z;
                tmp7 = tex2D(_PaintStrokes, tmp3.xy);
                tmp3 = tex2D(_PaintStrokes, tmp3.zw);
                tmp8.x = inp.texcoord1.z;
                tmp8.y = inp.texcoord2.z;
                tmp8.z = inp.texcoord3.z;
                tmp8.xyz = abs(tmp8.xyz) * abs(tmp8.xyz);
                tmp3.xyz = tmp3.xyz * tmp8.yyy;
                tmp3.xyz = tmp8.xxx * tmp7.xyz + tmp3.xyz;
                tmp3.xyz = tmp8.zzz * tmp4.xyz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp2.x = tmp2.x + tmp6.z;
                tmp2.z = tmp3.z * 0.075 + tmp6.x;
                tmp2.x = tmp3.x * 0.04 + abs(tmp2.x);
                tmp0.w = tmp3.y * 0.05 + tmp0.w;
                tmp3.xyz = tmp2.xxx + float3(1.0, 0.6666667, 0.3333333);
                tmp3.xyz = frac(tmp3.xyz);
                tmp3.xyz = tmp3.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp3.xyz = saturate(abs(tmp3.xyz) - float3(1.0, 1.0, 1.0));
                tmp3.xyz = tmp3.xyz - float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp0.www * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xzw = tmp2.zzz * tmp3.xyz;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp5.xyz;
                tmp4.xyz = tmp3.yyy * unity_MatrixV._m01_m11_m21;
                tmp3.xyw = unity_MatrixV._m00_m10_m20 * tmp3.xxx + tmp4.xyz;
                tmp3.xyz = unity_MatrixV._m02_m12_m22 * tmp3.zzz + tmp3.xyw;
                tmp4.xyz = tmp0.yyy * unity_MatrixV._m01_m11_m21;
                tmp0.xyw = unity_MatrixV._m00_m10_m20 * tmp0.xxx + tmp4.xyz;
                tmp0.xyz = unity_MatrixV._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp0.z = tmp0.z * 1.0;
                tmp4.xy = tmp0.xy * float2(-1.0, -1.0) + tmp3.xy;
                tmp4.z = tmp3.z * tmp0.z;
                tmp0.x = dot(tmp4.xyz, tmp4.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xy = tmp0.xx * tmp4.xy;
                tmp0.xy = tmp0.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0 = tex2D(_Rim, tmp0.xy);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _RimStrength.xxx;
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.w = dot(tmp3.xyz, float3(0.299, 0.587, 0.114));
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                tmp3.xyz = tmp4.xyz * float3(0.5, 0.5, 0.5) + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                tmp3.xyz = glstate_lightmodel_ambient.xyz * float3(0.2, 0.2, 0.2);
                tmp4.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp2.yyy * tmp1.xyz + tmp4.xyz;
                tmp0.xyz = tmp5.www * tmp0.xyz + tmp1.xyz;
                tmp1.xy = inp.texcoord4.xy / inp.texcoord4.ww;
                tmp3 = tex2D(_LightBuffer, tmp1.xy);
                tmp3 = log(tmp3);
                tmp0.w = tmp1.w * -tmp3.w;
                tmp1.xyz = inp.texcoord6.xyz - tmp3.xyz;
                tmp3.xyz = tmp1.xyz * _SpecColor.xyz;
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp1.xyz = tmp2.xzw * tmp1.xyz + tmp3.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "Meta"
			Tags { "DisableBatching" = "true" "IsEmissive" = "true" "LIGHTMODE" = "META" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
			Cull Off
			GpuProgramID 285417
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord2_ST;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color30;
			float4 _Color00;
			float4 _Color10;
			float4 _Color20;
			float4 _Color40;
			float4 _Color50;
			float4 _Color60;
			float4 _Color70;
			float4 _Color31;
			float4 _Color01;
			float4 _Color11;
			float4 _Color21;
			float4 _Color51;
			float4 _Color61;
			float4 _Color71;
			float _SpiralColor;
			float _GlowSpeed;
			float _GlowMultiplier;
			float4 _PaintStrokes_ST;
			float _RimStrength;
			float unity_OneOverOutputBoost;
			float unity_MaxOutputValue;
			float unity_UseLinearSpace;
			// Custom ConstantBuffers for Vertex Shader
			CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaVertexControl;
			CBUFFER_END
			// Custom ConstantBuffers for Fragment Shader
			CBUFFER_START(SRAMPActorRecolorX8_Normal_PaintTri)
				float4 _Color41;
			CBUFFER_END
			CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaFragmentControl;
			CBUFFER_END
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _ColorMask;
			sampler2D _AmbientOcclusion;
			sampler2D _Override;
			sampler2D _RampAlphaGlow;
			sampler2D _PaintStrokes;
			sampler2D _Rim;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
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
                o.position = tmp0 + unity_MatrixVP._m03_m13_m23_m33;
                o.texcoord.xy = v.texcoord1.xy * _texcoord2_ST.xy + _texcoord2_ST.zw;
                o.texcoord.zw = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp1.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp0.xyz * tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx + -tmp2.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                o.texcoord1.y = tmp2.x;
                tmp3.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp3.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp3.xyz;
                o.texcoord1.w = tmp3.x;
                o.texcoord1.x = tmp1.z;
                o.texcoord1.z = tmp0.y;
                o.texcoord2.x = tmp1.x;
                o.texcoord3.x = tmp1.y;
                o.texcoord2.z = tmp0.z;
                o.texcoord3.z = tmp0.x;
                o.texcoord2.w = tmp3.y;
                o.texcoord3.w = tmp3.z;
                o.texcoord2.y = tmp2.y;
                o.texcoord3.y = tmp2.z;
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
                float4 tmp10;
                float4 tmp11;
                tmp0.z = inp.texcoord3.w;
                tmp0.x = inp.texcoord1.w;
                tmp0.y = inp.texcoord2.w;
                tmp1.xyz = -tmp0.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp3 = _PaintStrokes_ST * tmp0.zyzx + _PaintStrokes_ST;
                tmp0.xy = _PaintStrokes_ST.xy * tmp0.xy + _PaintStrokes_ST.zw;
                tmp4 = tex2D(_PaintStrokes, tmp0.xy);
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp2.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2 = tex2D(_Normal, inp.texcoord.xy);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp2.z = sqrt(tmp0.w);
                tmp5.x = dot(inp.texcoord1.xyz, tmp2.xyz);
                tmp5.y = dot(inp.texcoord2.xyz, tmp2.xyz);
                tmp5.z = dot(inp.texcoord3.xyz, tmp2.xyz);
                tmp0.w = dot(tmp5.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp1 = _Color01 - _Color31;
                tmp2 = tex2D(_ColorMask, inp.texcoord.zw);
                tmp1 = tmp2.xxxx * tmp1 + _Color31;
                tmp6 = _Color11 - tmp1;
                tmp1 = tmp2.yyyy * tmp6 + tmp1;
                tmp6 = _Color21 - tmp1;
                tmp1 = tmp2.zzzz * tmp6 + tmp1;
                tmp6 = _Color41 - tmp1;
                tmp4.w = tmp2.y * tmp2.x;
                tmp4.w = tmp2.z * tmp4.w;
                tmp7.xyz = tmp2.xxy * tmp2.zyz + -tmp4.www;
                tmp1 = tmp7.xxxx * tmp6 + tmp1;
                tmp6 = _Color51 - tmp1;
                tmp1 = tmp7.yyyy * tmp6 + tmp1;
                tmp6 = _Color61 - tmp1;
                tmp1 = tmp7.zzzz * tmp6 + tmp1;
                tmp6 = _Color71 - tmp1;
                tmp1 = tmp4.wwww * tmp6 + tmp1;
                tmp6.xyz = tmp1.www * float3(8.0, 0.75, -0.1) + float3(-1.0, 0.25, 0.6);
                tmp5.w = exp(tmp6.x);
                tmp0.w = tmp0.w * tmp5.w;
                tmp0.w = exp(tmp0.w);
                tmp5.w = tmp1.w + tmp1.w;
                tmp5.w = saturate(tmp6.y * tmp5.w);
                tmp0.w = tmp0.w * tmp5.w;
                tmp6.xy = tmp1.ww * float2(0.75, 3.0);
                tmp0.w = saturate(tmp0.w * tmp6.y);
                tmp8 = tex2D(_AmbientOcclusion, inp.texcoord.xy);
                tmp5.w = tmp8.x * inp.color.x;
                tmp6.w = 1.0 - tmp8.w;
                tmp7.w = tmp0.w * tmp5.w;
                tmp8 = _Color00 - _Color30;
                tmp8 = tmp2.xxxx * tmp8 + _Color30;
                tmp9 = _Color10 - tmp8;
                tmp8 = tmp2.yyyy * tmp9 + tmp8;
                tmp9 = _Color20 - tmp8;
                tmp8 = tmp2.zzzz * tmp9 + tmp8;
                tmp2.x = 1.0 - tmp2.w;
                tmp9 = _Color40 - tmp8;
                tmp8 = tmp7.xxxx * tmp9 + tmp8;
                tmp9 = _Color50 - tmp8;
                tmp8 = tmp7.yyyy * tmp9 + tmp8;
                tmp9 = _Color60 - tmp8;
                tmp8 = tmp7.zzzz * tmp9 + tmp8;
                tmp9 = _Color70 - tmp8;
                tmp8 = tmp4.wwww * tmp9 + tmp8;
                tmp2.y = tmp5.w * tmp5.w;
                tmp2.y = saturate(tmp8.w * tmp2.y);
                tmp2.z = tmp7.w * 0.5 + -tmp2.y;
                tmp2.z = tmp8.w * tmp2.z + tmp2.y;
                tmp2.w = log(tmp2.z);
                tmp4.w = tmp1.w * 2.0 + 1.0;
                tmp2.w = tmp2.w * tmp4.w;
                tmp2.w = exp(tmp2.w);
                tmp2.w = min(tmp2.w, 1.0);
                tmp4.w = saturate(tmp2.z * -2.181818 + 1.2);
                tmp7.xy = tmp2.zz * float2(2.666667, 5.0);
                tmp2.z = tmp2.z - 0.1;
                tmp2.z = saturate(tmp2.z * -1.111111 + 1.0);
                tmp7.xy = saturate(tmp7.xy);
                tmp4.w = tmp4.w * tmp7.x;
                tmp2.z = tmp2.z * tmp7.y;
                tmp2.z = tmp6.x * tmp2.z;
                tmp4.w = saturate(tmp6.y * tmp4.w);
                tmp2.w = tmp2.w - tmp4.w;
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.z = log(tmp2.z);
                tmp6.xy = tmp1.ww + float2(2.0, -0.5);
                tmp2.z = tmp2.z * tmp6.x;
                tmp4.w = saturate(tmp6.y * 1.6);
                tmp2.z = exp(tmp2.z);
                tmp2.z = min(tmp2.z, 1.0);
                tmp2.w = tmp2.z + tmp2.w;
                tmp2.w = min(tmp2.w, 1.0);
                tmp6.xy = tmp2.ww * float2(1.515152, 3.030303);
                tmp6.xy = min(tmp6.xy, float2(1.0, 1.0));
                tmp7.xy = tmp1.ww * float2(-0.1, 0.3) + float2(0.5, 1.2);
                tmp1.xyz = tmp1.xyz - tmp8.xyz;
                tmp1.xyz = tmp2.yyy * tmp1.xyz + tmp8.xyz;
                tmp1.w = max(tmp2.x, tmp8.w);
                tmp8 = tex2D(_Override, inp.texcoord.xy);
                tmp8.xyz = tmp8.xyz - tmp1.xyz;
                tmp1.xyz = tmp8.www * tmp8.xyz + tmp1.xyz;
                tmp2.y = tmp1.y >= tmp1.z;
                tmp2.y = tmp2.y ? 1.0 : 0.0;
                tmp8.xy = tmp1.zy;
                tmp9.xy = tmp1.yz - tmp8.xy;
                tmp8.zw = float2(-1.0, 0.6666667);
                tmp9.zw = float2(1.0, -1.0);
                tmp8 = tmp2.yyyy * tmp9.xywz + tmp8.xywz;
                tmp2.y = tmp1.x >= tmp8.x;
                tmp2.y = tmp2.y ? 1.0 : 0.0;
                tmp9.z = tmp8.w;
                tmp8.w = tmp1.x;
                tmp9.xyw = tmp8.wyx;
                tmp9 = tmp9 - tmp8;
                tmp8 = tmp2.yyyy * tmp9 + tmp8;
                tmp2.y = min(tmp8.y, tmp8.w);
                tmp2.y = tmp8.x - tmp2.y;
                tmp7.z = tmp2.y * 6.0 + 0.0;
                tmp7.w = tmp8.w - tmp8.y;
                tmp7.z = tmp7.w / tmp7.z;
                tmp7.z = tmp7.z + tmp8.z;
                tmp8.yzw = abs(tmp7.zzz) + float3(0.95, 0.6166667, 0.2833333);
                tmp9.xyz = abs(tmp7.zzz) + float3(1.01, 0.6766667, 0.3433333);
                tmp9.xyz = frac(tmp9.xyz);
                tmp9.xyz = tmp9.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp9.xyz = saturate(abs(tmp9.xyz) - float3(1.0, 1.0, 1.0));
                tmp9.xyz = tmp9.xyz - float3(1.0, 1.0, 1.0);
                tmp8.yzw = frac(tmp8.yzw);
                tmp8.yzw = tmp8.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp8.yzw = saturate(abs(tmp8.yzw) - float3(1.0, 1.0, 1.0));
                tmp8.yzw = tmp8.yzw - float3(1.0, 1.0, 1.0);
                tmp7.z = tmp8.x + 0.0;
                tmp2.y = tmp2.y / tmp7.z;
                tmp8.yzw = tmp2.yyy * tmp8.yzw + float3(1.0, 1.0, 1.0);
                tmp9.xyz = tmp2.yyy * tmp9.xyz + float3(1.0, 1.0, 1.0);
                tmp10.xyz = tmp8.yzw * tmp8.xxx;
                tmp2.y = dot(tmp10.xyz, float3(0.299, 0.587, 0.114));
                tmp11.xyz = -tmp8.xxx * tmp8.yzw + tmp2.yyy;
                tmp8.yzw = tmp8.xxx * tmp8.yzw + -tmp11.xyz;
                tmp10.xyz = tmp11.xyz * float3(0.2, 0.2, 0.2) + tmp10.xyz;
                tmp10.xyz = saturate(tmp6.zzz * tmp10.xyz);
                tmp7.xzw = saturate(tmp7.xxx * tmp8.yzw);
                tmp8.yzw = tmp1.xyz - tmp7.xzw;
                tmp7.xzw = tmp6.xxx * tmp8.yzw + tmp7.xzw;
                tmp7.xzw = tmp7.xzw - tmp10.xyz;
                tmp6.xyz = tmp6.yyy * tmp7.xzw + tmp10.xyz;
                tmp7.xzw = tmp8.xxx * tmp9.xyz;
                tmp2.y = dot(tmp7.xyz, float3(0.299, 0.587, 0.114));
                tmp8.xyz = -tmp8.xxx * tmp9.xyz + tmp2.yyy;
                tmp7.xzw = tmp8.xyz * float3(0.05, 0.05, 0.05) + tmp7.xzw;
                tmp7.xyz = saturate(tmp7.yyy * tmp7.xzw);
                tmp7.xyz = tmp7.xyz - tmp1.xyz;
                tmp2.y = tmp2.w - 0.33;
                tmp2.y = tmp2.y * 1.492537;
                tmp2.y = max(tmp2.y, 0.0);
                tmp1.xyz = tmp2.yyy * tmp7.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz - tmp6.xyz;
                tmp1.xyz = tmp2.www * tmp1.xyz + tmp6.xyz;
                tmp2.y = tmp1.y >= tmp1.z;
                tmp2.y = tmp2.y ? 1.0 : 0.0;
                tmp7.xy = tmp1.zy;
                tmp8.xy = tmp1.yz - tmp7.xy;
                tmp7.zw = float2(-1.0, 0.6666667);
                tmp8.zw = float2(1.0, -1.0);
                tmp7 = tmp2.yyyy * tmp8.xywz + tmp7.xywz;
                tmp2.y = tmp1.x >= tmp7.x;
                tmp2.y = tmp2.y ? 1.0 : 0.0;
                tmp8.z = tmp7.w;
                tmp7.w = tmp1.x;
                tmp8.xyw = tmp7.wyx;
                tmp8 = tmp8 - tmp7;
                tmp7 = tmp2.yyyy * tmp8 + tmp7;
                tmp2.y = min(tmp7.y, tmp7.w);
                tmp2.y = tmp7.x - tmp2.y;
                tmp2.w = tmp2.y * 6.0 + 0.0;
                tmp6.x = tmp7.w - tmp7.y;
                tmp2.w = tmp6.x / tmp2.w;
                tmp2.w = tmp2.w + tmp7.z;
                tmp6.xyz = abs(tmp2.www) + float3(0.88, 0.5466667, 0.2133333);
                tmp6.xyz = frac(tmp6.xyz);
                tmp6.xyz = tmp6.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp6.xyz = saturate(abs(tmp6.xyz) - float3(1.0, 1.0, 1.0));
                tmp6.xyz = tmp6.xyz - float3(1.0, 1.0, 1.0);
                tmp2.w = tmp7.x + 0.0;
                tmp2.y = tmp2.y / tmp2.w;
                tmp6.xyz = tmp2.yyy * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp7.yzw = tmp6.xyz * tmp7.xxx;
                tmp2.y = dot(tmp7.xyz, float3(0.299, 0.587, 0.114));
                tmp6.xyz = -tmp7.xxx * tmp6.xyz + tmp2.yyy;
                tmp6.xyz = tmp6.xyz * float3(0.1, 0.1, 0.1) + tmp7.yzw;
                tmp6.xyz = tmp6.xyz - tmp1.xyz;
                tmp1.xyz = tmp2.zzz * tmp6.xyz + tmp1.xyz;
                tmp2.yzw = tmp1.xyz * float3(1.333, 1.333, 1.333);
                tmp6.x = dot(tmp2.xyz, float3(0.299, 0.587, 0.114));
                tmp1.xyz = -tmp1.xyz * float3(1.333, 1.333, 1.333) + tmp6.xxx;
                tmp1.xyz = tmp1.xyz * tmp4.www;
                tmp1.xyz = tmp0.www * tmp1.xyz + tmp2.yzw;
                tmp0.w = tmp1.y >= tmp1.z;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp7.xy = tmp1.zy;
                tmp8.xy = tmp1.yz - tmp7.xy;
                tmp7.zw = float2(-1.0, 0.6666667);
                tmp8.zw = float2(1.0, -1.0);
                tmp7 = tmp0.wwww * tmp8.xywz + tmp7.xywz;
                tmp0.w = tmp1.x >= tmp7.x;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp8.z = tmp7.w;
                tmp7.w = tmp1.x;
                tmp8.xyw = tmp7.wyx;
                tmp8 = tmp8 - tmp7;
                tmp7 = tmp0.wwww * tmp8 + tmp7;
                tmp0.w = min(tmp7.y, tmp7.w);
                tmp0.w = tmp7.x - tmp0.w;
                tmp2.y = tmp0.w * 6.0 + 0.0;
                tmp2.z = tmp7.w - tmp7.y;
                tmp2.y = tmp2.z / tmp2.y;
                tmp2.y = tmp2.y + tmp7.z;
                tmp2.zw = tmp7.xx + float2(0.0, 0.1);
                tmp6.xyz = abs(tmp2.yyy) + float3(1.0, 0.6666667, 0.3333333);
                tmp6.xyz = frac(tmp6.xyz);
                tmp6.xyz = tmp6.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp6.xyz = saturate(abs(tmp6.xyz) - float3(1.0, 1.0, 1.0));
                tmp6.xyz = tmp6.xyz - float3(1.0, 1.0, 1.0);
                tmp0.w = tmp0.w / tmp2.z;
                tmp0.w = tmp0.w - 0.5;
                tmp6.xyz = tmp0.www * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp2.yzw = tmp2.www * tmp6.xyz + -tmp1.xyz;
                tmp1.xyz = tmp6.www * tmp2.yzw + tmp1.xyz;
                tmp0.w = tmp1.y >= tmp1.z;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp6.xy = tmp1.zy;
                tmp7.xy = tmp1.yz - tmp6.xy;
                tmp6.zw = float2(-1.0, 0.6666667);
                tmp7.zw = float2(1.0, -1.0);
                tmp6 = tmp0.wwww * tmp7.xywz + tmp6.xywz;
                tmp0.w = tmp1.x >= tmp6.x;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp7.z = tmp6.w;
                tmp6.w = tmp1.x;
                tmp7.xyw = tmp6.wyx;
                tmp7 = tmp7 - tmp6;
                tmp6 = tmp0.wwww * tmp7 + tmp6;
                tmp0.w = min(tmp6.y, tmp6.w);
                tmp0.w = tmp6.x - tmp0.w;
                tmp2.y = tmp0.w * 6.0 + 0.0;
                tmp2.z = tmp6.w - tmp6.y;
                tmp2.y = tmp2.z / tmp2.y;
                tmp2.y = tmp2.y + tmp6.z;
                tmp2.zw = tmp6.xx + float2(0.0, -0.1);
                tmp6.xyz = abs(tmp2.yyy) + float3(1.05, 0.7166667, 0.3833334);
                tmp6.xyz = frac(tmp6.xyz);
                tmp6.xyz = tmp6.xyz * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp6.xyz = saturate(abs(tmp6.xyz) - float3(1.0, 1.0, 1.0));
                tmp6.xyz = tmp6.xyz - float3(1.0, 1.0, 1.0);
                tmp0.w = tmp0.w / tmp2.z;
                tmp2.y = max(tmp2.w, 0.1);
                tmp2.y = min(tmp2.y, 1.0);
                tmp0.w = tmp0.w + 0.2;
                tmp6.xyz = tmp0.www * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp2.yyy * tmp6.xyz + tmp1.xyz;
                tmp2.yzw = tmp2.yyy * tmp6.xyz;
                tmp1.xyz = saturate(tmp5.www * tmp1.xyz + tmp2.yzw);
                tmp0.w = _Time.y * 6.283;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w + 1.0;
                tmp2.yz = tmp0.ww * float2(0.35, 0.05) + float2(0.5, 0.9);
                tmp0.w = tmp2.z - tmp2.y;
                tmp2.z = _SpiralColor * 2.0 + -1.0;
                tmp0.w = abs(tmp2.z) * tmp0.w + tmp2.y;
                tmp6.x = tmp5.w * tmp0.w;
                tmp0.w = _GlowSpeed * _Time.y;
                tmp7.y = frac(tmp0.w);
                tmp6.y = _SpiralColor;
                tmp7.xzw = float3(0.0, 1.0, -1.0);
                tmp2.yz = tmp6.xy + tmp7.xy;
                tmp6 = tex2D(_RampAlphaGlow, tmp2.yz);
                tmp0.w = tmp2.x * _GlowMultiplier;
                tmp0.w = tmp0.w * 3.0;
                tmp2.yzw = tmp6.xyz * tmp0.www + -tmp1.xyz;
                tmp1.xyz = tmp2.xxx * tmp2.yzw + tmp1.xyz;
                tmp2.yzw = tmp1.xyz * _GlowMultiplier.xxx + -tmp1.xyz;
                tmp1.xyz = tmp2.xxx * tmp2.yzw + tmp1.xyz;
                tmp2.xyw = tmp1.www * -tmp1.yzx + tmp1.yzx;
                tmp0.w = tmp2.x >= tmp2.y;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp6.xy = tmp2.yx;
                tmp7.xy = tmp2.xy - tmp6.xy;
                tmp6.zw = float2(-1.0, 0.6666667);
                tmp6 = tmp0.wwww * tmp7 + tmp6;
                tmp0.w = tmp2.w >= tmp6.x;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp2.xyz = tmp6.xyw;
                tmp6.xyw = tmp2.wyx;
                tmp6 = tmp6 - tmp2;
                tmp2 = tmp0.wwww * tmp6 + tmp2;
                tmp0.w = min(tmp2.y, tmp2.w);
                tmp0.w = tmp2.x - tmp0.w;
                tmp2.y = tmp2.w - tmp2.y;
                tmp2.w = tmp0.w * 6.0 + 0.0;
                tmp2.y = tmp2.y / tmp2.w;
                tmp2.w = tmp2.x + 0.0;
                tmp0.w = tmp0.w / tmp2.w;
                tmp6 = tex2D(_PaintStrokes, tmp3.xy);
                tmp3 = tex2D(_PaintStrokes, tmp3.zw);
                tmp7.x = inp.texcoord1.z;
                tmp7.y = inp.texcoord2.z;
                tmp7.z = inp.texcoord3.z;
                tmp7.xyz = abs(tmp7.xyz) * abs(tmp7.xyz);
                tmp3.xyz = tmp3.xyz * tmp7.yyy;
                tmp3.xyz = tmp7.xxx * tmp6.xyz + tmp3.xyz;
                tmp3.xyz = tmp7.zzz * tmp4.xyz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp2.y = tmp2.y + tmp2.z;
                tmp2.x = tmp3.z * 0.075 + tmp2.x;
                tmp2.y = tmp3.x * 0.04 + abs(tmp2.y);
                tmp0.w = tmp3.y * 0.05 + tmp0.w;
                tmp2.yzw = tmp2.yyy + float3(1.0, 0.6666667, 0.3333333);
                tmp2.yzw = frac(tmp2.yzw);
                tmp2.yzw = tmp2.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp2.yzw = saturate(abs(tmp2.yzw) - float3(1.0, 1.0, 1.0));
                tmp2.yzw = tmp2.yzw - float3(1.0, 1.0, 1.0);
                tmp2.yzw = tmp0.www * tmp2.yzw + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.yzw * tmp2.xxx;
                tmp0.w = dot(tmp5.xyz, tmp5.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp5.xyz;
                tmp4.xyz = tmp3.yyy * unity_MatrixV._m01_m11_m21;
                tmp3.xyw = unity_MatrixV._m00_m10_m20 * tmp3.xxx + tmp4.xyz;
                tmp3.xyz = unity_MatrixV._m02_m12_m22 * tmp3.zzz + tmp3.xyw;
                tmp4.xyz = tmp0.yyy * unity_MatrixV._m01_m11_m21;
                tmp0.xyw = unity_MatrixV._m00_m10_m20 * tmp0.xxx + tmp4.xyz;
                tmp0.xyz = unity_MatrixV._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp0.z = tmp0.z * 1.0;
                tmp4.xy = tmp0.xy * float2(-1.0, -1.0) + tmp3.xy;
                tmp4.z = tmp3.z * tmp0.z;
                tmp0.x = dot(tmp4.xyz, tmp4.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xy = tmp0.xx * tmp4.xy;
                tmp0.xy = tmp0.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0 = tex2D(_Rim, tmp0.xy);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _RimStrength.xxx;
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.w = dot(tmp3.xyz, float3(0.299, 0.587, 0.114));
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                tmp3.xyz = tmp4.xyz * float3(0.5, 0.5, 0.5) + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                tmp3.xyz = glstate_lightmodel_ambient.xyz * float3(0.2, 0.2, 0.2);
                tmp4.xyz = tmp1.xyz * tmp3.xyz;
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.www * tmp1.xyz + tmp4.xyz;
                tmp0.xyz = tmp5.www * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp1.xyz = tmp0.xyz * tmp1.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.w = unity_UseLinearSpace != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp1.xyz = log(tmp2.xyz);
                tmp1.w = saturate(unity_OneOverOutputBoost);
                tmp1.xyz = tmp1.xyz * tmp1.www;
                tmp1.xyz = exp(tmp1.xyz);
                tmp1.xyz = min(tmp1.xyz, unity_MaxOutputValue.xxx);
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
			Tags { "DisableBatching" = "true" "IsEmissive" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 353419
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp1.xyz = -tmp0.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp1.x = dot(tmp2.xyz, tmp1.xyz);
                tmp1.x = -tmp1.x * tmp1.x + 1.0;
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x * unity_LightShadowBias.z;
                tmp1.xyz = -tmp2.xyz * tmp1.xxx + tmp0.xyz;
                tmp1.w = unity_LightShadowBias.z != 0.0;
                tmp0.xyz = tmp1.www ? tmp1.xyz : tmp0.xyz;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord1.xy = v.texcoord1.xy;
                o.texcoord1.zw = v.texcoord.xy;
                tmp0.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp0.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.xyz * tmp2.zxy;
                tmp1.xyz = tmp2.yzx * tmp0.yzx + -tmp1.xyz;
                tmp0.w = v.tangent.w * unity_WorldTransformParams.w;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord2.y = tmp1.x;
                o.texcoord2.z = tmp2.x;
                tmp3.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp3.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp3.xyz;
                o.texcoord2.w = tmp3.x;
                o.texcoord2.x = tmp0.z;
                o.texcoord3.x = tmp0.x;
                o.texcoord4.x = tmp0.y;
                o.texcoord3.z = tmp2.y;
                o.texcoord4.z = tmp2.z;
                o.texcoord3.w = tmp3.y;
                o.texcoord4.w = tmp3.z;
                o.texcoord3.y = tmp1.y;
                o.texcoord4.y = tmp1.z;
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