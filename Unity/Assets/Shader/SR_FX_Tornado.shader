Shader "SR/FX/Tornado" {
	Properties {
		_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
		_USpeed ("U Speed", Float) = 0
		_VSpeed ("V Speed", Float) = 0
		_Texture ("Texture", 2D) = "black" {}
		_Opacity ("Opacity", Range(0, 1)) = 1
		_DepthBlend ("DepthBlend", Float) = 0.5
		_NearClip ("NearClip", Float) = 1.5
		[MaterialToggle] _BottomHeavy ("BottomHeavy", Float) = 0
		_AlphaFuzzy ("AlphaFuzzy", Float) = 0
		_AlphaClip ("AlphaClip", Float) = 0.5
		_EmissiveColor ("EmissiveColor", Color) = (0,0,0,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 550
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 38112
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
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _TintColor;
			float _USpeed;
			float _VSpeed;
			float4 _Texture_ST;
			float _Opacity;
			float _DepthBlend;
			float _NearClip;
			float _BottomHeavy;
			float _AlphaFuzzy;
			float _AlphaClip;
			float4 _EmissiveColor;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _Texture;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                o.texcoord2.xyz = tmp0.zzz * tmp2.xyz;
                o.color = v.color;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord3.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.w = tmp0.w;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
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
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp0.yz = tmp0.xx * float2(_USpeed.x, _VSpeed.x);
                tmp0.xw = tmp0.xx * float2(_USpeed.x, _VSpeed.x) + inp.texcoord.xy;
                tmp0.xw = tmp0.xw * _Texture_ST.xy + _Texture_ST.zw;
                tmp1 = tex2D(_Texture, tmp0.xw);
                tmp0.xy = tmp0.yz * float2(-0.5, -0.5) + inp.texcoord.xy;
                tmp0.xy = tmp0.xy + float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * _Texture_ST.xy + _Texture_ST.zw;
                tmp0 = tex2D(_Texture, tmp0.xy);
                tmp0.y = 1.0 - tmp0.x;
                tmp0.x = dot(tmp0.xy, tmp1.xy);
                tmp0.z = tmp1.x - 0.5;
                tmp0.w = tmp1.x > 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.y = -tmp0.z * tmp0.y + 1.0;
                tmp0.x = saturate(tmp0.w ? tmp0.y : tmp0.x);
                tmp0.y = 1.0 - tmp0.x;
                tmp0.z = inp.texcoord.y * -1.125 + 0.875;
                tmp0.w = 1.0 - tmp0.z;
                tmp0.y = -tmp0.y * tmp0.w + 1.0;
                tmp0.w = tmp0.x * 0.5 + 0.5;
                tmp1.x = tmp0.w > 0.5;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.y = saturate(tmp1.x ? tmp0.y : tmp0.z);
                tmp0.y = tmp0.y - tmp0.x;
                tmp0.x = _BottomHeavy * tmp0.y + tmp0.x;
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * inp.texcoord2.xyz;
                tmp0.y = dot(tmp1.xyz, tmp0.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * 1.5;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp0.y * -1.111111 + 1.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = inp.texcoord.y * 2.0 + -1.0;
                tmp0.y = saturate(abs(tmp0.y) * -4.0 + 4.0);
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.yz = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.yz);
                tmp0.y = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.y = tmp0.y - _ProjectionParams.y;
                tmp0.z = inp.texcoord3.z - _ProjectionParams.y;
                tmp0.yz = max(tmp0.yz, float2(0.0, 0.0));
                tmp0.y = tmp0.y - tmp0.z;
                tmp0.y = saturate(tmp0.y / _DepthBlend);
                tmp1.xyz = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.z = tmp0.z / _NearClip;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = tmp0.x * inp.color.w;
                tmp0.z = tmp0.y * _TintColor.w;
                tmp0.y = tmp0.y * _TintColor.w + -1.0;
                tmp0.y = _AlphaFuzzy * tmp0.y + 1.0;
                o.sv_target.w = tmp0.y * _Opacity;
                tmp0.y = tmp0.z / _AlphaClip;
                tmp0.y = tmp0.y - 0.5;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp1.zw = float2(-1.0, 0.6666667);
                tmp2.zw = float2(1.0, -1.0);
                tmp0.yzw = inp.color.xyz * _TintColor.xyz;
                tmp0.yzw = tmp0.yzw + tmp0.yzw;
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.yzw = tmp0.yzw * tmp3.xyz + _EmissiveColor.xyz;
                tmp3.x = tmp0.z >= tmp0.w;
                tmp3.x = tmp3.x ? 1.0 : 0.0;
                tmp1.xy = tmp0.wz;
                tmp2.xy = tmp0.zw - tmp1.xy;
                tmp1 = tmp3.xxxx * tmp2.xywz + tmp1.xywz;
                tmp2.z = tmp1.w;
                tmp3.x = tmp0.y >= tmp1.x;
                tmp3.x = tmp3.x ? 1.0 : 0.0;
                tmp1.w = tmp0.y;
                tmp2.xyw = tmp1.wyx;
                tmp2 = tmp2 - tmp1;
                tmp1 = tmp3.xxxx * tmp2 + tmp1;
                tmp2.x = min(tmp1.y, tmp1.w);
                tmp2.x = tmp1.x - tmp2.x;
                tmp2.y = tmp2.x * 6.0 + 0.0;
                tmp1.y = tmp1.w - tmp1.y;
                tmp1.y = tmp1.y / tmp2.y;
                tmp1.y = tmp1.y + tmp1.z;
                tmp1.xz = tmp1.xx + float2(0.0, -0.3);
                tmp2.yzw = abs(tmp1.yyy) + float3(0.0, -0.3333333, 0.3333333);
                tmp2.yzw = frac(tmp2.yzw);
                tmp2.yzw = -tmp2.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.yzw = saturate(abs(tmp2.yzw) * float3(3.0, 3.0, 3.0) + float3(-1.0, -1.0, -1.0));
                tmp2.yzw = tmp2.yzw - float3(1.0, 1.0, 1.0);
                tmp1.x = tmp2.x / tmp1.x;
                tmp1.x = tmp1.x + 0.15;
                tmp1.xyw = tmp1.xxx * tmp2.yzw + float3(1.0, 1.0, 1.0);
                tmp0.yzw = -tmp1.xyw * tmp1.zzz + tmp0.yzw;
                tmp1.xyz = tmp1.zzz * tmp1.xyw;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw + tmp1.xyz;
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/FX/Tornado Low"
	CustomEditor "ShaderForgeMaterialInspector"
}