Shader "SR/UI/Dialogue Character" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_UnscaledTime ("Unscaled Time", Float) = 0
		_MainTex ("MainTex", 2D) = "white" {}
		_OutlineWidth ("Outline Width", Range(0, 1)) = 0.1
		_Noise ("Noise", 2D) = "white" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
	}
	SubShader {
		Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			Cull Off
			GpuProgramID 9732
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
			float _UnscaledTime;
			float4 _MainTex_ST;
			float4 _Noise_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Noise;
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
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _UnscaledTime + _Time.y;
                tmp0.y = tmp0.x * 1.5;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * inp.texcoord.y;
                tmp1.w = tmp0.x * 0.00375;
                tmp0.x = frac(tmp0.y);
                tmp0.x = tmp0.x * 4.0;
                tmp0.x = floor(tmp0.x);
                tmp0.y = tmp0.x * 0.5;
                tmp0.y = floor(tmp0.y);
                tmp1.x = -tmp0.y * 2.0 + tmp0.x;
                tmp0.x = _ScreenParams.x / _ScreenParams.y;
                tmp0.zw = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp0.z = tmp0.z * 2.0 + -1.0;
                tmp2.y = tmp0.w * 2.0 + tmp0.y;
                tmp2.x = tmp0.x * tmp0.z;
                tmp1.yz = float2(-1.0, 0.0);
                tmp0.xy = tmp1.xy + tmp2.xy;
                tmp0.xy = tmp0.xy * _Noise_ST.xy;
                tmp0.xy = tmp0.xy * float2(0.5, 0.5) + _Noise_ST.zw;
                tmp0 = tex2D(_Noise, tmp0.xy);
                tmp0.xy = tmp0.xy * float2(0.002, 0.002) + inp.texcoord.xy;
                tmp0.xy = tmp1.zw + tmp0.xy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp0.w = tmp0.w * _Color.w;
                tmp0 = tmp0 * inp.color;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
	}
	Fallback "UI/Unlit/Transparent"
	CustomEditor "ShaderForgeMaterialInspector"
}