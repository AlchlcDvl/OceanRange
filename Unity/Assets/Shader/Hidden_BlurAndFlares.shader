Shader "Hidden/BlurAndFlares" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}
		_NonBlurredTex ("Base (RGB)", 2D) = "" {}
	}
	SubShader {
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 11900
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
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
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.x = dot(tmp0.xyz, float3(0.22, 0.707, 0.071));
                tmp1.x = tmp1.x + 1.5;
                o.sv_target = tmp0 / tmp1.xxxx;
                return o;
			}
			ENDCG
		}
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 119073
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
				float2 texcoord4 : TEXCOORD4;
				float2 texcoord5 : TEXCOORD5;
				float2 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Offsets;
			float _StretchWidth;
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
                tmp0.x = _StretchWidth + _StretchWidth;
                o.texcoord1.xy = tmp0.xx * _Offsets.xy + v.texcoord.xy;
                o.texcoord2.xy = -tmp0.xx * _Offsets.xy + v.texcoord.xy;
                tmp0 = _StretchWidth.xxxx * float4(4.0, 4.0, 6.0, 6.0);
                o.texcoord3.xy = tmp0.xy * _Offsets.xy + v.texcoord.xy;
                o.texcoord4.xy = -tmp0.xy * _Offsets.xy + v.texcoord.xy;
                o.texcoord5.xy = tmp0.zw * _Offsets.xy + v.texcoord.xy;
                o.texcoord6.xy = -tmp0.zw * _Offsets.xy + v.texcoord.xy;
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
                tmp0 = max(tmp0, tmp1);
                tmp1 = tex2D(_MainTex, inp.texcoord2.xy);
                tmp0 = max(tmp0, tmp1);
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp0 = max(tmp0, tmp1);
                tmp1 = tex2D(_MainTex, inp.texcoord4.xy);
                tmp0 = max(tmp0, tmp1);
                tmp1 = tex2D(_MainTex, inp.texcoord5.xy);
                tmp0 = max(tmp0, tmp1);
                tmp1 = tex2D(_MainTex, inp.texcoord6.xy);
                o.sv_target = max(tmp0, tmp1);
                return o;
			}
			ENDCG
		}
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 193139
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
				float2 texcoord4 : TEXCOORD4;
				float2 texcoord5 : TEXCOORD5;
				float2 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Offsets;
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TintColor;
			float2 _Threshhold;
			float _Saturation;
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
                tmp0.xy = _Offsets.xy * _MainTex_TexelSize.xy;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5) + v.texcoord.xy;
                o.texcoord2.xy = -tmp0.xy * float2(0.5, 0.5) + v.texcoord.xy;
                o.texcoord3.xy = tmp0.xy * float2(1.5, 1.5) + v.texcoord.xy;
                o.texcoord4.xy = -tmp0.xy * float2(1.5, 1.5) + v.texcoord.xy;
                o.texcoord5.xy = tmp0.xy * float2(2.5, 2.5) + v.texcoord.xy;
                o.texcoord6.xy = -tmp0.xy * float2(2.5, 2.5) + v.texcoord.xy;
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
                tmp1 = tex2D(_MainTex, inp.texcoord4.xy);
                tmp0 = tmp0 + tmp1;
                tmp1 = tex2D(_MainTex, inp.texcoord5.xy);
                tmp0 = tmp0 + tmp1;
                tmp1 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0 = tmp0 + tmp1;
                tmp0 = tmp0 * float4(0.1428571, 0.1428571, 0.1428571, 0.1428571) + -_Threshhold.xxxx;
                tmp0 = max(tmp0, float4(0.0, 0.0, 0.0, 0.0));
                tmp1.x = dot(tmp0.xyz, float3(0.22, 0.707, 0.071));
                tmp0.xyz = tmp0.xyz - tmp1.xxx;
                o.sv_target.w = tmp0.w;
                tmp0.xyz = _Saturation.xxx * tmp0.xyz + tmp1.xxx;
                o.sv_target.xyz = tmp0.xyz * _TintColor.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 228544
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
				float2 texcoord4 : TEXCOORD4;
				float2 texcoord5 : TEXCOORD5;
				float2 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Offsets;
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
                o.texcoord.xy = v.texcoord.xy;
                tmp0.xy = _Offsets.xy * _MainTex_TexelSize.xy;
                o.texcoord1.xy = tmp0.xy * float2(0.5, 0.5) + v.texcoord.xy;
                o.texcoord2.xy = -tmp0.xy * float2(0.5, 0.5) + v.texcoord.xy;
                o.texcoord3.xy = tmp0.xy * float2(1.5, 1.5) + v.texcoord.xy;
                o.texcoord4.xy = -tmp0.xy * float2(1.5, 1.5) + v.texcoord.xy;
                o.texcoord5.xy = tmp0.xy * float2(2.5, 2.5) + v.texcoord.xy;
                o.texcoord6.xy = -tmp0.xy * float2(2.5, 2.5) + v.texcoord.xy;
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
                tmp1 = tex2D(_MainTex, inp.texcoord4.xy);
                tmp0 = tmp0 + tmp1;
                tmp1 = tex2D(_MainTex, inp.texcoord5.xy);
                tmp0 = tmp0 + tmp1;
                tmp1 = tex2D(_MainTex, inp.texcoord6.xy);
                tmp0 = tmp0 + tmp1;
                tmp1.x = dot(tmp0.xyz, float3(0.22, 0.707, 0.071));
                tmp1.x = tmp1.x + 7.5;
                o.sv_target = tmp0 / tmp1.xxxx;
                return o;
			}
			ENDCG
		}
		Pass {
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 266635
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Offsets;
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
                o.texcoord1 = _Offsets * float4(1.0, 1.0, -1.0, -1.0) + v.texcoord.xyxy;
                o.texcoord2 = _Offsets * float4(2.0, 2.0, -2.0, -2.0) + v.texcoord.xyxy;
                o.texcoord3 = _Offsets * float4(3.0, 3.0, -3.0, -3.0) + v.texcoord.xyxy;
                o.texcoord4 = _Offsets * float4(5.0, 5.0, -5.0, -5.0) + v.texcoord.xyxy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_MainTex, inp.texcoord1.xy);
                tmp0 = tmp0 * float4(0.15, 0.15, 0.15, 0.15);
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp0 = tmp1 * float4(0.225, 0.225, 0.225, 0.225) + tmp0;
                tmp1 = tex2D(_MainTex, inp.texcoord1.zw);
                tmp0 = tmp1 * float4(0.15, 0.15, 0.15, 0.15) + tmp0;
                tmp1 = tex2D(_MainTex, inp.texcoord2.xy);
                tmp0 = tmp1 * float4(0.11, 0.11, 0.11, 0.11) + tmp0;
                tmp1 = tex2D(_MainTex, inp.texcoord2.zw);
                tmp0 = tmp1 * float4(0.11, 0.11, 0.11, 0.11) + tmp0;
                tmp1 = tex2D(_MainTex, inp.texcoord3.xy);
                tmp0 = tmp1 * float4(0.075, 0.075, 0.075, 0.075) + tmp0;
                tmp1 = tex2D(_MainTex, inp.texcoord3.zw);
                tmp0 = tmp1 * float4(0.075, 0.075, 0.075, 0.075) + tmp0;
                tmp1 = tex2D(_MainTex, inp.texcoord4.xy);
                tmp0 = tmp1 * float4(0.0525, 0.0525, 0.0525, 0.0525) + tmp0;
                tmp1 = tex2D(_MainTex, inp.texcoord4.zw);
                o.sv_target = tmp1 * float4(0.0525, 0.0525, 0.0525, 0.0525) + tmp0;
                return o;
			}
			ENDCG
		}
	}
}