Shader "SR/Paintlight/GrassUV Low" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "PreviewType" = "Plane" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 62807
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
			float4 _MainTex_ST;
			float4 _Color;
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.w = tmp0.w * _Color.w + -0.5;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * inp.texcoord2.yxz;
                tmp0.w = dot(-tmp2.xyz, tmp3.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp2.xyz = tmp3.yxz * -tmp0.www + -tmp2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * 2.5 + -0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = min(tmp0.w, 0.3);
                tmp3.x = saturate(tmp3.x);
                tmp1.x = dot(abs(tmp3.xy), float2(0.333, 0.333));
                tmp1.x = tmp3.x + tmp1.x;
                tmp1.xyz = tmp1.xxx * tmp1.xxx + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp1.xyz = tmp1.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp1.xyz = max(tmp1.xyz, float3(0.75, 0.75, 0.75));
                tmp1.xyz = min(tmp1.xyz, float3(1.0, 1.0, 1.0));
                tmp1.xyz = tmp0.www + tmp1.xyz;
                tmp2.xyz = _LightColor0.xyz * tmp1.xyz + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = -tmp0.xyz * _Color.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp2.xyz = -tmp2.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp1.xyz = saturate(tmp3.xyz ? tmp2.xyz : tmp1.xyz);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.xyz = saturate(tmp0.xyz * tmp2.xyz);
                o.sv_target.xyz = tmp1.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "PreviewType" = "Plane" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 69838
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
			float4 _MainTex_ST;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _LightTexture0;
			
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
                tmp0.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.w = tmp0.w * _Color.w + -0.5;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp1.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * inp.texcoord2.yxz;
                tmp0.w = dot(-tmp2.xyz, tmp3.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp2.xyz = tmp3.yxz * -tmp0.www + -tmp2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * 2.5 + -0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = min(tmp0.w, 0.3);
                tmp3.x = saturate(tmp3.x);
                tmp1.x = dot(abs(tmp3.xy), float2(0.333, 0.333));
                tmp1.x = tmp3.x + tmp1.x;
                tmp1.xyz = tmp1.xxx * tmp1.xxx + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp1.xyz = tmp1.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp1.xyz = max(tmp1.xyz, float3(0.75, 0.75, 0.75));
                tmp1.xyz = min(tmp1.xyz, float3(1.0, 1.0, 1.0));
                tmp1.xyz = tmp0.www + tmp1.xyz;
                tmp0.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp2 = tex2D(_LightTexture0, tmp0.ww);
                tmp2.xyz = tmp2.xxx * _LightColor0.xyz;
                tmp3.xyz = tmp2.xyz * tmp1.xyz + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp2.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = -tmp0.xyz * _Color.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp2.xyz = -tmp2.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                o.sv_target.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp0.xyz);
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "PreviewType" = "Plane" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 183999
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_ST;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: SHADOWS_DEPTH
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
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord1.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.xy = inp.texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.x = tmp0.w * _Color.w + -0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}