// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "SR/Actor/BillboardEcho" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("MainTex", 2D) = "white" {}
		_Wiggle ("Wiggle", Range(0, 2)) = 1
		_TintColor ("Color_copy", Color) = (1,1,1,1)
		_TilesX ("Tiles X", Float) = 16
		_TilesY ("Tiles Y", Float) = -16
		_TilesOffset ("Tiles Offset", Float) = 0
		_AnimationSpeed ("Animation Speed", Float) = 0.1
		_Brightness ("Brightness", Float) = 1
		_HueVariance ("Hue Variance", Range(0, 1)) = 0
		_HueSpeed ("Hue Speed", Float) = 1
		_testcube ("testcube", Cube) = "_Skybox" {}
		_Normal ("Normal", 2D) = "bump" {}
		_Top ("Top", Color) = (0.7867647,0.7867647,0.7867647,1)
		_Mid ("Mid", Color) = (0.5,0.5,0.5,1)
		_Bot ("Bot", Color) = (0.1838235,0.1838235,0.1838235,1)
		_Shine ("Shine", Range(0, 1)) = 0
		_MoteTexture ("MoteTexture", 2D) = "white" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "DisableBatching" = "true" "PreviewType" = "Plane" "QUEUE" = "AlphaTest" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "AlphaTest" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 29057
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
			float4 _LightColor0;
			float4 _Color;
			float4 _MainTex_ST;
			float _Wiggle;
			float4 _MoteTexture_ST;
			float4 _TintColor;
			float _TilesX;
			float _TilesY;
			float _TilesOffset;
			float _AnimationSpeed;
			float _Brightness;
			float _HueVariance;
			float _HueSpeed;
			float4 _Normal_ST;
			float4 _Top;
			float4 _Mid;
			float4 _Bot;
			float _Shine;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _MainTex;
			sampler2D _MoteTexture;
			samplerCUBE _testcube;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.x = unity_WorldToObject._m10;
                tmp0.y = unity_WorldToObject._m11;
                tmp0.z = unity_WorldToObject._m12;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.z = -1.0 / tmp0.x;
                tmp1 = unity_ObjectToWorld._m13_m13_m13_m13 * unity_MatrixV._m01_m11_m21_m31;
                tmp1 = unity_MatrixV._m00_m10_m20_m30 * unity_ObjectToWorld._m03_m03_m03_m03 + tmp1;
                tmp1 = unity_MatrixV._m02_m12_m22_m32 * unity_ObjectToWorld._m23_m23_m23_m23 + tmp1;
                tmp1 = unity_MatrixV._m03_m23_m13_m33 * unity_ObjectToWorld._m33_m33_m33_m33 + tmp1.xzyw;
                tmp0.yw = tmp1.xz;
                tmp0.z = dot(tmp0.xy, v.vertex.xy);
                tmp2 = tmp0.zzzz * UNITY_MATRIX_P._m01_m11_m21_m31;
                tmp3.x = unity_WorldToObject._m00;
                tmp3.y = unity_WorldToObject._m01;
                tmp3.z = unity_WorldToObject._m02;
                tmp0.z = dot(tmp3.xyz, tmp3.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.x = -1.0 / tmp0.z;
                tmp0.x = dot(tmp0.xy, v.vertex.xy);
                tmp0 = UNITY_MATRIX_P._m00_m10_m20_m30 * tmp0.xxxx + tmp2;
                tmp2.x = unity_WorldToObject._m20;
                tmp2.y = unity_WorldToObject._m21;
                tmp2.z = unity_WorldToObject._m22;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2.x = sqrt(tmp2.x);
                tmp1.x = -1.0 / tmp2.x;
                tmp2.x = dot(tmp1.xy, v.vertex.xy);
                tmp0 = UNITY_MATRIX_P._m02_m12_m22_m32 * tmp2.xxxx + tmp0;
                tmp2.x = unity_ObjectToWorld._m10 * unity_MatrixV._m31;
                tmp2.x = unity_MatrixV._m30 * unity_ObjectToWorld._m00 + tmp2.x;
                tmp2.x = unity_MatrixV._m32 * unity_ObjectToWorld._m20 + tmp2.x;
                tmp1.x = unity_MatrixV._m33 * unity_ObjectToWorld._m30 + tmp2.x;
                tmp2.x = unity_ObjectToWorld._m11 * unity_MatrixV._m31;
                tmp2.x = unity_MatrixV._m30 * unity_ObjectToWorld._m01 + tmp2.x;
                tmp2.x = unity_MatrixV._m32 * unity_ObjectToWorld._m21 + tmp2.x;
                tmp1.z = unity_MatrixV._m33 * unity_ObjectToWorld._m31 + tmp2.x;
                tmp2.x = unity_ObjectToWorld._m12 * unity_MatrixV._m31;
                tmp2.x = unity_MatrixV._m30 * unity_ObjectToWorld._m02 + tmp2.x;
                tmp2.x = unity_MatrixV._m32 * unity_ObjectToWorld._m22 + tmp2.x;
                tmp1.y = unity_MatrixV._m33 * unity_ObjectToWorld._m32 + tmp2.x;
                tmp1.x = dot(tmp1, v.vertex);
                o.position = UNITY_MATRIX_P._m03_m13_m23_m33 * tmp1.xxxx + tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
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
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xy = tmp0.yy * unity_MatrixV._m01_m21;
                tmp1.xy = unity_MatrixV._m00_m20 * tmp0.xx + tmp1.xy;
                tmp1.xy = unity_MatrixV._m02_m22 * tmp0.zz + tmp1.xy;
                tmp0.w = max(abs(tmp1.y), abs(tmp1.x));
                tmp0.w = 1.0 / tmp0.w;
                tmp1.z = min(abs(tmp1.y), abs(tmp1.x));
                tmp0.w = tmp0.w * tmp1.z;
                tmp1.z = tmp0.w * tmp0.w;
                tmp1.w = tmp1.z * 0.0208351 + -0.085133;
                tmp1.w = tmp1.z * tmp1.w + 0.180141;
                tmp1.w = tmp1.z * tmp1.w + -0.3302995;
                tmp1.z = tmp1.z * tmp1.w + 0.999866;
                tmp1.w = tmp0.w * tmp1.z;
                tmp1.w = tmp1.w * -2.0 + 1.570796;
                tmp2.x = abs(tmp1.y) < abs(tmp1.x);
                tmp1.w = tmp2.x ? tmp1.w : 0.0;
                tmp0.w = tmp0.w * tmp1.z + tmp1.w;
                tmp1.z = tmp1.y < -tmp1.y;
                tmp1.z = tmp1.z ? -3.141593 : 0.0;
                tmp0.w = tmp0.w + tmp1.z;
                tmp1.z = min(tmp1.y, tmp1.x);
                tmp1.x = max(tmp1.y, tmp1.x);
                tmp1.x = tmp1.x >= -tmp1.x;
                tmp1.y = tmp1.z < -tmp1.z;
                tmp1.x = tmp1.x ? tmp1.y : 0.0;
                tmp0.w = tmp1.x ? -tmp0.w : tmp0.w;
                tmp0.w = tmp0.w * 0.3183099;
                tmp0.w = 1.0 - abs(tmp0.w);
                tmp0.w = tmp0.w * 2.0 + -1.0;
                tmp1.x = _Time.y * 1.5;
                tmp1.x = sin(tmp1.x);
                tmp2.x = tmp0.w * tmp1.x;
                tmp0.w = abs(tmp1.x) * 0.5;
                tmp2.y = tmp0.w * tmp0.w;
                tmp1.yz = tmp2.xy * float2(0.1, -0.1);
                tmp2 = inp.texcoord.yxxy * float4(-1.666667, -2.0, 4.0, 4.0) + float4(1.333333, 1.0, -1.5, -1.5);
                tmp0.w = abs(tmp1.x) * tmp2.y;
                tmp1.xw = tmp0.ww * float2(0.0167, 0.0);
                tmp0.w = inp.texcoord.x * 2.0 + -1.0;
                tmp0.w = saturate(abs(tmp0.w) * -4.0 + 4.0);
                tmp1.xw = tmp0.ww * tmp1.xw;
                tmp2.x = saturate(tmp2.x);
                tmp2.yz = unity_MatrixV._m11_m11 * float2(-0.0, -0.875) + tmp2.zw;
                tmp2.yz = tmp2.yz * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp2.yz);
                tmp1.xy = tmp1.yz * tmp2.xx + tmp1.xw;
                tmp1.xy = tmp1.xy * _Wiggle.xx + inp.texcoord.xy;
                tmp1.zw = tmp1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp2 = tex2D(_MainTex, tmp1.zw);
                tmp0.w = saturate(tmp2.w * _Color.w + tmp3.w);
                tmp1.z = tmp0.w - 0.5;
                tmp0.w = 1.0 - tmp0.w;
                tmp1.z = tmp1.z < 0.0;
                if (tmp1.z) {
                    discard;
                }
                tmp1.zw = tmp1.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = saturate(tmp1.x * -10.0 + 3.5);
                tmp4 = tex2D(_Normal, tmp1.zw);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.y = dot(tmp4.xy, tmp4.xy);
                tmp1.y = min(tmp1.y, 1.0);
                tmp1.y = 1.0 - tmp1.y;
                tmp4.z = sqrt(tmp1.y);
                tmp5.x = dot(tmp4.xyz, unity_MatrixV._m00_m10_m20);
                tmp5.y = dot(tmp4.xyz, unity_MatrixV._m01_m11_m21);
                tmp5.z = dot(tmp4.xyz, unity_MatrixV._m02_m12_m22);
                tmp0.z = dot(tmp0.xyz, tmp5.xyz);
                tmp0.x = dot(inp.texcoord3.xyz, tmp5.xyz);
                tmp0.y = dot(inp.texcoord4.xyz, tmp5.xyz);
                tmp4 = texCUBE(_testcube, tmp0.xyz);
                tmp0.x = tmp1.x * tmp4.w;
                tmp0.y = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.y = tmp0.y + unity_ObjectToWorld._m23;
                tmp0.y = tmp0.y * 2.0 + _Time.y;
                tmp0.z = tmp0.y * _AnimationSpeed;
                tmp0.y = tmp0.y * _HueSpeed;
                tmp0.y = sin(tmp0.y);
                tmp0.z = frac(tmp0.z);
                tmp1.x = _TilesY * _TilesX;
                tmp0.z = tmp0.z * tmp1.x;
                tmp0.z = floor(tmp0.z);
                tmp0.z = tmp0.z + _TilesOffset;
                tmp1.xy = float2(1.0, 1.0) / float2(_TilesX.x, _TilesY.x);
                tmp1.z = tmp0.z * tmp1.x;
                tmp5.y = floor(tmp1.z);
                tmp5.x = -_TilesX * tmp5.y + tmp0.z;
                tmp1.zw = tmp5.xy + inp.texcoord.xy;
                tmp1.xy = tmp1.xy * tmp1.zw;
                tmp1.xy = tmp1.xy * _MoteTexture_ST.xy + _MoteTexture_ST.zw;
                tmp1 = tex2D(_MoteTexture, tmp1.xy);
                tmp0.z = saturate(tmp1.z);
                tmp0.z = tmp1.z + tmp0.z;
                tmp1.xyw = tmp0.zzz * inp.color.xyz;
                tmp5.xyw = tmp1.ywx * _TintColor.yzx;
                tmp0.z = tmp5.x >= tmp5.y;
                tmp0.z = tmp0.z ? 1.0 : 0.0;
                tmp6.xy = tmp5.yx;
                tmp7.xy = tmp1.yw * _TintColor.yz + -tmp6.xy;
                tmp6.zw = float2(-1.0, 0.6666667);
                tmp7.zw = float2(1.0, -1.0);
                tmp6 = tmp0.zzzz * tmp7 + tmp6;
                tmp0.z = tmp5.w >= tmp6.x;
                tmp0.z = tmp0.z ? 1.0 : 0.0;
                tmp5.xyz = tmp6.xyw;
                tmp6.xyw = tmp5.wyx;
                tmp6 = tmp6 - tmp5;
                tmp5 = tmp0.zzzz * tmp6 + tmp5;
                tmp0.z = min(tmp5.y, tmp5.w);
                tmp0.z = tmp5.x - tmp0.z;
                tmp1.x = tmp0.z * 6.0 + 0.0;
                tmp1.y = tmp5.w - tmp5.y;
                tmp1.x = tmp1.y / tmp1.x;
                tmp1.x = tmp1.x + tmp5.z;
                tmp0.y = tmp0.y * _HueVariance + abs(tmp1.x);
                tmp1.xyw = tmp0.yyy + float3(0.0, -0.3333333, 0.3333333);
                tmp1.xyw = frac(tmp1.xyw);
                tmp1.xyw = -tmp1.xyw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyw = saturate(abs(tmp1.xyw) * float3(3.0, 3.0, 3.0) + float3(-1.0, -1.0, -1.0));
                tmp1.xyw = tmp1.xyw - float3(1.0, 1.0, 1.0);
                tmp0.y = tmp5.x + 0.0;
                tmp0.y = tmp0.z / tmp0.y;
                tmp1.xyw = tmp0.yyy * tmp1.xyw + float3(1.0, 1.0, 1.0);
                tmp1.xyw = tmp5.xxx * tmp1.xyw;
                tmp0.y = tmp1.z * inp.color.w;
                tmp0.z = saturate(tmp1.z * 2.5 + -2.0);
                tmp0.y = tmp0.y * _TintColor.w;
                tmp1.xyz = tmp1.xyw * tmp0.yyy + tmp0.zzz;
                tmp0.y = tmp2.y - tmp2.x;
                tmp0.y = _Shine * tmp0.y + tmp2.x;
                tmp0.z = tmp2.w * _Color.w;
                tmp0.z = round(tmp0.z);
                tmp0.y = tmp0.w + tmp0.y;
                tmp0.w = tmp3.x + tmp0.w;
                tmp1.w = tmp3.w * 0.7 + 0.3;
                tmp1.w = round(tmp1.w);
                tmp2.xyz = _Top.xyz - _Mid.xyz;
                tmp3.xyz = tmp0.yyy * tmp2.xyz + _Mid.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz + _Mid.xyz;
                tmp0.w = saturate(tmp0.w);
                tmp5.xyz = _Mid.xyz - _Bot.xyz;
                tmp6.xyz = tmp0.yyy * tmp5.xyz + _Bot.xyz;
                tmp5.xyz = tmp0.www * tmp5.xyz + _Bot.xyz;
                tmp3.xyz = tmp3.xyz - tmp6.xyz;
                tmp3.xyz = tmp0.yyy * tmp3.xyz + tmp6.xyz;
                tmp3.xyz = tmp3.xyz * _Color.xxx;
                tmp6.xyz = tmp3.xyz * _LightColor0.xyz;
                tmp3.xyz = tmp3.xyz * float3(0.9, 0.9, 0.9);
                tmp3.xyz = tmp6.xyz * float3(0.1, 0.1, 0.1) + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * _Brightness.xxx + tmp3.xyz;
                tmp3.xyz = tmp4.xyz - tmp1.xyz;
                tmp1.xyz = tmp0.xxx * tmp3.xyz + tmp1.xyz;
                tmp2.xyz = tmp2.xyz - tmp5.xyz;
                tmp0.xyw = tmp0.www * tmp2.xyz + tmp5.xyz;
                tmp2.x = dot(tmp0.xyz, float3(0.3, 0.59, 0.11));
                tmp2.xyz = tmp2.xxx - tmp0.xyw;
                tmp0.xyw = inp.texcoord.yyy * tmp2.xyz + tmp0.xyw;
                tmp0.xyw = tmp0.xyw - tmp1.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp2.x = dot(tmp2.xyz, tmp2.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.x = round(tmp2.x);
                tmp2.x = 1.0 - tmp2.x;
                tmp2.x = tmp1.w * tmp2.x;
                tmp0.z = saturate(tmp0.z * tmp2.x);
                tmp0.z = tmp0.z - tmp1.w;
                tmp0.z = min(abs(tmp0.z), 1.0);
                o.sv_target.xyz = tmp0.zzz * tmp0.xyw + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}