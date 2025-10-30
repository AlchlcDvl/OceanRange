Shader "SR/Paintlight/Triplanar Ruin Barrier" {
	Properties {
		[MaterialToggle] _UseMeshUVs ("Use Mesh UVs", Float) = 0
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		_Depth ("Depth", 2D) = "gray" {}
		_RampOffset ("Ramp Offset", Float) = 2
		_RampScale ("Ramp Scale", Float) = 1
		_RampUpper ("RampUpper", Color) = (0.4431373,0.3921569,0.5686275,1)
		_SeaLevelRampOffset ("SeaLevelRamp Offset", Float) = -3
		_SeaLevelRampScale ("SeaLevelRamp Scale", Float) = 1
		_SeaLevelRampLower ("SeaLevelRampLower", Color) = (0.3098039,0.4078431,0.3921569,1)
		[MaterialToggle] _SeaLevelRampObjectPos ("SeaLevelRamp Object Pos", Float) = 0
		_SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_Gloss ("Gloss", Range(0, 1)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_Normal ("Normal", 2D) = "bump" {}
		_ColorRamp ("Color-Ramp", 2D) = "gray" {}
		_DetailNoiseMask ("Detail Noise Mask", 2D) = "black" {}
		_BlurOffset ("Blur Offset", Float) = 0
		_GlassColor ("Glass Color", Color) = (0.5,0.5,0.5,1)
	}
	SubShader {
		LOD 550
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		GrabPass {
			"RefractionRuinBarrier"
		}
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 49426
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
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
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
			float _RampOffset;
			float _RampScale;
			float4 _RampUpper;
			float _SeaLevelRampOffset;
			float _SeaLevelRampScale;
			float4 _SeaLevelRampLower;
			float _Gloss;
			float _GlossPower;
			float4 _SpecularColor;
			float _SeaLevelRampObjectPos;
			float _UseMeshUVs;
			float4 _ColorRamp_ST;
			float4 _Normal_ST;
			float4 _DetailNoiseMask_ST;
			float _BlurOffset;
			float4 _GlassColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D RefractionRuinBarrier;
			sampler2D _DetailNoiseMask;
			sampler2D _Depth;
			sampler2D _ColorRamp;
			sampler2D _PrimaryTex;
			
			// Keywords: DIRECTIONAL
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
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord5 = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                tmp0 = inp.texcoord1.xyzx * _Normal_ST + _Normal_ST;
                tmp1 = tex2D(_Normal, tmp0.zw);
                tmp0 = tex2D(_Normal, tmp0.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.z = dot(tmp1.xy, tmp1.xy);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp1.z = sqrt(tmp0.z);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.xy = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp3.x = dot(tmp2.xy, float2(0.0000003, -1.0));
                tmp3.y = dot(tmp2.xy, float2(1.0, 0.0000003));
                tmp2.xy = tmp3.xy + float2(0.5, 0.5);
                tmp2.zw = tmp2.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp3 = tex2D(_Normal, tmp2.zw);
                tmp3.x = tmp3.w * tmp3.x;
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp3.xy, tmp3.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp3.z = sqrt(tmp0.w);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.z = sqrt(tmp0.w);
                tmp3.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * inp.texcoord2.yxz;
                tmp5.xyz = abs(tmp4.yxz) * abs(tmp4.yxz);
                tmp3.xyz = tmp5.xxx * tmp3.xyz + tmp0.xyz;
                tmp1.xyz = tmp1.xyz - tmp3.xyz;
                tmp1.xyz = tmp5.yyy * tmp1.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp0.xyz = tmp5.zzz * tmp0.xyz + tmp1.xyz;
                tmp1.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.z = sqrt(tmp0.w);
                tmp0.w = _UseMeshUVs <= 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp3.xyz = tmp0.xyz * tmp0.www;
                tmp1.w = _UseMeshUVs >= 0.0;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp1.xyz = tmp1.www * tmp1.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp2.z = tmp0.w * tmp1.w;
                tmp0.xyz = tmp2.zzz * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.yyy * inp.texcoord4.xyz;
                tmp1.xyz = tmp0.xxx * inp.texcoord3.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.zzz * tmp4.yxz + tmp1.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp3.xyz;
                tmp0.z = dot(tmp1.xyz, tmp3.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp2.w = log(tmp0.z);
                tmp6.xy = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp6 = tex2D(_Depth, tmp6.xy);
                tmp7 = inp.texcoord1.zxxy * _Depth_ST + _Depth_ST;
                tmp8 = tex2D(_Depth, tmp7.zw);
                tmp7 = tex2D(_Depth, tmp7.xy);
                tmp3.w = tmp5.y * tmp7.x;
                tmp6.yz = tmp2.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp7 = tex2D(_Depth, tmp6.yz);
                tmp3.w = tmp5.x * tmp7.x + tmp3.w;
                tmp3.w = tmp5.z * tmp8.x + tmp3.w;
                tmp4.w = tmp0.w * tmp3.w;
                tmp4.w = tmp1.w * tmp6.x + tmp4.w;
                tmp3.w = tmp3.w - tmp4.w;
                tmp3.w = tmp2.z * tmp3.w + tmp4.w;
                tmp4.w = tmp2.w * tmp3.w;
                tmp6.xy = tmp2.ww * float2(1.25, 0.2);
                tmp6.xy = exp(tmp6.xy);
                tmp2.w = exp(tmp4.w);
                tmp2.w = 1.0 - tmp2.w;
                tmp2.w = log(tmp2.w);
                tmp4.w = _GlossPower * 16.0 + -1.0;
                tmp4.w = exp(tmp4.w);
                tmp2.w = tmp2.w * tmp4.w;
                tmp2.w = exp(tmp2.w);
                tmp5.w = dot(-tmp3.xyz, tmp1.xyz);
                tmp5.w = tmp5.w + tmp5.w;
                tmp7.xyz = tmp1.xyz * -tmp5.www + -tmp3.xyz;
                tmp3.x = dot(tmp4.xyz, tmp3.xyz);
                tmp3.x = max(tmp3.x, 0.0);
                tmp3.x = 1.0 - tmp3.x;
                tmp3.x = log(tmp3.x);
                tmp3.x = tmp3.x * tmp3.w;
                tmp3.x = exp(tmp3.x);
                tmp3.x = tmp3.x * 1.333333;
                tmp3.x = min(tmp3.x, 1.0);
                tmp3.y = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp3.y = rsqrt(tmp3.y);
                tmp8.xyz = tmp3.yyy * _WorldSpaceLightPos0.xyz;
                tmp3.y = dot(tmp8.xyz, tmp7.xyz);
                tmp1.x = dot(tmp8.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.y = max(tmp3.y, 0.0);
                tmp1.y = log(tmp1.y);
                tmp1.y = tmp1.y * tmp4.w;
                tmp1.y = exp(tmp1.y);
                tmp1.y = tmp2.w + tmp1.y;
                tmp1.y = tmp1.y * _Gloss;
                tmp7.xyz = tmp1.yyy * _LightColor0.xyz;
                tmp7.xyz = tmp7.xyz * _Gloss.xxx;
                tmp7.xyz = tmp7.xyz * float3(148.368, 148.368, 148.368) + float3(-0.9792286, -0.9792286, -0.9792286);
                tmp1.y = tmp0.z * tmp0.z;
                tmp3.yz = tmp3.ww * float2(-2.994012, 0.25) + float2(1.997006, 0.25);
                tmp1.z = tmp3.z * tmp3.z;
                tmp3.yw = saturate(tmp3.yw);
                tmp7.xyz = saturate(tmp1.zzz * tmp7.xyz + tmp1.yyy);
                tmp1.y = tmp0.z * tmp1.y;
                tmp0.z = rsqrt(tmp0.z);
                tmp0.z = 1.0 / tmp0.z;
                tmp7.xyz = saturate(tmp7.xyz * _SpecularColor.xyz);
                tmp6.zw = tmp2.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp2.xy = tmp2.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp8 = tex2D(_DetailNoiseMask, tmp2.xy);
                tmp9 = tex2D(_PrimaryTex, tmp6.zw);
                tmp10 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp11 = tex2D(_PrimaryTex, tmp10.xy);
                tmp10 = tex2D(_PrimaryTex, tmp10.zw);
                tmp2.xyw = tmp5.yyy * tmp11.xyz;
                tmp2.xyw = tmp5.xxx * tmp9.xyz + tmp2.xyw;
                tmp2.xyw = tmp5.zzz * tmp10.xyz + tmp2.xyw;
                tmp8.yzw = tmp0.www * tmp2.xyw;
                tmp6.zw = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp9 = tex2D(_PrimaryTex, tmp6.zw);
                tmp8.yzw = tmp1.www * tmp9.xyz + tmp8.yzw;
                tmp2.xyw = tmp2.xyw - tmp8.yzw;
                tmp2.xyz = tmp2.zzz * tmp2.xyw + tmp8.yzw;
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp0.w = tmp0.w * 0.25;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w + tmp0.w;
                tmp9.z = tmp3.w * tmp3.x + tmp0.w;
                tmp9.yw = float2(0.0, 0.0);
                tmp1.zw = tmp9.zw * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp10 = tex2D(_ColorRamp, tmp1.zw);
                tmp2.xyz = tmp2.xyz - tmp10.xyz;
                tmp11 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp12 = tex2D(_DetailNoiseMask, tmp11.xy);
                tmp11 = tex2D(_DetailNoiseMask, tmp11.zw);
                tmp0.w = tmp5.y * tmp12.x;
                tmp0.w = tmp5.x * tmp8.x + tmp0.w;
                tmp0.w = tmp5.z * tmp11.x + tmp0.w;
                tmp1.z = tmp0.w - 0.5;
                tmp1.z = -tmp1.z * 2.0 + 1.0;
                tmp1.w = 1.0 - tmp3.y;
                tmp1.z = -tmp1.z * tmp1.w + 1.0;
                tmp1.w = tmp0.w + tmp0.w;
                tmp1.w = tmp3.y * tmp1.w;
                tmp2.w = tmp0.w > 0.5;
                tmp1.z = saturate(tmp2.w ? tmp1.z : tmp1.w);
                tmp2.xyz = tmp1.zzz * tmp2.xyz + tmp10.xyz;
                tmp3.xyz = saturate(tmp7.xyz + tmp10.xyz);
                tmp5.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp1.w = -_SeaLevelRampObjectPos * unity_ObjectToWorld._m13 + inp.texcoord1.y;
                tmp1.w = tmp1.w - _SeaLevelRampOffset;
                tmp1.w = tmp1.w * _SeaLevelRampScale;
                tmp1.w = saturate(tmp1.w * 0.2 + 0.5);
                tmp8.xyz = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp8.xyz = tmp1.www * tmp8.xyz + _SeaLevelRampLower.xyz;
                tmp10.xyz = float3(1.0, 1.0, 1.0) - tmp8.xyz;
                tmp1.w = inp.texcoord1.y - _WorldSpaceCameraPos.y;
                tmp1.w = tmp1.w * _RampScale;
                tmp1.w = tmp1.w * 0.1 + -_RampOffset;
                tmp1.w = saturate(tmp1.w * 0.5 + 0.5);
                tmp11.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp12.xyz = tmp1.www * tmp11.xyz;
                tmp11.xyz = tmp1.www * tmp11.xyz + float3(0.5, 0.5, 0.5);
                tmp12.xyz = -tmp12.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp10.xyz = -tmp12.xyz * tmp10.xyz + float3(1.0, 1.0, 1.0);
                tmp12.xyz = tmp11.xyz + tmp11.xyz;
                tmp11.xyz = tmp11.xyz > float3(0.5, 0.5, 0.5);
                tmp8.xyz = tmp8.xyz * tmp12.xyz;
                tmp8.xyz = saturate(tmp11.xyz ? tmp10.xyz : tmp8.xyz);
                tmp10.xyz = float3(1.0, 1.0, 1.0) - tmp8.xyz;
                tmp11.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = tmp8.xyz * tmp2.xyz;
                tmp8.xyz = -tmp11.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp8.xyz = -tmp8.xyz * tmp10.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = saturate(tmp5.xyz ? tmp8.xyz : tmp2.xyz);
                tmp1.w = 1.0 - tmp1.z;
                tmp5.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp8.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp1.www * tmp8.xyz + tmp5.xyz;
                tmp5.xyz = saturate(tmp2.xyz * tmp5.xyz);
                tmp5.xyz = tmp7.xyz * tmp1.www + tmp5.xyz;
                tmp5.xyz = tmp5.xyz - tmp3.xyz;
                tmp2.w = tmp1.x > 0.5;
                tmp3.w = tmp1.x - 0.5;
                tmp1.x = tmp1.x + tmp1.x;
                tmp3.w = -tmp3.w * 2.0 + 1.0;
                tmp6.zw = tmp1.zz * float2(0.33, 0.1) + float2(0.33, 0.45);
                tmp4.w = tmp6.w - tmp6.z;
                tmp5.w = saturate(tmp4.x * 2.0 + -1.0);
                tmp4.w = tmp5.w * tmp4.w + tmp6.z;
                tmp5.w = 1.0 - tmp4.w;
                tmp1.x = tmp1.x * tmp4.w;
                tmp3.w = -tmp3.w * tmp5.w + 1.0;
                tmp1.x = saturate(tmp2.w ? tmp3.w : tmp1.x);
                tmp4.x = saturate(tmp4.x);
                tmp2.w = dot(abs(tmp4.xy), float2(0.333, 0.333));
                tmp2.w = tmp4.x + tmp2.w;
                tmp3.w = tmp2.w * tmp2.w;
                tmp4.xyz = tmp2.www * tmp2.www + glstate_lightmodel_ambient.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp4.xyz = tmp4.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.75, 0.75, 0.75));
                tmp4.xyz = min(tmp4.xyz, float3(1.0, 1.0, 1.0));
                tmp1.y = tmp1.y * tmp3.w;
                tmp1.y = tmp1.z * tmp1.y;
                tmp2.w = tmp1.y + tmp1.y;
                tmp4.xyz = tmp1.yyy * float3(0.75, 0.75, 0.75) + tmp4.xyz;
                tmp4.xyz = tmp4.xyz * _LightColor0.xyz;
                tmp1.y = floor(tmp2.w);
                tmp1.x = tmp1.x * 13.0 + tmp1.y;
                tmp1.x = saturate(tmp1.x - 5.0);
                tmp1.y = tmp1.z + tmp1.x;
                tmp1.y = min(tmp1.y, 1.0);
                tmp3.xyz = tmp1.yyy * tmp5.xyz + tmp3.xyz;
                tmp1.y = tmp1.y * 4.0;
                tmp1.y = min(tmp1.y, 1.0);
                tmp0.z = tmp0.z + tmp1.y;
                tmp0.z = min(tmp0.z, 1.0);
                tmp1.y = tmp6.x * tmp1.z;
                tmp2.w = tmp6.y * -1.333333 + 1.333333;
                tmp2.w = min(tmp2.w, 1.0);
                tmp1.z = tmp1.z * 0.8;
                tmp9.x = tmp1.y * _ColorRamp_ST.x;
                tmp5.xy = tmp9.xy + _ColorRamp_ST.zw;
                tmp5 = tex2D(_ColorRamp, tmp5.xy);
                tmp5.xyz = saturate(tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0));
                tmp6.xyz = tmp5.xyz > float3(0.5, 0.5, 0.5);
                tmp8.xyz = tmp5.xyz * float3(2.0, 2.0, 2.0) + tmp2.www;
                tmp5.xyz = tmp5.xyz - float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp5.xyz * float3(2.0, 2.0, 2.0) + tmp2.www;
                tmp8.xyz = tmp8.xyz - float3(1.0, 1.0, 1.0);
                tmp5.xyz = saturate(tmp6.xyz ? tmp8.xyz : tmp5.xyz);
                tmp3.xyz = -tmp5.xyz * tmp2.www + tmp3.xyz;
                tmp5.xyz = tmp2.www * tmp5.xyz;
                tmp3.xyz = tmp0.zzz * tmp3.xyz + tmp5.xyz;
                tmp0.z = _ProjectionParams.x * -_ProjectionParams.x;
                tmp5.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp5.z = tmp0.z * tmp5.y;
                tmp5.xy = tmp5.xz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp5.xy = tmp0.xy * float2(0.1, 0.1) + tmp5.xy;
                tmp6 = tex2D(RefractionRuinBarrier, tmp5.xy);
                tmp8 = tmp0.wwww * _BlurOffset.xxxx + tmp5.xyxy;
                tmp0 = -tmp0.wwww * _BlurOffset.xxxx + tmp5.xyxy;
                tmp5.zw = tmp8.xy;
                tmp8 = tex2D(RefractionRuinBarrier, tmp8.zw);
                tmp9 = tex2D(RefractionRuinBarrier, tmp5.zy);
                tmp6.xyz = tmp6.xyz + tmp9.xyz;
                tmp9 = tex2D(RefractionRuinBarrier, tmp5.xw);
                tmp10.xz = tmp5.xz;
                tmp6.xyz = tmp6.xyz + tmp9.xyz;
                tmp5.x = tmp0.x;
                tmp5 = tex2D(RefractionRuinBarrier, tmp5.xy);
                tmp5.xyz = tmp5.xyz + tmp6.xyz;
                tmp10.y = tmp0.y;
                tmp0 = tex2D(RefractionRuinBarrier, tmp0.zw);
                tmp0.xyz = tmp0.xyz + tmp8.xyz;
                tmp6 = tex2D(RefractionRuinBarrier, tmp10.xy);
                tmp8 = tex2D(RefractionRuinBarrier, tmp10.zy);
                tmp0.xyz = tmp8.xyz * float3(2.0, 2.0, 2.0) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp5.xyz = tmp5.xyz + tmp6.xyz;
                tmp0.xyz = tmp5.xyz * float3(0.2, 0.2, 0.2) + tmp0.xyz;
                tmp5.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp0.xyz = -tmp0.xyz * float3(0.5, 0.5, 0.5) + float3(1.0, 1.0, 1.0);
                tmp6.xyz = _GlassColor.xyz + _GlassColor.xyz;
                tmp5.xyz = tmp5.xyz * tmp6.xyz;
                tmp6.xyz = _GlassColor.xyz - float3(0.5, 0.5, 0.5);
                tmp6.xyz = -tmp6.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = -tmp6.xyz * tmp0.xyz + float3(1.0, 1.0, 1.0);
                tmp6.xyz = _GlassColor.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = saturate(tmp6.xyz ? tmp0.xyz : tmp5.xyz);
                tmp3.xyz = tmp3.xyz * float3(1.5, 1.5, 1.5) + -tmp0.xyz;
                tmp0.xyz = tmp1.zzz * tmp3.xyz + tmp0.xyz;
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp5.xyz = tmp4.xyz * tmp1.xxx + float3(-0.5, -0.5, -0.5);
                tmp4.xyz = tmp1.xxx * tmp4.xyz;
                tmp0.w = tmp1.w + tmp1.x;
                tmp0.w = min(tmp0.w, 1.0);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = -tmp5.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz * tmp5.xyz;
                tmp2.xyz = saturate(tmp4.xyz ? tmp3.xyz : tmp2.xyz);
                tmp1.xyw = tmp7.xyz * tmp1.www + tmp2.xyz;
                tmp1.xyw = tmp0.www * tmp1.xyw;
                tmp1.xyz = tmp1.zzz * -tmp1.xyw + tmp1.xyw;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 69866
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
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
				float3 texcoord6 : TEXCOORD6;
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
			float _RampOffset;
			float _RampScale;
			float4 _RampUpper;
			float _SeaLevelRampOffset;
			float _SeaLevelRampScale;
			float4 _SeaLevelRampLower;
			float _Gloss;
			float _GlossPower;
			float4 _SpecularColor;
			float _SeaLevelRampObjectPos;
			float _UseMeshUVs;
			float4 _ColorRamp_ST;
			float4 _Normal_ST;
			float4 _DetailNoiseMask_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _LightTexture0;
			sampler2D _Depth;
			sampler2D _DetailNoiseMask;
			sampler2D _ColorRamp;
			sampler2D _PrimaryTex;
			
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
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord5 = tmp1;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord3.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord4.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord6.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                float4 tmp13;
                float4 tmp14;
                tmp0 = inp.texcoord1.xyzx * _Normal_ST + _Normal_ST;
                tmp1 = tex2D(_Normal, tmp0.zw);
                tmp0 = tex2D(_Normal, tmp0.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.z = dot(tmp1.xy, tmp1.xy);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp1.z = sqrt(tmp0.z);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.xy = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp3.x = dot(tmp2.xy, float2(0.0000003, -1.0));
                tmp3.y = dot(tmp2.xy, float2(1.0, 0.0000003));
                tmp2.xy = tmp3.xy + float2(0.5, 0.5);
                tmp2.zw = tmp2.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp3 = tex2D(_Normal, tmp2.zw);
                tmp3.x = tmp3.w * tmp3.x;
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp3.xy, tmp3.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp3.z = sqrt(tmp0.w);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.z = sqrt(tmp0.w);
                tmp3.xyz = tmp3.xyz - tmp0.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp5.xyz = abs(tmp4.xyz) * abs(tmp4.xyz);
                tmp3.xyz = tmp5.xxx * tmp3.xyz + tmp0.xyz;
                tmp1.xyz = tmp1.xyz - tmp3.xyz;
                tmp1.xyz = tmp5.yyy * tmp1.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp0.xyz = tmp5.zzz * tmp0.xyz + tmp1.xyz;
                tmp1.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.z = sqrt(tmp0.w);
                tmp0.w = _UseMeshUVs <= 0.0;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp3.xyz = tmp0.xyz * tmp0.www;
                tmp1.w = _UseMeshUVs >= 0.0;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp1.xyz = tmp1.www * tmp1.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp2.z = tmp0.w * tmp1.w;
                tmp0.xyz = tmp2.zzz * tmp0.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.yyy * inp.texcoord4.xyz;
                tmp1.xyz = tmp0.xxx * inp.texcoord3.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.zzz * tmp4.xyz + tmp1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                tmp1.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp1.xyz, tmp1.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp1.xyz = tmp1.xyz * tmp2.www;
                tmp2.w = dot(tmp1.xyz, tmp0.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp3.x = tmp2.w - 0.5;
                tmp3.x = -tmp3.x * 2.0 + 1.0;
                tmp3.yz = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp6 = tex2D(_Depth, tmp3.yz);
                tmp7 = inp.texcoord1.zxxy * _Depth_ST + _Depth_ST;
                tmp8 = tex2D(_Depth, tmp7.zw);
                tmp7 = tex2D(_Depth, tmp7.xy);
                tmp3.y = tmp5.y * tmp7.x;
                tmp3.zw = tmp2.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp7 = tex2D(_Depth, tmp3.zw);
                tmp3.y = tmp5.x * tmp7.x + tmp3.y;
                tmp3.y = tmp5.z * tmp8.x + tmp3.y;
                tmp3.z = tmp0.w * tmp3.y;
                tmp3.z = tmp1.w * tmp6.x + tmp3.z;
                tmp3.y = tmp3.y - tmp3.z;
                tmp3.y = tmp2.z * tmp3.y + tmp3.z;
                tmp3.zw = tmp3.yy * float2(-2.994012, 0.25) + float2(1.997006, 0.25);
                tmp3.z = saturate(tmp3.z);
                tmp3.w = tmp3.w * tmp3.w;
                tmp4.w = 1.0 - tmp3.z;
                tmp6.xy = tmp2.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp2.xy = tmp2.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp7 = tex2D(_PrimaryTex, tmp2.xy);
                tmp6 = tex2D(_DetailNoiseMask, tmp6.xy);
                tmp8 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp9 = tex2D(_DetailNoiseMask, tmp8.xy);
                tmp8 = tex2D(_DetailNoiseMask, tmp8.zw);
                tmp2.x = tmp5.y * tmp9.x;
                tmp2.x = tmp5.x * tmp6.x + tmp2.x;
                tmp2.x = tmp5.z * tmp8.x + tmp2.x;
                tmp2.y = tmp2.x - 0.5;
                tmp2.y = -tmp2.y * 2.0 + 1.0;
                tmp2.y = -tmp2.y * tmp4.w + 1.0;
                tmp4.w = tmp2.x + tmp2.x;
                tmp2.x = tmp2.x > 0.5;
                tmp3.z = tmp3.z * tmp4.w;
                tmp2.x = saturate(tmp2.x ? tmp2.y : tmp3.z);
                tmp6.xy = tmp2.xx * float2(0.33, 0.1) + float2(0.33, 0.45);
                tmp2.y = tmp6.y - tmp6.x;
                tmp3.z = saturate(tmp4.y * 2.0 + -1.0);
                tmp2.y = tmp3.z * tmp2.y + tmp6.x;
                tmp3.z = 1.0 - tmp2.y;
                tmp3.x = -tmp3.x * tmp3.z + 1.0;
                tmp3.z = tmp2.w + tmp2.w;
                tmp2.w = tmp2.w > 0.5;
                tmp2.y = tmp2.y * tmp3.z;
                tmp2.y = saturate(tmp2.w ? tmp3.x : tmp2.y);
                tmp2.w = saturate(tmp4.y);
                tmp3.x = dot(abs(tmp4.xy), float2(0.333, 0.333));
                tmp2.w = tmp2.w + tmp3.x;
                tmp3.x = tmp2.w * tmp2.w;
                tmp6.xyz = tmp2.www * tmp2.www + glstate_lightmodel_ambient.xyz;
                tmp6.xyz = tmp6.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp6.xyz = tmp6.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp6.xyz = max(tmp6.xyz, float3(0.75, 0.75, 0.75));
                tmp6.xyz = min(tmp6.xyz, float3(1.0, 1.0, 1.0));
                tmp8.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp2.w = dot(tmp8.xyz, tmp8.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp8.xyz = tmp2.www * tmp8.xyz;
                tmp2.w = dot(tmp0.xyz, tmp8.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp3.z = tmp2.w * tmp2.w;
                tmp4.w = tmp2.w * tmp3.z;
                tmp2.w = log(tmp2.w);
                tmp2.w = tmp2.w * tmp3.y;
                tmp2.w = exp(tmp2.w);
                tmp2.w = 1.0 - tmp2.w;
                tmp2.w = log(tmp2.w);
                tmp3.x = tmp3.x * tmp4.w;
                tmp3.x = tmp2.x * tmp3.x;
                tmp4.w = tmp3.x + tmp3.x;
                tmp6.xyz = tmp3.xxx * float3(0.75, 0.75, 0.75) + tmp6.xyz;
                tmp3.x = floor(tmp4.w);
                tmp2.y = tmp2.y * 13.0 + tmp3.x;
                tmp2.y = saturate(tmp2.y - 5.0);
                tmp3.x = dot(inp.texcoord6.xyz, inp.texcoord6.xyz);
                tmp9 = tex2D(_LightTexture0, tmp3.xx);
                tmp9.xyz = tmp9.xxx * _LightColor0.xyz;
                tmp6.xyz = tmp6.xyz * tmp9.xyz;
                tmp10.xyz = tmp6.xyz * tmp2.yyy + float3(-0.5, -0.5, -0.5);
                tmp6.xyz = tmp2.yyy * tmp6.xyz;
                tmp10.xyz = -tmp10.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp11 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp12 = tex2D(_PrimaryTex, tmp11.xy);
                tmp11 = tex2D(_PrimaryTex, tmp11.zw);
                tmp12.xyz = tmp5.yyy * tmp12.xyz;
                tmp5.xyw = tmp5.xxx * tmp7.xyz + tmp12.xyz;
                tmp5.xyz = tmp5.zzz * tmp11.xyz + tmp5.xyw;
                tmp7.xyz = tmp0.www * tmp5.xyz;
                tmp11.xy = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp11 = tex2D(_PrimaryTex, tmp11.xy);
                tmp7.xyz = tmp1.www * tmp11.xyz + tmp7.xyz;
                tmp5.xyz = tmp5.xyz - tmp7.xyz;
                tmp5.xyz = tmp2.zzz * tmp5.xyz + tmp7.xyz;
                tmp0.w = dot(tmp4.xyz, tmp8.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * tmp3.y;
                tmp3.y = saturate(tmp3.y);
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * 1.333333;
                tmp0.w = min(tmp0.w, 1.0);
                tmp1.w = _TimeEditor.y + _Time.y;
                tmp1.w = tmp1.w * 0.25;
                tmp1.w = sin(tmp1.w);
                tmp1.w = tmp1.w + tmp1.w;
                tmp3.x = tmp3.y * tmp0.w + tmp1.w;
                tmp3.y = 0.0;
                tmp3.xy = tmp3.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp4 = tex2D(_ColorRamp, tmp3.xy);
                tmp5.xyz = tmp5.xyz - tmp4.xyz;
                tmp4.xyz = tmp2.xxx * tmp5.xyz + tmp4.xyz;
                tmp5.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz - float3(0.5, 0.5, 0.5);
                tmp4.xyz = -tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.w = -_SeaLevelRampObjectPos * unity_ObjectToWorld._m13 + inp.texcoord1.y;
                tmp0.w = tmp0.w - _SeaLevelRampOffset;
                tmp0.w = tmp0.w * _SeaLevelRampScale;
                tmp0.w = saturate(tmp0.w * 0.2 + 0.5);
                tmp11.xyz = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp11.xyz = tmp0.www * tmp11.xyz + _SeaLevelRampLower.xyz;
                tmp12.xyz = float3(1.0, 1.0, 1.0) - tmp11.xyz;
                tmp0.w = inp.texcoord1.y - _WorldSpaceCameraPos.y;
                tmp0.w = tmp0.w * _RampScale;
                tmp0.w = tmp0.w * 0.1 + -_RampOffset;
                tmp0.w = saturate(tmp0.w * 0.5 + 0.5);
                tmp13.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp14.xyz = tmp0.www * tmp13.xyz;
                tmp13.xyz = tmp0.www * tmp13.xyz + float3(0.5, 0.5, 0.5);
                tmp14.xyz = -tmp14.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp12.xyz = -tmp14.xyz * tmp12.xyz + float3(1.0, 1.0, 1.0);
                tmp14.xyz = tmp13.xyz + tmp13.xyz;
                tmp13.xyz = tmp13.xyz > float3(0.5, 0.5, 0.5);
                tmp11.xyz = tmp11.xyz * tmp14.xyz;
                tmp11.xyz = saturate(tmp13.xyz ? tmp12.xyz : tmp11.xyz);
                tmp7.xyz = tmp7.xyz * tmp11.xyz;
                tmp11.xyz = float3(1.0, 1.0, 1.0) - tmp11.xyz;
                tmp4.xyz = -tmp4.xyz * tmp11.xyz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = saturate(tmp5.xyz ? tmp4.xyz : tmp7.xyz);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp5.xyz = -tmp10.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp6.xyz + tmp6.xyz;
                tmp6.xyz = tmp6.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz * tmp7.xyz;
                tmp4.xyz = saturate(tmp6.xyz ? tmp5.xyz : tmp4.xyz);
                tmp0.w = dot(-tmp8.xyz, tmp0.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp0.xyz = tmp0.xyz * -tmp0.www + -tmp8.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.y = _GlossPower * 16.0 + -1.0;
                tmp0.y = exp(tmp0.y);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = tmp2.w * tmp0.y;
                tmp0.y = exp(tmp0.y);
                tmp0.x = exp(tmp0.x);
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = tmp0.x * _Gloss;
                tmp0.xyz = tmp0.xxx * tmp9.xyz;
                tmp0.xyz = tmp0.xyz * _Gloss.xxx;
                tmp0.xyz = tmp0.xyz * float3(148.368, 148.368, 148.368) + float3(-0.9792286, -0.9792286, -0.9792286);
                tmp0.xyz = saturate(tmp3.www * tmp0.xyz + tmp3.zzz);
                tmp0.xyz = saturate(tmp0.xyz * _SpecularColor.xyz);
                tmp0.w = 1.0 - tmp2.x;
                tmp1.x = tmp2.x * 0.8;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp4.xyz;
                tmp0.w = tmp0.w + tmp2.y;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.xyz = tmp0.xyz * tmp0.www;
                o.sv_target.xyz = tmp1.xxx * -tmp0.xyz + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/Paintlight/Triplanar Ruin Barrier Low"
	CustomEditor "ShaderForgeMaterialInspector"
}