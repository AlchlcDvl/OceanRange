Shader "SR/UI/Digital Monitor DepthOn" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_LEDCells ("LED Cells", 2D) = "white" {}
		_Resolution ("Resolution", Float) = 6
		[MaterialToggle] _Font ("Font", Float) = 0
		_BlackValue ("Black Value", Color) = (0.2,0.1372549,0.1568628,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+502" "RenderType" = "Overlay" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+502" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Offset -1, 2
			GpuProgramID 44758
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LEDCells;
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
                tmp0.x = exp(_Resolution);
                tmp0.y = tmp0.x - 1.0;
                tmp1 = tmp0.xxxx * inp.texcoord.xyxy;
                tmp2 = floor(tmp1);
                tmp0.xz = tmp1.zw * _LEDCells_ST.xy + _LEDCells_ST.zw;
                tmp1 = tex2D(_LEDCells, tmp0.xz);
                tmp0 = tmp2 / tmp0.yyyy;
                tmp2.xy = tmp0.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp2.xy);
                tmp1.w = sin(_Time.y);
                tmp0 = tmp1.wwww * float4(0.0025, 0.0, -0.0025, 0.0) + tmp0;
                tmp0 = tmp0 * _MainTex_ST + _MainTex_ST;
                tmp3 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp0.x = tmp2.w + tmp3.w;
                tmp4.w = tmp0.w + tmp0.x;
                tmp0.x = _Font <= 0.0;
                tmp0.x = tmp0.x ? 1.0 : 0.0;
                tmp0.y = tmp3.y * tmp0.x;
                tmp2.y = _Font >= 0.0;
                tmp2.y = tmp2.y ? 1.0 : 0.0;
                tmp0.y = tmp2.y * tmp3.w + tmp0.y;
                tmp2.z = tmp3.y - tmp0.y;
                tmp3.x = tmp0.x * tmp2.y;
                tmp0.y = tmp3.x * tmp2.z + tmp0.y;
                tmp0.y = tmp0.y * tmp1.y;
                tmp5 = inp.color * _Color;
                tmp4.y = tmp0.y * tmp5.y;
                tmp0.y = tmp0.z * tmp0.x;
                tmp0.y = tmp2.y * tmp0.w + tmp0.y;
                tmp0.z = tmp0.z - tmp0.y;
                tmp0.y = tmp3.x * tmp0.z + tmp0.y;
                tmp0.y = tmp0.y * tmp1.z;
                tmp4.z = tmp5.z * tmp0.y;
                tmp0.y = tmp2.x * tmp0.x;
                tmp0.y = tmp2.y * tmp2.w + tmp0.y;
                tmp0.z = tmp2.x - tmp0.y;
                tmp0.y = tmp3.x * tmp0.z + tmp0.y;
                tmp0.y = tmp0.y * tmp1.x;
                tmp4.x = tmp5.x * tmp0.y;
                tmp4 = tmp4 * float4(1.25, 1.25, 1.25, 0.4166667);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.y = dot(tmp0.xyz, tmp0.xyz);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y + _Time.y;
                tmp6 = tmp0.yyyy * float4(0.1, 0.5, 0.6, 0.3);
                tmp0.y = tmp0.y * 0.2;
                tmp0.y = sin(tmp0.y);
                tmp0.y = abs(tmp0.y) * 20.0 + -19.0;
                tmp2.xzw = frac(tmp6.xyz);
                tmp0.z = sin(tmp6.w);
                tmp0.z = abs(tmp0.z) * 4.999999 + -4.749999;
                tmp0.yz = max(tmp0.yz, float2(0.0, 0.0));
                tmp0.w = inp.texcoord.y - 1.0;
                tmp2.xzw = tmp2.xzw * float3(2.0, 2.0, 2.0) + tmp0.www;
                tmp3.yzw = float3(1.0, 1.0, 1.0) - tmp2.xzw;
                tmp2.xzw = tmp2.xzw * tmp3.yzw;
                tmp2.xzw = saturate(tmp2.xzw * float3(66.60007, 20.0, 24.99999) + float3(-16.31702, -4.0, -5.999997));
                tmp6.xy = tmp2.xx * float2(0.025, -0.025) + inp.texcoord.xx;
                tmp6.z = inp.texcoord.y;
                tmp6 = tmp1.wwww * float4(0.0025, 0.0, -0.0025, 0.0) + tmp6.xzyz;
                tmp6 = tmp6 * _MainTex_ST + _MainTex_ST;
                tmp7 = tex2D(_MainTex, tmp6.zw);
                tmp6 = tex2D(_MainTex, tmp6.xy);
                tmp3.yz = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp8 = tex2D(_MainTex, tmp3.yz);
                tmp0.w = tmp6.w + tmp8.w;
                tmp0.w = tmp7.w + tmp0.w;
                tmp9.w = tmp5.w * tmp0.w;
                tmp10.w = 0.3333333;
                tmp0.w = tmp0.x * tmp6.y;
                tmp0.w = tmp2.y * tmp6.w + tmp0.w;
                tmp3.y = tmp6.y - tmp0.w;
                tmp9.y = tmp3.x * tmp3.y + tmp0.w;
                tmp0.w = tmp0.x * tmp7.z;
                tmp0.w = tmp2.y * tmp7.w + tmp0.w;
                tmp3.y = tmp7.z - tmp0.w;
                tmp9.z = tmp3.x * tmp3.y + tmp0.w;
                tmp0.w = tmp0.x * tmp8.x;
                tmp0.w = tmp2.y * tmp8.w + tmp0.w;
                tmp3.y = tmp8.x - tmp0.w;
                tmp9.x = tmp3.x * tmp3.y + tmp0.w;
                tmp10.xyz = tmp5.xyz;
                tmp6 = tmp9 * tmp10 + -tmp4;
                tmp3.yzw = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp0.w = tmp0.w * 0.3333333;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp4 = tmp0.wwww * tmp6 + tmp4;
                tmp2.x = tmp2.x * -0.25 + 1.0;
                tmp2.z = tmp2.w + tmp2.z;
                tmp2.z = min(tmp2.z, 1.0);
                tmp0.y = tmp0.y * tmp2.z + tmp0.z;
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.z = _Resolution * 0.5;
                tmp0.z = exp(tmp0.z);
                tmp2.z = tmp0.y * tmp0.z;
                tmp0.z = tmp2.z * -0.5 + tmp0.z;
                tmp0.z = trunc(tmp0.z);
                tmp2.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp0.z + -1.0;
                tmp6 = tmp2.zzzz * inp.texcoord.xyxy;
                tmp6 = floor(tmp6);
                tmp6 = tmp6 / tmp0.zzzz;
                tmp7 = tmp1.wwww * float4(-0.01, 0.0, 0.01, 0.0) + tmp6;
                tmp2.zw = tmp6.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp6 = tex2D(_MainTex, tmp2.zw);
                tmp7 = tmp7 * _MainTex_ST + _MainTex_ST;
                tmp8 = tex2D(_MainTex, tmp7.xy);
                tmp7 = tex2D(_MainTex, tmp7.zw);
                tmp0.z = tmp0.x * tmp8.y;
                tmp0.z = tmp2.y * tmp8.w + tmp0.z;
                tmp1.w = tmp8.y - tmp0.z;
                tmp2.z = tmp6.w + tmp8.w;
                tmp8.w = tmp7.w + tmp2.z;
                tmp9.y = tmp3.x * tmp1.w + tmp0.z;
                tmp0.z = tmp0.x * tmp7.z;
                tmp0.x = tmp0.x * tmp6.x;
                tmp0.x = tmp2.y * tmp6.w + tmp0.x;
                tmp0.z = tmp2.y * tmp7.w + tmp0.z;
                tmp1.w = tmp7.z - tmp0.z;
                tmp9.z = tmp3.x * tmp1.w + tmp0.z;
                tmp0.z = tmp6.x - tmp0.x;
                tmp9.x = tmp3.x * tmp0.z + tmp0.x;
                tmp1.xyz = tmp1.xyz * tmp9.xyz;
                tmp8.xyz = tmp10.xyz * tmp1.xyz;
                tmp9.w = tmp5.w * tmp8.w;
                tmp1 = tmp8 * float4(1.25, 1.25, 1.25, 0.4166667);
                tmp3 = tmp9 * tmp10 + -tmp1;
                tmp1 = tmp0.wwww * tmp3 + tmp1;
                tmp1 = -tmp2.xxxx * tmp4 + tmp1;
                tmp2 = tmp4 * tmp2.xxxx;
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
                o.sv_target.w = tmp0.w * inp.color.w;
                tmp0.xyz = tmp0.xyz * float3(2.2, 2.2, 2.2);
                tmp2.xyz = -tmp2.xyz * tmp2.www + float3(1.0, 1.0, 1.0);
                tmp0.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp0.xyz);
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = _LightColor0.xyz * _LightColor0.xyz;
                tmp1.xyz = _BlackValue.xyz * tmp1.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}