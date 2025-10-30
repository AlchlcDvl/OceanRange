Shader "SR/FX/Additive Animated NoDepth" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_TintColor ("Color", Color) = (1,1,1,1)
		_TilesX ("Tiles X", Float) = 1
		_TilesY ("Tiles Y", Float) = 1
		_TilesOffset ("Tiles Offset", Float) = 0
		_AnimationSpeed ("Animation Speed", Float) = 1
		_TransitionDistance ("TransitionDistance", Float) = 5
		_Falloff ("Falloff", Float) = 20
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 29818
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
			float4 _TintColor;
			float _TilesX;
			float _TilesY;
			float _TilesOffset;
			float _AnimationSpeed;
			float _TransitionDistance;
			float _Falloff;
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
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
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
                tmp0.xyz = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x / _TransitionDistance;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _Falloff;
                tmp0.x = exp(tmp0.x);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = _TimeEditor.y + _Time.y;
                tmp0.y = tmp0.y * _AnimationSpeed;
                tmp0.y = frac(tmp0.y);
                tmp0.z = _TilesY * _TilesX;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y + _TilesOffset;
                tmp0.zw = float2(1.0, 1.0) / float2(_TilesX.x, _TilesY.x);
                tmp1.x = tmp0.z * tmp0.y;
                tmp1.y = floor(tmp1.x);
                tmp1.x = -_TilesX * tmp1.y + tmp0.y;
                tmp1.xy = tmp1.xy + inp.texcoord.xy;
                tmp0.yz = tmp0.zw * tmp1.xy;
                tmp0.yz = tmp0.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.yz);
                tmp1 = tmp1 * inp.color;
                tmp1 = tmp1 * _TintColor;
                tmp0.x = tmp0.x * tmp1.w;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}