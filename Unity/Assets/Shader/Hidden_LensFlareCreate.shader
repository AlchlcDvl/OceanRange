Shader "Hidden/LensFlareCreate" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
	}
	SubShader {
		Pass {
			Blend One One, One One
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 54945
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 texcoord2 : TEXCOORD2;
				float2 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 colorA;
			float4 colorB;
			float4 colorC;
			float4 colorD;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
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
                tmp0 = v.texcoord.xyxy - float4(0.5, 0.5, 0.5, 0.5);
                o.texcoord.xy = tmp0.zw * float2(-0.85, -0.85) + float2(0.5, 0.5);
                o.texcoord1.xy = tmp0.zw * float2(-1.45, -1.45) + float2(0.5, 0.5);
                o.texcoord2.xy = tmp0.xy * float2(-2.55, -2.55) + float2(0.5, 0.5);
                o.texcoord3.xy = tmp0.zw * float2(-4.15, -4.15) + float2(0.5, 0.5);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0 = tmp0 * colorB;
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp1 * colorA + tmp0;
                tmp1 = tex2D(_MainTex, inp.texcoord2.xy);
                tmp0 = tmp1 * colorC + tmp0;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                o.sv_target = tmp1 * colorD + tmp0;
                return o;
			}
			ENDCG
		}
	}
}