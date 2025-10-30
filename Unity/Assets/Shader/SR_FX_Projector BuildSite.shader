Shader "SR/FX/Projector BuildSite" {
	Properties {
		_TintColor ("Color", Color) = (0.5,0.5,0.5,1)
		_FadePower ("Fade Power", Range(0, 10)) = 1
		_Pattern ("Pattern", 2D) = "black" {}
		_PatternColor ("Pattern Color", Color) = (1,1,1,1)
		_PatternDepth ("Pattern Depth", Float) = 2
		_MainTex ("MainTex", 2D) = "white" {}
		_Noise ("Noise", 2D) = "black" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 550
		Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+100" }
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+100" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZTest Always
			ZWrite Off
			GpuProgramID 24579
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
				float4 color : COLOR0;
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _MainTex_ST;
			float4 _TintColor;
			float _FadePower;
			float4 _Pattern_ST;
			float4 _PatternColor;
			float _PatternDepth;
			float4 _Noise_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _Pattern;
			sampler2D _Noise;
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
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
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                o.texcoord2.xyz = tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp3.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp3.xyz;
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp3.xyz = tmp0.zzz * tmp3.xyz;
                o.texcoord3.xyz = tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx;
                tmp2.xyz = tmp2.yzx * tmp3.zxy + -tmp4.xyz;
                tmp2.xyz = tmp2.xyz * v.tangent.www;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                o.texcoord4.xyz = tmp0.zzz * tmp2.xyz;
                o.color = v.color;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord5.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord5.w = tmp0.w;
                o.texcoord5.xy = tmp1.zz + tmp1.xw;
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
                tmp0.xy = inp.texcoord5.xy / inp.texcoord5.ww;
                tmp0 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - _ProjectionParams.y;
                tmp0.y = inp.texcoord5.z - _ProjectionParams.y;
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.z = tmp0.y - tmp0.x;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.y = 1.0 - tmp0.z;
                tmp0.z = 1.0 - tmp0.x;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = tmp0.y * _FadePower;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.xzw = -tmp1.xyz * tmp0.xxx + inp.texcoord1.xyz;
                tmp0.xzw = tmp0.xzw - unity_ObjectToWorld._m03_m13_m23;
                tmp2.xy = tmp0.zz * unity_WorldToObject._m01_m11;
                tmp0.xz = unity_WorldToObject._m00_m10 * tmp0.xx + tmp2.xy;
                tmp0.xz = unity_WorldToObject._m02_m12 * tmp0.ww + tmp0.xz;
                tmp2.xy = abs(tmp0.xz) <= float2(0.5, 0.5);
                tmp0.xz = tmp0.xz + float2(0.5, 0.5);
                tmp2.xy = tmp2.xy ? 1.0 : 0.0;
                tmp0.w = tmp2.y * tmp2.x;
                tmp0.y = saturate(tmp0.y * tmp0.w);
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp0.w = tmp0.w * 1.5;
                tmp0.w = frac(tmp0.w);
                tmp0.w = tmp0.w * 4.0;
                tmp0.w = floor(tmp0.w);
                tmp1.w = tmp0.w * 0.5;
                tmp2.y = floor(tmp1.w);
                tmp2.x = -tmp2.y * 2.0 + tmp0.w;
                tmp2.xy = tmp2.xy + inp.texcoord.xy;
                tmp2.xy = tmp2.xy * _Noise_ST.xy;
                tmp2.xy = tmp2.xy * float2(0.5, 0.5) + _Noise_ST.zw;
                tmp2 = tex2D(_Noise, tmp2.xy);
                tmp0.xz = tmp2.xy * float2(0.01, 0.01) + tmp0.xz;
                tmp0.xz = tmp0.xz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp0.xz);
                tmp0.x = tmp2.w * inp.color.w;
                tmp0.x = tmp0.x * _TintColor.w;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = dot(inp.texcoord2.xyz, tmp1.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.w = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp0.y;
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.y = tmp0.y * -3.333333 + 1.0;
                o.sv_target.w = tmp0.y * tmp0.x;
                tmp0.x = tmp0.z * -0.2 + 0.5;
                tmp0.yz = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y * -2.0 + 1.0;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = _PatternDepth - tmp0.y;
                tmp0.y = tmp0.y * 0.05;
                tmp3.x = dot(inp.texcoord3.xyz, tmp1.xyz);
                tmp3.y = dot(inp.texcoord4.xyz, tmp1.xyz);
                tmp0.yz = tmp0.yy * tmp3.xy + inp.texcoord.xy;
                tmp0.yz = tmp0.yz * _Pattern_ST.xy + _Pattern_ST.zw;
                tmp1 = tex2D(_Pattern, tmp0.yz);
                tmp0.yzw = tmp1.xyz * _PatternColor.xyz;
                tmp0.yzw = tmp0.yzw * _PatternColor.www + tmp2.xyz;
                tmp1.xyz = tmp0.yzw > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp0.yzw - float3(0.5, 0.5, 0.5);
                tmp0.yzw = tmp0.yzw * tmp0.xxx;
                tmp0.x = 1.0 - tmp0.x;
                tmp0.yzw = tmp0.yzw + tmp0.yzw;
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp2.xyz * tmp0.xxx + float3(1.0, 1.0, 1.0);
                tmp0.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp0.yzw);
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                o.sv_target.xyz = tmp0.xyz * _TintColor.xyz;
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/FX/Projector BuildSite NoDepth"
	CustomEditor "ShaderForgeMaterialInspector"
}