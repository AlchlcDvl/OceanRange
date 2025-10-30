Shader "SR/AMP/FX/RadAura" {
	Properties {
		_MiddleColor ("Middle Color", Color) = (0,0.5019608,0.06666667,1)
		_EdgeColor ("Edge Color", Color) = (0,0.5019608,0.06666667,1)
		_Cutoff ("Mask Clip Value", Float) = 0.5
		[NoScaleOffset] _Texture ("Texture", 2D) = "black" {}
		[NoScaleOffset] _Refraction ("Refraction", 2D) = "black" {}
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Overlay+0" "RenderType" = "Overlay" }
		GrabPass {
			"_RefractionOverlay"
		}
		Pass {
			Name "FORWARD"
			Tags { "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay+0" "RenderType" = "Overlay" }
			Cull Off
			GpuProgramID 56528
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MiddleColor;
			float4 _EdgeColor;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Refraction;
			// Texture params for Fragment Shader
			sampler2D _RefractionOverlay;
			sampler2D _CameraDepthTexture;
			sampler2D _Texture;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m01_m11;
                tmp0 = unity_ObjectToWorld._m00_m10_m00_m10 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m02_m12 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m03_m13_m03_m13 * v.vertex.wwww + tmp0;
                tmp0 = tmp0 * float4(0.1, 0.1, 0.1, 0.1);
                tmp0 = _Time * float4(0.1, -0.25, -0.1, -0.1) + tmp0;
                tmp1 = tex2Dlod(_Refraction, float4(tmp0.xy, 0, 0.0));
                tmp0 = tex2Dlod(_Refraction, float4(tmp0.zw, 0, 0.0));
                tmp0.x = tmp0.x * tmp1.x;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp0.yzw * tmp0.xxx;
                o.texcoord1.xyz = tmp0.yzw;
                tmp0.xyz = tmp1.xyz * float3(0.2, 0.2, 0.2) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp1.x = tmp0.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp0.xw * float2(0.5, 0.5);
                tmp0.xy = tmp1.zz + tmp1.xw;
                o.texcoord3 = tmp0;
                o.texcoord4 = tmp0;
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
                tmp0.xyz = inp.texcoord2.xyz - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 0.25;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = facing.x ? tmp0.x : 1.0;
                tmp0.y = tmp0.x - _Cutoff;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.yzw = inp.texcoord4.zxy / inp.texcoord4.www;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.zw);
                tmp0.y = _ZBufferParams.z * tmp0.y + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.y = tmp0.z - tmp0.y;
                tmp0.y = tmp0.y + tmp0.y;
                tmp0.y = min(abs(tmp0.y), 1.0);
                tmp0.z = tmp0.y * 4.0;
                tmp0.y = tmp0.y - 1.0;
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.w = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.w = tmp0.y * 2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.w;
                tmp0.z = tmp0.z * tmp0.y;
                tmp0.z = tmp0.z * 0.05;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(inp.texcoord1.xyz, tmp1.xyz);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.x = tmp0.w * tmp0.w;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp0.w * tmp1.x;
                tmp0.y = tmp1.x * 5.0 + tmp0.y;
                tmp0.y = facing.x ? tmp0.y : tmp0.z;
                tmp1.x = 1.0 - tmp0.y;
                tmp1.y = rsqrt(tmp0.w);
                tmp2.x = 1.0 / tmp1.y;
                tmp2.y = inp.texcoord2.y * 0.15;
                tmp1.yz = _Time.yy * float2(-0.25, -0.125) + tmp2.xy;
                tmp3 = tex2D(_Texture, tmp1.yz);
                tmp1.yz = tmp3.xx * float2(0.8, 0.8) + float2(0.1, -0.4);
                tmp1.z = -tmp1.z * 2.0 + 1.0;
                tmp1.x = -tmp1.z * tmp1.x + 1.0;
                tmp0.y = dot(tmp0.xy, tmp1.xy);
                tmp1.y = tmp1.y > 0.5;
                tmp0.y = saturate(tmp1.y ? tmp1.x : tmp0.y);
                tmp1.x = tmp0.y - 0.8;
                tmp1.x = tmp1.x * 5.0;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.y = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.x = min(tmp1.x, 1.0);
                tmp0.y = tmp0.y * 0.125 + tmp1.x;
                tmp1.x = log(tmp0.w);
                tmp1.x = tmp1.x * 0.75;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.x * -0.3333333 + 0.1;
                tmp1.x = max(tmp1.x, 0.0);
                tmp3 = inp.texcoord2.xyxy * float4(0.1, 0.1, 0.1, 0.1);
                tmp3 = _Time * float4(0.1, -0.25, -0.1, -0.1) + tmp3;
                tmp4 = tex2D(_Refraction, tmp3.xy);
                tmp3 = tex2D(_Refraction, tmp3.zw);
                tmp1.y = tmp3.x * tmp4.x;
                tmp1.x = tmp1.y * tmp1.x;
                tmp0.y = saturate(tmp0.w * tmp0.y + tmp1.x);
                tmp0.y = facing.x ? tmp0.y : tmp0.z;
                tmp1.xyz = _EdgeColor.xyz - _MiddleColor.xyz;
                tmp1.xyz = tmp2.xxx * tmp1.xyz + _MiddleColor.xyz;
                tmp2.xyz = tmp0.yyy * tmp1.xyz;
                tmp0.y = tmp0.y * 6.666667;
                tmp0.y = min(tmp0.y, 1.0);
                tmp2.xyz = tmp2.xyz * float3(8.5, 8.5, 8.5);
                tmp1.xyz = tmp1.xyz * float3(1.5, 1.5, 1.5) + tmp2.xyz;
                tmp2.xy = _Time.yy * float2(-0.05, -0.175) + inp.texcoord.xy;
                tmp2.zw = tmp2.xy + float2(0.1, 0.1);
                tmp3 = tex2D(_Refraction, tmp2.zy);
                tmp4 = tex2D(_Refraction, tmp2.xw);
                tmp2 = tex2D(_Refraction, tmp2.xy);
                tmp4.y = tmp4.y - tmp2.y;
                tmp4.x = tmp3.y - tmp2.y;
                tmp2.xy = tmp4.xy * float2(0.01, 0.01);
                tmp2.z = 0.0;
                tmp2.xyz = float3(0.0, 0.0, 1.0) - tmp2.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp0.zw = tmp0.zz * tmp2.xy;
                tmp1.w = inp.texcoord3.w + 0.0;
                tmp2.x = tmp1.w * 0.5;
                tmp2.y = -tmp1.w * 0.5 + inp.texcoord3.y;
                tmp2.y = -tmp2.y * _ProjectionParams.x + tmp2.x;
                tmp2.x = inp.texcoord3.x;
                tmp2.xy = tmp2.xy / tmp1.ww;
                tmp0.zw = tmp0.xx * tmp0.zw + tmp2.xy;
                tmp2 = tex2D(_RefractionOverlay, tmp0.zw);
                tmp1.xyz = tmp1.xyz - tmp2.xyz;
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.x = tmp0.x * tmp0.y;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz + tmp2.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}