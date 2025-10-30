Shader "SR/RanchTech/SpringGrassBug" {
	Properties {
		_AmbientOcclusion ("Ambient Occlusion", 2D) = "white" {}
		_Gloss ("Gloss", Range(0, 1)) = 0
		_Normal ("Normal", 2D) = "bump" {}
		_Ramp ("Ramp", 2D) = "white" {}
		_Alpha ("Alpha", 2D) = "white" {}
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			GpuProgramID 6167
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
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _AmbientOcclusion_ST;
			float _Gloss;
			float4 _Normal_ST;
			float4 _Ramp_ST;
			float4 _Alpha_ST;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AmbientOcclusion;
			sampler2D _Normal;
			sampler2D _Alpha;
			sampler2D _Ramp;
			
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
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
                tmp0.xy = inp.texcoord.xy * _Alpha_ST.xy + _Alpha_ST.zw;
                tmp0 = tex2D(_Alpha, tmp0.xy);
                tmp0.x = tmp0.w - 0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xy = inp.texcoord.xy * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
                tmp1 = tex2D(_AmbientOcclusion, tmp1.xy);
                tmp0.w = tmp1.x * 0.15;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp1.xyz;
                tmp3.x = dot(inp.texcoord3.xyz, tmp2.xyz);
                tmp3.y = dot(inp.texcoord4.xyz, tmp2.xyz);
                tmp3.xy = tmp0.ww * tmp3.xy + inp.texcoord.xy;
                tmp3.zw = tmp3.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp3.xy = tmp3.xy * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
                tmp4 = tex2D(_AmbientOcclusion, tmp3.xy);
                tmp3 = tex2D(_Normal, tmp3.zw);
                tmp3.x = tmp3.w * tmp3.x;
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp5.xyz = tmp3.yyy * inp.texcoord4.xyz;
                tmp5.xyz = tmp3.xxx * inp.texcoord3.xyz + tmp5.xyz;
                tmp0.w = dot(tmp3.xy, tmp3.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp2.w = sqrt(tmp0.w);
                tmp0.w = tmp0.w * tmp2.w;
                tmp0.xyz = tmp2.www * tmp0.xyz + tmp5.xyz;
                tmp2.w = dot(tmp0.xyz, tmp0.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp0.xyz = tmp0.xyz * tmp2.www;
                tmp2.w = dot(-tmp2.xyz, tmp0.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp3.xyz = tmp0.xyz * -tmp2.www + -tmp2.xyz;
                tmp2.x = dot(tmp0.xyz, tmp2.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.x = 1.0 - tmp2.x;
                tmp2.y = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.yzw = tmp2.yyy * _WorldSpaceLightPos0.xyz;
                tmp3.x = dot(tmp2.xyz, tmp3.xyz);
                tmp3.x = max(tmp3.x, 0.0);
                tmp3.x = log(tmp3.x);
                tmp3.y = tmp4.x * _Gloss;
                tmp3.zw = tmp3.yy * float2(10.0, 7.0) + float2(1.0, 1.0);
                tmp3.zw = exp(tmp3.zw);
                tmp3.x = tmp3.x * tmp3.w;
                tmp3.x = exp(tmp3.x);
                tmp3.x = tmp3.x * tmp4.z;
                tmp3.x = saturate(tmp3.x * _LightColor0.x);
                tmp3.w = log(tmp2.x);
                tmp3.w = tmp3.w * 3.333;
                tmp3.w = exp(tmp3.w);
                tmp3.w = tmp3.w * tmp3.w;
                tmp3.w = tmp0.w * tmp3.w;
                tmp3.w = dot(tmp3.xy, tmp4.xy);
                tmp3.w = tmp4.x + tmp3.w;
                tmp3.x = tmp3.x + tmp3.w;
                tmp3.x = tmp3.x * 0.667;
                tmp3.x = max(tmp3.x, 0.05);
                tmp3.x = min(tmp3.x, 0.95);
                tmp3.xw = tmp3.xx * _Ramp_ST.xy + _Ramp_ST.zw;
                tmp4 = tex2D(_Ramp, tmp3.xw);
                tmp5.xyz = tmp4.xyz * _Color.xyz;
                tmp5.xyz = tmp5.xyz * inp.color.xyz;
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp2.yzw;
                tmp1.w = dot(tmp0.xyz, tmp2.xyz);
                tmp2.y = dot(tmp1.xyz, tmp1.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp1.xyz = tmp1.xyz * tmp2.yyy;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * tmp3.z;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp3.yyy * tmp0.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.www * tmp1.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                tmp2.yzw = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz + tmp2.yzw;
                tmp0.xyz = tmp1.xyz * tmp5.xyz + tmp0.xyz;
                tmp1.x = tmp2.x * tmp2.x;
                tmp1.x = tmp1.x * tmp2.x;
                tmp1.xyz = tmp1.xxx * tmp0.www + tmp4.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp1.xyz = tmp2.yzw * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _Color.xyz;
                o.sv_target.xyz = tmp1.xyz * inp.color.xxx + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 104684
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
			float4 _Alpha_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Alpha;
			
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
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.xy = inp.texcoord1.xy * _Alpha_ST.xy + _Alpha_ST.zw;
                tmp0 = tex2D(_Alpha, tmp0.xy);
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