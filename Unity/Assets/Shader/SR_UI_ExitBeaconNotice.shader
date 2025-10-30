Shader "SR/UI/ExitBeaconNotice" {
	Properties {
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255
		_ColorMask ("Color Mask", Float) = 15
		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		[NoScaleOffset] _Grid ("Grid", 2D) = "white" {}
		_BGColor ("BG Color", Color) = (0.1012371,0.1695248,0.3301887,1)
		_WaveColor ("Wave Color", Color) = (0.9803922,0.7294118,0.01960784,0.4980392)
		_GridColor ("Grid Color", Color) = (0.9803922,0.7294118,0.01960784,0.4980392)
	}
	SubShader {
		Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "Default"
			Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ColorMask 0
			Stencil {
				ReadMask 0
				WriteMask 0
				Comp [Disabled]
				Pass Keep
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 44638
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 color : COLOR0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _Color;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _GridColor;
			float4 _WaveColor;
			float4 _BGColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Grid;
			
			// Keywords: 
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
                o.position = tmp0;
                o.color = v.color * _Color;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = v.vertex;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.zw = tmp0.zw;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
                return o;
			}
			// Keywords: 
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
                tmp0.xz = float2(0.0, 1.0);
                tmp1.xy = _Time.yy * float2(-0.15, 0.4);
                tmp0.w = _ScreenParams.x / _ScreenParams.y;
                tmp2.yz = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp2.x = tmp0.w * tmp2.y;
                tmp1.xy = tmp2.xz * float2(1.5, 1.5) + tmp1.xy;
                tmp1.zw = tmp2.xz + tmp2.xz;
                tmp0.w = _Time.y * 0.25 + tmp2.z;
                tmp0.w = frac(tmp0.w);
                tmp0.w = tmp0.w * 2.0 + -1.0;
                tmp0.w = abs(tmp0.w) - 0.1;
                tmp0.w = tmp0.w * -10.0;
                tmp0.w = max(tmp0.w, 0.0);
                tmp2.x = dot(tmp1.xy, float2(0.3660254, 0.3660254));
                tmp2.xy = tmp1.xy + tmp2.xx;
                tmp2.xy = floor(tmp2.xy);
                tmp2.zw = tmp2.xy * float2(0.0034602, 0.0034602);
                tmp2.zw = floor(tmp2.zw);
                tmp2.zw = -tmp2.zw * float2(289.0, 289.0) + tmp2.xy;
                tmp1.xy = tmp1.xy - tmp2.xy;
                tmp2.x = dot(tmp2.xy, float2(0.2113249, 0.2113249));
                tmp1.xy = tmp1.xy + tmp2.xx;
                tmp2.x = tmp1.y < tmp1.x;
                tmp3 = tmp2.xxxx ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp0.y = tmp3.y;
                tmp0.xyz = tmp0.xyz + tmp2.www;
                tmp2.xyw = tmp0.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.xyw;
                tmp2.xyw = tmp0.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp2.xyw = floor(tmp2.xyw);
                tmp0.xyz = -tmp2.xyw * float3(289.0, 289.0, 289.0) + tmp0.xyz;
                tmp0.xyz = tmp2.zzz + tmp0.xyz;
                tmp2.xz = float2(0.0, 1.0);
                tmp2.y = tmp3.x;
                tmp0.xyz = tmp0.xyz + tmp2.xyz;
                tmp2.xyz = tmp0.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp0.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp2.xyz = floor(tmp2.xyz);
                tmp0.xyz = -tmp2.xyz * float3(289.0, 289.0, 289.0) + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp0.xyz = frac(tmp0.xyz);
                tmp2.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp0.xyz = tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp2.xyz = floor(tmp2.xyz);
                tmp2.xyz = tmp0.xyz - tmp2.xyz;
                tmp0.xyz = abs(tmp0.xyz) - float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp0.xyz * tmp0.xyz;
                tmp4.xyz = tmp2.xyz * tmp2.xyz + tmp4.xyz;
                tmp4.xyz = -tmp4.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp5.x = dot(tmp1.xy, tmp1.xy);
                tmp6 = tmp1.xyxy + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp6.xy = tmp3.zw + tmp6.xy;
                tmp5.y = dot(tmp6.xy, tmp6.xy);
                tmp5.z = dot(tmp6.xy, tmp6.xy);
                tmp3.xyz = float3(0.5, 0.5, 0.5) - tmp5.xyz;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp3.xyz = tmp3.xyz * tmp3.xyz;
                tmp3.xyz = tmp3.xyz * tmp3.xyz;
                tmp3.xyz = tmp4.xyz * tmp3.xyz;
                tmp0.x = tmp1.y * tmp0.x;
                tmp0.yz = tmp0.yz * tmp6.yw;
                tmp4.yz = tmp2.yz * tmp6.xz + tmp0.yz;
                tmp4.x = tmp2.x * tmp1.x + tmp0.x;
                tmp0.x = dot(tmp3.xyz, tmp4.xyz);
                tmp0.x = tmp0.x * 130.0;
                tmp0.yz = _Time.yy * float2(0.333, 0.5) + tmp1.zw;
                tmp1 = tex2D(_Grid, tmp1.zw);
                tmp1.xy = float2(1.0, 0.5) - tmp1.xx;
                tmp1.z = dot(tmp0.xy, float2(0.3660254, 0.3660254));
                tmp1.zw = tmp0.yz + tmp1.zz;
                tmp1.zw = floor(tmp1.zw);
                tmp2.xy = tmp1.zw * float2(0.0034602, 0.0034602);
                tmp2.xy = floor(tmp2.xy);
                tmp2.xy = -tmp2.xy * float2(289.0, 289.0) + tmp1.zw;
                tmp3.xz = float2(0.0, 1.0);
                tmp0.yz = tmp0.yz - tmp1.zw;
                tmp1.z = dot(tmp1.xy, float2(0.2113249, 0.2113249));
                tmp0.yz = tmp0.yz + tmp1.zz;
                tmp1.z = tmp0.z < tmp0.y;
                tmp4 = tmp1.zzzz ? float4(1.0, 0.0, -1.0, -0.0) : float4(0.0, 1.0, -0.0, -1.0);
                tmp3.y = tmp4.y;
                tmp2.yzw = tmp2.yyy + tmp3.xyz;
                tmp3.xyz = tmp2.yzw * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp2.yzw = tmp2.yzw * tmp3.xyz;
                tmp3.xyz = tmp2.yzw * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp2.yzw = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp2.yzw;
                tmp2.xyz = tmp2.xxx + tmp2.yzw;
                tmp3.xz = float2(0.0, 1.0);
                tmp3.y = tmp4.x;
                tmp2.xyz = tmp2.xyz + tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(34.0, 34.0, 34.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp3.xyz = tmp2.xyz * float3(0.0034602, 0.0034602, 0.0034602);
                tmp3.xyz = floor(tmp3.xyz);
                tmp2.xyz = -tmp3.xyz * float3(289.0, 289.0, 289.0) + tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.0243902, 0.0243902, 0.0243902);
                tmp2.xyz = frac(tmp2.xyz);
                tmp3.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp3.xyz = floor(tmp3.xyz);
                tmp3.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = abs(tmp2.xyz) - float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp2.xyz * tmp2.xyz;
                tmp5.xyz = tmp3.xyz * tmp3.xyz + tmp5.xyz;
                tmp5.xyz = -tmp5.xyz * float3(0.8537347, 0.8537347, 0.8537347) + float3(1.792843, 1.792843, 1.792843);
                tmp6.x = dot(tmp0.xy, tmp0.xy);
                tmp7 = tmp0.yzyz + float4(0.2113249, 0.2113249, -0.5773503, -0.5773503);
                tmp7.xy = tmp4.zw + tmp7.xy;
                tmp6.y = dot(tmp7.xy, tmp7.xy);
                tmp6.z = dot(tmp7.xy, tmp7.xy);
                tmp4.xyz = float3(0.5, 0.5, 0.5) - tmp6.xyz;
                tmp4.xyz = max(tmp4.xyz, float3(0.0, 0.0, 0.0));
                tmp4.xyz = tmp4.xyz * tmp4.xyz;
                tmp4.xyz = tmp4.xyz * tmp4.xyz;
                tmp4.xyz = tmp5.xyz * tmp4.xyz;
                tmp0.z = tmp0.z * tmp2.x;
                tmp1.zw = tmp2.yz * tmp7.yw;
                tmp2.yz = tmp3.yz * tmp7.xz + tmp1.zw;
                tmp2.x = tmp3.x * tmp0.y + tmp0.z;
                tmp0.y = dot(tmp4.xyz, tmp2.xyz);
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 130.0 + 1.0;
                tmp0.y = -tmp0.x * 0.5 + 1.0;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = dot(tmp0.xy, tmp1.xy);
                tmp0.z = -tmp1.y * 2.0 + 1.0;
                tmp1.x = tmp1.x > 0.5;
                tmp0.y = -tmp0.z * tmp0.y + 1.0;
                tmp0.x = saturate(tmp1.x ? tmp0.y : tmp0.x);
                tmp0.yz = tmp0.xx - float2(0.4, 0.8);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.yz = saturate(tmp0.yz * float2(5.0, -2.5));
                tmp1.xy = tmp0.yz * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.y * tmp1.x;
                tmp0.z = tmp1.y * tmp0.z + -tmp0.y;
                tmp1.x = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.y = tmp0.w * tmp0.z + tmp0.y;
                tmp1.xyz = _GridColor.www * _GridColor.xyz;
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.x = 1.0 - inp.texcoord.y;
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.xyz = _WaveColor.xyz * _WaveColor.www + -tmp0.yzw;
                tmp1.w = 1.0 - tmp0.x;
                tmp2 = inp.texcoord.xyxy * float4(2.0, 0.5, 1.0, 0.5) + float4(-1.0, -0.15, -0.5, -0.5);
                tmp2.x = dot(tmp2.xy, tmp2.xy);
                tmp2.y = dot(tmp2.xy, tmp2.xy);
                tmp2.xy = sqrt(tmp2.xy);
                tmp2.y = min(tmp2.y, 1.0);
                tmp2.y = tmp2.y - 1.0;
                tmp2.x = tmp2.x + inp.color.w;
                tmp2.x = frac(tmp2.x);
                tmp2.x = tmp2.x * 2.0 + -1.0;
                tmp2.x = abs(tmp2.x) - 0.8;
                tmp2.x = tmp2.x * 5.0;
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.z = tmp2.x * -2.0 + 3.0;
                tmp2.x = tmp2.x * tmp2.x;
                tmp2.w = tmp2.z * tmp2.x + -0.5;
                tmp2.x = tmp2.x * tmp2.z;
                tmp2.z = -tmp2.w * 2.0 + 1.0;
                tmp1.w = -tmp2.z * tmp1.w + 1.0;
                tmp0.x = dot(tmp0.xy, tmp2.xy);
                tmp2.x = tmp2.x > 0.5;
                tmp0.x = saturate(tmp2.x ? tmp1.w : tmp0.x);
                tmp0.x = tmp0.x - 0.85;
                tmp0.x = saturate(tmp0.x * 20.00002);
                tmp1.w = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp1.w;
                tmp0.yzw = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                tmp1.x = tmp2.y * tmp2.y;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = -tmp2.y * tmp1.x + -0.01;
                tmp1.x = saturate(tmp1.x * 2.040816);
                tmp1.y = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                o.sv_target.xyz = _BGColor.xyz * tmp1.xxx + tmp0.yzw;
                tmp0.y = _WaveColor.w - _BGColor.w;
                tmp0.x = tmp0.x * tmp0.y + _BGColor.w;
                o.sv_target.w = tmp1.x * tmp0.x;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}