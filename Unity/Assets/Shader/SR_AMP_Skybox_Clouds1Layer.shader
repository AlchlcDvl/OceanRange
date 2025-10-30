Shader "SR/AMP/Skybox/Clouds1Layer" {
	Properties {
		_Cutoff ("Mask Clip Value", Float) = 0.5
		_NoiseTexture ("Noise Texture", 2D) = "white" {}
		_NoiseTextureScale ("Noise Texture Scale", Float) = 1
		_NoiseTextureScale2 ("Noise Texture Scale 2", Float) = 1
		_NoiseScaleMaster ("Noise Scale Master", Float) = 1
		_CloudSpeed1 ("Cloud Speed 1", Float) = 0
		_CloudSpeed2 ("Cloud Speed 2", Float) = 0
		_CloudSpeedMaster ("Cloud Speed Master", Float) = 1
		_LightingOffsetDistance ("Lighting Offset Distance", Range(0, 15)) = 1
		_Coverage ("Coverage", Range(0, 1)) = 0.5106499
		_Softness ("Softness", Range(0, 1)) = 0.5
		_RimPower ("Rim Power", Float) = 3
		_RimLightStrength ("Rim Light Strength", Float) = 1
		_SSSRim ("SSS Rim", Range(0, 1)) = 0
		_SSSBoost ("SSS Boost", Range(0, 1)) = 1
		_SSSPower ("SSS Power", Float) = 0
		_AroundSunBias ("Around Sun Bias", Range(0, 1)) = 0
		_TopOffset ("Top Offset", Range(-1, 1)) = 1
		_TopShadingOpacity ("Top Shading Opacity", Range(0, 1)) = 1
		_TopDownOffset ("TopDown Offset", Range(-1, 1)) = 1
		_TopDownShadingSoftness ("TopDown Shading Softness", Range(0, 1)) = 0
		_TopDownShadingLevel ("TopDown Shading Level", Range(0, 1)) = 0
		_TopDownShadingOpacity ("TopDown Shading Opacity", Range(0, 1)) = 1
		_AlphaCut ("AlphaCut", Float) = 0.2
		_EdgeBlend ("EdgeBlend", Range(0, 10)) = 2
		_Alpha ("Alpha", Float) = 5
		_Dayness ("Dayness", Range(0, 1)) = 1
		_ShadingNight ("Shading - Night", Color) = (0.007843138,0.007843138,0.1686275,0)
		_BaseColorNight ("BaseColor - Night", Color) = (0.02745098,0.1294118,0.3411765,0.5019608)
		_BaseColor ("BaseColor", Color) = (0.9176471,0.9725491,1,1)
		_Shading ("Shading", Color) = (0.1803922,0.5882353,0.7882354,0.2392157)
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			Cull Off
			GpuProgramID 40261
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
				float texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _EdgeBlend;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ShadingNight;
			float4 _Shading;
			float _Dayness;
			float4 _BaseColorNight;
			float4 _BaseColor;
			float _CloudSpeed1;
			float _CloudSpeedMaster;
			float _NoiseTextureScale;
			float _NoiseScaleMaster;
			float _LightingOffsetDistance;
			float _CloudSpeed2;
			float _NoiseTextureScale2;
			float _AroundSunBias;
			float _Coverage;
			float _Softness;
			float _SSSRim;
			float _SSSPower;
			float _SSSBoost;
			float _RimLightStrength;
			float _RimPower;
			float _TopDownOffset;
			float _TopDownShadingLevel;
			float _TopDownShadingSoftness;
			float _TopDownShadingOpacity;
			float _Alpha;
			float _TopOffset;
			float _TopShadingOpacity;
			float _AlphaCut;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _NoiseTexture;
			
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
                o.texcoord.w = tmp0.x;
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
                o.texcoord.y = tmp3.x;
                o.texcoord.x = tmp2.z;
                o.texcoord.z = tmp1.y;
                o.texcoord1.x = tmp2.x;
                o.texcoord2.x = tmp2.y;
                o.texcoord1.z = tmp1.z;
                o.texcoord2.z = tmp1.x;
                o.texcoord1.w = tmp0.y;
                o.texcoord2.w = tmp0.z;
                o.texcoord1.y = tmp3.y;
                o.texcoord2.y = tmp3.z;
                tmp0.xy = v.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _EdgeBlend;
                o.texcoord3.x = exp(tmp0.x);
                o.texcoord4.xyz = float3(0.0, 0.0, 0.0);
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
                tmp0.y = inp.texcoord1.w;
                tmp0.x = inp.texcoord.w;
                tmp0.z = inp.texcoord2.w;
                tmp1.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp2.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = max(tmp0.y, 0.001);
                tmp0.y = rsqrt(tmp0.y);
                tmp1.xyz = tmp0.yyy * tmp1.xyz;
                tmp0.y = saturate(-tmp1.y);
                tmp3.x = dot(tmp2.xyz, inp.texcoord.xyz);
                tmp3.y = dot(tmp2.xyz, inp.texcoord1.xyz);
                tmp0.yw = tmp0.yy * tmp3.xy;
                tmp1.w = _TopOffset * -0.02 + 0.01;
                tmp2.xy = tmp0.xz * _NoiseTextureScale.xx;
                tmp0.xz = tmp0.xz * _NoiseTextureScale2.xx;
                tmp0.xz = tmp0.xz * _NoiseScaleMaster.xx;
                tmp0 = tmp0 * float4(0.001, 0.1, 0.001, 0.1);
                tmp2.xy = tmp2.xy * _NoiseScaleMaster.xx;
                tmp2.xy = tmp2.xy * float2(0.001, 0.001);
                tmp2.z = _CloudSpeedMaster * _CloudSpeed1;
                tmp2.z = tmp2.z * _Time.y;
                tmp2.xy = tmp2.zz * float2(0.01, 0.01) + tmp2.xy;
                tmp2.zw = tmp0.yw * tmp1.ww + tmp2.xy;
                tmp3 = tex2D(_NoiseTexture, tmp2.zw);
                tmp2.z = _CloudSpeedMaster * _CloudSpeed2;
                tmp2.z = tmp2.z * _Time.y;
                tmp0.xz = tmp2.zz * float2(0.01, 0.01) + tmp0.xz;
                tmp2.zw = tmp0.yw * tmp1.ww + tmp0.xz;
                tmp4 = tex2D(_NoiseTexture, tmp2.zw);
                tmp1.w = tmp3.x + tmp4.x;
                tmp2.z = 1.0 - _Coverage;
                tmp2.w = tmp2.z - _Softness;
                tmp2.z = tmp2.z + _Softness;
                tmp1.w = tmp1.w * 0.5 + -tmp2.w;
                tmp3.x = tmp2.z - tmp2.w;
                tmp2.z = tmp2.z + _SSSRim;
                tmp2.z = tmp2.z - tmp2.w;
                tmp1.w = -tmp1.w / tmp3.x;
                tmp1.w = saturate(tmp1.w + 1.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp3.y = 1.0 - _TopShadingOpacity;
                tmp1.w = saturate(tmp1.w * tmp3.y);
                tmp4 = tex2D(_NoiseTexture, tmp2.xy);
                tmp5 = tex2D(_NoiseTexture, tmp0.xz);
                tmp3.y = tmp4.x + tmp5.x;
                tmp3.y = tmp3.y * 0.5 + -tmp2.w;
                tmp3.x = saturate(tmp3.y / tmp3.x);
                tmp1.w = tmp1.w + tmp3.x;
                tmp3.x = inp.texcoord3.x * _Alpha;
                tmp3.y = tmp3.x * tmp1.w + -_AlphaCut;
                tmp1.w = tmp1.w * tmp3.x;
                o.sv_target.w = saturate(tmp1.w);
                tmp1.w = ceil(tmp3.y);
                tmp1.w = tmp1.w - 0.5;
                tmp1.w = tmp1.w - _Cutoff;
                tmp1.w = tmp1.w < 0.0;
                if (tmp1.w) {
                    discard;
                }
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp1.x = dot(tmp1.xyz, -tmp3.xyz);
                tmp1.x = tmp1.x + 1.0;
                tmp1.y = -tmp1.x * 0.5 + 1.0;
                tmp1.x = tmp1.x * 0.5;
                tmp1.x = saturate(tmp1.x);
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * _SSSPower;
                tmp1.x = exp(tmp1.x);
                tmp1.z = tmp1.y * -_LightingOffsetDistance;
                tmp1.y = tmp1.y * _AroundSunBias;
                tmp4.x = inp.texcoord.x;
                tmp4.y = inp.texcoord1.x;
                tmp4.z = inp.texcoord2.x;
                tmp5.x = dot(tmp3.xyz, unity_WorldToObject._m00_m10_m20);
                tmp5.y = dot(tmp3.xyz, unity_WorldToObject._m01_m11_m21);
                tmp5.z = dot(tmp3.xyz, unity_WorldToObject._m02_m12_m22);
                tmp3.x = dot(tmp4.xyz, tmp5.xyz);
                tmp4.x = inp.texcoord.y;
                tmp4.y = inp.texcoord1.y;
                tmp4.z = inp.texcoord2.y;
                tmp3.y = dot(tmp4.xyz, tmp5.xyz);
                tmp3.zw = tmp3.xy * tmp1.zz + tmp2.xy;
                tmp1.zw = tmp3.xy * tmp1.zz + tmp0.xz;
                tmp4 = tex2D(_NoiseTexture, tmp1.zw);
                tmp3 = tex2D(_NoiseTexture, tmp3.zw);
                tmp1.z = tmp4.x + tmp3.x;
                tmp1.y = tmp1.z * 0.5 + tmp1.y;
                tmp1.y = tmp1.y - tmp2.w;
                tmp1.y = tmp1.y / tmp2.z;
                tmp1.y = saturate(1.0 - tmp1.y);
                tmp1.x = tmp1.x * _SSSBoost + tmp1.y;
                tmp1.x = saturate(tmp1.x * _RimLightStrength);
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * _RimPower;
                tmp1.x = exp(tmp1.x);
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.y = _TopDownOffset * 0.02 + -0.01;
                tmp1.zw = tmp1.yy * tmp0.yw + tmp2.xy;
                tmp0.xy = tmp1.yy * tmp0.yw + tmp0.xz;
                tmp0 = tex2D(_NoiseTexture, tmp0.xy);
                tmp2 = tex2D(_NoiseTexture, tmp1.zw);
                tmp0.x = tmp0.x + tmp2.x;
                tmp0.y = _TopDownShadingLevel - _TopDownShadingSoftness;
                tmp0.x = tmp0.x * 0.5 + -tmp0.y;
                tmp0.z = _TopDownShadingSoftness + _TopDownShadingLevel;
                tmp0.y = tmp0.z - tmp0.y;
                tmp0.x = saturate(tmp0.x / tmp0.y);
                tmp0.y = 1.0 - _TopDownShadingOpacity;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = saturate(1.0 - tmp0.x);
                tmp0.x = tmp0.x + tmp1.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.yzw = _Shading.xyz - _ShadingNight.xyz;
                tmp0.yzw = _Dayness.xxx * tmp0.yzw + _ShadingNight.xyz;
                tmp1 = _BaseColor - _BaseColorNight;
                tmp1 = _Dayness.xxxx * tmp1 + _BaseColorNight;
                tmp1.xyz = tmp1.xyz - tmp0.yzw;
                tmp0.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.www * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz + -unity_FogColor.xyz;
                tmp0.w = inp.texcoord3.x * inp.texcoord3.x;
                o.sv_target.xyz = tmp0.www * tmp0.xyz + unity_FogColor.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
			Blend One One, One One
			ZWrite Off
			Cull Off
			GpuProgramID 78111
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float texcoord4 : TEXCOORD4;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float _EdgeBlend;
			// $Globals ConstantBuffers for Fragment Shader
			float _CloudSpeed1;
			float _CloudSpeedMaster;
			float _NoiseTextureScale;
			float _NoiseScaleMaster;
			float _CloudSpeed2;
			float _NoiseTextureScale2;
			float _Coverage;
			float _Softness;
			float _Alpha;
			float _TopOffset;
			float _TopShadingOpacity;
			float _AlphaCut;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _NoiseTexture;
			
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
                tmp1.xy = v.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * _EdgeBlend;
                o.texcoord4.x = exp(tmp1.x);
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
                o.texcoord.y = tmp3.x;
                o.texcoord.x = tmp2.z;
                o.texcoord.z = tmp1.y;
                o.texcoord1.x = tmp2.x;
                o.texcoord2.x = tmp2.y;
                o.texcoord1.z = tmp1.z;
                o.texcoord2.z = tmp1.x;
                o.texcoord1.y = tmp3.y;
                o.texcoord2.y = tmp3.z;
                o.texcoord3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.001);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = saturate(-tmp0.x);
                tmp0.yzw = inp.texcoord3.xyz - _WorldSpaceCameraPos;
                tmp1.x = dot(tmp0.xyz, inp.texcoord.xyz);
                tmp1.y = dot(tmp0.xyz, inp.texcoord1.xyz);
                tmp0.xy = tmp0.xx * tmp1.xy;
                tmp0.zw = inp.texcoord3.xz * _NoiseTextureScale.xx;
                tmp0.zw = tmp0.zw * _NoiseScaleMaster.xx;
                tmp0 = tmp0 * float4(0.1, 0.1, 0.001, 0.001);
                tmp1.x = _CloudSpeedMaster * _CloudSpeed1;
                tmp1.x = tmp1.x * _Time.y;
                tmp0.zw = tmp1.xx * float2(0.01, 0.01) + tmp0.zw;
                tmp1.x = _TopOffset * -0.02 + 0.01;
                tmp1.yz = tmp0.xy * tmp1.xx + tmp0.zw;
                tmp2 = tex2D(_NoiseTexture, tmp0.zw);
                tmp3 = tex2D(_NoiseTexture, tmp1.yz);
                tmp0.zw = inp.texcoord3.xz * _NoiseTextureScale2.xx;
                tmp0.zw = tmp0.zw * _NoiseScaleMaster.xx;
                tmp0.zw = tmp0.zw * float2(0.001, 0.001);
                tmp1.y = _CloudSpeedMaster * _CloudSpeed2;
                tmp1.y = tmp1.y * _Time.y;
                tmp0.zw = tmp1.yy * float2(0.01, 0.01) + tmp0.zw;
                tmp0.xy = tmp0.xy * tmp1.xx + tmp0.zw;
                tmp1 = tex2D(_NoiseTexture, tmp0.zw);
                tmp0.z = tmp1.x + tmp2.x;
                tmp1 = tex2D(_NoiseTexture, tmp0.xy);
                tmp0.x = tmp1.x + tmp3.x;
                tmp0.y = 1.0 - _Coverage;
                tmp0.w = tmp0.y - _Softness;
                tmp0.y = tmp0.y + _Softness;
                tmp0.y = tmp0.y - tmp0.w;
                tmp0.x = tmp0.x * 0.5 + -tmp0.w;
                tmp0.z = tmp0.z * 0.5 + -tmp0.w;
                tmp0.z = saturate(tmp0.z / tmp0.y);
                tmp0.x = -tmp0.x / tmp0.y;
                tmp0.x = saturate(tmp0.x + 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = 1.0 - _TopShadingOpacity;
                tmp0.x = saturate(tmp0.y * tmp0.x);
                tmp0.x = tmp0.z + tmp0.x;
                tmp0.y = inp.texcoord4.x * _Alpha;
                tmp0.z = tmp0.y * tmp0.x + -_AlphaCut;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.w = saturate(tmp0.x);
                tmp0.x = ceil(tmp0.z);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x - _Cutoff;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target.xyz = float3(0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}