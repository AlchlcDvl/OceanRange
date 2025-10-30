Shader "SR/FX/Alpha Clip Screen Space" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
		[MaterialToggle] _OpacityfromGrey ("Opacity from Grey", Float) = 0
		_Emission ("Emission", Color) = (0.25,0.25,0.25,1)
		_Alpha ("Alpha", Range(0, 1)) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "DisableBatching" = "true" "QUEUE" = "Overlay+1" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay+1" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 31076
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _MainTex_ST;
			float4 _TintColor;
			float _OpacityfromGrey;
			float4 _Emission;
			float _Alpha;
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
                o.position = v.vertex;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                o.texcoord = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.color = v.color;
                tmp0.y = tmp0.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp0.x + tmp0.y;
                tmp0.x = unity_MatrixV._m22 * tmp0.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp0.w + tmp0.x;
                o.texcoord2.z = -tmp0.x;
                tmp0.x = v.vertex.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = v.vertex.xw * float2(0.5, 0.5);
                o.texcoord2.xy = tmp0.zz + tmp0.xw;
                o.texcoord2.w = v.vertex.w;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp1 = tmp0 * inp.color;
                tmp0.xyz = saturate(tmp0.xyz + _OpacityfromGrey.xxx);
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp0.xyz = tmp0.xyz * _TintColor.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp1 = tmp1 * _TintColor;
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, float3(0.3, 0.59, 0.11));
                tmp1.x = 1.0 - _OpacityfromGrey;
                tmp1.x = tmp1.x * tmp1.w;
                tmp0.w = saturate(tmp0.w * _OpacityfromGrey + tmp1.x);
                tmp0.w = tmp0.w - 0.5;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.www * _LightColor0.xyz + tmp1.xyz;
                tmp2.xyz = _Emission.www * _Emission.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp2.xyz;
                o.sv_target.w = _Alpha;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}