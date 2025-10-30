Shader "SR/UI/MagicWaterAmmo" {
	Properties {
		[HideInInspector] _MainTex ("MainTex", 2D) = "white" {}
		_TintColor ("Color", Color) = (1,1,1,1)
		_Bubbles ("Bubbles", 2D) = "black" {}
		_Noise ("Noise", 2D) = "black" {}
		_Rays ("Rays", 2D) = "white" {}
		_Prism ("Prism", 2D) = "white" {}
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 58055
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _TintColor;
			float4 _Bubbles_ST;
			float4 _Noise_ST;
			float4 _Rays_ST;
			float4 _Prism_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Noise;
			sampler2D _Bubbles;
			sampler2D _Rays;
			sampler2D _Prism;
			
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.xy = _TimeEditor.wy + _Time.wy;
                tmp0.zw = tmp0.yy * float2(-0.25, 0.1);
                tmp0.zw = inp.texcoord.xy * float2(0.8, 0.8) + tmp0.zw;
                tmp0.zw = tmp0.zw * _Noise_ST.xy + _Noise_ST.zw;
                tmp1 = tex2D(_Noise, tmp0.zw);
                tmp0.z = 1.0 - tmp1.x;
                tmp1.yz = tmp0.yy * float2(0.1, -0.3) + inp.texcoord.xy;
                tmp1.yz = tmp1.yz * _Noise_ST.xy + _Noise_ST.zw;
                tmp2 = tex2D(_Noise, tmp1.yz);
                tmp0.w = tmp2.x - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.z = -tmp0.w * tmp0.z + 1.0;
                tmp0.w = dot(tmp1.xy, tmp2.xy);
                tmp1.x = tmp2.x > 0.5;
                tmp0.z = saturate(tmp1.x ? tmp0.z : tmp0.w);
                tmp0.zw = tmp0.zz * float2(0.05, -1.5) + float2(-0.025, 1.0);
                tmp1 = tmp0.zzzz + inp.texcoord.xyxy;
                tmp1 = tmp0.yyyy * float4(-0.01, -1.0, 0.01, -0.75) + tmp1;
                tmp1 = tmp1 * _Bubbles_ST + _Bubbles_ST;
                tmp2 = tex2D(_Bubbles, tmp1.xy);
                tmp1 = tex2D(_Bubbles, tmp1.zw);
                tmp0.z = saturate(tmp1.z + tmp2.y);
                tmp1.xy = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.xy = tmp1.xy * tmp1.xy;
                tmp1.x = tmp1.y + tmp1.x;
                tmp1.x = tmp1.x * -1.5 + 1.0;
                tmp1.x = max(tmp1.x, 0.0);
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = tmp1.x * 0.25 + -0.1;
                tmp1.x = max(tmp1.x, 0.0);
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.yz = inp.texcoord.yy * float2(4.0, 2.8) + float2(-1.0, -0.8);
                tmp0.w = tmp0.w * tmp1.y;
                tmp1.y = tmp0.z * tmp0.w;
                tmp2.xy = sin(tmp0.xy);
                tmp0.xy = tmp0.yy * float2(-0.2, 0.13);
                tmp2.zw = tmp2.xx * float2(0.1, -0.1);
                tmp3 = inp.texcoord.xyxy * tmp2.zzww + inp.texcoord.xyxy;
                tmp3 = -tmp2.xxxx * float4(0.05, 0.05, -0.05, -0.05) + tmp3;
                tmp3 = tmp3 - float4(0.5, 0.5, 0.5, 0.5);
                tmp0.x = sin(tmp0.x);
                tmp2.x = cos(tmp0.x);
                tmp4.x = sin(tmp0.y);
                tmp5.x = cos(tmp0.y);
                tmp6.z = tmp0.x;
                tmp6.y = tmp2.x;
                tmp6.x = -tmp0.x;
                tmp0.y = dot(tmp3.xy, tmp6.xy);
                tmp0.x = dot(tmp3.xy, tmp6.xy);
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * _Rays_ST.xy + _Rays_ST.zw;
                tmp6 = tex2D(_Rays, tmp0.xy);
                tmp0.x = 1.0 - tmp6.x;
                tmp7.z = tmp4.x;
                tmp7.y = tmp5.x;
                tmp7.x = -tmp4.x;
                tmp3.y = dot(tmp3.xy, tmp7.xy);
                tmp3.x = dot(tmp3.xy, tmp7.xy);
                tmp2.xz = tmp3.xy + float2(0.5, 0.5);
                tmp2.xz = tmp2.xz * _Rays_ST.xy + _Rays_ST.zw;
                tmp3 = tex2D(_Rays, tmp2.xz);
                tmp0.y = tmp3.x - 0.5;
                tmp0.y = -tmp0.y * 2.0 + 1.0;
                tmp0.x = -tmp0.y * tmp0.x + 1.0;
                tmp0.y = dot(tmp6.xy, tmp3.xy);
                tmp1.w = tmp3.x > 0.5;
                tmp0.x = saturate(tmp1.w ? tmp0.x : tmp0.y);
                tmp0.y = saturate(tmp0.x * 20.0 + -1.0);
                tmp0.x = tmp0.x * 2.0 + tmp0.y;
                tmp0.x = saturate(tmp1.z * tmp0.x);
                tmp0.y = tmp1.y * 0.2 + tmp0.x;
                tmp0.y = tmp2.y + tmp0.y;
                tmp1.yz = tmp0.yy * _Prism_ST.xy + _Prism_ST.zw;
                tmp2 = tex2D(_Prism, tmp1.yz);
                tmp1.yzw = tmp0.xxx + tmp2.xyz;
                tmp0.x = tmp0.w * tmp0.z + tmp0.x;
                tmp0.x = tmp1.x + tmp0.x;
                tmp2 = inp.color * _TintColor;
                tmp0.yzw = tmp2.www * tmp2.xyz;
                tmp0.yzw = tmp0.yzw * tmp1.yzw;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}