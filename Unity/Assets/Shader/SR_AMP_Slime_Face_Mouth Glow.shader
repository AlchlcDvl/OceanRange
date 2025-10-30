Shader "SR/AMP/Slime/Face/Mouth Glow" {
	Properties {
		[NoScaleOffset] _FaceAtlas ("Face Atlas", 2D) = "black" {}
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		[HideInInspector] _Drips ("Drips", 2D) = "black" {}
		[HDR] _GlowColor ("Glow Color", Color) = (0.4,1,0,1)
		_GlowNoise ("Glow Noise", 2D) = "black" {}
		_GlowNoiseSpeed ("Glow Noise Speed", Float) = 1
		_XWiggleSpeed ("X Wiggle Speed", Float) = 0
		_YWiggleSpeed ("Y Wiggle Speed", Float) = -2
		_WiggleAmplitude ("Wiggle Amplitude", Float) = 0.01
		_XScaleSpeed ("X Scale Speed", Float) = 2
		_YScaleSpeed ("Y Scale Speed", Float) = -1
		_ScaleAmplitude ("Scale Amplitude", Float) = 0.05
		_MouthTop ("MouthTop", Color) = (0.2470588,0,0.1372549,1)
		_MouthMid ("MouthMid", Color) = (0.4941177,0.01568628,0.01960784,1)
		_MouthBot ("MouthBot", Color) = (0.7529413,0.145098,0.2588235,1)
		_MouthSmoothStepBase ("Mouth SmoothStep Base", Range(0.001, 0.999)) = 0.5
		_Cutoff ("Mask Clip Value", Float) = 0.5
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+1" "RenderType" = "Custom" }
		Pass {
			Name "FORWARD"
			Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+1" "RenderType" = "Custom" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			GpuProgramID 45300
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
			float4 _MouthTop;
			float4 _MouthMid;
			float4 _MouthBot;
			float _MouthSmoothStepBase;
			float _ScaleAmplitude;
			float _XScaleSpeed;
			float _YScaleSpeed;
			float4 _Drips_ST;
			float4 _FaceAtlas_ST;
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			float _GlowNoiseSpeed;
			float4 _GlowNoise_ST;
			float4 _GlowColor;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Drips;
			sampler2D _FaceAtlas;
			sampler2D _GlowNoise;
			
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
                tmp1.xyz = float3(_XWiggleSpeed.x, _YWiggleSpeed.x, _GlowNoiseSpeed.x) * _Time.yyy;
                tmp1.xy = sin(tmp1.xy);
                tmp0.xy = tmp1.xy * _WiggleAmplitude.xx + tmp0.xy;
                tmp0.xy = tmp0.xy + tmp0.zw;
                tmp0.xy = tmp0.xy * float2(0.5, 0.5);
                tmp2.x = inp.texcoord1.x;
                tmp2.y = inp.texcoord2.x;
                tmp2.z = inp.texcoord3.x;
                tmp3.x = inp.texcoord1.w;
                tmp3.y = inp.texcoord2.w;
                tmp3.z = inp.texcoord3.w;
                tmp1.xyw = _WorldSpaceCameraPos - tmp3.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.z, 0.001);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp1.xyw;
                tmp0.z = rsqrt(tmp0.w);
                tmp1.xyw = tmp0.zzz * tmp1.xyw;
                tmp2.x = dot(tmp2.xyz, tmp1.xyz);
                tmp4.x = inp.texcoord1.y;
                tmp4.y = inp.texcoord2.y;
                tmp4.z = inp.texcoord3.y;
                tmp2.y = dot(tmp4.xyz, tmp1.xyz);
                tmp2 = tmp2.xyxy * float4(-0.0375, -0.0375, 0.0225, 0.0225) + tmp0.xyxy;
                tmp0.xy = saturate(tmp0.xy);
                tmp0 = tex2D(_FaceAtlas, tmp0.xy);
                tmp0.xy = saturate(tmp2.zw + float2(0.0, 0.005));
                tmp2.xy = saturate(tmp2.xy);
                tmp2 = tex2D(_FaceAtlas, tmp2.xy);
                tmp0.z = 1.0 - tmp2.w;
                tmp2 = tex2D(_FaceAtlas, tmp0.xy);
                tmp0.x = 1.0 - tmp2.w;
                tmp2.xy = _MouthSmoothStepBase.xx + float2(-0.01, 0.09);
                tmp0.x = tmp0.x - tmp2.y;
                tmp0.x = saturate(tmp0.x * 50.00001);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = tmp0.x * inp.color.y + -_Cutoff;
                tmp0.x = tmp0.x * inp.color.y;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.y = tmp0.z - tmp2.x;
                tmp0.z = -tmp0.w - tmp2.x;
                tmp0.z = tmp0.z + 1.0;
                tmp0.yz = saturate(tmp0.yz * float2(50.0, 50.0));
                tmp0.w = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.w;
                tmp2.x = inp.texcoord1.z;
                tmp2.y = inp.texcoord2.z;
                tmp2.z = inp.texcoord3.z;
                tmp0.w = dot(tmp2.xyz, tmp1.xyz);
                tmp1.x = 1.0 - tmp0.w;
                tmp0.w = saturate(tmp0.w);
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * 2.2;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.x - 0.52;
                tmp1.x = saturate(tmp1.x * -25.00001);
                tmp1.y = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp0.y = tmp0.y * tmp1.x;
                tmp1.xyw = tmp3.yyy * inp.texcoord2.xyz;
                tmp1.xyw = inp.texcoord1.xyz * tmp3.xxx + tmp1.xyw;
                tmp1.xyw = inp.texcoord3.xyz * tmp3.zzz + tmp1.xyw;
                tmp2.x = dot(tmp1.xyz, tmp1.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.yz = tmp1.xy * tmp2.xx;
                tmp1.x = tmp1.w * tmp2.x + 0.42;
                tmp2.yz = tmp2.yz / tmp1.xx;
                tmp3.xy = inp.texcoord.yy - float2(0.1, 0.2);
                tmp1.x = tmp3.y * 3.333333;
                tmp2.w = tmp3.x * -1.875 + 0.75;
                tmp1.x = saturate(tmp1.x);
                tmp3.x = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp3.x;
                tmp1.x = tmp1.x * -0.335;
                tmp3.xy = inp.texcoord.xy * float2(1.0, 1.8) + float2(-0.5, -0.7);
                tmp3.xy = tmp1.xx * tmp2.yz + tmp3.xy;
                tmp1.x = dot(tmp3.xy, tmp3.xy);
                tmp3.x = tmp3.y - 0.75;
                tmp1.x = sqrt(tmp1.x);
                tmp3.yz = tmp1.xx - float2(0.1, 0.15);
                tmp3.xyz = saturate(tmp3.xyz * float3(-0.6666667, -49.99999, -9.999999));
                tmp4.xy = tmp3.yz * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp3.yz = tmp3.yz * tmp3.yz;
                tmp3.yz = tmp3.yz * tmp4.xy;
                tmp1.x = tmp3.z * tmp3.y;
                tmp3.y = tmp3.x * -2.0 + 3.0;
                tmp3.x = tmp3.x * tmp3.x;
                tmp3.x = tmp3.x * tmp3.y;
                tmp3.x = min(tmp3.x, 1.0);
                tmp1.x = tmp1.x * tmp3.x;
                tmp1.x = tmp0.y * tmp1.x;
                tmp3.x = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp3.x;
                tmp1.y = tmp1.y * tmp2.x;
                tmp1.w = tmp1.w * tmp2.x + 0.42;
                tmp1.y = tmp1.y / tmp1.w;
                tmp1.y = tmp1.y * -0.5 + inp.texcoord.y;
                tmp1.w = saturate(tmp1.y * -4.0 + 1.0);
                tmp1.y = tmp1.y - 0.25;
                tmp1.y = saturate(tmp1.y * -1.333333 + 1.0);
                tmp1.y = tmp0.w * tmp1.y;
                tmp0.w = tmp1.w * tmp0.w + tmp1.x;
                tmp1.x = tmp0.w * 0.25 + 0.75;
                tmp0.w = tmp0.w - tmp1.x;
                tmp0.y = tmp0.y * tmp0.w + tmp1.x;
                tmp3.xyz = _MouthBot.xyz - _MouthMid.xyz;
                tmp3.xyz = tmp0.yyy * tmp3.xyz + _MouthMid.xyz;
                tmp4.xyz = _MouthMid.xyz - _MouthTop.xyz;
                tmp1.xyw = tmp1.yyy * tmp4.xyz + _MouthTop.xyz;
                tmp3.xyz = tmp3.xyz - tmp1.xyw;
                tmp1.xyw = tmp0.yyy * tmp3.xyz + tmp1.xyw;
                tmp0.y = saturate(tmp1.x * 0.75);
                tmp0.y = tmp0.y * tmp2.w;
                tmp0.y = saturate(tmp0.y * 0.598);
                tmp1.xyw = tmp1.xyw - tmp0.yyy;
                tmp0.w = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp0.w;
                tmp1.xyw = tmp0.zzz * tmp1.xyw + tmp0.yyy;
                tmp0.yw = inp.texcoord.xy * _GlowNoise_ST.xy + _GlowNoise_ST.zw;
                tmp0.yw = tmp2.yz * float2(-1.5, -1.5) + tmp0.yw;
                tmp0.yw = tmp1.zz * float2(0.1, -0.6) + tmp0.yw;
                tmp2 = tex2D(_GlowNoise, tmp0.yw);
                tmp0.y = tmp2.x * 0.5 + 0.5;
                tmp2.xyz = _GlowColor.www * _GlowColor.xyz;
                tmp2.xyz = tmp0.yyy * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.333, 0.333, 0.333);
                tmp0.y = sin(_Time.y);
                tmp0.y = abs(tmp0.y) * 0.5 + 0.5;
                tmp0.y = tmp0.y * 2.0 + 1.0;
                tmp2.xyz = tmp0.yyy * tmp2.xyz;
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                o.sv_target.w = tmp0.z;
                tmp0.yzw = tmp2.xyz * float3(4.0, 4.0, 4.0);
                tmp0.yzw = floor(tmp0.yzw);
                tmp0.yzw = tmp0.yzw * float3(0.25, 0.25, 0.25) + tmp2.xyz;
                o.sv_target.xyz = tmp1.xyw * tmp0.xxx + tmp0.yzw;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+1" "RenderType" = "Custom" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 80875
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
			float _MouthSmoothStepBase;
			float _ScaleAmplitude;
			float _XScaleSpeed;
			float _YScaleSpeed;
			float4 _Drips_ST;
			float4 _FaceAtlas_ST;
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Drips;
			sampler2D _FaceAtlas;
			
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
                float4 tmp3;
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
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord4.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = max(tmp0.z, 0.001);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp2.x = inp.texcoord1.x;
                tmp2.y = inp.texcoord2.x;
                tmp2.z = inp.texcoord3.x;
                tmp2.x = dot(tmp2.xyz, tmp1.xyz);
                tmp3.x = inp.texcoord1.y;
                tmp3.y = inp.texcoord2.y;
                tmp3.z = inp.texcoord3.y;
                tmp2.y = dot(tmp3.xyz, tmp1.xyz);
                tmp0.zw = tmp2.xy * float2(0.0225, 0.0225) + tmp0.xy;
                tmp0.xy = saturate(tmp0.xy);
                tmp1 = tex2D(_FaceAtlas, tmp0.xy);
                tmp0.x = 1.0 - tmp1.w;
                tmp0.yz = saturate(tmp0.zw + float2(0.0, 0.005));
                tmp1 = tex2D(_FaceAtlas, tmp0.yz);
                tmp0.y = 1.0 - tmp1.w;
                tmp0.zw = _MouthSmoothStepBase.xx + float2(-0.01, 0.09);
                tmp0.xy = tmp0.xy - tmp0.zw;
                tmp0.xy = saturate(tmp0.xy * float2(50.0, 50.00001));
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = tmp0.y * inp.color.y + -_Cutoff;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                o.sv_target.w = tmp0.x * tmp0.y;
                o.sv_target.xyz = float3(0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}