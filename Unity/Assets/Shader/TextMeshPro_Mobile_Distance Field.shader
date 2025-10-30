// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "TextMeshPro/Mobile/Distance Field" {
	Properties {
		_FaceColor ("Face Color", Color) = (1,1,1,1)
		_FaceDilate ("Face Dilate", Range(-1, 1)) = 0
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_OutlineWidth ("Outline Thickness", Range(0, 1)) = 0
		_OutlineSoftness ("Outline Softness", Range(0, 1)) = 0
		_UnderlayColor ("Border Color", Color) = (0,0,0,0.5)
		_UnderlayOffsetX ("Border OffsetX", Range(-1, 1)) = 0
		_UnderlayOffsetY ("Border OffsetY", Range(-1, 1)) = 0
		_UnderlayDilate ("Border Dilate", Range(-1, 1)) = 0
		_UnderlaySoftness ("Border Softness", Range(0, 1)) = 0
		_WeightNormal ("Weight Normal", Float) = 0
		_WeightBold ("Weight Bold", Float) = 0.5
		_ShaderFlags ("Flags", Float) = 0
		_ScaleRatioA ("Scale RatioA", Float) = 1
		_ScaleRatioB ("Scale RatioB", Float) = 1
		_ScaleRatioC ("Scale RatioC", Float) = 1
		_MainTex ("Font Atlas", 2D) = "white" {}
		_TextureWidth ("Texture Width", Float) = 512
		_TextureHeight ("Texture Height", Float) = 512
		_GradientScale ("Gradient Scale", Float) = 5
		_ScaleX ("Scale X", Float) = 1
		_ScaleY ("Scale Y", Float) = 1
		_PerspectiveFilter ("Perspective Correction", Range(0, 1)) = 0.875
		_VertexOffsetX ("Vertex OffsetX", Float) = 0
		_VertexOffsetY ("Vertex OffsetY", Float) = 0
		_ClipRect ("Clip Rect", Vector) = (-32767,-32767,32767,32767)
		_MaskSoftnessX ("Mask SoftnessX", Float) = 0
		_MaskSoftnessY ("Mask SoftnessY", Float) = 0
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255
		_ColorMask ("Color Mask", Float) = 15
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			ColorMask 0
			ZWrite Off
			Cull Off
			Stencil {
				ReadMask 0
				WriteMask 0
				Comp [Disabled]
				Pass Keep
				Fail Keep
				ZFail Keep
			}
			Fog {
				Mode 0
			}
			GpuProgramID 57736
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 color : COLOR0;
				float4 color1 : COLOR1;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _FaceColor;
			float _FaceDilate;
			float _OutlineSoftness;
			float4 _OutlineColor;
			float _OutlineWidth;
			float _WeightNormal;
			float _WeightBold;
			float _ScaleRatioA;
			float _VertexOffsetX;
			float _VertexOffsetY;
			float4 _ClipRect;
			float _MaskSoftnessX;
			float _MaskSoftnessY;
			float _GradientScale;
			float _ScaleX;
			float _ScaleY;
			float _PerspectiveFilter;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xy = v.vertex.xy + float2(_VertexOffsetX.x, _VertexOffsetY.x);
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp1;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                o.position = tmp2;
                tmp3 = v.color * _FaceColor;
                tmp3.xyz = tmp3.www * tmp3.xyz;
                o.color = tmp3;
                tmp4.w = v.color.w * _OutlineColor.w;
                tmp4.xyz = tmp4.www * _OutlineColor.xyz;
                tmp4 = tmp4 - tmp3;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(tmp2.xyz, tmp1.xyz);
                tmp1.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp1.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp1.xy;
                tmp1.xy = abs(tmp1.xy) * float2(_ScaleX.x, _ScaleY.x);
                tmp1.xy = tmp2.ww / tmp1.xy;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp1.xy = float2(_MaskSoftnessX.x, _MaskSoftnessY.x) * float2(0.25, 0.25) + tmp1.xy;
                o.texcoord2.zw = float2(0.25, 0.25) / tmp1.xy;
                tmp0.w = rsqrt(tmp0.w);
                tmp1.x = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = tmp0.w * 1.5;
                tmp1.y = 1.0 - _PerspectiveFilter;
                tmp1.y = tmp1.y * abs(tmp1.x);
                tmp0.w = tmp0.w * 1.5 + -tmp1.y;
                tmp0.z = abs(tmp0.z) * tmp0.w + tmp1.y;
                tmp0.w = UNITY_MATRIX_P._m33 == 0.0;
                tmp0.z = tmp0.w ? tmp0.z : tmp1.x;
                tmp0.w = _OutlineSoftness * _ScaleRatioA;
                tmp0.w = tmp0.w * tmp0.z + 1.0;
                tmp1.x = tmp0.z / tmp0.w;
                tmp0.z = _OutlineWidth * _ScaleRatioA;
                tmp0.z = tmp0.z * 0.5;
                tmp0.w = tmp1.x * tmp0.z;
                tmp0.w = tmp0.w + tmp0.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = sqrt(tmp0.w);
                o.color1 = tmp0.wwww * tmp4 + tmp3;
                tmp2 = max(_ClipRect, float4(-20000000000.0, -20000000000.0, -20000000000.0, -20000000000.0));
                tmp2 = min(tmp2, float4(20000000000.0, 20000000000.0, 20000000000.0, 20000000000.0));
                tmp1.yz = tmp0.xy - tmp2.xy;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + -tmp2.xy;
                o.texcoord2.xy = tmp0.xy - tmp2.zw;
                tmp0.xy = tmp2.zw - tmp2.xy;
                o.texcoord.zw = tmp1.yz / tmp0.xy;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = v.texcoord1.y <= 0.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.y = _WeightBold - _WeightNormal;
                tmp0.x = tmp0.x * tmp0.y + _WeightNormal;
                tmp0.x = tmp0.x * 0.25 + _FaceDilate;
                tmp0.x = tmp0.x * _ScaleRatioA;
                tmp0.x = -tmp0.x * 0.5 + 0.5;
                tmp1.w = tmp0.x * tmp1.x + -0.5;
                o.texcoord1.y = -tmp0.z * tmp1.x + tmp1.w;
                o.texcoord1.z = tmp0.z * tmp1.x + tmp1.w;
                o.texcoord1.xw = tmp1.xw;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = saturate(tmp0.w * inp.texcoord1.x + -inp.texcoord1.w);
                o.sv_target = tmp0.xxxx * inp.color;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "TMPro.EditorUtilities.TMP_SDFShaderGUI"
}