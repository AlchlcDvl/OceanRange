Shader "SR/RanchWindow" {
	Properties {
		_InteriorDepth ("Interior Depth", 2D) = "white" {}
		_Interior ("Interior", 2D) = "black" {}
		_Spotlight ("Spotlight", 2D) = "black" {}
		_IneriorFurniture ("Inerior Furniture", 2D) = "white" {}
		_FurnitureSpread ("Furniture Spread", Float) = 0.25
		_InteriorShadow ("Interior Shadow", 2D) = "white" {}
		_Normal ("Normal", 2D) = "bump" {}
		_MatCap ("MatCap", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 46601
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
			float4 _Interior_ST;
			float4 _InteriorDepth_ST;
			float4 _IneriorFurniture_ST;
			float4 _InteriorShadow_ST;
			float _FurnitureSpread;
			float4 _MatCap_ST;
			float4 _Normal_ST;
			float4 _Spotlight_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _InteriorDepth;
			sampler2D _Interior;
			sampler2D _IneriorFurniture;
			sampler2D _InteriorShadow;
			sampler2D _MatCap;
			sampler2D _Spotlight;
			
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
                float4 tmp8;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp2.xyz = tmp1.yyy * inp.texcoord4.xyz;
                tmp2.xyz = tmp1.xxx * inp.texcoord3.xyz + tmp2.xyz;
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = sqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz + tmp2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = dot(-tmp2.xyz, tmp0.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp3.xyz = tmp0.xyz * -tmp1.www + -tmp2.xyz;
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp4.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp4.xyz, tmp3.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * 22.62742;
                tmp1.w = exp(tmp1.w);
                tmp1.w = min(tmp1.w, 1.0);
                tmp2.w = saturate(tmp0.y);
                tmp3.xy = abs(tmp0.xz) * abs(tmp0.xz);
                tmp3.x = tmp3.x * 0.25;
                tmp2.w = tmp2.w * tmp2.w + tmp3.x;
                tmp2.w = tmp3.y * 0.25 + tmp2.w;
                tmp3.x = dot(tmp0.xyz, tmp2.xyz);
                tmp3.x = max(tmp3.x, 0.0);
                tmp3.x = 1.0 - tmp3.x;
                tmp2.w = tmp2.w * tmp3.x;
                tmp3.yzw = tmp2.www * _LightColor0.xyz + tmp1.www;
                tmp3.yzw = saturate(tmp3.yzw * float3(1.333333, 1.333333, 1.333333) + float3(-0.3333333, -0.3333333, -0.3333333));
                tmp5.xy = tmp0.yy * unity_MatrixV._m01_m11;
                tmp5.xy = unity_MatrixV._m00_m10 * tmp0.xx + tmp5.xy;
                tmp5.xy = unity_MatrixV._m02_m12 * tmp0.zz + tmp5.xy;
                tmp5.xy = tmp5.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp5.xy = tmp5.xy * _MatCap_ST.xy + _MatCap_ST.zw;
                tmp5 = tex2D(_MatCap, tmp5.xy);
                tmp3.yzw = tmp5.xyz * _LightColor0.xyz + tmp3.yzw;
                tmp5.xy = inp.texcoord.xy * _InteriorDepth_ST.xy + _InteriorDepth_ST.zw;
                tmp5 = tex2D(_InteriorDepth, tmp5.xy);
                tmp6.x = dot(inp.texcoord3.xyz, tmp2.xyz);
                tmp6.y = dot(inp.texcoord4.xyz, tmp2.xyz);
                tmp2.xy = -tmp5.xx * tmp6.xy + inp.texcoord.xy;
                tmp2.zw = tmp2.xy * _Interior_ST.xy + _Interior_ST.zw;
                tmp2.xy = tmp2.xy * _Spotlight_ST.xy + _Spotlight_ST.zw;
                tmp5 = tex2D(_Spotlight, tmp2.xy);
                tmp2 = tex2D(_Interior, tmp2.zw);
                tmp7.xyz = _FurnitureSpread.xxx * float3(-0.375, -0.25, -0.125);
                tmp8 = tmp7.xxyy * tmp6.xyxy + inp.texcoord.xyxy;
                tmp6.xy = tmp7.zz * tmp6.xy + inp.texcoord.xy;
                tmp6.xy = tmp6.xy * _IneriorFurniture_ST.xy + _IneriorFurniture_ST.zw;
                tmp6 = tex2D(_IneriorFurniture, tmp6.xy);
                tmp7 = tmp8 * _IneriorFurniture_ST + _IneriorFurniture_ST;
                tmp8 = tex2D(_IneriorFurniture, tmp7.xy);
                tmp7 = tex2D(_IneriorFurniture, tmp7.zw);
                tmp8.xyz = tmp8.xyz * float3(0.5, 0.5, 0.5) + -tmp2.xyz;
                tmp2.xyz = tmp8.www * tmp8.xyz + tmp2.xyz;
                tmp1.w = tmp8.w * -0.333 + 1.0;
                tmp7.xyz = tmp7.xyz * float3(0.75, 0.75, 0.75) + -tmp2.xyz;
                tmp2.xyz = tmp7.www * tmp7.xyz + tmp2.xyz;
                tmp6.xyz = tmp6.xyz - tmp2.xyz;
                tmp2.xyz = tmp6.www * tmp6.xyz + tmp2.xyz;
                tmp6.xy = inp.texcoord.xy * _InteriorShadow_ST.xy + _InteriorShadow_ST.zw;
                tmp8 = tex2D(_InteriorShadow, tmp6.xy);
                tmp6.xyz = tmp8.xyz * float3(1.5, 1.5, 1.5) + -tmp2.xyz;
                tmp2.xyz = tmp8.www * tmp6.xyz + tmp2.xyz;
                tmp2.w = 0.333 - tmp1.w;
                tmp1.w = tmp7.w * tmp2.w + tmp1.w;
                tmp1.w = tmp6.w * -tmp1.w + tmp1.w;
                tmp6.xyz = tmp2.xyz * tmp1.www;
                tmp2.xyz = tmp2.xyz * float3(0.5693123, 0.6617647, 0.6541135);
                tmp7.xy = tmp3.xx * float2(-1.818182, -4.0) + float2(1.363636, 2.0);
                tmp2.w = tmp1.w * tmp3.x;
                tmp6.xyz = tmp6.xyz * tmp7.xxx;
                tmp6.xyz = tmp6.xyz * float3(0.1405709, 0.2941176, 0.287764);
                tmp6.xyz = tmp7.yyy * tmp6.xyz;
                tmp6.xyz = tmp2.www * float3(0.1405709, 0.2941176, 0.287764) + tmp6.xyz;
                tmp3.xyz = tmp3.yzw + tmp6.xyz;
                tmp2.w = tmp1.w * 0.5 + 0.5;
                tmp5.xyz = tmp5.xyz * tmp1.www;
                tmp3.xyz = tmp2.www * float3(0.1985294, 0.1959119, 0.1605753) + tmp3.xyz;
                tmp3.xyz = tmp5.xyz * float3(3.0, 3.0, 3.0) + tmp3.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp4.xyz;
                tmp0.w = dot(tmp0.xyz, tmp4.xyz);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.xw = max(tmp0.xw, float2(0.0, 0.0));
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 11.31371;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.www * _LightColor0.xyz + tmp1.xyz;
                tmp0.xyz = tmp1.xyz * tmp2.xyz + tmp0.xyz;
                o.sv_target.xyz = tmp3.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 90255
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
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Interior_ST;
			float4 _InteriorDepth_ST;
			float4 _IneriorFurniture_ST;
			float4 _InteriorShadow_ST;
			float _FurnitureSpread;
			float4 _Normal_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _LightTexture0;
			sampler2D _InteriorDepth;
			sampler2D _Interior;
			sampler2D _IneriorFurniture;
			sampler2D _InteriorShadow;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord3.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord4.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.xy = inp.texcoord.xy * _InteriorDepth_ST.xy + _InteriorDepth_ST.zw;
                tmp0 = tex2D(_InteriorDepth, tmp0.xy);
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.yzw = tmp0.yzw * tmp1.xxx;
                tmp2.x = dot(inp.texcoord3.xyz, tmp1.xyz);
                tmp2.y = dot(inp.texcoord4.xyz, tmp1.xyz);
                tmp1.yz = -tmp0.xx * tmp2.xy + inp.texcoord.xy;
                tmp1.yz = tmp1.yz * _Interior_ST.xy + _Interior_ST.zw;
                tmp3 = tex2D(_Interior, tmp1.yz);
                tmp1.yzw = _FurnitureSpread.xxx * float3(-0.375, -0.25, -0.125);
                tmp4 = tmp1.yyzz * tmp2.xyxy + inp.texcoord.xyxy;
                tmp1.yz = tmp1.ww * tmp2.xy + inp.texcoord.xy;
                tmp1.yz = tmp1.yz * _IneriorFurniture_ST.xy + _IneriorFurniture_ST.zw;
                tmp2 = tex2D(_IneriorFurniture, tmp1.yz);
                tmp4 = tmp4 * _IneriorFurniture_ST + _IneriorFurniture_ST;
                tmp5 = tex2D(_IneriorFurniture, tmp4.xy);
                tmp4 = tex2D(_IneriorFurniture, tmp4.zw);
                tmp1.yzw = tmp5.xyz * float3(0.5, 0.5, 0.5) + -tmp3.xyz;
                tmp1.yzw = tmp5.www * tmp1.yzw + tmp3.xyz;
                tmp3.xyz = tmp4.xyz * float3(0.75, 0.75, 0.75) + -tmp1.yzw;
                tmp1.yzw = tmp4.www * tmp3.xyz + tmp1.yzw;
                tmp2.xyz = tmp2.xyz - tmp1.yzw;
                tmp1.yzw = tmp2.www * tmp2.xyz + tmp1.yzw;
                tmp2.xy = inp.texcoord.xy * _InteriorShadow_ST.xy + _InteriorShadow_ST.zw;
                tmp2 = tex2D(_InteriorShadow, tmp2.xy);
                tmp2.xyz = tmp2.xyz * float3(1.5, 1.5, 1.5) + -tmp1.yzw;
                tmp1.yzw = tmp2.www * tmp2.xyz + tmp1.yzw;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp3.xy = inp.texcoord.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp3 = tex2D(_Normal, tmp3.xy);
                tmp3.x = tmp3.w * tmp3.x;
                tmp3.xy = tmp3.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp4.xyz = tmp3.yyy * inp.texcoord4.xyz;
                tmp4.xyz = tmp3.xxx * inp.texcoord3.xyz + tmp4.xyz;
                tmp0.x = dot(tmp3.xy, tmp3.xy);
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = sqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz + tmp4.xyz;
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.x = dot(tmp2.xyz, tmp3.xyz);
                tmp0.yzw = tmp0.yzw * tmp1.xxx + tmp3.xyz;
                tmp0.x = max(tmp0.x, 0.0);
                tmp1.x = dot(inp.texcoord5.xyz, inp.texcoord5.xyz);
                tmp3 = tex2D(_LightTexture0, tmp1.xx);
                tmp3.xyz = tmp3.xxx * _LightColor0.xyz;
                tmp4.xyz = tmp0.xxx * tmp3.xyz;
                tmp1.xyz = tmp1.yzw * tmp4.xyz;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.x = dot(tmp0.xyz, tmp2.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 11.31371;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp3.xyz;
                o.sv_target.xyz = tmp1.xyz * float3(0.5693123, 0.6617647, 0.6541135) + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}