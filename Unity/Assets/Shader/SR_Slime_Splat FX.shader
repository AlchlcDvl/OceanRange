Shader "SR/Slime/Splat FX" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		_Decal ("Decal", 2D) = "white" {}
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_Color ("Color", Color) = (0.5,0.5,0.5,0.5)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "AlphaTest" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Offset -1, -1
			GpuProgramID 55225
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
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float _Gloss;
			float _GlossPower;
			float4 _Decal_ST;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Decal;
			
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
                tmp0.xy = inp.texcoord.xy * _Decal_ST.xy + _Decal_ST.zw;
                tmp1 = tex2D(_Decal, tmp0.xy);
                tmp0 = tex2Dlod(_Decal, float4(tmp0.xy, 0, 0.0));
                tmp0.y = inp.color.w * _Color.w;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = min(tmp0.y, 0.999);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.z = tmp1.x >= tmp0.y;
                if (!(tmp0.z)) {
                    discard;
                }
                tmp0.x = max(tmp0.y, tmp0.x);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.z = 1.0 - tmp0.y;
                tmp1 = inp.texcoord.xyxy + float4(0.0, 0.02, 0.02, 0.0);
                tmp1 = tmp1 * _Decal_ST + _Decal_ST;
                tmp2 = tex2Dlod(_Decal, float4(tmp1.xy, 0, 0.0));
                tmp1 = tex2Dlod(_Decal, float4(tmp1.zw, 0, 0.0));
                tmp0.w = max(tmp0.y, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w - tmp0.y;
                tmp1.x = max(tmp0.y, tmp2.x);
                tmp1.x = min(tmp1.x, 1.0);
                tmp0.y = tmp1.x - tmp0.y;
                tmp0.xyw = tmp0.xyw / tmp0.zzz;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.y = tmp0.y - tmp0.w;
                tmp1.xyz = tmp0.yyx * float3(-2.0, 0.5, -2.0);
                tmp0.y = saturate(tmp0.x * 2.0 + tmp1.y);
                tmp0.x = tmp0.y + 0.5;
                tmp0.yzw = tmp1.zzz * inp.texcoord4.xyz;
                tmp1.y = dot(tmp1.xy, tmp1.xy);
                tmp0.yzw = tmp1.xxx * inp.texcoord3.xyz + tmp0.yzw;
                tmp1.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xzw = tmp1.xxx * inp.texcoord2.xyz;
                tmp0.yzw = tmp1.yyy * tmp1.xzw + tmp0.yzw;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.x = saturate(tmp0.z * 0.75 + 0.25);
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp2.x = dot(tmp1.xyz, tmp1.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.yzw = tmp1.yzw * tmp2.xxx;
                tmp2.y = dot(tmp0.xyz, tmp2.xyz);
                tmp2.y = max(tmp2.y, 0.0);
                tmp2.y = 1.0 - tmp2.y;
                tmp2.y = tmp2.y * tmp2.y;
                tmp2.y = min(tmp2.y, 1.0);
                tmp1.x = tmp1.x + tmp2.y;
                tmp2.y = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.yzw = tmp2.yyy * _WorldSpaceLightPos0.xyz;
                tmp3.x = dot(tmp0.xyz, tmp2.xyz);
                tmp1.yzw = tmp1.yzw * tmp2.xxx + tmp2.yzw;
                tmp2.x = max(tmp3.x, 0.0);
                tmp2.y = log(tmp2.x);
                tmp2.z = _GlossPower * 16.0 + -1.0;
                tmp2.z = exp(tmp2.z);
                tmp2.y = tmp2.y * tmp2.z;
                tmp2.y = exp(tmp2.y);
                tmp1.x = _Gloss * tmp2.y + tmp1.x;
                tmp2.y = tmp2.y * _Gloss;
                tmp2.yzw = tmp2.yyy * _LightColor0.xyz;
                tmp0.x = saturate(tmp0.x * tmp1.x);
                tmp3.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + _MiddleColor.xyz;
                tmp4.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp4.xyz = tmp0.xxx * tmp4.xyz + _BottomColor.xyz;
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.xyz * inp.color.xyz;
                tmp4.xyz = tmp3.xyz * float3(0.2, 0.2, 0.2);
                tmp3.xyz = tmp3.xyz * float3(0.8, 0.8, 0.8);
                tmp2.yzw = tmp2.yzw * _Gloss.xxx + tmp3.xyz;
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp3.xyz = tmp2.xxx * _LightColor0.xyz + tmp3.xyz;
                tmp0.x = dot(tmp1.xyz, tmp1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp1.xyz = tmp0.xxx * tmp1.yzw;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 32.0;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.1, 0.1, 0.1);
                tmp0.xyz = tmp3.xyz * tmp4.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp2.yzw + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Offset -1, -1
			GpuProgramID 122984
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Decal_ST;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Decal;
			
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
                o.color = v.color;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.color.w * _Color.w;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = min(tmp0.x, 0.999);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.yz = inp.texcoord1.xy * _Decal_ST.xy + _Decal_ST.zw;
                tmp1 = tex2D(_Decal, tmp0.yz);
                tmp0.x = tmp1.x >= tmp0.x;
                if (!(tmp0.x)) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}