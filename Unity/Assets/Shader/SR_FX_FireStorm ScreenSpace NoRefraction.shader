Shader "SR/FX/FireStorm ScreenSpace NoRefraction" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_Refraction ("Refraction", 2D) = "white" {}
		_RefractionStrength ("Refraction Strength", Range(0, 2)) = 1
		_AberationStrength ("Aberation Strength", Range(0, 2)) = 1
		_Intensity ("Intensity", Float) = 5
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay-500" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Overlay-500" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZTest Always
			ZWrite Off
			Cull Off
			Offset 1, -100
			GpuProgramID 65497
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
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
			float4 _Color;
			float4 _Refraction_ST;
			float _Intensity;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Refraction;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                tmp0.y = v.vertex.y * _ProjectionParams.x;
                tmp0.xzw = v.vertex.xzw;
                o.position = tmp0;
                o.texcoord1 = tmp0;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                o.texcoord = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
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
                tmp0.x = inp.texcoord1.y / inp.texcoord1.w;
                tmp0.y = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.y = tmp0.z * tmp1.x + -tmp0.x;
                tmp0.x = tmp0.z * tmp1.x + tmp0.x;
                tmp2.yzw = tmp0.yzw * tmp1.xxx;
                tmp0.x = saturate(tmp0.x + 0.5);
                tmp0.y = tmp1.y + 0.5;
                tmp0.y = saturate(tmp0.y * 6.0);
                tmp0.y = tmp0.y * -0.5 + 1.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp2.x = tmp2.w + tmp2.y;
                tmp0.y = _TimeEditor.y + _Time.y;
                tmp1 = tmp0.yyyy * float4(0.5, 0.1, -0.5, 0.05) + tmp2.xzxz;
                tmp0.y = saturate(tmp2.z * 1.25 + 0.75);
                tmp1 = tmp1 * _Refraction_ST + _Refraction_ST;
                tmp2 = tex2D(_Refraction, tmp1.xy);
                tmp1 = tex2D(_Refraction, tmp1.zw);
                tmp0.z = saturate(-tmp2.x * tmp1.x + 1.0);
                tmp0.y = tmp0.z * 0.2 + tmp0.y;
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.z = tmp0.y * 0.7142857 + -0.2142857;
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.y = tmp0.y * 0.333 + tmp0.z;
                tmp0.y = tmp0.y * _Color.w;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = inp.color.w * _Color.w;
                tmp0.y = tmp0.y * 4.0 + -2.0;
                tmp0.y = tmp0.y * tmp0.x;
                o.sv_target.w = tmp0.y * _Intensity;
                tmp0.yzw = _Color.xyz * _Intensity.xxx;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}