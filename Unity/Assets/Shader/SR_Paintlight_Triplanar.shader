Shader "SR/Paintlight/Triplanar" {
	Properties {
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		_Depth ("Depth", 2D) = "white" {}
		[MaterialToggle] _EnableDetailTex ("Enable Detail Tex", Float) = 0
		_DetailTex ("Detail Tex", 2D) = "white" {}
		_DetailNoiseMask ("Detail Noise Mask", 2D) = "white" {}
		_RampOffset ("Ramp Offset", Float) = 2
		_RampScale ("Ramp Scale", Float) = 1
		_RampUpper ("RampUpper", Color) = (0.4431373,0.3921569,0.5686275,1)
		_SeaLevelRampOffset ("SeaLevelRamp Offset", Float) = -3
		_SeaLevelRampScale ("SeaLevelRamp Scale", Float) = 1
		_SeaLevelRampLower ("SeaLevelRampLower", Color) = (0.3098039,0.4078431,0.3921569,1)
		_PaintRim ("Paint Rim", Range(0, 1)) = 1
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 1610
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			float _RampOffset;
			float _RampScale;
			float4 _RampUpper;
			float _SeaLevelRampOffset;
			float _SeaLevelRampScale;
			float4 _SeaLevelRampLower;
			float _PaintRim;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _PrimaryTex;
			sampler2D _DetailTex;
			sampler2D _DetailNoiseMask;
			sampler2D _Depth;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp9;
                float4 tmp10;
                tmp0.x = inp.texcoord.y - _SeaLevelRampOffset;
                tmp0.x = tmp0.x * _SeaLevelRampScale;
                tmp0.x = saturate(tmp0.x * 0.2 + 0.5);
                tmp0.yzw = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + _SeaLevelRampLower.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp2.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp0.w = tmp2.y * _RampScale;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp1.w = tmp1.w * 0.01;
                tmp0.w = tmp0.w * 0.1 + -_RampOffset;
                tmp0.w = saturate(tmp0.w * 0.5 + 0.5);
                tmp2.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz + float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp0.xyz);
                tmp1.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3 = inp.texcoord.zxxy * _DetailTex_ST + _DetailTex_ST;
                tmp4 = tex2D(_DetailTex, tmp3.zw);
                tmp3 = tex2D(_DetailTex, tmp3.xy);
                tmp5.xy = inp.texcoord.yz - float2(0.5, 0.5);
                tmp6.x = dot(tmp5.xy, float2(0.0000003, -1.0));
                tmp6.y = dot(tmp5.xy, float2(1.0, 0.0000003));
                tmp5.zw = tmp6.xy + float2(0.5, 0.5);
                tmp5.zw = tmp5.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp6 = tex2D(_DetailTex, tmp5.zw);
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp7.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp8.xyz = abs(tmp7.xyz) * abs(tmp7.xyz);
                tmp3.xyz = tmp3.xyz * tmp8.yyy;
                tmp3.xyz = tmp8.xxx * tmp6.xyz + tmp3.xyz;
                tmp3.xyz = tmp8.zzz * tmp4.xyz + tmp3.xyz;
                tmp4 = inp.texcoord.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp6 = tex2D(_PrimaryTex, tmp4.zw);
                tmp4 = tex2D(_PrimaryTex, tmp4.xy);
                tmp4.xyz = tmp4.xyz * tmp8.yyy;
                tmp9.x = dot(tmp5.xy, float2(0.0000003, -1.0));
                tmp9.y = dot(tmp5.xy, float2(1.0, 0.0000003));
                tmp5.zw = tmp9.xy + float2(0.5, 0.5);
                tmp5.zw = tmp5.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp9 = tex2D(_PrimaryTex, tmp5.zw);
                tmp4.xyz = tmp8.xxx * tmp9.xyz + tmp4.xyz;
                tmp4.xyz = tmp8.zzz * tmp6.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp0.w = tmp1.w * tmp1.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp6.x = dot(tmp5.xy, float2(0.0000003, -1.0));
                tmp6.y = dot(tmp5.xy, float2(1.0, 0.0000003));
                tmp5.zw = tmp6.xy + float2(0.5, 0.5);
                tmp5.zw = tmp5.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp6 = tex2D(_DetailNoiseMask, tmp5.zw);
                tmp9 = inp.texcoord.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp10 = tex2D(_DetailNoiseMask, tmp9.xy);
                tmp9 = tex2D(_DetailNoiseMask, tmp9.zw);
                tmp1.w = tmp8.y * tmp10.x;
                tmp1.w = tmp8.x * tmp6.x + tmp1.w;
                tmp1.w = tmp8.z * tmp9.x + tmp1.w;
                tmp2.w = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = tmp0.w * -tmp1.w + tmp1.w;
                tmp3.xyz = tmp3.xyz * tmp1.www;
                tmp3.xyz = _EnableDetailTex.xxx * tmp3.xyz + tmp4.xyz;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp2.xyz = -tmp2.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp0.xyz);
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp1.w = saturate(tmp7.y);
                tmp2.x = dot(abs(tmp7.xy), float2(0.333, 0.333));
                tmp1.w = tmp1.w + tmp2.x;
                tmp2.x = tmp1.w * tmp1.w;
                tmp2.yzw = tmp1.www * tmp1.www + glstate_lightmodel_ambient.xyz;
                tmp2.yzw = tmp2.yzw * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp2.yzw = tmp2.yzw * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp2.yzw = max(tmp2.yzw, float3(0.75, 0.75, 0.75));
                tmp2.yzw = min(tmp2.yzw, float3(1.0, 1.0, 1.0));
                tmp3.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp1.w = dot(tmp3.xyz, tmp3.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp1.www * tmp3.xyz;
                tmp1.w = dot(tmp7.xyz, tmp3.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp3.x = tmp1.w * tmp1.w;
                tmp3.x = tmp1.w * tmp3.x;
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * 2.5;
                tmp1.w = exp(tmp1.w);
                tmp2.x = tmp2.x * tmp3.x;
                tmp0.w = tmp0.w * -tmp2.x + tmp2.x;
                tmp3.x = dot(tmp5.xy, float2(0.0000003, -1.0));
                tmp3.y = dot(tmp5.xy, float2(1.0, 0.0000003));
                tmp3.xy = tmp3.xy + float2(0.5, 0.5);
                tmp3.xy = tmp3.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp3 = tex2D(_Depth, tmp3.xy);
                tmp4 = inp.texcoord.zxxy * _Depth_ST + _Depth_ST;
                tmp5 = tex2D(_Depth, tmp4.xy);
                tmp4 = tex2D(_Depth, tmp4.zw);
                tmp2.x = tmp5.x * tmp8.y;
                tmp2.x = tmp8.x * tmp3.x + tmp2.x;
                tmp2.x = tmp8.z * tmp4.x + tmp2.x;
                tmp0.w = tmp0.w * tmp2.x;
                tmp3 = tmp2.xxxx * float4(5.0, 0.33, 0.1, 0.5) + float4(-1.0, 0.33, 0.45, 0.25);
                tmp2.xyz = tmp0.www * float3(0.5, 0.5, 0.5) + tmp2.yzw;
                tmp0.w = tmp0.w + tmp0.w;
                tmp0.w = floor(tmp0.w);
                tmp2.xyz = tmp2.xyz * _LightColor0.xyz;
                tmp2.w = tmp3.z - tmp3.y;
                tmp3.z = saturate(tmp7.y * 2.0 + -1.0);
                tmp2.w = tmp3.z * tmp2.w + tmp3.y;
                tmp3.y = 1.0 - tmp3.z;
                tmp3.z = 1.0 - tmp2.w;
                tmp4.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp4.x = rsqrt(tmp4.x);
                tmp4.xyz = tmp4.xxx * _WorldSpaceLightPos0.xyz;
                tmp4.x = dot(tmp4.xyz, tmp7.xyz);
                tmp4.x = max(tmp4.x, 0.0);
                tmp4.y = tmp4.x - 0.5;
                tmp4.y = -tmp4.y * 2.0 + 1.0;
                tmp3.z = -tmp4.y * tmp3.z + 1.0;
                tmp2.w = dot(tmp2.xy, tmp4.xy);
                tmp4.x = tmp4.x > 0.5;
                tmp2.w = saturate(tmp4.x ? tmp3.z : tmp2.w);
                tmp0.w = tmp2.w * 13.0 + tmp0.w;
                tmp2.w = 1.0 - tmp2.w;
                tmp0.w = saturate(tmp0.w - 5.0);
                tmp4.xyz = tmp2.xyz * tmp0.www + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp4.xyz = -tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp4.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp1.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp4.xyz);
                tmp0.w = 1.0 - tmp3.w;
                tmp2.x = tmp1.w - 0.5;
                tmp2.x = -tmp2.x * 2.0 + 1.0;
                tmp0.w = -tmp2.x * tmp0.w + 1.0;
                tmp2.x = dot(tmp3.xy, tmp1.xy);
                tmp3.x = saturate(tmp3.x);
                tmp1.w = tmp1.w > 0.5;
                tmp0.w = saturate(tmp1.w ? tmp0.w : tmp2.x);
                tmp0.w = saturate(tmp0.w * 8.0 + -3.0);
                tmp0.w = tmp0.w * tmp2.w;
                tmp0.w = tmp3.x * tmp0.w;
                tmp0.w = tmp3.y * tmp0.w;
                tmp0.w = tmp0.w * _PaintRim;
                tmp0.w = tmp0.w * 0.25;
                tmp2.xyz = glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _LightColor0.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz + tmp0.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.xyz = saturate(tmp0.xyz * tmp3.xyz);
                tmp0.xyz = tmp2.xyz * float3(0.7, 0.7, 0.7) + tmp0.xyz;
                o.sv_target.xyz = tmp1.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 96834
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			float _RampOffset;
			float _RampScale;
			float4 _RampUpper;
			float _SeaLevelRampOffset;
			float _SeaLevelRampScale;
			float4 _SeaLevelRampLower;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _PrimaryTex;
			sampler2D _DetailTex;
			sampler2D _DetailNoiseMask;
			sampler2D _Depth;
			
			// Keywords: POINT
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
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.texcoord = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord2.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                float4 tmp9;
                float4 tmp10;
                tmp0.x = inp.texcoord.y - _SeaLevelRampOffset;
                tmp0.x = tmp0.x * _SeaLevelRampScale;
                tmp0.x = saturate(tmp0.x * 0.2 + 0.5);
                tmp0.yzw = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + _SeaLevelRampLower.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp2.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp0.w = tmp2.y * _RampScale;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = sqrt(tmp1.w);
                tmp1.w = tmp1.w * 0.01;
                tmp0.w = tmp0.w * 0.1 + -_RampOffset;
                tmp0.w = saturate(tmp0.w * 0.5 + 0.5);
                tmp2.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz + float3(0.5, 0.5, 0.5);
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                tmp0.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp0.xyz);
                tmp1.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3 = inp.texcoord.zxxy * _DetailTex_ST + _DetailTex_ST;
                tmp4 = tex2D(_DetailTex, tmp3.zw);
                tmp3 = tex2D(_DetailTex, tmp3.xy);
                tmp5.xy = inp.texcoord.yz - float2(0.5, 0.5);
                tmp6.x = dot(tmp5.xy, float2(0.0000003, -1.0));
                tmp6.y = dot(tmp5.xy, float2(1.0, 0.0000003));
                tmp5.zw = tmp6.xy + float2(0.5, 0.5);
                tmp5.zw = tmp5.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp6 = tex2D(_DetailTex, tmp5.zw);
                tmp0.w = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp7.xyz = tmp0.www * inp.texcoord1.xyz;
                tmp8.xyz = abs(tmp7.xyz) * abs(tmp7.xyz);
                tmp3.xyz = tmp3.xyz * tmp8.yyy;
                tmp3.xyz = tmp8.xxx * tmp6.xyz + tmp3.xyz;
                tmp3.xyz = tmp8.zzz * tmp4.xyz + tmp3.xyz;
                tmp4 = inp.texcoord.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp6 = tex2D(_PrimaryTex, tmp4.zw);
                tmp4 = tex2D(_PrimaryTex, tmp4.xy);
                tmp4.xyz = tmp4.xyz * tmp8.yyy;
                tmp9.x = dot(tmp5.xy, float2(0.0000003, -1.0));
                tmp9.y = dot(tmp5.xy, float2(1.0, 0.0000003));
                tmp5.zw = tmp9.xy + float2(0.5, 0.5);
                tmp5.zw = tmp5.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp9 = tex2D(_PrimaryTex, tmp5.zw);
                tmp4.xyz = tmp8.xxx * tmp9.xyz + tmp4.xyz;
                tmp4.xyz = tmp8.zzz * tmp6.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp0.w = tmp1.w * tmp1.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp6.x = dot(tmp5.xy, float2(0.0000003, -1.0));
                tmp6.y = dot(tmp5.xy, float2(1.0, 0.0000003));
                tmp5.zw = tmp6.xy + float2(0.5, 0.5);
                tmp5.zw = tmp5.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp6 = tex2D(_DetailNoiseMask, tmp5.zw);
                tmp9 = inp.texcoord.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp10 = tex2D(_DetailNoiseMask, tmp9.xy);
                tmp9 = tex2D(_DetailNoiseMask, tmp9.zw);
                tmp1.w = tmp8.y * tmp10.x;
                tmp1.w = tmp8.x * tmp6.x + tmp1.w;
                tmp1.w = tmp8.z * tmp9.x + tmp1.w;
                tmp2.w = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = tmp0.w * -tmp1.w + tmp1.w;
                tmp3.xyz = tmp3.xyz * tmp1.www;
                tmp3.xyz = _EnableDetailTex.xxx * tmp3.xyz + tmp4.xyz;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                tmp2.xyz = -tmp2.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp0.xyz);
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp1.w = dot(tmp7.xyz, tmp2.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.x = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp2.x;
                tmp2.x = saturate(tmp7.y);
                tmp2.y = dot(abs(tmp7.xy), float2(0.333, 0.333));
                tmp2.x = tmp2.x + tmp2.y;
                tmp2.y = tmp2.x * tmp2.x;
                tmp2.xzw = tmp2.xxx * tmp2.xxx + glstate_lightmodel_ambient.xyz;
                tmp2.xzw = tmp2.xzw * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp2.xzw = tmp2.xzw * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp2.xzw = max(tmp2.xzw, float3(0.75, 0.75, 0.75));
                tmp2.xzw = min(tmp2.xzw, float3(1.0, 1.0, 1.0));
                tmp1.w = tmp1.w * tmp2.y;
                tmp0.w = tmp0.w * -tmp1.w + tmp1.w;
                tmp3.x = dot(tmp5.xy, float2(0.0000003, -1.0));
                tmp3.y = dot(tmp5.xy, float2(1.0, 0.0000003));
                tmp3.xy = tmp3.xy + float2(0.5, 0.5);
                tmp3.xy = tmp3.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp3 = tex2D(_Depth, tmp3.xy);
                tmp4 = inp.texcoord.zxxy * _Depth_ST + _Depth_ST;
                tmp5 = tex2D(_Depth, tmp4.xy);
                tmp4 = tex2D(_Depth, tmp4.zw);
                tmp1.w = tmp5.x * tmp8.y;
                tmp1.w = tmp8.x * tmp3.x + tmp1.w;
                tmp1.w = tmp8.z * tmp4.x + tmp1.w;
                tmp0.w = tmp0.w * tmp1.w;
                tmp3.xy = tmp1.ww * float2(0.33, 0.1) + float2(0.33, 0.45);
                tmp1.w = tmp0.w + tmp0.w;
                tmp2.xyz = tmp0.www * float3(0.5, 0.5, 0.5) + tmp2.xzw;
                tmp0.w = floor(tmp1.w);
                tmp1.w = tmp3.y - tmp3.x;
                tmp2.w = saturate(tmp7.y * 2.0 + -1.0);
                tmp1.w = tmp2.w * tmp1.w + tmp3.x;
                tmp2.w = 1.0 - tmp1.w;
                tmp3.xyz = _WorldSpaceLightPos0.www * -inp.texcoord.xyz + _WorldSpaceLightPos0.xyz;
                tmp3.w = dot(tmp3.xyz, tmp3.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp3.xyz = tmp3.www * tmp3.xyz;
                tmp3.x = dot(tmp3.xyz, tmp7.xyz);
                tmp3.x = max(tmp3.x, 0.0);
                tmp3.y = tmp3.x - 0.5;
                tmp3.y = -tmp3.y * 2.0 + 1.0;
                tmp2.w = -tmp3.y * tmp2.w + 1.0;
                tmp3.y = tmp3.x + tmp3.x;
                tmp3.x = tmp3.x > 0.5;
                tmp1.w = tmp1.w * tmp3.y;
                tmp1.w = saturate(tmp3.x ? tmp2.w : tmp1.w);
                tmp0.w = tmp1.w * 13.0 + tmp0.w;
                tmp0.w = saturate(tmp0.w - 5.0);
                tmp1.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp3 = tex2D(_LightTexture0, tmp1.ww);
                tmp3.xyz = tmp3.xxx * _LightColor0.xyz;
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp3.xyz = tmp2.xyz * tmp0.www + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz * tmp3.xyz;
                o.sv_target.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp0.xyz);
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}