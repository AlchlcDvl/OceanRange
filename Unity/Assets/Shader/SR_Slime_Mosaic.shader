Shader "SR/Slime/Mosaic" {
	Properties {
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		_Depth ("Depth", 2D) = "gray" {}
		_SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_Gloss ("Gloss", Range(0, 1)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_Normal ("Normal", 2D) = "bump" {}
		_ColorRamp ("Color-Ramp", 2D) = "gray" {}
		_Roughness ("Roughness", 2D) = "white" {}
		_VertexOffset ("Vertex Offset", Float) = 0
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 31571
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _VertexOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _TimeEditor;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float _Gloss;
			float _GlossPower;
			float4 _SpecularColor;
			float4 _ColorRamp_ST;
			float4 _Normal_ST;
			float4 _Roughness_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _Roughness;
			sampler2D _Depth;
			sampler2D _PrimaryTex;
			sampler2D _ColorRamp;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = v.normal.xyz * _VertexOffset.xxx + v.vertex.xyz;
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
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.xyz = tmp1.yyy * inp.texcoord4.xyz;
                tmp2.xyz = tmp1.xxx * inp.texcoord3.xyz + tmp2.xyz;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = sqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz + tmp2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = -tmp0.y * tmp0.w + 1.0;
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp0.yzw * tmp1.www;
                tmp2.w = dot(-tmp2.xyz, tmp1.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp3.xyz = tmp1.xyz * -tmp2.www + -tmp2.xyz;
                tmp2.x = dot(tmp1.xyz, tmp2.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.x = 1.0 - tmp2.x;
                tmp2.y = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.y = rsqrt(tmp2.y);
                tmp2.yzw = tmp2.yyy * _WorldSpaceLightPos0.xyz;
                tmp3.x = dot(tmp2.xyz, tmp3.xyz);
                tmp3.x = max(tmp3.x, 0.0);
                tmp3.x = log(tmp3.x);
                tmp3.y = _GlossPower * 16.0 + -1.0;
                tmp3.y = exp(tmp3.y);
                tmp3.x = tmp3.x * tmp3.y;
                tmp3.x = exp(tmp3.x);
                tmp3.z = log(tmp2.x);
                tmp4.xy = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp4 = tex2D(_Depth, tmp4.xy);
                tmp3.w = tmp3.z * tmp4.x;
                tmp4.yz = tmp3.zz * float2(1.25, 0.25);
                tmp4.yz = exp(tmp4.yz);
                tmp3.z = exp(tmp3.w);
                tmp3.w = 1.0 - tmp3.z;
                tmp3.z = tmp3.z * 1.333333;
                tmp3.w = log(tmp3.w);
                tmp3.y = tmp3.w * tmp3.y;
                tmp3.y = exp(tmp3.y);
                tmp3.x = tmp3.y + tmp3.x;
                tmp3.yw = inp.texcoord.xy * _Roughness_ST.xy + _Roughness_ST.zw;
                tmp5 = tex2D(_Roughness, tmp3.yw);
                tmp3.y = tmp5.x * _Gloss;
                tmp3.w = max(tmp5.x, 0.0);
                tmp3.zw = min(tmp3.zw, float2(1.0, 0.5));
                tmp3.w = 1.0 - tmp3.w;
                tmp3.w = tmp3.w * 10.0 + 1.0;
                tmp3.w = exp(tmp3.w);
                tmp3.x = tmp3.x * tmp3.y;
                tmp5.xyz = tmp3.xxx * _LightColor0.xyz;
                tmp5.xyz = tmp5.xyz * _Gloss.xxx;
                tmp5.xyz = tmp5.xyz * float3(148.368, 148.368, 148.368) + float3(-0.9792286, -0.9792286, -0.9792286);
                tmp3.x = tmp2.x * tmp2.x;
                tmp3.y = tmp4.x * tmp4.x;
                tmp5.xyz = saturate(tmp3.yyy * tmp5.xyz + tmp3.xxx);
                o.sv_target.w = tmp3.x;
                tmp5.xyz = saturate(tmp5.xyz * _SpecularColor.xyz);
                tmp3.x = saturate(tmp0.x);
                tmp3.y = tmp4.z * -2.0 + 2.0;
                tmp3.y = max(tmp3.y, 0.25);
                tmp3.y = min(tmp3.y, 1.0);
                tmp4.zw = inp.texcoord.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp6 = tex2D(_PrimaryTex, tmp4.zw);
                tmp4.z = dot(tmp6.xy, float2(0.3, 0.667));
                tmp4.y = tmp4.x * tmp4.y + tmp4.z;
                tmp4.x = saturate(tmp4.x);
                tmp7.x = tmp4.y * _ColorRamp_ST.x;
                tmp7.yw = float2(0.0, 0.0);
                tmp4.yw = tmp7.xy + _ColorRamp_ST.zw;
                tmp8 = tex2D(_ColorRamp, tmp4.yw);
                tmp8.xyz = saturate(tmp8.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0));
                tmp9.xyz = tmp8.xyz * float3(2.0, 2.0, 2.0) + tmp3.yyy;
                tmp9.xyz = tmp9.xyz - float3(1.0, 1.0, 1.0);
                tmp10.xyz = tmp8.xyz - float3(0.5, 0.5, 0.5);
                tmp8.xyz = tmp8.xyz > float3(0.5, 0.5, 0.5);
                tmp10.xyz = tmp10.xyz * float3(2.0, 2.0, 2.0) + tmp3.yyy;
                tmp8.xyz = saturate(tmp8.xyz ? tmp9.xyz : tmp10.xyz);
                tmp8.xyz = tmp3.yyy * tmp8.xyz;
                tmp8.xyz = tmp8.xyz * tmp3.xxx + _SpecularColor.xyz;
                tmp8.xyz = tmp5.xyz + tmp8.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp3.x = tmp6.y + tmp6.x;
                tmp3.x = tmp6.z + tmp3.x;
                tmp4.y = 1.0 - tmp3.x;
                tmp4.w = tmp2.x * tmp4.y;
                tmp0.x = saturate(tmp3.y * tmp0.x + tmp4.w);
                tmp6.xyz = tmp0.xxx * tmp8.xyz;
                tmp0.x = tmp2.x * 3.0;
                tmp6.xyz = tmp0.xxx * tmp6.xyz;
                tmp0.xyz = tmp0.yzw * tmp1.www + tmp2.yzw;
                tmp0.w = dot(tmp1.xyz, tmp2.xyz);
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp0.xyz = tmp0.xyz * tmp1.www;
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.xw = max(tmp0.xw, float2(0.0, 0.0));
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * tmp3.w;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp0.xyz * float3(3.0, 3.0, 3.0);
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.www * _LightColor0.xyz + tmp1.xyz;
                tmp0.xyz = tmp1.xyz * tmp6.xyz + tmp0.xyz;
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp0.w = tmp0.w * 0.5 + tmp4.z;
                tmp7.z = tmp4.x * tmp3.z + tmp0.w;
                tmp1.xy = tmp7.zw * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp1 = tex2D(_ColorRamp, tmp1.xy);
                tmp0.w = dot(tmp1.xyz, float3(0.3, 0.59, 0.11));
                tmp2.yzw = tmp0.www - tmp1.xyz;
                tmp1.xyz = tmp4.yyy * tmp2.yzw + tmp1.xyz;
                tmp1.xyz = tmp3.xxx * tmp1.xyz;
                tmp1.xyz = -tmp1.xyz * tmp2.xxx + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(-tmp1.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0));
                o.sv_target.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}