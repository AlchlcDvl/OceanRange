Shader "SR/Slime/Eyes Feral" {
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
		_Iris ("Iris", 2D) = "black" {}
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
			GpuProgramID 53455
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
			float4 _Iris_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Iris;
			sampler2D _Glow;
			sampler2D _Mask;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = v.normal.xyz * float3(0.001, 0.001, 0.001) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
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
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xy = float2(_XScaleSpeed.x, _YScaleSpeed.x) * _Time.yy;
                tmp1.xy = sin(tmp1.xy);
                tmp1.zw = tmp1.xy * _ScaleAmplitude.xx;
                tmp1.xy = tmp1.xy * _ScaleAmplitude.xx + float2(1.0, 1.0);
                tmp1.xy = tmp1.xy * inp.texcoord.xy;
                tmp1.xy = tmp1.zw * float2(-0.5, -0.5) + tmp1.xy;
                tmp1.zw = float2(_XWiggleSpeed.x, _YWiggleSpeed.x) * _Time.yy;
                tmp1.zw = sin(tmp1.zw);
                tmp1.zw = _WiggleAmplitude.xx * tmp1.zw + inp.texcoord.xy;
                tmp1.xy = tmp1.zw + tmp1.xy;
                tmp1.xy = tmp1.xy * float2(0.5, 0.5);
                tmp2.x = dot(inp.texcoord3.xyz, tmp0.xyz);
                tmp2.y = dot(inp.texcoord4.xyz, tmp0.xyz);
                tmp0.xy = tmp2.xy * float2(-0.05, -0.05) + tmp1.xy;
                tmp0.xy = tmp0.xy * _Iris_ST.xy + _Iris_ST.zw;
                tmp0 = tex2D(_Iris, tmp0.xy);
                tmp1.zw = tmp1.xy * _Glow_ST.xy + _Glow_ST.zw;
                tmp2 = tex2D(_Glow, tmp1.zw);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp2.www * tmp0.xyz;
                tmp1.zw = sin(_Time.wy);
                tmp0.w = tmp1.z * 0.15 + 1.05;
                tmp1.xy = tmp1.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp3 = tex2D(_Mask, tmp1.xy);
                tmp1.xy = _Time.yy * float2(0.01, -0.065) + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * float2(6.0, 6.0);
                tmp1.z = 0.0;
                tmp2.x = 0.0;
                while (true) {
                    tmp2.y = i >= 6;
                    if (tmp2.y) {
                        break;
                    }
                    i = i + 1;
                    tmp2.yz = tmp1.xy * tmp2.yy;
                    tmp4.xy = floor(tmp2.yz);
                    tmp2.yz = frac(tmp2.yz);
                    tmp4.zw = tmp2.yz * tmp2.yz;
                    tmp2.yz = -tmp2.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp2.yz = tmp2.yz * tmp4.zw;
                    tmp4.x = tmp4.y * 57.0 + tmp4.x;
                    tmp4.yzw = tmp4.xxx + float3(1.0, 57.0, 58.0);
                    tmp5 = sin(tmp4);
                    tmp4 = tmp5 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp4 = frac(tmp4);
                    tmp4.yw = tmp4.yw - tmp4.xz;
                    tmp4.xy = tmp2.yy * tmp4.yw + tmp4.xz;
                    tmp2.y = tmp4.y - tmp4.x;
                    tmp2.y = tmp2.z * tmp2.y + tmp4.x;
                    tmp2.z = null.z / 6;
                    tmp1.z = tmp2.y * tmp2.z + tmp1.z;
                }
                tmp1.x = tmp1.z * 0.1666667;
                tmp1.y = abs(tmp1.w) * 0.5 + 0.5;
                tmp1.y = tmp1.y * 2.0 + 1.0;
                tmp1.z = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.z;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.xyz = tmp1.xxx * _GlowColor.xyz;
                tmp1.xyz = tmp2.www * tmp1.xyz;
                tmp2.xyz = tmp0.xyz * tmp0.www + tmp3.xyz;
                tmp4.xyz = tmp1.xyz * float3(0.666, 0.666, 0.666);
                tmp4.xyz = floor(tmp4.xyz);
                tmp1.xyz = tmp1.xyz * float3(0.333, 0.333, 0.333) + tmp4.xyz;
                tmp1.xyz = tmp3.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp1.xyz;
                tmp0.xyz = tmp0.xyz - tmp2.xyz;
                o.sv_target.xyz = _EnableGlow.xxx * tmp0.xyz + tmp2.xyz;
                o.sv_target.w = tmp3.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest+1" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Offset -1, -1
			GpuProgramID 100856
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
	Fallback "Unlit/Transparent Cutout"
	CustomEditor "ShaderForgeMaterialInspector"
}