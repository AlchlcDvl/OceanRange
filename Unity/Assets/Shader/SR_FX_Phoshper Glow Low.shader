// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "SR/FX/Phoshper Glow Low" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("MainTex", 2D) = "white" {}
	}
	SubShader {
		Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent+1500" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent+1500" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ColorMask RGB
			ZWrite Off
			GpuProgramID 29462
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _Color;
			float4 _MainTex_ST;
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
                tmp0.x = unity_WorldToObject._m10;
                tmp0.y = unity_WorldToObject._m11;
                tmp0.z = unity_WorldToObject._m12;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.z = -1.0 / tmp0.x;
                tmp1 = unity_ObjectToWorld._m13_m13_m13_m13 * unity_MatrixV._m01_m11_m21_m31;
                tmp1 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = unity_MatrixV._m03_m23_m13_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1.xzyw;
                tmp0.yw = tmp1.xz;
                tmp0.z = dot(tmp0.xy, v.vertex.xy);
                tmp2 = tmp0.zzzz * UNITY_MATRIX_P._m01_m11_m21_m31;
                tmp3.x = unity_WorldToObject._m00;
                tmp3.y = unity_WorldToObject._m01;
                tmp3.z = unity_WorldToObject._m02;
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.x = -1.0 / tmp0.z;
                tmp0.x = dot(tmp0.xy, v.vertex.xy);
                tmp0 = UNITY_MATRIX_P._m00_m10_m20_m30 * tmp0.xxxx + tmp2;
                tmp2.x = unity_WorldToObject._m20;
                tmp2.y = unity_WorldToObject._m21;
                tmp2.z = unity_WorldToObject._m22;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2.x = sqrt(tmp2.x);
                tmp1.x = -1.0 / tmp2.x;
                tmp2.x = dot(tmp1.xy, v.vertex.xy);
                tmp0 = UNITY_MATRIX_P._m02_m12_m22_m32 * tmp2.xxxx + tmp0;
                tmp2.x = unity_ObjectToWorld._m10 * unity_MatrixV._m31;
                tmp2.x = unity_MatrixV._m30 * unity_ObjectToWorld._m00 + tmp2.x;
                tmp2.x = unity_MatrixV._m32 * unity_ObjectToWorld._m20 + tmp2.x;
                tmp1.x = unity_MatrixV._m33 * unity_ObjectToWorld._m30 + tmp2.x;
                tmp2.x = unity_ObjectToWorld._m11 * unity_MatrixV._m31;
                tmp2.x = unity_MatrixV._m30 * unity_ObjectToWorld._m01 + tmp2.x;
                tmp2.x = unity_MatrixV._m32 * unity_ObjectToWorld._m21 + tmp2.x;
                tmp1.z = unity_MatrixV._m33 * unity_ObjectToWorld._m31 + tmp2.x;
                tmp2.x = unity_ObjectToWorld._m12 * unity_MatrixV._m31;
                tmp2.x = unity_MatrixV._m30 * unity_ObjectToWorld._m02 + tmp2.x;
                tmp2.x = unity_MatrixV._m32 * unity_ObjectToWorld._m22 + tmp2.x;
                tmp1.y = unity_MatrixV._m33 * unity_ObjectToWorld._m32 + tmp2.x;
                tmp1.x = dot(tmp1, v.vertex);
                o.position = UNITY_MATRIX_P._m03_m13_m23_m33 * tmp1.xxxx + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp0.x = tmp0.x * 0.8;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.yz = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.yz);
                tmp1 = tmp1 * _Color;
                tmp0.x = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}