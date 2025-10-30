Shader "SR/AMP/FX/BoomExploder Ring" {
	Properties {
		_Cutoff ("Mask Clip Value", Float) = 0.5
		[NoScaleOffset] _GradientMap ("Gradient Map", 2D) = "white" {}
		_ExplosionMasks ("Explosion Masks", 2D) = "black" {}
		_Alpha ("Alpha", Range(0, 1)) = 1
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IsEmissive" = "true" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
		Pass {
			Name "FORWARD"
			Tags { "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			Cull Off
			GpuProgramID 22878
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ExplosionMasks_ST;
			float _Alpha;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _ExplosionMasks;
			sampler2D _GradientMap;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.color = v.color;
                tmp1.x = tmp0.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp0.xw * float2(0.5, 0.5);
                tmp0.xy = tmp1.zz + tmp1.xw;
                o.texcoord3 = tmp0;
                o.texcoord4 = tmp0;
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
                tmp0.xyz = inp.texcoord3.zxy / inp.texcoord3.www;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.yz);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.y = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.x = tmp0.y - tmp0.x;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = min(abs(tmp0.x), 1.0);
                tmp0.x = tmp0.x * -0.5;
                tmp1 = inp.texcoord.xyxy * _ExplosionMasks_ST + _ExplosionMasks_ST;
                tmp1 = _Time * float4(0.0, -0.25, 0.0, -0.5) + tmp1;
                tmp2 = tex2D(_ExplosionMasks, tmp1.xy);
                tmp1 = tex2D(_ExplosionMasks, tmp1.zw);
                tmp0.y = tmp1.y * -0.2 + 1.0;
                tmp0.z = tmp2.x * -0.2 + 1.0;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.zw = inp.texcoord2.xz * float2(0.15, 0.15);
                tmp1 = tex2D(_ExplosionMasks, tmp0.zw);
                tmp0.z = 1.0 - tmp1.x;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x + 0.5;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.z = 1.0 - inp.color.x;
                tmp0.y = -tmp0.z * tmp0.y + 1.0;
                tmp0.z = inp.color.x * 0.5 + 0.5;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.z > 0.5;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.y = inp.color.w * _Alpha;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.yzw = inp.texcoord4.zxy / inp.texcoord4.www;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.zw);
                tmp0.y = _ZBufferParams.z * tmp0.y + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.y = tmp0.z - tmp0.y;
                tmp0.y = tmp0.y * 4.0;
                tmp0.y = min(abs(tmp0.y), 1.0);
                tmp0.x = tmp0.x * tmp0.y + -0.5;
                tmp0.x = saturate(tmp0.x * 3.333333);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.z = tmp0.y * tmp0.x + -_Cutoff;
                tmp0.y = -tmp0.y * tmp0.x + 1.0;
                tmp0.z = tmp0.z < 0.0;
                if (tmp0.z) {
                    discard;
                }
                tmp0.x = 0.5;
                tmp0 = tex2D(_GradientMap, tmp0.xy);
                tmp1.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = glstate_lightmodel_ambient.xyz * float3(0.4, 0.4, 0.4) + float3(0.4, 0.4, 0.4);
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp3.xyz = tmp0.xyz * tmp3.xyz;
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp2.xyz = -tmp2.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp3.xyz);
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp0.xyz = tmp0.www * tmp0.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp0.www * float3(2.26, 0.07, 0.0) + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
			Blend One One, One One
			ZWrite Off
			Cull Off
			GpuProgramID 128555
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ExplosionMasks_ST;
			float _Alpha;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _ExplosionMasks;
			
			// Keywords: POINT
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
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                o.texcoord1.xyz = tmp2.www * tmp2.xyz;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.color = v.color;
                tmp2.x = tmp1.y * _ProjectionParams.x;
                tmp2.w = tmp2.x * 0.5;
                tmp2.xz = tmp1.xw * float2(0.5, 0.5);
                tmp1.xy = tmp2.zz + tmp2.xw;
                o.texcoord3 = tmp1;
                o.texcoord4 = tmp1;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = inp.texcoord3.zxy / inp.texcoord3.www;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.yz);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.y = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.x = tmp0.y - tmp0.x;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = min(abs(tmp0.x), 1.0);
                tmp0.x = tmp0.x * -0.5;
                tmp1 = inp.texcoord.xyxy * _ExplosionMasks_ST + _ExplosionMasks_ST;
                tmp1 = _Time * float4(0.0, -0.25, 0.0, -0.5) + tmp1;
                tmp2 = tex2D(_ExplosionMasks, tmp1.xy);
                tmp1 = tex2D(_ExplosionMasks, tmp1.zw);
                tmp0.y = tmp1.y * -0.2 + 1.0;
                tmp0.z = tmp2.x * -0.2 + 1.0;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.zw = inp.texcoord2.xz * float2(0.15, 0.15);
                tmp1 = tex2D(_ExplosionMasks, tmp0.zw);
                tmp0.z = 1.0 - tmp1.x;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x + 0.5;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.z = 1.0 - inp.color.x;
                tmp0.y = -tmp0.z * tmp0.y + 1.0;
                tmp0.z = inp.color.x * 0.5 + 0.5;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.z > 0.5;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.y = inp.color.w * _Alpha;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.yzw = inp.texcoord4.zxy / inp.texcoord4.www;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.zw);
                tmp0.y = _ZBufferParams.z * tmp0.y + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.y = tmp0.z - tmp0.y;
                tmp0.y = tmp0.y * 4.0;
                tmp0.y = min(abs(tmp0.y), 1.0);
                tmp0.x = tmp0.x * tmp0.y + -0.5;
                tmp0.x = saturate(tmp0.x * 3.333333);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.y * tmp0.x + -_Cutoff;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 1.0);
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}