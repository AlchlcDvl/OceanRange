Shader "SR/RanchTech/RanchBarrier" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_ColorRamp ("Color-Ramp", 2D) = "white" {}
		_Stripes ("Stripes", 2D) = "black" {}
		_Noise ("Noise", Cube) = "_Skybox" {}
		_Mask ("Mask", 2D) = "black" {}
		_FadeDistance ("Fade Distance", Float) = 10
	}
	SubShader {
		LOD 550
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ColorMask RGB
			ZWrite Off
			GpuProgramID 26784
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
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _ColorRamp_ST;
			float4 _Stripes_ST;
			float4 _Color;
			float4 _Mask_ST;
			float _FadeDistance;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			samplerCUBE _Noise;
			sampler2D _ColorRamp;
			sampler2D _Stripes;
			sampler2D _Mask;
			
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
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                o.texcoord2.xyz = tmp0.zzz * tmp2.xyz;
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
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xy = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp2 = tex2D(_CameraDepthTexture, tmp2.xy);
                tmp0.w = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - _ProjectionParams.y;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.w = inp.texcoord3.z - _ProjectionParams.y;
                tmp2.x = _TimeEditor.y + _Time.y;
                tmp1.x = dot(tmp0.xyz, tmp1.xyz);
                tmp1.xw = max(tmp1.xw, float2(0.0, 0.0));
                tmp1.x = 1.0 - tmp1.x;
                tmp2.yzw = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp2.yzw = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp2.yzw;
                tmp2.yzw = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp2.yzw;
                tmp3 = texCUBElod(_Noise, float4(tmp2.yzw, 2.0));
                tmp3.x = tmp2.x * 0.167 + tmp3.x;
                tmp3.y = 0.0;
                tmp1.xy = tmp1.xx + tmp3.xy;
                tmp1.xy = tmp1.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp3 = tex2D(_ColorRamp, tmp1.xy);
                tmp1.xyz = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp0.xyz = abs(tmp0.xyz) * abs(tmp0.xyz);
                tmp1.yz = tmp2.xx * float2(0.0, 0.1) + inp.texcoord.xy;
                tmp2.yz = float2(0.0, 0.0);
                while (true) {
                    tmp2.w = i >= 8;
                    if (tmp2.w) {
                        break;
                    }
                    i = i + 1;
                    tmp4.xy = tmp1.yz * tmp2.ww;
                    tmp4.zw = floor(tmp4.xy);
                    tmp4.xy = frac(tmp4.xy);
                    tmp5.xy = tmp4.xy * tmp4.xy;
                    tmp4.xy = -tmp4.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp4.xy = tmp4.xy * tmp5.xy;
                    tmp2.w = tmp4.w * 57.0 + tmp4.z;
                    tmp5.xyz = tmp2.www + float3(1.0, 57.0, 58.0);
                    tmp6.x = sin(tmp2.w);
                    tmp6.yzw = sin(tmp5.xyz);
                    tmp5 = tmp6 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp5 = frac(tmp5);
                    tmp4.zw = tmp5.yw - tmp5.xz;
                    tmp4.xz = tmp4.xx * tmp4.zw + tmp5.xz;
                    tmp2.w = tmp4.z - tmp4.x;
                    tmp2.w = tmp4.y * tmp2.w + tmp4.x;
                    tmp3.w = null.w / 8;
                    tmp2.y = tmp2.w * tmp3.w + tmp2.y;
                }
                tmp1.yz = tmp2.yx * float2(0.125, 0.75);
                tmp1.y = tmp1.y * tmp1.y;
                tmp4 = tmp1.yyyy * float4(0.3, 0.3, 0.3, 0.3) + inp.texcoord1.yzzx;
                tmp5 = tmp2.xxxx * float4(0.5, 0.0, 0.25, 0.25) + tmp4;
                tmp5 = tmp5 * _Stripes_ST + _Stripes_ST;
                tmp6 = tex2D(_Stripes, tmp5.xy);
                tmp5 = tex2D(_Stripes, tmp5.zw);
                tmp2.yz = tmp1.yy * float2(0.3, 0.3) + inp.texcoord1.xy;
                tmp2.xw = tmp2.xx * float2(0.0, 0.5) + tmp2.yz;
                tmp2.xw = tmp2.xw * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp7 = tex2D(_Stripes, tmp2.xw);
                tmp1.y = tmp0.y * tmp5.x;
                tmp1.y = tmp0.x * tmp6.x + tmp1.y;
                tmp1.y = tmp0.z * tmp7.x + tmp1.y;
                tmp4 = tmp4 * _Mask_ST + _Mask_ST;
                tmp5 = tex2D(_Mask, tmp4.xy);
                tmp4 = tex2D(_Mask, tmp4.zw);
                tmp2.xy = tmp2.yz * _Mask_ST.xy + _Mask_ST.zw;
                tmp2 = tex2D(_Mask, tmp2.xy);
                tmp0.y = tmp0.y * tmp4.x;
                tmp0.x = tmp0.x * tmp5.x + tmp0.y;
                tmp0.x = tmp0.z * tmp2.x + tmp0.x;
                tmp0.y = dot(tmp3.xyz, float3(0.3, 0.59, 0.11));
                tmp2.xyz = tmp0.yyy - tmp3.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.5, 0.5, 0.5) + tmp3.xyz;
                tmp3.xyz = _FadeDistance.xxx * float3(3.334, 1.667, 0.8335);
                tmp3.xyz = tmp1.xxx / tmp3.xyz;
                tmp3.xyz = saturate(float3(1.0, 1.0, 1.0) - tmp3.xyz);
                tmp0.y = tmp0.w - tmp1.w;
                tmp0.y = saturate(tmp0.y * 0.3333333);
                tmp0.yz = tmp0.yy * float2(-0.55, -0.55) + float2(0.75, 0.25);
                tmp0.w = tmp0.y > 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp1.x = tmp0.x * tmp1.y;
                tmp1.w = -tmp1.y * tmp0.x + 1.0;
                tmp0.z = -tmp0.z * tmp1.w + 1.0;
                tmp0.y = dot(tmp1.xy, tmp0.xy);
                tmp0.y = saturate(tmp0.w ? tmp0.z : tmp0.y);
                tmp0.y = tmp0.y * tmp3.x;
                tmp0.y = saturate(tmp0.y * 5.0 + -1.0);
                tmp0.z = tmp0.x > 0.5;
                tmp0.w = tmp0.x - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp1.x = tmp1.y * 0.3 + 0.4;
                tmp1.y = 1.0 - tmp1.x;
                tmp0.w = -tmp0.w * tmp1.y + 1.0;
                tmp0.x = dot(tmp1.xy, tmp0.xy);
                tmp0.x = saturate(tmp0.z ? tmp0.w : tmp0.x);
                tmp0.z = sin(tmp1.z);
                tmp0.z = tmp0.z * 0.2 + 1.0;
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.x = tmp3.y * tmp0.x;
                tmp0.x = saturate(tmp0.x * 20.00001 + -6.000002);
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.x = tmp3.z * 0.5 + tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.xyz = saturate(tmp0.xxx * tmp2.xyz);
                tmp0.xyz = tmp0.xyz * _Color.xyz;
                tmp0.xyz = tmp0.xyz * _Color.www;
                o.sv_target.xyz = tmp0.xyz * float3(4.0, 4.0, 4.0);
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/RanchTech/RanchBarrier Low"
	CustomEditor "ShaderForgeMaterialInspector"
}