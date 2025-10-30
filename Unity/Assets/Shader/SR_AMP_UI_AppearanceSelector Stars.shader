Shader "SR/AMP/UI/AppearanceSelector Stars" {
	Properties {
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255
		_ColorMask ("Color Mask", Float) = 15
		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_Stars ("Stars", 2D) = "white" {}
		_Ramp ("Ramp", 2D) = "white" {}
		_Background ("Background", 2D) = "white" {}
		[HideInInspector] _texcoord ("", 2D) = "white" {}
	}
	SubShader {
		Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "Default"
			Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask 0
			ZWrite Off
			Cull Off
			Stencil {
				ReadMask 0
				WriteMask 0
				CompFront [Disabled]
				PassFront Keep
				FailFront Keep
				ZFailFront Keep
			}
			GpuProgramID 11250
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Color;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Background_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Background;
			sampler2D _Stars;
			sampler2D _Ramp;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = v.vertex;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = _Time * float4(-0.06, 0.06, -0.0075, 0.01875);
                tmp1.xy = inp.texcoord.xy * float2(0.62, 0.62) + tmp0.yx;
                tmp0 = inp.texcoord.xyxy * float4(0.43, -0.43, 1.9, 1.9) + tmp0;
                tmp1 = tex2D(_Stars, tmp1.xy);
                tmp2 = tex2D(_Stars, tmp0.xy);
                tmp0 = tex2D(_Stars, tmp0.zw);
                tmp0.x = tmp1.z * tmp2.z;
                tmp0.x = tmp0.x * 0.8 + 0.1;
                tmp0.z = 1.0 - tmp0.x;
                tmp0.w = tmp0.y - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.w = -tmp0.w * tmp0.z + 1.0;
                tmp1.x = dot(tmp0.xy, tmp0.xy);
                tmp0.y = tmp0.y > 0.5;
                tmp0.y = saturate(tmp0.y ? tmp0.w : tmp1.x);
                tmp0.y = tmp0.y - 0.45;
                tmp0.y = saturate(tmp0.y * 9.999998);
                tmp0.w = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.w;
                tmp0.y = min(tmp0.y, 0.7);
                tmp1.xyz = inp.texcoord.yyy * float3(2.13, 2.13, 3.0) + float3(-0.4, -0.6, -1.5);
                tmp0.w = tmp1.x * -0.4;
                tmp1.xy = saturate(tmp1.xy);
                tmp1.z = saturate(tmp1.z * -0.2 + 0.2);
                tmp1.xw = tmp1.xy * tmp1.xy;
                tmp1.y = tmp1.w * tmp1.y;
                tmp0.w = tmp1.x * tmp1.x + tmp0.w;
                tmp0.w = tmp0.w + 0.4;
                tmp0.y = tmp0.w * tmp0.y;
                tmp1.xw = inp.texcoord.xy * float2(1.5, 1.5);
                tmp1.xw = _Time.yy * float2(-0.005, 0.0125) + tmp1.xw;
                tmp2 = tex2D(_Stars, tmp1.xw);
                tmp0.x = dot(tmp0.xy, tmp2.xy);
                tmp0.w = tmp2.x - 0.5;
                tmp1.x = tmp2.x > 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.z = -tmp0.w * tmp0.z + 1.0;
                tmp0.x = saturate(tmp1.x ? tmp0.z : tmp0.x);
                tmp0.x = tmp1.y * tmp0.x + -0.45;
                tmp0.x = saturate(tmp0.x * 9.999998);
                tmp0.z = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.w = tmp0.x * tmp0.z;
                tmp0.w = tmp0.y * 0.9 + tmp0.w;
                tmp0.y = tmp0.y * 0.9 + tmp1.z;
                tmp0.x = tmp0.z * tmp0.x + tmp0.y;
                tmp0.y = 0.5;
                tmp1 = tex2D(_Ramp, tmp0.xy);
                tmp0.xy = inp.texcoord.xy * _Background_ST.xy + _Background_ST.zw;
                tmp2 = tex2D(_Background, tmp0.xy);
                tmp0.xyz = tmp1.xyz - tmp2.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz + tmp2.xyz;
                o.sv_target.w = tmp2.w;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}