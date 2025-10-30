Shader "SR/FX/Additive Animated" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_TintColor ("Color", Color) = (1,1,1,1)
		_SoftParticlesFactor ("Soft Particles Factor", Range(0, 3)) = 1
		_TilesX ("Tiles X", Float) = 1
		_TilesY ("Tiles Y", Float) = 1
		_TilesOffset ("Tiles Offset", Float) = 0
		_AnimationSpeed ("Animation Speed", Float) = 1
		_TransitionDistance ("TransitionDistance", Float) = 5
		_Falloff ("Falloff", Float) = 20
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
			GpuProgramID 42776
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
				float4 texcoord2 : TEXCOORD2;
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
			float _SoftParticlesFactor;
			float _TilesX;
			float _TilesY;
			float _TilesOffset;
			float _AnimationSpeed;
			float _TransitionDistance;
			float _Falloff;
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
                tmp0.xy = inp.texcoord2.xy / inp.texcoord2.ww;
                tmp0 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.x = _ZBufferParams.z * tmp0.x + _ZBufferParams.w;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x - _ProjectionParams.y;
                tmp0.y = inp.texcoord2.z - _ProjectionParams.y;
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = saturate(tmp0.x / _SoftParticlesFactor);
                tmp0.y = _TimeEditor.y + _Time.y;
                tmp0.y = tmp0.y * _AnimationSpeed;
                tmp0.y = frac(tmp0.y);
                tmp0.z = _TilesY * _TilesX;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y + _TilesOffset;
                tmp0.zw = float2(1.0, 1.0) / float2(_TilesX.x, _TilesY.x);
                tmp1.x = tmp0.z * tmp0.y;
                tmp1.y = floor(tmp1.x);
                tmp1.x = -_TilesX * tmp1.y + tmp0.y;
                tmp1.xy = tmp1.xy + inp.texcoord.xy;
                tmp0.yz = tmp0.zw * tmp1.xy;
                tmp0.yz = tmp0.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.yz);
                tmp1 = tmp1 * inp.color;
                tmp1 = tmp1 * _TintColor;
                tmp0.x = tmp0.x * tmp1.w;
                tmp0.yzw = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.y = dot(tmp0.xyz, tmp0.xyz);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y / _TransitionDistance;
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * _Falloff;
                tmp0.y = exp(tmp0.y);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.x = tmp0.y * tmp0.x;
                o.sv_target.xyz = tmp0.xxx * tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "SR/FX/Additive Animated NoDepth"
	CustomEditor "ShaderForgeMaterialInspector"
}