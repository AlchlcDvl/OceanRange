Shader "SR/FX/Refraction" {
	Properties {
		_MainTex ("MainTex", 2D) = "black" {}
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Transparent+0" "RenderType" = "Transparent" }
		GrabPass {
			"_RefractionTransparent"
		}
		Pass {
			Name "FORWARD"
			Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+0" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
			ZWrite Off
			GpuProgramID 57680
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _RefractionTransparent;
			
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.zw = tmp0.zw;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
                o.color = v.color;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = inp.texcoord3.w + 0.0;
                tmp0.y = tmp0.x * 0.5;
                tmp0.z = -tmp0.x * 0.5 + inp.texcoord3.y;
                tmp1.y = -tmp0.z * _ProjectionParams.x + tmp0.y;
                tmp1.x = inp.texcoord3.x;
                tmp0.xy = tmp1.xy / tmp0.xx;
                tmp1.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1.zw = tmp1.xy + float2(0.1, 0.1);
                tmp2 = tex2D(_MainTex, tmp1.zy);
                tmp3 = tex2D(_MainTex, tmp1.xw);
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp3.y = tmp3.y - tmp1.y;
                tmp3.x = tmp2.y - tmp1.y;
                tmp2.xy = tmp3.xy * float2(0.5, 0.5);
                tmp2.z = 0.0;
                tmp2.xyz = float3(0.0, 0.0, 1.0) - tmp2.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp0.zw = tmp0.zz * tmp2.xy;
                tmp2.x = dot(inp.color.xyz, float3(0.299, 0.587, 0.114));
                tmp2.x = tmp2.x * inp.color.w;
                tmp0.xy = tmp0.zw * tmp2.xx + tmp0.xy;
                tmp0 = tex2D(_RefractionTransparent, tmp0.xy);
                o.sv_target.xyz = tmp0.xyz;
                tmp0.x = dot(tmp1.xyz, float3(0.299, 0.587, 0.114));
                tmp0.x = tmp0.x * tmp1.w + -0.025;
                tmp0.x = saturate(tmp0.x * 40.0);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                o.sv_target.w = tmp0.x * tmp0.y;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}