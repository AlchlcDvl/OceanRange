Shader "SR/Slime/Body Tarr" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.1882353,0.1529412,0.1568628,1)
		_MiddleColor ("Middle Color", Color) = (0.2904635,0.2459991,0.3676471,1)
		_TopColor ("Top Color", Color) = (0.4313726,0.3960784,0.4313726,1)
		_Normal ("Normal", 2D) = "bump" {}
		_Depth ("Depth", 2D) = "white" {}
		_Stripes ("Stripes", 2D) = "white" {}
		[MaterialToggle] _StripesInvert ("Stripes Invert", Float) = 0
		_ColorRamp ("Color-Ramp", 2D) = "white" {}
		_Noise ("Noise", Cube) = "_Skybox" {}
		_HitFlash ("Hit Flash", Range(0, 1)) = 0
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 12761
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
			float4 _TimeEditor;
			float4 _Depth_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float4 _ColorRamp_ST;
			float4 _Stripes_ST;
			float4 _Normal_ST;
			float _StripesInvert;
			float _HitFlash;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Depth;
			// Texture params for Fragment Shader
			sampler2D _Normal;
			samplerCUBE _Noise;
			sampler2D _ColorRamp;
			sampler2D _Stripes;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp2.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp2.xyz = tmp2.xyz * v.tangent.www;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp2 = tmp0.wwww * float4(0.05, -0.125, 0.0, 0.1) + v.texcoord.xyxy;
                tmp0.w = 0.0;
                tmp1.w = 0.0;
                while (true) {
                    tmp3.x = i >= 8;
                    if (tmp3.x) {
                        break;
                    }
                    i = i + 1;
                    tmp3.xy = tmp2.xy * tmp3.xx;
                    tmp3.zw = floor(tmp3.xy);
                    tmp3.xy = frac(tmp3.xy);
                    tmp4.xy = tmp3.xy * tmp3.xy;
                    tmp3.xy = -tmp3.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp3.xy = tmp3.xy * tmp4.xy;
                    tmp3.z = tmp3.w * 57.0 + tmp3.z;
                    tmp4.xyz = tmp3.zzz + float3(1.0, 57.0, 58.0);
                    tmp5.x = sin(tmp3.z);
                    tmp5.yzw = sin(tmp4.xyz);
                    tmp4 = tmp5 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp4 = frac(tmp4);
                    tmp3.zw = tmp4.yw - tmp4.xz;
                    tmp3.xz = tmp3.xx * tmp3.zw + tmp4.xz;
                    tmp3.z = tmp3.z - tmp3.x;
                    tmp3.x = tmp3.y * tmp3.z + tmp3.x;
                    tmp3.y = null.y / 8;
                    tmp0.w = tmp3.x * tmp3.y + tmp0.w;
                }
                tmp0.w = tmp0.w * 0.125;
                tmp1.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.w;
                tmp2.xy = float2(1.0, 1.0) - v.texcoord.yx;
                tmp2.xy = tmp2.xy * v.texcoord.yx;
                tmp1.w = tmp2.x * 5.0;
                tmp2.x = tmp2.y * tmp1.w;
                tmp2.x = saturate(tmp2.x * 5.0);
                tmp0.w = tmp0.w * tmp2.x;
                tmp2.xy = tmp0.ww * float2(0.01, 0.01) + tmp2.zw;
                tmp2.xy = tmp2.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp2 = tex2Dlod(_Depth, float4(tmp2.xy, 0, 0.0));
                tmp2.xyz = tmp2.xxx * v.normal.xyz;
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.05, 0.05, 0.05) + v.vertex.xyz;
                tmp3 = tmp2.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp3 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp2 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp2;
                tmp2 = tmp2 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord3.xyz = tmp1.xyz;
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
                float4 tmp6;
                float4 tmp7;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = _TimeEditor.y + _Time.y;
                tmp3 = tmp1.wwww * float4(0.05, -0.125, 0.0, 0.1) + inp.texcoord.xyxy;
                tmp2.w = 0.0;
                tmp4.x = 0.0;
                while (true) {
                    tmp4.y = i >= 8;
                    if (tmp4.y) {
                        break;
                    }
                    i = i + 1;
                    tmp4.yz = tmp3.xy * tmp4.yy;
                    tmp5.xy = floor(tmp4.yz);
                    tmp4.yz = frac(tmp4.yz);
                    tmp5.zw = tmp4.yz * tmp4.yz;
                    tmp4.yz = -tmp4.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp4.yz = tmp4.yz * tmp5.zw;
                    tmp4.w = tmp5.y * 57.0 + tmp5.x;
                    tmp5.xyz = tmp4.www + float3(1.0, 57.0, 58.0);
                    tmp6.x = sin(tmp4.w);
                    tmp6.yzw = sin(tmp5.xyz);
                    tmp5 = tmp6 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp5 = frac(tmp5);
                    tmp5.yw = tmp5.yw - tmp5.xz;
                    tmp4.yw = tmp4.yy * tmp5.yw + tmp5.xz;
                    tmp4.w = tmp4.w - tmp4.y;
                    tmp4.y = tmp4.z * tmp4.w + tmp4.y;
                    tmp4.z = null.z / 8;
                    tmp2.w = tmp4.y * tmp4.z + tmp2.w;
                }
                tmp2.w = tmp2.w * 0.125;
                tmp3.x = tmp2.w * tmp2.w;
                tmp2.w = tmp2.w * tmp3.x;
                tmp3.xy = float2(1.0, 1.0) - inp.texcoord.yx;
                tmp3.xy = tmp3.xy * inp.texcoord.yx;
                tmp4.xy = tmp3.xx * float2(5.0, 4.0);
                tmp3.x = tmp3.y * tmp4.x;
                tmp3.x = saturate(tmp3.x * 5.0);
                tmp2.w = tmp2.w * tmp3.x;
                tmp3.xy = tmp2.ww * float2(0.01, 0.01) + tmp3.zw;
                tmp3.xy = tmp3.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp3 = tex2D(_Normal, tmp3.xy);
                tmp3.x = tmp3.w * tmp3.x;
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp3.z = dot(tmp3.xy, tmp3.xy);
                tmp3.z = min(tmp3.z, 1.0);
                tmp3.z = 1.0 - tmp3.z;
                tmp3.z = sqrt(tmp3.z);
                tmp4.xzw = tmp3.yyy * inp.texcoord4.xyz;
                tmp3.xyw = tmp3.xxx * inp.texcoord3.xyz + tmp4.xzw;
                tmp0.xyz = tmp3.zzz * tmp0.xyz + tmp3.xyw;
                tmp3.x = dot(tmp0.xyz, tmp0.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp0.xyz = tmp0.xyz * tmp3.xxx;
                tmp3.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp3.xyz = tmp3.xxx * _WorldSpaceLightPos0.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp2.xy = float2(1.0, 1.5) - tmp0.ww;
                tmp4.xzw = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp4.xzw = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp4.xzw;
                tmp4.xzw = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp4.xzw;
                tmp5 = texCUBElod(_Noise, float4(tmp4.xzw, 2.0));
                tmp5.x = tmp1.w * 0.333 + tmp5.x;
                tmp5.y = 0.0;
                tmp4.xz = tmp2.xx + tmp5.xy;
                tmp4.xz = tmp4.xz * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp5 = tex2D(_ColorRamp, tmp4.xz);
                tmp0.w = dot(tmp5.xyz, float3(0.3, 0.59, 0.11));
                tmp4.xzw = tmp0.www - tmp5.xyz;
                tmp6.xyz = tmp4.xzw * float3(0.5, 0.5, 0.5) + tmp5.xyz;
                tmp7.xyz = _MiddleColor.xyz - tmp6.xyz;
                tmp6.xyz = tmp7.xyz * float3(0.75, 0.75, 0.75) + tmp6.xyz;
                tmp0.w = dot(tmp1.xyz, tmp0.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.xyz = tmp0.www * _LightColor0.xyz;
                tmp1.xyz = tmp6.xyz * tmp1.xyz;
                tmp0.x = dot(tmp0.xyz, tmp3.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.z = saturate(tmp0.y + tmp0.y);
                tmp0.y = saturate(tmp0.y * 0.5 + 0.5);
                tmp0.w = tmp2.x * tmp2.x;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.y = tmp0.w + tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = saturate(tmp2.y * tmp0.y);
                tmp6.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp6.xyz = tmp0.yyy * tmp6.xyz + _BottomColor.xyz;
                tmp7.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp7.xyz = tmp0.yyy * tmp7.xyz + _MiddleColor.xyz;
                tmp0.y = tmp0.y * 2.0 + -1.0;
                tmp0.y = max(tmp0.y, 0.0);
                tmp7.xyz = tmp7.xyz - tmp6.xyz;
                tmp0.yzw = tmp0.yyy * tmp7.xyz + tmp6.xyz;
                tmp6.xyz = tmp0.yzw * float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp0.xxx * _LightColor0.xyz + tmp3.xyz;
                tmp2.yz = tmp1.ww * float2(0.0, 0.05) + inp.texcoord.xy;
                tmp2.yz = tmp2.ww * float2(0.1, 0.1) + tmp2.yz;
                tmp2.yz = tmp2.yz * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp7 = tex2D(_Stripes, tmp2.yz);
                tmp2.yzw = tmp7.xyz * float3(-2.0, -2.0, -2.0) + float3(1.0, 1.0, 1.0);
                tmp2.yzw = _StripesInvert.xxx * tmp2.yzw + tmp7.xyz;
                tmp4.xzw = tmp4.xzw * float3(0.25, 0.25, 0.25) + tmp5.xyz;
                tmp5.xy = tmp2.xx * float2(-1.5, -2.0) + float2(1.0, 1.0);
                tmp5.x = saturate(tmp5.x);
                tmp4.xzw = tmp4.xzw * tmp5.xxx;
                tmp0.x = tmp4.y * tmp4.y;
                tmp4.xyz = tmp0.xxx * tmp4.xzw;
                tmp5.xyz = tmp2.yzw * tmp5.yyy + float3(0.05, 0.05, 0.05);
                tmp4.xyz = saturate(tmp4.xyz * tmp5.xyz);
                tmp0.xyz = tmp0.yzw * float3(0.5, 0.5, 0.5) + tmp4.xyz;
                tmp0.w = tmp2.y * _HitFlash;
                tmp0.w = tmp0.w * 1.5;
                tmp0.w = _HitFlash * 9.999998 + tmp0.w;
                tmp0.w = tmp0.w - 8.999998;
                tmp0.w = tmp2.x * -4.0 + tmp0.w;
                tmp0.w = saturate(tmp0.w + 2.0);
                tmp2.yz = tmp0.ww * _HitFlash.xx;
                tmp2.x = _HitFlash;
                tmp0.xyz = tmp2.xyz * float3(2.0, 0.6764706, 1.251521) + tmp0.xyz;
                tmp1.xyz = tmp3.xyz * tmp6.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 123768
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			float4 _Depth_ST;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Depth;
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp0 = tmp0.xxxx * float4(0.05, -0.125, 0.0, 0.1) + v.texcoord.xyxy;
                tmp1.xy = float2(0.0, 0.0);
                while (true) {
                    tmp1.z = i >= 8;
                    if (tmp1.z) {
                        break;
                    }
                    i = i + 1;
                    tmp1.zw = tmp0.xy * tmp1.zz;
                    tmp2.xy = floor(tmp1.zw);
                    tmp1.zw = frac(tmp1.zw);
                    tmp2.zw = tmp1.zw * tmp1.zw;
                    tmp1.zw = -tmp1.zw * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp1.zw = tmp1.zw * tmp2.zw;
                    tmp2.x = tmp2.y * 57.0 + tmp2.x;
                    tmp2.yzw = tmp2.xxx + float3(1.0, 57.0, 58.0);
                    tmp3 = sin(tmp2);
                    tmp2 = tmp3 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp2 = frac(tmp2);
                    tmp2.yw = tmp2.yw - tmp2.xz;
                    tmp2.xy = tmp1.zz * tmp2.yw + tmp2.xz;
                    tmp1.z = tmp2.y - tmp2.x;
                    tmp1.z = tmp1.w * tmp1.z + tmp2.x;
                    tmp1.w = null.w / 8;
                    tmp1.x = tmp1.z * tmp1.w + tmp1.x;
                }
                tmp0.x = tmp1.x * 0.125;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp1.xy = float2(1.0, 1.0) - v.texcoord.yx;
                tmp1.xy = tmp1.xy * v.texcoord.yx;
                tmp0.y = tmp1.x * 5.0;
                tmp1.x = tmp1.y * tmp0.y;
                tmp1.x = saturate(tmp1.x * 5.0);
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.xz = tmp0.xx * float2(0.01, 0.01) + tmp0.zw;
                tmp0.xz = tmp0.xz * _Depth_ST.xy + _Depth_ST.zw;
                tmp1 = tex2Dlod(_Depth, float4(tmp0.xz, 0, 0.0));
                tmp0.xzw = tmp1.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.yyy * tmp0.xzw;
                tmp0.xyz = tmp0.xyz * float3(0.05, 0.05, 0.05) + v.vertex.xyz;
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
                tmp1.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp1.x + tmp0.z;
                o.position.xyw = tmp0.xyw;
                o.texcoord1.xy = v.texcoord.xy;
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