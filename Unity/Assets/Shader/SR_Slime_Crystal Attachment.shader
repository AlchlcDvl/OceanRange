Shader "SR/Slime/Crystal Attachment" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		_Diffuse ("Diffuse", 2D) = "white" {}
		_Normal ("Normal", 2D) = "bump" {}
		_SaturationMask ("Saturation Mask", 2D) = "white" {}
		_SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_ColorRamp ("Color-Ramp", 2D) = "gray" {}
		_OutlineRamp ("Outline-Ramp", 2D) = "gray" {}
		_TipBrightness ("Tip Brightness", Float) = 1
		_Caustics ("Caustics", 2D) = "black" {}
		_CuasticSpeed ("Cuastic Speed", Float) = 0.25
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" }
		Pass {
			Name "Outline"
			Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Cull Front
			GpuProgramID 19665
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
			float4 _TimeEditor;
			float4 _SaturationMask_ST;
			float _TipBrightness;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _OutlineRamp_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _SaturationMask;
			// Texture params for Fragment Shader
			sampler2D _OutlineRamp;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp1.x = tmp0.y + tmp0.x;
                tmp1.x = tmp0.z + tmp1.x;
                tmp1.y = _TimeEditor.w + _Time.w;
                tmp1.x = tmp1.x * 1.5 + tmp1.y;
                tmp1.x = tmp0.y * -5.0 + tmp1.x;
                o.texcoord1 = tmp0;
                tmp0.x = sin(tmp1.x);
                tmp0.x = tmp0.x * 0.25 + 0.75;
                tmp0.yz = v.texcoord.xy * _SaturationMask_ST.xy + _SaturationMask_ST.zw;
                tmp1 = tex2Dlod(_SaturationMask, float4(tmp0.yz, 0, 0.0));
                tmp0.y = tmp1.x * _TipBrightness;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * 0.02;
                tmp0.xyz = v.normal.xyz * tmp0.xxx + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = inp.texcoord1.y + inp.texcoord1.x;
                tmp0.x = tmp0.x + inp.texcoord1.z;
                tmp0.y = _TimeEditor.w + _Time.w;
                tmp0.x = tmp0.x * 1.5 + tmp0.y;
                tmp0.x = inp.texcoord1.y * -5.0 + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 0.25 + 0.75;
                tmp0.yz = inp.texcoord.xy * _SaturationMask_ST.xy + _SaturationMask_ST.zw;
                tmp1 = tex2D(_SaturationMask, tmp0.yz);
                tmp0.y = tmp1.x * _TipBrightness;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * _OutlineRamp_ST.x;
                tmp0.x = tmp0.x * 2.0;
                tmp0.y = 0.0;
                tmp0.xy = tmp0.xy + _OutlineRamp_ST.zw;
                tmp0 = tex2D(_OutlineRamp, tmp0.xy);
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 104928
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _TimeEditor;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float4 _Diffuse_ST;
			float4 _Normal_ST;
			float4 _SaturationMask_ST;
			float4 _SpecularColor;
			float4 _ColorRamp_ST;
			float4 _OutlineRamp_ST;
			float _TipBrightness;
			float4 _Caustics_ST;
			float _CuasticSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _Diffuse;
			sampler2D _Caustics;
			sampler2D _ColorRamp;
			sampler2D _SaturationMask;
			sampler2D _OutlineRamp;
			
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
                tmp0.yz = inp.texcoord1.zx;
                tmp1.xy = _TimeEditor.yw + _Time.yw;
                tmp0.x = tmp1.x * _CuasticSpeed + inp.texcoord1.y;
                tmp0 = tmp0.xyxz * _Caustics_ST + _Caustics_ST;
                tmp2 = tex2D(_Caustics, tmp0.xy);
                tmp0 = tex2D(_Caustics, tmp0.zw);
                tmp0.yz = inp.texcoord1.xz * _Caustics_ST.xy + _Caustics_ST.zw;
                tmp3 = tex2D(_Caustics, tmp0.yz);
                tmp0.y = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * inp.texcoord2.xyz;
                tmp1.x = tmp3.x * abs(tmp0.z);
                tmp1.x = abs(tmp0.y) * tmp2.x + tmp1.x;
                tmp0.x = abs(tmp0.w) * tmp0.x + tmp1.x;
                tmp1.xz = inp.texcoord.xy * _Diffuse_ST.xy + _Diffuse_ST.zw;
                tmp2 = tex2D(_Diffuse, tmp1.xz);
                tmp0.x = tmp0.x + tmp2.x;
                tmp1.xz = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp3 = tex2D(_Normal, tmp1.xz);
                tmp3.x = tmp3.w * tmp3.x;
                tmp1.xz = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.xyz = tmp1.zzz * inp.texcoord4.xyz;
                tmp3.xyz = tmp1.xxx * inp.texcoord3.xyz + tmp3.xyz;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = min(tmp1.x, 1.0);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = sqrt(tmp1.x);
                tmp1.xzw = tmp1.xxx * tmp0.yzw + tmp3.xyz;
                tmp2.w = dot(tmp1.xyz, tmp1.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp1.xzw = tmp1.xzw * tmp2.www;
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp2.w = dot(tmp3.xyz, tmp3.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp4.xyz = tmp2.www * tmp3.xyz;
                tmp3.w = dot(tmp1.xyz, tmp4.xyz);
                tmp3.w = max(tmp3.w, 0.0);
                tmp3.w = 1.0 - tmp3.w;
                tmp4.w = log(tmp3.w);
                tmp5.x = tmp0.x * tmp4.w;
                tmp5.yz = tmp4.ww * float2(1.25, 0.2);
                tmp5.yz = exp(tmp5.yz);
                tmp4.w = exp(tmp5.x);
                tmp4.w = 1.0 - tmp4.w;
                tmp4.w = log(tmp4.w);
                tmp4.w = tmp4.w * 13.92881;
                tmp4.w = exp(tmp4.w);
                tmp5.x = dot(-tmp4.xyz, tmp1.xyz);
                tmp5.x = tmp5.x + tmp5.x;
                tmp6.xyz = tmp1.xzw * -tmp5.xxx + -tmp4.xyz;
                tmp0.y = dot(tmp0.xyz, tmp4.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * tmp0.x;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp0.y * 1.333333;
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.z = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp4.xyz = tmp0.zzz * _WorldSpaceLightPos0.xyz;
                tmp0.z = dot(tmp4.xyz, tmp6.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = log(tmp0.z);
                tmp0.z = tmp0.z * 13.92881;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp4.w + tmp0.z;
                tmp0.z = tmp0.z * 0.4;
                tmp6.xyz = tmp0.zzz * _LightColor0.xyz;
                tmp6.xyz = tmp6.xyz * float3(59.34718, 59.34718, 59.34718) + float3(-0.9792286, -0.9792286, -0.9792286);
                tmp0.zw = tmp0.xx * float2(-2.994012, 0.25) + float2(1.997006, 0.25);
                tmp0.xz = saturate(tmp0.xz);
                tmp0.x = tmp0.y * tmp0.x;
                tmp7.z = tmp0.x * _ColorRamp_ST.x;
                tmp0.x = tmp0.w * tmp0.w;
                tmp0.y = tmp3.w * tmp3.w;
                tmp0.w = rsqrt(tmp3.w);
                tmp0.w = 1.0 / tmp0.w;
                tmp6.xyz = saturate(tmp0.xxx * tmp6.xyz + tmp0.yyy);
                tmp6.xyz = saturate(tmp6.xyz * _SpecularColor.xyz);
                tmp7.yw = float2(0.0, 0.0);
                tmp5.xw = tmp7.zw + _ColorRamp_ST.zw;
                tmp8 = tex2D(_ColorRamp, tmp5.xw);
                tmp6.xyz = saturate(tmp6.xyz + tmp8.xyz);
                tmp0.x = 1.0 - tmp0.z;
                tmp9.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + float3(0.5, 0.5, 0.5);
                tmp10.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp9.xyz = tmp0.xxx * tmp9.xyz + tmp10.xyz;
                tmp8.xyz = saturate(tmp8.xyz * tmp9.xyz);
                tmp8.xyz = tmp8.xyz - tmp6.xyz;
                tmp6.xyz = tmp0.zzz * tmp8.xyz + tmp6.xyz;
                tmp0.x = tmp5.y * tmp0.z;
                tmp0.z = tmp5.z * -1.333333 + 1.333333;
                tmp0.z = min(tmp0.z, 1.0);
                tmp7.x = tmp0.x * _ColorRamp_ST.x;
                tmp5.xy = tmp7.xy + _ColorRamp_ST.zw;
                tmp5 = tex2D(_ColorRamp, tmp5.xy);
                tmp5.xyz = saturate(tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0));
                tmp7.xyz = tmp5.xyz > float3(0.5, 0.5, 0.5);
                tmp8.xyz = tmp5.xyz * float3(2.0, 2.0, 2.0) + tmp0.zzz;
                tmp5.xyz = tmp5.xyz - float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp5.xyz * float3(2.0, 2.0, 2.0) + tmp0.zzz;
                tmp8.xyz = tmp8.xyz - float3(1.0, 1.0, 1.0);
                tmp5.xyz = saturate(tmp7.xyz ? tmp8.xyz : tmp5.xyz);
                tmp6.xyz = -tmp5.xyz * tmp0.zzz + tmp6.xyz;
                tmp5.xyz = tmp0.zzz * tmp5.xyz;
                tmp0.xzw = tmp0.www * tmp6.xyz + tmp5.xyz;
                tmp3.w = min(tmp0.y, 1.0);
                tmp0.y = saturate(tmp0.y * 5.0 + -0.5);
                tmp2.xyz = tmp2.xyz + tmp3.www;
                tmp5.xyz = saturate(tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0));
                tmp6.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp5.xyz = tmp5.xyz * tmp6.xyz + _MiddleColor.xyz;
                tmp6.xyz = tmp2.xyz + tmp2.xyz;
                tmp6.xyz = saturate(tmp6.xyz);
                tmp7.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp6.xyz = tmp6.xyz * tmp7.xyz + _BottomColor.xyz;
                tmp5.xyz = tmp5.xyz - tmp6.xyz;
                tmp2.xyz = tmp2.xyz * tmp5.xyz + tmp6.xyz;
                tmp5.xyz = -tmp2.xyz * float3(0.2, 0.2, 0.2) + tmp0.xzw;
                tmp0.xzw = -tmp2.xyz * float3(0.8, 0.8, 0.8) + tmp0.xzw;
                tmp6.xyz = tmp2.xyz * float3(0.2, 0.2, 0.2);
                tmp2.xyz = tmp2.xyz * float3(0.8, 0.8, 0.8);
                tmp7.xy = inp.texcoord.xy * _SaturationMask_ST.xy + _SaturationMask_ST.zw;
                tmp7 = tex2D(_SaturationMask, tmp7.xy);
                tmp3.w = tmp7.x * _TipBrightness;
                tmp4.w = saturate(tmp3.w * 2.5 + -0.25);
                tmp5.xyz = tmp4.www * tmp5.xyz + tmp6.xyz;
                tmp0.xzw = tmp4.www * tmp0.xzw + tmp2.xyz;
                tmp2.xyz = tmp3.xyz * tmp2.www + tmp4.xyz;
                tmp2.w = dot(tmp1.xyz, tmp4.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp3.xyz = tmp2.www * _LightColor0.xyz + tmp10.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp1.x = dot(tmp2.xyz, tmp1.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = log(tmp1.x);
                tmp1.x = tmp1.x * 32.0;
                tmp1.x = exp(tmp1.x);
                tmp1.xzw = tmp1.xxx * _LightColor0.xyz;
                tmp1.xzw = tmp3.xyz * tmp5.xyz + tmp1.xzw;
                tmp2.x = tmp3.w * _ColorRamp_ST.x;
                tmp2.yw = float2(0.0, 0.0);
                tmp2.xy = tmp2.xy + _ColorRamp_ST.zw;
                tmp4 = tex2D(_ColorRamp, tmp2.xy);
                tmp3.xyz = tmp4.xyz - tmp0.xzw;
                tmp2.x = inp.texcoord1.y + inp.texcoord1.x;
                tmp2.x = tmp2.x + inp.texcoord1.z;
                tmp1.y = tmp2.x * 1.5 + tmp1.y;
                tmp1.y = inp.texcoord1.y * -5.0 + tmp1.y;
                tmp1.y = sin(tmp1.y);
                tmp1.y = tmp1.y * 0.25 + 0.75;
                tmp1.y = tmp1.y * tmp3.w;
                tmp0.xzw = tmp1.yyy * tmp3.xyz + tmp0.xzw;
                tmp2.x = tmp1.y * _OutlineRamp_ST.x;
                tmp0.y = tmp0.y * tmp1.y;
                tmp0.y = saturate(tmp0.y * 5.0 + -0.5);
                tmp2.z = tmp2.x * 2.0;
                tmp2.xy = tmp2.zw + _OutlineRamp_ST.zw;
                tmp2 = tex2D(_OutlineRamp, tmp2.xy);
                tmp2.xyz = tmp2.xyz - tmp0.xzw;
                tmp0.xyz = tmp0.yyy * tmp2.xyz + tmp0.xzw;
                o.sv_target.xyz = tmp0.xyz + tmp1.xzw;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}