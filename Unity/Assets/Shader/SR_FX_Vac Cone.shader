Shader "SR/FX/Vac Cone" {
	Properties {
		_WaveRamp ("Wave Ramp", 2D) = "white" {}
		_WaveStrength ("Wave Strength", Float) = -1
		_WaveSpeed ("Wave Speed", Float) = 1
		_TurbulanceWaves ("Turbulance Waves", 2D) = "white" {}
		_Alpha ("Alpha", Range(0, 1)) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 62874
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			float4 _WaveRamp_ST;
			float _WaveStrength;
			float _WaveSpeed;
			// $Globals ConstantBuffers for Fragment Shader
			float _Alpha;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _WaveRamp;
			// Texture params for Fragment Shader
			sampler2D _TurbulanceWaves;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp0.xy = tmp0.xx * float2(0.0, 0.5) + v.texcoord.xy;
                tmp0.xy = tmp0.xy * _WaveSpeed.xx;
                tmp0.xy = tmp0.xy * _WaveRamp_ST.xy + _WaveRamp_ST.zw;
                tmp0 = tex2Dlod(_WaveRamp, float4(tmp0.xy, 0, 0.0));
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * _WaveStrength.xxx;
                tmp0.w = v.texcoord.y * 0.2 + -0.1;
                tmp1.xyz = tmp0.www * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * v.texcoord.yyy + tmp1.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = inp.texcoord.y - _Alpha;
                tmp0.x = tmp0.x * -6.0;
                tmp0.y = 1.0 - _Alpha;
                tmp0.x = tmp0.x / tmp0.y;
                tmp0.y = tmp0.y == 0.0;
                tmp0.x = saturate(tmp0.x + 1.0);
                tmp0.x = tmp0.y ? 1.0 : tmp0.x;
                tmp0.y = _TimeEditor.y + _Time.y;
                tmp1 = tmp0.yyyy * float4(1.0, 0.5, -1.0, 0.25) + inp.texcoord.xy;
                tmp0.yz = tmp1.zw * float2(0.75, 1.5);
                tmp1 = tex2D(_TurbulanceWaves, tmp1.xy);
                tmp2 = tex2D(_TurbulanceWaves, tmp0.yz);
                tmp0.y = tmp1.x + tmp2.x;
                tmp0.z = 1.0 - inp.texcoord.y;
                tmp0.w = tmp0.z + tmp0.z;
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = saturate(inp.texcoord.y * 15.0);
                tmp0.yw = tmp0.yy * float2(0.75, -0.5) + float2(0.25, 0.5);
                tmp0.x = saturate(tmp0.y * tmp0.x);
                tmp0.y = tmp0.z * tmp0.x + tmp0.w;
                o.sv_target.xyz = tmp0.yyy * float3(0.4926471, 0.2242393, 0.0) + float3(0.5073529, 0.7757607, 1.0);
                tmp0.y = tmp0.x - 0.5;
                o.sv_target.w = tmp0.x;
                tmp0.x = tmp0.y < 0.0;
                if (tmp0.x) {
                    discard;
                }
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}