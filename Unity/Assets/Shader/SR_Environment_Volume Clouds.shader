Shader "SR/Environment/Volume Clouds" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_TintColor ("Color", Color) = (0.9294118,0.9843138,1,1)
		_ColorBase ("Color Base", Color) = (0.5215687,0.8470589,1,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent+501" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+501" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 16485
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
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _MainTex_ST;
			float4 _TintColor;
			float4 _ColorBase;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _MainTex;
			
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
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                o.texcoord2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = tmp1.y * unity_MatrixV._m21;
                tmp0.z = unity_MatrixV._m20 * tmp1.x + tmp0.z;
                tmp0.z = unity_MatrixV._m22 * tmp1.z + tmp0.z;
                tmp0.z = unity_MatrixV._m23 * tmp1.w + tmp0.z;
                o.texcoord3.z = -tmp0.z;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.w = tmp0.w;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
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
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.y = tmp0.x * 0.625 + 0.375;
                tmp0.x = -tmp0.x * 0.625 + 0.375;
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.x = tmp0.x * 0.75 + tmp0.y;
                tmp0.yzw = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz + tmp0.yzw;
                tmp0.w = saturate(tmp1.y + tmp1.y);
                tmp1.w = 1.0 - inp.texcoord.y;
                tmp2.xy = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp2.zw = _Time.yy * float2(0.0, -0.15) + tmp2.xy;
                tmp3 = tex2D(_CameraDepthTexture, tmp2.xy);
                tmp2.x = _ZBufferParams.z * tmp3.x + _ZBufferParams.w;
                tmp2.x = 1.0 / tmp2.x;
                tmp2.x = tmp2.x - _ProjectionParams.y;
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.yz = tmp2.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp2.yz);
                tmp2.yzw = saturate(tmp3.xyz * float3(0.5, 0.5, 0.5) + float3(0.2, 0.2, 0.2));
                tmp3.xyz = tmp2.yzw - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.yzw = -tmp3.xyz * tmp1.www + float3(1.0, 1.0, 1.0);
                tmp4.yz = float2(2.0, 2.0);
                tmp4.x = inp.texcoord.y;
                tmp5.xyz = tmp2.yzw * tmp4.zxx;
                tmp2.yzw = tmp2.yzw > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz * tmp5.xyz;
                tmp3.yzw = saturate(tmp2.yzw ? tmp3.yzw : tmp4.xyz);
                tmp3.yzw = tmp0.www * tmp3.yzw;
                tmp4.xyz = _TintColor.xyz - _ColorBase.xyz;
                tmp3.yzw = tmp3.yzw * tmp4.xyz + _ColorBase.xyz;
                tmp3.yzw = tmp3.yzw * float3(1.5, 1.5, 1.5);
                o.sv_target.xyz = tmp0.xyz * tmp3.yzw;
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * -1.25 + 1.125;
                tmp0.y = inp.texcoord3.z - _ProjectionParams.y;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = tmp2.x - tmp0.y;
                tmp0.y = saturate(tmp0.y * 0.2);
                tmp0.z = -tmp0.x * tmp0.y + 1.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = -tmp3.x * tmp0.z + 1.0;
                tmp0.z = tmp0.x * tmp5.x;
                tmp0.y = saturate(tmp2.y ? tmp0.y : tmp0.z);
                tmp1.xyz = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.z = tmp0.z * 0.2;
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.x = tmp0.z * tmp0.x;
                tmp0.z = _TintColor.w + _ColorBase.w;
                tmp0.z = tmp0.z * 0.5;
                tmp0.x = tmp0.x * tmp0.z;
                o.sv_target.w = tmp0.y * tmp0.x;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Transparent+501" "RenderType" = "TransparentCutout" }
			Blend One One, One One
			ZWrite Off
			GpuProgramID 130102
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
				float4 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _MainTex_ST;
			float4 _TintColor;
			float4 _ColorBase;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _LightTexture0;
			sampler2D _MainTex;
			
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
                tmp2 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp2;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = tmp0;
                tmp3.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp3.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp3.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp2.z = dot(tmp3.xyz, tmp3.xyz);
                tmp2.z = rsqrt(tmp2.z);
                o.texcoord2.xyz = tmp2.zzz * tmp3.xyz;
                tmp1.y = tmp1.y * unity_MatrixV._m21;
                tmp1.x = unity_MatrixV._m20 * tmp1.x + tmp1.y;
                tmp1.x = unity_MatrixV._m22 * tmp1.z + tmp1.x;
                tmp1.x = unity_MatrixV._m23 * tmp1.w + tmp1.x;
                o.texcoord3.z = -tmp1.x;
                tmp1.x = tmp2.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp2.xw * float2(0.5, 0.5);
                o.texcoord3.w = tmp2.w;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                tmp0.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.y = tmp0.x * 0.625 + 0.375;
                tmp0.x = -tmp0.x * 0.625 + 0.375;
                tmp0.xy = max(tmp0.xy, float2(0.0, 0.0));
                tmp0.x = tmp0.x * 0.75 + tmp0.y;
                tmp0.y = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp2 = tex2D(_LightTexture0, tmp0.yy);
                tmp0.yzw = tmp2.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp0.yzw * tmp0.xxx;
                tmp0.w = saturate(tmp1.y + tmp1.y);
                tmp1.w = 1.0 - inp.texcoord.y;
                tmp2.xy = inp.texcoord3.xy / inp.texcoord3.ww;
                tmp2.zw = _Time.yy * float2(0.0, -0.15) + tmp2.xy;
                tmp3 = tex2D(_CameraDepthTexture, tmp2.xy);
                tmp2.x = _ZBufferParams.z * tmp3.x + _ZBufferParams.w;
                tmp2.x = 1.0 / tmp2.x;
                tmp2.x = tmp2.x - _ProjectionParams.y;
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.yz = tmp2.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp2.yz);
                tmp2.yzw = saturate(tmp3.xyz * float3(0.5, 0.5, 0.5) + float3(0.2, 0.2, 0.2));
                tmp3.xyz = tmp2.yzw - float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.yzw = -tmp3.xyz * tmp1.www + float3(1.0, 1.0, 1.0);
                tmp4.yz = float2(2.0, 2.0);
                tmp4.x = inp.texcoord.y;
                tmp5.xyz = tmp2.yzw * tmp4.zxx;
                tmp2.yzw = tmp2.yzw > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz * tmp5.xyz;
                tmp3.yzw = saturate(tmp2.yzw ? tmp3.yzw : tmp4.xyz);
                tmp3.yzw = tmp0.www * tmp3.yzw;
                tmp4.xyz = _TintColor.xyz - _ColorBase.xyz;
                tmp3.yzw = tmp3.yzw * tmp4.xyz + _ColorBase.xyz;
                tmp0.xyz = tmp0.xyz * tmp3.yzw;
                tmp0.xyz = tmp0.xyz * float3(1.5, 1.5, 1.5);
                tmp3.yzw = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.yzw = tmp0.www * tmp3.yzw;
                tmp0.w = dot(tmp1.xyz, tmp3.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.w = tmp0.w * -1.25 + 1.125;
                tmp1.x = inp.texcoord3.z - _ProjectionParams.y;
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.x = tmp2.x - tmp1.x;
                tmp1.x = saturate(tmp1.x * 0.2);
                tmp1.y = -tmp0.w * tmp1.x + 1.0;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = -tmp3.x * tmp1.y + 1.0;
                tmp1.y = tmp0.w * tmp5.x;
                tmp1.x = saturate(tmp2.y ? tmp1.x : tmp1.y);
                tmp1.yzw = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp1.y = dot(tmp1.xyz, tmp1.xyz);
                tmp1.y = sqrt(tmp1.y);
                tmp1.y = tmp1.y * 0.2;
                tmp1.y = min(tmp1.y, 1.0);
                tmp0.w = tmp0.w * tmp1.y;
                tmp1.y = _TintColor.w + _ColorBase.w;
                tmp1.y = tmp1.y * 0.5;
                tmp0.w = tmp0.w * tmp1.y;
                tmp0.w = tmp1.x * tmp0.w;
                o.sv_target.xyz = tmp0.www * tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}