Shader "SR/FX/TanglePollen" {
	Properties {
		_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
		_Texture ("Texture", 2D) = "white" {}
		_Drift ("Drift", Float) = 0
		_VertexNoise ("Vertex Noise", 2D) = "white" {}
		_VertexOffset ("Vertex Offset", Float) = 0.1
		_DepthBlend ("Depth Blend", Range(0, 2)) = 1
		_ColorCenter ("Color Center", Color) = (0.5,0.5,0.5,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 12305
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
			float4 _VertexNoise_ST;
			float _VertexOffset;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _TintColor;
			float4 _Texture_ST;
			float _Drift;
			float _DepthBlend;
			float4 _ColorCenter;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _VertexNoise;
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m21_m11_m21_m01;
                tmp0 = unity_ObjectToWorld._m20_m10_m20_m00 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m22_m12_m22_m02 * v.vertex.zzzz + tmp0;
                tmp0 = unity_ObjectToWorld._m23_m13_m23_m03 * v.vertex.wwww + tmp0;
                tmp1 = tmp0 * _VertexNoise_ST + _VertexNoise_ST;
                tmp0.xy = tmp0.yw * _VertexNoise_ST.xy + _VertexNoise_ST.zw;
                tmp0 = tex2Dlod(_VertexNoise, float4(tmp0.xy, 0, 0.0));
                tmp2 = tex2Dlod(_VertexNoise, float4(tmp1.zw, 0, 0.0));
                tmp1 = tex2Dlod(_VertexNoise, float4(tmp1.xy, 0, 0.0));
                tmp0.y = tmp2.x * v.normal.y;
                tmp0.y = v.normal.x * tmp1.x + tmp0.y;
                tmp0.x = v.normal.z * tmp0.x + tmp0.y;
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * _VertexOffset.xxx + v.vertex.xyz;
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
			fout frag(v2f inp)
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
                tmp0.y = _TimeEditor.y + _Time.y;
                tmp0.z = tmp0.y * _Drift;
                tmp0.z = tmp0.z * 0.5;
                tmp0.z = sin(tmp0.z);
                tmp1.xy = tmp0.zz + inp.texcoord.xz;
                tmp0.zw = tmp1.yx * _Texture_ST.xy + _Texture_ST.zw;
                tmp2 = tex2D(_Texture, tmp0.zw);
                tmp1.z = tmp0.y * _Drift + inp.texcoord.y;
                tmp0.y = sin(tmp0.y);
                tmp0.y = tmp0.y * 0.5 + 1.5;
                tmp1 = tmp1.xzzy * _Texture_ST + _Texture_ST;
                tmp3 = tex2D(_Texture, tmp1.zw);
                tmp1 = tex2D(_Texture, tmp1.xy);
                tmp0.z = tmp3.w - tmp1.w;
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp2.xyz = tmp1.xyz * tmp1.xyz;
                tmp0.z = tmp2.x * tmp0.z + tmp1.w;
                tmp0.w = tmp2.w - tmp0.z;
                tmp0.z = tmp2.y * tmp0.w + tmp0.z;
                tmp0.w = tmp1.w - tmp0.z;
                tmp0.z = tmp2.z * tmp0.w + tmp0.z;
                tmp0.z = tmp0.z * inp.color.w;
                tmp0.z = tmp0.z * _TintColor.w;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.x = saturate(tmp0.w * -1.49925 + 1.0);
                tmp0.z = tmp0.z * tmp1.x;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.z = 1.0 - tmp0.w;
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 1.5;
                tmp0.w = exp(tmp0.w);
                tmp0.z = tmp0.z * tmp0.x;
                tmp1.x = tmp0.z * 3.003003 + -0.5;
                o.sv_target.w = tmp0.z;
                tmp0.z = tmp1.x < 0.0;
                if (tmp0.z) {
                    discard;
                }
                tmp1.xyz = _TintColor.xyz - _ColorCenter.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz + _ColorCenter.xyz;
                tmp0.xzw = tmp0.xxx * tmp1.xyz;
                tmp0.xzw = tmp0.xzw * inp.color.xyz;
                o.sv_target.xyz = tmp0.yyy * tmp0.xzw;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}