Shader "SR/UI/Map, Clouds" {
	Properties {
		[HideInInspector] _MainTex ("MainTex", 2D) = "white" {}
		_CloudColor ("Cloud Color", Color) = (0.9176471,0.9725491,1,0.5)
		_CloudShadowColor ("Cloud Shadow Color", Color) = (0.1803922,0.5882353,0.7882354,0.272)
		_Clouds ("Clouds", 2D) = "white" {}
		_CloudDistance ("Cloud Distance", Range(0, 2)) = 1
		_WaterLines ("WaterLines", 2D) = "black" {}
		_UnscaledTime ("Unscaled Time", Float) = 0
		_CloudSpeed ("CloudSpeed", Float) = 0.5
		_StencilComp ("StencilComp", Float) = 8
		_Stencil ("Stencil", Float) = 0
		_StencilOp ("StencilOp", Float) = 0
		_StencilWriteMask ("StencilWriteMask", Float) = 255
		_StencilReadMask ("StencilReadMask", Float) = 255
		_ColorMask ("ColorMask", Float) = 15
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			Stencil {
				Ref 1
				Comp LEqual
				Pass Keep
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 39534
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _CloudColor;
			float4 _CloudShadowColor;
			float4 _Clouds_ST;
			float _CloudDistance;
			float4 _WaterLines_ST;
			float _UnscaledTime;
			float _CloudSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Clouds;
			sampler2D _WaterLines;
			
			// Keywords: DIRECTIONAL
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
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.y = tmp0.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp0.x + tmp0.y;
                tmp0.x = unity_MatrixV._m22 * tmp0.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp0.w + tmp0.x;
                o.texcoord1.z = -tmp0.x;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord1.w = tmp1.w;
                o.texcoord1.xy = tmp0.zz + tmp0.xw;
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
                tmp0.x = _CloudDistance * -0.05;
                tmp0.y = _ScreenParams.x / _ScreenParams.y;
                tmp1 = inp.texcoord1.xyxy / inp.texcoord1.wwww;
                tmp1 = tmp1 * float4(2.0, 2.0, 2.0, 2.0) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp1.x = tmp0.y * tmp1.x;
                tmp0.y = dot(tmp1.xy, tmp1.xy);
                tmp0.xz = tmp1.xy * tmp0.xx + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * float2(-0.0125, -0.0125) + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _WaterLines_ST.xy + _WaterLines_ST.zw;
                tmp1 = tex2D(_WaterLines, tmp1.xy);
                tmp0.w = _UnscaledTime + _Time.y;
                tmp0.w = tmp0.w * _CloudSpeed;
                tmp0.xz = tmp0.ww * float2(0.01, 0.001) + tmp0.xz;
                tmp2.xy = tmp0.ww * float2(0.01, 0.001) + inp.texcoord.xy;
                tmp2.xy = tmp2.xy * _Clouds_ST.xy + _Clouds_ST.zw;
                tmp2 = tex2D(_Clouds, tmp2.xy);
                tmp0.w = tmp2.y * tmp2.x;
                tmp0.xz = tmp0.xz * _Clouds_ST.xy + _Clouds_ST.zw;
                tmp2 = tex2D(_Clouds, tmp0.xz);
                tmp0.x = tmp2.y * tmp2.x;
                tmp0.z = sqrt(tmp0.y);
                tmp2.x = tmp0.z * 0.5 + 0.5;
                tmp2.x = min(tmp2.x, 1.0);
                tmp0.x = tmp0.x * tmp2.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp0.w = saturate(tmp0.w * 7.5 + -3.0);
                tmp2.x = tmp0.x * 1.666667;
                tmp0.x = saturate(tmp0.x * 20.00001 + -8.000003);
                tmp2.x = saturate(tmp2.x);
                tmp2.yzw = _CloudColor.xyz - _CloudShadowColor.xyz;
                tmp2.xyz = tmp2.xxx * tmp2.yzw + _CloudShadowColor.xyz;
                tmp2.w = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * _CloudColor.w;
                tmp0.x = tmp0.x * tmp0.y;
                tmp3.xyz = _CloudShadowColor.xyz - float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp2.www * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp0.y = tmp0.w * tmp2.w;
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp0.w = tmp0.z * tmp0.x;
                tmp2.xyz = tmp0.www * tmp2.xyz + tmp3.xyz;
                tmp0.y = tmp0.y * _CloudShadowColor.w + tmp0.w;
                o.sv_target.w = tmp1.w + tmp0.y;
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp0.y = -tmp0.x * tmp0.z + 1.0;
                tmp0.x = saturate(tmp0.x * tmp0.z + tmp1.w);
                tmp0.y = tmp0.y * tmp1.w;
                tmp0.yzw = tmp0.yyy * tmp1.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp0.yzw * tmp0.xxx;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}