Shader "SR/UI/Map Fog" {
	Properties {
		[HideInInspector] _MainTex ("MainTex", 2D) = "white" {}
		_Noise ("Noise", 2D) = "gray" {}
		_StencilComp ("StencilComp", Float) = 8
		_Stencil ("Stencil", Float) = 0
		_StencilOp ("StencilOp", Float) = 0
		_StencilWriteMask ("StencilWriteMask", Float) = 255
		_StencilReadMask ("StencilReadMask", Float) = 255
		_ColorMask ("ColorMask", Float) = 15
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "PreviewType" = "Plane" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			Stencil {
				Ref 1
				Comp LEqual
				Pass Keep
				Fail Keep
				ZFail Keep
			}
			GpuProgramID 12728
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _MainTex_ST;
			float4 _Noise_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _Noise;
			
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
                o.texcoord.xy = v.texcoord.xy;
                o.color = v.color;
                tmp0.y = tmp0.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp0.x + tmp0.y;
                tmp0.x = unity_MatrixV._m22 * tmp0.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp0.w + tmp0.x;
                o.texcoord1.z = -tmp0.x;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord1.w = tmp1.w;
                o.texcoord1.xy = tmp0.zz + tmp0.xw;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _ScreenParams.x / _ScreenParams.y;
                tmp0.yz = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1.yz = tmp0.yz * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.x = tmp0.x * tmp1.y;
                tmp0.xy = tmp1.xz * _Noise_ST.xy + _Noise_ST.zw;
                tmp0.zw = tmp1.yz * tmp1.yz;
                tmp0.z = tmp0.w + tmp0.z;
                tmp1 = tex2D(_Noise, tmp0.xy);
                tmp0.xy = tmp1.xx * float2(0.2, 0.2) + float2(0.4, -0.1);
                tmp0.y = -tmp0.y * 2.0 + 1.0;
                tmp0.w = 1.0 - tmp0.z;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.x = tmp0.x > 0.5;
                tmp0.y = -tmp0.y * tmp0.w + 1.0;
                tmp0.x = saturate(tmp0.x ? tmp0.y : tmp0.z);
                tmp0.xy = tmp0.xx * float2(0.2, 0.2) + float2(-0.1, 0.4);
                tmp0.z = tmp0.y > 0.5;
                tmp0.x = -tmp0.x * 2.0 + 1.0;
                tmp0.y = tmp0.y + tmp0.y;
                tmp1.xy = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp0.w = -tmp1.w * inp.color.w + 1.0;
                tmp0.w = -tmp0.x * tmp0.w + 1.0;
                tmp1.w = tmp1.w * inp.color.w;
                tmp1.w = tmp0.y * tmp1.w;
                tmp0.y = tmp0.y * inp.color.w;
                tmp0.w = saturate(tmp0.z ? tmp0.w : tmp1.w);
                tmp0.w = tmp0.w - 0.5;
                tmp0.w = tmp0.w < 0.0;
                if (tmp0.w) {
                    discard;
                }
                tmp0.w = 1.0 - inp.color.w;
                tmp0.x = -tmp0.x * tmp0.w + 1.0;
                tmp0.x = saturate(tmp0.z ? tmp0.x : tmp0.y);
                tmp0.x = tmp0.x * -2.0 + 1.0;
                tmp0.xy = abs(tmp0.xx) * float2(-20.0, -40.0) + float2(1.0, 1.0);
                tmp0.yzw = tmp0.yyy * float3(0.75, 1.0, 0.9896551);
                tmp0.xyz = saturate(tmp0.xxx * float3(0.0, 1.0, 0.9568628) + tmp0.yzw);
                tmp0.xyz = tmp1.xyz * inp.color.xyz + tmp0.xyz;
                tmp1.xy = saturate(inp.color.ww * float2(-10.0, 20.0) + float2(9.500004, -8.999998));
                tmp0.w = tmp1.y * tmp1.x;
                o.sv_target.xyz = tmp0.www * float3(0.0, 0.1676483, 0.333) + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}