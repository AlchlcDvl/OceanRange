Shader "SR/RanchTech/SolarShield" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_Stripes ("Stripes", 2D) = "white" {}
		[MaterialToggle] _StripesInvert ("Stripes Invert", Float) = 0.05530696
		_node_6874 ("node_6874", 2D) = "white" {}
		_node_7631 ("node_7631", 2D) = "white" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay+200" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay+200" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend DstColor Zero, DstColor Zero
			ZWrite Off
			Cull Off
			GpuProgramID 41556
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
			float4 _TimeEditor;
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
                tmp1.x = _TimeEditor.y + _Time.y;
                tmp2 = tmp1.xxxx * float4(0.0, 1.0, 0.0, 1.0) + tmp0;
                tmp0.xy = tmp1.xx * float2(0.0, 1.0) + tmp0.wx;
                tmp0.xy = tmp0.xy * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp0 = tex2Dlod(_Stripes, float4(tmp0.xy, 0, 0.0));
                tmp1 = tmp2 * _Stripes_ST + _Stripes_ST;
                tmp2 = tex2Dlod(_Stripes, float4(tmp1.xy, 0, 0.0));
                tmp1 = tex2Dlod(_Stripes, float4(tmp1.zw, 0, 0.0));
                tmp0.yzw = abs(v.normal.xyz) * abs(v.normal.xyz);
                tmp0.z = tmp1.x * tmp0.z;
                tmp0.y = tmp0.y * tmp2.x + tmp0.z;
                tmp0.x = tmp0.w * tmp0.x + tmp0.y;
                tmp0.y = tmp0.x * -2.0 + 1.0;
                tmp0.x = _StripesInvert * tmp0.y + tmp0.x;
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * float3(-0.25, -0.25, -0.25) + v.vertex.xyz;
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
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = abs(tmp0.xyz) * abs(tmp0.xyz);
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp2 = tmp0.wwww * float4(0.0, 1.0, 0.0, 1.0) + inp.texcoord1.yzzx;
                tmp3.xy = tmp0.ww * float2(0.0, 1.0) + inp.texcoord1.xy;
                tmp3.xy = tmp3.xy * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp3 = tex2D(_Stripes, tmp3.xy);
                tmp2 = tmp2 * _Stripes_ST + _Stripes_ST;
                tmp4 = tex2D(_Stripes, tmp2.zw);
                tmp2 = tex2D(_Stripes, tmp2.xy);
                tmp0.w = tmp1.y * tmp4.x;
                tmp0.w = tmp1.x * tmp2.x + tmp0.w;
                tmp0.w = tmp1.z * tmp3.x + tmp0.w;
                tmp1.x = tmp0.w * -2.0 + 1.0;
                tmp0.w = _StripesInvert * tmp1.x + tmp0.w;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = tmp0.x * -2.0 + 1.0;
                tmp0.y = tmp0.y * tmp0.w;
                tmp0.y = saturate(tmp0.y * 0.5 + -0.2);
                tmp0.z = saturate(inp.texcoord.y * -4.0 + 1.0);
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.w = min(tmp0.z, 1.0);
                tmp0.x = saturate(tmp0.x * tmp0.z + tmp0.w);
                tmp0.x = tmp0.x + tmp0.y;
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
                tmp0.yzw = float3(1.0, 1.0, 1.0) - _Color.xyz;
                o.sv_target.xyz = saturate(-tmp0.yzw * tmp0.xxx + float3(1.0, 1.0, 1.0));
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Overlay+200" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 72374
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			float4 _Stripes_ST;
			float _StripesInvert;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Stripes;
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
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
                tmp1.x = _TimeEditor.y + _Time.y;
                tmp2 = tmp1.xxxx * float4(0.0, 1.0, 0.0, 1.0) + tmp0;
                tmp0.xy = tmp1.xx * float2(0.0, 1.0) + tmp0.wx;
                tmp0.xy = tmp0.xy * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp0 = tex2Dlod(_Stripes, float4(tmp0.xy, 0, 0.0));
                tmp1 = tmp2 * _Stripes_ST + _Stripes_ST;
                tmp2 = tex2Dlod(_Stripes, float4(tmp1.xy, 0, 0.0));
                tmp1 = tex2Dlod(_Stripes, float4(tmp1.zw, 0, 0.0));
                tmp0.yzw = abs(v.normal.xyz) * abs(v.normal.xyz);
                tmp0.z = tmp1.x * tmp0.z;
                tmp0.y = tmp0.y * tmp2.x + tmp0.z;
                tmp0.x = tmp0.w * tmp0.x + tmp0.y;
                tmp0.y = tmp0.x * -2.0 + 1.0;
                tmp0.x = _StripesInvert * tmp0.y + tmp0.x;
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * float3(-0.25, -0.25, -0.25) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}