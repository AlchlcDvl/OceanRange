Shader "SR/AMP/FX/ScreenSpace Overlay (Additive)" {
	Properties {
		[HDR] _Color ("Color", Color) = (1,1,1,1)
		[NoScaleOffset] _MainTexture ("Main Texture", 2D) = "white" {}
		[Toggle] _RedUVsRadial ("Red UVs Radial", Float) = 0
		_RedSpeedXYScaleZW ("Red Speed(X/Y) Scale(Z/W)", Vector) = (0,0,1,1)
		[Toggle] _GreenUVsRadial ("Green UVs Radial", Float) = 1
		_GreenSpeedXYScaleZW ("Green Speed(X/Y) Scale(Z/W)", Vector) = (0,0,1,1)
		[Toggle] _BlueUVsRadial ("Blue UVs Radial", Float) = 1
		_BlueSpeedXYScaleZW ("Blue Speed(X/Y) Scale(Z/W)", Vector) = (0,0,1,1)
		_VerticalMaskMin ("VerticalMask Min", Range(0, 1)) = 0
		_VerticalMaskMax ("VerticalMask Max", Range(0, 1)) = 0
		_VerticalMaskTilingOffset ("VerticalMask Tiling/Offset", Vector) = (1,1,0,0)
		_RadialMaskMin ("RadialMask Min", Range(0, 1)) = 0
		_RadialMaskMax ("RadialMask Max", Range(0, 1)) = 0
		_RadialMaskTilingOffset ("RadialMask Tiling/Offset", Vector) = (1,1,0,0)
		_FinalMixOldMinMaxNewMinMax ("FinalMix Old(Min/Max) New(Min/Max)", Vector) = (0,1,0,1)
		[Toggle] _EnableGradientMap ("Enable GradientMap", Float) = 0
		[NoScaleOffset] _GradientMap ("GradientMap", 2D) = "white" {}
		[HideInInspector] _texcoord ("", 2D) = "white" {}
	}
	SubShader {
		LOD 100
		Tags { "Overlay" = "Overlay" "RenderType" = "Opaque" }
		Pass {
			Name "Unlit"
			LOD 100
			Tags { "Overlay" = "Overlay" "RenderType" = "Opaque" }
			Blend One One, One One
			ZTest Always
			ZWrite Off
			GpuProgramID 9008
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 color : COLOR0;
				float4 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color;
			float _EnableGradientMap;
			float _RedUVsRadial;
			float4 _RedSpeedXYScaleZW;
			float _GreenUVsRadial;
			float4 _GreenSpeedXYScaleZW;
			float _BlueUVsRadial;
			float4 _BlueSpeedXYScaleZW;
			float _RadialMaskMin;
			float _RadialMaskMax;
			float4 _RadialMaskTilingOffset;
			float _VerticalMaskMin;
			float _VerticalMaskMax;
			float4 _VerticalMaskTilingOffset;
			float4 _FinalMixOldMinMaxNewMinMax;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTexture;
			sampler2D _GradientMap;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = v.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.yzw = tmp0.yyy * unity_CameraInvProjection._m01_m11_m21;
                tmp0.xyz = unity_CameraInvProjection._m00_m10_m20 * tmp0.xxx + tmp0.yzw;
                tmp0.xyz = tmp0.xyz + unity_CameraInvProjection._m03_m13_m23;
                tmp1 = tmp0.yyyy * unity_MatrixInvV._m01_m11_m21_m31;
                tmp1 = unity_MatrixInvV._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_MatrixInvV._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_MatrixInvV._m03_m13_m23_m33;
                tmp1.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp1.xyz = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                tmp0.xyz = unity_WorldToObject._m03_m13_m23 * tmp0.www + tmp0.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.color = v.color;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord.zw = float2(0.0, 0.0);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.z = max(abs(tmp0.x), abs(tmp0.y));
                tmp0.z = 1.0 / tmp0.z;
                tmp0.w = min(abs(tmp0.x), abs(tmp0.y));
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.w = tmp0.z * tmp0.z;
                tmp1.x = tmp0.w * 0.0208351 + -0.085133;
                tmp1.x = tmp0.w * tmp1.x + 0.180141;
                tmp1.x = tmp0.w * tmp1.x + -0.3302995;
                tmp0.w = tmp0.w * tmp1.x + 0.999866;
                tmp1.x = tmp0.w * tmp0.z;
                tmp1.x = tmp1.x * -2.0 + 1.570796;
                tmp1.y = abs(tmp0.x) < abs(tmp0.y);
                tmp1.x = tmp1.y ? tmp1.x : 0.0;
                tmp0.z = tmp0.z * tmp0.w + tmp1.x;
                tmp0.w = tmp0.x < -tmp0.x;
                tmp0.w = tmp0.w ? -3.141593 : 0.0;
                tmp0.z = tmp0.w + tmp0.z;
                tmp0.w = min(tmp0.x, tmp0.y);
                tmp0.w = tmp0.w < -tmp0.w;
                tmp1.x = max(tmp0.x, tmp0.y);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.y = 1.0 - tmp0.x;
                tmp1.x = tmp1.x >= -tmp1.x;
                tmp0.w = tmp0.w ? tmp1.x : 0.0;
                tmp0.z = tmp0.w ? -tmp0.z : tmp0.z;
                tmp0.z = tmp0.z + 3.141593;
                tmp0.x = tmp0.z * 0.1591549;
                tmp0.zw = _Time.yy * _RedSpeedXYScaleZW.xy + tmp0.xy;
                tmp1.xy = _Time.yy * _RedSpeedXYScaleZW.xy + inp.texcoord.xy;
                tmp0.zw = tmp0.zw - tmp1.xy;
                tmp0.zw = _RedUVsRadial.xx * tmp0.zw + tmp1.xy;
                tmp0.zw = tmp0.zw * _RedSpeedXYScaleZW.zw;
                tmp1 = tex2D(_MainTexture, tmp0.zw);
                tmp0.zw = _Time.yy * _GreenSpeedXYScaleZW.xy + tmp0.xy;
                tmp0.xy = _Time.yy * _BlueSpeedXYScaleZW.xy + tmp0.xy;
                tmp1.yz = _Time.yy * _GreenSpeedXYScaleZW.xy + inp.texcoord.xy;
                tmp0.zw = tmp0.zw - tmp1.yz;
                tmp0.zw = _GreenUVsRadial.xx * tmp0.zw + tmp1.yz;
                tmp0.zw = tmp0.zw * _GreenSpeedXYScaleZW.zw;
                tmp2 = tex2D(_MainTexture, tmp0.zw);
                tmp0.z = tmp1.x * tmp2.y;
                tmp1.xy = _Time.yy * _BlueSpeedXYScaleZW.xy + inp.texcoord.xy;
                tmp0.xy = tmp0.xy - tmp1.xy;
                tmp0.xy = _BlueUVsRadial.xx * tmp0.xy + tmp1.xy;
                tmp0.xy = tmp0.xy * _BlueSpeedXYScaleZW.zw;
                tmp1 = tex2D(_MainTexture, tmp0.xy);
                tmp0.x = tmp0.z * tmp1.z;
                tmp1 = tex2D(_MainTexture, inp.texcoord.xy);
                tmp0.x = tmp0.x * tmp1.w;
                tmp0.x = tmp0.x * 4.0;
                tmp0.yz = inp.texcoord.xy * _RadialMaskTilingOffset.xy + _RadialMaskTilingOffset.zw;
                tmp0.yz = tmp0.yz * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.y = dot(tmp0.xy, tmp0.xy);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y - _RadialMaskMin;
                tmp0.z = _RadialMaskMax - _RadialMaskMin;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.y = saturate(tmp0.z * tmp0.y);
                tmp0.z = tmp0.y * -2.0 + 3.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = inp.texcoord.y * _VerticalMaskTilingOffset.y + _VerticalMaskTilingOffset.w;
                tmp0.z = tmp0.z * 2.0 + -1.0;
                tmp0.z = abs(tmp0.z) - _VerticalMaskMin;
                tmp0.w = _VerticalMaskMax - _VerticalMaskMin;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.z = saturate(tmp0.w * tmp0.z);
                tmp0.w = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.yz = min(tmp0.yz, float2(1.0, 1.0));
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.x = tmp0.x * tmp0.y + -_FinalMixOldMinMaxNewMinMax.x;
                tmp0.yz = _FinalMixOldMinMaxNewMinMax.wy - _FinalMixOldMinMaxNewMinMax.zx;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x / tmp0.z;
                tmp0.x = saturate(tmp0.x + _FinalMixOldMinMaxNewMinMax.z);
                tmp0.y = 0.0;
                tmp1 = tex2D(_GradientMap, tmp0.xy);
                tmp0.yzw = tmp1.xyz * tmp1.www + -tmp0.xxx;
                tmp0.xyz = _EnableGradientMap.xxx * tmp0.yzw + tmp0.xxx;
                tmp1.xyz = _Color.www * _Color.xyz;
                tmp2.xyz = inp.color.www * inp.color.xyz;
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz * tmp1.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}