Shader "SR/FX/RadBurn ScreenSpace" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("MainTex", 2D) = "white" {}
		_Refraction ("Refraction", 2D) = "white" {}
		_RefractionStrength ("Refraction Strength", Range(0, 2)) = 1
		_AberationStrength ("Aberation Strength", Range(0, 2)) = 1
	}
	SubShader {
		LOD 550
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay-500" "RenderType" = "Overlay" }
		GrabPass {
		}
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay-500" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			ZTest Always
			ZWrite Off
			Cull Off
			Offset 1, -100
			GpuProgramID 18631
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
			float4 _Refraction_ST;
			float _AberationStrength;
			float _RefractionStrength;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _GrabTexture;
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.x = _ProjectionParams.x * -_ProjectionParams.x;
                tmp1.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1.z = tmp0.x * tmp1.y;
                tmp0.xy = tmp1.xz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0.z = _TimeEditor.y + _Time.y;
                tmp1 = tmp0.zzzz * float4(0.05, 0.1, -0.05, 0.05) + tmp0.xyxy;
                tmp0.zw = tmp0.zz * float2(0.5, 0.25);
                tmp1 = tmp1 * _Refraction_ST + _Refraction_ST;
                tmp2 = tex2D(_Refraction, tmp1.xy);
                tmp1 = tex2D(_Refraction, tmp1.zw);
                tmp1.xy = tmp1.xy * tmp2.xy;
                tmp1.yz = tmp1.xy * _Color.ww;
                tmp1.w = _RefractionStrength * 0.025;
                tmp0.xy = tmp1.yz * tmp1.ww + tmp0.xy;
                tmp1.yz = tmp0.xy - float2(0.5, 0.5);
                tmp0.z = sin(tmp0.z);
                tmp2.x = sin(tmp0.w);
                tmp3.x = cos(tmp0.w);
                tmp0.w = _Color.w * _AberationStrength;
                tmp1.w = tmp0.w * 0.025;
                tmp0.w = tmp0.w * tmp0.z;
                tmp0.z = tmp0.z * tmp1.w;
                tmp4.x = sin(tmp0.z);
                tmp5.x = cos(tmp0.z);
                tmp6.z = tmp4.x;
                tmp6.y = tmp5.x;
                tmp6.x = -tmp4.x;
                tmp4.y = dot(tmp1.xy, tmp6.xy);
                tmp4.x = dot(tmp1.xy, tmp6.xy);
                tmp2.yz = tmp4.xy + float2(0.5, 0.5);
                tmp4 = tex2D(_GrabTexture, tmp2.yz);
                tmp0.z = tmp0.w * -0.0025 + 1.0;
                tmp2.yz = tmp0.ww * float2(-0.025, -0.00125);
                tmp0.zw = tmp0.xy * tmp0.zz + -tmp2.zz;
                tmp5 = tex2D(_GrabTexture, tmp0.xy);
                tmp0.x = sin(tmp2.y);
                tmp6.x = cos(tmp2.y);
                tmp7 = tex2D(_GrabTexture, tmp0.zw);
                tmp4.y = tmp7.y;
                tmp7.z = tmp0.x;
                tmp7.y = tmp6.x;
                tmp7.x = -tmp0.x;
                tmp0.y = dot(tmp1.xy, tmp7.xy);
                tmp0.x = dot(tmp1.xy, tmp7.xy);
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0 = tex2D(_GrabTexture, tmp0.xy);
                tmp4.x = tmp0.x;
                tmp0.xyz = tmp4.xyz - tmp5.xyz;
                tmp1.yz = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp1.y = tmp0.w * 1.25;
                tmp0.w = tmp0.w * 2.5 + -1.0;
                tmp0.xyz = tmp1.yyy * tmp0.xyz + tmp5.xyz;
                tmp4.z = tmp2.x;
                tmp4.y = tmp3.x;
                tmp4.x = -tmp2.x;
                tmp1.yz = inp.texcoord.xy - float2(0.5, 0.5);
                tmp2.x = dot(tmp1.xy, tmp4.xy);
                tmp2.y = dot(tmp1.xy, tmp4.xy);
                tmp1.yz = tmp2.xy + float2(0.5, 0.5);
                tmp1.yz = tmp1.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp1.yz);
                tmp2 = tmp2 * inp.color;
                tmp1.y = tmp2.w * _Color.w;
                tmp2.xyz = tmp2.xyz * _Color.xyz + float3(-1.0, -1.0, -1.0);
                tmp1.yzw = tmp1.yyy * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp1.yzw;
                tmp1.y = inp.texcoord.y * 0.5 + 0.25;
                tmp0.w = tmp0.w * tmp1.y;
                tmp1.y = tmp1.x * 0.2;
                tmp0.w = saturate(tmp0.w * tmp1.x + tmp1.y);
                tmp1.x = tmp0.w * 0.7142857 + -0.2142857;
                tmp1.x = max(tmp1.x, 0.0);
                tmp0.w = tmp0.w * 0.333 + tmp1.x;
                tmp1.xyz = tmp0.www * _Color.xyz;
                o.sv_target.xyz = tmp1.xyz * _Color.www + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/FX/RadBurn ScreenSpace NoRefraction"
	CustomEditor "ShaderForgeMaterialInspector"
}