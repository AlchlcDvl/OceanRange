Shader "Cloud/ShaderForge/Standard" {
	Properties {
		_BaseColor ("BaseColor", Color) = (1,1,1,0.5)
		_Shading ("Shading", Color) = (0,0,0,0.5)
		_DepthIntensity ("DepthIntensity", Float) = 0.5
		_PerlinNormalMap ("PerlinNormalMap", 2D) = "white" {}
		_Tiling ("Tiling", Float) = 3000
		_Density ("Density", Float) = -0.25
		_Alpha ("Alpha", Float) = 5
		_AlphaCut ("AlphaCut", Float) = 0.01
		_Speed ("Speed", Float) = 0.1
		_SpeedSecondLayer ("SpeedSecondLayer", Float) = 4
		_WindDirection ("WindDirection", Vector) = (1,0,0,0)
		_CloudNormalsDirection ("CloudNormalsDirection", Vector) = (1,1,-1,0)
		_MipLevel ("Mip Level", Float) = 0
		_EdgeBlend ("EdgeBlend", Range(0, 10)) = 2
		_DepthBlendMul ("DepthBlendMul", Range(0, 100)) = 1
		_ShadingNight ("Shading - Night", Color) = (0,0,0,0.5)
		_BaseColorNight ("BaseColor - Night", Color) = (1,1,1,0.5)
		_Dayness ("Dayness", Float) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 200
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
		Pass {
			Name "FORWARD"
			LOD 200
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			Cull Front
			GpuProgramID 48338
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
			float4 _BaseColor;
			float4 _Shading;
			float _DepthIntensity;
			float _Tiling;
			float _Density;
			float _Alpha;
			float _AlphaCut;
			float _Speed;
			float _SpeedSecondLayer;
			float _EdgeBlend;
			float4 _CloudNormalsDirection;
			float4 _PerlinNormalMap_ST;
			float _MipLevel;
			float4 _BaseColorNight;
			float4 _ShadingNight;
			float _Dayness;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _PerlinNormalMap;
			
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
                tmp0.x = dot(-v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(-v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(-v.normal.xyz, unity_WorldToObject._m02_m12_m22);
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
                tmp0.xy = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * _EdgeBlend;
                tmp0.x = exp(tmp0.x);
                tmp1 = inp.texcoord1.xzxz / _Tiling.xxxx;
                tmp0.y = _Time.y * 0.001;
                tmp1 = tmp0.yyyy * float4(_Speed.xx, _SpeedSecondLayer.xx) + tmp1;
                tmp0.yz = tmp1.zw + float2(0.0, 0.5);
                tmp1.xy = tmp1.xy * _PerlinNormalMap_ST.xy + _PerlinNormalMap_ST.zw;
                tmp1 = tex2Dlod(_PerlinNormalMap, float4(tmp1.xy, 0, _MipLevel));
                tmp0.yz = tmp0.yz * _PerlinNormalMap_ST.xy + _PerlinNormalMap_ST.zw;
                tmp2 = tex2Dlod(_PerlinNormalMap, float4(tmp0.yz, 0, _MipLevel));
                tmp0.y = saturate(tmp1.w + _Density);
                tmp1.xyz = tmp1.xyz * float3(2.0, 2.0, 2.0) + _Density.xxx;
                tmp1.xyz = tmp1.xyz - float3(1.0, 1.0, 1.0);
                tmp0.y = inp.color.w * tmp0.y + -tmp2.w;
                tmp2.xyz = tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(-1.0, -1.0, -1.0);
                tmp1.xyz = inp.color.www * tmp1.xyz + -tmp2.xyz;
                tmp1.xyz = _CloudNormalsDirection.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp0.y = tmp0.y * _Alpha;
                tmp0.z = tmp0.y * tmp0.x + -_AlphaCut;
                tmp0.y = tmp0.x * tmp0.y;
                o.sv_target.w = saturate(tmp0.y);
                tmp0.y = ceil(tmp0.z);
                tmp0.y = tmp0.y - 1.0;
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp0.y = inp.color.z * 3.003003;
                tmp0.yzw = tmp0.yyy * tmp1.xyz + float3(-1.0, -1.0, -1.0);
                tmp1.xyz = tmp0.zzz * inp.texcoord4.xyz;
                tmp1.xyz = tmp0.yyy * inp.texcoord3.xyz + tmp1.xyz;
                tmp0.y = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp2.xyz = tmp0.yyy * inp.texcoord2.xyz;
                tmp0.yzw = tmp0.www * tmp2.xyz + tmp1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * _WorldSpaceLightPos0.yxz;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.y = 1.0 - abs(tmp0.y);
                tmp1 = _Shading - _ShadingNight;
                tmp0.z = saturate(_Dayness);
                tmp1 = tmp0.zzzz * tmp1 + _ShadingNight;
                tmp0.y = -tmp0.y * tmp1.x + 1.0;
                tmp0.w = _CloudNormalsDirection.y * inp.color.z + 1.0;
                tmp0.w = saturate(tmp0.w * 0.5 + _DepthIntensity);
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.w = inp.color.z + 0.5;
                tmp0.xy = tmp0.xw * tmp0.xy;
                tmp2 = _BaseColor - _BaseColorNight;
                tmp2 = tmp0.zzzz * tmp2 + _BaseColorNight;
                tmp2.yzw = tmp2.yzw - tmp1.yzw;
                tmp0.yzw = saturate(tmp0.yyy * tmp2.yzw + tmp1.yzw);
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.yzw = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp2.xxx * tmp2.yzw + tmp1.xyz;
                tmp0.yzw = tmp0.yzw * tmp1.xyz + -unity_FogColor.xyz;
                o.sv_target.xyz = tmp0.xxx * tmp0.yzw + unity_FogColor.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			LOD 200
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" "SHADOWSUPPORT" = "true" }
			Cull Front
			Offset 1, 1
			GpuProgramID 91286
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _Tiling;
			float _Density;
			float _Alpha;
			float _AlphaCut;
			float _Speed;
			float _SpeedSecondLayer;
			float _EdgeBlend;
			float4 _PerlinNormalMap_ST;
			float _MipLevel;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _PerlinNormalMap;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                o.position.xyw = tmp0.xyw;
                tmp0.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp0.x + tmp0.z;
                o.texcoord1.xy = v.texcoord.xy;
                o.color = v.color;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = inp.texcoord2.xzxz / _Tiling.xxxx;
                tmp1.x = _Time.y * 0.001;
                tmp0 = tmp1.xxxx * float4(_Speed.xx, _SpeedSecondLayer.xx) + tmp0;
                tmp0.zw = tmp0.zw + float2(0.0, 0.5);
                tmp0.xy = tmp0.xy * _PerlinNormalMap_ST.xy + _PerlinNormalMap_ST.zw;
                tmp1 = tex2Dlod(_PerlinNormalMap, float4(tmp0.xy, 0, _MipLevel));
                tmp0.x = saturate(tmp1.w + _Density);
                tmp0.yz = tmp0.zw * _PerlinNormalMap_ST.xy + _PerlinNormalMap_ST.zw;
                tmp1 = tex2Dlod(_PerlinNormalMap, float4(tmp0.yz, 0, _MipLevel));
                tmp0.x = inp.color.w * tmp0.x + -tmp1.w;
                tmp0.x = tmp0.x * _Alpha;
                tmp0.yz = inp.texcoord1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.y = dot(tmp0.xy, tmp0.xy);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = log(tmp0.y);
                tmp0.y = tmp0.y * _EdgeBlend;
                tmp0.y = exp(tmp0.y);
                tmp0.x = tmp0.x * tmp0.y + -_AlphaCut;
                tmp0.x = ceil(tmp0.x);
                tmp0.x = tmp0.x - 1.0;
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
	CustomEditor "ShaderForgeMaterialInspector"
}