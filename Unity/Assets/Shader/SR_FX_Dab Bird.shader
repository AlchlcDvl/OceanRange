Shader "SR/FX/Dab Bird" {
	Properties {
		_mainTex ("mainTex", 2D) = "white" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			GpuProgramID 64860
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _mainTex_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _mainTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = _TimeEditor.wy + _Time.wy;
                tmp0.yz = tmp0.xy * float2(3.0, 0.5) + v.color.yz;
                tmp0.xw = tmp0.zy + float2(0.25, 0.5);
                tmp0.yw = tmp0.yw * float2(2.122066, 2.122066);
                tmp0.xz = sin(tmp0.zx);
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.x = tmp0.x * -3.0 + 1.0;
                tmp0.x = max(tmp0.x, 0.01);
                tmp0.x = min(tmp0.x, 1.0);
                tmp1.xy = sin(tmp0.yw);
                tmp0.yz = -tmp1.xy * float2(0.5, 0.5) + tmp0.yw;
                tmp0.yz = sin(tmp0.yz);
                tmp1.yz = tmp0.yz * v.color.xx;
                tmp1.x = v.color.x;
                tmp0.yzw = v.color.xxx * float3(0.0, 0.05, 0.1);
                tmp0.yzw = tmp1.xyz * float3(0.0, 0.2, 0.4) + -tmp0.yzw;
                tmp0.xyz = tmp0.yzw * tmp0.xxx + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp0;
                o.texcoord1 = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.color = v.color;
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
                tmp0.x = _ProjectionParams.x * -_ProjectionParams.x;
                tmp1.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1.z = tmp0.x * tmp1.y;
                tmp0.xy = tmp1.xz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * _ScreenParams.xy;
                tmp0.xy = floor(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(0.25, 0.25);
                tmp0.zw = tmp0.xy >= -tmp0.xy;
                tmp0.xy = frac(abs(tmp0.xy));
                tmp0.xy = tmp0.zw ? tmp0.xy : -tmp0.xy;
                tmp0.xy = tmp0.xy * float2(4.0, 4.0);
                tmp0.xy = trunc(tmp0.xy);
                tmp1 = float4(0.0, 1.0, 2.0, 3.0) - tmp0.xxxx;
                tmp0 = float4(0.0, 1.0, 2.0, 3.0) - tmp0.yyyy;
                tmp0 = min(abs(tmp0), float4(1.0, 1.0, 1.0, 1.0));
                tmp0 = float4(1.0, 1.0, 1.0, 1.0) - tmp0;
                tmp1 = min(abs(tmp1), float4(1.0, 1.0, 1.0, 1.0));
                tmp1 = float4(1.0, 1.0, 1.0, 1.0) - tmp1;
                tmp2.x = dot(float4(0.0588235, 0.5294118, 0.1764706, 0.6470588), tmp0);
                tmp2.y = dot(float4(0.7647059, 0.2941177, 0.8823529, 0.4117647), tmp0);
                tmp2.z = dot(float4(0.2352941, 0.7058824, 0.1176471, 0.5882353), tmp0);
                tmp2.w = dot(float4(0.9411765, 0.4705882, 0.8235294, 0.3529412), tmp0);
                tmp0.x = dot(tmp2, tmp1);
                tmp0.y = inp.color.w - 1.5;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.x = round(tmp0.x);
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + float3(0.5073529, 0.5073529, 0.5073529);
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp1.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp1.xyz = -tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xy = inp.texcoord.xy * _mainTex_ST.xy + _mainTex_ST.zw;
                tmp2 = tex2D(_mainTex, tmp2.xy);
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp1.xyz = -tmp1.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                o.sv_target.xyz = saturate(tmp0.xyz ? tmp1.xyz : tmp2.xyz);
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 81974
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = _TimeEditor.wy + _Time.wy;
                tmp0.yz = tmp0.xy * float2(3.0, 0.5) + v.color.yz;
                tmp0.xw = tmp0.zy + float2(0.25, 0.5);
                tmp0.yw = tmp0.yw * float2(2.122066, 2.122066);
                tmp0.xz = sin(tmp0.zx);
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.x = tmp0.x * -3.0 + 1.0;
                tmp0.x = max(tmp0.x, 0.01);
                tmp0.x = min(tmp0.x, 1.0);
                tmp1.xy = sin(tmp0.yw);
                tmp0.yz = -tmp1.xy * float2(0.5, 0.5) + tmp0.yw;
                tmp0.yz = sin(tmp0.yz);
                tmp1.yz = tmp0.yz * v.color.xx;
                tmp1.x = v.color.x;
                tmp0.yzw = v.color.xxx * float3(0.0, 0.05, 0.1);
                tmp0.yzw = tmp1.xyz * float3(0.0, 0.2, 0.4) + -tmp0.yzw;
                tmp0.xyz = tmp0.yzw * tmp0.xxx + v.vertex.xyz;
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
                tmp1.x = tmp0.z + tmp1.x;
                tmp1.y = min(tmp0.w, tmp1.x);
                tmp1.y = tmp1.y - tmp1.x;
                o.position.z = unity_LightShadowBias.y * tmp1.y + tmp1.x;
                o.position.xyw = tmp0.xyw;
                o.texcoord1 = tmp0;
                o.color = v.color;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _ProjectionParams.x * -_ProjectionParams.x;
                tmp1.xy = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp1.z = tmp0.x * tmp1.y;
                tmp0.xy = tmp1.xz * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * _ScreenParams.xy;
                tmp0.xy = floor(tmp0.xy);
                tmp0.xy = tmp0.xy * float2(0.25, 0.25);
                tmp0.zw = tmp0.xy >= -tmp0.xy;
                tmp0.xy = frac(abs(tmp0.xy));
                tmp0.xy = tmp0.zw ? tmp0.xy : -tmp0.xy;
                tmp0.xy = tmp0.xy * float2(4.0, 4.0);
                tmp0.xy = trunc(tmp0.xy);
                tmp1 = float4(0.0, 1.0, 2.0, 3.0) - tmp0.xxxx;
                tmp0 = float4(0.0, 1.0, 2.0, 3.0) - tmp0.yyyy;
                tmp0 = min(abs(tmp0), float4(1.0, 1.0, 1.0, 1.0));
                tmp0 = float4(1.0, 1.0, 1.0, 1.0) - tmp0;
                tmp1 = min(abs(tmp1), float4(1.0, 1.0, 1.0, 1.0));
                tmp1 = float4(1.0, 1.0, 1.0, 1.0) - tmp1;
                tmp2.x = dot(float4(0.0588235, 0.5294118, 0.1764706, 0.6470588), tmp0);
                tmp2.y = dot(float4(0.7647059, 0.2941177, 0.8823529, 0.4117647), tmp0);
                tmp2.z = dot(float4(0.2352941, 0.7058824, 0.1176471, 0.5882353), tmp0);
                tmp2.w = dot(float4(0.9411765, 0.4705882, 0.8235294, 0.3529412), tmp0);
                tmp0.x = dot(tmp2, tmp1);
                tmp0.y = inp.color.w - 1.5;
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.x = round(tmp0.x);
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