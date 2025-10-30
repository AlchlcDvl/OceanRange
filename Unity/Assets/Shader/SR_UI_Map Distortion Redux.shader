Shader "SR/UI/Map Distortion Redux" {
	Properties {
		[HideInInspector] _MainTex ("MainTex", 2D) = "white" {}
		_Fade ("Fade", Range(0, 1)) = 1
		_UnscaledTime ("Unscaled Time", Float) = 0
		_AvgCycleLength ("AvgCycleLength", Range(1, 10)) = 3
		_CycleGlitchRatio ("CycleGlitchRatio", Range(0, 1)) = 0.5
		_StencilComp ("StencilComp", Float) = 8
		_Stencil ("Stencil", Float) = 0
		_StencilOp ("StencilOp", Float) = 0
		_StencilWriteMask ("StencilWriteMask", Float) = 255
		_StencilReadMask ("StencilReadMask", Float) = 255
		_ColorMask ("ColorMask", Float) = 15
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Stencil {
				Ref 1
				Comp LEqual
				Pass Keep
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 42787
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 color : COLOR0;
				float4 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _AvgCycleLength;
			float _CycleGlitchRatio;
			float _Fade;
			float _UnscaledTime;
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp1;
                o.color = v.color;
                tmp0.y = tmp0.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp0.x + tmp0.y;
                tmp0.x = unity_MatrixV._m22 * tmp0.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp0.w + tmp0.x;
                o.texcoord.z = -tmp0.x;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord.w = tmp1.w;
                o.texcoord.xy = tmp0.zz + tmp0.xw;
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
                tmp0.x = _UnscaledTime + _Time.y;
                tmp0.y = tmp0.x * 0.2;
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.y * 48.0;
                tmp0.y = round(tmp0.y);
                tmp1.xyz = inp.texcoord.xxy / inp.texcoord.www;
                tmp0.zw = tmp1.zy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.x = tmp1.z + tmp1.x;
                tmp1.xy = tmp1.xx * float2(16.0, 32.0);
                tmp1.xy = frac(tmp1.xy);
                tmp1.xy = tmp1.yx * float2(1000.013, 1000.013) + float2(-800.0103, -499.0064);
                tmp2 = tmp0.wzwz + tmp0.yyyy;
                tmp2 = tmp2 * float4(48.0, 48.0, 8.0, 8.0);
                tmp2 = floor(tmp2);
                tmp1.zw = tmp2.yw * float2(0.0212766, 0.1428571);
                tmp3 = tmp1.zzww * tmp2.xxzz;
                tmp2 = tmp2 * float4(0.0212766, 0.0212766, 0.1428571, 0.1428571) + float4(0.2127, 0.2127, 0.2127, 0.2127);
                tmp2 = tmp3 * float4(0.0079, 0.0079, 0.0530429, 0.0530429) + tmp2;
                tmp3 = tmp2 * float4(489.123, 489.123, 489.123, 489.123);
                tmp1.zw = tmp2.xz + float2(1.0, 1.0);
                tmp2 = sin(tmp3);
                tmp2 = tmp2 * float4(4.789, 4.789, 4.789, 4.789);
                tmp2.xy = tmp2.yw * tmp2.xz;
                tmp1.zw = tmp1.zw * tmp2.xy;
                tmp1.zw = frac(tmp1.zw);
                tmp0.y = max(tmp1.w, tmp1.z);
                tmp1.zw = tmp1.zz * float2(0.6, 0.6) + float2(0.2, -0.3);
                tmp0.y = tmp0.y * tmp0.y;
                tmp2.x = -tmp0.y * tmp0.y + 1.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp2.y = tmp0.x + tmp0.x;
                tmp2.y = frac(tmp2.y);
                tmp0.x = tmp0.x * 2.0 + tmp2.y;
                tmp0.x = tmp0.x / _AvgCycleLength;
                tmp0.x = frac(tmp0.x);
                tmp2.y = _CycleGlitchRatio >= tmp0.x;
                tmp0.x = tmp0.x >= _CycleGlitchRatio;
                tmp2.y = tmp2.y ? 1.0 : 0.0;
                tmp2.z = tmp0.x ? 1.0 : 0.0;
                tmp2.y = tmp2.z * tmp2.y;
                tmp0.x = tmp0.x ? 0.0 : tmp2.y;
                tmp0.x = tmp0.x + tmp2.z;
                tmp2.y = inp.color.w * _Fade;
                tmp2.z = tmp2.y * 4.0;
                tmp2.z = round(tmp2.z);
                tmp0.x = tmp0.x * tmp2.z;
                tmp0.x = tmp0.x * 0.25;
                tmp2.z = tmp2.x * tmp0.x;
                tmp2.x = tmp0.y * tmp2.x;
                tmp0.y = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * tmp2.x;
                tmp3.xyz = tmp0.xxx * float3(0.0, 0.0, 0.667);
                tmp2.xw = tmp0.zw * float2(2304.0, 64.0);
                tmp0.xz = tmp0.wz * tmp0.wz;
                tmp0.x = tmp0.z + tmp0.x;
                tmp0.zw = frac(tmp2.xw);
                tmp0.zw = log(tmp0.zw);
                tmp0.zw = tmp0.zw * float2(0.1, 0.1);
                tmp0.zw = exp(tmp0.zw);
                tmp2.x = tmp0.w * tmp2.z;
                tmp2.x = tmp2.x * inp.color.x;
                tmp2.xzw = tmp2.xxx * float3(0.333, 0.0, 0.0);
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.z = max(tmp0.w, tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp3.xyz;
                tmp0.y = tmp0.y * inp.color.y;
                tmp0.yzw = tmp0.yyy * float3(0.0, 0.333, 0.0) + tmp2.xzw;
                tmp0.yzw = tmp3.xyz * inp.color.yyy + tmp0.yzw;
                tmp0.yzw = float3(0.0683247, 0.3039706, 0.4142157) - tmp0.yzw;
                tmp0.yzw = min(abs(tmp0.yzw), float3(1.0, 1.0, 1.0));
                tmp2.x = tmp1.z > 0.5;
                tmp1.w = -tmp1.w * 2.0 + 1.0;
                tmp1.z = dot(tmp0.xy, tmp1.xy);
                tmp2.z = 1.0 - tmp0.x;
                tmp1.w = -tmp1.w * tmp2.z + 1.0;
                tmp1.z = saturate(tmp2.x ? tmp1.w : tmp1.z);
                tmp1.w = 1.0 - tmp1.z;
                tmp1.z = dot(tmp1.xy, tmp2.xy);
                tmp2.x = _Fade * inp.color.w + -0.5;
                tmp2.x = -tmp2.x * 2.0 + 1.0;
                tmp1.w = -tmp2.x * tmp1.w + 1.0;
                tmp2.x = tmp2.y > 0.5;
                tmp1.z = saturate(tmp2.x ? tmp1.w : tmp1.z);
                tmp1.z = tmp1.z * 4.0;
                tmp1.z = floor(tmp1.z);
                tmp1.z = tmp0.x * tmp1.z;
                tmp1.z = tmp2.y * tmp1.z;
                tmp1.z = tmp1.z * 0.111;
                tmp1.y = max(tmp1.y, 0.0);
                tmp1.x = saturate(tmp1.x);
                tmp1.y = min(tmp1.y, 0.75);
                tmp1.x = tmp1.x + tmp1.y;
                tmp1.x = min(tmp1.x, 1.0);
                tmp0.x = tmp0.x * tmp1.x;
                tmp1.xyw = tmp0.xxx * float3(0.0, 0.0647059, 0.0843138);
                o.sv_target.w = tmp0.x * 0.25 + tmp1.z;
                o.sv_target.xyz = tmp0.yzw * tmp1.zzz + tmp1.xyw;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}