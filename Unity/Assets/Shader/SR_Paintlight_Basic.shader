Shader "SR/Paintlight/Basic" {
	Properties {
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		_Depth ("Depth", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 17316
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _PrimaryTex;
			sampler2D _Depth;
			
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
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = saturate(tmp1.y);
                tmp0.z = dot(abs(tmp1.xy), float2(0.333, 0.333));
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = tmp0.y * 0.33 + 0.33;
                tmp0.y = tmp0.y * 13.0 + -6.0;
                tmp0.y = max(tmp0.y, 0.75);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.zw = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp2 = tex2D(_Depth, tmp0.zw);
                tmp0.xzw = tmp0.xxx * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.334, 0.334, 0.334) + float3(0.333, 0.333, 0.333);
                tmp3.xyz = tmp0.xzw + tmp0.xzw;
                tmp0.xyz = tmp0.xzw * float3(0.333, 0.333, 0.333) + tmp0.yyy;
                tmp0.xyz = tmp0.xyz * _LightColor0.xyz;
                tmp3.xyz = floor(tmp3.xyz);
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp4.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = -tmp1.x * 2.0 + 1.0;
                tmp1.yzw = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp1.xyz = -tmp1.xxx * tmp1.yzw + float3(1.0, 1.0, 1.0);
                tmp1.w = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w > 0.5;
                tmp2.xyz = tmp2.xyz * tmp1.www;
                tmp1.xyz = saturate(tmp0.www ? tmp1.xyz : tmp2.xyz);
                tmp1.xyz = tmp1.xyz * float3(13.0, 13.0, 13.0) + tmp3.xyz;
                tmp1.xyz = saturate(tmp1.xyz - float3(6.0, 6.0, 6.0));
                tmp2.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz + float3(-0.5, -0.5, -0.5);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xy = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp3 = tex2D(_PrimaryTex, tmp3.xy);
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp0.xyz = -tmp0.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp0.xyz = saturate(tmp1.xyz ? tmp0.xyz : tmp2.xyz);
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = saturate(tmp3.xyz * tmp1.xyz);
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 126365
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _PrimaryTex;
			sampler2D _Depth;
			
			// Keywords: POINT
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
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord3.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = saturate(tmp1.y);
                tmp0.z = dot(abs(tmp1.xy), float2(0.333, 0.333));
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = tmp0.y * 0.33 + 0.33;
                tmp0.y = tmp0.y * 13.0 + -6.0;
                tmp0.y = max(tmp0.y, 0.75);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.zw = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp2 = tex2D(_Depth, tmp0.zw);
                tmp0.xzw = tmp0.xxx * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.334, 0.334, 0.334) + float3(0.333, 0.333, 0.333);
                tmp3.xyz = tmp0.xzw + tmp0.xzw;
                tmp0.xyz = tmp0.xzw * float3(0.333, 0.333, 0.333) + tmp0.yyy;
                tmp3.xyz = floor(tmp3.xyz);
                tmp4.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = dot(tmp4.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.x = tmp0.w - 0.5;
                tmp1.x = -tmp1.x * 2.0 + 1.0;
                tmp1.yzw = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp1.xyz = -tmp1.xxx * tmp1.yzw + float3(1.0, 1.0, 1.0);
                tmp1.w = tmp0.w + tmp0.w;
                tmp0.w = tmp0.w > 0.5;
                tmp2.xyz = tmp2.xyz * tmp1.www;
                tmp1.xyz = saturate(tmp0.www ? tmp1.xyz : tmp2.xyz);
                tmp1.xyz = tmp1.xyz * float3(13.0, 13.0, 13.0) + tmp3.xyz;
                tmp1.xyz = saturate(tmp1.xyz - float3(6.0, 6.0, 6.0));
                tmp0.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp2 = tex2D(_LightTexture0, tmp0.ww);
                tmp2.xyz = tmp2.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp0.xyz * tmp1.xyz + float3(-0.5, -0.5, -0.5);
                tmp0.xyz = tmp1.xyz * tmp0.xyz;
                tmp1.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xy = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp2 = tex2D(_PrimaryTex, tmp2.xy);
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp2.xyz = tmp0.xyz * tmp2.xyz;
                tmp0.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp1.xyz = -tmp1.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                o.sv_target.xyz = saturate(tmp0.xyz ? tmp1.xyz : tmp2.xyz);
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}