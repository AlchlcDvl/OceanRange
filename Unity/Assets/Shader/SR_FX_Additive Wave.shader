Shader "SR/FX/Additive Wave" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
		_RadialThickness ("Radial Thickness", Float) = 0.25
		_Exposure ("Exposure", Float) = 2
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 10298
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_ST;
			float4 _TintColor;
			float _RadialThickness;
			float _Exposure;
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
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
                tmp0.xy = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.y = 1.0 - tmp0.x;
                tmp0.z = _RadialThickness * 0.5;
                tmp0.z = inp.color.w * _TintColor.w + -tmp0.z;
                tmp0.y = max(tmp0.z, tmp0.y);
                tmp0.w = inp.color.w * _TintColor.w + _RadialThickness;
                tmp0.y = min(tmp0.w, tmp0.y);
                tmp0.w = tmp0.w - tmp0.z;
                tmp0.y = tmp0.y - tmp0.z;
                tmp0.y = saturate(tmp0.y / tmp0.w);
                tmp0.z = -inp.color.w * _TintColor.w + 1.0;
                tmp0.w = -_RadialThickness * 0.5 + tmp0.z;
                tmp0.z = tmp0.z + _RadialThickness;
                tmp0.x = max(tmp0.w, tmp0.x);
                tmp0.x = min(tmp0.z, tmp0.x);
                tmp0.z = tmp0.z - tmp0.w;
                tmp0.x = tmp0.x - tmp0.w;
                tmp0.x = saturate(tmp0.x / tmp0.z);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * 3.333333;
                tmp0.yz = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.yz);
                tmp0.yzw = tmp1.xyz * inp.color.xyz;
                tmp0.yzw = tmp0.yzw * _TintColor.xyz;
                tmp0.yzw = tmp0.yzw * _Exposure.xxx;
                tmp0.yzw = tmp0.yzw * tmp1.www;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}