Shader "SR/AMP/Slime/FX/PhosCore Aura" {
	Properties {
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		[HDR] _Color ("Color", Color) = (1,1,0,1)
		_GlowMax ("Glow Max", Range(0, 1)) = 1
		_GlowMin ("Glow Min", Range(0, 1)) = 0
		_GlowSpeed ("Glow Speed", Float) = 0.8
		[NoScaleOffset] _MainTexture ("Main Texture", 2D) = "white" {}
		[Toggle] _RedUVsRadial ("Red UVs Radial", Float) = 1
		_RedSpeedXYScaleZW ("Red Speed(X/Y) Scale(Z/W)", Vector) = (0,0,1,1)
		[Toggle] _GreenUVsRadial ("Green UVs Radial", Float) = 0
		_GreenSpeedXYScaleZW ("Green Speed(X/Y) Scale(Z/W)", Vector) = (0,0,1,1)
		[Toggle] _BlueUVsRadial ("Blue UVs Radial", Float) = 1
		_BlueSpeedXYScaleZW ("Blue Speed(X/Y) Scale(Z/W)", Vector) = (0,0,1,1)
		_RadialMaskMin ("RadialMask Min", Range(0, 1)) = 0
		_RadialMaskMax ("RadialMask Max", Range(0, 1)) = 0
		_RadialMaskTilingOffset ("RadialMask Tiling/Offset", Vector) = (1,1,0,0)
		_FinalMixOldMinMaxNewMinMax ("FinalMix Old(Min/Max) New(Min/Max)", Vector) = (0,1,0,1)
		[Toggle] _EnableGradientMap ("Enable GradientMap", Float) = 1
		_DepthFade ("Depth Fade", Range(0, 3)) = 0.25
		[NoScaleOffset] _GradientMap ("GradientMap", 2D) = "white" {}
		_PushForward ("Billboard Push Forward", Float) = 0
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IsEmissive" = "true" "QUEUE" = "Overlay+0" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay+0" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 731
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _PushForward;
			float4 _texcoord_ST;
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
			float4 _FinalMixOldMinMaxNewMinMax;
			float _GlowSpeed;
			float _GlowMin;
			float _GlowMax;
			float _DepthFade;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTexture;
			sampler2D _GradientMap;
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
                tmp2.xyz = tmp2.xyz * float3(1.1, 1.1, 1.1);
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
                o.texcoord4 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			// Keywords: DIRECTIONAL
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
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 4.0 + -_FinalMixOldMinMaxNewMinMax.x;
                tmp0.yz = _FinalMixOldMinMaxNewMinMax.wy - _FinalMixOldMinMaxNewMinMax.zx;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x / tmp0.z;
                tmp0.x = saturate(tmp0.x + _FinalMixOldMinMaxNewMinMax.z);
                tmp0.y = 0.0;
                tmp1 = tex2D(_GradientMap, tmp0.xy);
                tmp0.yzw = tmp1.xyz * tmp1.www + -tmp0.xxx;
                tmp0.yzw = _EnableGradientMap.xxx * tmp0.yzw + tmp0.xxx;
                tmp1.xyz = _Color.www * _Color.xyz;
                tmp2.xyz = inp.color.www * inp.color.xyz;
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp0.yzw = tmp0.yzw * tmp1.xyz;
                tmp1.x = _GlowSpeed * _Time.y;
                tmp1.x = sin(tmp1.x);
                tmp1.x = tmp1.x + 1.0;
                tmp1.x = tmp1.x * 2.0 + -3.0;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.y = _GlowMax - _GlowMin;
                tmp1.x = tmp1.x * tmp1.y + _GlowMin;
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.y = inp.texcoord3.w + 0.0;
                tmp1.yzw = inp.texcoord3.zxy / tmp1.yyy;
                tmp2 = tex2D(_CameraDepthTexture, tmp1.zw);
                tmp1.y = _ZBufferParams.z * tmp1.y + _ZBufferParams.w;
                tmp1.y = 1.0 / tmp1.y;
                tmp1.z = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp1.z = 1.0 / tmp1.z;
                tmp1.y = tmp1.z - tmp1.y;
                tmp1.y = tmp1.y / _DepthFade;
                tmp1.y = min(abs(tmp1.y), 1.0);
                o.sv_target.xyz = tmp0.yzw * tmp1.yyy;
                tmp0.y = tmp1.y * tmp1.x;
                o.sv_target.w = tmp0.x * tmp0.y;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Overlay+0" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 121572
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
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float _PushForward;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _RedUVsRadial;
			float4 _RedSpeedXYScaleZW;
			float _GreenUVsRadial;
			float4 _GreenSpeedXYScaleZW;
			float _BlueUVsRadial;
			float4 _BlueSpeedXYScaleZW;
			float _RadialMaskMin;
			float _RadialMaskMax;
			float4 _RadialMaskTilingOffset;
			float4 _FinalMixOldMinMaxNewMinMax;
			float _GlowSpeed;
			float _GlowMin;
			float _GlowMax;
			float _DepthFade;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTexture;
			sampler2D _CameraDepthTexture;
			
			// Keywords: POINT
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
                tmp2.xyz = tmp2.xyz * float3(1.1, 1.1, 1.1);
                tmp0.xyz = tmp0.xxx * tmp0.yzw + tmp2.xyz;
                tmp3 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp3 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp3;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp3;
                tmp3 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp4 = tmp3.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp4 = unity_MatrixVP._m00_m10_m20_m30 * tmp3.xxxx + tmp4;
                tmp4 = unity_MatrixVP._m02_m12_m22_m32 * tmp3.zzzz + tmp4;
                tmp3 = unity_MatrixVP._m03_m13_m23_m33 * tmp3.wwww + tmp4;
                o.position = tmp3;
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
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * tmp2.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * tmp2.wwww + tmp0;
                tmp1.x = tmp3.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp3.xw * float2(0.5, 0.5);
                o.texcoord3.zw = tmp3.zw;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			// Keywords: POINT
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
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 4.0 + -_FinalMixOldMinMaxNewMinMax.x;
                tmp0.yz = _FinalMixOldMinMaxNewMinMax.wy - _FinalMixOldMinMaxNewMinMax.zx;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x / tmp0.z;
                tmp0.x = saturate(tmp0.x + _FinalMixOldMinMaxNewMinMax.z);
                tmp0.y = inp.texcoord3.w + 0.0;
                tmp0.yzw = inp.texcoord3.zxy / tmp0.yyy;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.zw);
                tmp0.y = _ZBufferParams.z * tmp0.y + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.y = tmp0.z - tmp0.y;
                tmp0.y = tmp0.y / _DepthFade;
                tmp0.y = min(abs(tmp0.y), 1.0);
                tmp0.z = _GlowSpeed * _Time.y;
                tmp0.z = sin(tmp0.z);
                tmp0.z = tmp0.z + 1.0;
                tmp0.z = tmp0.z * 2.0 + -3.0;
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.w = _GlowMax - _GlowMin;
                tmp0.z = tmp0.z * tmp0.w + _GlowMin;
                tmp0.y = tmp0.y * tmp0.z;
                o.sv_target.w = tmp0.x * tmp0.y;
                o.sv_target.xyz = float3(0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IsEmissive" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Overlay+0" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend One One, One OneMinusSrcAlpha
			GpuProgramID 179513
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
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
			// $Globals ConstantBuffers for Fragment Shader
			float _RedUVsRadial;
			float4 _RedSpeedXYScaleZW;
			float _GreenUVsRadial;
			float4 _GreenSpeedXYScaleZW;
			float _BlueUVsRadial;
			float4 _BlueSpeedXYScaleZW;
			float _RadialMaskMin;
			float _RadialMaskMax;
			float4 _RadialMaskTilingOffset;
			float4 _FinalMixOldMinMaxNewMinMax;
			float _GlowSpeed;
			float _GlowMin;
			float _GlowMax;
			float _DepthFade;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTexture;
			sampler2D _CameraDepthTexture;
			sampler3D _DitherMaskLOD;
			
			// Keywords: SHADOWS_DEPTH UNITY_PASS_SHADOWCASTER
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
                tmp2.xyz = tmp2.xyz * float3(1.1, 1.1, 1.1);
                tmp0.xyz = tmp0.xxx * tmp0.yzw + tmp2.xyz;
                tmp3 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp3 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp3;
                tmp3 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp3;
                tmp3 = unity_ObjectToWorld._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp2.xyz = -tmp3.xyz * _WorldSpaceLightPos0.www + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp4.x = dot(tmp1.xyz, unity_WorldToObject._m00_m10_m20);
                tmp4.y = dot(tmp1.xyz, unity_WorldToObject._m01_m11_m21);
                tmp4.z = dot(tmp1.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = dot(tmp1.xyz, tmp2.xyz);
                tmp0.w = -tmp0.w * tmp0.w + 1.0;
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = tmp0.w * unity_LightShadowBias.z;
                tmp1.xyz = -tmp1.xyz * tmp0.www + tmp3.xyz;
                tmp0.w = unity_LightShadowBias.z != 0.0;
                tmp1.xyz = tmp0.www ? tmp1.xyz : tmp3.xyz;
                tmp4 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp4 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp4;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp4;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp3.wwww + tmp1;
                tmp0.w = unity_LightShadowBias.x / tmp1.w;
                tmp0.w = min(tmp0.w, 0.0);
                tmp0.w = max(tmp0.w, -1.0);
                tmp0.w = tmp0.w + tmp1.z;
                tmp2.x = min(tmp1.w, tmp0.w);
                tmp2.x = tmp2.x - tmp0.w;
                tmp1.z = unity_LightShadowBias.y * tmp2.x + tmp0.w;
                o.position = tmp1;
                o.texcoord3.zw = tmp1.zw;
                o.texcoord1.xy = v.texcoord.xy;
                tmp2.xyz = tmp0.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyw = unity_ObjectToWorld._m00_m10_m20 * tmp0.xxx + tmp2.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * tmp2.www + tmp0.xyz;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp1.xz = tmp1.xw * float2(0.5, 0.5);
                tmp1.w = tmp0.x * 0.5;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
                o.color = v.color;
                return o;
			}
			// Keywords: SHADOWS_DEPTH UNITY_PASS_SHADOWCASTER
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xy = inp.texcoord1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
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
                tmp1.xy = _Time.yy * _RedSpeedXYScaleZW.xy + inp.texcoord1.xy;
                tmp0.zw = tmp0.zw - tmp1.xy;
                tmp0.zw = _RedUVsRadial.xx * tmp0.zw + tmp1.xy;
                tmp0.zw = tmp0.zw * _RedSpeedXYScaleZW.zw;
                tmp1 = tex2D(_MainTexture, tmp0.zw);
                tmp0.zw = _Time.yy * _GreenSpeedXYScaleZW.xy + tmp0.xy;
                tmp0.xy = _Time.yy * _BlueSpeedXYScaleZW.xy + tmp0.xy;
                tmp1.yz = _Time.yy * _GreenSpeedXYScaleZW.xy + inp.texcoord1.xy;
                tmp0.zw = tmp0.zw - tmp1.yz;
                tmp0.zw = _GreenUVsRadial.xx * tmp0.zw + tmp1.yz;
                tmp0.zw = tmp0.zw * _GreenSpeedXYScaleZW.zw;
                tmp2 = tex2D(_MainTexture, tmp0.zw);
                tmp0.z = tmp1.x * tmp2.y;
                tmp1.xy = _Time.yy * _BlueSpeedXYScaleZW.xy + inp.texcoord1.xy;
                tmp0.xy = tmp0.xy - tmp1.xy;
                tmp0.xy = _BlueUVsRadial.xx * tmp0.xy + tmp1.xy;
                tmp0.xy = tmp0.xy * _BlueSpeedXYScaleZW.zw;
                tmp1 = tex2D(_MainTexture, tmp0.xy);
                tmp0.x = tmp0.z * tmp1.z;
                tmp1 = tex2D(_MainTexture, inp.texcoord1.xy);
                tmp0.x = tmp0.x * tmp1.w;
                tmp0.yz = inp.texcoord1.xy * _RadialMaskTilingOffset.xy + _RadialMaskTilingOffset.zw;
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
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 4.0 + -_FinalMixOldMinMaxNewMinMax.x;
                tmp0.yz = _FinalMixOldMinMaxNewMinMax.wy - _FinalMixOldMinMaxNewMinMax.zx;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x / tmp0.z;
                tmp0.x = saturate(tmp0.x + _FinalMixOldMinMaxNewMinMax.z);
                tmp0.y = inp.texcoord3.w + 0.0;
                tmp0.yzw = inp.texcoord3.zxy / tmp0.yyy;
                tmp1 = tex2D(_CameraDepthTexture, tmp0.zw);
                tmp0.y = _ZBufferParams.z * tmp0.y + _ZBufferParams.w;
                tmp0.y = 1.0 / tmp0.y;
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.y = tmp0.z - tmp0.y;
                tmp0.y = tmp0.y / _DepthFade;
                tmp0.y = min(abs(tmp0.y), 1.0);
                tmp0.z = _GlowSpeed * _Time.y;
                tmp0.z = sin(tmp0.z);
                tmp0.z = tmp0.z + 1.0;
                tmp0.z = tmp0.z * 2.0 + -3.0;
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.w = _GlowMax - _GlowMin;
                tmp0.z = tmp0.z * tmp0.w + _GlowMin;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.z = tmp0.x * 0.9375;
                tmp0.xy = inp.position.xy * float2(0.25, 0.25);
                tmp0 = tex3D(_DitherMaskLOD, tmp0.xyz);
                tmp0.x = tmp0.w - 0.01;
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
	CustomEditor "ASEMaterialInspector"
}