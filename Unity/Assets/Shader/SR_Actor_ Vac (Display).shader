Shader "SR/Actor, Vac (Display)" {
	Properties {
		_SpiralColor ("Spiral Color", Range(0, 1)) = 0.5
		_SpiralRamp ("Spiral Ramp", 2D) = "white" {}
		_AmmoFullness ("Ammo Fullness", Range(0, 1)) = 0
		_AmmoColor ("Ammo Color", Color) = (1,0.392638,0,1)
		_scanlines ("scanlines", 2D) = "white" {}
		_lines ("lines", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_Arrow ("Arrow", 2D) = "white" {}
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 46149
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _scanlines_ST;
			float4 _lines_ST;
			float4 _Mask_ST;
			float4 _Arrow_ST;
			float _SpiralColor;
			float _AmmoFullness;
			float4 _AmmoColor;
			float4 _SpiralRamp_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _SpiralRamp;
			sampler2D _Mask;
			sampler2D _Arrow;
			sampler2D _scanlines;
			sampler2D _lines;
			
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
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
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
                tmp0.x = 0.6;
                tmp0.y = _SpiralColor;
                tmp0.xy = tmp0.xy * _SpiralRamp_ST.xy + _SpiralRamp_ST.zw;
                tmp0 = tex2D(_SpiralRamp, tmp0.xy);
                tmp1.xy = inp.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp1 = tex2Dlod(_Mask, float4(tmp1.xy, 0, 0.0));
                tmp0.w = _SpiralColor - 0.5;
                tmp0.w = abs(tmp0.w) * -2.0 + 1.0;
                tmp1.x = -tmp0.w * 1.09 + tmp1.x;
                tmp1.x = tmp1.x * 50.0;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = min(tmp1.x, 0.99);
                tmp2.xyz = tmp1.zzz * float3(0.3508867, 0.3841092, 0.4044118);
                tmp0.xyz = tmp0.xyz * tmp1.xxx + tmp2.xyz;
                tmp1.x = _AmmoFullness * -0.98 + 0.98;
                tmp1.x = tmp1.y - tmp1.x;
                tmp1.x = saturate(tmp1.x * 50.0);
                tmp0.xyz = _AmmoColor.xyz * tmp1.xxx + tmp0.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp1.w = tmp0.w * 2.0 + -1.0;
                tmp0.w = 1.0 - tmp0.w;
                tmp2.x = _TimeEditor.y + _Time.y;
                tmp2.y = tmp0.w * tmp2.x;
                tmp2.y = tmp2.y * 30.0;
                tmp2.y = sin(tmp2.y);
                tmp0.w = tmp0.w * tmp2.y;
                tmp0.w = tmp0.w * 0.05 + tmp1.w;
                tmp3.x = sin(tmp0.w);
                tmp4.x = cos(tmp0.w);
                tmp5.z = tmp3.x;
                tmp5.y = tmp4.x;
                tmp5.x = -tmp3.x;
                tmp2.yz = inp.texcoord.xy - float2(0.5, 0.5);
                tmp3.x = dot(tmp2.xy, tmp5.xy);
                tmp3.y = dot(tmp2.xy, tmp5.xy);
                tmp2.yz = tmp3.xy + float2(0.5, 0.5);
                tmp2.yz = tmp2.yz * _Arrow_ST.xy + _Arrow_ST.zw;
                tmp3 = tex2D(_Arrow, tmp2.yz);
                tmp0.xyz = tmp3.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xy = tmp2.xx * float2(0.0, 2.0);
                tmp1.xy = inp.texcoord.xy * float2(48.0, 48.0) + tmp1.xy;
                tmp1.xy = tmp1.xy * _scanlines_ST.xy + _scanlines_ST.zw;
                tmp1 = tex2D(_scanlines, tmp1.xy);
                tmp2.yzw = tmp1.xyz * float3(0.333, 0.333, 0.333) + float3(0.667, 0.667, 0.667);
                tmp0.xyz = tmp0.xyz * tmp2.yzw;
                tmp2.yz = tmp2.xx * float2(0.0, 0.2) + inp.texcoord.xy;
                tmp2.yz = tmp2.yz * _lines_ST.xy + _lines_ST.zw;
                tmp3 = tex2D(_lines, tmp2.yz);
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.xyz + tmp0.xyz;
                tmp1.xy = tmp2.xx + inp.texcoord.xy;
                tmp2 = tmp2.xxxx * float4(0.6, 0.6, 0.8, 0.8) + inp.texcoord.xyxy;
                tmp1.zw = tmp1.xy + float2(0.2127, 0.2127);
                tmp0.w = tmp1.y * tmp1.x;
                tmp1.xy = tmp0.ww * float2(0.3713, 0.3713) + tmp1.zw;
                tmp1.yz = tmp1.xy * float2(489.123, 489.123);
                tmp0.w = tmp1.x + 1.0;
                tmp1.xy = sin(tmp1.yz);
                tmp1.xy = tmp1.xy * float2(4.789, 4.789);
                tmp1.x = tmp1.y * tmp1.x;
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.w = frac(tmp0.w);
                tmp0.w = max(tmp0.w, 0.65);
                tmp1.x = dot(tmp0.xy, tmp0.xy);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.yzw = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp1.yzw = -tmp1.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.w = -tmp1.w * tmp0.w + 1.0;
                tmp3.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                o.sv_target.z = saturate(tmp3.z ? tmp0.w : tmp1.x);
                tmp4 = tmp2 + float4(0.2127, 0.2127, 0.2127, 0.2127);
                tmp2 = tmp2.yyww * tmp2.xxzz;
                tmp2 = tmp2 * float4(0.3713, 0.3713, 0.3713, 0.3713) + tmp4;
                tmp4 = tmp2 * float4(489.123, 489.123, 489.123, 489.123);
                tmp0.zw = tmp2.xz + float2(1.0, 1.0);
                tmp2 = sin(tmp4);
                tmp2 = tmp2 * float4(4.789, 4.789, 4.789, 4.789);
                tmp1.xw = tmp2.yw * tmp2.xz;
                tmp0.zw = tmp0.zw * tmp1.xw;
                tmp0.zw = frac(tmp0.zw);
                tmp0.zw = max(tmp0.zw, float2(0.65, 0.65));
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.y = dot(tmp0.xy, tmp0.xy);
                tmp0.zw = float2(1.0, 1.0) - tmp0.zw;
                tmp0.zw = -tmp1.yz * tmp0.zw + float2(1.0, 1.0);
                o.sv_target.xy = saturate(tmp3.xy ? tmp0.zw : tmp0.xy);
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}