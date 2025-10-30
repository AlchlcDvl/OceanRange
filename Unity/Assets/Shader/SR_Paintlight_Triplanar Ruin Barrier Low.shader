Shader "SR/Paintlight/Triplanar Ruin Barrier Low" {
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
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 50933
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _Depth;
			sampler2D _DetailNoiseMask;
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
                tmp0.x = _ProjectionParams.x * -_ProjectionParams.x;
                tmp1.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp1.z = tmp0.x * tmp1.y;
                tmp0.xy = tmp1.xz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * _ScreenParams.xy;
                tmp0.xy = floor(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(0.25, 0.25);
                tmp0.zw = tmp0.xy >= -tmp0.xy;
                tmp0.xy = frac(abs(tmp0.xy));
                tmp0.xy = tmp0.zw ? tmp0.xy : -tmp0.xy;
                tmp0.xy = tmp0.xy * float2(4.0, 4.0);
                tmp0.xy = trunc(tmp0.xy);
                tmp1 = float4(0.0, 1.0, 2.0, 3.0) - tmp0.xxxx;
                tmp0 = float4(0.0, 1.0, 2.0, 3.0) - tmp0.yyyy;
                tmp0 = min(abs(tmp0), float4(1.0, 1.0, 1.0, 1.0));
                tmp0 = float4(1.0, 1.0, 1.0, 1.0) - tmp0;
                tmp1 = min(abs(tmp1), float4(1.0, 1.0, 1.0, 1.0));
                tmp1 = float4(1.0, 1.0, 1.0, 1.0) - tmp1;
                tmp2.x = dot(float4(0.0588235, 0.5294118, 0.1764706, 0.6470588), tmp0);
                tmp2.y = dot(float4(0.7647059, 0.2941177, 0.8823529, 0.4117647), tmp0);
                tmp2.z = dot(float4(0.2352941, 0.7058824, 0.1176471, 0.5882353), tmp0);
                tmp2.w = dot(float4(0.9411765, 0.4705882, 0.8235294, 0.3529412), tmp0);
                tmp0.x = dot(tmp2, tmp1);
                tmp0.yz = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp1 = tex2D(_Depth, tmp0.yz);
                tmp2 = inp.texcoord1.zxxy * _Depth_ST + _Depth_ST;
                tmp3 = tex2D(_Depth, tmp2.zw);
                tmp2 = tex2D(_Depth, tmp2.xy);
                tmp0.yz = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp4.x = dot(tmp0.xy, float2(0.0000003, -1.0));
                tmp4.y = dot(tmp0.xy, float2(1.0, 0.0000003));
                tmp0.yz = tmp4.xy + float2(0.5, 0.5);
                tmp1.yz = tmp0.yz * _Depth_ST.xy + _Depth_ST.zw;
                tmp4 = tex2D(_Depth, tmp1.yz);
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.yzw = tmp0.www * inp.texcoord2.yxz;
                tmp2.yzw = abs(tmp1.zyw) * abs(tmp1.zyw);
                tmp0.w = tmp2.x * tmp2.z;
                tmp0.w = tmp2.y * tmp4.x + tmp0.w;
                tmp0.w = tmp2.w * tmp3.x + tmp0.w;
                tmp2.x = _UseMeshUVs <= 0.0;
                tmp2.x = tmp2.x ? 1.0 : 0.0;
                tmp3.x = tmp0.w * tmp2.x;
                tmp3.y = _UseMeshUVs >= 0.0;
                tmp3.y = tmp3.y ? 1.0 : 0.0;
                tmp1.x = tmp3.y * tmp1.x + tmp3.x;
                tmp0.w = tmp0.w - tmp1.x;
                tmp3.x = tmp2.x * tmp3.y;
                tmp0.w = tmp3.x * tmp0.w + tmp1.x;
                tmp3.zw = tmp0.ww * float2(-2.994012, 0.25) + float2(1.997006, 0.25);
                tmp3.z = saturate(tmp3.z);
                tmp1.x = tmp3.w * tmp3.w;
                tmp3.w = 1.0 - tmp3.z;
                tmp4 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp5 = tex2D(_DetailNoiseMask, tmp4.zw);
                tmp4 = tex2D(_DetailNoiseMask, tmp4.xy);
                tmp4.x = tmp2.z * tmp4.x;
                tmp4.yz = tmp0.yz * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp6 = tex2D(_DetailNoiseMask, tmp4.yz);
                tmp4.x = tmp2.y * tmp6.x + tmp4.x;
                tmp4.x = tmp2.w * tmp5.x + tmp4.x;
                tmp4.y = tmp4.x - 0.5;
                tmp4.y = -tmp4.y * 2.0 + 1.0;
                tmp3.w = -tmp4.y * tmp3.w + 1.0;
                tmp4.y = tmp4.x + tmp4.x;
                tmp4.x = tmp4.x > 0.5;
                tmp3.z = tmp3.z * tmp4.y;
                tmp3.z = saturate(tmp4.x ? tmp3.w : tmp3.z);
                tmp4.xyz = tmp3.zzz * float3(0.8, 0.33, 0.1) + float3(-1.3, 0.33, 0.45);
                tmp0.x = tmp0.x + tmp4.x;
                tmp0.x = round(tmp0.x);
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp5 = inp.texcoord1.xyzx * _Normal_ST + _Normal_ST;
                tmp6 = tex2D(_Normal, tmp5.zw);
                tmp5 = tex2D(_Normal, tmp5.xy);
                tmp6.x = tmp6.w * tmp6.x;
                tmp6.xy = tmp6.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.x = dot(tmp6.xy, tmp6.xy);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp6.z = sqrt(tmp0.x);
                tmp4.xw = tmp0.yz * _Normal_ST.xy + _Normal_ST.zw;
                tmp0.xy = tmp0.yz * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp7 = tex2D(_PrimaryTex, tmp0.xy);
                tmp8 = tex2D(_Normal, tmp4.xw);
                tmp8.x = tmp8.w * tmp8.x;
                tmp0.xy = tmp8.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.w = dot(tmp0.xy, tmp0.xy);
                tmp3.w = min(tmp3.w, 1.0);
                tmp3.w = 1.0 - tmp3.w;
                tmp0.z = sqrt(tmp3.w);
                tmp5.x = tmp5.w * tmp5.x;
                tmp5.xy = tmp5.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.w = dot(tmp5.xy, tmp5.xy);
                tmp3.w = min(tmp3.w, 1.0);
                tmp3.w = 1.0 - tmp3.w;
                tmp5.z = sqrt(tmp3.w);
                tmp0.xyz = tmp0.xyz - tmp5.xyz;
                tmp0.xyz = tmp2.yyy * tmp0.xyz + tmp5.xyz;
                tmp6.xyz = tmp6.xyz - tmp0.xyz;
                tmp0.xyz = tmp2.zzz * tmp6.xyz + tmp0.xyz;
                tmp5.xyz = tmp5.xyz - tmp0.xyz;
                tmp0.xyz = tmp2.www * tmp5.xyz + tmp0.xyz;
                tmp5.xyz = tmp0.xyz * tmp2.xxx;
                tmp4.xw = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp6 = tex2D(_Normal, tmp4.xw);
                tmp6.x = tmp6.w * tmp6.x;
                tmp6.xy = tmp6.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.w = dot(tmp6.xy, tmp6.xy);
                tmp3.w = min(tmp3.w, 1.0);
                tmp3.w = 1.0 - tmp3.w;
                tmp6.z = sqrt(tmp3.w);
                tmp5.xyz = tmp3.yyy * tmp6.xyz + tmp5.xyz;
                tmp0.xyz = tmp0.xyz - tmp5.xyz;
                tmp0.xyz = tmp3.xxx * tmp0.xyz + tmp5.xyz;
                tmp5.xyz = tmp0.yyy * inp.texcoord4.xyz;
                tmp5.xyz = tmp0.xxx * inp.texcoord3.xyz + tmp5.xyz;
                tmp0.xyz = tmp0.zzz * tmp1.zyw + tmp5.xyz;
                tmp3.w = dot(tmp0.xyz, tmp0.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp0.xyz = tmp0.xyz * tmp3.www;
                tmp5.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp3.w = dot(tmp5.xyz, tmp5.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp5.xyz = tmp3.www * tmp5.xyz;
                tmp3.w = dot(-tmp5.xyz, tmp0.xyz);
                tmp3.w = tmp3.w + tmp3.w;
                tmp6.xyz = tmp0.xyz * -tmp3.www + -tmp5.xyz;
                tmp3.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp8.xyz = tmp3.www * _WorldSpaceLightPos0.xyz;
                tmp3.w = dot(tmp8.xyz, tmp6.xyz);
                tmp4.x = dot(tmp8.xyz, tmp0.xyz);
                tmp0.x = dot(tmp0.xyz, tmp5.xyz);
                tmp0.y = dot(tmp1.xyz, tmp5.xyz);
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.xy = float2(1.0, 1.0) - tmp0.xy;
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * tmp0.w;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp0.y * 1.333333;
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.z = max(tmp4.x, 0.0);
                tmp3.w = max(tmp3.w, 0.0);
                tmp3.w = log(tmp3.w);
                tmp4.x = _GlossPower * 16.0 + -1.0;
                tmp4.x = exp(tmp4.x);
                tmp3.w = tmp3.w * tmp4.x;
                tmp3.w = exp(tmp3.w);
                tmp4.w = log(tmp0.x);
                tmp5.x = tmp0.w * tmp4.w;
                tmp5.yz = tmp4.ww * float2(1.25, 0.2);
                tmp5.yz = exp(tmp5.yz);
                tmp0.w = saturate(tmp0.w);
                tmp4.w = exp(tmp5.x);
                tmp4.w = 1.0 - tmp4.w;
                tmp4.w = log(tmp4.w);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.x = exp(tmp4.x);
                tmp3.w = tmp3.w + tmp4.x;
                tmp3.w = tmp3.w * _Gloss;
                tmp6.xyz = tmp3.www * _LightColor0.xyz;
                tmp6.xyz = tmp6.xyz * _Gloss.xxx;
                tmp6.xyz = tmp6.xyz * float3(148.368, 148.368, 148.368) + float3(-0.9792286, -0.9792286, -0.9792286);
                tmp3.w = tmp0.x * tmp0.x;
                tmp6.xyz = saturate(tmp1.xxx * tmp6.xyz + tmp3.www);
                tmp1.x = tmp0.x * tmp3.w;
                tmp0.x = rsqrt(tmp0.x);
                tmp0.x = 1.0 / tmp0.x;
                tmp6.xyz = saturate(tmp6.xyz * _SpecularColor.xyz);
                tmp8 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp9 = tex2D(_PrimaryTex, tmp8.xy);
                tmp8 = tex2D(_PrimaryTex, tmp8.zw);
                tmp9.xyz = tmp2.zzz * tmp9.xyz;
                tmp7.xyz = tmp2.yyy * tmp7.xyz + tmp9.xyz;
                tmp2.yzw = tmp2.www * tmp8.xyz + tmp7.xyz;
                tmp7.xyz = tmp2.yzw * tmp2.xxx;
                tmp4.xw = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp8 = tex2D(_PrimaryTex, tmp4.xw);
                tmp7.xyz = tmp3.yyy * tmp8.xyz + tmp7.xyz;
                tmp2.xyz = tmp2.yzw - tmp7.xyz;
                tmp2.xyz = tmp3.xxx * tmp2.xyz + tmp7.xyz;
                tmp2.w = _TimeEditor.y + _Time.y;
                tmp2.w = tmp2.w * 0.25;
                tmp2.w = sin(tmp2.w);
                tmp2.w = tmp2.w + tmp2.w;
                tmp7.z = tmp0.w * tmp0.y + tmp2.w;
                tmp7.yw = float2(0.0, 0.0);
                tmp0.yw = tmp7.zw * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp8 = tex2D(_ColorRamp, tmp0.yw);
                tmp2.xyz = tmp2.xyz - tmp8.xyz;
                tmp2.xyz = tmp3.zzz * tmp2.xyz + tmp8.xyz;
                tmp3.xyw = saturate(tmp6.xyz + tmp8.xyz);
                tmp8.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp0.y = -_SeaLevelRampObjectPos * unity_ObjectToWorld._m13 + inp.texcoord1.y;
                tmp0.y = tmp0.y - _SeaLevelRampOffset;
                tmp0.y = tmp0.y * _SeaLevelRampScale;
                tmp0.y = saturate(tmp0.y * 0.2 + 0.5);
                tmp9.xyz = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp9.xyz = tmp0.yyy * tmp9.xyz + _SeaLevelRampLower.xyz;
                tmp10.xyz = float3(1.0, 1.0, 1.0) - tmp9.xyz;
                tmp0.y = inp.texcoord1.y - _WorldSpaceCameraPos.y;
                tmp0.y = tmp0.y * _RampScale;
                tmp0.y = tmp0.y * 0.1 + -_RampOffset;
                tmp0.y = saturate(tmp0.y * 0.5 + 0.5);
                tmp11.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp12.xyz = tmp0.yyy * tmp11.xyz;
                tmp11.xyz = tmp0.yyy * tmp11.xyz + float3(0.5, 0.5, 0.5);
                tmp12.xyz = -tmp12.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp10.xyz = -tmp12.xyz * tmp10.xyz + float3(1.0, 1.0, 1.0);
                tmp12.xyz = tmp11.xyz + tmp11.xyz;
                tmp11.xyz = tmp11.xyz > float3(0.5, 0.5, 0.5);
                tmp9.xyz = tmp9.xyz * tmp12.xyz;
                tmp9.xyz = saturate(tmp11.xyz ? tmp10.xyz : tmp9.xyz);
                tmp10.xyz = float3(1.0, 1.0, 1.0) - tmp9.xyz;
                tmp11.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = tmp9.xyz * tmp2.xyz;
                tmp9.xyz = -tmp11.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp9.xyz = -tmp9.xyz * tmp10.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = saturate(tmp8.xyz ? tmp9.xyz : tmp2.xyz);
                tmp0.y = 1.0 - tmp3.z;
                tmp8.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp9.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + float3(0.5, 0.5, 0.5);
                tmp8.xyz = tmp0.yyy * tmp9.xyz + tmp8.xyz;
                tmp8.xyz = saturate(tmp2.xyz * tmp8.xyz);
                tmp8.xyz = tmp6.xyz * tmp0.yyy + tmp8.xyz;
                tmp8.xyz = tmp8.xyz - tmp3.xyw;
                tmp0.w = tmp0.z - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp2.w = tmp4.z - tmp4.y;
                tmp4.x = saturate(tmp1.y * 2.0 + -1.0);
                tmp2.w = tmp4.x * tmp2.w + tmp4.y;
                tmp4.x = 1.0 - tmp2.w;
                tmp0.w = -tmp0.w * tmp4.x + 1.0;
                tmp4.x = tmp0.z + tmp0.z;
                tmp0.z = tmp0.z > 0.5;
                tmp2.w = tmp2.w * tmp4.x;
                tmp0.z = saturate(tmp0.z ? tmp0.w : tmp2.w);
                tmp1.y = saturate(tmp1.y);
                tmp0.w = dot(abs(tmp1.xy), float2(0.333, 0.333));
                tmp0.w = tmp1.y + tmp0.w;
                tmp1.y = tmp0.w * tmp0.w;
                tmp4.xyz = tmp0.www * tmp0.www + glstate_lightmodel_ambient.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp4.xyz = tmp4.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.75, 0.75, 0.75));
                tmp4.xyz = min(tmp4.xyz, float3(1.0, 1.0, 1.0));
                tmp0.w = tmp1.x * tmp1.y;
                tmp0.w = tmp3.z * tmp0.w;
                tmp1.x = tmp0.w + tmp0.w;
                tmp1.yzw = tmp0.www * float3(0.75, 0.75, 0.75) + tmp4.xyz;
                tmp1.yzw = tmp1.yzw * _LightColor0.xyz;
                tmp0.w = floor(tmp1.x);
                tmp0.z = tmp0.z * 13.0 + tmp0.w;
                tmp0.z = saturate(tmp0.z - 5.0);
                tmp0.w = tmp3.z + tmp0.z;
                tmp1.x = tmp3.z * tmp5.y;
                tmp2.w = tmp5.z * -1.333333 + 1.333333;
                tmp2.w = min(tmp2.w, 1.0);
                tmp7.x = tmp1.x * _ColorRamp_ST.x;
                tmp4.xy = tmp7.xy + _ColorRamp_ST.zw;
                tmp4 = tex2D(_ColorRamp, tmp4.xy);
                tmp4.xyz = saturate(tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0));
                tmp0.w = min(tmp0.w, 1.0);
                tmp3.xyz = tmp0.www * tmp8.xyz + tmp3.xyw;
                tmp0.w = tmp0.w * 4.0;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.x = tmp0.x + tmp0.w;
                tmp0.x = min(tmp0.x, 1.0);
                tmp5.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp4.xyz * float3(2.0, 2.0, 2.0) + tmp2.www;
                tmp4.xyz = tmp4.xyz - float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz * float3(2.0, 2.0, 2.0) + tmp2.www;
                tmp7.xyz = tmp7.xyz - float3(1.0, 1.0, 1.0);
                tmp4.xyz = saturate(tmp5.xyz ? tmp7.xyz : tmp4.xyz);
                tmp3.xyz = -tmp4.xyz * tmp2.www + tmp3.xyz;
                tmp4.xyz = tmp2.www * tmp4.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + tmp4.xyz;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp5.xyz = tmp1.yzw * tmp0.zzz + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp0.zzz * tmp1.yzw;
                tmp0.x = tmp0.y + tmp0.z;
                tmp0.x = min(tmp0.x, 1.0);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = -tmp5.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz * tmp5.xyz;
                tmp1.xyz = saturate(tmp1.xyz ? tmp4.xyz : tmp2.xyz);
                tmp0.yzw = tmp6.xyz * tmp0.yyy + tmp1.xyz;
                tmp0.xyz = tmp0.yzw * tmp0.xxx;
                o.sv_target.xyz = tmp3.xyz * float3(1.5, 1.5, 1.5) + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 83363
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
			sampler2D _Depth;
			sampler2D _DetailNoiseMask;
			sampler2D _LightTexture0;
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
                tmp0.x = _ProjectionParams.x * -_ProjectionParams.x;
                tmp1.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp1.z = tmp0.x * tmp1.y;
                tmp0.xy = tmp1.xz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * _ScreenParams.xy;
                tmp0.xy = floor(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(0.25, 0.25);
                tmp0.zw = tmp0.xy >= -tmp0.xy;
                tmp0.xy = frac(abs(tmp0.xy));
                tmp0.xy = tmp0.zw ? tmp0.xy : -tmp0.xy;
                tmp0.xy = tmp0.xy * float2(4.0, 4.0);
                tmp0.xy = trunc(tmp0.xy);
                tmp1 = float4(0.0, 1.0, 2.0, 3.0) - tmp0.xxxx;
                tmp0 = float4(0.0, 1.0, 2.0, 3.0) - tmp0.yyyy;
                tmp0 = min(abs(tmp0), float4(1.0, 1.0, 1.0, 1.0));
                tmp0 = float4(1.0, 1.0, 1.0, 1.0) - tmp0;
                tmp1 = min(abs(tmp1), float4(1.0, 1.0, 1.0, 1.0));
                tmp1 = float4(1.0, 1.0, 1.0, 1.0) - tmp1;
                tmp2.x = dot(float4(0.0588235, 0.5294118, 0.1764706, 0.6470588), tmp0);
                tmp2.y = dot(float4(0.7647059, 0.2941177, 0.8823529, 0.4117647), tmp0);
                tmp2.z = dot(float4(0.2352941, 0.7058824, 0.1176471, 0.5882353), tmp0);
                tmp2.w = dot(float4(0.9411765, 0.4705882, 0.8235294, 0.3529412), tmp0);
                tmp0.x = dot(tmp2, tmp1);
                tmp0.yz = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp1 = tex2D(_Depth, tmp0.yz);
                tmp2 = inp.texcoord1.zxxy * _Depth_ST + _Depth_ST;
                tmp3 = tex2D(_Depth, tmp2.zw);
                tmp2 = tex2D(_Depth, tmp2.xy);
                tmp0.yz = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp4.x = dot(tmp0.xy, float2(0.0000003, -1.0));
                tmp4.y = dot(tmp0.xy, float2(1.0, 0.0000003));
                tmp0.yz = tmp4.xy + float2(0.5, 0.5);
                tmp1.yz = tmp0.yz * _Depth_ST.xy + _Depth_ST.zw;
                tmp4 = tex2D(_Depth, tmp1.yz);
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.yzw = tmp0.www * inp.texcoord2.yxz;
                tmp2.yzw = abs(tmp1.zyw) * abs(tmp1.zyw);
                tmp0.w = tmp2.x * tmp2.z;
                tmp0.w = tmp2.y * tmp4.x + tmp0.w;
                tmp0.w = tmp2.w * tmp3.x + tmp0.w;
                tmp2.x = _UseMeshUVs <= 0.0;
                tmp2.x = tmp2.x ? 1.0 : 0.0;
                tmp3.x = tmp0.w * tmp2.x;
                tmp3.y = _UseMeshUVs >= 0.0;
                tmp3.y = tmp3.y ? 1.0 : 0.0;
                tmp1.x = tmp3.y * tmp1.x + tmp3.x;
                tmp0.w = tmp0.w - tmp1.x;
                tmp3.x = tmp2.x * tmp3.y;
                tmp0.w = tmp3.x * tmp0.w + tmp1.x;
                tmp3.zw = tmp0.ww * float2(-2.994012, 0.25) + float2(1.997006, 0.25);
                tmp3.z = saturate(tmp3.z);
                tmp1.x = tmp3.w * tmp3.w;
                tmp3.w = 1.0 - tmp3.z;
                tmp4 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp5 = tex2D(_DetailNoiseMask, tmp4.zw);
                tmp4 = tex2D(_DetailNoiseMask, tmp4.xy);
                tmp4.x = tmp2.z * tmp4.x;
                tmp4.yz = tmp0.yz * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp6 = tex2D(_DetailNoiseMask, tmp4.yz);
                tmp4.x = tmp2.y * tmp6.x + tmp4.x;
                tmp4.x = tmp2.w * tmp5.x + tmp4.x;
                tmp4.y = tmp4.x - 0.5;
                tmp4.y = -tmp4.y * 2.0 + 1.0;
                tmp3.w = -tmp4.y * tmp3.w + 1.0;
                tmp4.y = tmp4.x + tmp4.x;
                tmp4.x = tmp4.x > 0.5;
                tmp3.z = tmp3.z * tmp4.y;
                tmp3.z = saturate(tmp4.x ? tmp3.w : tmp3.z);
                tmp4.xyz = tmp3.zzz * float3(0.8, 0.33, 0.1) + float3(-1.3, 0.33, 0.45);
                tmp0.x = tmp0.x + tmp4.x;
                tmp0.x = round(tmp0.x);
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = -_SeaLevelRampObjectPos * unity_ObjectToWorld._m13 + inp.texcoord1.y;
                tmp0.x = tmp0.x - _SeaLevelRampOffset;
                tmp0.x = tmp0.x * _SeaLevelRampScale;
                tmp0.x = saturate(tmp0.x * 0.2 + 0.5);
                tmp5.xyz = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp5.xyz = tmp0.xxx * tmp5.xyz + _SeaLevelRampLower.xyz;
                tmp6.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp0.x = inp.texcoord1.y - _WorldSpaceCameraPos.y;
                tmp0.x = tmp0.x * _RampScale;
                tmp0.x = tmp0.x * 0.1 + -_RampOffset;
                tmp0.x = saturate(tmp0.x * 0.5 + 0.5);
                tmp7.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp8.xyz = tmp0.xxx * tmp7.xyz;
                tmp7.xyz = tmp0.xxx * tmp7.xyz + float3(0.5, 0.5, 0.5);
                tmp8.xyz = -tmp8.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp6.xyz = -tmp8.xyz * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp8.xyz = tmp7.xyz + tmp7.xyz;
                tmp7.xyz = tmp7.xyz > float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp5.xyz * tmp8.xyz;
                tmp5.xyz = saturate(tmp7.xyz ? tmp6.xyz : tmp5.xyz);
                tmp6.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp4.xw = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp7 = tex2D(_PrimaryTex, tmp4.xw);
                tmp4.xw = tmp0.yz * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp0.xy = tmp0.yz * _Normal_ST.xy + _Normal_ST.zw;
                tmp8 = tex2D(_Normal, tmp0.xy);
                tmp9 = tex2D(_PrimaryTex, tmp4.xw);
                tmp10 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp11 = tex2D(_PrimaryTex, tmp10.xy);
                tmp10 = tex2D(_PrimaryTex, tmp10.zw);
                tmp0.xyz = tmp2.zzz * tmp11.xyz;
                tmp0.xyz = tmp2.yyy * tmp9.xyz + tmp0.xyz;
                tmp0.xyz = tmp2.www * tmp10.xyz + tmp0.xyz;
                tmp9.xyz = tmp0.xyz * tmp2.xxx;
                tmp7.xyz = tmp3.yyy * tmp7.xyz + tmp9.xyz;
                tmp0.xyz = tmp0.xyz - tmp7.xyz;
                tmp0.xyz = tmp3.xxx * tmp0.xyz + tmp7.xyz;
                tmp3.w = _TimeEditor.y + _Time.y;
                tmp3.w = tmp3.w * 0.25;
                tmp3.w = sin(tmp3.w);
                tmp3.w = tmp3.w + tmp3.w;
                tmp7.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp4.x = dot(tmp7.xyz, tmp7.xyz);
                tmp4.x = rsqrt(tmp4.x);
                tmp7.xyz = tmp4.xxx * tmp7.xyz;
                tmp4.x = dot(tmp1.xyz, tmp7.xyz);
                tmp4.x = max(tmp4.x, 0.0);
                tmp4.x = 1.0 - tmp4.x;
                tmp4.x = log(tmp4.x);
                tmp4.x = tmp0.w * tmp4.x;
                tmp4.x = exp(tmp4.x);
                tmp4.x = tmp4.x * 1.333333;
                tmp4.x = min(tmp4.x, 1.0);
                tmp4.w = saturate(tmp0.w);
                tmp9.x = tmp4.w * tmp4.x + tmp3.w;
                tmp9.y = 0.0;
                tmp4.xw = tmp9.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp9 = tex2D(_ColorRamp, tmp4.xw);
                tmp0.xyz = tmp0.xyz - tmp9.xyz;
                tmp0.xyz = tmp3.zzz * tmp0.xyz + tmp9.xyz;
                tmp9.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp9.xyz = -tmp9.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp6.xyz = -tmp9.xyz * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp9.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp5.xyz * tmp9.xyz;
                tmp0.xyz = saturate(tmp0.xyz ? tmp6.xyz : tmp5.xyz);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp8.x = tmp8.w * tmp8.x;
                tmp6.xy = tmp8.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.w = dot(tmp6.xy, tmp6.xy);
                tmp3.w = min(tmp3.w, 1.0);
                tmp3.w = 1.0 - tmp3.w;
                tmp6.z = sqrt(tmp3.w);
                tmp8 = inp.texcoord1.xyzx * _Normal_ST + _Normal_ST;
                tmp9 = tex2D(_Normal, tmp8.xy);
                tmp8 = tex2D(_Normal, tmp8.zw);
                tmp9.x = tmp9.w * tmp9.x;
                tmp9.xy = tmp9.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.w = dot(tmp9.xy, tmp9.xy);
                tmp3.w = min(tmp3.w, 1.0);
                tmp3.w = 1.0 - tmp3.w;
                tmp9.z = sqrt(tmp3.w);
                tmp6.xyz = tmp6.xyz - tmp9.xyz;
                tmp6.xyz = tmp2.yyy * tmp6.xyz + tmp9.xyz;
                tmp8.x = tmp8.w * tmp8.x;
                tmp8.xy = tmp8.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.y = dot(tmp8.xy, tmp8.xy);
                tmp2.y = min(tmp2.y, 1.0);
                tmp2.y = 1.0 - tmp2.y;
                tmp8.z = sqrt(tmp2.y);
                tmp8.xyz = tmp8.xyz - tmp6.xyz;
                tmp6.xyz = tmp2.zzz * tmp8.xyz + tmp6.xyz;
                tmp8.xyz = tmp9.xyz - tmp6.xyz;
                tmp2.yzw = tmp2.www * tmp8.xyz + tmp6.xyz;
                tmp6.xyz = tmp2.yzw * tmp2.xxx;
                tmp4.xw = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp8 = tex2D(_Normal, tmp4.xw);
                tmp8.x = tmp8.w * tmp8.x;
                tmp8.xy = tmp8.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.x = dot(tmp8.xy, tmp8.xy);
                tmp2.x = min(tmp2.x, 1.0);
                tmp2.x = 1.0 - tmp2.x;
                tmp8.z = sqrt(tmp2.x);
                tmp6.xyz = tmp3.yyy * tmp8.xyz + tmp6.xyz;
                tmp2.xyz = tmp2.yzw - tmp6.xyz;
                tmp2.xyz = tmp3.xxx * tmp2.xyz + tmp6.xyz;
                tmp3.xyw = tmp2.yyy * inp.texcoord4.xyz;
                tmp2.xyw = tmp2.xxx * inp.texcoord3.xyz + tmp3.xyw;
                tmp2.xyz = tmp2.zzz * tmp1.zyw + tmp2.xyw;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xyw = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyw = tmp2.www * tmp3.xyw;
                tmp2.w = dot(tmp3.xyz, tmp2.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp4.x = tmp2.w - 0.5;
                tmp4.x = -tmp4.x * 2.0 + 1.0;
                tmp4.z = tmp4.z - tmp4.y;
                tmp4.w = saturate(tmp1.y * 2.0 + -1.0);
                tmp4.y = tmp4.w * tmp4.z + tmp4.y;
                tmp4.z = 1.0 - tmp4.y;
                tmp4.x = -tmp4.x * tmp4.z + 1.0;
                tmp4.z = tmp2.w + tmp2.w;
                tmp2.w = tmp2.w > 0.5;
                tmp4.y = tmp4.y * tmp4.z;
                tmp2.w = saturate(tmp2.w ? tmp4.x : tmp4.y);
                tmp1.y = saturate(tmp1.y);
                tmp1.z = dot(abs(tmp1.xy), float2(0.333, 0.333));
                tmp1.y = tmp1.y + tmp1.z;
                tmp1.z = tmp1.y * tmp1.y;
                tmp4.xyz = tmp1.yyy * tmp1.yyy + glstate_lightmodel_ambient.xyz;
                tmp4.xyz = tmp4.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp4.xyz = tmp4.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.75, 0.75, 0.75));
                tmp4.xyz = min(tmp4.xyz, float3(1.0, 1.0, 1.0));
                tmp1.y = dot(tmp2.xyz, tmp7.xyz);
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.y = 1.0 - tmp1.y;
                tmp1.w = tmp1.y * tmp1.y;
                tmp4.w = tmp1.w * tmp1.y;
                tmp1.y = log(tmp1.y);
                tmp0.w = tmp0.w * tmp1.y;
                tmp0.w = exp(tmp0.w);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = log(tmp0.w);
                tmp1.y = tmp1.z * tmp4.w;
                tmp1.y = tmp3.z * tmp1.y;
                tmp1.z = 1.0 - tmp3.z;
                tmp3.z = tmp1.y + tmp1.y;
                tmp4.xyz = tmp1.yyy * float3(0.75, 0.75, 0.75) + tmp4.xyz;
                tmp1.y = floor(tmp3.z);
                tmp1.y = tmp2.w * 13.0 + tmp1.y;
                tmp1.y = saturate(tmp1.y - 5.0);
                tmp2.w = dot(inp.texcoord6.xyz, inp.texcoord6.xyz);
                tmp6 = tex2D(_LightTexture0, tmp2.ww);
                tmp6.xyz = tmp6.xxx * _LightColor0.xyz;
                tmp4.xyz = tmp4.xyz * tmp6.xyz;
                tmp8.xyz = tmp4.xyz * tmp1.yyy + float3(-0.5, -0.5, -0.5);
                tmp4.xyz = tmp1.yyy * tmp4.xyz;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = min(tmp1.y, 1.0);
                tmp8.xyz = -tmp8.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp8.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp8.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz * tmp8.xyz;
                tmp0.xyz = saturate(tmp4.xyz ? tmp5.xyz : tmp0.xyz);
                tmp2.w = dot(-tmp7.xyz, tmp2.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp2.xyz = tmp2.xyz * -tmp2.www + -tmp7.xyz;
                tmp2.x = dot(tmp3.xyz, tmp2.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.x = log(tmp2.x);
                tmp2.y = _GlossPower * 16.0 + -1.0;
                tmp2.y = exp(tmp2.y);
                tmp2.x = tmp2.x * tmp2.y;
                tmp0.w = tmp0.w * tmp2.y;
                tmp0.w = exp(tmp0.w);
                tmp2.x = exp(tmp2.x);
                tmp0.w = tmp0.w + tmp2.x;
                tmp0.w = tmp0.w * _Gloss;
                tmp2.xyz = tmp0.www * tmp6.xyz;
                tmp2.xyz = tmp2.xyz * _Gloss.xxx;
                tmp2.xyz = tmp2.xyz * float3(148.368, 148.368, 148.368) + float3(-0.9792286, -0.9792286, -0.9792286);
                tmp2.xyz = saturate(tmp1.xxx * tmp2.xyz + tmp1.www);
                tmp2.xyz = saturate(tmp2.xyz * _SpecularColor.xyz);
                tmp0.xyz = tmp2.xyz * tmp1.zzz + tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz * tmp1.yyy;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}