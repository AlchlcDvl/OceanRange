// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "SR/FX/Animated Echo" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_TintColor ("Color", Color) = (1,1,1,1)
		_SoftParticlesFactor ("Soft Particles Factor", Range(0, 3)) = 1
		_TilesX ("Tiles X", Float) = 16
		_TilesY ("Tiles Y", Float) = -16
		_TilesOffset ("Tiles Offset", Float) = 0
		_AnimationSpeed ("Animation Speed", Float) = 0.1
		_Brightness ("Brightness", Float) = 1
		_HueVariance ("Hue Variance", Range(0, 1)) = 0
		_HueSpeed ("Hue Speed", Float) = 1
	}
	SubShader {
		LOD 550
		Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Overlay" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ColorMask RGB
			ZWrite Off
			GpuProgramID 29037
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _MainTex_ST;
			float4 _TintColor;
			float _SoftParticlesFactor;
			float _TilesX;
			float _TilesY;
			float _TilesOffset;
			float _AnimationSpeed;
			float _Brightness;
			float _HueVariance;
			float _HueSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = unity_WorldToObject._m10;
                tmp0.y = unity_WorldToObject._m11;
                tmp0.z = unity_WorldToObject._m12;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.z = -1.0 / tmp0.x;
                tmp1 = unity_ObjectToWorld._m13_m13_m13_m13 * unity_MatrixV._m01_m11_m21_m31;
                tmp1 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = unity_MatrixV._m03_m23_m13_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1.xzyw;
                tmp0.yw = tmp1.xz;
                tmp0.z = dot(tmp0.xy, v.vertex.xy);
                tmp2 = tmp0.zzzz * UNITY_MATRIX_P._m01_m11_m21_m31;
                tmp3.x = unity_WorldToObject._m00;
                tmp3.y = unity_WorldToObject._m01;
                tmp3.z = unity_WorldToObject._m02;
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.x = -1.0 / tmp0.z;
                tmp0.x = dot(tmp0.xy, v.vertex.xy);
                tmp0 = UNITY_MATRIX_P._m00_m10_m20_m30 * tmp0.xxxx + tmp2;
                tmp2.x = unity_WorldToObject._m20;
                tmp2.y = unity_WorldToObject._m21;
                tmp2.z = unity_WorldToObject._m22;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2.x = sqrt(tmp2.x);
                tmp1.x = -1.0 / tmp2.x;
                tmp2.x = dot(tmp1.xy, v.vertex.xy);
                tmp0 = UNITY_MATRIX_P._m02_m12_m22_m32 * tmp2.xxxx + tmp0;
                tmp2.x = unity_ObjectToWorld._m10 * unity_MatrixV._m31;
                tmp2.x = unity_MatrixV._m30 * unity_ObjectToWorld._m00 + tmp2.x;
                tmp2.x = unity_MatrixV._m32 * unity_ObjectToWorld._m20 + tmp2.x;
                tmp1.x = unity_MatrixV._m33 * unity_ObjectToWorld._m30 + tmp2.x;
                tmp2.x = unity_ObjectToWorld._m11 * unity_MatrixV._m31;
                tmp2.x = unity_MatrixV._m30 * unity_ObjectToWorld._m01 + tmp2.x;
                tmp2.x = unity_MatrixV._m32 * unity_ObjectToWorld._m21 + tmp2.x;
                tmp1.z = unity_MatrixV._m33 * unity_ObjectToWorld._m31 + tmp2.x;
                tmp2.x = unity_ObjectToWorld._m12 * unity_MatrixV._m31;
                tmp2.x = unity_MatrixV._m30 * unity_ObjectToWorld._m02 + tmp2.x;
                tmp2.x = unity_MatrixV._m32 * unity_ObjectToWorld._m22 + tmp2.x;
                tmp1.y = unity_MatrixV._m33 * unity_ObjectToWorld._m32 + tmp2.x;
                tmp1.x = dot(tmp1, v.vertex);
                tmp0 = UNITY_MATRIX_P._m03_m13_m23_m33 * tmp1.xxxx + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.color = v.color;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord1.w = tmp0.w;
                o.texcoord1.xy = tmp1.zz + tmp1.xw;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.y = tmp0.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp0.x + tmp0.y;
                tmp0.x = unity_MatrixV._m22 * tmp0.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp0.w + tmp0.x;
                o.texcoord1.z = -tmp0.x;
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
                tmp0.x = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.x = tmp0.x + unity_ObjectToWorld._m23;
                tmp0.y = _TimeEditor.y + _Time.y;
                tmp0.x = tmp0.x * 2.0 + tmp0.y;
                tmp0.xy = tmp0.xx * float2(_AnimationSpeed.x, _HueSpeed.x);
                tmp0.x = frac(tmp0.x);
                tmp0.y = sin(tmp0.y);
                tmp0.z = _TilesY * _TilesX;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.x = floor(tmp0.x);
                tmp0.x = tmp0.x + _TilesOffset;
                tmp0.zw = float2(1.0, 1.0) / float2(_TilesX.x, _TilesY.x);
                tmp1.x = tmp0.z * tmp0.x;
                tmp1.y = floor(tmp1.x);
                tmp1.x = -_TilesX * tmp1.y + tmp0.x;
                tmp1.xy = tmp1.xy + inp.texcoord.xy;
                tmp0.xz = tmp0.zw * tmp1.xy;
                tmp0.xz = tmp0.xz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.xz);
                tmp0.xzw = saturate(tmp1.xyz * float3(50.0, 50.0, 50.0) + float3(-30.0, -30.0, -30.0));
                tmp0.xzw = tmp1.xyz + tmp0.xzw;
                tmp0.xzw = tmp0.xzw * inp.color.xyz;
                tmp2.xyw = tmp0.zwx * _TintColor.yzx;
                tmp0.x = tmp2.x >= tmp2.y;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp3.xy = tmp2.yx;
                tmp4.xy = tmp0.zw * _TintColor.yz + -tmp3.xy;
                tmp3.zw = float2(-1.0, 0.6666667);
                tmp4.zw = float2(1.0, -1.0);
                tmp3 = tmp0.xxxx * tmp4 + tmp3;
                tmp0.x = tmp2.w >= tmp3.x;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp2.xyz = tmp3.xyw;
                tmp3.xyw = tmp2.wyx;
                tmp3 = tmp3 - tmp2;
                tmp2 = tmp0.xxxx * tmp3 + tmp2;
                tmp0.x = min(tmp2.y, tmp2.w);
                tmp0.x = tmp2.x - tmp0.x;
                tmp0.z = tmp0.x * 6.0 + 0.0;
                tmp0.w = tmp2.w - tmp2.y;
                tmp0.z = tmp0.w / tmp0.z;
                tmp0.z = tmp0.z + tmp2.z;
                tmp0.y = tmp0.y * _HueVariance + abs(tmp0.z);
                tmp0.yzw = tmp0.yyy + float3(0.0, -0.3333333, 0.3333333);
                tmp0.yzw = frac(tmp0.yzw);
                tmp0.yzw = -tmp0.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.yzw = saturate(abs(tmp0.yzw) * float3(3.0, 3.0, 3.0) + float3(-1.0, -1.0, -1.0));
                tmp0.yzw = tmp0.yzw - float3(1.0, 1.0, 1.0);
                tmp2.y = tmp2.x + 0.0;
                tmp0.x = tmp0.x / tmp2.y;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp2.xxx * tmp0.xyz;
                tmp0.w = tmp1.w * inp.color.w;
                tmp1.xyz = saturate(tmp1.xyz * float3(16.66666, 16.66666, 16.66666) + float3(-15.0, -15.0, -15.0));
                tmp0.w = tmp0.w * _TintColor.w;
                tmp0.xyz = tmp0.xyz * tmp0.www + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _Brightness.xxx;
                tmp1.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1 = tex2D(_CameraDepthTexture, tmp1.xy);
                tmp0.w = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = tmp0.w - _ProjectionParams.y;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.x = inp.texcoord1.z - _ProjectionParams.y;
                tmp1.x = max(tmp1.x, 0.0);
                tmp0.w = tmp0.w - tmp1.x;
                tmp0.w = saturate(tmp0.w / _SoftParticlesFactor);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/FX/Animated Echo Low"
	CustomEditor "ShaderForgeMaterialInspector"
}