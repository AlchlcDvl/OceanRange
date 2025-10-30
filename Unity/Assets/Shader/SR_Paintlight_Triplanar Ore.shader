Shader "SR/Paintlight/Triplanar Ore" {
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
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 41221
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
			float4 _DetailNoiseMask_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
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
                tmp0.x = 1.0 - inp.color.w;
                tmp0.yz = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp1 = tex2D(_Depth, tmp0.yz);
                tmp0.y = _UseMeshUVs <= 0.0;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp2 = inp.texcoord1.zxxy * _Depth_ST + _Depth_ST;
                tmp3 = tex2D(_Depth, tmp2.zw);
                tmp2 = tex2D(_Depth, tmp2.xy);
                tmp0.zw = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp4.x = dot(tmp0.xy, float2(0.0000003, -1.0));
                tmp4.y = dot(tmp0.xy, float2(1.0, 0.0000003));
                tmp0.zw = tmp4.xy + float2(0.5, 0.5);
                tmp2.yz = tmp0.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp4 = tex2D(_Depth, tmp2.yz);
                tmp1.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.yzw = tmp1.www * inp.texcoord2.yxz;
                tmp3.yzw = abs(tmp2.zyw) * abs(tmp2.zyw);
                tmp1.w = tmp2.x * tmp3.z;
                tmp1.w = tmp3.y * tmp4.x + tmp1.w;
                tmp1.w = tmp3.w * tmp3.x + tmp1.w;
                tmp2.x = tmp0.y * tmp1.w;
                tmp3.x = _UseMeshUVs >= 0.0;
                tmp3.x = tmp3.x ? 1.0 : 0.0;
                tmp1.xyz = tmp3.xxx * tmp1.xyz + tmp2.xxx;
                tmp4.xyz = tmp1.www - tmp1.xyz;
                tmp1.w = tmp0.y * tmp3.x;
                tmp1.xyz = tmp1.www * tmp4.xyz + tmp1.xyz;
                tmp4.xyz = saturate(tmp1.xyz * float3(-2.994012, -2.994012, -2.994012) + float3(1.997006, 1.997006, 1.997006));
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp6 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp7 = tex2D(_DetailNoiseMask, tmp6.zw);
                tmp6 = tex2D(_DetailNoiseMask, tmp6.xy);
                tmp6.xyz = tmp3.zzz * tmp6.xyz;
                tmp8.xy = tmp0.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp0.zw = tmp0.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp9 = tex2D(_PrimaryTex, tmp0.zw);
                tmp8 = tex2D(_DetailNoiseMask, tmp8.xy);
                tmp6.xyz = tmp3.yyy * tmp8.xyz + tmp6.xyz;
                tmp6.xyz = tmp3.www * tmp7.xyz + tmp6.xyz;
                tmp7.xyz = tmp6.xyz - float3(0.5, 0.5, 0.5);
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp7.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp4.xyz * tmp6.xyz;
                tmp6.xyz = tmp6.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = saturate(tmp6.xyz ? tmp5.xyz : tmp4.xyz);
                tmp0.zw = tmp4.xx * float2(0.1, 0.1) + float2(0.45, -0.05);
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.x = -tmp0.w * tmp0.x + 1.0;
                tmp0.w = tmp0.z > 0.5;
                tmp0.z = dot(inp.color.xy, tmp0.xy);
                tmp0.x = saturate(tmp0.w ? tmp0.x : tmp0.z);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = -_SeaLevelRampObjectPos * unity_ObjectToWorld._m13 + inp.texcoord1.y;
                tmp0.x = tmp0.x - _SeaLevelRampOffset;
                tmp0.x = tmp0.x * _SeaLevelRampScale;
                tmp0.x = saturate(tmp0.x * 0.2 + 0.5);
                tmp5.xyz = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp0.xzw = tmp0.xxx * tmp5.xyz + _SeaLevelRampLower.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp0.xzw;
                tmp2.x = inp.texcoord1.y - _WorldSpaceCameraPos.y;
                tmp2.x = tmp2.x * _RampScale;
                tmp2.x = tmp2.x * 0.1 + -_RampOffset;
                tmp2.x = saturate(tmp2.x * 0.5 + 0.5);
                tmp6.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp2.xxx * tmp6.xyz;
                tmp6.xyz = tmp2.xxx * tmp6.xyz + float3(0.5, 0.5, 0.5);
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp7.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xzw = tmp0.xzw * tmp6.xyz;
                tmp6.xyz = tmp6.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xzw = tmp0.xzw + tmp0.xzw;
                tmp0.xzw = saturate(tmp6.xyz ? tmp5.xyz : tmp0.xzw);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp0.xzw;
                tmp6 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp7 = tex2D(_PrimaryTex, tmp6.xy);
                tmp6 = tex2D(_PrimaryTex, tmp6.zw);
                tmp7.xyz = tmp3.zzz * tmp7.xyz;
                tmp7.xyz = tmp3.yyy * tmp9.xyz + tmp7.xyz;
                tmp3.yzw = tmp3.www * tmp6.xyz + tmp7.xyz;
                tmp6.xyz = tmp0.yyy * tmp3.yzw;
                tmp7.xy = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp7 = tex2D(_PrimaryTex, tmp7.xy);
                tmp6.xyz = tmp3.xxx * tmp7.xyz + tmp6.xyz;
                tmp3.xyz = tmp3.yzw - tmp6.xyz;
                tmp3.xyz = tmp1.www * tmp3.xyz + tmp6.xyz;
                tmp0.y = saturate(tmp1.x);
                tmp6.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp6.xyz, tmp6.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp6.xyz = tmp1.www * tmp6.xyz;
                tmp1.w = dot(tmp2.xyz, tmp6.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.x = log(tmp1.w);
                tmp3.w = tmp1.x * tmp2.x;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + float3(0.25, 0.25, 0.25);
                tmp1.xyz = tmp1.xyz * tmp1.xyz;
                tmp7.xy = tmp2.xx * float2(1.25, 0.2);
                tmp7.xy = exp(tmp7.xy);
                tmp2.x = exp(tmp3.w);
                tmp3.w = tmp2.x * 1.333333;
                tmp2.x = 1.0 - tmp2.x;
                tmp2.x = log(tmp2.x);
                tmp3.w = min(tmp3.w, 1.0);
                tmp0.y = tmp0.y * tmp3.w;
                tmp8.x = tmp0.y * _ColorRamp_ST.x;
                tmp8.y = 0.0;
                tmp7.zw = tmp8.xy + _ColorRamp_ST.zw;
                tmp8 = tex2D(_ColorRamp, tmp7.zw);
                tmp3.xyz = tmp3.xyz - tmp8.xyz;
                tmp3.xyz = tmp4.xyz * tmp3.xyz + tmp8.xyz;
                tmp9.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp9.xyz = -tmp9.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp9.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xzw * tmp3.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = saturate(tmp3.xyz ? tmp5.xyz : tmp0.xyz);
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp5.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp9.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp3.xyz * tmp9.xyz + tmp5.xyz;
                tmp5.xyz = saturate(tmp0.xyz * tmp5.xyz);
                tmp0.w = dot(-tmp6.xyz, tmp2.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp6.xyz = tmp2.zyw * -tmp0.www + -tmp6.xyz;
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp9.xyz = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp9.xyz, tmp6.xyz);
                tmp3.w = dot(tmp9.xyz, tmp2.xyz);
                tmp3.w = max(tmp3.w, 0.0);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp4.w = _GlossPower * 16.0 + -1.0;
                tmp4.w = exp(tmp4.w);
                tmp0.w = tmp0.w * tmp4.w;
                tmp2.x = tmp2.x * tmp4.w;
                tmp2.x = exp(tmp2.x);
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp2.x + tmp0.w;
                tmp0.w = tmp0.w * _Gloss;
                tmp6.xyz = tmp0.www * _LightColor0.xyz;
                tmp6.xyz = tmp6.xyz * _Gloss.xxx;
                tmp6.xyz = tmp6.xyz * float3(148.368, 148.368, 148.368) + float3(-0.9792286, -0.9792286, -0.9792286);
                tmp0.w = tmp1.w * tmp1.w;
                tmp1.xyz = saturate(tmp1.xyz * tmp6.xyz + tmp0.www);
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.w = rsqrt(tmp1.w);
                tmp1.w = 1.0 / tmp1.w;
                tmp1.xyz = saturate(tmp1.xyz * _SpecularColor.xyz);
                tmp5.xyz = tmp1.xyz * tmp3.xyz + tmp5.xyz;
                tmp6.xyz = saturate(tmp1.xyz + tmp8.xyz);
                tmp5.xyz = tmp5.xyz - tmp6.xyz;
                tmp8.xyz = tmp4.xyz * float3(0.1, 0.1, 0.1) + float3(0.45, 0.45, 0.45);
                tmp9.xyz = tmp4.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp8.xyz = tmp8.xyz - tmp9.xyz;
                tmp2.x = saturate(tmp2.y * 2.0 + -1.0);
                tmp8.xyz = tmp2.xxx * tmp8.xyz + tmp9.xyz;
                tmp9.xyz = float3(1.0, 1.0, 1.0) - tmp8.xyz;
                tmp2.x = tmp3.w - 0.5;
                tmp2.x = -tmp2.x * 2.0 + 1.0;
                tmp9.xyz = -tmp2.xxx * tmp9.xyz + float3(1.0, 1.0, 1.0);
                tmp2.x = tmp3.w + tmp3.w;
                tmp3.w = tmp3.w > 0.5;
                tmp8.xyz = tmp8.xyz * tmp2.xxx;
                tmp8.xyz = saturate(tmp3.www ? tmp9.xyz : tmp8.xyz);
                tmp2.y = saturate(tmp2.y);
                tmp2.x = dot(abs(tmp2.xy), float2(0.333, 0.333));
                tmp2.x = tmp2.y + tmp2.x;
                tmp2.y = tmp2.x * tmp2.x;
                tmp2.xzw = tmp2.xxx * tmp2.xxx + glstate_lightmodel_ambient.xyz;
                tmp2.xzw = tmp2.xzw * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp2.xzw = tmp2.xzw * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp2.xzw = max(tmp2.xzw, float3(0.75, 0.75, 0.75));
                tmp2.xzw = min(tmp2.xzw, float3(1.0, 1.0, 1.0));
                tmp0.w = tmp0.w * tmp2.y;
                tmp9.xyz = tmp4.xyz * tmp0.www;
                tmp10.xyz = tmp9.xyz + tmp9.xyz;
                tmp2.xyz = tmp9.xyz * float3(0.75, 0.75, 0.75) + tmp2.xzw;
                tmp2.xyz = tmp2.xyz * _LightColor0.xyz;
                tmp9.xyz = floor(tmp10.xyz);
                tmp8.xyz = tmp8.xyz * float3(13.0, 13.0, 13.0) + tmp9.xyz;
                tmp8.xyz = saturate(tmp8.xyz - float3(5.0, 5.0, 5.0));
                tmp9.xyz = tmp4.xyz + tmp8.xyz;
                tmp4.xy = tmp4.xy * tmp7.xx;
                tmp0.w = tmp7.y * -1.333333 + 1.333333;
                tmp0.w = min(tmp0.w, 1.0);
                tmp4.xy = tmp4.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp4 = tex2D(_ColorRamp, tmp4.xy);
                tmp4.xyz = saturate(tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0));
                tmp7.xyz = min(tmp9.xyz, float3(1.0, 1.0, 1.0));
                tmp5.xyz = tmp7.xyz * tmp5.xyz + tmp6.xyz;
                tmp6.xyz = tmp7.xyz * float3(4.0, 4.0, 4.0);
                tmp6.xyz = min(tmp6.xyz, float3(1.0, 1.0, 1.0));
                tmp6.xyz = tmp1.www + tmp6.xyz;
                tmp6.xyz = min(tmp6.xyz, float3(1.0, 1.0, 1.0));
                tmp7.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp9.xyz = tmp4.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                tmp4.xyz = tmp4.xyz - float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz * float3(2.0, 2.0, 2.0) + tmp0.www;
                tmp9.xyz = tmp9.xyz - float3(1.0, 1.0, 1.0);
                tmp4.xyz = saturate(tmp7.xyz ? tmp9.xyz : tmp4.xyz);
                tmp5.xyz = -tmp4.xyz * tmp0.www + tmp5.xyz;
                tmp4.xyz = tmp0.www * tmp4.xyz;
                tmp4.xyz = tmp6.xyz * tmp5.xyz + tmp4.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp6.xyz = tmp2.xyz * tmp8.xyz + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp2.xyz * tmp8.xyz;
                tmp7.xyz = tmp3.xyz + tmp8.xyz;
                tmp7.xyz = min(tmp7.xyz, float3(1.0, 1.0, 1.0));
                tmp6.xyz = -tmp6.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp6.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = saturate(tmp2.xyz ? tmp5.xyz : tmp0.xyz);
                tmp0.xyz = tmp1.xyz * tmp3.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp7.xyz * tmp0.xyz + tmp4.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 105128
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
				float4 color : COLOR0;
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
			float4 _DetailNoiseMask_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
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
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                tmp0.x = 1.0 - inp.color.w;
                tmp0.yz = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp1 = tex2D(_Depth, tmp0.yz);
                tmp0.y = _UseMeshUVs <= 0.0;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp2 = inp.texcoord1.zxxy * _Depth_ST + _Depth_ST;
                tmp3 = tex2D(_Depth, tmp2.zw);
                tmp2 = tex2D(_Depth, tmp2.xy);
                tmp0.zw = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp4.x = dot(tmp0.xy, float2(0.0000003, -1.0));
                tmp4.y = dot(tmp0.xy, float2(1.0, 0.0000003));
                tmp0.zw = tmp4.xy + float2(0.5, 0.5);
                tmp2.yz = tmp0.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp4 = tex2D(_Depth, tmp2.yz);
                tmp1.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.yzw = tmp1.www * inp.texcoord2.xyz;
                tmp3.yzw = abs(tmp2.yzw) * abs(tmp2.yzw);
                tmp1.w = tmp2.x * tmp3.z;
                tmp1.w = tmp3.y * tmp4.x + tmp1.w;
                tmp1.w = tmp3.w * tmp3.x + tmp1.w;
                tmp2.x = tmp0.y * tmp1.w;
                tmp3.x = _UseMeshUVs >= 0.0;
                tmp3.x = tmp3.x ? 1.0 : 0.0;
                tmp1.xyz = tmp3.xxx * tmp1.xyz + tmp2.xxx;
                tmp4.xyz = tmp1.www - tmp1.xyz;
                tmp1.w = tmp0.y * tmp3.x;
                tmp1.xyz = tmp1.www * tmp4.xyz + tmp1.xyz;
                tmp4.xyz = saturate(tmp1.xyz * float3(-2.994012, -2.994012, -2.994012) + float3(1.997006, 1.997006, 1.997006));
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp6 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp7 = tex2D(_DetailNoiseMask, tmp6.zw);
                tmp6 = tex2D(_DetailNoiseMask, tmp6.xy);
                tmp6.xyz = tmp3.zzz * tmp6.xyz;
                tmp8.xy = tmp0.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp0.zw = tmp0.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp9 = tex2D(_PrimaryTex, tmp0.zw);
                tmp8 = tex2D(_DetailNoiseMask, tmp8.xy);
                tmp6.xyz = tmp3.yyy * tmp8.xyz + tmp6.xyz;
                tmp6.xyz = tmp3.www * tmp7.xyz + tmp6.xyz;
                tmp7.xyz = tmp6.xyz - float3(0.5, 0.5, 0.5);
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp7.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp4.xyz * tmp6.xyz;
                tmp6.xyz = tmp6.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = saturate(tmp6.xyz ? tmp5.xyz : tmp4.xyz);
                tmp0.zw = tmp4.xx * float2(0.1, 0.1) + float2(0.45, -0.05);
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.x = -tmp0.w * tmp0.x + 1.0;
                tmp0.w = tmp0.z > 0.5;
                tmp0.z = dot(inp.color.xy, tmp0.xy);
                tmp0.x = saturate(tmp0.w ? tmp0.x : tmp0.z);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = -_SeaLevelRampObjectPos * unity_ObjectToWorld._m13 + inp.texcoord1.y;
                tmp0.x = tmp0.x - _SeaLevelRampOffset;
                tmp0.x = tmp0.x * _SeaLevelRampScale;
                tmp0.x = saturate(tmp0.x * 0.2 + 0.5);
                tmp5.xyz = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp0.xzw = tmp0.xxx * tmp5.xyz + _SeaLevelRampLower.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp0.xzw;
                tmp2.x = inp.texcoord1.y - _WorldSpaceCameraPos.y;
                tmp2.x = tmp2.x * _RampScale;
                tmp2.x = tmp2.x * 0.1 + -_RampOffset;
                tmp2.x = saturate(tmp2.x * 0.5 + 0.5);
                tmp6.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp2.xxx * tmp6.xyz;
                tmp6.xyz = tmp2.xxx * tmp6.xyz + float3(0.5, 0.5, 0.5);
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp7.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xzw = tmp0.xzw * tmp6.xyz;
                tmp6.xyz = tmp6.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xzw = tmp0.xzw + tmp0.xzw;
                tmp0.xzw = saturate(tmp6.xyz ? tmp5.xyz : tmp0.xzw);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp0.xzw;
                tmp6 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp7 = tex2D(_PrimaryTex, tmp6.xy);
                tmp6 = tex2D(_PrimaryTex, tmp6.zw);
                tmp7.xyz = tmp3.zzz * tmp7.xyz;
                tmp7.xyz = tmp3.yyy * tmp9.xyz + tmp7.xyz;
                tmp3.yzw = tmp3.www * tmp6.xyz + tmp7.xyz;
                tmp6.xyz = tmp0.yyy * tmp3.yzw;
                tmp7.xy = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp7 = tex2D(_PrimaryTex, tmp7.xy);
                tmp6.xyz = tmp3.xxx * tmp7.xyz + tmp6.xyz;
                tmp3.xyz = tmp3.yzw - tmp6.xyz;
                tmp3.xyz = tmp1.www * tmp3.xyz + tmp6.xyz;
                tmp6.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.y = dot(tmp6.xyz, tmp6.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp6.xyz = tmp0.yyy * tmp6.xyz;
                tmp0.y = dot(tmp2.xyz, tmp6.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp1.w = log(tmp0.y);
                tmp1.w = tmp1.w * tmp1.x;
                tmp1.w = exp(tmp1.w);
                tmp2.x = tmp1.w * 1.333333;
                tmp1.w = 1.0 - tmp1.w;
                tmp1.w = log(tmp1.w);
                tmp2.x = min(tmp2.x, 1.0);
                tmp3.w = saturate(tmp1.x);
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + float3(0.25, 0.25, 0.25);
                tmp1.xyz = tmp1.xyz * tmp1.xyz;
                tmp2.x = tmp2.x * tmp3.w;
                tmp7.x = tmp2.x * _ColorRamp_ST.x;
                tmp7.y = 0.0;
                tmp7.xy = tmp7.xy + _ColorRamp_ST.zw;
                tmp7 = tex2D(_ColorRamp, tmp7.xy);
                tmp3.xyz = tmp3.xyz - tmp7.xyz;
                tmp3.xyz = tmp4.xyz * tmp3.xyz + tmp7.xyz;
                tmp7.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp7.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xzw = tmp0.xzw * tmp3.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xzw = tmp0.xzw + tmp0.xzw;
                tmp0.xzw = saturate(tmp3.xyz ? tmp5.xyz : tmp0.xzw);
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp0.xzw;
                tmp5.xyz = tmp4.xyz * float3(0.1, 0.1, 0.1) + float3(0.45, 0.45, 0.45);
                tmp7.xyz = tmp4.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp5.xyz = tmp5.xyz - tmp7.xyz;
                tmp2.x = saturate(tmp2.z * 2.0 + -1.0);
                tmp5.xyz = tmp2.xxx * tmp5.xyz + tmp7.xyz;
                tmp7.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp8.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp2.x = dot(tmp8.xyz, tmp8.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp8.xyz = tmp2.xxx * tmp8.xyz;
                tmp2.x = dot(tmp8.xyz, tmp2.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp3.w = tmp2.x - 0.5;
                tmp3.w = -tmp3.w * 2.0 + 1.0;
                tmp7.xyz = -tmp3.www * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp3.w = tmp2.x + tmp2.x;
                tmp2.x = tmp2.x > 0.5;
                tmp5.xyz = tmp5.xyz * tmp3.www;
                tmp5.xyz = saturate(tmp2.xxx ? tmp7.xyz : tmp5.xyz);
                tmp2.x = saturate(tmp2.z);
                tmp3.w = dot(abs(tmp2.xy), float2(0.333, 0.333));
                tmp2.x = tmp2.x + tmp3.w;
                tmp3.w = tmp2.x * tmp2.x;
                tmp7.xyz = tmp2.xxx * tmp2.xxx + glstate_lightmodel_ambient.xyz;
                tmp7.xyz = tmp7.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp7.xyz = tmp7.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp7.xyz = max(tmp7.xyz, float3(0.75, 0.75, 0.75));
                tmp7.xyz = min(tmp7.xyz, float3(1.0, 1.0, 1.0));
                tmp2.x = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp2.x;
                tmp0.y = tmp0.y * tmp3.w;
                tmp9.xyz = tmp4.xyz * tmp0.yyy;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp10.xyz = tmp9.xyz + tmp9.xyz;
                tmp7.xyz = tmp9.xyz * float3(0.75, 0.75, 0.75) + tmp7.xyz;
                tmp9.xyz = floor(tmp10.xyz);
                tmp5.xyz = tmp5.xyz * float3(13.0, 13.0, 13.0) + tmp9.xyz;
                tmp5.xyz = saturate(tmp5.xyz - float3(5.0, 5.0, 5.0));
                tmp0.y = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp9 = tex2D(_LightTexture0, tmp0.yy);
                tmp9.xyz = tmp9.xxx * _LightColor0.xyz;
                tmp7.xyz = tmp7.xyz * tmp9.xyz;
                tmp10.xyz = tmp7.xyz * tmp5.xyz + float3(-0.5, -0.5, -0.5);
                tmp7.xyz = tmp5.xyz * tmp7.xyz;
                tmp5.xyz = tmp4.xyz + tmp5.xyz;
                tmp5.xyz = min(tmp5.xyz, float3(1.0, 1.0, 1.0));
                tmp10.xyz = -tmp10.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = -tmp10.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xzw * tmp7.xyz;
                tmp7.xyz = tmp7.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = saturate(tmp7.xyz ? tmp3.xyz : tmp0.xyz);
                tmp0.w = dot(-tmp6.xyz, tmp2.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp2.yzw = tmp2.yzw * -tmp0.www + -tmp6.xyz;
                tmp0.w = dot(tmp8.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp2.y = _GlossPower * 16.0 + -1.0;
                tmp2.y = exp(tmp2.y);
                tmp0.w = tmp0.w * tmp2.y;
                tmp1.w = tmp1.w * tmp2.y;
                tmp1.w = exp(tmp1.w);
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp1.w + tmp0.w;
                tmp0.w = tmp0.w * _Gloss;
                tmp2.yzw = tmp0.www * tmp9.xyz;
                tmp2.yzw = tmp2.yzw * _Gloss.xxx;
                tmp2.yzw = tmp2.yzw * float3(148.368, 148.368, 148.368) + float3(-0.9792286, -0.9792286, -0.9792286);
                tmp1.xyz = saturate(tmp1.xyz * tmp2.yzw + tmp2.xxx);
                tmp1.xyz = saturate(tmp1.xyz * _SpecularColor.xyz);
                tmp0.xyz = tmp1.xyz * tmp4.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp0.xyz * tmp5.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 195047
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Depth_ST;
			float _UseMeshUVs;
			float4 _DetailNoiseMask_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Depth;
			sampler2D _DetailNoiseMask;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord1.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.xy = inp.texcoord2.yz - float2(0.5, 0.5);
                tmp1.x = dot(tmp0.xy, float2(0.0000003, -1.0));
                tmp1.y = dot(tmp0.xy, float2(1.0, 0.0000003));
                tmp0.xy = tmp1.xy + float2(0.5, 0.5);
                tmp0.zw = tmp0.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp0.xy = tmp0.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp1 = tex2D(_DetailNoiseMask, tmp0.xy);
                tmp0 = tex2D(_Depth, tmp0.zw);
                tmp2 = inp.texcoord2.zxxy * _Depth_ST + _Depth_ST;
                tmp3 = tex2D(_Depth, tmp2.xy);
                tmp2 = tex2D(_Depth, tmp2.zw);
                tmp0.y = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * inp.texcoord3.xyz;
                tmp0.yzw = abs(tmp0.yzw) * abs(tmp0.yzw);
                tmp1.y = tmp3.x * tmp0.z;
                tmp0.x = tmp0.y * tmp0.x + tmp1.y;
                tmp0.x = tmp0.w * tmp2.x + tmp0.x;
                tmp1.y = _UseMeshUVs <= 0.0;
                tmp1.y = tmp1.y ? 1.0 : 0.0;
                tmp1.z = tmp0.x * tmp1.y;
                tmp2.xy = inp.texcoord1.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp2 = tex2D(_Depth, tmp2.xy);
                tmp1.w = _UseMeshUVs >= 0.0;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp1.z = tmp1.w * tmp2.x + tmp1.z;
                tmp1.y = tmp1.y * tmp1.w;
                tmp0.x = tmp0.x - tmp1.z;
                tmp0.x = tmp1.y * tmp0.x + tmp1.z;
                tmp0.x = saturate(tmp0.x * -2.994012 + 1.997006);
                tmp1.y = 1.0 - tmp0.x;
                tmp2 = inp.texcoord2.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp3 = tex2D(_DetailNoiseMask, tmp2.xy);
                tmp2 = tex2D(_DetailNoiseMask, tmp2.zw);
                tmp0.z = tmp0.z * tmp3.x;
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = tmp0.w * tmp2.x + tmp0.y;
                tmp0.z = tmp0.y - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.z = -tmp0.z * tmp1.y + 1.0;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = saturate(tmp0.y ? tmp0.z : tmp0.x);
                tmp0.xy = tmp0.xx * float2(0.1, 0.1) + float2(0.45, -0.05);
                tmp0.y = -tmp0.y * 2.0 + 1.0;
                tmp0.z = 1.0 - inp.color.w;
                tmp0.y = -tmp0.y * tmp0.z + 1.0;
                tmp0.z = tmp0.x > 0.5;
                tmp0.x = dot(inp.color.xy, tmp0.xy);
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
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