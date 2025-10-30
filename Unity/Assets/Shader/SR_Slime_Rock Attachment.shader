Shader "SR/Slime/Rock Attachment" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		_Diffuse ("Diffuse", 2D) = "white" {}
		_Normal ("Normal", 2D) = "bump" {}
		_SaturationMask ("Saturation Mask", 2D) = "white" {}
		_RedMask ("Red Mask", Color) = (1,0.5,0.5,1)
		_GreenMask ("Green Mask", Color) = (0.5,1,0.5,1)
		_BlueMask ("Blue Mask", Color) = (0.5,0.5,1,1)
		[MaterialToggle] _ColorMask ("Color Mask", Float) = 0
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 50160
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
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float4 _Diffuse_ST;
			float4 _Normal_ST;
			float4 _SaturationMask_ST;
			float4 _RedMask;
			float4 _GreenMask;
			float4 _BlueMask;
			float _ColorMask;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _Diffuse;
			sampler2D _SaturationMask;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
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
                tmp0.zw = float2(-1.0, 0.6666667);
                tmp1.zw = float2(1.0, -1.0);
                tmp2 = _RedMask - _BlueMask;
                tmp3.xy = inp.texcoord.xy * _SaturationMask_ST.xy + _SaturationMask_ST.zw;
                tmp3 = tex2D(_SaturationMask, tmp3.xy);
                tmp2 = tmp3.xxxx * tmp2 + _BlueMask;
                tmp4 = _GreenMask - tmp2;
                tmp2 = tmp3.yyyy * tmp4 + tmp2;
                tmp4 = _BlueMask - tmp2;
                tmp2 = tmp3.zzzz * tmp4 + tmp2;
                tmp3.w = tmp2.y >= tmp2.z;
                tmp3.w = tmp3.w ? 1.0 : 0.0;
                tmp0.xy = tmp2.zy;
                tmp1.xy = tmp2.yz - tmp0.xy;
                tmp0 = tmp3.wwww * tmp1.xywz + tmp0.xywz;
                tmp1.z = tmp0.w;
                tmp3.w = tmp2.x >= tmp0.x;
                tmp3.w = tmp3.w ? 1.0 : 0.0;
                tmp0.w = tmp2.x;
                tmp1.xyw = tmp0.wyx;
                tmp1 = tmp1 - tmp0;
                tmp0 = tmp3.wwww * tmp1 + tmp0;
                tmp1.x = min(tmp0.y, tmp0.w);
                tmp1.x = tmp0.x - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0;
                tmp0.y = tmp0.w - tmp0.y;
                tmp0.y = tmp0.y / tmp1.y;
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.yzw = abs(tmp0.yyy) + float3(-0.05, -0.3833334, 0.2833333);
                tmp0.yzw = frac(tmp0.yzw);
                tmp0.yzw = -tmp0.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.yzw = saturate(abs(tmp0.yzw) * float3(3.0, 3.0, 3.0) + float3(-1.0, -1.0, -1.0));
                tmp0.yzw = tmp0.yzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.x + 0.0;
                tmp0.x = tmp2.w * -0.75 + tmp0.x;
                tmp1.x = tmp1.x / tmp1.y;
                tmp1.x = tmp2.w * 0.75 + tmp1.x;
                tmp0.yzw = tmp1.xxx * tmp0.yzw + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp0.yzw * tmp0.xxx + tmp2.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp4.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp4 = tex2D(_Normal, tmp4.xy);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp5.xyz = tmp4.yyy * inp.texcoord4.xyz;
                tmp5.xyz = tmp4.xxx * inp.texcoord3.xyz + tmp5.xyz;
                tmp0.w = dot(tmp4.xy, tmp4.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = sqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz + tmp5.xyz;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp4.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp0.www * tmp4.xyz;
                tmp1.w = dot(tmp2.xyz, tmp5.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.w = tmp1.w * tmp1.w;
                tmp1.w = min(tmp1.w, 1.0);
                tmp5.xy = inp.texcoord.xy * _Diffuse_ST.xy + _Diffuse_ST.zw;
                tmp5 = tex2D(_Diffuse, tmp5.xy);
                tmp5.xyz = tmp1.www + tmp5.xyz;
                tmp0.xyz = tmp5.xyz * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = saturate(tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0));
                tmp6.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp1.xyz = tmp1.xyz * tmp6.xyz + _MiddleColor.xyz;
                tmp6.xyz = tmp5.xyz + tmp5.xyz;
                tmp6.xyz = saturate(tmp6.xyz);
                tmp7.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp6.xyz = tmp6.xyz * tmp7.xyz + _BottomColor.xyz;
                tmp1.xyz = tmp1.xyz - tmp6.xyz;
                tmp1.xyz = tmp5.xyz * tmp1.xyz + tmp6.xyz;
                tmp1.w = dot(tmp1.xyz, float3(0.3, 0.59, 0.11));
                tmp5.xyz = tmp1.www - tmp1.xyz;
                tmp1.xyz = tmp3.xxx * tmp5.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp1.w = tmp3.y + tmp3.x;
                tmp1.w = tmp3.z + tmp1.w;
                tmp0.xyz = tmp1.www * tmp0.xyz + tmp1.xyz;
                tmp1.w = tmp3.x * -0.5 + 0.5;
                tmp3.xyz = tmp3.xxx * float3(0.4044118, 0.3240489, 0.3003352) + tmp1.www;
                tmp5.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp6.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp5.xyz = -tmp5.xyz * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp3.xyz ? tmp5.xyz : tmp1.xyz);
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                tmp0.xyz = _ColorMask.xxx * tmp1.xyz + tmp0.xyz;
                tmp1.xyz = tmp0.xyz * float3(0.2, 0.2, 0.2);
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp2.xyz, tmp3.xyz);
                tmp3.xyz = tmp4.xyz * tmp0.www + tmp3.xyz;
                tmp0.w = max(tmp1.w, 0.0);
                tmp4.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp4.xyz = tmp0.www * _LightColor0.xyz + tmp4.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp0.w = dot(tmp3.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp0.w = tmp0.w * 32.0;
                tmp0.w = exp(tmp0.w);
                tmp2.xyz = tmp0.www * _LightColor0.xyz;
                tmp1.xyz = tmp4.xyz * tmp1.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz * float3(0.8, 0.8, 0.8) + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}