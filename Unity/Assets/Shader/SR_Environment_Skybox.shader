Shader "SR/Environment/Skybox" {
	Properties {
		_SkyColor ("Sky Color", Color) = (0.02553246,0.03709318,0.1827586,1)
		_HorizonColor ("Horizon Color", Color) = (0.06617647,0.5468207,1,1)
		_SkyColorNight ("Sky Color - Night", Color) = (0.02745098,0.03529412,0.1843137,1)
		_HorizonNight ("Horizon - Night", Color) = (0.06666667,0.5450981,1,1)
		_Horizon ("Horizon", Cube) = "_Skybox" {}
		_StarNoise ("Star Noise", 2D) = "white" {}
		_StarColor ("Star Color", Color) = (1,1,1,1)
		_StarsCube ("Stars Cube", Cube) = "_Skybox" {}
		_Dayness ("Dayness", Float) = 1
		_Moon ("Moon", Cube) = "_Skybox" {}
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			ZWrite Off
			Offset 20, 0
			GpuProgramID 4436
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _SkyColor;
			float4 _HorizonColor;
			float4 _StarNoise_ST;
			float4 _StarColor;
			float4 _SkyColorNight;
			float4 _HorizonNight;
			float _Dayness;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			samplerCUBE _Moon;
			samplerCUBE _Horizon;
			sampler2D _StarNoise;
			samplerCUBE _StarsCube;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
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
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.yzx;
                tmp1.xyz = tmp0.zxy * float3(0.0, 0.0, 1.0);
                tmp1.xyz = tmp0.xyz * float3(1.0, 0.0, 0.0) + -tmp1.xyz;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp0.xyz * tmp1.xyz;
                tmp2.xyz = tmp1.zxy * tmp0.yzx + -tmp2.xyz;
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp2.x = dot(tmp2.xyz, tmp3.xyz);
                tmp2.y = dot(tmp1.xy, tmp3.xy);
                tmp2.z = dot(tmp0.xyz, tmp3.xyz);
                tmp1 = texCUBE(_StarsCube, tmp2.xyz);
                tmp1.xyz = max(tmp1.xyz, float3(0.05, 0.05, 0.05));
                tmp1.xyz = min(tmp1.xyz, float3(0.9, 0.9, 0.9));
                tmp1.xyz = tmp1.xyz * float3(1.176471, 1.176471, 1.176471) + float3(-0.0588235, -0.0588235, -0.0588235);
                tmp0.w = max(-tmp3.y, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.w = 1.0 - tmp0.w;
                tmp0.w = saturate(tmp0.w * 1.25);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 1.25;
                tmp0.w = exp(tmp0.w);
                tmp1.w = max(tmp1.w, 0.1);
                tmp1.w = min(tmp1.w, 0.5);
                tmp1.w = tmp1.w * 2.5 + -0.25;
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp4.xyz = tmp0.zxy * float3(0.0, 0.0, -1.0);
                tmp4.xyz = tmp0.xyz * float3(-1.0, 0.0, 0.0) + -tmp4.xyz;
                tmp1.w = dot(tmp4.xy, tmp4.xy);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp1.www * tmp4.xyz;
                tmp5.xyz = tmp0.xyz * tmp4.xyz;
                tmp5.xyz = tmp4.zxy * tmp0.yzx + -tmp5.xyz;
                tmp2.y = dot(tmp4.xy, tmp3.xy);
                tmp0.x = dot(-tmp0.xyz, tmp3.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp2.x = dot(tmp5.xyz, tmp3.xyz);
                tmp2 = texCUBE(_Moon, tmp2.xyz);
                tmp0.y = 1.0 - tmp2.w;
                tmp1.xyz = tmp0.yyy * tmp1.xyz;
                tmp4 = _Time * float4(0.025, 0.0125, 0.0025, -0.001667) + inp.texcoord.xyyy;
                tmp0.yz = tmp4.xy * _StarNoise_ST.xy + _StarNoise_ST.zw;
                tmp4.xy = tmp4.zw * float2(40.0, 26.0);
                tmp4.xy = frac(tmp4.xy);
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.w = abs(tmp4.y) * abs(tmp4.x);
                tmp4 = tex2D(_StarNoise, tmp0.yz);
                tmp5.xyz = float3(0.5, 0.5, 0.5) - tmp4.xyz;
                tmp4.xyz = tmp5.xyz * float3(0.5, 0.5, 0.5) + tmp4.xyz;
                tmp1.xyz = tmp1.xyz * tmp4.xyz;
                tmp1.xyz = tmp1.xyz * _StarColor.xyz;
                tmp1.xyz = tmp1.xyz * float3(4.0, 4.0, 4.0);
                tmp0.y = _Dayness * 2.0 + -1.0;
                tmp0.y = 1.0 - abs(tmp0.y);
                tmp0.y = max(tmp0.y, 0.667);
                tmp0.y = tmp0.y * 3.003003 + -2.003003;
                tmp0.z = max(tmp3.z, 0.0);
                tmp4.xyz = tmp0.zzz * float3(0.05, 0.175, -0.015) + float3(0.95, 0.075, 0.04);
                tmp0.z = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x - 1.0;
                tmp0.x = saturate(tmp0.x * 100.0001 + 1.0);
                tmp4.xyz = tmp4.xyz * tmp0.zzz;
                tmp4.xyz = tmp4.xyz * float3(5.0, 5.0, 5.0);
                tmp4.xyz = tmp0.yyy * tmp4.xyz;
                tmp0.y = abs(tmp3.y) * -0.8 + 0.8;
                tmp3.xyz = tmp3.xyz * float3(-1.0, -1.0, 1.0);
                tmp3 = texCUBE(_Horizon, tmp3.xyz);
                tmp0.yw = tmp0.yw * tmp0.yw;
                tmp3.xyz = tmp0.yyy * tmp4.xyz;
                tmp4.xyz = tmp3.xyz * float3(1.2, 1.2, 1.2);
                tmp0.y = log(tmp0.z);
                tmp0.y = tmp0.y * 20.0;
                tmp0.y = exp(tmp0.y);
                tmp4.xyz = tmp0.yyy * tmp4.xyz;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp5.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp0.x = tmp0.z * tmp1.w;
                tmp0.y = 1.0 - tmp0.z;
                tmp0.z = log(tmp0.w);
                tmp0.z = tmp0.z * 2.5;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp0.z * 1.333333 + -0.3333333;
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.x = tmp0.x * 1.5;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp5.xyz = tmp0.xxx * tmp5.xyz;
                tmp4.xyz = tmp5.xyz * float3(160.0, 160.0, 160.0) + tmp4.xyz;
                tmp5.xyz = _HorizonColor.xyz - _SkyColor.xyz;
                tmp5.xyz = tmp0.www * tmp5.xyz + _SkyColor.xyz;
                tmp6.xyz = _HorizonNight.xyz - _SkyColorNight.xyz;
                tmp0.xzw = tmp0.www * tmp6.xyz + _SkyColorNight.xyz;
                tmp5.xyz = tmp5.xyz - tmp0.xzw;
                tmp1.w = saturate(_Dayness * 5.0 + -2.0);
                tmp0.xzw = tmp1.www * tmp5.xyz + tmp0.xzw;
                tmp1.w = 1.0 - tmp1.w;
                tmp0.y = tmp0.y * tmp1.w;
                tmp0.xzw = tmp3.xyz * float3(1.2, 1.2, 1.2) + tmp0.xzw;
                tmp3.xyz = unity_FogColor.xyz - tmp0.xzw;
                tmp5.xy = saturate(inp.texcoord.yy * float2(-20.0, -4.761905) + float2(1.0, 1.190476));
                tmp5.xy = saturate(tmp3.ww + tmp5.xy);
                tmp0.xzw = tmp5.yyy * tmp3.xyz + tmp0.xzw;
                tmp1.w = 1.0 - tmp5.x;
                tmp0.xzw = tmp4.xyz * tmp1.www + tmp0.xzw;
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp2.xyz = -tmp2.xyz * float3(1.2, 1.2, 1.2) + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp1.xyz * tmp0.yyy + tmp0.xzw;
                tmp0.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                o.sv_target.xyz = -tmp2.xyz * tmp0.xyz + float3(1.0, 1.0, 1.0);
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}