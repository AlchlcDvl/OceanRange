Shader "SR/FX/Glitch" {
	Properties {
		_AvgCycleLength ("AvgCycleLength", Range(1, 10)) = 3
		_CycleGlitchRatio ("CycleGlitchRatio", Range(0, 1)) = 0.5
		_GlitchDist ("GlitchDist", Range(0, 0.1)) = 0
		_Fade ("Fade", Range(0, 1)) = 1
		_MainTex ("MainTex", 2D) = "white" {}
		_TimeSpeed ("Time Speed", Float) = 0
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 550
		Tags { "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Overlay+1" "RenderType" = "Overlay" }
		GrabPass {
			"Glitch"
		}
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "Overlay+1" "RenderType" = "Overlay" "SHADOWSUPPORT" = "true" }
			ZWrite Off
			GpuProgramID 43278
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float _CycleGlitchRatio;
			float _GlitchDist;
			float _Fade;
			float4 _MainTex_ST;
			float _TimeSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D Glitch;
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
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy;
                o.color = v.color;
                tmp0.y = tmp0.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp0.x + tmp0.y;
                tmp0.x = unity_MatrixV._m22 * tmp0.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp0.w + tmp0.x;
                o.texcoord1.z = -tmp0.x;
                tmp0.xz = tmp1.xw;
                tmp0.y = _ProjectionParams.x;
                tmp2.xz = float2(0.5, 0.5);
                tmp2.y = _ProjectionParams.x;
                tmp0.xyw = tmp0.xyz * tmp2.xyz;
                o.texcoord1.w = tmp0.z;
                tmp0.y = tmp1.y * tmp0.y;
                o.texcoord1.y = tmp0.y * -0.5 + tmp0.w;
                o.texcoord1.x = tmp0.w + tmp0.x;
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
                tmp0.x = _TimeSpeed * _Time.y;
                tmp0.x = inp.color.w * 0.1 + tmp0.x;
                tmp0.x = frac(tmp0.x);
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.x * tmp0.y;
                tmp0.y = tmp0.y * 80.0;
                tmp0.y = round(tmp0.y);
                tmp0.z = tmp0.y + 0.2127;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * 0.3713 + tmp0.z;
                tmp0.z = tmp0.y * 489.123;
                tmp0.y = tmp0.y + 1.0;
                tmp0.z = sin(tmp0.z);
                tmp0.z = tmp0.z * 4.789;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.x * 48.0;
                tmp0.z = round(tmp0.z);
                tmp1.zw = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp2 = tmp0.zzzz + tmp1.zwzw;
                tmp2 = tmp2 * float4(48.0, 48.0, 4.0, 4.0);
                tmp2 = floor(tmp2);
                tmp0.zw = tmp2.yw * float2(0.0212766, 0.3333333);
                tmp3 = tmp0.zzww * tmp2.xxzz;
                tmp2 = tmp2 * float4(0.0212766, 0.0212766, 0.3333333, 0.3333333) + float4(0.2127, 0.2127, 0.2127, 0.2127);
                tmp2 = tmp3 * float4(0.0079, 0.0079, 0.1237667, 0.1237667) + tmp2;
                tmp3 = tmp2 * float4(489.123, 489.123, 489.123, 489.123);
                tmp0.zw = tmp2.xz + float2(1.0, 1.0);
                tmp2 = sin(tmp3);
                tmp2 = tmp2 * float4(4.789, 4.789, 4.789, 4.789);
                tmp2.xy = tmp2.yw * tmp2.xz;
                tmp0.zw = tmp0.zw * tmp2.xy;
                tmp0.yzw = frac(tmp0.yzw);
                tmp0.w = max(tmp0.w, tmp0.z);
                tmp2.xy = tmp0.zz * float2(0.6, 0.6) + float2(0.2, -0.3);
                tmp0.yz = tmp0.ww * tmp0.yw;
                tmp2.zw = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp2.zw);
                tmp0.w = tmp3.w * tmp3.x;
                tmp2.z = inp.color.w * _Fade;
                tmp2.w = tmp0.w * tmp2.z;
                tmp2.z = tmp2.z * tmp0.w + -0.5;
                o.sv_target.w = tmp0.w;
                tmp0.w = -tmp2.z * 2.0 + 1.0;
                tmp2.z = tmp2.w * _GlitchDist;
                tmp3.x = tmp2.z + tmp2.z;
                tmp0.y = tmp0.y * tmp3.x + -tmp2.z;
                tmp2.z = _CycleGlitchRatio >= tmp0.x;
                tmp2.z = tmp2.z ? 1.0 : 0.0;
                tmp3.x = tmp0.x >= _CycleGlitchRatio;
                tmp0.x = round(tmp0.x);
                tmp3.y = tmp3.x ? 1.0 : 0.0;
                tmp2.z = tmp2.z * tmp3.y;
                tmp2.z = tmp3.x ? 0.0 : tmp2.z;
                tmp2.z = tmp2.z + tmp3.y;
                tmp3.x = tmp2.w * 4.0;
                tmp3.x = round(tmp3.x);
                tmp2.z = tmp2.z * tmp3.x;
                tmp2.z = tmp2.z * 0.25;
                tmp3.xy = tmp2.zz * tmp0.yy + tmp1.zw;
                tmp1.xy = -tmp2.zz * tmp0.yy + tmp1.zw;
                tmp3.z = tmp1.z;
                tmp3.yz = tmp3.zy - tmp1.zy;
                tmp4.x = tmp3.x - tmp1.x;
                tmp3.xy = tmp0.xx * tmp3.yz + tmp1.zy;
                tmp3 = tex2D(Glitch, tmp3.xy);
                tmp4.y = 0.0;
                tmp0.xy = tmp0.xx * tmp4.xy + tmp1.xw;
                tmp4 = tex2D(Glitch, tmp0.xy);
                tmp5.xyz = max(tmp3.xyz, tmp4.xyz);
                tmp3.xyz = min(tmp3.xyz, tmp4.xyz);
                tmp3.xyz = tmp3.xyz + tmp5.xyz;
                tmp0.x = -tmp0.z * tmp0.z + 1.0;
                tmp0.y = tmp0.z * tmp0.z;
                tmp0.z = tmp0.x * tmp2.z;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = tmp0.y * tmp2.z;
                tmp0.x = tmp2.z * tmp0.x;
                tmp4.xyz = tmp0.xxx * float3(0.0, 0.0, 0.667);
                tmp5.xyz = tmp0.yyy * float3(0.0, 0.333, 0.0);
                tmp0.xyz = tmp0.zzz * float3(0.333, 0.0, 0.0);
                tmp1.xy = tmp1.wz * float2(2304.0, 64.0);
                tmp1.xy = frac(tmp1.xy);
                tmp1.xy = log(tmp1.xy);
                tmp1.xy = tmp1.xy * float2(0.1, 0.1);
                tmp1.xy = exp(tmp1.xy);
                tmp6.xy = tmp1.xy * float2(0.5, 0.5);
                tmp1.x = max(tmp1.y, tmp1.x);
                tmp4.xyz = tmp1.xxx * tmp4.xyz;
                tmp0.xyz = tmp0.xyz * tmp6.yyy;
                tmp5.xyz = tmp5.xyz * tmp6.xxx;
                tmp0.xyz = tmp0.xyz * inp.color.xxx;
                tmp0.xyz = tmp5.xyz * inp.color.yyy + tmp0.xyz;
                tmp0.xyz = tmp4.xyz * inp.color.yyy + tmp0.xyz;
                tmp0.xyz = tmp3.xyz * float3(0.5, 0.5, 0.5) + -tmp0.xyz;
                tmp0.xyz = min(abs(tmp0.xyz), float3(1.0, 1.0, 1.0));
                tmp3 = tex2D(Glitch, tmp1.zw);
                tmp1.xy = tmp1.zw * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.xy = tmp1.xy * tmp1.xy;
                tmp1.x = tmp1.y + tmp1.x;
                tmp0.xyz = tmp0.xyz - tmp3.xyz;
                tmp1.y = -tmp2.y * 2.0 + 1.0;
                tmp1.z = 1.0 - tmp1.x;
                tmp1.x = dot(tmp1.xy, tmp2.xy);
                tmp1.w = tmp2.x > 0.5;
                tmp1.y = -tmp1.y * tmp1.z + 1.0;
                tmp1.x = saturate(tmp1.w ? tmp1.y : tmp1.x);
                tmp1.y = 1.0 - tmp1.x;
                tmp1.x = dot(tmp1.xy, tmp2.xy);
                tmp1.z = tmp2.w > 0.5;
                tmp0.w = -tmp0.w * tmp1.y + 1.0;
                tmp0.w = saturate(tmp1.z ? tmp0.w : tmp1.x);
                tmp0.w = tmp0.w * 4.0;
                tmp0.w = floor(tmp0.w);
                tmp0.w = tmp0.w * 0.3333333;
                o.sv_target.xyz = tmp0.www * tmp0.xyz + tmp3.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "Meta"
			LOD 550
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "META" "PreviewType" = "Plane" "QUEUE" = "Overlay+1" "RenderType" = "Overlay" }
			Cull Off
			GpuProgramID 70564
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
				float4 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float unity_MaxOutputValue;
			float unity_UseLinearSpace;
			float _CycleGlitchRatio;
			float _GlitchDist;
			float _Fade;
			float4 _MainTex_ST;
			float _TimeSpeed;
			// Custom ConstantBuffers for Vertex Shader
			CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaVertexControl;
			CBUFFER_END
			// Custom ConstantBuffers for Fragment Shader
			CBUFFER_START(UnityMetaPass)
				bool4 unity_MetaFragmentControl;
			CBUFFER_END
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D Glitch;
			sampler2D _MainTex;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = v.vertex.z > 0.0;
                tmp0.z = tmp0.x ? 0.0001 : 0.0;
                tmp0.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
                tmp0.xyz = unity_MetaVertexControl.xxx ? tmp0.xyz : v.vertex.xyz;
                tmp0.w = tmp0.z > 0.0;
                tmp1.z = tmp0.w ? 0.0001 : 0.0;
                tmp1.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                tmp0.xyz = unity_MetaVertexControl.yyy ? tmp1.xyz : tmp0.xyz;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = tmp0 + unity_MatrixVP._m03_m13_m23_m33;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.color = v.color;
                tmp1.xz = tmp0.xw;
                tmp1.y = _ProjectionParams.x;
                tmp2.xz = float2(0.5, 0.5);
                tmp2.y = _ProjectionParams.x;
                tmp0.xzw = tmp1.xyz * tmp2.xyz;
                o.texcoord1.w = tmp1.z;
                tmp0.y = tmp0.y * tmp0.z;
                o.texcoord1.y = tmp0.y * -0.5 + tmp0.w;
                o.texcoord1.x = tmp0.w + tmp0.x;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.y = tmp0.y * unity_MatrixV._m21;
                tmp0.x = unity_MatrixV._m20 * tmp0.x + tmp0.y;
                tmp0.x = unity_MatrixV._m22 * tmp0.z + tmp0.x;
                tmp0.x = unity_MatrixV._m23 * tmp0.w + tmp0.x;
                o.texcoord1.z = -tmp0.x;
                return o;
			}
			// Keywords: 
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
                tmp0.x = _TimeSpeed * _Time.y;
                tmp0.x = inp.color.w * 0.1 + tmp0.x;
                tmp0.x = frac(tmp0.x);
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.x * tmp0.y;
                tmp0.y = tmp0.y * 80.0;
                tmp0.y = round(tmp0.y);
                tmp0.z = tmp0.y + 0.2127;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * 0.3713 + tmp0.z;
                tmp0.z = tmp0.y * 489.123;
                tmp0.y = tmp0.y + 1.0;
                tmp0.z = sin(tmp0.z);
                tmp0.z = tmp0.z * 4.789;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.x * 48.0;
                tmp0.z = round(tmp0.z);
                tmp1.zw = inp.texcoord1.xy / inp.texcoord1.ww;
                tmp2 = tmp0.zzzz + tmp1.zwzw;
                tmp2 = tmp2 * float4(48.0, 48.0, 4.0, 4.0);
                tmp2 = floor(tmp2);
                tmp0.zw = tmp2.yw * float2(0.0212766, 0.3333333);
                tmp3 = tmp0.zzww * tmp2.xxzz;
                tmp2 = tmp2 * float4(0.0212766, 0.0212766, 0.3333333, 0.3333333) + float4(0.2127, 0.2127, 0.2127, 0.2127);
                tmp2 = tmp3 * float4(0.0079, 0.0079, 0.1237667, 0.1237667) + tmp2;
                tmp3 = tmp2 * float4(489.123, 489.123, 489.123, 489.123);
                tmp0.zw = tmp2.xz + float2(1.0, 1.0);
                tmp2 = sin(tmp3);
                tmp2 = tmp2 * float4(4.789, 4.789, 4.789, 4.789);
                tmp2.xy = tmp2.yw * tmp2.xz;
                tmp0.zw = tmp0.zw * tmp2.xy;
                tmp0.yzw = frac(tmp0.yzw);
                tmp0.w = max(tmp0.w, tmp0.z);
                tmp2.xy = tmp0.zz * float2(0.6, 0.6) + float2(0.2, -0.3);
                tmp0.yz = tmp0.ww * tmp0.yw;
                tmp2.zw = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp2.zw);
                tmp0.w = tmp3.w * tmp3.x;
                tmp2.z = inp.color.w * _Fade;
                tmp2.w = tmp0.w * tmp2.z;
                tmp0.w = tmp2.z * tmp0.w + -0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp2.z = tmp2.w * _GlitchDist;
                tmp3.x = tmp2.z + tmp2.z;
                tmp0.y = tmp0.y * tmp3.x + -tmp2.z;
                tmp2.z = _CycleGlitchRatio >= tmp0.x;
                tmp2.z = tmp2.z ? 1.0 : 0.0;
                tmp3.x = tmp0.x >= _CycleGlitchRatio;
                tmp0.x = round(tmp0.x);
                tmp3.y = tmp3.x ? 1.0 : 0.0;
                tmp2.z = tmp2.z * tmp3.y;
                tmp2.z = tmp3.x ? 0.0 : tmp2.z;
                tmp2.z = tmp2.z + tmp3.y;
                tmp3.x = tmp2.w * 4.0;
                tmp3.x = round(tmp3.x);
                tmp2.z = tmp2.z * tmp3.x;
                tmp2.z = tmp2.z * 0.25;
                tmp3.xy = tmp2.zz * tmp0.yy + tmp1.zw;
                tmp1.xy = -tmp2.zz * tmp0.yy + tmp1.zw;
                tmp3.z = tmp1.z;
                tmp3.yz = tmp3.zy - tmp1.zy;
                tmp4.x = tmp3.x - tmp1.x;
                tmp3.xy = tmp0.xx * tmp3.yz + tmp1.zy;
                tmp3 = tex2D(Glitch, tmp3.xy);
                tmp4.y = 0.0;
                tmp0.xy = tmp0.xx * tmp4.xy + tmp1.xw;
                tmp4 = tex2D(Glitch, tmp0.xy);
                tmp5.xyz = max(tmp3.xyz, tmp4.xyz);
                tmp3.xyz = min(tmp3.xyz, tmp4.xyz);
                tmp3.xyz = tmp3.xyz + tmp5.xyz;
                tmp0.x = -tmp0.z * tmp0.z + 1.0;
                tmp0.y = tmp0.z * tmp0.z;
                tmp0.z = tmp0.x * tmp2.z;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = tmp0.y * tmp2.z;
                tmp0.x = tmp2.z * tmp0.x;
                tmp4.xyz = tmp0.xxx * float3(0.0, 0.0, 0.667);
                tmp5.xyz = tmp0.yyy * float3(0.0, 0.333, 0.0);
                tmp0.xyz = tmp0.zzz * float3(0.333, 0.0, 0.0);
                tmp1.xy = tmp1.wz * float2(2304.0, 64.0);
                tmp1.xy = frac(tmp1.xy);
                tmp1.xy = log(tmp1.xy);
                tmp1.xy = tmp1.xy * float2(0.1, 0.1);
                tmp1.xy = exp(tmp1.xy);
                tmp6.xy = tmp1.xy * float2(0.5, 0.5);
                tmp1.x = max(tmp1.y, tmp1.x);
                tmp4.xyz = tmp1.xxx * tmp4.xyz;
                tmp0.xyz = tmp0.xyz * tmp6.yyy;
                tmp5.xyz = tmp5.xyz * tmp6.xxx;
                tmp0.xyz = tmp0.xyz * inp.color.xxx;
                tmp0.xyz = tmp5.xyz * inp.color.yyy + tmp0.xyz;
                tmp0.xyz = tmp4.xyz * inp.color.yyy + tmp0.xyz;
                tmp0.xyz = tmp3.xyz * float3(0.5, 0.5, 0.5) + -tmp0.xyz;
                tmp0.xyz = min(abs(tmp0.xyz), float3(1.0, 1.0, 1.0));
                tmp3 = tex2D(Glitch, tmp1.zw);
                tmp1.xy = tmp1.zw * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.xy = tmp1.xy * tmp1.xy;
                tmp1.x = tmp1.y + tmp1.x;
                tmp0.xyz = tmp0.xyz - tmp3.xyz;
                tmp1.y = -tmp2.y * 2.0 + 1.0;
                tmp1.z = 1.0 - tmp1.x;
                tmp1.x = dot(tmp1.xy, tmp2.xy);
                tmp1.w = tmp2.x > 0.5;
                tmp1.y = -tmp1.y * tmp1.z + 1.0;
                tmp1.x = saturate(tmp1.w ? tmp1.y : tmp1.x);
                tmp1.y = 1.0 - tmp1.x;
                tmp1.x = dot(tmp1.xy, tmp2.xy);
                tmp1.z = tmp2.w > 0.5;
                tmp0.w = -tmp0.w * tmp1.y + 1.0;
                tmp0.w = saturate(tmp1.z ? tmp0.w : tmp1.x);
                tmp0.w = tmp0.w * 4.0;
                tmp0.w = floor(tmp0.w);
                tmp0.w = tmp0.w * 0.3333333;
                tmp0.xyz = tmp0.www * tmp0.xyz + tmp3.xyz;
                tmp1.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp1.xyz = tmp0.xyz * tmp1.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.w = unity_UseLinearSpace != 0.0;
                tmp0.xyz = tmp0.www ? tmp0.xyz : tmp1.xyz;
                tmp1.xyz = min(unity_MaxOutputValue.xxx, float3(0.0, 0.0, 0.0));
                tmp1.w = 1.0;
                tmp1 = unity_MetaFragmentControl ? tmp1 : float4(0.0, 0.0, 0.0, 0.0);
                tmp0.w = 1.0;
                o.sv_target = unity_MetaFragmentControl ? tmp0 : tmp1;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}