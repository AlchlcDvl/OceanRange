Shader "SR/FX/BuildMode ScreenSpace" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Overlay-500" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay-500" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZTest Always
			ZWrite Off
			Cull Off
			Offset 1, -100
			GpuProgramID 25468
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
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                o.position = v.vertex;
                o.texcoord.xy = v.texcoord.xy;
                o.color = v.color;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.y = tmp0.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp0.x + tmp0.y;
                tmp0.x = unity_MatrixV._m22 * tmp0.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp0.w + tmp0.x;
                o.texcoord1.z = -tmp0.x;
                tmp0.x = v.vertex.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = v.vertex.xw * float2(0.5, 0.5);
                o.texcoord1.xy = tmp0.zz + tmp0.xw;
                o.texcoord1.w = v.vertex.w;
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
                tmp0.x = _ScreenParams.y / _ScreenParams.x;
                tmp1.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1.z = tmp0.x * tmp1.y;
                tmp0 = tmp1.xzxz * float4(48.0, 48.0, 12.0, 12.0);
                tmp1.x = tmp1.y * 0.5 + 0.5;
                tmp0 = frac(tmp0);
                tmp0 = tmp0 * float4(24.99999, 24.99999, 20.0, 20.0) + float4(-23.99999, -23.99999, -19.0, -19.0);
                tmp0 = max(tmp0, float4(0.0, 0.0, 0.0, 0.0));
                tmp0.xy = tmp0.yw + tmp0.xz;
                tmp0.xy = min(tmp0.xy, float2(1.0, 1.0));
                tmp0.xy = tmp0.xy + tmp0.xy;
                tmp0.xy = floor(tmp0.xy);
                tmp0.x = tmp0.x * 0.5 + tmp0.y;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.y = max(tmp0.x, 0.4);
                tmp0.y = min(tmp0.y, 0.5);
                tmp2 = inp.texcoord.xyxy * float4(2.0, -2.0, 1.0, -1.0) + float4(-1.0, 0.334, 0.0, 1.0);
                tmp0.zw = tmp2.xy * tmp2.xy;
                tmp1.yz = tmp2.zw * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.yz = tmp1.yz * tmp1.yz;
                tmp1.y = tmp1.z + tmp1.y;
                tmp1.y = saturate(tmp1.y * 0.6666667 + -0.3333333);
                tmp0.yz = tmp0.yw + tmp0.yz;
                tmp0.z = tmp0.z * 0.1;
                tmp0.z = min(tmp0.z, 1.0);
                tmp1.zw = inp.color.ww * _Color.ww + float2(-0.2, -0.1);
                tmp1.zw = frac(tmp1.zw);
                tmp2.xy = tmp0.zz - tmp1.zw;
                tmp0.z = 1.0 - tmp0.z;
                tmp0.w = tmp1.w - tmp1.z;
                tmp0.w = saturate(tmp2.x / tmp0.w);
                tmp3 = inp.color * _Color;
                tmp1.z = frac(tmp3.w);
                tmp1.z = tmp1.z - tmp1.w;
                tmp1.z = -tmp2.y / tmp1.z;
                tmp1.z = saturate(tmp1.z + 1.0);
                tmp0.w = tmp0.w * tmp1.z;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = tmp1.x * tmp0.z;
                tmp0.w = tmp0.z * 1.428571 + -0.4285715;
                tmp0.w = tmp0.w + tmp0.w;
                tmp0.w = floor(tmp0.w);
                tmp0.z = tmp0.w * 0.05 + tmp0.z;
                tmp0.y = saturate(tmp0.z * tmp0.y);
                tmp0.z = tmp0.y + tmp0.y;
                tmp1.xzw = tmp3.xyz * tmp0.zzz;
                tmp0.z = tmp0.y - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp2.xyz = -inp.color.xyz * _Color.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp0.zzz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp0.z = tmp0.y > 0.5;
                tmp1.xzw = saturate(tmp0.zzz ? tmp2.xyz : tmp1.xzw);
                tmp0.xzw = tmp0.xxx * float3(0.2, 0.2, 0.2) + tmp3.xyz;
                o.sv_target.xyz = tmp1.xzw + tmp0.xzw;
                tmp0.x = 1.0 - inp.texcoord.y;
                tmp0.z = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.xz = tmp0.xx * float2(-0.6, -0.6666666) + float2(0.3, 0.2);
                tmp0.x = saturate(tmp0.x);
                tmp0.x = tmp0.x + tmp0.z;
                tmp0.x = tmp1.y * tmp0.x;
                tmp0.x = saturate(tmp0.x * 4.0 + -0.4);
                o.sv_target.w = tmp0.x * tmp3.w + tmp0.y;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}