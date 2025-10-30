Shader "SR/Slime/Body Boom" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		_Cracks ("Cracks", Cube) = "_Skybox" {}
		_CrackAmount ("Crack Amount", Range(0, 1)) = 0.4957265
		_Char ("Char", Range(0, 1)) = 0
		_StripeTexture ("Stripe Texture", 2D) = "white" {}
		_VertexNoise ("Vertex Noise", 2D) = "black" {}
		_VertexOffset ("Vertex Offset", Float) = 0
		[MaterialToggle] _StripeUV1 ("Stripe UV1", Float) = 0
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" }
		Pass {
			Name "Outline"
			Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Cull Front
			GpuProgramID 32838
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
			float _CrackAmount;
			float4 _VertexNoise_ST;
			float _VertexOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TopColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _VertexNoise;
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _CrackAmount * 0.025;
                tmp0.y = saturate(v.normal.y + v.normal.y);
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.yz = v.vertex.yy * unity_ObjectToWorld._m21_m01;
                tmp0.yz = unity_ObjectToWorld._m20_m00 * v.vertex.xx + tmp0.yz;
                tmp0.yz = unity_ObjectToWorld._m22_m02 * v.vertex.zz + tmp0.yz;
                tmp0.yz = unity_ObjectToWorld._m23_m03 * v.vertex.ww + tmp0.yz;
                tmp0.yz = _Time.yy * float2(0.1, 0.1) + tmp0.yz;
                tmp0.yz = tmp0.yz * _VertexNoise_ST.xy + _VertexNoise_ST.zw;
                tmp1 = tex2Dlod(_VertexNoise, float4(tmp0.yz, 0, 0.0));
                tmp0.y = saturate(v.texcoord.y * -4.0 + 1.8);
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = v.normal.xyz * float3(1.0, 0.0, 1.0);
                tmp0.yzw = tmp0.yzw * tmp1.xyz;
                tmp0.yzw = tmp0.yzw * _VertexOffset.xxx + v.vertex.xyz;
                tmp1.xyz = v.normal.xyz * tmp0.xxx + tmp0.yzw;
                tmp2 = tmp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy;
                tmp1 = tmp0.zzzz * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.wwww + tmp1;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
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
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = _Time.yy * float2(0.01, -0.5) + inp.texcoord.xy;
                tmp0.xy = tmp0.xy * float2(6.0, 6.0);
                tmp0.zw = float2(0.0, 0.0);
                while (true) {
                    tmp1.x = i >= 6;
                    if (tmp1.x) {
                        break;
                    }
                    i = i + 1;
                    tmp1.xy = tmp0.xy * tmp1.xx;
                    tmp1.zw = floor(tmp1.xy);
                    tmp1.xy = frac(tmp1.xy);
                    tmp2.xy = tmp1.xy * tmp1.xy;
                    tmp1.xy = -tmp1.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp1.xy = tmp1.xy * tmp2.xy;
                    tmp1.z = tmp1.w * 57.0 + tmp1.z;
                    tmp2.xyz = tmp1.zzz + float3(1.0, 57.0, 58.0);
                    tmp3.x = sin(tmp1.z);
                    tmp3.yzw = sin(tmp2.xyz);
                    tmp2 = tmp3 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp2 = frac(tmp2);
                    tmp1.zw = tmp2.yw - tmp2.xz;
                    tmp1.xz = tmp1.xx * tmp1.zw + tmp2.xz;
                    tmp1.z = tmp1.z - tmp1.x;
                    tmp1.x = tmp1.y * tmp1.z + tmp1.x;
                    tmp1.y = null.y / 6;
                    tmp0.z = tmp1.x * tmp1.y + tmp0.z;
                }
                tmp0.x = tmp0.z * 0.1666667;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yzw = _CrackAmount.xxx * float3(0.0, 0.7034483, 0.0) + float3(1.0, 0.1862069, 0.0);
                tmp0.yzw = tmp0.yzw * _CrackAmount.xxx;
                tmp0.xyz = saturate(tmp0.xxx * tmp0.yzw);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.xyz = _TopColor.xyz * float3(0.8, 0.8, 0.8) + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 77871
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _VertexNoise_ST;
			float _VertexOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float _CrackAmount;
			float _Char;
			float4 _StripeTexture_ST;
			float _StripeUV1;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _VertexNoise;
			// Texture params for Fragment Shader
			samplerCUBE _Cracks;
			sampler2D _StripeTexture;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.yy * unity_ObjectToWorld._m21_m01;
                tmp0.xy = unity_ObjectToWorld._m20_m00 * v.vertex.xx + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m22_m02 * v.vertex.zz + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m23_m03 * v.vertex.ww + tmp0.xy;
                tmp0.xy = _Time.yy * float2(0.1, 0.1) + tmp0.xy;
                tmp0.xy = tmp0.xy * _VertexNoise_ST.xy + _VertexNoise_ST.zw;
                tmp0 = tex2Dlod(_VertexNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.w = saturate(v.texcoord.y * -4.0 + 1.8);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.normal.xyz * float3(1.0, 0.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _VertexOffset.xxx + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp7;
                tmp0.x = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord3.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp0.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 32.0;
                tmp0.w = exp(tmp0.w);
                tmp1.xyz = tmp0.www * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.1, 0.1, 0.1);
                tmp0.w = dot(tmp0.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.w = dot(tmp0.xyz, tmp2.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp2.xyz;
                tmp2.xyz = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp2.xyz;
                tmp2 = texCUBE(_Cracks, tmp2.xyz);
                tmp0.x = tmp1.w * -1.5 + 1.5;
                tmp0.x = tmp0.x * tmp2.x;
                tmp0.x = tmp0.x * _CrackAmount;
                tmp4.xy = inp.texcoord1.xy - inp.texcoord.xy;
                tmp4.xy = _StripeUV1.xx * tmp4.xy + inp.texcoord.xy;
                tmp4.xy = tmp4.xy * _StripeTexture_ST.xy + _StripeTexture_ST.zw;
                tmp4 = tex2D(_StripeTexture, tmp4.xy);
                tmp0.z = saturate(tmp4.x * 9.999998 + -8.999998);
                tmp2.w = _CrackAmount * -0.5 + 1.0;
                tmp0.y = saturate(tmp0.y * 0.75 + 0.25);
                tmp3.w = tmp1.w * tmp1.w;
                tmp3.w = min(tmp3.w, 1.0);
                tmp0.y = tmp0.y + tmp3.w;
                tmp0.y = tmp0.y * tmp2.w;
                tmp2.w = tmp0.x * -3.0 + 1.0;
                tmp0.y = saturate(tmp0.y * tmp2.w);
                tmp0.y = tmp0.z * tmp0.y;
                tmp4.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp4.xyz = tmp0.yyy * tmp4.xyz + _BottomColor.xyz;
                tmp5.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp5.xyz = tmp0.yyy * tmp5.xyz + _MiddleColor.xyz;
                tmp0.y = tmp0.y * 2.0 + -1.0;
                tmp0.y = max(tmp0.y, 0.0);
                tmp5.xyz = tmp5.xyz - tmp4.xyz;
                tmp4.xyz = tmp0.yyy * tmp5.xyz + tmp4.xyz;
                tmp2.xyz = tmp2.xyz * float3(-0.25, -0.25, -0.25) + float3(1.0, 1.0, 1.0);
                tmp0.y = dot(tmp4.xyz, float3(0.3, 0.59, 0.11));
                tmp5.xyz = tmp0.yyy - tmp4.xyz;
                tmp5.xyz = tmp5.xyz * float3(0.5, 0.5, 0.5) + tmp4.xyz;
                tmp2.xyz = tmp2.xyz * tmp5.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.75, 0.75, 0.75) + -tmp4.xyz;
                tmp2.xyz = _Char.xxx * tmp2.xyz + tmp4.xyz;
                tmp4.xyz = tmp2.xyz * float3(0.2, 0.2, 0.2);
                tmp3.xyz = tmp0.www * _LightColor0.xyz + tmp3.xyz;
                tmp0.yw = _Time.yy * float2(0.01, -0.5) + inp.texcoord.xy;
                tmp0.yw = tmp0.yw * float2(6.0, 6.0);
                tmp2.w = 0.0;
                tmp3.w = 0.0;
                while (true) {
                    tmp4.w = i >= 6;
                    if (tmp4.w) {
                        break;
                    }
                    i = i + 1;
                    tmp5.xy = tmp0.yw * tmp4.ww;
                    tmp5.zw = floor(tmp5.xy);
                    tmp5.xy = frac(tmp5.xy);
                    tmp6.xy = tmp5.xy * tmp5.xy;
                    tmp5.xy = -tmp5.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp5.xy = tmp5.xy * tmp6.xy;
                    tmp4.w = tmp5.w * 57.0 + tmp5.z;
                    tmp6.xyz = tmp4.www + float3(1.0, 57.0, 58.0);
                    tmp7.x = sin(tmp4.w);
                    tmp7.yzw = sin(tmp6.xyz);
                    tmp6 = tmp7 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp6 = frac(tmp6);
                    tmp5.zw = tmp6.yw - tmp6.xz;
                    tmp5.xz = tmp5.xx * tmp5.zw + tmp6.xz;
                    tmp4.w = tmp5.z - tmp5.x;
                    tmp4.w = tmp5.y * tmp4.w + tmp5.x;
                    tmp5.x = null.x / 6;
                    tmp2.w = tmp4.w * tmp5.x + tmp2.w;
                }
                tmp0.y = tmp2.w * 0.1666667;
                tmp0.w = tmp0.y * tmp0.y;
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp0.w = log(tmp1.w);
                tmp0.w = tmp0.w * 0.9;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * -3.0 + 1.0;
                tmp5.x = tmp0.w * _CrackAmount;
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.x = tmp0.x * 20.0;
                tmp0.x = floor(tmp0.x);
                tmp5.yzw = tmp0.yyy * float3(0.0, 0.3310345, 0.0) + float3(1.0, 0.1862069, 0.0);
                tmp6.xyz = tmp0.yyy * float3(0.0, 0.3724138, 0.0) + float3(1.0, 0.5172414, 0.0);
                tmp6.xyz = tmp6.xyz - tmp5.yzw;
                tmp7.xyz = tmp5.xxx * tmp6.xyz + tmp5.xzx;
                tmp7.xyz = tmp5.yxw + tmp7.xyz;
                tmp7.xyz = saturate(tmp7.xyz - float3(1.0, 1.0, 1.0));
                tmp0.z = 1.0 - tmp0.x;
                tmp0.y = tmp0.z / tmp0.y;
                tmp0.y = saturate(1.0 - tmp0.y);
                tmp0.y = tmp0.x * 0.667 + tmp0.y;
                tmp0.yzw = tmp0.yyy * tmp6.xyz + tmp5.yzw;
                tmp0.xyz = saturate(tmp0.xxx * tmp0.yzw);
                tmp0.xyz = tmp0.xyz + tmp7.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = tmp2.xyz * float3(0.8, 0.8, 0.8) + tmp0.xyz;
                tmp1.xyz = tmp3.xyz * tmp4.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 158536
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _VertexNoise_ST;
			float _VertexOffset;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _VertexNoise;
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.vertex.yy * unity_ObjectToWorld._m21_m01;
                tmp0.xy = unity_ObjectToWorld._m20_m00 * v.vertex.xx + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m22_m02 * v.vertex.zz + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m23_m03 * v.vertex.ww + tmp0.xy;
                tmp0.xy = _Time.yy * float2(0.1, 0.1) + tmp0.xy;
                tmp0.xy = tmp0.xy * _VertexNoise_ST.xy + _VertexNoise_ST.zw;
                tmp0 = tex2Dlod(_VertexNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.w = saturate(v.texcoord.y * -4.0 + 1.8);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.normal.xyz * float3(1.0, 0.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _VertexOffset.xxx + v.vertex.xyz;
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