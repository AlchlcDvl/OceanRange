Shader "SR/Aura/Rad (Medium)" {
	Properties {
		_Refraction ("Refraction", 2D) = "white" {}
		_MiddleColor ("Middle Color", Color) = (0.2413795,1,0,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 550
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+10" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay+10" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 40674
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MiddleColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Refraction;
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m01_m11;
                tmp0 = unity_ObjectToWorld._m00_m10_m00_m10 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m02_m12 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m03_m13_m03_m13 * v.vertex.wwww + tmp0;
                tmp1.x = _TimeEditor.y + _Time.y;
                tmp1 = tmp1.xxxx * float4(0.1, -0.25, -0.1, -0.1);
                tmp0 = tmp0 * float4(0.1, 0.1, 0.1, 0.1) + tmp1;
                tmp1 = tex2Dlod(_Refraction, float4(tmp0.xy, 0, 0.0));
                tmp0 = tex2Dlod(_Refraction, float4(tmp0.zw, 0, 0.0));
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.2, 0.2, 0.2) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                o.texcoord1.xyz = tmp2.www * tmp2.xyz;
                o.texcoord2 = tmp0;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord3.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.w = tmp0.w;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = log(tmp0.x);
                tmp0.x = saturate(tmp0.x * -0.6666666 + 0.2);
                tmp0.y = tmp0.y * 4.481689;
                tmp0.y = exp(tmp0.y);
                tmp1.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.z = tmp0.z * 0.5;
                tmp0.z = log(tmp0.z);
                tmp0.z = tmp0.z * 20.0;
                tmp0.z = exp(tmp0.z);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.w = _ProjectionParams.x * -_ProjectionParams.x;
                tmp1.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp1.z = tmp0.w * tmp1.y;
                tmp1 = tmp1.xzxz * float4(0.5, 0.5, 0.5, 0.5) + float4(0.5, 0.5, 0.5, 0.5);
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp1 = tmp0.wwww * float4(0.05, -0.1, -0.05, -0.05) + tmp1;
                tmp2 = tex2D(_Refraction, tmp1.xy);
                tmp1 = tex2D(_Refraction, tmp1.zw);
                tmp0.w = tmp1.x * tmp2.x;
                tmp0.yz = tmp0.yw * tmp0.wz;
                tmp0.z = tmp0.z * 0.75;
                tmp0.y = tmp0.y * 10.0 + tmp0.z;
                tmp0.zw = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.zw);
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.z = tmp0.z - _ProjectionParams.y;
                tmp0.w = inp.texcoord3.z - _ProjectionParams.y;
                tmp0.zw = max(tmp0.zw, float2(0.0, 0.0));
                tmp0.z = tmp0.z - tmp0.w;
                tmp0.z = saturate(tmp0.z * -1.333333 + 0.6666666);
                tmp0.y = saturate(tmp0.z + tmp0.y);
                tmp0.yz = tmp0.yy * float2(0.5555556, 5.0) + float2(-0.1111111, -4.0);
                tmp0.yz = max(tmp0.yz, float2(0.0, 0.0));
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.yzw = _MiddleColor.xyz * float3(4.5, 4.5, 4.5);
                tmp0.yzw = tmp0.yzw * tmp0.xxx;
                o.sv_target.w = tmp0.x;
                o.sv_target.xyz = _MiddleColor.xyz * float3(0.5, 0.5, 0.5) + tmp0.yzw;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Overlay+10" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 88210
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Refraction;
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m01_m11;
                tmp0 = unity_ObjectToWorld._m00_m10_m00_m10 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m02_m12 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m03_m13_m03_m13 * v.vertex.wwww + tmp0;
                tmp1.x = _TimeEditor.y + _Time.y;
                tmp1 = tmp1.xxxx * float4(0.1, -0.25, -0.1, -0.1);
                tmp0 = tmp0 * float4(0.1, 0.1, 0.1, 0.1) + tmp1;
                tmp1 = tex2Dlod(_Refraction, float4(tmp0.xy, 0, 0.0));
                tmp0 = tex2Dlod(_Refraction, float4(tmp0.zw, 0, 0.0));
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.2, 0.2, 0.2) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
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
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
	Fallback "SR/Aura/Rad (Simple)"
	CustomEditor "ShaderForgeMaterialInspector"
}