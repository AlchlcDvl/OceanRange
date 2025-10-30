Shader "SR/Slime/Plort (Boom)" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		_Cracks ("Cracks", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 55844
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
			float4 _TimeEditor;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float4 _Cracks_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Cracks;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp0.x = tmp0.x * 5.0;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = abs(tmp0.x) * 0.05;
                tmp0.xyz = tmp0.xxx * v.normal.xyz + v.vertex.xyz;
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
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(-tmp1.xyz, tmp0.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp2.xyz = tmp0.xyz * -tmp0.www + -tmp1.xyz;
                tmp3.xy = _TimeEditor.zy + _Time.zy;
                tmp0.w = sin(tmp3.x);
                tmp0.w = tmp0.w * 0.1 + 0.4;
                tmp1.x = dot(tmp0.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.y = log(tmp1.x);
                tmp1.y = tmp1.y * 0.9;
                tmp1.y = exp(tmp1.y);
                tmp1.y = tmp1.y * -3.0 + 1.0;
                tmp4.x = tmp0.w * tmp1.y;
                tmp1.y = tmp3.y * 5.0;
                tmp1.zw = tmp3.yy * float2(0.01, -0.5) + inp.texcoord.xy;
                tmp1.zw = tmp1.zw * float2(6.0, 6.0);
                tmp2.w = 0.0;
                tmp3.x = 0.0;
                while (true) {
                    tmp3.y = i >= 6;
                    if (tmp3.y) {
                        break;
                    }
                    i = i + 1;
                    tmp3.yz = tmp1.zw * tmp3.yy;
                    tmp5.xy = floor(tmp3.yz);
                    tmp3.yz = frac(tmp3.yz);
                    tmp5.zw = tmp3.yz * tmp3.yz;
                    tmp3.yz = -tmp3.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp3.yz = tmp3.yz * tmp5.zw;
                    tmp3.w = tmp5.y * 57.0 + tmp5.x;
                    tmp5.xyz = tmp3.www + float3(1.0, 57.0, 58.0);
                    tmp6.x = sin(tmp3.w);
                    tmp6.yzw = sin(tmp5.xyz);
                    tmp5 = tmp6 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp5 = frac(tmp5);
                    tmp5.yw = tmp5.yw - tmp5.xz;
                    tmp3.yw = tmp3.yy * tmp5.yw + tmp5.xz;
                    tmp3.w = tmp3.w - tmp3.y;
                    tmp3.y = tmp3.z * tmp3.w + tmp3.y;
                    tmp3.z = null.z / 6;
                    tmp2.w = tmp3.y * tmp3.z + tmp2.w;
                }
                tmp1.z = tmp2.w * 0.1666667;
                tmp1.w = tmp1.z * tmp1.z;
                tmp1.z = -tmp1.w * tmp1.z + 1.0;
                tmp3.xy = inp.texcoord.xy * _Cracks_ST.xy + _Cracks_ST.zw;
                tmp3 = tex2D(_Cracks, tmp3.xy);
                tmp0.w = tmp0.w * tmp3.x;
                tmp1.w = tmp1.x * -1.5 + 1.5;
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.w = tmp0.w * 20.0;
                tmp1.w = floor(tmp1.w);
                tmp1.y = sin(tmp1.y);
                tmp1.y = tmp1.y + tmp1.y;
                tmp0.w = tmp0.w * -3.0 + 1.0;
                tmp2.w = tmp1.x + inp.texcoord.y;
                tmp0.x = dot(tmp0.xyz, tmp2.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 128.0;
                tmp0.x = exp(tmp0.x);
                tmp0.x = tmp0.x + tmp2.w;
                tmp0.y = rsqrt(tmp1.x);
                tmp0.y = 1.0 / tmp0.y;
                tmp0.y = tmp0.y * -abs(tmp1.y) + abs(tmp1.y);
                tmp0.y = tmp0.y * 0.333;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.x = tmp0.y * 0.5 + tmp0.x;
                tmp0.x = saturate(tmp0.x * tmp0.w);
                tmp0.yzw = tmp4.xxx * float3(0.0, 0.3310345, 0.0) + float3(1.0, 0.1862069, 0.0);
                tmp2.xyz = tmp4.xxx * float3(0.0, 0.3724138, 0.0) + float3(1.0, 0.5172414, 0.0);
                tmp0.yzw = tmp2.xyz - tmp0.yzw;
                tmp4.y = tmp4.x * 0.3310345 + 0.1862069;
                tmp0.yzw = tmp4.xxx * tmp0.yzw + tmp4.xyx;
                tmp4.zw = float2(1.0, 0.0);
                tmp0.yzw = tmp0.yzw + tmp4.zxw;
                tmp0.yzw = tmp0.yzw - float3(1.0, 1.0, 1.0);
                tmp0.yzw = max(tmp0.yzw, float3(0.0, 0.0, 0.0));
                tmp2.xyz = tmp1.zzz * float3(0.0, 0.3310345, 0.0) + float3(1.0, 0.1862069, 0.0);
                tmp1.xyz = tmp1.zzz * float3(0.0, 0.3724138, 0.0) + float3(1.0, 0.5172414, 0.0);
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp1.xyz = tmp1.www * tmp1.xyz + tmp2.xyz;
                tmp1.xyz = saturate(tmp1.www * tmp1.xyz);
                tmp0.yzw = tmp0.yzw + tmp1.xyz;
                tmp1.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz + _BottomColor.xyz;
                tmp2.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp2.xyz = tmp0.xxx * tmp2.xyz + _MiddleColor.xyz;
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp1.xyz = tmp0.xxx * tmp2.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp0.yzw + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 104686
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
			float4 _TimeEditor;
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
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp0.x = tmp0.x * 5.0;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = abs(tmp0.x) * 0.05;
                tmp0.xyz = tmp0.xxx * v.normal.xyz + v.vertex.xyz;
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
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
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