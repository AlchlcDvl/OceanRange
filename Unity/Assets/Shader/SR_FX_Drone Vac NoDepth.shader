Shader "SR/FX/Drone Vac NoDepth" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_VertexOffset ("VertexOffset", Float) = 1
		_Speed ("Speed", Float) = 1
		_Power ("Power", Float) = 1
		_Color2 ("Color 2", Color) = (0.5,0.5,0.5,1)
		_Alpha ("Alpha", Range(0, 1)) = 1
		_MainTexture ("Main Texture", 2D) = "black" {}
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+200" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay+200" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			Cull Off
			GpuProgramID 48398
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
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _VertexOffset;
			float _Speed;
			float _Alpha;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float _Power;
			float4 _Color2;
			float4 _MainTexture_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTexture;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _Time.y * _Speed + v.texcoord.y;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * -2.0 + 1.0;
                tmp0.x = abs(tmp0.x) * -2.0 + 1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = v.color.x * -0.5 + 1.0;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _VertexOffset.xxx;
                tmp1.xyz = v.normal.xyz * float3(-2.0, -2.0, -2.0);
                tmp0.w = 1.0 - _Alpha;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * v.texcoord.yyy + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
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
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _Time.y * _Speed + inp.texcoord.y;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * -2.0 + 1.0;
                tmp0.x = abs(tmp0.x) * -2.0 + 1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.y = _Power * _Alpha;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = exp(tmp0.x);
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * inp.texcoord2.xyz;
                tmp1.x = facing.x ? 1.0 : -1.0;
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.z = 1.0 - tmp0.y;
                tmp0.x = saturate(tmp0.x * tmp0.z + -0.2);
                tmp0.z = 1.0 - inp.texcoord.y;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.w = _Speed * _Time.y;
                tmp1.xy = tmp0.ww * float2(0.0, 2.0) + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
                tmp1 = tex2D(_MainTexture, tmp1.xy);
                tmp0.x = tmp0.z * tmp1.x + tmp0.x;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.w = min(tmp0.z, 1.0);
                tmp0.y = saturate(tmp0.y * tmp0.z + tmp0.w);
                tmp0.y = saturate(tmp0.y + inp.texcoord.y);
                tmp0.x = tmp0.y * -0.5 + tmp0.x;
                tmp0.x = saturate(tmp0.x + 0.5);
                tmp0.yzw = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.y = dot(tmp0.xyz, tmp0.xyz);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y * 0.5;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = 1.0 - _Alpha;
                tmp0.zw = inp.texcoord.yy * float2(-0.04, -0.04) + float2(0.52, 0.02);
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp0.w = tmp0.z > 0.5;
                tmp0.z = dot(_Alpha, tmp0.xy);
                tmp0.y = saturate(tmp0.w ? tmp0.y : tmp0.z);
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.yzw = _Color.xyz - _Color2.xyz;
                tmp0.yzw = tmp0.xxx * tmp0.yzw + _Color2.xyz;
                tmp0.x = tmp0.x * 1.25;
                tmp0.x = min(tmp0.x, 1.0);
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Overlay+200" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Cull Off
			Offset 1, 1
			GpuProgramID 72881
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _VertexOffset;
			float _Speed;
			float _Alpha;
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
                tmp0.x = _Time.y * _Speed + v.texcoord.y;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * -2.0 + 1.0;
                tmp0.x = abs(tmp0.x) * -2.0 + 1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.25, 0.25, 0.25);
                tmp0.w = v.color.x * -0.5 + 1.0;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _VertexOffset.xxx;
                tmp1.xyz = v.normal.xyz * float3(-2.0, -2.0, -2.0);
                tmp0.w = 1.0 - _Alpha;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.xyz = tmp1.xyz * v.texcoord.yyy + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord1.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp, float facing: VFACE)
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