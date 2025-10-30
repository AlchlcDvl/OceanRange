Shader "SR/Actor/Eyes" {
	Properties {
		[NoScaleOffset] _Mask ("Mask", 2D) = "white" {}
		[NoScaleOffset] _Blink ("Blink", 2D) = "white" {}
		_XWiggleSpeed ("X Wiggle Speed", Float) = 0
		_YWiggleSpeed ("Y Wiggle Speed", Float) = 0
		_WiggleAmplitude ("Wiggle Amplitude", Float) = 0
		_YScaleSpeed ("Y Scale Speed", Float) = 0
		_XScaleSpeed ("X Scale Speed", Float) = 0
		_ScaleAmplitude ("Scale Amplitude", Float) = 0
		_UnscaledTime ("Unscaled Time", Float) = 0
		_Eyes2 ("Eyes2", 2D) = "white" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+500" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+500" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			Offset -1, -1
			GpuProgramID 11711
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			float _ScaleAmplitude;
			float _XScaleSpeed;
			float _YScaleSpeed;
			float _UnscaledTime;
			float4 _Eyes2_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Eyes2;
			sampler2D _Mask;
			sampler2D _Blink;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xyz = v.normal.xyz * float3(0.001, 0.001, 0.001) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord1.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.xy = _TimeEditor.yw + _Time.yw;
                tmp0.x = tmp0.x + _UnscaledTime;
                tmp0.y = _UnscaledTime * 3.0 + tmp0.y;
                tmp0.yz = tmp0.yy * float2(0.111, 0.333);
                tmp0.yz = sin(tmp0.yz);
                tmp0.yz = max(tmp0.yz, float2(0.0, 0.99));
                tmp0.yz = min(tmp0.yz, float2(0.05, 0.999));
                tmp1.xy = tmp0.xx * float2(_XScaleSpeed.x, _YScaleSpeed.x);
                tmp0.xw = tmp0.xx * float2(_XWiggleSpeed.x, _YWiggleSpeed.x);
                tmp0.xw = sin(tmp0.xw);
                tmp0.xw = _WiggleAmplitude.xx * tmp0.xw + inp.texcoord.xy;
                tmp1.xy = sin(tmp1.xy);
                tmp1.zw = tmp1.xy * _ScaleAmplitude.xx + float2(1.0, 1.0);
                tmp1.xy = tmp1.xy * _ScaleAmplitude.xx;
                tmp1.zw = tmp1.zw * inp.texcoord.xy;
                tmp1.xy = tmp1.xy * float2(-0.5, -0.5) + tmp1.zw;
                tmp0.xw = tmp0.xw + tmp1.xy;
                tmp0.xw = tmp0.xw * float2(0.5, 0.5);
                tmp1 = tex2D(_Mask, tmp0.xw);
                tmp2.xy = tmp0.xw * _Eyes2_ST.xy + _Eyes2_ST.zw;
                tmp3 = tex2D(_Blink, tmp0.xw);
                tmp2 = tex2D(_Eyes2, tmp2.xy);
                tmp1 = tmp1.wxyz - tmp2.wxyz;
                tmp0.x = tmp0.y * 20.0;
                tmp0.y = tmp0.z * 111.1111 + -110.0;
                tmp0.y = max(tmp0.y, 0.0);
                tmp1 = tmp0.xxxx * tmp1 + tmp2.wxyz;
                tmp2 = tmp3.wxyz - tmp1;
                tmp0 = tmp0.yyyy * tmp2 + tmp1;
                tmp0.x = tmp0.x - 0.5;
                o.sv_target.xyz = tmp0.yzw;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}