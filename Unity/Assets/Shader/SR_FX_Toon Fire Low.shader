Shader "SR/FX/Toon Fire Low" {
	Properties {
		_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
		_Blobs ("Blobs", 2D) = "black" {}
		_Speed ("Speed", Float) = 1
		_WaveStrength ("WaveStrength", Float) = 0.1
		_FlowMap ("FlowMap", 2D) = "white" {}
		_BillboardOffset ("Billboard Offset", Float) = -2
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			Offset -1, -2
			GpuProgramID 16740
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
			float4 _TimeEditor;
			float _Speed;
			float _WaveStrength;
			float4 _FlowMap_ST;
			float _BillboardOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TintColor;
			float4 _Blobs_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _FlowMap;
			// Texture params for Fragment Shader
			sampler2D _Blobs;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m21_m11;
                tmp0.xyz = unity_ObjectToWorld._m00_m20_m10 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m22_m12 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m23_m13 * v.vertex.www + tmp0.xyz;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = tmp0.z + tmp0.x;
                tmp0.y = _TimeEditor.y + _Time.y;
                tmp0.y = _Speed * -0.5 + tmp0.y;
                tmp0.y = tmp0.y + v.texcoord.y;
                tmp0.y = tmp0.x * 0.02 + tmp0.y;
                tmp0.x = 0.5;
                tmp0.xy = tmp0.xy * _FlowMap_ST.xy + _FlowMap_ST.zw;
                tmp0 = tex2Dlod(_FlowMap, float4(tmp0.xy, 0, 0.0));
                tmp0.xy = tmp0.xx * float2(0.25, 0.5);
                tmp0.z = _WaveStrength * 50.0;
                tmp0.xz = tmp0.zz * tmp0.xy;
                tmp0.y = 0.0;
                tmp0.w = v.texcoord.y * v.texcoord.y;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = abs(v.normal.yyy) * -tmp0.xyz + tmp0.xyz;
                tmp1.xyz = float3(0.0, 0.5, 0.0) - tmp0.xyz;
                tmp0.xyz = abs(v.normal.yyy) * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp2.xyz = tmp1.xyz - _WorldSpaceCameraPos;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.xyz = -_BillboardOffset.xxx * tmp2.xyz + tmp0.xyz;
                tmp0.xyz = tmp1.xyz + tmp0.xyz;
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
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.xy = _TimeEditor.wy + _Time.wy;
                tmp0.x = tmp0.x * _Speed;
                tmp1.y = _Speed * -0.5 + tmp0.y;
                tmp2 = tmp0.xxxx * float4(-0.125, -0.5, -0.5, 0.25) + inp.texcoord1.xyyz;
                tmp0 = tmp0.xxxx * float4(-0.25, -1.0, -1.0, 0.5) + inp.texcoord1.xyyz;
                tmp2 = tmp2 * float4(0.25, 0.25, 0.25, 0.25);
                tmp1.zw = tmp2.wx * _Blobs_ST.xy + _Blobs_ST.zw;
                tmp2 = tmp2 * _Blobs_ST + _Blobs_ST;
                tmp3 = tex2D(_Blobs, tmp1.zw);
                tmp4 = tex2D(_Blobs, tmp2.zw);
                tmp2 = tex2D(_Blobs, tmp2.xy);
                tmp1.z = tmp4.x - tmp2.x;
                tmp1.z = abs(inp.texcoord2.x) * tmp1.z + tmp2.x;
                tmp1.w = tmp3.x - tmp1.z;
                tmp1.z = abs(inp.texcoord2.y) * tmp1.w + tmp1.z;
                tmp1.w = tmp2.x - tmp1.z;
                tmp1.z = abs(inp.texcoord2.z) * tmp1.w + tmp1.z;
                tmp2.xy = tmp0.wx * _Blobs_ST.xy + _Blobs_ST.zw;
                tmp0 = tmp0 * _Blobs_ST + _Blobs_ST;
                tmp2 = tex2D(_Blobs, tmp2.xy);
                tmp3 = tex2D(_Blobs, tmp0.zw);
                tmp0 = tex2D(_Blobs, tmp0.xy);
                tmp0.y = tmp3.x - tmp0.x;
                tmp0.y = abs(inp.texcoord2.x) * tmp0.y + tmp0.x;
                tmp0.z = tmp2.x - tmp0.y;
                tmp0.y = abs(inp.texcoord2.y) * tmp0.z + tmp0.y;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = abs(inp.texcoord2.z) * tmp0.x + tmp0.y;
                tmp0.x = tmp0.x + tmp1.z;
                tmp0.x = saturate(tmp0.x * 0.667 + 0.333);
                tmp0.y = tmp0.x * -2.0 + 1.0;
                tmp0.z = log(inp.texcoord.y);
                tmp0.z = tmp0.z * 0.25;
                tmp0.z = exp(tmp0.z);
                tmp0.x = tmp0.z * tmp0.y + tmp0.x;
                tmp0.y = 1.0 - tmp0.x;
                tmp1.x = 0.0;
                tmp0.zw = tmp1.xy + inp.texcoord.xy;
                tmp1.x = inp.texcoord1.z + inp.texcoord1.x;
                tmp1.x = tmp1.x + inp.texcoord1.y;
                tmp0.zw = tmp1.xx * float2(0.0, 0.02) + tmp0.zw;
                tmp0.zw = tmp0.zw * _FlowMap_ST.xy + _FlowMap_ST.zw;
                tmp1 = tex2D(_FlowMap, tmp0.zw);
                tmp0.z = tmp1.x - inp.texcoord.x;
                tmp1.x = _WaveStrength * tmp0.z + inp.texcoord.x;
                tmp1.y = inp.texcoord.y;
                tmp0.zw = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.x = 1.0 - abs(tmp0.z);
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.z = sqrt(tmp0.z);
                tmp0.z = 1.0 - tmp0.z;
                tmp0.w = 1.0 - inp.texcoord.y;
                tmp0.w = tmp1.x * tmp0.w;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 0.75;
                tmp0.w = exp(tmp0.w);
                tmp1.x = tmp0.z - tmp0.w;
                tmp0.w = abs(inp.texcoord2.y) * tmp1.x + tmp0.w;
                tmp0.z = saturate(tmp0.z + tmp0.z);
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.z = saturate(tmp0.z * 1.333333);
                tmp1.x = tmp0.z - 0.5;
                tmp1.x = -tmp1.x * 2.0 + 1.0;
                tmp0.y = -tmp1.x * tmp0.y + 1.0;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.z > 0.5;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.y = tmp0.w * tmp0.x;
                tmp0.x = saturate(tmp0.x * 25.00001 + -12.0);
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.x = tmp0.y * 4.333333 + tmp0.x;
                tmp0.x = tmp0.x - 1.0;
                tmp0 = tmp0.xxxx * inp.color;
                tmp0 = tmp0 * _TintColor;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.w = tmp0.w * 0.5;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}