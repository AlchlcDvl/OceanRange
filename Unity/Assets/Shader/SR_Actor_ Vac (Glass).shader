Shader "SR/Actor, Vac (Glass)" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Normal ("Normal", 2D) = "bump" {}
		_Detail ("Detail", 2D) = "black" {}
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 63463
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _MainTex_ST;
			float4 _Normal_ST;
			float4 _Detail_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _Detail;
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
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
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.xyz = tmp1.yyy * inp.texcoord4.xyz;
                tmp2.xyz = tmp1.xxx * inp.texcoord3.xyz + tmp2.xyz;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = sqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz + tmp2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = saturate(tmp0.y);
                tmp1.xy = abs(tmp0.xz) * abs(tmp0.xz);
                tmp1.x = tmp1.x * 0.25;
                tmp0.w = tmp0.w * tmp0.w + tmp1.x;
                tmp0.w = tmp1.y * 0.25 + tmp0.w;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.w = dot(tmp0.xyz, tmp1.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp0.w = saturate(tmp0.w * tmp1.w);
                tmp1.w = dot(-tmp1.xyz, tmp0.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp2.xyz = tmp0.xyz * -tmp1.www + -tmp1.xyz;
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp3.xyz, tmp2.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * 22.62742;
                tmp1.w = exp(tmp1.w);
                tmp1.w = min(tmp1.w, 1.0);
                tmp2.xyz = tmp0.www * _LightColor0.xyz + tmp1.www;
                tmp2.xyz = saturate(tmp2.xyz * float3(1.333333, 1.333333, 1.333333) + float3(-0.3333333, -0.3333333, -0.3333333));
                tmp4.xy = tmp0.yy * unity_MatrixV._m01_m11;
                tmp4.xy = unity_MatrixV._m00_m10 * tmp0.xx + tmp4.xy;
                tmp4.xy = unity_MatrixV._m02_m12 * tmp0.zz + tmp4.xy;
                tmp4.xy = tmp4.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp4.xy = tmp4.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp4.xy);
                tmp5.xy = inp.texcoord.xy * _Detail_ST.xy + _Detail_ST.zw;
                tmp5 = tex2D(_Detail, tmp5.xy);
                tmp6.xyz = tmp5.xyz - tmp4.xyz;
                tmp4.xyz = tmp5.www * tmp6.xyz + tmp4.xyz;
                tmp5.xyz = saturate(tmp5.www * tmp5.xyz);
                tmp2.xyz = saturate(tmp2.xyz + tmp4.xyz);
                tmp0.w = dot(-tmp3.xyz, tmp0.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp4.xyz = tmp0.xyz * -tmp0.www + -tmp3.xyz;
                tmp0.x = dot(tmp0.xyz, tmp3.xyz);
                tmp0.y = dot(tmp4.xyz, tmp1.xyz);
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * 11.31371;
                tmp0.y = exp(tmp0.y);
                tmp0.yzw = tmp0.yyy * _LightColor0.xyz;
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.xxx * _LightColor0.xyz + tmp1.xyz;
                tmp0.xyz = tmp1.xyz * tmp5.xyz + tmp0.yzw;
                o.sv_target.xyz = tmp2.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}