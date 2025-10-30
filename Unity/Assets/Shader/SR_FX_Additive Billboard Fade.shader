// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "SR/FX/Additive Billboard Fade" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_TintColor ("Color", Color) = (1,1,1,1)
		_TransitionDistance ("TransitionDistance", Float) = 5
		_Falloff ("Falloff", Float) = 10
		_ColorNear ("Color Near", Color) = (1,1,1,1)
		_ColorFar ("Color Far", Color) = (1,1,1,1)
		_ScaleNear ("Scale Near", Float) = 1
		_ScaleFar ("Scale Far", Float) = 1
		_Width ("Width", Float) = 1
		_Height ("Height", Float) = 1
	}
	SubShader {
		Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Overlay" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 26112
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _TransitionDistance;
			float _Falloff;
			float _ScaleNear;
			float _ScaleFar;
			float _Width;
			float _Height;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_ST;
			float4 _TintColor;
			float4 _ColorNear;
			float4 _ColorFar;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = unity_WorldToObject._m10;
                tmp0.y = unity_WorldToObject._m11;
                tmp0.z = unity_WorldToObject._m12;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.z = -1.0 / tmp0.x;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 - _WorldSpaceCameraPos;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x / _TransitionDistance;
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * _Falloff;
                tmp1.x = exp(tmp1.x);
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.y = _ScaleFar - _ScaleNear;
                tmp1.x = tmp1.x * tmp1.y + _ScaleNear;
                tmp1.yz = v.texcoord.xy - float2(0.5, 0.5);
                tmp1.yz = tmp1.yz * float2(_Width.x, _Height.x);
                tmp1.xy = tmp1.yz * tmp1.xx;
                tmp1.z = 0.0;
                tmp1.xyz = tmp1.xyz + v.vertex.xyz;
                tmp2 = unity_ObjectToWorld._m13_m13_m13_m13 * unity_MatrixV._m01_m11_m21_m31;
                tmp2 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp2;
                tmp2 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp2;
                tmp2 = unity_MatrixV._m03_m23_m13_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp2.xzyw;
                tmp0.yw = tmp2.xz;
                tmp1.w = v.vertex.w;
                tmp0.z = dot(tmp0.xy, tmp1.xy);
                tmp3 = tmp0.zzzz * UNITY_MATRIX_P._m01_m11_m21_m31;
                tmp4.x = unity_WorldToObject._m00;
                tmp4.y = unity_WorldToObject._m01;
                tmp4.z = unity_WorldToObject._m02;
                tmp0.z = dot(tmp4.xyz, tmp4.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.x = -1.0 / tmp0.z;
                tmp0.x = dot(tmp0.xy, tmp1.xy);
                tmp0 = UNITY_MATRIX_P._m00_m10_m20_m30 * tmp0.xxxx + tmp3;
                tmp3.x = unity_WorldToObject._m20;
                tmp3.y = unity_WorldToObject._m21;
                tmp3.z = unity_WorldToObject._m22;
                tmp3.x = dot(tmp3.xyz, tmp3.xyz);
                tmp3.x = sqrt(tmp3.x);
                tmp2.x = -1.0 / tmp3.x;
                tmp3.x = dot(tmp2.xy, v.vertex.xy);
                tmp0 = UNITY_MATRIX_P._m02_m12_m22_m32 * tmp3.xxxx + tmp0;
                tmp3.x = unity_ObjectToWorld._m10 * unity_MatrixV._m31;
                tmp3.x = unity_MatrixV._m30 * unity_ObjectToWorld._m00 + tmp3.x;
                tmp3.x = unity_MatrixV._m32 * unity_ObjectToWorld._m20 + tmp3.x;
                tmp2.x = unity_MatrixV._m33 * unity_ObjectToWorld._m30 + tmp3.x;
                tmp3.x = unity_ObjectToWorld._m11 * unity_MatrixV._m31;
                tmp3.x = unity_MatrixV._m30 * unity_ObjectToWorld._m01 + tmp3.x;
                tmp3.x = unity_MatrixV._m32 * unity_ObjectToWorld._m21 + tmp3.x;
                tmp2.z = unity_MatrixV._m33 * unity_ObjectToWorld._m31 + tmp3.x;
                tmp3.x = unity_ObjectToWorld._m12 * unity_MatrixV._m31;
                tmp3.x = unity_MatrixV._m30 * unity_ObjectToWorld._m02 + tmp3.x;
                tmp3.x = unity_MatrixV._m32 * unity_ObjectToWorld._m22 + tmp3.x;
                tmp2.y = unity_MatrixV._m33 * unity_ObjectToWorld._m32 + tmp3.x;
                tmp1.x = dot(tmp2, tmp1);
                o.position = UNITY_MATRIX_P._m03_m13_m23_m33 * tmp1.xxxx + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.color = v.color;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x / _TransitionDistance;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _Falloff;
                tmp0.x = exp(tmp0.x);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.yzw = _ColorFar.xyz - _ColorNear.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + _ColorNear.xyz;
                tmp1.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1.xyz = tmp1.xyz * inp.color.xyz;
                tmp1.xyz = tmp1.xyz * _TintColor.xyz;
                o.sv_target.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}