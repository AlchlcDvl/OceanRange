Shader "SR/Actor, Vac (Glass, Inside)" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Normal ("Normal", 2D) = "bump" {}
		_Detail ("Detail", 2D) = "white" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Cull Front
			GpuProgramID 3971
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
                tmp0.xyz = v.normal.xyz * float3(-0.0005, -0.0005, -0.0005) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(-v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(-v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(-v.normal.xyz, unity_WorldToObject._m02_m12_m22);
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
                tmp0.w = max(tmp0.y, -1.0);
                tmp0.w = min(tmp0.w, 0.0);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp1.xy = abs(tmp0.xz) * abs(tmp0.xz);
                tmp0.w = tmp1.x * 0.5 + tmp0.w;
                tmp0.w = tmp1.y * 0.5 + tmp0.w;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.w = dot(tmp0.xyz, tmp1.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = tmp0.w * tmp1.w;
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
                tmp2.xyz = tmp2.xyz + tmp4.xyz;
                tmp4.xy = inp.texcoord.xy * _Detail_ST.xy + _Detail_ST.zw;
                tmp4 = tex2D(_Detail, tmp4.xy);
                tmp2.xyz = tmp2.xyz + tmp4.www;
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
                tmp0.xyz = tmp1.xyz * tmp4.www + tmp0.yzw;
                o.sv_target.xyz = tmp2.xyz + tmp0.xyz;
                o.sv_target.w = tmp2.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend One One, One One
			ZWrite Off
			Cull Front
			GpuProgramID 104171
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
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
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
			sampler2D _LightTexture0;
			sampler2D _Detail;
			sampler2D _MainTex;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = v.normal.xyz * float3(-0.0005, -0.0005, -0.0005) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = tmp0;
                tmp1.x = dot(-v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(-v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(-v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord3.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord4.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
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
                tmp0.w = max(tmp0.y, -1.0);
                tmp0.w = min(tmp0.w, 0.0);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp1.xy = abs(tmp0.xz) * abs(tmp0.xz);
                tmp0.w = tmp1.x * 0.5 + tmp0.w;
                tmp0.w = tmp1.y * 0.5 + tmp0.w;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.w = dot(tmp0.xyz, tmp1.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.w = dot(-tmp1.xyz, tmp0.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp2.xyz = tmp0.xyz * -tmp1.www + -tmp1.xyz;
                tmp3.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp3.xyz;
                tmp1.w = dot(tmp3.xyz, tmp2.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * 22.62742;
                tmp1.w = exp(tmp1.w);
                tmp1.w = min(tmp1.w, 1.0);
                tmp0.w = tmp0.w * _LightColor0.x + tmp1.w;
                tmp1.w = dot(inp.texcoord5.xyz, inp.texcoord5.xyz);
                tmp2 = tex2D(_LightTexture0, tmp1.ww);
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xyz = tmp2.xxx * _LightColor0.xyz;
                tmp0.w = saturate(tmp0.w * 1.333333 + -0.3333333);
                tmp4.xy = tmp0.yy * unity_MatrixV._m01_m11;
                tmp4.xy = unity_MatrixV._m00_m10 * tmp0.xx + tmp4.xy;
                tmp4.xy = unity_MatrixV._m02_m12 * tmp0.zz + tmp4.xy;
                tmp4.xy = tmp4.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp4.xy = tmp4.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp4 = tex2D(_MainTex, tmp4.xy);
                tmp0.w = tmp0.w + tmp4.x;
                tmp4.xy = inp.texcoord.xy * _Detail_ST.xy + _Detail_ST.zw;
                tmp4 = tex2D(_Detail, tmp4.xy);
                tmp0.w = tmp0.w + tmp4.w;
                tmp1.w = dot(-tmp3.xyz, tmp0.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp4.xyz = tmp0.xyz * -tmp1.www + -tmp3.xyz;
                tmp0.x = dot(tmp0.xyz, tmp3.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.xyz = tmp2.xyz * tmp0.xxx;
                tmp1.x = dot(tmp4.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * 11.31371;
                tmp1.x = exp(tmp1.x);
                tmp1.xyz = tmp1.xxx * tmp2.xyz;
                tmp0.xyz = tmp0.xyz * tmp4.www + tmp1.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 190639
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xyz = v.normal.xyz * float3(-0.0005, -0.0005, -0.0005) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                tmp0.x = dot(-v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(-v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(-v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}