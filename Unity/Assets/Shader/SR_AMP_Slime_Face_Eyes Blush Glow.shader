Shader "SR/AMP/Slime/Face/Eyes Blush Glow" {
	Properties {
		[NoScaleOffset] _FaceAtlas ("Face Atlas", 2D) = "black" {}
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		[HDR] _GlowColor ("Glow Color", Color) = (0.4,1,0,1)
		[HideInInspector] _Drips ("Drips", 2D) = "black" {}
		_GlowNoise ("Glow Noise", 2D) = "black" {}
		_GlowNoiseSpeed ("Glow Noise Speed", Float) = 1
		[NoScaleOffset] _Blush ("Blush", 2D) = "black" {}
		_XWiggleSpeed ("X Wiggle Speed", Float) = 0
		_YWiggleSpeed ("Y Wiggle Speed", Float) = -2
		_WiggleAmplitude ("Wiggle Amplitude", Float) = 0.01
		_XScaleSpeed ("X Scale Speed", Float) = 2
		_YScaleSpeed ("Y Scale Speed", Float) = -1
		_ScaleAmplitude ("Scale Amplitude", Float) = 0.05
		_EyeRed ("Eye (Red)", Color) = (0.1137255,0.03921569,0.01176471,1)
		[HDR] _EyeGreen ("Eye (Green)", Color) = (0.3137255,0.1215686,0.02745098,1)
		_EyeBlue ("Eye (Blue)", Color) = (0.9528302,0.8915228,0.876424,1)
		_DepthGreen ("Depth (Green)", Float) = 0
		_DepthBlue ("Depth (Blue)", Float) = 0
		_EyeSmoothStepBase ("Eye SmoothStep Base", Range(0.001, 0.999)) = 0.5
		_EyeGlare ("Eye Glare", Range(0, 1)) = 0.2
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+1" "RenderType" = "Custom" }
		Pass {
			Name "FORWARD"
			Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+1" "RenderType" = "Custom" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			GpuProgramID 56954
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
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
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _GlowNoiseSpeed;
			float4 _GlowNoise_ST;
			float4 _GlowColor;
			float _EyeSmoothStepBase;
			float _ScaleAmplitude;
			float _XScaleSpeed;
			float _YScaleSpeed;
			float4 _Drips_ST;
			float4 _FaceAtlas_ST;
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			float _EyeGlare;
			float _DepthGreen;
			float4 _EyeGreen;
			float4 _EyeRed;
			float4 _EyeBlue;
			float _DepthBlue;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Drips;
			sampler2D _FaceAtlas;
			sampler2D _GlowNoise;
			sampler2D _Blush;
			
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
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
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
                tmp0.x = inp.texcoord1.w;
                tmp0.y = inp.texcoord2.w;
                tmp0.z = inp.texcoord3.w;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = tmp0.yyy * inp.texcoord2.xyz;
                tmp0.xyw = inp.texcoord1.xyz * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = inp.texcoord3.xyz * tmp0.zzz + tmp0.xyw;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xy = tmp0.ww * tmp0.xy;
                tmp0.z = tmp0.z * tmp0.w + 0.42;
                tmp0.xy = tmp0.xy / tmp0.zz;
                tmp0.zw = tmp0.xy * float2(-2.5, -2.5);
                tmp0.zw = inp.texcoord.xy * float2(25.0, 25.0) + tmp0.zw;
                tmp0.zw = tmp0.zw - float2(5.7, 13.845);
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.z = sqrt(tmp0.z);
                tmp1.xy = inp.texcoord.xy * float2(25.0, 25.0) + float2(-19.15, -13.845);
                tmp1.xy = tmp0.xy * float2(-2.5, -2.5) + tmp1.xy;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp0.zw = min(tmp0.zw, float2(1.0, 1.0));
                tmp0.w = 1.0 - tmp0.w;
                tmp0.z = tmp0.w - tmp0.z;
                tmp0.z = tmp0.z + 0.667;
                tmp0.z = saturate(tmp0.z * 1.49925);
                tmp0.w = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = tmp0.z * _EyeGlare;
                tmp1.xy = inp.texcoord.xy * _Drips_ST.xy + _Drips_ST.zw;
                tmp1.xy = _Time.yy * float2(0.09, 0.31) + tmp1.xy;
                tmp1.zw = tmp1.xy + float2(0.1, 0.1);
                tmp2 = tex2D(_Drips, tmp1.zy);
                tmp3 = tex2D(_Drips, tmp1.xw);
                tmp1 = tex2D(_Drips, tmp1.xy);
                tmp3.y = tmp3.y - tmp1.y;
                tmp3.x = tmp2.y - tmp1.y;
                tmp1.xy = tmp3.xy * float2(0.5, 0.5);
                tmp1.z = 0.0;
                tmp1.xyz = float3(0.0, 0.0, 1.0) - tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xy = tmp0.ww * tmp1.xy;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.zw = inp.texcoord.xy * _FaceAtlas_ST.xy + _FaceAtlas_ST.zw;
                tmp1.xy = tmp1.xy * float2(0.01, 0.01) + tmp1.zw;
                tmp1.zw = float2(_XScaleSpeed.x, _YScaleSpeed.x) * _Time.yy;
                tmp1.zw = sin(tmp1.zw);
                tmp2.xy = _ScaleAmplitude.xx * tmp1.zw + float2(1.0, 1.0);
                tmp1.zw = tmp1.zw * _ScaleAmplitude.xx;
                tmp2.xy = tmp1.xy * tmp2.xy;
                tmp1.zw = tmp1.zw * float2(-0.5, -0.5) + tmp2.xy;
                tmp2.xy = float2(_XWiggleSpeed.x, _YWiggleSpeed.x) * _Time.yy;
                tmp2.xy = sin(tmp2.xy);
                tmp1.xy = tmp2.xy * _WiggleAmplitude.xx + tmp1.xy;
                tmp1.xy = tmp1.xy + tmp1.zw;
                tmp1.xy = tmp1.xy * float2(0.5, 0.5);
                tmp1.zw = saturate(tmp1.xy);
                tmp2 = tex2D(_Blush, tmp1.xy);
                tmp0.w = _DepthBlue * 0.5;
                tmp1.xy = tmp0.ww * tmp0.xy + tmp1.zw;
                tmp3 = tex2D(_FaceAtlas, tmp1.xy);
                tmp1.xy = _EyeSmoothStepBase.xx - float2(0.025, 0.1);
                tmp0.w = tmp3.z - tmp1.x;
                tmp0.w = saturate(tmp0.w * 20.0);
                tmp3.x = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp3.x;
                tmp3.xyz = _EyeBlue.xyz - _EyeRed.xyz;
                tmp3.xyz = tmp0.www * tmp3.xyz + _EyeRed.xyz;
                tmp0.w = _DepthGreen * 0.5;
                tmp4.xy = tmp0.ww * tmp0.xy + tmp1.zw;
                tmp5 = tex2D(_FaceAtlas, tmp1.zw);
                tmp1.xy = tmp5.xx - tmp1.xy;
                tmp1.xy = saturate(tmp1.xy * float2(20.0, 5.0));
                tmp4 = tex2D(_FaceAtlas, tmp4.xy);
                tmp1.zw = tmp1.xy * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp1.xy = tmp1.xy * tmp1.xy;
                tmp1.xy = tmp1.xy * tmp1.zw;
                tmp0.w = tmp4.y * tmp1.y;
                tmp3.xyz = tmp0.www * _EyeGreen.xyz + tmp3.xyz;
                tmp0.w = tmp1.x * inp.color.x;
                tmp1.xzw = tmp3.xyz * tmp0.www;
                tmp1.xyz = tmp0.zzz * tmp1.yyy + tmp1.xzw;
                tmp1.xyz = -tmp2.xyz * tmp2.www + tmp1.xyz;
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp0.z = saturate(tmp0.w);
                tmp1.xyz = tmp0.zzz * tmp1.xyz + tmp2.xyz;
                o.sv_target.w = saturate(tmp0.z + tmp2.w);
                tmp2.xy = inp.texcoord.xy * _GlowNoise_ST.xy + _GlowNoise_ST.zw;
                tmp0.xy = tmp0.xy * float2(-1.5, -1.5) + tmp2.xy;
                tmp0.z = _GlowNoiseSpeed * _Time.y;
                tmp0.xy = tmp0.zz * float2(0.1, -0.6) + tmp0.xy;
                tmp2 = tex2D(_GlowNoise, tmp0.xy);
                tmp0.x = tmp2.x * 0.5 + 0.5;
                tmp2.xyz = _GlowColor.www * _GlowColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.333, 0.333, 0.333);
                tmp1.w = sin(_Time.y);
                tmp1.w = abs(tmp1.w) * 0.5 + 0.5;
                tmp1.w = tmp1.w * 2.0 + 1.0;
                tmp0.xyz = tmp0.xyz * tmp1.www;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp2.xyz = tmp0.xyz * float3(4.0, 4.0, 4.0);
                tmp2.xyz = floor(tmp2.xyz);
                tmp0.xyz = tmp2.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                o.sv_target.xyz = tmp1.xyz + tmp0.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+1" "RenderType" = "Custom" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 85130
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _EyeSmoothStepBase;
			float _ScaleAmplitude;
			float _XScaleSpeed;
			float _YScaleSpeed;
			float4 _Drips_ST;
			float4 _FaceAtlas_ST;
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Drips;
			sampler2D _FaceAtlas;
			sampler2D _Blush;
			
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
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
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
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy * _Drips_ST.xy + _Drips_ST.zw;
                tmp0.xy = _Time.yy * float2(0.09, 0.31) + tmp0.xy;
                tmp0.zw = tmp0.xy + float2(0.1, 0.1);
                tmp1 = tex2D(_Drips, tmp0.zy);
                tmp2 = tex2D(_Drips, tmp0.xw);
                tmp0 = tex2D(_Drips, tmp0.xy);
                tmp2.y = tmp2.y - tmp0.y;
                tmp2.x = tmp1.y - tmp0.y;
                tmp0.xy = tmp2.xy * float2(0.5, 0.5);
                tmp0.z = 0.0;
                tmp0.xyz = float3(0.0, 0.0, 1.0) - tmp0.xyz;
                tmp0.z = dot(tmp0.xyz, tmp0.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp0.xy = tmp0.zz * tmp0.xy;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.zw = inp.texcoord.xy * _FaceAtlas_ST.xy + _FaceAtlas_ST.zw;
                tmp0.xy = tmp0.xy * float2(0.01, 0.01) + tmp0.zw;
                tmp0.zw = float2(_XScaleSpeed.x, _YScaleSpeed.x) * _Time.yy;
                tmp0.zw = sin(tmp0.zw);
                tmp1.xy = _ScaleAmplitude.xx * tmp0.zw + float2(1.0, 1.0);
                tmp0.zw = tmp0.zw * _ScaleAmplitude.xx;
                tmp1.xy = tmp0.xy * tmp1.xy;
                tmp0.zw = tmp0.zw * float2(-0.5, -0.5) + tmp1.xy;
                tmp1.xy = float2(_XWiggleSpeed.x, _YWiggleSpeed.x) * _Time.yy;
                tmp1.xy = sin(tmp1.xy);
                tmp0.xy = tmp1.xy * _WiggleAmplitude.xx + tmp0.xy;
                tmp0.xy = tmp0.xy + tmp0.zw;
                tmp0.xy = tmp0.xy * float2(0.5, 0.5);
                tmp0.zw = saturate(tmp0.xy);
                tmp1 = tex2D(_Blush, tmp0.xy);
                tmp0 = tex2D(_FaceAtlas, tmp0.zw);
                tmp0.y = _EyeSmoothStepBase - 0.025;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = saturate(tmp0.x * 20.0);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = saturate(tmp0.x * inp.color.x);
                o.sv_target.w = saturate(tmp0.x + tmp1.w);
                o.sv_target.xyz = float3(0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}