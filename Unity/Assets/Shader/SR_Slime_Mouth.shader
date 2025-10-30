Shader "SR/Slime/Mouth" {
	Properties {
		_XWiggleSpeed ("X Wiggle Speed", Float) = 10
		_YWiggleSpeed ("Y Wiggle Speed", Float) = -10
		_WiggleAmplitude ("Wiggle Amplitude", Float) = 0.005
		_YScaleSpeed ("Y Scale Speed", Float) = -5
		_XScaleSpeed ("X Scale Speed", Float) = 5
		_ ("-", Float) = 0.1
		_MouthRamp ("Mouth Ramp", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_Drips ("Drips", 2D) = "black" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+1" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "AlphaTest+1" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Offset -1, -1
			GpuProgramID 11417
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			float _;
			float _XScaleSpeed;
			float _YScaleSpeed;
			float4 _MouthRamp_ST;
			float4 _Mask_ST;
			float4 _Drips_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Drips;
			sampler2D _Mask;
			sampler2D _MouthRamp;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = v.normal.xyz * float3(0.001, 0.001, 0.001) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = saturate(-tmp0.x * tmp0.y + 1.0);
                tmp0.x = -tmp0.x * tmp0.x + 1.0;
                tmp0.zw = _Time.yy * float2(0.01, 0.3) + inp.texcoord.xy;
                tmp0.zw = tmp0.zw * _Drips_ST.xy + _Drips_ST.zw;
                tmp2 = tex2D(_Drips, tmp0.zw);
                tmp2.y = tmp2.x * 0.025;
                tmp3.x = dot(inp.texcoord3.xyz, tmp1.xyz);
                tmp3.y = dot(inp.texcoord4.xyz, tmp1.xyz);
                tmp0.zw = tmp3.xy * float2(-0.035, -0.035) + inp.texcoord.xy;
                tmp2.x = 0.0;
                tmp0.zw = tmp0.zw + tmp2.xy;
                tmp1.xy = float2(_XScaleSpeed.x, _YScaleSpeed.x) * _Time.yy;
                tmp1.xy = sin(tmp1.xy);
                tmp1.zw = tmp1.xy * _.xx + float2(1.0, 1.0);
                tmp1.xy = tmp1.xy * _.xx;
                tmp1.zw = tmp0.zw * tmp1.zw;
                tmp1.xy = tmp1.xy * float2(-0.5, -0.5) + tmp1.zw;
                tmp1.zw = float2(_XWiggleSpeed.x, _YWiggleSpeed.x) * _Time.yy;
                tmp1.zw = sin(tmp1.zw);
                tmp1.zw = _WiggleAmplitude.xx * tmp1.zw + tmp0.zw;
                tmp0.zw = tmp3.xy * float2(-0.525, -0.525) + tmp0.zw;
                tmp0.zw = tmp0.zw * _MouthRamp_ST.xy + _MouthRamp_ST.zw;
                tmp2 = tex2D(_MouthRamp, tmp0.zw);
                tmp0.zw = tmp1.zw + tmp1.xy;
                tmp0.zw = tmp0.zw * float2(0.5, 0.5);
                tmp1.xy = tmp0.zw * _Mask_ST.xy + _Mask_ST.zw;
                tmp0.zw = tmp3.xy * float2(-0.03, -0.03) + tmp0.zw;
                tmp0.zw = tmp0.zw * _Mask_ST.xy + _Mask_ST.zw;
                tmp3 = tex2D(_Mask, tmp0.zw);
                tmp1 = tex2D(_Mask, tmp1.xy);
                tmp0.y = tmp0.y * tmp1.w;
                tmp0.y = tmp0.y * inp.color.y + -0.5;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.yzw = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp1.xyz = -tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + float3(0.2132353, 0.1489511, 0.1489511);
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp3.xyz = min(tmp3.xyz, float3(0.5, 0.5, 0.5));
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp1.xyz = -tmp1.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp0.yzw = saturate(tmp0.yzw ? tmp1.xyz : tmp2.xyz);
                tmp1.xyz = tmp0.yzw - float3(0.1764706, 0.0, 0.0816506);
                tmp1.w = tmp0.x * tmp0.x;
                tmp0.x = max(tmp0.x, 0.5);
                tmp0.x = min(tmp0.x, 0.501);
                tmp0.x = tmp0.x * 1000.013 + -500.0064;
                tmp0.x = -tmp3.w * tmp0.x + 1.0;
                tmp1.xyz = tmp1.www * tmp1.xyz + float3(0.1764706, 0.0, 0.0816506);
                tmp0.yzw = tmp0.yzw * float3(1.5, 1.5, 1.5) + -tmp1.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}