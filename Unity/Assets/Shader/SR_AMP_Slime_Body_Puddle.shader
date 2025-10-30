Shader "SR/AMP/Slime/Body/Puddle" {
	Properties {
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		_Gloss ("Gloss", Range(0, 2)) = 0
		[NoScaleOffset] _CubemapOverride ("Puddle Panning Refraction", 2D) = "black" {}
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		[Toggle] _OverrideAlphaUV1 ("Override Alpha UV1", Float) = 0
		_OverrideBlend ("Override Blend", Range(0, 1)) = 1
		_VertexOffset ("Vertex Offset", Float) = 0.3
		_VertexNoise ("Vertex Noise", 2D) = "black" {}
		[HideInInspector] _texcoord2 ("", 2D) = "white" {}
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 46417
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
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _VertexOffset;
			float4 _texcoord_ST;
			float4 _texcoord2_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BottomColor;
			float4 _MiddleColor;
			float _Gloss;
			float _GlossPower;
			float4 _TopColor;
			float _OverrideAlphaUV1;
			float _OverrideBlend;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _VertexNoise;
			// Texture params for Fragment Shader
			sampler2D _CubemapOverride;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.yy * unity_ObjectToWorld._m21_m01;
                tmp0.xy = unity_ObjectToWorld._m20_m00 * v.vertex.xx + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m22_m02 * v.vertex.zz + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m23_m03 * v.vertex.ww + tmp0.xy;
                tmp0.xy = _Time.yy * float2(0.1, 0.1) + tmp0.xy;
                tmp0 = tex2Dlod(_VertexNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.y = v.texcoord.y - 0.2;
                tmp0.y = saturate(tmp0.y * -4.0 + 1.0);
                tmp0.x = tmp0.y * tmp0.x;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp0.zwy * float3(1.0, 0.0, 1.0);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _VertexOffset.xxx + v.vertex.xyz;
                tmp2 = tmp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord.zw = v.texcoord1.xy * _texcoord2_ST.xy + _texcoord2_ST.zw;
                o.texcoord1.w = tmp1.x;
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
                o.texcoord1.y = tmp3.x;
                o.texcoord1.z = tmp0.z;
                o.texcoord1.x = tmp2.z;
                o.texcoord2.x = tmp2.x;
                o.texcoord3.x = tmp2.y;
                o.texcoord2.z = tmp0.w;
                o.texcoord3.z = tmp0.y;
                o.texcoord2.w = tmp1.y;
                o.texcoord3.w = tmp1.z;
                o.texcoord2.y = tmp3.y;
                o.texcoord3.y = tmp3.z;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
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
                tmp0.x = _GlossPower * 16.0 + -1.0;
                tmp0.x = exp(tmp0.x);
                tmp1.y = inp.texcoord2.w;
                tmp1.x = inp.texcoord1.w;
                tmp1.z = inp.texcoord3.w;
                tmp0.yzw = _WorldSpaceCameraPos - tmp1.xyz;
                tmp1.xy = tmp1.xz * float2(0.5, 0.5) + float2(1.0, 1.0);
                tmp1.xy = tmp1.xy * float2(0.5, 0.5);
                tmp1.xy = _Time.yy * float2(0.05, 0.05) + tmp1.xy;
                tmp1 = tex2D(_CubemapOverride, tmp1.xy);
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = max(tmp1.w, 0.001);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp0.yzw * tmp1.www + float3(0.0, 1.0, 0.0);
                tmp0.yzw = tmp0.yzw * tmp1.www;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp3.x = inp.texcoord1.z;
                tmp3.y = inp.texcoord2.z;
                tmp3.z = inp.texcoord3.z;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp1.www * tmp3.xyz;
                tmp1.w = dot(tmp3.xyz, tmp0.xyz);
                tmp0.y = dot(tmp4.xyz, tmp0.xyz);
                tmp0.z = dot(tmp4.xyz, tmp2.xyz);
                tmp0.z = tmp0.z + 1.0;
                tmp0.z = tmp0.z * 0.5;
                tmp0.z = log(tmp0.z);
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.x = exp(tmp0.x);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.z = 1.0 - tmp1.w;
                tmp0.w = tmp0.x * tmp0.x;
                tmp0.w = tmp0.w * _Gloss;
                tmp0.x = tmp0.x * tmp0.w;
                tmp0.w = inp.texcoord2.z + 1.0;
                tmp0.w = saturate(tmp0.w * 0.375 + -0.5);
                tmp0.z = tmp0.z * tmp0.z + tmp0.w;
                tmp0.z = tmp0.x * 0.625 + tmp0.z;
                tmp0.w = tmp0.y * tmp0.y;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.y = saturate(tmp0.y * 0.5 + tmp0.z);
                tmp0.z = tmp0.y * 2.0 + -1.0;
                tmp0.z = max(tmp0.z, 0.0);
                tmp2.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _TopColor.xyz;
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = _TopColor.www * tmp2.xyz + tmp3.xyz;
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _MiddleColor.xyz;
                tmp4.xyz = _MiddleColor.www * tmp4.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp2.xyz = tmp0.yyy * tmp2.xyz + tmp4.xyz;
                tmp5.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _BottomColor.xyz;
                tmp5.xyz = _BottomColor.www * tmp5.xyz + tmp3.xyz;
                tmp4.xyz = tmp4.xyz - tmp5.xyz;
                tmp4.xyz = tmp0.yyy * tmp4.xyz + tmp5.xyz;
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp0.yzw = tmp0.zzz * tmp2.xyz + tmp4.xyz;
                tmp2.xyz = tmp0.xxx * float3(0.625, 0.625, 0.625) + tmp0.yzw;
                tmp2.xyz = -tmp3.xyz * tmp0.yzw + tmp2.xyz;
                tmp0.xyz = tmp0.yzw * tmp3.xyz;
                tmp0.xyz = tmp2.xyz * float3(0.8, 0.8, 0.8) + tmp0.xyz;
                tmp2.xy = inp.texcoord.zw - inp.texcoord.xy;
                tmp2.xy = _OverrideAlphaUV1.xx * tmp2.xy + inp.texcoord.xy;
                tmp2 = tex2D(_CubemapOverride, tmp2.xy);
                tmp0.w = tmp2.w * _OverrideBlend;
                tmp0.xyz = saturate(tmp1.xyz * tmp0.www + tmp0.xyz);
                tmp0.xyz = tmp0.xyz * float3(1.3, 1.3, 1.3);
                o.sv_target.xyz = min(tmp0.xyz, float3(1.0, 1.0, 1.0));
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 105874
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
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float _VertexOffset;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _VertexNoise;
			// Texture params for Fragment Shader
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.yy * unity_ObjectToWorld._m21_m01;
                tmp0.xy = unity_ObjectToWorld._m20_m00 * v.vertex.xx + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m22_m02 * v.vertex.zz + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m23_m03 * v.vertex.ww + tmp0.xy;
                tmp0.xy = _Time.yy * float2(0.1, 0.1) + tmp0.xy;
                tmp0 = tex2Dlod(_VertexNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.y = v.texcoord.y - 0.2;
                tmp0.y = saturate(tmp0.y * -4.0 + 1.0);
                tmp0.x = tmp0.y * tmp0.x;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp0.zwy * float3(1.0, 0.0, 1.0);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _VertexOffset.xxx + v.vertex.xyz;
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
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 1.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}