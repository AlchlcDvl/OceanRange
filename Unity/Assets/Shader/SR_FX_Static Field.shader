Shader "SR/FX/Static Field" {
	Properties {
		_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("MainTex", 2D) = "black" {}
		_Alpha ("Alpha", Range(0, 1)) = 1
		_ColorCore ("Color Core", Color) = (0.5,0.5,0.5,1)
		_SpeedY ("Speed Y", Float) = 0
		_DepthBlend ("Depth Blend", Float) = 2
	}
	SubShader {
		LOD 550
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			Cull Off
			GpuProgramID 25657
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
				float4 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _Alpha;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TintColor;
			float4 _MainTex_ST;
			float4 _ColorCore;
			float _SpeedY;
			float _DepthBlend;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.color.z * _Alpha + -1.0;
                tmp0.xyz = tmp0.xxx * v.normal.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                o.texcoord1.xyz = tmp0.zzz * tmp2.xyz;
                o.color = v.color;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord2.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord2.w = tmp0.w;
                o.texcoord2.xy = tmp1.zz + tmp1.xw;
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
                tmp0.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp0 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - _ProjectionParams.y;
                tmp0.y = inp.texcoord2.z - _ProjectionParams.y;
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = saturate(tmp0.x / _DepthBlend);
                tmp1.x = -_Time.y * _SpeedY + inp.texcoord.y;
                tmp1.yz = inp.texcoord.zx;
                tmp1 = tmp1.yxzx * _MainTex_ST + _MainTex_ST;
                tmp2 = tex2D(_MainTex, tmp1.xy);
                tmp1 = tex2D(_MainTex, tmp1.zw);
                tmp0.yz = inp.texcoord.zx * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp0.yz);
                tmp0.y = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * inp.texcoord1.xyz;
                tmp1.y = facing.x ? 1.0 : -1.0;
                tmp0.yzw = tmp0.yzw * tmp1.yyy;
                tmp1.y = tmp3.x * abs(tmp0.z);
                tmp1.y = abs(tmp0.y) * tmp2.x + tmp1.y;
                tmp1.x = abs(tmp0.w) * tmp1.x + tmp1.y;
                tmp1.x = tmp1.x * inp.color.w;
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.x = tmp0.x * _Alpha;
                tmp0.x = -tmp0.x * 0.5 + 1.0;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.y = -tmp0.y * tmp0.z + 1.0;
                tmp0.z = saturate(tmp0.z * -2.0 + 2.0);
                tmp0.x = saturate(-tmp0.y * tmp0.x + 1.0);
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.x = saturate(tmp0.x * 20.0 + -9.999998);
                tmp0.y = tmp0.x * 2.0 + -1.0;
                tmp0.y = max(tmp0.y, 0.0);
                tmp1.xyz = _ColorCore.xyz - _TintColor.xyz;
                tmp0.yzw = tmp0.yyy * tmp1.xyz + _TintColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.w = inp.color.z * _Alpha;
                tmp0.w = saturate(tmp0.w * 3.333333 + -0.6666667);
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/FX/Static Field Low"
	CustomEditor "ShaderForgeMaterialInspector"
}