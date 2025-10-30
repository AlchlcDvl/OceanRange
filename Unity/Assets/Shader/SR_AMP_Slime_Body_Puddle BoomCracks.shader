Shader "SR/AMP/Slime/Body/Puddle BoomCracks" {
	Properties {
		_CrackNoise ("Crack Noise", 2D) = "white" {}
		[Toggle(_UNSCALEDTIME_ON)] _UnscaledTime ("Unscaled Time?", Float) = 0
		_CrackNoiseSpeed ("Crack Noise Speed", Float) = 1
		_Cracks ("Cracks", Cube) = "black" {}
		_Gloss ("Gloss", Range(0, 2)) = 0
		_CrackAmount ("Crack Amount", Range(0, 1)) = 1
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_Char ("Char Amount", Range(0, 1)) = 0
		_CrackColor ("Crack Color", Color) = (1,0.51,0,1)
		_CrackColorRange ("Crack Color Range", Range(-0.15, 0.15)) = 0.1
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		_VertexOffset ("Vertex Offset", Float) = 0.3
		_VertexNoise ("Vertex Noise", 2D) = "black" {}
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 61475
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _VertexOffset;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _CrackColorRange;
			float4 _CrackColor;
			float _CrackNoiseSpeed;
			float4 _CrackNoise_ST;
			float _CrackAmount;
			float4 _BottomColor;
			float4 _MiddleColor;
			float _Gloss;
			float _GlossPower;
			float4 _TopColor;
			float _Char;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _VertexNoise;
			// Texture params for Fragment Shader
			sampler2D _CrackNoise;
			samplerCUBE _Cracks;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.yy * unity_ObjectToWorld._m21_m01;
                tmp0.xy = unity_ObjectToWorld._m20_m00 * v.vertex.xx + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m22_m02 * v.vertex.zz + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m23_m03 * v.vertex.ww + tmp0.xy;
                tmp0.xy = _Time.yy * float2(0.1, 0.1) + tmp0.xy;
                tmp0 = tex2Dlod(_VertexNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.y = v.texcoord.y - 0.2;
                tmp0.y = saturate(tmp0.y * -4.0 + 1.0);
                tmp0.x = tmp0.y * tmp0.x;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp0.zwy * float3(1.0, 0.0, 1.0);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _VertexOffset.xxx + v.vertex.xyz;
                tmp2 = tmp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord1.w = tmp1.x;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = tmp0.yzw * tmp2.xyz;
                tmp3.xyz = tmp0.wyz * tmp2.yzx + -tmp3.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord1.y = tmp3.x;
                o.texcoord1.z = tmp0.z;
                o.texcoord1.x = tmp2.z;
                o.texcoord2.x = tmp2.x;
                o.texcoord3.x = tmp2.y;
                o.texcoord2.z = tmp0.w;
                o.texcoord3.z = tmp0.y;
                o.texcoord2.w = tmp1.y;
                o.texcoord3.w = tmp1.z;
                o.texcoord2.y = tmp3.y;
                o.texcoord3.y = tmp3.z;
                o.texcoord5 = float4(0.0, 0.0, 0.0, 0.0);
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
                tmp0.x = inp.texcoord1.w;
                tmp0.y = inp.texcoord2.w;
                tmp0.z = inp.texcoord3.w;
                tmp0.xyz = _WorldSpaceCameraPos - tmp0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = max(tmp0.w, 0.001);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.xyz * tmp0.www + float3(0.0, 1.0, 0.0);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.x = inp.texcoord1.z;
                tmp2.y = inp.texcoord2.z;
                tmp2.z = inp.texcoord3.z;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(tmp2.xyz, tmp0.xyz);
                tmp0.x = dot(tmp3.xyz, tmp0.xyz);
                tmp0.y = dot(tmp3.xyz, tmp1.xyz);
                tmp0.y = tmp0.y + 1.0;
                tmp0.y = tmp0.y * 0.5;
                tmp0.y = log(tmp0.y);
                tmp0.xz = float2(1.0, 1.0) - tmp0.xw;
                tmp0.w = _GlossPower * 16.0 + -1.0;
                tmp0.w = exp(tmp0.w);
                tmp0.y = tmp0.y * tmp0.w;
                tmp0.y = exp(tmp0.y);
                tmp0.w = tmp0.y * tmp0.y;
                tmp0.w = tmp0.w * _Gloss;
                tmp0.y = tmp0.y * tmp0.w;
                tmp0.w = inp.texcoord2.z + 1.0;
                tmp0.w = saturate(tmp0.w * 0.375 + -0.5);
                tmp0.w = tmp0.z * tmp0.z + tmp0.w;
                tmp0.z = tmp0.z * -1.5 + 1.5;
                tmp0.w = tmp0.y * 0.625 + tmp0.w;
                tmp1.x = tmp0.x * tmp0.x;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp0.x * tmp1.x;
                tmp0.w = saturate(tmp1.x * 0.5 + tmp0.w);
                tmp1.x = tmp0.w * 2.0 + -1.0;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.yzw = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _TopColor.xyz;
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.yzw = _TopColor.www * tmp1.yzw + tmp2.xyz;
                tmp3.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _MiddleColor.xyz;
                tmp3.xyz = _MiddleColor.www * tmp3.xyz + tmp2.xyz;
                tmp1.yzw = tmp1.yzw - tmp3.xyz;
                tmp1.yzw = tmp0.www * tmp1.yzw + tmp3.xyz;
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _BottomColor.xyz;
                tmp4.xyz = _BottomColor.www * tmp4.xyz + tmp2.xyz;
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp3.xyz = tmp0.www * tmp3.xyz + tmp4.xyz;
                tmp1.yzw = tmp1.yzw - tmp3.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + tmp3.xyz;
                tmp3.xyz = tmp0.yyy * float3(0.625, 0.625, 0.625) + tmp1.xyz;
                tmp3.xyz = -tmp2.xyz * tmp1.xyz + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp1.xyz = tmp3.xyz * float3(0.8, 0.8, 0.8) + tmp1.xyz;
                tmp0.y = dot(tmp1.xyz, float3(0.299, 0.587, 0.114));
                tmp2.xyz = tmp0.yyy - tmp1.xyz;
                tmp2.xyz = tmp2.xyz * float3(0.5, 0.5, 0.5) + tmp1.xyz;
                tmp3.xyz = inp.texcoord2.zzz * unity_WorldToObject._m01_m11_m21;
                tmp3.xyz = unity_WorldToObject._m00_m10_m20 * inp.texcoord1.zzz + tmp3.xyz;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * inp.texcoord3.zzz + tmp3.xyz;
                tmp0.yw = inp.texcoord.xy * _CrackNoise_ST.xy + _CrackNoise_ST.zw;
                tmp1.w = _CrackNoiseSpeed * _Time.y;
                tmp0.yw = tmp1.ww * float2(0.06, -3.0) + tmp0.yw;
                tmp4 = tex2D(_CrackNoise, tmp0.yw);
                tmp0.y = tmp4.x * 2.0 + -1.0;
                tmp0.y = tmp0.y * _CrackAmount;
                tmp3.xyz = tmp0.yyy * float3(0.03, 0.03, 0.03) + tmp3.xyz;
                tmp3 = texCUBE(_Cracks, tmp3.xyz);
                tmp0.y = tmp3.x * -0.25 + 1.0;
                tmp0.z = tmp0.z * tmp3.x;
                tmp0.z = tmp0.z * _CrackAmount;
                tmp2.xyz = tmp2.xyz * tmp0.yyy;
                tmp2.xyz = tmp2.xyz * float3(0.75, 0.75, 0.75) + -tmp1.xyz;
                tmp1.xyw = _Char.xxx * tmp2.yzx + tmp1.yzx;
                tmp0.y = tmp1.x >= tmp1.y;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp2.xy = tmp1.yx;
                tmp3.xy = tmp1.xy - tmp2.xy;
                tmp2.zw = float2(-1.0, 0.6666667);
                tmp3.zw = float2(1.0, -1.0);
                tmp2 = tmp0.yyyy * tmp3 + tmp2;
                tmp0.y = tmp1.w >= tmp2.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp1.xyz = tmp2.xyw;
                tmp2.xyw = tmp1.wyx;
                tmp2 = tmp2 - tmp1;
                tmp1 = tmp0.yyyy * tmp2 + tmp1;
                tmp0.y = min(tmp1.y, tmp1.w);
                tmp0.y = tmp1.x - tmp0.y;
                tmp0.w = tmp0.y * 6.0 + 0.0;
                tmp1.y = tmp1.w - tmp1.y;
                tmp0.w = tmp1.y / tmp0.w;
                tmp0.w = tmp0.w + tmp1.z;
                tmp1.yzw = abs(tmp0.www) + float3(1.0, 0.6666667, 0.3333333);
                tmp1.yzw = frac(tmp1.yzw);
                tmp1.yzw = tmp1.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp1.yzw = saturate(abs(tmp1.yzw) - float3(1.0, 1.0, 1.0));
                tmp1.yzw = tmp1.yzw - float3(1.0, 1.0, 1.0);
                tmp0.w = tmp1.x + 0.0;
                tmp0.y = tmp0.y / tmp0.w;
                tmp0.w = _CrackAmount + 1.0;
                tmp0.y = tmp0.w * tmp0.y;
                tmp1.yzw = tmp0.yyy * tmp1.yzw + float3(1.0, 1.0, 1.0);
                tmp0.yw = tmp0.zz * float2(10.0, 10.0) + float2(-0.8, -0.333);
                tmp2.x = tmp0.z * 40.0;
                tmp2.x = saturate(tmp2.x);
                tmp0.yz = saturate(tmp0.yw * float2(5.0, 2.994012));
                tmp2.yz = tmp0.yz * float2(-2.0, -2.0) + float2(3.0, 3.0);
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.yz = tmp0.yz * tmp2.yz;
                tmp0.y = tmp0.z * 0.5 + tmp0.y;
                tmp0.z = 1.0 - tmp0.y;
                tmp0.w = 1.0 - tmp4.x;
                tmp0.z = tmp0.z / tmp0.w;
                tmp0.z = saturate(1.0 - tmp0.z);
                tmp0.z = tmp0.y * 0.667 + tmp0.z;
                tmp2.y = _CrackColor.y >= _CrackColor.z;
                tmp2.y = tmp2.y ? 1.0 : 0.0;
                tmp3.xy = _CrackColor.yz;
                tmp3.zw = float2(0.0, -0.3333333);
                tmp5.xy = _CrackColor.zy;
                tmp5.zw = float2(-1.0, 0.6666667);
                tmp3 = tmp3 - tmp5;
                tmp3 = tmp2.yyyy * tmp3.xywz + tmp5.xywz;
                tmp2.y = _CrackColor.x >= tmp3.x;
                tmp2.y = tmp2.y ? 1.0 : 0.0;
                tmp5.z = tmp3.w;
                tmp3.w = _CrackColor.x;
                tmp5.xyw = tmp3.wyx;
                tmp5 = tmp5 - tmp3;
                tmp3 = tmp2.yyyy * tmp5 + tmp3;
                tmp2.y = min(tmp3.y, tmp3.w);
                tmp2.y = tmp3.x - tmp2.y;
                tmp2.z = tmp2.y * 6.0 + 0.0;
                tmp2.w = tmp3.w - tmp3.y;
                tmp2.z = tmp2.w / tmp2.z;
                tmp2.z = tmp2.z + tmp3.z;
                tmp2.w = abs(tmp2.z) + _CrackColorRange;
                tmp2.z = abs(tmp2.z) - _CrackColorRange;
                tmp3.yzw = tmp2.zzz + float3(1.0, 0.6666667, 0.3333333);
                tmp3.yzw = frac(tmp3.yzw);
                tmp3.yzw = tmp3.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp3.yzw = saturate(abs(tmp3.yzw) - float3(1.0, 1.0, 1.0));
                tmp3.yzw = tmp3.yzw - float3(1.0, 1.0, 1.0);
                tmp4.yzw = tmp2.www + float3(1.0, 0.6666667, 0.3333333);
                tmp4.yzw = frac(tmp4.yzw);
                tmp4.yzw = tmp4.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp4.yzw = saturate(abs(tmp4.yzw) - float3(1.0, 1.0, 1.0));
                tmp4.yzw = tmp4.yzw - float3(1.0, 1.0, 1.0);
                tmp2.z = tmp3.x + 0.0;
                tmp2.y = tmp2.y / tmp2.z;
                tmp4.yzw = tmp2.yyy * tmp4.yzw + float3(1.0, 1.0, 1.0);
                tmp2.yzw = tmp2.yyy * tmp3.yzw + float3(1.0, 1.0, 1.0);
                tmp3.yzw = tmp3.xxx * tmp4.yzw + -_CrackColor.xyz;
                tmp3.yzw = tmp0.www * tmp3.yzw + _CrackColor.xyz;
                tmp5.xyz = -tmp3.xxx * tmp2.yzw + _CrackColor.xyz;
                tmp2.yzw = tmp2.yzw * tmp3.xxx;
                tmp5.xyz = tmp0.www * tmp5.xyz + tmp2.yzw;
                tmp3.yzw = tmp3.yzw - tmp5.xyz;
                tmp6.xyz = tmp0.zzz * tmp3.yzw + tmp5.xyz;
                tmp0.z = log(tmp0.x);
                tmp0.z = tmp0.z * 0.9;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp0.z * -3.0 + 1.0;
                tmp0.w = tmp0.z * _CrackAmount;
                tmp3.yzw = tmp0.www * tmp3.yzw + tmp5.xyz;
                tmp3.yzw = _CrackAmount.xxx * tmp0.zzz + tmp3.yzw;
                tmp3.yzw = saturate(tmp3.yzw - float3(1.0, 1.0, 1.0));
                tmp0.yzw = tmp6.xyz * tmp0.yyy + tmp3.yzw;
                tmp0.yzw = tmp0.yzw + tmp0.yzw;
                tmp3.y = inp.texcoord.y * 0.5 + 0.5;
                tmp5.xyz = _CrackAmount.xxx * float3(-0.4, -1.3, -0.25) + float3(1.0, 2.0, 1.0);
                tmp0.x = tmp0.x * tmp3.y + -tmp5.x;
                tmp3.y = tmp5.y - tmp5.x;
                tmp3.y = 1.0 / tmp3.y;
                tmp0.x = saturate(tmp0.x * tmp3.y);
                tmp3.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp3.y;
                tmp3.yzw = tmp3.xxx * tmp4.yzw + -tmp2.yzw;
                tmp4.yzw = tmp3.xxx * tmp4.yzw;
                tmp2.yzw = _CrackAmount.xxx * tmp3.yzw + tmp2.yzw;
                tmp2.yzw = tmp2.yzw * _CrackAmount.xxx;
                tmp2.yzw = tmp4.xxx * tmp2.yzw;
                tmp2.yzw = max(tmp2.yzw, float3(0.0, 0.0, 0.0));
                tmp2.yzw = min(tmp2.yzw, float3(1.0, 0.0, 0.0));
                tmp2.yzw = tmp2.yzw * float3(2.0, 2.0, 2.0) + tmp4.yzw;
                tmp0.xyz = tmp2.yzw * tmp0.xxx + tmp0.yzw;
                tmp0.w = tmp2.x * -2.0 + 3.0;
                tmp2.x = tmp2.x * tmp2.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp0.w = tmp0.w * -0.05 + 1.0;
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.w = tmp5.z * tmp0.w;
                o.sv_target.xyz = tmp0.www * tmp1.yzw + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Geometry+0" "RenderType" = "Opaque" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 73255
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float3 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float _VertexOffset;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _VertexNoise;
			// Texture params for Fragment Shader
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = v.vertex.yy * unity_ObjectToWorld._m21_m01;
                tmp0.xy = unity_ObjectToWorld._m20_m00 * v.vertex.xx + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m22_m02 * v.vertex.zz + tmp0.xy;
                tmp0.xy = unity_ObjectToWorld._m23_m03 * v.vertex.ww + tmp0.xy;
                tmp0.xy = _Time.yy * float2(0.1, 0.1) + tmp0.xy;
                tmp0 = tex2Dlod(_VertexNoise, float4(tmp0.xy, 0, 0.0));
                tmp0.y = v.texcoord.y - 0.2;
                tmp0.y = saturate(tmp0.y * -4.0 + 1.0);
                tmp0.x = tmp0.y * tmp0.x;
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp1.xyz = tmp0.zwy * float3(1.0, 0.0, 1.0);
                tmp1.xyz = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _VertexOffset.xxx + v.vertex.xyz;
                tmp2 = tmp1.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp1 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp2 = tmp1 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp2.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp2.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = tmp0.yzw * tmp2.xyz;
                tmp3.xyz = tmp0.wyz * tmp2.yzx + -tmp3.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                o.texcoord.y = tmp3.x;
                o.texcoord.z = tmp0.z;
                o.texcoord.x = tmp2.z;
                o.texcoord1.x = tmp2.x;
                o.texcoord2.x = tmp2.y;
                o.texcoord1.z = tmp0.w;
                o.texcoord2.z = tmp0.y;
                o.texcoord1.y = tmp3.y;
                o.texcoord2.y = tmp3.z;
                o.texcoord3.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp1;
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
                o.sv_target = float4(0.0, 0.0, 0.0, 1.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}