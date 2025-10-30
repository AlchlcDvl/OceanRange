Shader "SR/RanchTech/CorralBarrier" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_ColorRamp ("Color-Ramp", 2D) = "white" {}
		_Stripes ("Stripes", 2D) = "white" {}
		[MaterialToggle] _StripesInvert ("Stripes Invert", Float) = 0
		[MaterialToggle] _ToggleWallpaper ("Toggle Wallpaper", Float) = 0
		_Wallpaper ("Wallpaper", 2D) = "white" {}
		_Noise ("Noise", Cube) = "_Skybox" {}
		[MaterialToggle] _ToggleMask ("Toggle Mask", Float) = 0.1
		_Mask ("Mask", 2D) = "white" {}
		[MaterialToggle] _VertexWobble ("Vertex Wobble", Float) = 0
		_FadeNoise ("Fade Noise", 2D) = "white" {}
		_Health ("Health", Range(0, 1)) = 1
		[MaterialToggle] _EdgeFade ("Edge Fade", Float) = 0.1
		[MaterialToggle] _EdgeGlow ("Edge Glow", Float) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 51617
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _VertexWobble;
			float _Health;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorRamp_ST;
			float4 _Stripes_ST;
			float _StripesInvert;
			float4 _Wallpaper_ST;
			float _ToggleWallpaper;
			float4 _Color;
			float _ToggleMask;
			float4 _Mask_ST;
			float4 _FadeNoise_ST;
			float _EdgeFade;
			float _EdgeGlow;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			samplerCUBE _Noise;
			sampler2D _ColorRamp;
			sampler2D _Wallpaper;
			sampler2D _Stripes;
			sampler2D _Mask;
			sampler2D _FadeNoise;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = float2(1.0, 1.0) - v.texcoord1.yx;
                tmp0.xy = tmp0.xy * v.texcoord1.yx;
                tmp0.x = tmp0.x * 5.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = saturate(tmp0.x * 5.0);
                tmp0.xyz = tmp0.xxx * float3(0.01, 0.25, 0.01);
                tmp0.w = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.w = tmp0.w + unity_ObjectToWorld._m23;
                tmp1.xy = _Health.xx * float2(-10.0, -2.75) + float2(10.0, 3.0);
                tmp0.w = _Time.y * tmp1.x + tmp0.w;
                tmp0.w = tmp1.y * tmp0.w;
                tmp0.w = sin(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = _VertexWobble.xxx * tmp0.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.x = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord3.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.xy = float2(1.0, 1.5) - tmp0.ww;
                tmp2.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp2.xyz;
                tmp0.xzw = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp2.xyz;
                tmp2 = texCUBElod(_Noise, float4(tmp0.xzw, 2.0));
                tmp2.x = _Time.y * 0.167 + tmp2.x;
                tmp2.y = 0.0;
                tmp0.xz = tmp1.xx + tmp2.xy;
                tmp0.xz = tmp0.xz * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp2 = tex2D(_ColorRamp, tmp0.xz);
                tmp0.xz = _Time.yy * float2(0.0, 0.1) + inp.texcoord.xy;
                tmp0.w = 0.0;
                tmp1.z = 0.0;
                while (true) {
                    tmp1.w = i >= 8;
                    if (tmp1.w) {
                        break;
                    }
                    i = i + 1;
                    tmp3.xy = tmp0.xz * tmp1.ww;
                    tmp3.zw = floor(tmp3.xy);
                    tmp3.xy = frac(tmp3.xy);
                    tmp4.xy = tmp3.xy * tmp3.xy;
                    tmp3.xy = -tmp3.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp3.xy = tmp3.xy * tmp4.xy;
                    tmp1.w = tmp3.w * 57.0 + tmp3.z;
                    tmp4.xyz = tmp1.www + float3(1.0, 57.0, 58.0);
                    tmp5.x = sin(tmp1.w);
                    tmp5.yzw = sin(tmp4.xyz);
                    tmp4 = tmp5 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp4 = frac(tmp4);
                    tmp3.zw = tmp4.yw - tmp4.xz;
                    tmp3.xz = tmp3.xx * tmp3.zw + tmp4.xz;
                    tmp1.w = tmp3.z - tmp3.x;
                    tmp1.w = tmp3.y * tmp1.w + tmp3.x;
                    tmp2.w = null.w / 8;
                    tmp0.w = tmp1.w * tmp2.w + tmp0.w;
                }
                tmp0.x = tmp0.w * 0.125;
                tmp0.z = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.z;
                tmp3 = _Time * float4(0.05, 0.0, 0.0, 0.03) + inp.texcoord.xyxy;
                tmp3 = tmp0.xxxx * float4(0.05, 0.05, 0.1, 0.1) + tmp3;
                tmp0.xz = tmp3.xy * _Wallpaper_ST.xy + _Wallpaper_ST.zw;
                tmp4 = tex2D(_Wallpaper, tmp0.xz);
                tmp0.xz = tmp3.zw * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp3 = tex2D(_Stripes, tmp0.xz);
                tmp0.x = tmp3.x * -2.0 + 1.0;
                tmp0.x = _StripesInvert * tmp0.x + tmp3.x;
                tmp0.zw = tmp1.xx * float2(-5.0, -2.0) + float2(0.5, 1.0);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = _ToggleWallpaper * tmp4.x + tmp0.x;
                tmp0.x = tmp0.x + 0.1;
                tmp1.zw = float2(1.0, 1.0) - inp.texcoord.xy;
                tmp1.zw = tmp1.zw * inp.texcoord.xy;
                tmp0.w = tmp1.z * tmp1.w;
                tmp0.w = saturate(tmp0.w * 25.0);
                tmp0.w = tmp0.w * tmp0.x;
                tmp0.w = tmp1.z * -5.625 + tmp0.w;
                tmp0.w = tmp0.w + 0.75;
                tmp0.z = saturate(tmp0.z);
                tmp0.z = tmp0.z + tmp0.w;
                tmp1.zw = saturate(tmp0.yy * float2(-0.875, 0.5) + float2(-0.125, 0.5));
                tmp0.y = saturate(tmp0.y + tmp0.y);
                tmp0.w = tmp1.x * tmp1.x;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w + tmp1.w;
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.y = saturate(tmp0.y * tmp1.y + tmp1.z);
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.y = tmp0.y - tmp0.x;
                tmp0.x = _EdgeFade * tmp0.y + tmp0.x;
                tmp0.yz = inp.texcoord1.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp1 = tex2D(_Mask, tmp0.yz);
                tmp0.y = _Health * 0.25;
                tmp0.z = 0.0;
                tmp0.yz = tmp0.yz + inp.texcoord.xy;
                tmp0.yz = _Time.yy * float2(-0.05, 0.0) + tmp0.yz;
                tmp0.yz = tmp0.yz * _FadeNoise_ST.xy + _FadeNoise_ST.zw;
                tmp3 = tex2D(_FadeNoise, tmp0.yz);
                tmp0.y = _Health * -1.5 + 0.5;
                tmp0.z = dot(tmp2.xyz, float3(0.3, 0.59, 0.11));
                tmp1.yzw = tmp0.zzz - tmp2.xyz;
                tmp1.yzw = tmp1.yzw * float3(0.5, 0.5, 0.5) + tmp2.xyz;
                tmp0.z = tmp0.x * tmp1.x + -tmp0.x;
                tmp0.x = saturate(_ToggleMask * tmp0.z + tmp0.x);
                tmp0.xzw = saturate(tmp0.xxx * tmp1.yzw);
                tmp0.xzw = tmp0.xzw * _Color.xyz;
                tmp1.x = saturate(tmp3.x * 0.2 + 0.8);
                tmp1.yz = saturate(inp.texcoord.xy * float2(-2.0, -2.0) + float2(1.0, 0.5));
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.z = saturate(inp.texcoord.y * 2.0 + -1.5);
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.x = max(tmp0.y, tmp1.x);
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.x = tmp1.x - tmp0.y;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = saturate(tmp1.x / tmp0.y);
                tmp0.y = tmp0.y - 1.0;
                tmp0.y = _EdgeGlow * tmp0.y + 1.0;
                tmp0.xyz = tmp0.yyy * tmp0.xzw;
                o.sv_target.xyz = tmp0.xyz * float3(1.5, 1.5, 1.5);
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Overlay" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 123648
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _VertexWobble;
			float _Health;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = float2(1.0, 1.0) - v.texcoord1.yx;
                tmp0.xy = tmp0.xy * v.texcoord1.yx;
                tmp0.x = tmp0.x * 5.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = saturate(tmp0.x * 5.0);
                tmp0.xyz = tmp0.xxx * float3(0.01, 0.25, 0.01);
                tmp0.w = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.w = tmp0.w + unity_ObjectToWorld._m23;
                tmp1.xy = _Health.xx * float2(-10.0, -2.75) + float2(10.0, 3.0);
                tmp0.w = _Time.y * tmp1.x + tmp0.w;
                tmp0.w = tmp1.y * tmp0.w;
                tmp0.w = sin(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = _VertexWobble.xxx * tmp0.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord1.xy = v.texcoord1.xy;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
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