// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "TextMeshPro/Distance Field" {
	Properties {
		_FaceTex ("Face Texture", 2D) = "white" {}
		_FaceUVSpeedX ("Face UV Speed X", Range(-5, 5)) = 0
		_FaceUVSpeedY ("Face UV Speed Y", Range(-5, 5)) = 0
		_FaceColor ("Face Color", Color) = (1,1,1,1)
		_FaceDilate ("Face Dilate", Range(-1, 1)) = 0
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_OutlineTex ("Outline Texture", 2D) = "white" {}
		_OutlineUVSpeedX ("Outline UV Speed X", Range(-5, 5)) = 0
		_OutlineUVSpeedY ("Outline UV Speed Y", Range(-5, 5)) = 0
		_OutlineWidth ("Outline Thickness", Range(0, 1)) = 0
		_OutlineSoftness ("Outline Softness", Range(-1, 1)) = 0
		_Bevel ("Bevel", Range(0, 1)) = 0.5
		_BevelOffset ("Bevel Offset", Range(-0.5, 0.5)) = 0
		_BevelWidth ("Bevel Width", Range(-0.5, 0.5)) = 0
		_BevelClamp ("Bevel Clamp", Range(0, 1)) = 0
		_BevelRoundness ("Bevel Roundness", Range(0, 1)) = 0
		_LightAngle ("Light Angle", Range(0, 6.2831855)) = 3.1416
		_SpecularColor ("Specular", Color) = (1,1,1,1)
		_SpecularPower ("Specular", Range(0, 4)) = 2
		_Reflectivity ("Reflectivity", Range(5, 15)) = 10
		_Diffuse ("Diffuse", Range(0, 1)) = 0.5
		_Ambient ("Ambient", Range(1, 0)) = 0.5
		_BumpMap ("Normal map", 2D) = "bump" {}
		_BumpOutline ("Bump Outline", Range(0, 1)) = 0
		_BumpFace ("Bump Face", Range(0, 1)) = 0
		_ReflectFaceColor ("Reflection Color", Color) = (0,0,0,1)
		_ReflectOutlineColor ("Reflection Color", Color) = (0,0,0,1)
		_Cube ("Reflection Cubemap", Cube) = "black" {}
		_EnvMatrixRotation ("Texture Rotation", Vector) = (0,0,0,0)
		_UnderlayColor ("Border Color", Color) = (0,0,0,0.5)
		_UnderlayOffsetX ("Border OffsetX", Range(-1, 1)) = 0
		_UnderlayOffsetY ("Border OffsetY", Range(-1, 1)) = 0
		_UnderlayDilate ("Border Dilate", Range(-1, 1)) = 0
		_UnderlaySoftness ("Border Softness", Range(0, 1)) = 0
		_GlowColor ("Color", Color) = (0,1,0,0.5)
		_GlowOffset ("Offset", Range(-1, 1)) = 0
		_GlowInner ("Inner", Range(0, 1)) = 0.05
		_GlowOuter ("Outer", Range(0, 1)) = 0.05
		_GlowPower ("Falloff", Range(1, 0)) = 0.75
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
		_MaskCoord ("Mask Coordinates", Vector) = (0,0,32767,32767)
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
			GpuProgramID 57834
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 color : COLOR0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 _EnvMatrix;
			float _FaceDilate;
			float _OutlineSoftness;
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
			float4 _FaceTex_ST;
			float4 _OutlineTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _FaceUVSpeedX;
			float _FaceUVSpeedY;
			float4 _FaceColor;
			float _OutlineUVSpeedX;
			float _OutlineUVSpeedY;
			float4 _OutlineColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _FaceTex;
			sampler2D _OutlineTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
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
                o.color = v.color;
                o.texcoord.xy = v.texcoord.xy;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.z = dot(tmp2.xyz, tmp3.xyz);
                tmp2.xy = _ScreenParams.yy * UNITY_MATRIX_P._m01_m11;
                tmp2.xy = UNITY_MATRIX_P._m00_m10 * _ScreenParams.xx + tmp2.xy;
                tmp2.xy = abs(tmp2.xy) * float2(_ScaleX.x, _ScaleY.x);
                tmp2.xy = tmp2.ww / tmp2.xy;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp2.xy = float2(_MaskSoftnessX.x, _MaskSoftnessY.x) * float2(0.25, 0.25) + tmp2.xy;
                o.texcoord2.zw = float2(0.25, 0.25) / tmp2.xy;
                tmp0.w = rsqrt(tmp0.w);
                tmp1.w = abs(v.texcoord1.y) * _GradientScale;
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.w = tmp0.w * 1.5;
                tmp2.x = 1.0 - _PerspectiveFilter;
                tmp2.x = abs(tmp1.w) * tmp2.x;
                tmp0.w = tmp0.w * 1.5 + -tmp2.x;
                tmp0.z = abs(tmp0.z) * tmp0.w + tmp2.x;
                tmp0.w = UNITY_MATRIX_P._m33 == 0.0;
                tmp2.y = tmp0.w ? tmp0.z : tmp1.w;
                tmp0.z = v.texcoord1.y <= 0.0;
                tmp0.z = tmp0.z ? 1.0 : 0.0;
                tmp0.w = _WeightBold - _WeightNormal;
                tmp0.z = tmp0.z * tmp0.w + _WeightNormal;
                tmp0.z = tmp0.z * 0.25 + _FaceDilate;
                tmp0.z = tmp0.z * _ScaleRatioA;
                tmp2.w = tmp0.z * 0.5;
                o.texcoord1.yw = tmp2.yw;
                tmp0.w = 0.5 / tmp2.y;
                tmp1.w = -_OutlineWidth * _ScaleRatioA + 1.0;
                tmp1.w = -_OutlineSoftness * _ScaleRatioA + tmp1.w;
                tmp1.w = tmp1.w * 0.5 + -tmp0.w;
                o.texcoord1.x = -tmp0.z * 0.5 + tmp1.w;
                tmp0.z = -tmp0.z * 0.5 + 0.5;
                o.texcoord1.z = tmp0.w + tmp0.z;
                tmp2 = max(_ClipRect, float4(-20000000000.0, -20000000000.0, -20000000000.0, -20000000000.0));
                tmp2 = min(tmp2, float4(20000000000.0, 20000000000.0, 20000000000.0, 20000000000.0));
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + -tmp2.xy;
                o.texcoord2.xy = tmp0.xy - tmp2.zw;
                tmp0.xyz = tmp1.yyy * _EnvMatrix._m01_m11_m21;
                tmp0.xyz = _EnvMatrix._m00_m10_m20 * tmp1.xxx + tmp0.xyz;
                o.texcoord3.xyz = _EnvMatrix._m02_m12_m22 * tmp1.zzz + tmp0.xyz;
                tmp0.x = v.texcoord1.x * 0.0002441;
                tmp0.z = floor(tmp0.x);
                tmp0.w = -tmp0.z * 4096.0 + v.texcoord1.x;
                tmp0.xy = tmp0.zw * float2(0.0019531, 0.0019531);
                o.texcoord5.xy = tmp0.xy * _FaceTex_ST.xy + _FaceTex_ST.zw;
                o.texcoord5.zw = tmp0.xy * _OutlineTex_ST.xy + _OutlineTex_ST.zw;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0.x = tmp0.w - inp.texcoord1.x;
                tmp0.y = inp.texcoord1.z - tmp0.w;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = _OutlineWidth * _ScaleRatioA;
                tmp0.x = tmp0.x * inp.texcoord1.y;
                tmp0.z = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x * 0.5;
                tmp0.z = sqrt(tmp0.z);
                tmp0.w = saturate(tmp0.y * inp.texcoord1.y + tmp0.x);
                tmp0.x = tmp0.y * inp.texcoord1.y + -tmp0.x;
                tmp0.y = tmp0.z * tmp0.w;
                tmp0.zw = float2(_OutlineUVSpeedX.x, _OutlineUVSpeedY.x) * _Time.yy + inp.texcoord5.zw;
                tmp1 = tex2D(_OutlineTex, tmp0.zw);
                tmp1 = tmp1 * _OutlineColor;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.xyz = inp.color.xyz * _FaceColor.xyz;
                tmp0.zw = float2(_FaceUVSpeedX.x, _FaceUVSpeedY.x) * _Time.yy + inp.texcoord5.xy;
                tmp3 = tex2D(_FaceTex, tmp0.zw);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp3.w = tmp3.w * _FaceColor.w;
                tmp3.xyz = tmp2.xyz * tmp3.www;
                tmp1 = tmp1 - tmp3;
                tmp1 = tmp0.yyyy * tmp1 + tmp3;
                tmp0.y = _OutlineSoftness * _ScaleRatioA;
                tmp0.z = tmp0.y * inp.texcoord1.y;
                tmp0.y = tmp0.y * inp.texcoord1.y + 1.0;
                tmp0.x = tmp0.z * 0.5 + tmp0.x;
                tmp0.x = saturate(tmp0.x / tmp0.y);
                tmp0.x = 1.0 - tmp0.x;
                tmp0 = tmp0.xxxx * tmp1;
                o.sv_target = tmp0 * inp.color.wwww;
                return o;
			}
			ENDCG
		}
	}
	Fallback "TextMeshPro/Mobile/Distance Field"
	CustomEditor "TMPro.EditorUtilities.TMP_SDFShaderGUI"
}