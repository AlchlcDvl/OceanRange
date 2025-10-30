Shader "SR/FX/RadBurn ScreenSpace NoRefraction" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("MainTex", 2D) = "white" {}
		_Refraction ("Refraction", 2D) = "white" {}
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay-500" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay-500" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZTest Always
			ZWrite Off
			Cull Off
			Offset 1, -100
			GpuProgramID 40989
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _MainTex_ST;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Refraction;
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                o.position = v.vertex;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = v.vertex;
                o.color = v.color;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xy = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 2.5 + -1.0;
                tmp0.y = inp.texcoord.y * 0.5 + 0.25;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = _ProjectionParams.x * -_ProjectionParams.x;
                tmp1.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1.z = tmp0.y * tmp1.y;
                tmp1 = tmp1.xzxz * float4(0.5, 0.5, 0.5, 0.5) + float4(0.5, 0.5, 0.5, 0.5);
                tmp0.y = _TimeEditor.y + _Time.y;
                tmp1 = tmp0.yyyy * float4(0.05, 0.1, -0.05, 0.05) + tmp1;
                tmp0.y = tmp0.y * 0.25;
                tmp2.x = sin(tmp0.y);
                tmp3.x = cos(tmp0.y);
                tmp4 = tex2D(_Refraction, tmp1.xy);
                tmp1 = tex2D(_Refraction, tmp1.zw);
                tmp0.y = tmp1.x * tmp4.x;
                tmp0.z = tmp0.y * 0.2;
                tmp0.x = saturate(tmp0.x * tmp0.y + tmp0.z);
                tmp0.y = tmp0.x * 0.7142857 + -0.2142857;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.x = tmp0.x * 0.333 + tmp0.y;
                tmp0.xyz = tmp0.xxx * _Color.xyz;
                tmp1.z = tmp2.x;
                tmp1.y = tmp3.x;
                tmp1.x = -tmp2.x;
                tmp2.xy = inp.texcoord.xy - float2(0.5, 0.5);
                tmp3.x = dot(tmp2.xy, tmp1.xy);
                tmp3.y = dot(tmp2.xy, tmp1.xy);
                tmp1.xy = tmp3.xy + float2(0.5, 0.5);
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tmp1 * inp.color;
                tmp1 = tmp1 * _Color;
                tmp1.xyz = tmp1.xyz * tmp1.www;
                o.sv_target.xyz = tmp0.xyz * _Color.www + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}