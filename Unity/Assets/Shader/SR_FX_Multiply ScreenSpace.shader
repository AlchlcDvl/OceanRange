Shader "SR/FX/Multiply ScreenSpace" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_ColorAdditive ("Color Additive", Color) = (0,0,0,1)
	}
	SubShader {
		Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend DstColor Zero, DstColor Zero
			ZTest Always
			ZWrite Off
			Cull Off
			Offset 1, -100
			GpuProgramID 28976
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
			float4 _MainTex_ST;
			float4 _Color;
			float4 _ColorAdditive;
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
                o.position = v.vertex;
                o.color = v.color;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.y = tmp0.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp0.x + tmp0.y;
                tmp0.x = unity_MatrixV._m22 * tmp0.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp0.w + tmp0.x;
                o.texcoord.z = -tmp0.x;
                tmp0.x = v.vertex.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = v.vertex.xw * float2(0.5, 0.5);
                o.texcoord.xy = tmp0.zz + tmp0.xw;
                o.texcoord.w = v.vertex.w;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord.xy / inp.texcoord.ww;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tmp0 * inp.color;
                tmp1.xyz = _ColorAdditive.xyz * _ColorAdditive.www + _Color.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz + float3(-1.0, -1.0, -1.0);
                tmp0.w = tmp0.w * _Color.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz + float3(1.0, 1.0, 1.0);
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}