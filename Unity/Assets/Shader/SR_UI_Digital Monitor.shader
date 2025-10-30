Shader "SR/UI/Digital Monitor" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_LEDCells ("LED Cells", 2D) = "white" {}
		_Resolution ("Resolution", Float) = 6
		[MaterialToggle] _Font ("Font", Float) = 0
		_BlackValue ("Black Value", Color) = (0.2,0.1372549,0.1568628,1)
		_TileAnimWidth ("TileAnim Width", Float) = 1
		_TileAnimHeight ("TileAnim Height", Float) = 1
		_TileAnimSpeed ("TileAnim Speed", Float) = 0
		_Noise ("Noise", 2D) = "black" {}
		_NoiseStrength ("Noise Strength", Float) = 0.01
		_NoiseSpeed ("Noise Speed", Float) = 1
		_NoiseAmount ("Noise Amount", Range(0, 1)) = 0
		_CycleLength ("Cycle Length", Float) = 1
		_CycleRatio ("Cycle Ratio", Float) = 1
		[MaterialToggle] _TileAnimOverride ("TileAnim Override", Float) = 0
		_TileAnimOverrideFrame ("TileAnim Override Frame", Float) = 0
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "AlphaTest" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "AlphaTest" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Offset -1, 2
			GpuProgramID 34831
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _MainTex_ST;
			float4 _Color;
			float4 _LEDCells_ST;
			float _Resolution;
			float _Font;
			float4 _BlackValue;
			float _TileAnimWidth;
			float _TileAnimHeight;
			float _TileAnimSpeed;
			float4 _Noise_ST;
			float _NoiseStrength;
			float _NoiseSpeed;
			float _NoiseAmount;
			float _CycleLength;
			float _CycleRatio;
			float _TileAnimOverride;
			float _TileAnimOverrideFrame;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LEDCells;
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
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
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
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                float4 tmp11;
                tmp0.x = _TileAnimSpeed * _Time.y;
                tmp0.x = _TileAnimOverride * -tmp0.x + tmp0.x;
                tmp0.x = frac(tmp0.x);
                tmp0.y = _TileAnimHeight * _TileAnimWidth;
                tmp0.x = tmp0.y * tmp0.x + _TileAnimOverrideFrame;
                tmp0.x = floor(tmp0.x);
                tmp0.yz = float2(1.0, 1.0) / float2(_TileAnimWidth.x, _TileAnimHeight.x);
                tmp0.w = tmp0.y * tmp0.x;
                tmp1.w = floor(tmp0.w);
                tmp1.z = -_TileAnimWidth * tmp1.w + tmp0.x;
                tmp0.xw = tmp1.zw + inp.texcoord.xy;
                tmp1.zw = tmp0.yz * tmp0.xw;
                tmp2.x = exp(_Resolution);
                tmp2.yz = tmp2.xx * float2(_TileAnimWidth.x, _TileAnimHeight.x);
                tmp3 = tmp1.zwzw * tmp2.yzyz;
                tmp3 = floor(tmp3);
                tmp4 = tmp2.xxxx * float4(_TileAnimWidth.xx, _TileAnimHeight.xx) + float4(-1.0, -1.0, -1.0, -1.0);
                tmp2.xy = tmp2.xx * inp.texcoord.xy;
                tmp2.xy = tmp2.xy * _LEDCells_ST.xy + _LEDCells_ST.zw;
                tmp2 = tex2D(_LEDCells, tmp2.xy);
                tmp3 = tmp3 / tmp4;
                tmp2.w = _NoiseSpeed * _Time.y;
                tmp2.w = frac(tmp2.w);
                tmp2.w = tmp2.w * 64.0;
                tmp2.w = floor(tmp2.w);
                tmp4.x = tmp2.w * 0.125;
                tmp4.y = floor(tmp4.x);
                tmp4.x = -tmp4.y * 8.0 + tmp2.w;
                tmp4.xy = tmp4.xy + inp.texcoord.xy;
                tmp4.xy = tmp4.xy * _Noise_ST.xy;
                tmp4.xy = tmp4.xy * float2(0.125, 0.125) + _Noise_ST.zw;
                tmp4 = tex2D(_Noise, tmp4.xy);
                tmp2.w = tmp4.x * _NoiseStrength;
                tmp4.yz = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp4.yz = saturate(abs(tmp4.yz) * float2(-2.0, -2.0) + float2(2.0, 2.0));
                tmp4.y = tmp4.z * tmp4.y;
                tmp4.zw = tmp2.ww * tmp4.yy + tmp3.zw;
                tmp4.zw = tmp4.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp5 = tex2D(_MainTex, tmp4.zw);
                tmp4.z = sin(_Time.y);
                tmp3 = tmp4.zzzz * float4(0.0025, 0.0, -0.0025, 0.0) + tmp3;
                tmp3 = tmp2.wwww * tmp4.yyyy + tmp3;
                tmp3 = tmp3 * _MainTex_ST + _MainTex_ST;
                tmp6 = tex2D(_MainTex, tmp3.xy);
                tmp3 = tex2D(_MainTex, tmp3.zw);
                tmp3.x = tmp5.w + tmp6.w;
                tmp7.w = tmp3.w + tmp3.x;
                tmp3.x = _Font <= 0.0;
                tmp3.x = tmp3.x ? 1.0 : 0.0;
                tmp3.y = tmp5.x * tmp3.x;
                tmp4.w = _Font >= 0.0;
                tmp4.w = tmp4.w ? 1.0 : 0.0;
                tmp3.y = tmp4.w * tmp5.w + tmp3.y;
                tmp5.x = tmp5.x - tmp3.y;
                tmp5.y = tmp3.x * tmp4.w;
                tmp3.y = tmp5.y * tmp5.x + tmp3.y;
                tmp3.y = tmp2.x * tmp3.y;
                tmp8 = inp.color * _Color;
                tmp7.x = tmp3.y * tmp8.x;
                tmp3.y = tmp6.y * tmp3.x;
                tmp3.y = tmp4.w * tmp6.w + tmp3.y;
                tmp5.x = tmp6.y - tmp3.y;
                tmp3.y = tmp5.y * tmp5.x + tmp3.y;
                tmp3.y = tmp2.y * tmp3.y;
                tmp7.y = tmp8.y * tmp3.y;
                tmp3.y = tmp3.z * tmp3.x;
                tmp3.y = tmp4.w * tmp3.w + tmp3.y;
                tmp3.z = tmp3.z - tmp3.y;
                tmp3.y = tmp5.y * tmp3.z + tmp3.y;
                tmp3.y = tmp2.z * tmp3.y;
                tmp7.z = tmp8.z * tmp3.y;
                tmp6 = tmp7 * float4(1.25, 1.25, 1.25, 0.4166667);
                tmp3.y = tmp2.w * tmp4.y;
                tmp0.xy = tmp0.xw * tmp0.yz + tmp3.yy;
                tmp0.xy = tmp0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp0 = tex2D(_MainTex, tmp0.xy);
                tmp3.yzw = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.y = dot(tmp3.xyz, tmp3.xyz);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y + _Time.y;
                tmp7 = tmp0.yyyy * float4(0.1, 0.5, 0.6, 0.3);
                tmp0.y = tmp0.y * 0.2;
                tmp0.y = sin(tmp0.y);
                tmp0.y = abs(tmp0.y) * 20.0 + -19.0;
                tmp3.yzw = frac(tmp7.xyz);
                tmp0.z = sin(tmp7.w);
                tmp0.z = abs(tmp0.z) * 4.999999 + -4.749999;
                tmp0.yz = max(tmp0.yz, float2(0.0, 0.0));
                tmp5.x = inp.texcoord.y - 1.0;
                tmp3.yzw = tmp3.yzw * float3(2.0, 2.0, 2.0) + tmp5.xxx;
                tmp5.xzw = float3(1.0, 1.0, 1.0) - tmp3.yzw;
                tmp3.yzw = tmp3.yzw * tmp5.xzw;
                tmp3.yzw = saturate(tmp3.yzw * float3(66.60007, 20.0, 24.99999) + float3(-16.31702, -4.0, -5.999997));
                tmp1.xy = tmp3.yy * float2(0.025, -0.025) + tmp1.zz;
                tmp7 = tmp4.zzzz * float4(0.0025, 0.0, -0.0025, 0.0) + tmp1.xwyw;
                tmp7 = tmp2.wwww * tmp4.yyyy + tmp7;
                tmp7 = tmp7 * _MainTex_ST + _MainTex_ST;
                tmp9 = tex2D(_MainTex, tmp7.xy);
                tmp7 = tex2D(_MainTex, tmp7.zw);
                tmp1.x = tmp0.w + tmp9.w;
                tmp1.x = tmp7.w + tmp1.x;
                tmp10.w = tmp8.w * tmp1.x;
                tmp1.x = tmp3.x * tmp9.y;
                tmp1.x = tmp4.w * tmp9.w + tmp1.x;
                tmp1.y = tmp9.y - tmp1.x;
                tmp10.y = tmp5.y * tmp1.y + tmp1.x;
                tmp1.x = tmp3.x * tmp7.z;
                tmp1.x = tmp4.w * tmp7.w + tmp1.x;
                tmp1.y = tmp7.z - tmp1.x;
                tmp10.z = tmp5.y * tmp1.y + tmp1.x;
                tmp1.x = tmp0.x * tmp3.x;
                tmp0.w = tmp4.w * tmp0.w + tmp1.x;
                tmp0.x = tmp0.x - tmp0.w;
                tmp10.x = tmp5.y * tmp0.x + tmp0.w;
                tmp7.w = 0.3333333;
                tmp7.xyz = tmp8.xyz;
                tmp9 = tmp10 * tmp7 + -tmp6;
                tmp5.xzw = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp5.xyz, tmp5.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 0.3333333;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp6 = tmp0.xxxx * tmp9 + tmp6;
                tmp0.w = tmp3.y * -0.25 + 1.0;
                tmp1.x = tmp3.w + tmp3.z;
                tmp1.x = min(tmp1.x, 1.0);
                tmp0.y = tmp0.y * tmp1.x + tmp0.z;
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.z = _Resolution * 0.5;
                tmp0.z = exp(tmp0.z);
                tmp1.x = tmp0.y * tmp0.z;
                tmp0.z = tmp1.x * -0.5 + tmp0.z;
                tmp0.z = trunc(tmp0.z);
                tmp1.x = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp0.z + -1.0;
                tmp1 = tmp1.xxxx * tmp1.zwzw;
                tmp1 = floor(tmp1);
                tmp1 = tmp1 / tmp0.zzzz;
                tmp9 = tmp4.zzzz * float4(-0.01, 0.0, 0.01, 0.0) + tmp1;
                tmp1.xy = tmp2.ww * tmp4.yy + tmp1.zw;
                tmp9 = tmp2.wwww * tmp4.yyyy + tmp9;
                tmp9 = tmp9 * _MainTex_ST + _MainTex_ST;
                tmp1.xy = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp1.xy);
                tmp10 = tex2D(_MainTex, tmp9.xy);
                tmp9 = tex2D(_MainTex, tmp9.zw);
                tmp0.z = tmp3.x * tmp10.y;
                tmp0.z = tmp4.w * tmp10.w + tmp0.z;
                tmp1.y = tmp10.y - tmp0.z;
                tmp1.z = tmp1.w + tmp10.w;
                tmp10.w = tmp9.w + tmp1.z;
                tmp11.y = tmp5.y * tmp1.y + tmp0.z;
                tmp0.z = tmp3.x * tmp9.z;
                tmp1.y = tmp1.x * tmp3.x;
                tmp1.y = tmp4.w * tmp1.w + tmp1.y;
                tmp0.z = tmp4.w * tmp9.w + tmp0.z;
                tmp1.z = tmp9.z - tmp0.z;
                tmp11.z = tmp5.y * tmp1.z + tmp0.z;
                tmp0.z = tmp1.x - tmp1.y;
                tmp11.x = tmp5.y * tmp0.z + tmp1.y;
                tmp1.xyz = tmp2.xyz * tmp11.xyz;
                tmp10.xyz = tmp7.xyz * tmp1.xyz;
                tmp11.w = tmp8.w * tmp10.w;
                tmp1 = tmp10 * float4(1.25, 1.25, 1.25, 0.4166667);
                tmp2 = tmp11 * tmp7 + -tmp1;
                tmp1 = tmp0.xxxx * tmp2 + tmp1;
                tmp1 = -tmp0.wwww * tmp6 + tmp1;
                tmp2 = tmp6 * tmp0.wwww;
                tmp0 = tmp0.yyyy * tmp1 + tmp2;
                tmp1.xyz = tmp0.xyz > float3(0.4545454, 0.4545454, 0.4545454);
                tmp2.xyz = tmp0.xyz * float3(1.1, 1.1, 1.1) + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.w = inp.texcoord1.x + _Time.w;
                tmp1.w = tmp1.w + inp.texcoord1.y;
                tmp1.w = tmp1.w + inp.texcoord1.z;
                tmp1.w = sin(tmp1.w);
                tmp1.w = tmp1.w * 0.05 + 0.5;
                tmp2.w = 1.0 - tmp1.w;
                tmp0.xyz = tmp0.xyz * tmp1.www;
                tmp0.w = tmp0.w * _Color.w;
                tmp0.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * float3(2.2, 2.2, 2.2);
                tmp2.xyz = -tmp2.xyz * tmp2.www + float3(1.0, 1.0, 1.0);
                tmp0.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp0.xyz);
                tmp1.xyz = tmp4.xxx - tmp0.xyz;
                tmp0.xyz = _NoiseAmount.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = _LightColor0.xyz * _LightColor0.xyz;
                tmp1.xyz = _BlackValue.xyz * tmp1.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                tmp0.x = _CycleLength + 0.001;
                tmp0.x = _Time.y / tmp0.x;
                tmp0.x = frac(tmp0.x);
                tmp0.y = tmp0.x >= _CycleRatio;
                tmp0.x = _CycleRatio >= tmp0.x;
                tmp0.yz = tmp0.yx ? 1.0 : 0.0;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = -tmp0.y;
                tmp0.x = tmp0.x ? tmp0.y : 0.0;
                tmp0.x = tmp0.x + tmp0.z;
                o.sv_target.w = tmp0.x * tmp0.w;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}