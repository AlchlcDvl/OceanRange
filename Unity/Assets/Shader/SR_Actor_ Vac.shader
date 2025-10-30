Shader "SR/Actor, Vac" {
	Properties {
		_SpiralColor ("Spiral Color", Range(0, 1)) = 0
		_MapsGreySpecDepthAlpha ("Maps (Grey/Spec/Depth/Alpha)", 2D) = "white" {}
		_Normal ("Normal", 2D) = "bump" {}
		_Override ("Override", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_RampRed ("Ramp Red", 2D) = "white" {}
		_RampGreen ("Ramp Green", 2D) = "white" {}
		_RampBlue ("Ramp Blue", 2D) = "white" {}
		_RampBlack ("Ramp Black", 2D) = "white" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Cull Off
			GpuProgramID 36781
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
				float3 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _TimeEditor;
			float4 _RampRed_ST;
			float4 _RampGreen_ST;
			float4 _RampBlack_ST;
			float4 _Mask_ST;
			float4 _Override_ST;
			float4 _MapsGreySpecDepthAlpha_ST;
			float4 _Normal_ST;
			float4 _RampBlue_ST;
			float _SpiralColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _MapsGreySpecDepthAlpha;
			sampler2D _Mask;
			sampler2D _RampBlack;
			sampler2D _RampRed;
			sampler2D _RampGreen;
			sampler2D _Override;
			sampler2D _RampBlue;
			
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord4.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord5.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp, float facing: VFACE)
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
                float4 tmp8;
                tmp0.xy = inp.texcoord.xy * _MapsGreySpecDepthAlpha_ST.xy + _MapsGreySpecDepthAlpha_ST.zw;
                tmp0 = tex2D(_MapsGreySpecDepthAlpha, tmp0.xy);
                tmp0.w = tmp0.w - 0.5;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord3.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp2 = tex2D(_Normal, tmp2.xy);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xyz = tmp2.yyy * inp.texcoord5.xyz;
                tmp3.xyz = tmp2.xxx * inp.texcoord4.xyz + tmp3.xyz;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = sqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz + tmp3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp2.xyz;
                tmp1.w = dot(-tmp3.xyz, tmp1.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp4.xyz = tmp1.xyz * -tmp1.www + -tmp3.xyz;
                tmp1.w = dot(tmp1.xyz, tmp3.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp3.xyz, tmp4.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = log(tmp2.w);
                tmp4.xy = tmp0.yy * float2(10.0, 7.0) + float2(1.0, 1.0);
                tmp4.xy = exp(tmp4.xy);
                tmp2.w = tmp2.w * tmp4.y;
                tmp2.w = exp(tmp2.w);
                tmp2.w = saturate(tmp0.z * tmp2.w);
                tmp3.w = tmp1.w * tmp1.w;
                tmp4.y = min(tmp3.w, 1.0);
                tmp4.y = tmp4.y * inp.texcoord1.y;
                tmp0.z = dot(tmp4.xy, tmp0.xy);
                tmp0.z = tmp0.x * 0.5 + tmp0.z;
                tmp0.z = tmp2.w + tmp0.z;
                tmp0.xz = tmp0.xz * float2(0.5, 0.667);
                tmp0.z = max(tmp0.z, 0.05);
                tmp0.z = min(tmp0.z, 0.95);
                tmp4.yz = tmp0.zz * _RampGreen_ST.xy + _RampGreen_ST.zw;
                tmp5 = tex2D(_RampGreen, tmp4.yz);
                tmp4.yz = tmp0.zz * _RampBlack_ST.xy + _RampBlack_ST.zw;
                tmp6.xy = tmp0.zz * _RampRed_ST.xy + _RampRed_ST.zw;
                tmp6 = tex2D(_RampRed, tmp6.xy);
                tmp7 = tex2D(_RampBlack, tmp4.yz);
                tmp4.yzw = tmp6.xyz - tmp7.xyz;
                tmp8.xy = inp.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp8 = tex2D(_Mask, tmp8.xy);
                tmp4.yzw = tmp8.xxx * tmp4.yzw + tmp7.xyz;
                tmp5.xyz = tmp5.xyz - tmp4.yzw;
                tmp4.yzw = tmp8.yyy * tmp5.xyz + tmp4.yzw;
                tmp5.xyz = tmp6.xyz - tmp4.yzw;
                tmp4.yzw = tmp8.zzz * tmp5.xyz + tmp4.yzw;
                tmp5.xy = inp.texcoord.xy * _Override_ST.xy + _Override_ST.zw;
                tmp5 = tex2D(_Override, tmp5.xy);
                tmp5.xyz = tmp5.xyz - tmp4.yzw;
                tmp4.yzw = tmp5.www * tmp5.xyz + tmp4.yzw;
                tmp0.z = dot(tmp1.xyz, tmp3.xyz);
                tmp2.xyz = tmp2.xyz * tmp0.www + tmp3.xyz;
                tmp3.xyz = tmp0.zzz * float3(0.7132353, 0.907136, 0.951503) + float3(0.2867647, 0.0928641, 0.048497);
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp5.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp3.xyz = tmp3.xyz * _LightColor0.xyz + tmp5.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(tmp2.xyz, tmp1.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = log(tmp0.z);
                tmp0.z = tmp0.z * tmp4.x;
                tmp0.z = exp(tmp0.z);
                tmp1.xyz = tmp0.zzz * _LightColor0.xyz;
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp0.x = saturate(tmp0.x);
                tmp1.x = tmp0.x * _RampBlue_ST.x;
                tmp0.xyz = tmp3.xyz * tmp4.yzw + tmp0.yzw;
                tmp2.xyz = tmp1.www * tmp3.www + tmp4.yzw;
                tmp2.xyz = tmp2.xyz * float3(0.25, 0.25, 0.25);
                tmp1.y = _RampBlue_ST.y * _SpiralColor;
                tmp1.xy = tmp1.xy + _RampBlue_ST.zw;
                tmp1 = tex2D(_RampBlue, tmp1.xy);
                tmp1.xyz = tmp1.xyz * tmp8.zzz;
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp0.w = tmp0.w * 1.5;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 0.15 + 1.05;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp1.xyz = tmp2.xyz * tmp5.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			Cull Off
			GpuProgramID 130745
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
				float3 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
				float3 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _RampRed_ST;
			float4 _RampGreen_ST;
			float4 _RampBlack_ST;
			float4 _Mask_ST;
			float4 _Override_ST;
			float4 _MapsGreySpecDepthAlpha_ST;
			float4 _Normal_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _MapsGreySpecDepthAlpha;
			sampler2D _LightTexture0;
			sampler2D _Mask;
			sampler2D _RampBlack;
			sampler2D _RampRed;
			sampler2D _RampGreen;
			sampler2D _Override;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                o.texcoord2 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord4.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord5.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord6.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp, float facing: VFACE)
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
                float4 tmp8;
                float4 tmp9;
                tmp0.xy = inp.texcoord.xy * _MapsGreySpecDepthAlpha_ST.xy + _MapsGreySpecDepthAlpha_ST.zw;
                tmp0 = tex2D(_MapsGreySpecDepthAlpha, tmp0.xy);
                tmp0.w = tmp0.w - 0.5;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord3.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp2 = tex2D(_Normal, tmp2.xy);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xyz = tmp2.yyy * inp.texcoord5.xyz;
                tmp3.xyz = tmp2.xxx * inp.texcoord4.xyz + tmp3.xyz;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = sqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz + tmp3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp2.xyz;
                tmp1.w = dot(tmp1.xyz, tmp3.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.w = tmp1.w * tmp1.w;
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = tmp1.w * inp.texcoord1.y;
                tmp1.w = dot(tmp1.xy, tmp0.xy);
                tmp0.x = tmp0.x * 0.5 + tmp1.w;
                tmp1.w = dot(-tmp3.xyz, tmp1.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp3.xyz = tmp1.xyz * -tmp1.www + -tmp3.xyz;
                tmp4.xyz = _WorldSpaceLightPos0.www * -inp.texcoord2.xyz + _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp1.www * tmp4.xyz;
                tmp1.w = dot(tmp4.xyz, tmp3.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = log(tmp1.w);
                tmp3.xy = tmp0.yy * float2(10.0, 7.0) + float2(1.0, 1.0);
                tmp3.xy = exp(tmp3.xy);
                tmp1.w = tmp1.w * tmp3.y;
                tmp1.w = exp(tmp1.w);
                tmp0.z = tmp0.z * tmp1.w;
                tmp1.w = dot(inp.texcoord6.xyz, inp.texcoord6.xyz);
                tmp5 = tex2D(_LightTexture0, tmp1.ww);
                tmp0.z = saturate(tmp0.z * tmp5.x);
                tmp0.x = tmp0.z + tmp0.x;
                tmp0.z = tmp5.x * 0.334 + 0.333;
                tmp3.yzw = tmp5.xxx * _LightColor0.xyz;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.x = max(tmp0.x, 0.05);
                tmp0.x = min(tmp0.x, 0.95);
                tmp5.xy = tmp0.xx * _RampGreen_ST.xy + _RampGreen_ST.zw;
                tmp5 = tex2D(_RampGreen, tmp5.xy);
                tmp6.xy = tmp0.xx * _RampBlack_ST.xy + _RampBlack_ST.zw;
                tmp0.xz = tmp0.xx * _RampRed_ST.xy + _RampRed_ST.zw;
                tmp7 = tex2D(_RampRed, tmp0.xz);
                tmp6 = tex2D(_RampBlack, tmp6.xy);
                tmp8.xyz = tmp7.xyz - tmp6.xyz;
                tmp0.xz = inp.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp9 = tex2D(_Mask, tmp0.xz);
                tmp6.xyz = tmp9.xxx * tmp8.xyz + tmp6.xyz;
                tmp5.xyz = tmp5.xyz - tmp6.xyz;
                tmp5.xyz = tmp9.yyy * tmp5.xyz + tmp6.xyz;
                tmp6.xyz = tmp7.xyz - tmp5.xyz;
                tmp5.xyz = tmp9.zzz * tmp6.xyz + tmp5.xyz;
                tmp0.xz = inp.texcoord.xy * _Override_ST.xy + _Override_ST.zw;
                tmp6 = tex2D(_Override, tmp0.xz);
                tmp6.xyz = tmp6.xyz - tmp5.xyz;
                tmp5.xyz = tmp6.www * tmp6.xyz + tmp5.xyz;
                tmp0.xzw = tmp2.xyz * tmp0.www + tmp4.xyz;
                tmp1.w = dot(tmp1.xyz, tmp4.xyz);
                tmp2.xyz = tmp1.www * float3(0.7132353, 0.907136, 0.951503) + float3(0.2867647, 0.0928641, 0.048497);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = tmp3.yzw * tmp2.xyz;
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp0.xzw = tmp0.xzw * tmp1.www;
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * tmp3.x;
                tmp0.x = exp(tmp0.x);
                tmp0.xzw = tmp0.xxx * tmp3.yzw;
                tmp0.xyz = tmp0.yyy * tmp0.xzw;
                o.sv_target.xyz = tmp2.xyz * tmp5.xyz + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 160297
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MapsGreySpecDepthAlpha_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MapsGreySpecDepthAlpha;
			
			// Keywords: SHADOWS_DEPTH
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
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord1.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                tmp0.xy = inp.texcoord1.xy * _MapsGreySpecDepthAlpha_ST.xy + _MapsGreySpecDepthAlpha_ST.zw;
                tmp0 = tex2D(_MapsGreySpecDepthAlpha, tmp0.xy);
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