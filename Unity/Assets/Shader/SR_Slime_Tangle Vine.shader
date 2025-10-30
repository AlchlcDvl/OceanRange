Shader "SR/Slime/Tangle Vine" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.1882353,0.1529412,0.1568628,1)
		_MiddleColor ("Middle Color", Color) = (0.2904635,0.2459991,0.3676471,1)
		_TopColor ("Top Color", Color) = (0.4313726,0.3960784,0.4313726,1)
		_Normal ("Normal", 2D) = "bump" {}
		_Depth ("Depth", 2D) = "white" {}
		_Stripes ("Stripes", 2D) = "white" {}
		_Alpha ("Alpha", Range(0, 1)) = 1
		_EndColor ("End Color", Color) = (0.5,0.5,0.5,1)
		_Mask ("Mask", 2D) = "white" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Cull Off
			GpuProgramID 42289
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
			float4 _Stripes_ST;
			float4 _Normal_ST;
			float4 _Depth_ST;
			float _Alpha;
			float4 _EndColor;
			float4 _Mask_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _Stripes;
			sampler2D _Depth;
			sampler2D _Mask;
			
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
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.x = facing.x ? 1.0 : -1.0;
                tmp0.y = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * inp.texcoord2.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp2 = tex2D(_Normal, tmp2.xy);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = sqrt(tmp0.w);
                tmp2.yzw = tmp2.yyy * inp.texcoord4.xyz;
                tmp2.xyz = tmp2.xxx * inp.texcoord3.xyz + tmp2.yzw;
                tmp0.xyz = tmp0.www * tmp0.xyz + tmp2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = _Alpha * 1.5 + -0.5;
                tmp1.w = _TimeEditor.y + _Time.y;
                tmp2 = tmp1.wwww * float4(0.05, -0.125, 0.0, 0.05) + inp.texcoord.xyxy;
                tmp1.w = 0.0;
                tmp3.x = 0.0;
                while (true) {
                    tmp3.y = i >= 8;
                    if (tmp3.y) {
                        break;
                    }
                    i = i + 1;
                    tmp3.yz = tmp2.xy * tmp3.yy;
                    tmp4.xy = floor(tmp3.yz);
                    tmp3.yz = frac(tmp3.yz);
                    tmp4.zw = tmp3.yz * tmp3.yz;
                    tmp3.yz = -tmp3.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp3.yz = tmp3.yz * tmp4.zw;
                    tmp3.w = tmp4.y * 57.0 + tmp4.x;
                    tmp4.xyz = tmp3.www + float3(1.0, 57.0, 58.0);
                    tmp5.x = sin(tmp3.w);
                    tmp5.yzw = sin(tmp4.xyz);
                    tmp4 = tmp5 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp4 = frac(tmp4);
                    tmp4.yw = tmp4.yw - tmp4.xz;
                    tmp3.yw = tmp3.yy * tmp4.yw + tmp4.xz;
                    tmp3.w = tmp3.w - tmp3.y;
                    tmp3.y = tmp3.z * tmp3.w + tmp3.y;
                    tmp3.z = null.z / 8;
                    tmp1.w = tmp3.y * tmp3.z + tmp1.w;
                }
                tmp1.w = tmp1.w * 0.125;
                tmp2.x = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp2.x;
                tmp2.xy = float2(1.0, 1.0) - inp.texcoord.yx;
                tmp2.xy = tmp2.xy * inp.texcoord.yx;
                tmp2.x = tmp2.x * 5.0;
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.x = saturate(tmp2.x * 5.0);
                tmp1.w = tmp1.w * tmp2.x;
                tmp2.xy = tmp1.ww * float2(0.1, 0.1) + tmp2.zw;
                tmp2.xy = tmp2.xy * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp2 = tex2D(_Stripes, tmp2.xy);
                tmp2.yz = inp.texcoord.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp3 = tex2D(_Depth, tmp2.yz);
                tmp2.yz = tmp3.xx * float2(0.6, 0.6) + float2(0.2, -0.3);
                tmp1.w = tmp2.y > 0.5;
                tmp2.z = -tmp2.z * 2.0 + 1.0;
                tmp2.x = tmp2.x * 0.6 + 0.2;
                tmp2.w = 1.0 - tmp2.x;
                tmp2.z = -tmp2.z * tmp2.w + 1.0;
                tmp2.x = dot(tmp2.xy, tmp2.xy);
                tmp1.w = saturate(tmp1.w ? tmp2.z : tmp2.x);
                tmp2.x = tmp1.w > 0.5;
                tmp2.y = tmp1.w - 0.5;
                tmp2.y = -tmp2.y * 2.0 + 1.0;
                tmp2.z = inp.texcoord.y - tmp0.w;
                tmp2.z = tmp2.z * -6.0;
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = tmp2.z / tmp0.w;
                tmp0.w = tmp0.w + 1.0;
                tmp2.z = 1.0 - tmp0.w;
                tmp2.y = -tmp2.y * tmp2.z + 1.0;
                tmp0.w = dot(tmp0.xy, tmp1.xy);
                tmp0.w = saturate(tmp2.x ? tmp2.y : tmp0.w);
                tmp0.w = tmp0.w - 0.5;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp2.xyz);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.xw = max(tmp0.xw, float2(0.0, 0.0));
                tmp0.xz = float2(1.0, 1.5) - tmp0.xx;
                tmp1.xy = saturate(tmp0.yy * float2(0.25, 0.5) + float2(0.75, 0.5));
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x + tmp1.y;
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.y = tmp3.x * 2.0 + -1.0;
                tmp0.x = saturate(tmp0.y * tmp0.x);
                tmp1.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp1.xyz = tmp0.xxx * tmp1.xyz + _BottomColor.xyz;
                tmp3.yzw = _TopColor.xyz - _MiddleColor.xyz;
                tmp3.yzw = tmp0.xxx * tmp3.yzw + _MiddleColor.xyz;
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp3.yzw = tmp3.yzw - tmp1.xyz;
                tmp0.xyz = tmp0.xxx * tmp3.yzw + tmp1.xyz;
                tmp1.xy = inp.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp1 = tex2D(_Mask, tmp1.xy);
                tmp1.x = tmp3.x * tmp1.x;
                tmp1.yzw = _EndColor.xyz - tmp0.xyz;
                tmp0.xyz = tmp1.xxx * tmp1.yzw + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp0.www * _LightColor0.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp0.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 83328
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _Stripes_ST;
			float4 _Depth_ST;
			float _Alpha;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Stripes;
			sampler2D _Depth;
			
			// Keywords: SHADOWS_DEPTH
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
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord1.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = _Alpha * 1.5 + -0.5;
                tmp0.y = _TimeEditor.y + _Time.y;
                tmp1 = tmp0.yyyy * float4(0.05, -0.125, 0.0, 0.05) + inp.texcoord1.xyxy;
                tmp0.yz = float2(0.0, 0.0);
                while (true) {
                    tmp0.w = i >= 8;
                    if (tmp0.w) {
                        break;
                    }
                    i = i + 1;
                    tmp2.xy = tmp0.ww * tmp1.xy;
                    tmp2.zw = floor(tmp2.xy);
                    tmp2.xy = frac(tmp2.xy);
                    tmp3.xy = tmp2.xy * tmp2.xy;
                    tmp2.xy = -tmp2.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp2.xy = tmp2.xy * tmp3.xy;
                    tmp0.w = tmp2.w * 57.0 + tmp2.z;
                    tmp3.xyz = tmp0.www + float3(1.0, 57.0, 58.0);
                    tmp4.x = sin(tmp0.w);
                    tmp4.yzw = sin(tmp3.xyz);
                    tmp3 = tmp4 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp3 = frac(tmp3);
                    tmp2.zw = tmp3.yw - tmp3.xz;
                    tmp2.xz = tmp2.xx * tmp2.zw + tmp3.xz;
                    tmp0.w = tmp2.z - tmp2.x;
                    tmp0.w = tmp2.y * tmp0.w + tmp2.x;
                    tmp2.x = null.x / 8;
                    tmp0.y = tmp0.w * tmp2.x + tmp0.y;
                }
                tmp0.y = tmp0.y * 0.125;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.zw = float2(1.0, 1.0) - inp.texcoord1.yx;
                tmp0.zw = tmp0.zw * inp.texcoord1.yx;
                tmp0.z = tmp0.z * 5.0;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.z = saturate(tmp0.z * 5.0);
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.yz = tmp0.yy * float2(0.1, 0.1) + tmp1.zw;
                tmp0.yz = tmp0.yz * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp1 = tex2D(_Stripes, tmp0.yz);
                tmp0.yz = inp.texcoord1.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp2 = tex2D(_Depth, tmp0.yz);
                tmp0.yz = tmp2.xx * float2(0.6, 0.6) + float2(0.2, -0.3);
                tmp0.w = tmp0.y > 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp1.x = tmp1.x * 0.6 + 0.2;
                tmp1.y = 1.0 - tmp1.x;
                tmp0.z = -tmp0.z * tmp1.y + 1.0;
                tmp0.y = dot(tmp1.xy, tmp0.xy);
                tmp0.y = saturate(tmp0.w ? tmp0.z : tmp0.y);
                tmp0.z = tmp0.y > 0.5;
                tmp0.w = tmp0.y - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp1.x = inp.texcoord1.y - tmp0.x;
                tmp1.x = tmp1.x * -6.0;
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = tmp1.x / tmp0.x;
                tmp0.x = tmp0.x + 1.0;
                tmp1.x = 1.0 - tmp0.x;
                tmp0.w = -tmp0.w * tmp1.x + 1.0;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = saturate(tmp0.z ? tmp0.w : tmp0.x);
                tmp0.x = tmp0.x - 0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}