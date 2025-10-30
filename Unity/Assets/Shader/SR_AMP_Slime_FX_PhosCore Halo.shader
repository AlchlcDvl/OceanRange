Shader "SR/AMP/Slime/FX/PhosCore Halo" {
	Properties {
		[HDR] _GlowTop ("Glow Color", Color) = (1,1,0,1)
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_GlowMin ("Glow Min", Range(0, 1)) = 0
		_GlowMax ("Glow Max", Range(0, 1)) = 1
		_GlowSpeed ("Glow Speed", Float) = 0.8
		_OffsetNoise ("Offset Noise", 2D) = "black" {}
		_OffsetMultiplier ("Offset Multiplier", Float) = 0.1
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			AlphaToMask On
			GpuProgramID 9853
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _OffsetNoise_ST;
			float _OffsetMultiplier;
			// $Globals ConstantBuffers for Fragment Shader
			float _Gloss;
			float _GlossPower;
			float4 _GlowTop;
			float _GlowSpeed;
			float _GlowMin;
			float _GlowMax;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _OffsetNoise;
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.texcoord.xy * _OffsetNoise_ST.xy + _OffsetNoise_ST.zw;
                tmp0.xy = _Time.yy * float2(0.5, 0.1) + tmp0.xy;
                tmp0 = tex2Dlod(_OffsetNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp0.xxx * tmp0.zwy;
                tmp1.xyz = tmp1.xyz * _OffsetMultiplier.xxx + v.vertex.xyz;
                tmp2 = tmp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = tmp0.yzw * tmp2.xyz;
                tmp3.xyz = tmp0.wyz * tmp2.yzx + -tmp3.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord.y = tmp3.x;
                o.texcoord.w = tmp1.x;
                o.texcoord.z = tmp0.z;
                o.texcoord.x = tmp2.z;
                o.texcoord1.x = tmp2.x;
                o.texcoord2.x = tmp2.y;
                o.texcoord1.z = tmp0.w;
                o.texcoord2.z = tmp0.y;
                o.texcoord1.w = tmp1.y;
                o.texcoord2.w = tmp1.z;
                o.texcoord1.y = tmp3.y;
                o.texcoord2.y = tmp3.z;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = inp.texcoord.w;
                tmp0.y = inp.texcoord1.w;
                tmp0.z = inp.texcoord2.w;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = max(tmp0.w, 0.001);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.xyz * tmp0.www + float3(0.0, 1.0, 0.0);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.x = inp.texcoord.z;
                tmp2.y = inp.texcoord1.z;
                tmp2.z = inp.texcoord2.z;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp2.xyz, tmp1.xyz);
                tmp0.x = dot(tmp2.xyz, tmp0.xyz);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = tmp0.w + 1.0;
                tmp0.y = tmp0.y * 0.5;
                tmp0.y = log(tmp0.y);
                tmp0.z = _GlossPower * 16.0 + -1.0;
                tmp0.z = exp(tmp0.z);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = exp(tmp0.y);
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.z = tmp0.z * _Gloss;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = log(tmp0.x);
                tmp0.z = tmp0.z * 0.15;
                tmp0.z = exp(tmp0.z);
                tmp0.zw = float2(1.0, 0.8) - tmp0.zz;
                tmp0.w = saturate(tmp0.w * -5.0);
                tmp1.x = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.y = tmp1.x * tmp0.w + tmp0.y;
                tmp0.z = tmp1.x * tmp0.w + tmp0.z;
                tmp0.yzw = _GlowTop.xyz * tmp0.zzz + tmp0.yyy;
                tmp0.x = tmp0.x * -0.75 + tmp1.y;
                tmp0.x = tmp0.x + 0.75;
                tmp1.x = _GlowSpeed * _Time.y;
                tmp1.x = sin(tmp1.x);
                tmp1.x = tmp1.x + 1.0;
                tmp1.x = tmp1.x * 2.0 + -3.0;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.y = _GlowMax - _GlowMin;
                tmp1.x = tmp1.x * tmp1.y + _GlowMin;
                o.sv_target = tmp0.yzwx * tmp1.xxxx;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
			Blend One One, One One
			AlphaToMask On
			ZWrite Off
			GpuProgramID 76268
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _OffsetNoise_ST;
			float _OffsetMultiplier;
			// $Globals ConstantBuffers for Fragment Shader
			float _Gloss;
			float _GlossPower;
			float _GlowSpeed;
			float _GlowMin;
			float _GlowMax;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _OffsetNoise;
			// Texture params for Fragment Shader
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.texcoord.xy * _OffsetNoise_ST.xy + _OffsetNoise_ST.zw;
                tmp0.xy = _Time.yy * float2(0.5, 0.1) + tmp0.xy;
                tmp0 = tex2Dlod(_OffsetNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp0.xxx * tmp0.zwy;
                tmp1.xyz = tmp1.xyz * _OffsetMultiplier.xxx + v.vertex.xyz;
                tmp2 = tmp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = tmp0.yzw * tmp2.xyz;
                tmp3.xyz = tmp0.wyz * tmp2.yzx + -tmp3.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord.y = tmp3.x;
                o.texcoord.z = tmp0.z;
                o.texcoord.x = tmp2.z;
                o.texcoord1.x = tmp2.x;
                o.texcoord2.x = tmp2.y;
                o.texcoord1.z = tmp0.w;
                o.texcoord2.z = tmp0.y;
                o.texcoord1.y = tmp3.y;
                o.texcoord2.y = tmp3.z;
                o.texcoord3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = inp.texcoord.z;
                tmp0.y = inp.texcoord1.z;
                tmp0.z = inp.texcoord2.z;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.001);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp1.xyz * tmp0.www + float3(0.0, 1.0, 0.0);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp1.xyz);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.x = dot(tmp2.xyz, tmp2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * tmp2.xyz;
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = tmp0.x + 1.0;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = log(tmp0.x);
                tmp0.y = _GlossPower * 16.0 + -1.0;
                tmp0.y = exp(tmp0.y);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = exp(tmp0.x);
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.y * _Gloss;
                tmp0.z = log(tmp0.w);
                tmp0.z = tmp0.z * 0.15;
                tmp0.z = exp(tmp0.z);
                tmp0.z = 0.8 - tmp0.z;
                tmp0.z = saturate(tmp0.z * -5.0);
                tmp1.x = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp1.x;
                tmp0.x = tmp0.y * tmp0.x + tmp0.z;
                tmp0.x = tmp0.w * -0.75 + tmp0.x;
                tmp0.x = tmp0.x + 0.75;
                tmp0.y = _GlowSpeed * _Time.y;
                tmp0.y = sin(tmp0.y);
                tmp0.y = tmp0.y + 1.0;
                tmp0.y = tmp0.y * 2.0 + -3.0;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.z = _GlowMax - _GlowMin;
                tmp0.y = tmp0.y * tmp0.z + _GlowMin;
                o.sv_target.w = tmp0.y * tmp0.x;
                o.sv_target.xyz = float3(0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}