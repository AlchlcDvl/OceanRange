Shader "SR/Slime/Face Tarr" {
	Properties {
		_FaceTexture ("Face Texture", 2D) = "white" {}
		_Depth ("Depth", 2D) = "white" {}
		_ColorRamp ("Color-Ramp", 2D) = "white" {}
		_Noise ("Noise", Cube) = "_Skybox" {}
		_XWiggleSpeed ("X Wiggle Speed", Float) = 10
		_YWiggleSpeed ("Y Wiggle Speed", Float) = -10
		_WiggleAmplitude ("Wiggle Amplitude", Float) = 0.005
		_ScaleAmplitude ("Scale Amplitude", Float) = 0.1
		_XScaleSpeed ("X Scale Speed", Float) = 5
		_YScaleSpeed ("Y Scale Speed", Float) = -5
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+500" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+500" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 12411
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
			float4 _Depth_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorRamp_ST;
			float4 _FaceTexture_ST;
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			float _ScaleAmplitude;
			float _XScaleSpeed;
			float _YScaleSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Depth;
			// Texture params for Fragment Shader
			sampler2D _FaceTexture;
			samplerCUBE _Noise;
			sampler2D _ColorRamp;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                tmp0 = _Time * float4(0.05, -0.125, 0.0, 0.1) + v.texcoord.xyxy;
                tmp1.xy = float2(0.0, 0.0);
                while (true) {
                    tmp1.z = i >= 8;
                    if (tmp1.z) {
                        break;
                    }
                    i = i + 1;
                    tmp1.zw = tmp0.xy * tmp1.zz;
                    tmp2.xy = floor(tmp1.zw);
                    tmp1.zw = frac(tmp1.zw);
                    tmp2.zw = tmp1.zw * tmp1.zw;
                    tmp1.zw = -tmp1.zw * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp1.zw = tmp1.zw * tmp2.zw;
                    tmp2.x = tmp2.y * 57.0 + tmp2.x;
                    tmp2.yzw = tmp2.xxx + float3(1.0, 57.0, 58.0);
                    tmp3 = sin(tmp2);
                    tmp2 = tmp3 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp2 = frac(tmp2);
                    tmp2.yw = tmp2.yw - tmp2.xz;
                    tmp2.xy = tmp1.zz * tmp2.yw + tmp2.xz;
                    tmp1.z = tmp2.y - tmp2.x;
                    tmp1.z = tmp1.w * tmp1.z + tmp2.x;
                    tmp1.w = null.w / 8;
                    tmp1.x = tmp1.z * tmp1.w + tmp1.x;
                }
                tmp0.x = tmp1.x * 0.125;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp1.xy = float2(1.0, 1.0) - v.texcoord.yx;
                tmp1.xy = tmp1.xy * v.texcoord.yx;
                tmp0.y = tmp1.x * 5.0;
                tmp1.x = tmp1.y * tmp0.y;
                tmp1.x = saturate(tmp1.x * 5.0);
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.xz = tmp0.xx * float2(0.01, 0.01) + tmp0.zw;
                tmp0.xz = tmp0.xz * _Depth_ST.xy + _Depth_ST.zw;
                tmp1 = tex2Dlod(_Depth, float4(tmp0.xz, 0, 0.0));
                tmp0.xzw = tmp1.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.yyy * tmp0.xzw;
                tmp1.xyz = v.normal.xyz * float3(0.0025, 0.0025, 0.0025);
                tmp0.xyz = tmp0.xyz * float3(0.05, 0.05, 0.05) + tmp1.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
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
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xy = float2(_XScaleSpeed.x, _YScaleSpeed.x) * _Time.yy;
                tmp2.xy = sin(tmp2.xy);
                tmp2.zw = tmp2.xy * _ScaleAmplitude.xx;
                tmp3.xy = _Time.yy * float2(0.05, -0.125) + inp.texcoord.xy;
                tmp0.w = 0.0;
                tmp1.w = 0.0;
                while (true) {
                    tmp3.z = i >= 8;
                    if (tmp3.z) {
                        break;
                    }
                    i = i + 1;
                    tmp3.zw = tmp3.zz * tmp3.xy;
                    tmp4.xy = floor(tmp3.zw);
                    tmp3.zw = frac(tmp3.zw);
                    tmp4.zw = tmp3.zw * tmp3.zw;
                    tmp3.zw = -tmp3.zw * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp3.zw = tmp3.zw * tmp4.zw;
                    tmp4.x = tmp4.y * 57.0 + tmp4.x;
                    tmp4.yzw = tmp4.xxx + float3(1.0, 57.0, 58.0);
                    tmp5 = sin(tmp4);
                    tmp4 = tmp5 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp4 = frac(tmp4);
                    tmp4.yw = tmp4.yw - tmp4.xz;
                    tmp4.xy = tmp3.zz * tmp4.yw + tmp4.xz;
                    tmp3.z = tmp4.y - tmp4.x;
                    tmp3.z = tmp3.w * tmp3.z + tmp4.x;
                    tmp3.w = null.w / 8;
                    tmp0.w = tmp3.z * tmp3.w + tmp0.w;
                }
                tmp0.w = tmp0.w * 0.125;
                tmp1.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.w;
                tmp3.xy = float2(1.0, 1.0) - inp.texcoord.yx;
                tmp3.xy = tmp3.xy * inp.texcoord.yx;
                tmp1.w = tmp3.x * 5.0;
                tmp1.w = tmp3.y * tmp1.w;
                tmp1.w = saturate(tmp1.w * 5.0);
                tmp0.w = tmp0.w * tmp1.w;
                tmp2.xy = tmp2.xy * _ScaleAmplitude.xx + float2(1.0, 1.0);
                tmp2.xy = tmp2.xy * inp.texcoord.xy;
                tmp2.xy = tmp2.zw * float2(-0.5, -0.5) + tmp2.xy;
                tmp2.zw = float2(_XWiggleSpeed.x, _YWiggleSpeed.x) * _Time.yy;
                tmp2.zw = sin(tmp2.zw);
                tmp2.zw = _WiggleAmplitude.xx * tmp2.zw + inp.texcoord.xy;
                tmp2.xy = tmp2.zw + tmp2.xy;
                tmp2.xy = tmp2.xy * float2(0.25, 0.25) + float2(0.667, 0.667);
                tmp2.zw = tmp0.ww * float2(0.015, 0.015) + inp.texcoord.xy;
                tmp2.xy = tmp2.zw * tmp2.xy;
                tmp2.xy = tmp2.xy * _FaceTexture_ST.xy + _FaceTexture_ST.zw;
                tmp2 = tex2D(_FaceTexture, tmp2.xy);
                tmp0.w = tmp2.w - 0.5;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = dot(tmp0.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp1.xyz = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                tmp1 = texCUBElod(_Noise, float4(tmp0.xyz, 2.0));
                tmp0.x = _Time.y * 0.333 + tmp1.x;
                tmp0.y = 0.0;
                tmp0.xy = tmp0.xy + tmp0.ww;
                tmp0.xy = tmp0.xy * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp1 = tex2D(_ColorRamp, tmp0.xy);
                tmp0.xyz = tmp1.xyz * float3(1.5, 1.5, 1.5);
                tmp1.w = dot(tmp0.xyz, float3(0.3, 0.59, 0.11));
                tmp1.xyz = -tmp1.xyz * float3(1.5, 1.5, 1.5) + tmp1.www;
                tmp0.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25) + tmp0.xyz;
                tmp1.x = dot(tmp0.xyz, float3(0.3, 0.59, 0.11));
                tmp1.xyz = tmp1.xxx - tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.333, 0.333, 0.333) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(0.333, 0.333, 0.333);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 1.5;
                tmp0.w = exp(tmp0.w);
                tmp0.w = saturate(tmp0.w * -4.0 + 2.0);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Transparent+500" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 123975
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Depth_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _FaceTexture_ST;
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			float _ScaleAmplitude;
			float _XScaleSpeed;
			float _YScaleSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Depth;
			// Texture params for Fragment Shader
			sampler2D _FaceTexture;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                tmp0 = _Time * float4(0.05, -0.125, 0.0, 0.1) + v.texcoord.xyxy;
                tmp1.xy = float2(0.0, 0.0);
                while (true) {
                    tmp1.z = i >= 8;
                    if (tmp1.z) {
                        break;
                    }
                    i = i + 1;
                    tmp1.zw = tmp0.xy * tmp1.zz;
                    tmp2.xy = floor(tmp1.zw);
                    tmp1.zw = frac(tmp1.zw);
                    tmp2.zw = tmp1.zw * tmp1.zw;
                    tmp1.zw = -tmp1.zw * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp1.zw = tmp1.zw * tmp2.zw;
                    tmp2.x = tmp2.y * 57.0 + tmp2.x;
                    tmp2.yzw = tmp2.xxx + float3(1.0, 57.0, 58.0);
                    tmp3 = sin(tmp2);
                    tmp2 = tmp3 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp2 = frac(tmp2);
                    tmp2.yw = tmp2.yw - tmp2.xz;
                    tmp2.xy = tmp1.zz * tmp2.yw + tmp2.xz;
                    tmp1.z = tmp2.y - tmp2.x;
                    tmp1.z = tmp1.w * tmp1.z + tmp2.x;
                    tmp1.w = null.w / 8;
                    tmp1.x = tmp1.z * tmp1.w + tmp1.x;
                }
                tmp0.x = tmp1.x * 0.125;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp1.xy = float2(1.0, 1.0) - v.texcoord.yx;
                tmp1.xy = tmp1.xy * v.texcoord.yx;
                tmp0.y = tmp1.x * 5.0;
                tmp1.x = tmp1.y * tmp0.y;
                tmp1.x = saturate(tmp1.x * 5.0);
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.xz = tmp0.xx * float2(0.01, 0.01) + tmp0.zw;
                tmp0.xz = tmp0.xz * _Depth_ST.xy + _Depth_ST.zw;
                tmp1 = tex2Dlod(_Depth, float4(tmp0.xz, 0, 0.0));
                tmp0.xzw = tmp1.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.yyy * tmp0.xzw;
                tmp1.xyz = v.normal.xyz * float3(0.0025, 0.0025, 0.0025);
                tmp0.xyz = tmp0.xyz * float3(0.05, 0.05, 0.05) + tmp1.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
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
                tmp1.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp1.x + tmp0.z;
                o.position.xyw = tmp0.xyw;
                o.texcoord1.xy = v.texcoord.xy;
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
                float4 tmp4;
                tmp0.xy = float2(_XScaleSpeed.x, _YScaleSpeed.x) * _Time.yy;
                tmp0.xy = sin(tmp0.xy);
                tmp0.zw = tmp0.xy * _ScaleAmplitude.xx;
                tmp1.xy = _Time.yy * float2(0.05, -0.125) + inp.texcoord1.xy;
                tmp1.zw = float2(0.0, 0.0);
                while (true) {
                    tmp2.x = i >= 8;
                    if (tmp2.x) {
                        break;
                    }
                    i = i + 1;
                    tmp2.xy = tmp1.xy * tmp2.xx;
                    tmp2.zw = floor(tmp2.xy);
                    tmp2.xy = frac(tmp2.xy);
                    tmp3.xy = tmp2.xy * tmp2.xy;
                    tmp2.xy = -tmp2.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp2.xy = tmp2.xy * tmp3.xy;
                    tmp2.z = tmp2.w * 57.0 + tmp2.z;
                    tmp3.xyz = tmp2.zzz + float3(1.0, 57.0, 58.0);
                    tmp4.x = sin(tmp2.z);
                    tmp4.yzw = sin(tmp3.xyz);
                    tmp3 = tmp4 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp3 = frac(tmp3);
                    tmp2.zw = tmp3.yw - tmp3.xz;
                    tmp2.xz = tmp2.xx * tmp2.zw + tmp3.xz;
                    tmp2.z = tmp2.z - tmp2.x;
                    tmp2.x = tmp2.y * tmp2.z + tmp2.x;
                    tmp2.y = null.y / 8;
                    tmp1.z = tmp2.x * tmp2.y + tmp1.z;
                }
                tmp1.x = tmp1.z * 0.125;
                tmp1.y = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yz = float2(1.0, 1.0) - inp.texcoord1.yx;
                tmp1.yz = tmp1.yz * inp.texcoord1.yx;
                tmp1.y = tmp1.y * 5.0;
                tmp1.y = tmp1.z * tmp1.y;
                tmp1.y = saturate(tmp1.y * 5.0);
                tmp1.x = tmp1.y * tmp1.x;
                tmp0.xy = tmp0.xy * _ScaleAmplitude.xx + float2(1.0, 1.0);
                tmp0.xy = tmp0.xy * inp.texcoord1.xy;
                tmp0.xy = tmp0.zw * float2(-0.5, -0.5) + tmp0.xy;
                tmp0.zw = float2(_XWiggleSpeed.x, _YWiggleSpeed.x) * _Time.yy;
                tmp0.zw = sin(tmp0.zw);
                tmp0.zw = _WiggleAmplitude.xx * tmp0.zw + inp.texcoord1.xy;
                tmp0.xy = tmp0.zw + tmp0.xy;
                tmp0.xy = tmp0.xy * float2(0.25, 0.25) + float2(0.667, 0.667);
                tmp0.zw = tmp1.xx * float2(0.015, 0.015) + inp.texcoord1.xy;
                tmp0.xy = tmp0.zw * tmp0.xy;
                tmp0.xy = tmp0.xy * _FaceTexture_ST.xy + _FaceTexture_ST.zw;
                tmp0 = tex2D(_FaceTexture, tmp0.xy);
                tmp0.x = tmp0.w - 0.5;
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
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}