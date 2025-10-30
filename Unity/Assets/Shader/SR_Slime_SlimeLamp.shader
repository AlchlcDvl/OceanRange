Shader "SR/Slime/SlimeLamp" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		_GlowTop ("Glow Top", Color) = (1,1,0,1)
		_GlowMid ("Glow Mid", Color) = (0.67,0.67,0,1)
		_GlowBottom ("Glow Bottom", Color) = (0.33,0.33,0,1)
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 65381
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float4 _GlowTop;
			float4 _GlowMid;
			float4 _GlowBottom;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp0.w = dot(-tmp0.xyz, tmp1.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp2.xyz = tmp1.xyz * -tmp0.www + -tmp0.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.y = dot(tmp1.xyz, tmp2.xyz);
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * 128.0;
                tmp0.y = exp(tmp0.y);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.z = inp.texcoord.y * -2.2 + 2.0;
                tmp0.z = tmp0.x * tmp0.x + tmp0.z;
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = tmp0.y + tmp0.z;
                tmp1.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp1.xyz = tmp0.yyy * tmp1.xyz + _MiddleColor.xyz;
                tmp2.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp2.xyz = tmp0.yyy * tmp2.xyz + _BottomColor.xyz;
                tmp0.y = saturate(tmp0.y * 2.0 + -1.0);
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp0.yzw = tmp0.yyy * tmp1.xyz + tmp2.xyz;
                tmp1.xyz = _GlowTop.xyz - _GlowMid.xyz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz + _GlowMid.xyz;
                tmp2.xyz = _GlowMid.xyz - _GlowBottom.xyz;
                tmp2.xyz = tmp0.xxx * tmp2.xyz + _GlowBottom.xyz;
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz + tmp2.xyz;
                tmp1.xyz = tmp0.xxx + tmp1.xyz;
                tmp0.x = min(tmp0.x, 1.0);
                tmp1.xyz = saturate(tmp1.xyz - float3(1.0, 1.0, 1.0));
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp0.x = 1.0 - inp.texcoord.y;
                tmp0.x = tmp0.x * tmp0.x;
                tmp1.xyz = tmp1.xyz * tmp0.xxx;
                o.sv_target.xyz = tmp1.xyz * float3(6.0, 6.0, 6.0) + tmp0.yzw;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}