Shader "Hidden/FastBlur" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Bloom ("Bloom (RGB)", 2D) = "black" {}
	}
	SubShader {
		Pass {
			ZWrite Off
			Cull Off
			GpuProgramID 9100
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
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
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
                o.texcoord.xy = v.texcoord.xy + _MainTex_TexelSize.xy;
                o.texcoord1.xy = _MainTex_TexelSize.xy * float2(-0.5, -0.5) + v.texcoord.xy;
                o.texcoord2.xy = _MainTex_TexelSize.xy * float2(0.5, -0.5) + v.texcoord.xy;
                o.texcoord3.xy = _MainTex_TexelSize.xy * float2(-0.5, 0.5) + v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0 = tmp0 + tmp1;
                tmp1 = tex2D(_MainTex, inp.texcoord2.xy);
                tmp0 = tmp0 + tmp1;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp0 = tmp0 + tmp1;
                o.sv_target = tmp0 * float4(0.25, 0.25, 0.25, 0.25);
                return o;
			}
			ENDCG
		}
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 72896
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			float4 _Parameter;
			// $Globals ConstantBuffers for Fragment Shader
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
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord.zw = float2(1.0, 1.0);
                tmp0.xw = _Parameter.xx;
                tmp0.yz = float2(1.0, 0.0);
                tmp0.xy = tmp0.xy * _MainTex_TexelSize.xy;
                o.texcoord1.xy = tmp0.zw * tmp0.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[7] = {
                    float4(0.0205, 0.0, 0.0, 0.0),
                    float4(0.0855, 0.0, 0.0, 0.0),
                    float4(0.232, 0.0, 0.0, 0.0),
                    float4(0.324, 0.0, 0.0, 1.0),
                    float4(0.232, 0.0, 0.0, 0.0),
                    float4(0.0855, 0.0, 0.0, 0.0),
                    float4(0.0205, 0.0, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = -inp.texcoord1.xy * float2(3.0, 3.0) + inp.texcoord.xy;
                tmp1 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.zw = tmp0.xy;
                tmp2.x = 0.0;
                while (true) {
                    tmp2.y = i >= 7;
                    if (tmp2.y) {
                        break;
                    }
                    tmp3 = tex2D(_MainTex, tmp0.zw);
                    tmp1 = tmp3 * icb[i + 0].xxxw + tmp1;
                    tmp0.zw = tmp0.zw + inp.texcoord1.xy;
                    tmp2.x = tmp2.x + 1;
                }
                o.sv_target = tmp1;
                return o;
			}
			ENDCG
		}
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 135591
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			float4 _Parameter;
			// $Globals ConstantBuffers for Fragment Shader
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
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord.zw = float2(1.0, 1.0);
                tmp0.xw = float2(1.0, 0.0);
                tmp0.yz = _Parameter.xx;
                tmp0.xy = tmp0.xy * _MainTex_TexelSize.xy;
                o.texcoord1.xy = tmp0.zw * tmp0.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[7] = {
                    float4(0.0205, 0.0, 0.0, 0.0),
                    float4(0.0855, 0.0, 0.0, 0.0),
                    float4(0.232, 0.0, 0.0, 0.0),
                    float4(0.324, 0.0, 0.0, 1.0),
                    float4(0.232, 0.0, 0.0, 0.0),
                    float4(0.0855, 0.0, 0.0, 0.0),
                    float4(0.0205, 0.0, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = -inp.texcoord1.xy * float2(3.0, 3.0) + inp.texcoord.xy;
                tmp1 = float4(0.0, 0.0, 0.0, 0.0);
                tmp0.zw = tmp0.xy;
                tmp2.x = 0.0;
                while (true) {
                    tmp2.y = i >= 7;
                    if (tmp2.y) {
                        break;
                    }
                    tmp3 = tex2D(_MainTex, tmp0.zw);
                    tmp1 = tmp3 * icb[i + 0].xxxw + tmp1;
                    tmp0.zw = tmp0.zw + inp.texcoord1.xy;
                    tmp2.x = tmp2.x + 1;
                }
                o.sv_target = tmp1;
                return o;
			}
			ENDCG
		}
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 246384
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			float4 _Parameter;
			// $Globals ConstantBuffers for Fragment Shader
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
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = _Parameter.x;
                tmp0.y = 1.0;
                tmp0.xy = tmp0.xy * _MainTex_TexelSize.xy;
                tmp0.z = tmp0.y * _Parameter.x;
                o.texcoord1 = tmp0.xzxz * float4(-0.0, -3.0, 0.0, 3.0) + v.texcoord.xyxy;
                o.texcoord2 = tmp0.xzxz * float4(0.0, -2.0, -0.0, 2.0) + v.texcoord.xyxy;
                o.texcoord3 = tmp0.xzxz * float4(0.0, -1.0, -0.0, 1.0) + v.texcoord.xyxy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[7] = {
                    float4(0.0205, 0.0, 0.0, 0.0),
                    float4(0.0855, 0.0, 0.0, 0.0),
                    float4(0.232, 0.0, 0.0, 0.0),
                    float4(0.324, 0.0, 0.0, 1.0),
                    float4(0.232, 0.0, 0.0, 0.0),
                    float4(0.0855, 0.0, 0.0, 0.0),
                    float4(0.0205, 0.0, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * float4(0.324, 0.324, 0.324, 1.0);
                tmp1 = tmp0;
                tmp2.x = 0.0;
                while (true) {
                    tmp2.y = i >= 3;
                    if (tmp2.y) {
                        break;
                    }
                    tmp3 = tex2D(_MainTex, inp.position.xy);
                    tmp4 = tex2D(_MainTex, inp.position.zw);
                    tmp3 = tmp3 + tmp4;
                    tmp1 = tmp3 * icb[tmp2.x + 0].xxxw + tmp1;
                    tmp2.x = tmp2.x + 1;
                }
                o.sv_target = tmp1;
                return o;
			}
			ENDCG
		}
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 301178
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			float4 _Parameter;
			// $Globals ConstantBuffers for Fragment Shader
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
                o.texcoord.xy = v.texcoord.xy;
                tmp0.y = 1.0;
                tmp0.z = _Parameter.x;
                tmp0.yz = tmp0.yz * _MainTex_TexelSize.xy;
                tmp0.x = tmp0.y * _Parameter.x;
                o.texcoord1 = tmp0.xzxz * float4(-3.0, -0.0, 3.0, 0.0) + v.texcoord.xyxy;
                o.texcoord2 = tmp0.xzxz * float4(-2.0, 0.0, 2.0, -0.0) + v.texcoord.xyxy;
                o.texcoord3 = tmp0.xzxz * float4(-1.0, 0.0, 1.0, -0.0) + v.texcoord.xyxy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                const float4 icb[7] = {
                    float4(0.0205, 0.0, 0.0, 0.0),
                    float4(0.0855, 0.0, 0.0, 0.0),
                    float4(0.232, 0.0, 0.0, 0.0),
                    float4(0.324, 0.0, 0.0, 1.0),
                    float4(0.232, 0.0, 0.0, 0.0),
                    float4(0.0855, 0.0, 0.0, 0.0),
                    float4(0.0205, 0.0, 0.0, 0.0)
                };
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp0 * float4(0.324, 0.324, 0.324, 1.0);
                tmp1 = tmp0;
                tmp2.x = 0.0;
                while (true) {
                    tmp2.y = i >= 3;
                    if (tmp2.y) {
                        break;
                    }
                    tmp3 = tex2D(_MainTex, inp.position.xy);
                    tmp4 = tex2D(_MainTex, inp.position.zw);
                    tmp3 = tmp3 + tmp4;
                    tmp1 = tmp3 * icb[tmp2.x + 0].xxxw + tmp1;
                    tmp2.x = tmp2.x + 1;
                }
                o.sv_target = tmp1;
                return o;
			}
			ENDCG
		}
	}
}