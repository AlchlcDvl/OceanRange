Shader "SR/Slime/Splat" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.3308824,0,0.1163793,1)
		_MiddleColor ("Middle Color", Color) = (0.8455882,0.1305688,0.2045361,1)
		_TopColor ("Top Color", Color) = (0.9117647,0.3687284,0.4698454,1)
		_Decal ("Decal", 2D) = "white" {}
		[MaterialToggle] _UseOverride ("Use Override", Float) = 0.7294118
		_CubemapOverride ("Cubemap Override", 2D) = "white" {}
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_Alpha ("Alpha", Range(0, 1)) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
		_FalloffTex ("FallOff", 2D) = "white" {}
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset -1, -1
			GpuProgramID 47749
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
				float4 texcoord8 : TEXCOORD8;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float _UseOverride;
			float4 _CubemapOverride_ST;
			float _Gloss;
			float _GlossPower;
			float4 _Decal_ST;
			float _Alpha;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _FalloffTex;
			sampler2D _Decal;
			sampler2D _CubemapOverride;
			
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
                tmp0.xy = v.vertex.yy * unity_Projector._m01_m11;
                tmp0.xy = unity_Projector._m00_m10 * v.vertex.xx + tmp0.xy;
                tmp0.xy = unity_Projector._m02_m12 * v.vertex.zz + tmp0.xy;
                o.texcoord.xy = unity_Projector._m03_m13 * v.vertex.ww + tmp0.xy;
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
                tmp0.xyz = v.vertex.yyy * unity_ProjectorClip._m01_m11_m21;
                tmp0.xyz = unity_ProjectorClip._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ProjectorClip._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                o.texcoord8.xyz = unity_ProjectorClip._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.x = v.normal.y * unity_Projector._m21;
                tmp0.x = unity_Projector._m20 * v.normal.x + tmp0.x;
                tmp0.x = unity_Projector._m22 * v.normal.z + tmp0.x;
                o.texcoord8.w = saturate(-tmp0.x);
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
                tmp0.xy = inp.texcoord.xy * _Decal_ST.xy + _Decal_ST.zw;
                tmp1 = tex2D(_Decal, tmp0.xy);
                tmp0 = tex2Dlod(_Decal, float4(tmp0.xy, 0, 0.0));
                tmp2 = tex2D(_FalloffTex, inp.texcoord8.xy);
                tmp0.y = tmp1.x * tmp2.w;
                tmp0.z = tmp2.w * _Alpha;
                tmp0.z = tmp0.z * inp.texcoord8.w;
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = min(tmp0.z, 0.999);
                tmp0.z = 1.0 - tmp0.z;
                tmp0.y = tmp0.y >= tmp0.z;
                if (!(tmp0.y)) {
                    discard;
                }
                tmp0.x = tmp0.x * tmp2.w;
                tmp0.x = max(tmp0.z, tmp0.x);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x - tmp0.z;
                tmp0.y = 1.0 - tmp0.z;
                tmp1 = inp.texcoord.xyxy + float4(0.02, 0.0, 0.0, 0.02);
                tmp1 = tmp1 * _Decal_ST + _Decal_ST;
                tmp3 = tex2Dlod(_Decal, float4(tmp1.xy, 0, 0.0));
                tmp1 = tex2Dlod(_Decal, float4(tmp1.zw, 0, 0.0));
                tmp0.w = max(tmp0.z, tmp1.x);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w - tmp0.z;
                tmp0.xw = tmp0.xw / tmp0.yy;
                tmp0.w = tmp0.x - tmp0.w;
                tmp1.y = tmp0.w + tmp0.w;
                tmp0.w = tmp2.w * tmp3.x;
                tmp0.w = max(tmp0.z, tmp0.w);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.z = tmp0.w - tmp0.z;
                tmp0.y = tmp0.z / tmp0.y;
                tmp0.x = tmp0.x - tmp0.y;
                tmp1.x = tmp0.x + tmp0.x;
                tmp0.xyz = tmp1.yyy * inp.texcoord4.xyz;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.xyz = tmp1.xxx * inp.texcoord3.xyz + tmp0.xyz;
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = sqrt(tmp0.w);
                tmp1.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * inp.texcoord2.xyz;
                tmp0.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                tmp0.w = saturate(tmp1.y * 0.5);
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                tmp1.xy = tmp0.yy * unity_MatrixV._m01_m11;
                tmp1.xy = unity_MatrixV._m00_m10 * tmp0.xx + tmp1.xy;
                tmp1.xy = unity_MatrixV._m02_m12 * tmp0.zz + tmp1.xy;
                tmp1.xy = tmp1.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp1.xy = tmp1.xy * _CubemapOverride_ST.xy + _CubemapOverride_ST.zw;
                tmp1 = tex2D(_CubemapOverride, tmp1.xy);
                tmp2.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp1.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp4.xyz, tmp4.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp5.xyz = tmp1.www * tmp4.xyz;
                tmp2.w = dot(tmp0.xyz, tmp5.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp2.w = tmp2.w * tmp2.w;
                tmp2.w = min(tmp2.w, 1.0);
                tmp0.w = tmp0.w + tmp2.w;
                tmp2.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp5.xyz = tmp2.www * _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp0.xyz, tmp5.xyz);
                tmp4.xyz = tmp4.xyz * tmp1.www + tmp5.xyz;
                tmp1.w = max(tmp2.w, 0.0);
                tmp2.w = log(tmp1.w);
                tmp3.w = _GlossPower * 16.0 + -1.0;
                tmp3.w = exp(tmp3.w);
                tmp2.w = tmp2.w * tmp3.w;
                tmp2.w = exp(tmp2.w);
                tmp0.w = saturate(_Gloss * tmp2.w + tmp0.w);
                tmp2.w = tmp2.w * _Gloss;
                tmp5.xyz = tmp2.www * _LightColor0.xyz;
                tmp2.w = 1.0 - tmp0.w;
                tmp3.xyz = -tmp3.xyz * tmp2.www + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.xyz * tmp0.www;
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp1.xyz = saturate(tmp2.xyz ? tmp3.xyz : tmp1.xyz);
                tmp2.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz + _MiddleColor.xyz;
                tmp3.xyz = _MiddleColor.xyz - _BottomColor.xyz;
                tmp3.xyz = tmp0.www * tmp3.xyz + _BottomColor.xyz;
                tmp0.w = tmp0.w * 2.0 + -1.0;
                tmp0.w = max(tmp0.w, 0.0);
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz + tmp3.xyz;
                tmp1.xyz = -tmp2.xyz * float3(0.8, 0.8, 0.8) + tmp1.xyz;
                tmp3.xyz = tmp2.xyz * float3(0.8, 0.8, 0.8);
                tmp2.xyz = tmp2.xyz * float3(0.2, 0.2, 0.2);
                tmp1.xyz = _UseOverride.xxx * tmp1.xyz + tmp3.xyz;
                tmp1.xyz = tmp5.xyz * _Gloss.xxx + tmp1.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp4.xyz;
                tmp0.x = dot(tmp3.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 32.0;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.1, 0.1, 0.1);
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp3.xyz = tmp1.www * _LightColor0.xyz + tmp3.xyz;
                tmp0.xyz = tmp3.xyz * tmp2.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp1.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}