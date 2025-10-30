Shader "SR/Slime/Eyes Transparent" {
	Properties {
		_Mask ("Mask", 2D) = "white" {}
		_XWiggleSpeed ("X Wiggle Speed", Float) = 0
		_YWiggleSpeed ("Y Wiggle Speed", Float) = 0
		_WiggleAmplitude ("Wiggle Amplitude", Float) = 0
		_YScaleSpeed ("Y Scale Speed", Float) = 0
		_XScaleSpeed ("X Scale Speed", Float) = 0
		_ScaleAmplitude ("Scale Amplitude", Float) = 0
		[MaterialToggle] _EnableGlow ("Enable Glow", Float) = 0
		_Glow ("Glow", 2D) = "white" {}
		_GlowColor ("Glow Color", Color) = (0.4482759,1,0,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "AlphaTest+1" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+1" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Offset -1, -1
			GpuProgramID 54808
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
			float4 _Mask_ST;
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			float _ScaleAmplitude;
			float _XScaleSpeed;
			float _YScaleSpeed;
			float4 _Glow_ST;
			float4 _GlowColor;
			float _EnableGlow;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Mask;
			sampler2D _Glow;
			
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
                o.texcoord.xy = v.texcoord.xy;
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
                float4 tmp4;
                tmp0.xy = float2(_XScaleSpeed.x, _YScaleSpeed.x) * _Time.yy;
                tmp0.xy = sin(tmp0.xy);
                tmp0.zw = tmp0.xy * _ScaleAmplitude.xx;
                tmp0.xy = tmp0.xy * _ScaleAmplitude.xx + float2(1.0, 1.0);
                tmp0.xy = tmp0.xy * inp.texcoord.xy;
                tmp0.xy = tmp0.zw * float2(-0.5, -0.5) + tmp0.xy;
                tmp0.zw = float2(_XWiggleSpeed.x, _YWiggleSpeed.x) * _Time.yy;
                tmp0.zw = sin(tmp0.zw);
                tmp0.zw = _WiggleAmplitude.xx * tmp0.zw + inp.texcoord.xy;
                tmp0.xy = tmp0.zw + tmp0.xy;
                tmp0.xy = tmp0.xy * float2(0.5, 0.5);
                tmp0.zw = tmp0.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp1 = tex2D(_Mask, tmp0.zw);
                tmp0.zw = _Time.yy * float2(0.01, -0.065) + inp.texcoord.xy;
                tmp0.zw = tmp0.zw * float2(6.0, 6.0);
                tmp2.xy = float2(0.0, 0.0);
                while (true) {
                    tmp2.z = i >= 6;
                    if (tmp2.z) {
                        break;
                    }
                    i = i + 1;
                    tmp2.zw = tmp0.zw * tmp2.zz;
                    tmp3.xy = floor(tmp2.zw);
                    tmp2.zw = frac(tmp2.zw);
                    tmp3.zw = tmp2.zw * tmp2.zw;
                    tmp2.zw = -tmp2.zw * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp2.zw = tmp2.zw * tmp3.zw;
                    tmp3.x = tmp3.y * 57.0 + tmp3.x;
                    tmp3.yzw = tmp3.xxx + float3(1.0, 57.0, 58.0);
                    tmp4 = sin(tmp3);
                    tmp3 = tmp4 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp3 = frac(tmp3);
                    tmp3.yw = tmp3.yw - tmp3.xz;
                    tmp3.xy = tmp2.zz * tmp3.yw + tmp3.xz;
                    tmp2.z = tmp3.y - tmp3.x;
                    tmp2.z = tmp2.w * tmp2.z + tmp3.x;
                    tmp2.w = null.w / 6;
                    tmp2.x = tmp2.z * tmp2.w + tmp2.x;
                }
                tmp0.z = tmp2.x * 0.1666667;
                tmp0.xy = tmp0.xy * _Glow_ST.xy + _Glow_ST.zw;
                tmp2 = tex2D(_Glow, tmp0.xy);
                tmp0.x = sin(_Time.y);
                tmp0.x = abs(tmp0.x) * 0.5 + 0.5;
                tmp0.x = tmp0.x * 2.0 + 1.0;
                tmp0.y = tmp0.z * tmp0.z;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.xyz = tmp0.xxx * _GlowColor.xyz;
                tmp0.xyz = tmp2.www * tmp0.xyz;
                tmp2.xyz = tmp0.xyz * float3(0.666, 0.666, 0.666);
                tmp2.xyz = floor(tmp2.xyz);
                tmp0.xyz = tmp0.xyz * float3(0.333, 0.333, 0.333) + tmp2.xyz;
                o.sv_target.xyz = _EnableGlow.xxx * tmp0.xyz + tmp1.xyz;
                o.sv_target.w = tmp1.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest+1" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Offset -1, -1
			GpuProgramID 83046
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord1 : TEXCOORD1;
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
			
			// Keywords: SHADOWS_DEPTH
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
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Unlit/Transparent"
	CustomEditor "ShaderForgeMaterialInspector"
}