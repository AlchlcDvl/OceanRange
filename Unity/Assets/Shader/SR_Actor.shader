Shader "SR/Actor" {
	Properties {
		_MapsGreySpecDepthAlpha ("Maps (Grey/Spec/Depth/Alpha)", 2D) = "white" {}
		_Override ("Override", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_RampRed ("Ramp Red", 2D) = "white" {}
		_RampGreen ("Ramp Green", 2D) = "white" {}
		_RampBlue ("Ramp Blue", 2D) = "white" {}
		_RampBlack ("Ramp Black", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Cull Off
			GpuProgramID 35183
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _RampRed_ST;
			float4 _RampGreen_ST;
			float4 _RampBlue_ST;
			float4 _RampBlack_ST;
			float4 _Mask_ST;
			float4 _Override_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MapsGreySpecDepthAlpha;
			sampler2D _Mask;
			sampler2D _RampBlack;
			sampler2D _RampRed;
			sampler2D _RampGreen;
			sampler2D _RampBlue;
			sampler2D _Override;
			
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
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.x = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord3.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = dot(-tmp2.xyz, tmp0.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp3.xyz = tmp0.xyz * -tmp1.www + -tmp2.xyz;
                tmp1.w = dot(tmp0.xyz, tmp2.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp2.xxx * _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp2.xyz, tmp3.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = log(tmp2.w);
                tmp3 = tex2D(_MapsGreySpecDepthAlpha, inp.texcoord.xy);
                tmp4.xy = tmp3.yy * float2(10.0, 7.0) + float2(1.0, 1.0);
                tmp4.xy = exp(tmp4.xy);
                tmp2.w = tmp2.w * tmp4.y;
                tmp2.w = exp(tmp2.w);
                tmp2.w = saturate(tmp2.w * tmp3.z);
                tmp3.w = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp3.w;
                tmp3.w = min(tmp3.w, 1.0);
                tmp3.w = tmp3.w * inp.texcoord1.y;
                tmp3.z = dot(tmp3.xy, tmp3.xy);
                tmp3.w = inp.texcoord1.y * 0.75 + 0.25;
                tmp3.x = tmp3.w * tmp3.x + tmp3.z;
                tmp2.w = tmp2.w + tmp3.x;
                tmp2.w = max(tmp2.w, 0.05);
                tmp2.w = min(tmp2.w, 0.95);
                tmp3.xz = tmp2.ww * _RampRed_ST.xy + _RampRed_ST.zw;
                tmp5 = tex2D(_RampRed, tmp3.xz);
                tmp3.xz = tmp2.ww * _RampBlack_ST.xy + _RampBlack_ST.zw;
                tmp6 = tex2D(_RampBlack, tmp3.xz);
                tmp3.xzw = tmp5.xyz - tmp6.xyz;
                tmp4.yz = inp.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp5 = tex2D(_Mask, tmp4.yz);
                tmp3.xzw = tmp5.xxx * tmp3.xzw + tmp6.xyz;
                tmp4.yz = tmp2.ww * _RampGreen_ST.xy + _RampGreen_ST.zw;
                tmp6 = tex2D(_RampGreen, tmp4.yz);
                tmp4.yzw = tmp6.xyz - tmp3.xzw;
                tmp3.xzw = tmp5.yyy * tmp4.yzw + tmp3.xzw;
                tmp4.yz = tmp2.ww * _RampBlue_ST.xy + _RampBlue_ST.zw;
                tmp1.w = tmp1.w * tmp2.w;
                tmp6 = tex2D(_RampBlue, tmp4.yz);
                tmp4.yzw = tmp6.xyz - tmp3.xzw;
                tmp3.xzw = tmp5.zzz * tmp4.yzw + tmp3.xzw;
                tmp4.yz = inp.texcoord.xy * _Override_ST.xy + _Override_ST.zw;
                tmp5 = tex2D(_Override, tmp4.yz);
                tmp4.yzw = tmp5.xyz - tmp3.xzw;
                tmp3.xzw = tmp5.www * tmp4.yzw + tmp3.xzw;
                tmp4.yzw = tmp3.xzw * float3(0.5, 0.5, 0.5);
                tmp3.xzw = tmp3.xzw * float3(0.8, 0.8, 0.8) + tmp1.www;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp2.xyz);
                tmp2.xyz = tmp0.www * float3(0.7132353, 0.907136, 0.951503) + float3(0.2867647, 0.0928641, 0.048497);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * tmp4.x;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp3.yyy * tmp0.xyz;
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = tmp2.xyz * _LightColor0.xyz + tmp1.xyz;
                tmp1.xyz = tmp3.xzw * tmp1.xyz + -tmp4.yzw;
                tmp1.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp4.yzw;
                tmp0.xyz = tmp2.xyz * tmp4.yzw + tmp0.xyz;
                o.sv_target.xyz = tmp1.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			Cull Off
			GpuProgramID 114588
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
			float4 _RampBlue_ST;
			float4 _RampBlack_ST;
			float4 _Mask_ST;
			float4 _Override_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _MapsGreySpecDepthAlpha;
			sampler2D _Mask;
			sampler2D _RampBlack;
			sampler2D _RampRed;
			sampler2D _RampGreen;
			sampler2D _RampBlue;
			sampler2D _Override;
			
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
                o.texcoord3.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                tmp0.x = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord3.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = dot(-tmp2.xyz, tmp0.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp3.xyz = tmp0.xyz * -tmp1.www + -tmp2.xyz;
                tmp1.w = dot(tmp0.xyz, tmp2.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.w = tmp1.w * tmp1.w;
                tmp1.w = min(tmp1.w, 1.0);
                tmp1.w = tmp1.w * inp.texcoord1.y;
                tmp2.xyz = _WorldSpaceLightPos0.www * -inp.texcoord2.xyz + _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.w = dot(tmp2.xyz, tmp3.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = log(tmp2.w);
                tmp3 = tex2D(_MapsGreySpecDepthAlpha, inp.texcoord.xy);
                tmp4.xy = tmp3.yy * float2(10.0, 7.0) + float2(1.0, 1.0);
                tmp4.xy = exp(tmp4.xy);
                tmp2.w = tmp2.w * tmp4.y;
                tmp2.w = exp(tmp2.w);
                tmp2.w = tmp2.w * tmp3.z;
                tmp3.w = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp5 = tex2D(_LightTexture0, tmp3.ww);
                tmp2.w = saturate(tmp2.w * tmp5.x);
                tmp1.w = dot(tmp1.xy, tmp3.xy);
                tmp3.z = inp.texcoord1.y * 0.75 + 0.25;
                tmp1.w = tmp3.z * tmp3.x + tmp1.w;
                tmp1.w = tmp2.w + tmp1.w;
                tmp2.w = tmp5.x * 0.75 + 0.25;
                tmp3.xzw = tmp5.xxx * _LightColor0.xyz;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = max(tmp1.w, 0.05);
                tmp1.w = min(tmp1.w, 0.95);
                tmp4.yz = tmp1.ww * _RampGreen_ST.xy + _RampGreen_ST.zw;
                tmp5 = tex2D(_RampGreen, tmp4.yz);
                tmp4.yz = tmp1.ww * _RampRed_ST.xy + _RampRed_ST.zw;
                tmp6 = tex2D(_RampRed, tmp4.yz);
                tmp4.yz = tmp1.ww * _RampBlack_ST.xy + _RampBlack_ST.zw;
                tmp7.xy = tmp1.ww * _RampBlue_ST.xy + _RampBlue_ST.zw;
                tmp7 = tex2D(_RampBlue, tmp7.xy);
                tmp8 = tex2D(_RampBlack, tmp4.yz);
                tmp4.yzw = tmp6.xyz - tmp8.xyz;
                tmp6.xy = inp.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp6 = tex2D(_Mask, tmp6.xy);
                tmp4.yzw = tmp6.xxx * tmp4.yzw + tmp8.xyz;
                tmp5.xyz = tmp5.xyz - tmp4.yzw;
                tmp4.yzw = tmp6.yyy * tmp5.xyz + tmp4.yzw;
                tmp5.xyz = tmp7.xyz - tmp4.yzw;
                tmp4.yzw = tmp6.zzz * tmp5.xyz + tmp4.yzw;
                tmp5.xy = inp.texcoord.xy * _Override_ST.xy + _Override_ST.zw;
                tmp5 = tex2D(_Override, tmp5.xy);
                tmp5.xyz = tmp5.xyz - tmp4.yzw;
                tmp4.yzw = tmp5.www * tmp5.xyz + tmp4.yzw;
                tmp1.w = dot(tmp0.xyz, tmp2.xyz);
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp2.xyz;
                tmp2.xyz = tmp1.www * float3(0.7132353, 0.907136, 0.951503) + float3(0.2867647, 0.0928641, 0.048497);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = tmp3.xzw * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp4.yzw;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * tmp4.x;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp3.xzw;
                tmp0.xyz = tmp3.yyy * tmp0.xyz;
                o.sv_target.xyz = tmp2.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}