Shader "SR/UI/Map" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("MainTex", 2D) = "white" {}
		_Clouds ("Clouds", 2D) = "white" {}
		_CloudDistance ("Cloud Distance", Range(0, 2)) = 1
		_Sparkles ("Sparkles", 2D) = "black" {}
		_UnscaledTime ("Unscaled Time", Float) = 0
		_WaterSpeed ("WaterSpeed", Float) = 0.25
		_StencilComp ("StencilComp", Float) = 8
		_Stencil ("Stencil", Float) = 0
		_StencilOp ("StencilOp", Float) = 0
		_StencilWriteMask ("StencilWriteMask", Float) = 255
		_StencilReadMask ("StencilReadMask", Float) = 255
		_ColorMask ("ColorMask", Float) = 15
	}
	SubShader {
		Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Stencil {
				Ref 1
				Comp LEqual
				Pass Keep
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 7336
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
			float4 _Color;
			float4 _MainTex_ST;
			float4 _Clouds_ST;
			float _CloudDistance;
			float4 _Sparkles_ST;
			float _UnscaledTime;
			float _WaterSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Clouds;
			sampler2D _Sparkles;
			
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
                tmp0.x = _CloudDistance * 0.05;
                tmp0.y = _ScreenParams.x / _ScreenParams.y;
                tmp1 = inp.texcoord1.xyxy / inp.texcoord1.wwww;
                tmp1 = tmp1 * float4(2.0, 2.0, 2.0, 2.0) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp1.x = tmp0.y * tmp1.x;
                tmp0.y = dot(tmp1.xy, tmp1.xy);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.xz = tmp1.xy * tmp0.xx + inp.texcoord.xy;
                tmp0.w = _UnscaledTime + _Time.y;
                tmp0.w = tmp0.w * _WaterSpeed;
                tmp0.xz = tmp0.ww * float2(0.1, 0.01) + tmp0.xz;
                tmp1.xy = tmp0.ww * float2(0.1, 0.01) + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * _Clouds_ST.xy + _Clouds_ST.zw;
                tmp1 = tex2D(_Clouds, tmp1.xy);
                tmp0.w = tmp1.y * tmp1.x;
                tmp0.w = tmp0.w * tmp0.y;
                tmp0.w = saturate(tmp0.w * 21.0 + -8.000001);
                tmp0.xz = tmp0.xz * _Clouds_ST.xy + _Clouds_ST.zw;
                tmp1 = tex2D(_Clouds, tmp0.xz);
                tmp0.x = tmp1.y * tmp1.x;
                tmp0.x = saturate(dot(tmp0.xy, tmp0.xy));
                tmp0.xyz = tmp0.www * float3(0.0, 1.0, 0.503448) + tmp0.xxx;
                tmp1.xy = inp.texcoord.xy * _Sparkles_ST.xy + _Sparkles_ST.zw;
                tmp1 = tex2D(_Sparkles, tmp1.xy);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp1.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp0.w = 1.0 - tmp1.w;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.xyz * _Color.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}