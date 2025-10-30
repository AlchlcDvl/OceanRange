Shader "SR/AMP/FX/ToonFire Billboard" {
	Properties {
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_Cutoff ("Mask Clip Value", Float) = 0.5
		[HDR] _ColorOutside ("Color Outside", Color) = (1,0.02937273,0,1)
		[HDR] _ColorInside ("Color Inside", Color) = (1,0.6135118,0,1)
		_OutsideContrast ("Outside Contrast", Range(0, 1)) = 0.75
		_InsideContrast ("Inside Contrast", Range(0, 1)) = 0
		[NoScaleOffset] _NoiseTexture ("Noise Texture", 2D) = "white" {}
		_NoiseScale ("Noise Scale", Float) = 1
		_NoisePanSpeed ("Noise Pan Speed", Vector) = (0.333,-1.2,-0.5,-1.06)
		_DistortionSpeed ("Distortion Speed", Float) = 1
		_DistortionScale ("Distortion Scale", Float) = 0.5
		_PushForward ("Push Forward", Float) = 0.3
		_DepthFade ("Depth Fade", Float) = 0.25
		_RadialMaskTilingOffset ("RadialMask Tiling/Offset", Vector) = (1.5,1,-0.25,-0.21)
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "DisableBatching" = "true" "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "AlphaTest+0" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "FORCENOSHADOWCASTING" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+0" "RenderType" = "Transparent" }
			Blend One OneMinusSrcAlpha, OneMinusDstColor One
			ZWrite Off
			GpuProgramID 39127
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _PushForward;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _ColorOutside;
			float4 _ColorInside;
			float4 _RadialMaskTilingOffset;
			float _InsideContrast;
			float _DistortionScale;
			float _DistortionSpeed;
			float4 _NoisePanSpeed;
			float _NoiseScale;
			float _DepthFade;
			float _OutsideContrast;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _NoiseTexture;
			sampler2D _CameraDepthTexture;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.xyz = _WorldSpaceCameraPos;
                tmp0.w = 0.0;
                tmp0 = tmp0 - unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.x = dot(tmp0, tmp0);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 0.3333333;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp1.x = unity_MatrixV._m00;
                tmp1.y = unity_MatrixV._m01;
                tmp1.z = unity_MatrixV._m02;
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp1.yxz;
                tmp1.x = tmp0.z;
                tmp2.x = unity_MatrixV._m10;
                tmp2.y = unity_MatrixV._m11;
                tmp2.z = unity_MatrixV._m12;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xzy;
                tmp1.y = tmp2.x;
                tmp3.x = unity_MatrixV._m20;
                tmp3.y = unity_MatrixV._m21;
                tmp3.z = unity_MatrixV._m22;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp3.xyz;
                tmp1.z = -tmp3.x;
                tmp1.w = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp1.w = sqrt(tmp1.w);
                tmp4.x = tmp1.w * v.vertex.x;
                tmp1.w = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp1.w = sqrt(tmp1.w);
                tmp4.y = tmp1.w * v.vertex.y;
                tmp1.w = dot(unity_ObjectToWorld._m02_m12_m22, unity_ObjectToWorld._m02_m12_m22);
                tmp1.w = sqrt(tmp1.w);
                tmp4.z = tmp1.w * v.vertex.z;
                tmp5.x = dot(tmp4.xyz, tmp1.xyz);
                tmp1.x = dot(v.normal.xyz, tmp1.xyz);
                tmp2.x = tmp0.w;
                tmp0.z = tmp2.z;
                tmp0.w = -tmp3.y;
                tmp2.z = -tmp3.z;
                tmp5.y = dot(tmp4.xyz, tmp0.xyz);
                tmp1.y = dot(v.normal.xyz, tmp0.xyz);
                tmp5.z = dot(tmp4.xyz, tmp2.xyz);
                tmp1.z = dot(v.normal.xyz, tmp2.xyz);
                tmp0.yzw = tmp5.xyz + unity_ObjectToWorld._m03_m13_m23;
                tmp2 = tmp0.zzzz * unity_WorldToObject._m01_m11_m21_m31;
                tmp2 = unity_WorldToObject._m00_m10_m20_m30 * tmp0.yyyy + tmp2;
                tmp2 = unity_WorldToObject._m02_m12_m22_m32 * tmp0.wwww + tmp2;
                tmp2 = unity_WorldToObject._m03_m13_m23_m33 * v.vertex.wwww + tmp2;
                tmp0.yzw = tmp2.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.yzw = unity_ObjectToWorld._m00_m10_m20 * tmp2.xxx + tmp0.yzw;
                tmp0.yzw = unity_ObjectToWorld._m02_m12_m22 * tmp2.zzz + tmp0.yzw;
                tmp0.yzw = unity_ObjectToWorld._m03_m13_m23 * tmp2.www + tmp0.yzw;
                tmp0.yzw = _WorldSpaceCameraPos - tmp0.yzw;
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = max(tmp1.w, 0.001);
                tmp1.w = rsqrt(tmp1.w);
                tmp0.yzw = tmp0.yzw * tmp1.www;
                tmp3.xyz = tmp0.zzz * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * tmp0.yyy + tmp3.xyz;
                tmp0.yzw = unity_WorldToObject._m02_m12_m22 * tmp0.www + tmp3.xyz;
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp0.yzw = tmp0.yzw * tmp1.www;
                tmp0.yzw = tmp0.yzw * _PushForward.xxx;
                tmp2.xyz = tmp2.xyz * float3(1.5, 1.5, 1.5);
                tmp0.xyz = tmp0.xxx * tmp0.yzw + tmp2.xyz;
                tmp3 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp3 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp3;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp3;
                tmp3 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * tmp2.www + tmp0.xyz;
                tmp0 = tmp3.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp3.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp3.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp3.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = dot(tmp1.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(tmp1.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(tmp1.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.x = dot(tmp2.xyz, tmp2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                o.texcoord1.xyz = tmp1.xxx * tmp2.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.zw = tmp0.zw;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
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
                tmp0.x = _DistortionSpeed * _DistortionScale;
                tmp0.x = tmp0.x * _Time.y;
                tmp1 = inp.texcoord2.xyzy * _NoiseScale.xxxx;
                tmp1 = tmp1 * _DistortionScale.xxxx;
                tmp0.yz = tmp0.xx * _NoisePanSpeed.xy + tmp1.zw;
                tmp1 = tmp0.xxxx * _NoisePanSpeed + tmp1.xyxy;
                tmp0 = tex2D(_NoiseTexture, tmp0.yz);
                tmp0.x = tmp0.y + tmp0.x;
                tmp2 = tex2D(_NoiseTexture, tmp1.xy);
                tmp1 = tex2D(_NoiseTexture, tmp1.zw);
                tmp0.y = tmp1.y + tmp2.x;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = abs(inp.texcoord1.x) * tmp0.x + tmp0.y;
                tmp1.xy = inp.texcoord.xy * _RadialMaskTilingOffset.xy + _RadialMaskTilingOffset.zw;
                tmp0.x = tmp0.x * tmp1.y;
                tmp1.z = tmp0.x * 0.333 + tmp1.y;
                tmp0.xy = tmp1.xz * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.z = tmp1.y - 0.333;
                tmp0.z = saturate(tmp0.z * -1.49925 + 1.0);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x - 1.0;
                tmp0.x = max(-tmp0.x, 0.0);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * inp.color.w;
                tmp0.y = inp.texcoord3.w + 0.0;
                tmp1.xyz = inp.texcoord3.zxy / tmp0.yyy;
                tmp2 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp0.y = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.w = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.y = tmp0.w - tmp0.y;
                tmp0.y = tmp0.y / _DepthFade;
                tmp0.y = min(abs(tmp0.y), 1.0);
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.yw = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.yw = float2(1.0, 1.0) - abs(tmp0.yw);
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.y = saturate(tmp0.y * 8.0);
                tmp0.w = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.w;
                tmp1.xy = _OutsideContrast.xx * float2(0.499, -0.499) + float2(0.0, 1.0);
                tmp0.w = tmp0.x * tmp0.y + -tmp1.x;
                tmp1.x = tmp1.y - tmp1.x;
                tmp1.x = 1.0 / tmp1.x;
                tmp0.w = saturate(tmp0.w * tmp1.x);
                tmp1.x = tmp0.w * -2.0 + 3.0;
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.y = tmp1.x * tmp0.w + -_Cutoff;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = tmp1.y < 0.0;
                if (tmp1.x) {
                    discard;
                }
                tmp1.xy = _InsideContrast.xx * float2(0.499, -0.249) + float2(0.25, 1.0);
                tmp0.x = tmp0.x * tmp0.y + -tmp1.x;
                tmp0.y = tmp1.y - tmp1.x;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.x = saturate(tmp0.y * tmp0.x);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = tmp0.x * tmp0.z;
                o.sv_target.w = tmp0.x;
                tmp1 = _ColorInside - _ColorOutside;
                tmp1 = tmp0.yyyy * tmp1 + _ColorOutside;
                tmp0.xyz = tmp1.www * tmp1.xyz;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}