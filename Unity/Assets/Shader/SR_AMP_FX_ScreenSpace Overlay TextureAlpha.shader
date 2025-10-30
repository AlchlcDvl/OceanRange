Shader "SR/AMP/FX/ScreenSpace Overlay TextureAlpha" {
	Properties {
		[NoScaleOffset] _MainTexture ("MainTexture", 2D) = "black" {}
		_Color ("Color", Color) = (1,1,1,0.5019608)
	}
	SubShader {
		LOD 100
		Tags { "Overlay" = "Overlay" "RenderType" = "Opaque" }
		Pass {
			Name "Unlit"
			LOD 100
			Tags { "Overlay" = "Overlay" "RenderType" = "Opaque" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			AlphaToMask On
			ZTest Always
			ZWrite Off
			GpuProgramID 57384
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 color : COLOR0;
				float4 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTexture;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.yzw = tmp0.yyy * unity_CameraInvProjection._m01_m11_m21;
                tmp0.xyz = unity_CameraInvProjection._m00_m10_m20 * tmp0.xxx + tmp0.yzw;
                tmp0.xyz = tmp0.xyz + unity_CameraInvProjection._m03_m13_m23;
                tmp1 = tmp0.yyyy * unity_MatrixInvV._m01_m11_m21_m31;
                tmp1 = unity_MatrixInvV._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_MatrixInvV._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_MatrixInvV._m03_m13_m23_m33;
                tmp1.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp1.xyz = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                tmp0.xyz = unity_WorldToObject._m03_m13_m23 * tmp0.www + tmp0.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord.zw = float2(0.0, 0.0);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.y = _ScreenParams.y / _ScreenParams.x;
                tmp0.zw = inp.texcoord.xy - float2(0.5, 0.5);
                tmp0.x = 1.0;
                tmp0.xy = tmp0.zw * tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_MainTexture, tmp0.xy);
                tmp1 = inp.color * _Color;
                o.sv_target = tmp0 * tmp1;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}