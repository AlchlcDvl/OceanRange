Shader "SR/RanchTech/VitamizerRay NoDepth" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_Stripes ("Stripes", 2D) = "white" {}
		[MaterialToggle] _StripesInvert ("Stripes Invert", Float) = 0
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+200" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay+200" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			Cull Off
			GpuProgramID 26071
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
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Stripes_ST;
			float _StripesInvert;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Stripes;
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m11_m21_m21_m01;
                tmp0 = unity_ObjectToWorld._m10_m20_m20_m00 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m12_m22_m22_m02 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m13_m23_m23_m03 * v.vertex.wwww + tmp0;
                tmp1.xy = _Time.yy * float2(0.0, 1.0) + tmp0.wx;
                tmp0 = _Time * float4(0.0, 1.0, 0.0, 1.0) + tmp0;
                tmp0 = tmp0 * _Stripes_ST + _Stripes_ST;
                tmp1.xy = tmp1.xy * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp1 = tex2Dlod(_Stripes, float4(tmp1.xy, 0, 0.0));
                tmp2 = tex2Dlod(_Stripes, float4(tmp0.xy, 0, 0.0));
                tmp0 = tex2Dlod(_Stripes, float4(tmp0.zw, 0, 0.0));
                tmp0.yzw = abs(v.normal.xyz) * abs(v.normal.xyz);
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.x = tmp0.y * tmp2.x + tmp0.x;
                tmp0.x = tmp0.w * tmp1.x + tmp0.x;
                tmp0.y = tmp0.x * -2.0 + 1.0;
                tmp0.x = _StripesInvert * tmp0.y + tmp0.x;
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * float3(-0.25, -0.25, -0.25);
                tmp0.w = v.color.x * -0.5 + 1.0;
                tmp0.xyz = tmp0.xyz * tmp0.www + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
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
                o.color = v.color;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = _Time * float4(0.0, 1.0, 0.0, 1.0) + inp.texcoord1.yzzx;
                tmp0 = tmp0 * _Stripes_ST + _Stripes_ST;
                tmp1 = tex2D(_Stripes, tmp0.zw);
                tmp0 = tex2D(_Stripes, tmp0.xy);
                tmp0.y = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * inp.texcoord2.xyz;
                tmp1.y = facing.x ? 1.0 : -1.0;
                tmp0.yzw = tmp0.yzw * tmp1.yyy;
                tmp1.yzw = abs(tmp0.yzw) * abs(tmp0.yzw);
                tmp1.x = tmp1.x * tmp1.z;
                tmp0.x = tmp1.y * tmp0.x + tmp1.x;
                tmp1.xy = _Time.yy * float2(0.0, 1.0) + inp.texcoord1.xy;
                tmp1.xy = tmp1.xy * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp2 = tex2D(_Stripes, tmp1.xy);
                tmp0.x = tmp1.w * tmp2.x + tmp0.x;
                tmp1.x = tmp0.x * -2.0 + 1.0;
                tmp0.x = _StripesInvert * tmp1.x + tmp0.x;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.z = tmp0.y * -2.0 + 1.0;
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.x = saturate(tmp0.x * 0.5 + -0.2);
                tmp0.z = saturate(inp.texcoord.y * -4.0 + 1.0);
                tmp0.x = tmp0.z + tmp0.x;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.w = min(tmp0.z, 1.0);
                tmp0.y = saturate(tmp0.y * tmp0.z + tmp0.w);
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.yzw = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.y = dot(tmp0.xyz, tmp0.xyz);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y * 0.5;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = tmp0.x + 1.0;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.xyz = tmp0.xxx * _Color.xyz;
                o.sv_target.xyz = tmp0.xyz * inp.color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}