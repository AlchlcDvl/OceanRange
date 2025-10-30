Shader "SR/Actor/Mouth" {
	Properties {
		_XWiggleSpeed ("X Wiggle Speed", Float) = 10
		_YWiggleSpeed ("Y Wiggle Speed", Float) = -10
		_WiggleAmplitude ("Wiggle Amplitude", Float) = 0.005
		_YScaleSpeed ("Y Scale Speed", Float) = -5
		_XScaleSpeed ("X Scale Speed", Float) = 5
		_ ("-", Float) = 0.1
		_MouthRamp ("Mouth Ramp", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_UnscaledTime ("Unscaled Time", Float) = 0
		_Mask2 ("Mask2", 2D) = "white" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+500" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+500" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			Offset -1, -1
			GpuProgramID 60183
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _TimeEditor;
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			float _;
			float _XScaleSpeed;
			float _YScaleSpeed;
			float4 _MouthRamp_ST;
			float4 _Mask_ST;
			float4 _Color;
			float _UnscaledTime;
			float4 _Mask2_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Mask2;
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
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord3.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord4.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord5.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.xy = _TimeEditor.yw + _Time.yw;
                tmp0.y = _UnscaledTime * 3.0 + tmp0.y;
                tmp0.x = tmp0.x + _UnscaledTime;
                tmp0.y = tmp0.y * 0.111;
                tmp0.y = sin(tmp0.y);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = min(tmp0.y, 0.05);
                tmp0.y = tmp0.y * 20.0;
                tmp0.zw = tmp0.xx * float2(_XScaleSpeed.x, _YScaleSpeed.x);
                tmp1.xy = tmp0.xx * float2(_XWiggleSpeed.x, _YWiggleSpeed.x);
                tmp1.xy = sin(tmp1.xy);
                tmp1.xy = _WiggleAmplitude.xx * tmp1.xy + inp.texcoord1.xy;
                tmp0.xz = sin(tmp0.zw);
                tmp1.zw = tmp0.xz * _.xx + float2(1.0, 1.0);
                tmp0.xz = tmp0.xz * _.xx;
                tmp1.zw = tmp1.zw * inp.texcoord1.xy;
                tmp0.xz = tmp0.xz * float2(-0.5, -0.5) + tmp1.zw;
                tmp0.xz = tmp1.xy + tmp0.xz;
                tmp1.zw = tmp0.xz * float2(0.5, 0.5);
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp3.y = dot(inp.texcoord4.xyz, tmp2.xyz);
                tmp1.y = tmp3.y * -0.175 + tmp1.z;
                tmp0.zw = tmp1.yw * _Mask_ST.xy + _Mask_ST.zw;
                tmp1.yz = tmp1.yw * _Mask2_ST.xy + _Mask2_ST.zw;
                tmp4 = tex2D(_Mask2, tmp1.yz);
                tmp5 = tex2D(_Mask, tmp0.zw);
                tmp0.z = tmp5.w - tmp4.w;
                tmp0.z = tmp0.y * tmp0.z + tmp4.w;
                tmp0.z = _Color.w * tmp0.z + -0.5;
                tmp0.z = tmp0.z < 0.0;
                if (tmp0.z) {
                    discard;
                }
                tmp3.z = dot(inp.texcoord5.xyz, tmp2.xyz);
                tmp1.x = tmp3.y * -0.175;
                tmp1.yz = tmp3.yz * float2(-0.0225, -0.0225) + tmp1.xw;
                tmp0.zw = tmp3.yz * float2(-0.425, -0.425) + inp.texcoord.xy;
                tmp0.zw = tmp0.zw * _MouthRamp_ST.xy + _MouthRamp_ST.zw;
                tmp3 = tex2D(_MouthRamp, tmp0.zw);
                tmp1.x = tmp0.x * 0.5 + tmp1.y;
                tmp0.xz = tmp1.xz * _Mask_ST.xy + _Mask_ST.zw;
                tmp1.xy = tmp1.xz * _Mask2_ST.xy + _Mask2_ST.zw;
                tmp1 = tex2D(_Mask2, tmp1.xy);
                tmp4 = tex2D(_Mask, tmp0.xz);
                tmp0.x = tmp4.w - tmp1.w;
                tmp0.x = tmp0.y * tmp0.x + tmp1.w;
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * inp.texcoord3.xyz;
                tmp0.y = dot(tmp0.xyz, tmp2.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = -tmp0.y * tmp0.y + 1.0;
                tmp0.y = tmp0.y * tmp0.y;
                tmp1.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp1.xyz = -tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _LightColor0.xyz;
                tmp2.xyz = tmp2.xyz + float3(0.2132353, 0.1489511, 0.1489511);
                tmp2.xyz = max(tmp2.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = min(tmp2.xyz, float3(0.5, 0.5, 0.5));
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp2.xyz = tmp3.xyz * tmp2.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp1.xyz = -tmp1.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp3.xyz ? tmp1.xyz : tmp2.xyz);
                tmp2.xyz = tmp1.xyz - float3(0.1764706, 0.0, 0.0816506);
                tmp0.yzw = tmp0.yyy * tmp2.xyz + float3(0.1764706, 0.0, 0.0816506);
                tmp1.xyz = tmp1.xyz * float3(1.5, 1.5, 1.5) + -tmp0.yzw;
                tmp0.xyz = tmp0.xxx * tmp1.xyz + tmp0.yzw;
                o.sv_target.xyz = tmp0.xyz * _Color.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent+500" "RenderType" = "Transparent" }
			Blend One One, One One
			Offset -1, -1
			GpuProgramID 110898
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
				float3 texcoord6 : TEXCOORD6;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float _XWiggleSpeed;
			float _YWiggleSpeed;
			float _WiggleAmplitude;
			float _;
			float _XScaleSpeed;
			float _YScaleSpeed;
			float4 _Mask_ST;
			float4 _Color;
			float _UnscaledTime;
			float4 _Mask2_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Mask2;
			sampler2D _Mask;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = v.normal.xyz * float3(0.001, 0.001, 0.001) + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                o.texcoord2 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord3.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord4.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord5.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord6.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(inp.texcoord4.xyz, tmp0.xyz);
                tmp0.yz = _TimeEditor.yw + _Time.yw;
                tmp0.y = tmp0.y + _UnscaledTime;
                tmp0.z = _UnscaledTime * 3.0 + tmp0.z;
                tmp0.z = tmp0.z * 0.111;
                tmp0.z = sin(tmp0.z);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = min(tmp0.z, 0.05);
                tmp0.z = tmp0.z * 20.0;
                tmp1.xy = tmp0.yy * float2(_XScaleSpeed.x, _YScaleSpeed.x);
                tmp0.yw = tmp0.yy * float2(_XWiggleSpeed.x, _YWiggleSpeed.x);
                tmp0.yw = sin(tmp0.yw);
                tmp0.yw = _WiggleAmplitude.xx * tmp0.yw + inp.texcoord1.xy;
                tmp1.xy = sin(tmp1.xy);
                tmp1.zw = tmp1.xy * _.xx + float2(1.0, 1.0);
                tmp1.xy = tmp1.xy * _.xx;
                tmp1.zw = tmp1.zw * inp.texcoord1.xy;
                tmp1.xy = tmp1.xy * float2(-0.5, -0.5) + tmp1.zw;
                tmp0.yw = tmp0.yw + tmp1.xy;
                tmp1.yz = tmp0.yw * float2(0.5, 0.5);
                tmp1.x = tmp0.x * -0.175 + tmp1.y;
                tmp0.xy = tmp1.xz * _Mask_ST.xy + _Mask_ST.zw;
                tmp1.xy = tmp1.xz * _Mask2_ST.xy + _Mask2_ST.zw;
                tmp1 = tex2D(_Mask2, tmp1.xy);
                tmp2 = tex2D(_Mask, tmp0.xy);
                tmp0.x = tmp2.w - tmp1.w;
                tmp0.x = tmp0.z * tmp0.x + tmp1.w;
                tmp0.x = _Color.w * tmp0.x + -0.5;
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
	CustomEditor "ShaderForgeMaterialInspector"
}