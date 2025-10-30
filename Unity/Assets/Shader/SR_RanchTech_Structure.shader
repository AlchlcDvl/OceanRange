Shader "SR/RanchTech/Structure" {
	Properties {
		_AmbientOcclusion ("Ambient Occlusion", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_RampRed ("Ramp Red", 2D) = "white" {}
		_GlossRed ("Gloss Red", Range(0, 1)) = 0
		_RampGreen ("Ramp Green", 2D) = "white" {}
		_GlossGreen ("Gloss Green", Range(0, 1)) = 0
		_RampBlue ("Ramp Blue", 2D) = "white" {}
		_GlossBlue ("Gloss Blue", Range(0, 1)) = 0
		_RampBlack ("Ramp Black", 2D) = "white" {}
		_GlossBlack ("Gloss Black", Range(0, 1)) = 0
		_RampAlphaGlow ("Ramp Alpha (Glow)", 2D) = "white" {}
		_GlowShift ("Glow Shift", Range(0, 1)) = 0
		_Normal ("Normal", 2D) = "bump" {}
		[MaterialToggle] _TriplanarNormals ("Triplanar Normals", Float) = 0
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 10145
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
			float4 _RampRed_ST;
			float4 _RampGreen_ST;
			float4 _RampBlue_ST;
			float4 _RampBlack_ST;
			float4 _AmbientOcclusion_ST;
			float4 _Mask_ST;
			float4 _RampAlphaGlow_ST;
			float _GlowShift;
			float _GlossRed;
			float _GlossGreen;
			float _GlossBlue;
			float _GlossBlack;
			float4 _Normal_ST;
			float _TriplanarNormals;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _AmbientOcclusion;
			sampler2D _Mask;
			sampler2D _RampBlack;
			sampler2D _RampRed;
			sampler2D _RampGreen;
			sampler2D _RampBlue;
			sampler2D _RampAlphaGlow;
			
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
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                tmp0.xy = inp.texcoord2.zx * _Normal_ST.xy + _Normal_ST.zw;
                tmp0 = tex2D(_Normal, tmp0.xy);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.z = sqrt(tmp0.w);
                tmp1 = inp.texcoord2.xyyz * _Normal_ST + _Normal_ST;
                tmp2 = tex2D(_Normal, tmp1.zw);
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp2.z = sqrt(tmp0.w);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.z = sqrt(tmp0.w);
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp0.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * inp.texcoord3.xyz;
                tmp2.xyz = abs(tmp3.xxx) * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz - tmp2.xyz;
                tmp0.xyz = abs(tmp3.yyy) * tmp0.xyz + tmp2.xyz;
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                tmp0.xyz = abs(tmp3.zzz) * tmp1.xyz + tmp0.xyz;
                tmp1.xy = inp.texcoord1.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.z = sqrt(tmp0.w);
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp0.xyz = _TriplanarNormals.xxx * tmp0.xyz + tmp1.xyz;
                tmp0.w = tmp0.z * tmp0.z;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = saturate(tmp0.z * tmp0.w);
                tmp1.xyz = tmp0.yyy * inp.texcoord5.xyz;
                tmp1.xyz = tmp0.xxx * inp.texcoord4.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.zzz * tmp3.xyz + tmp1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp1.xyz;
                tmp2.w = dot(tmp0.xyz, tmp2.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp3.x = log(tmp2.w);
                tmp3.x = tmp3.x * 3.333;
                tmp3.x = exp(tmp3.x);
                tmp3.x = tmp3.x * tmp3.x;
                tmp3.y = tmp0.w * tmp3.x;
                tmp3.zw = inp.texcoord1.xy * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
                tmp4 = tex2D(_AmbientOcclusion, tmp3.zw);
                tmp3.y = dot(tmp3.xy, tmp4.xy);
                tmp3.y = tmp4.x + tmp3.y;
                tmp3.z = dot(-tmp2.xyz, tmp0.xyz);
                tmp3.z = tmp3.z + tmp3.z;
                tmp2.xyz = tmp0.xyz * -tmp3.zzz + -tmp2.xyz;
                tmp3.z = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp3.z = rsqrt(tmp3.z);
                tmp5.xyz = tmp3.zzz * _WorldSpaceLightPos0.xyz;
                tmp2.x = dot(tmp5.xyz, tmp2.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.x = log(tmp2.x);
                tmp2.y = _GlossRed - _GlossBlack;
                tmp3.zw = inp.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp6 = tex2D(_Mask, tmp3.zw);
                tmp2.y = tmp6.x * tmp2.y + _GlossBlack;
                tmp2.z = _GlossGreen - tmp2.y;
                tmp2.y = tmp6.y * tmp2.z + tmp2.y;
                tmp2.z = _GlossBlue - tmp2.y;
                tmp2.y = tmp6.z * tmp2.z + tmp2.y;
                tmp2.z = tmp4.x * tmp6.w;
                tmp2.y = tmp2.y * tmp2.z;
                tmp3.zw = tmp2.yy * float2(10.0, 7.0) + float2(1.0, 1.0);
                tmp3.zw = exp(tmp3.zw);
                tmp2.x = tmp2.x * tmp3.w;
                tmp2.x = exp(tmp2.x);
                tmp2.z = tmp2.x * tmp4.z;
                tmp2.x = tmp3.x * tmp0.w + tmp2.x;
                tmp4.x = tmp2.x * _RampAlphaGlow_ST.x;
                tmp2.x = saturate(tmp2.z * _LightColor0.x);
                tmp2.x = tmp2.x + tmp3.y;
                tmp2.x = tmp2.x * 0.667;
                tmp2.x = max(tmp2.x, 0.05);
                tmp2.x = min(tmp2.x, 0.95);
                tmp3.xy = tmp2.xx * _RampRed_ST.xy + _RampRed_ST.zw;
                tmp7 = tex2D(_RampRed, tmp3.xy);
                tmp3.xy = tmp2.xx * _RampBlack_ST.xy + _RampBlack_ST.zw;
                tmp8 = tex2D(_RampBlack, tmp3.xy);
                tmp3.xyw = tmp7.xyz - tmp8.xyz;
                tmp3.xyw = tmp6.xxx * tmp3.xyw + tmp8.xyz;
                tmp4.zw = tmp2.xx * _RampGreen_ST.xy + _RampGreen_ST.zw;
                tmp2.xz = tmp2.xx * _RampBlue_ST.xy + _RampBlue_ST.zw;
                tmp7 = tex2D(_RampBlue, tmp2.xz);
                tmp8 = tex2D(_RampGreen, tmp4.zw);
                tmp8.xyz = tmp8.xyz - tmp3.xyw;
                tmp3.xyw = tmp6.yyy * tmp8.xyz + tmp3.xyw;
                tmp7.xyz = tmp7.xyz - tmp3.xyw;
                tmp3.xyw = tmp6.zzz * tmp7.xyz + tmp3.xyw;
                tmp2.x = 1.0 - tmp6.w;
                tmp2.z = dot(tmp0.xyz, tmp5.xyz);
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp5.xyz;
                tmp5.xyz = float3(1.0, 1.0, 1.0) - glstate_lightmodel_ambient.xyz;
                tmp5.xyz = tmp2.zzz * tmp5.xyz + glstate_lightmodel_ambient.xyz;
                tmp5.xyz = max(tmp5.xyz, float3(0.0, 0.0, 0.0));
                tmp6.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp5.xyz = tmp5.xyz * _LightColor0.xyz + tmp6.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * tmp3.z;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp2.yyy * tmp0.xyz;
                tmp0.xyz = tmp5.xyz * tmp3.xyw + tmp0.xyz;
                tmp1.x = tmp2.w * tmp2.w;
                tmp1.x = tmp1.x * tmp2.w;
                tmp1.xyz = tmp1.xxx * tmp0.www + tmp3.xyw;
                tmp1.xyz = tmp1.xyz * float3(0.25, 0.25, 0.25);
                tmp4.y = _RampAlphaGlow_ST.y * _GlowShift;
                tmp2.yz = tmp4.xy + _RampAlphaGlow_ST.zw;
                tmp3 = tex2D(_RampAlphaGlow, tmp2.yz);
                tmp2.xyz = tmp2.xxx * tmp3.xyz;
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp0.w = tmp0.w * 6.28318;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 0.05 + 1.05;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp1.xyz = tmp1.xyz * tmp6.xyz + tmp2.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 111398
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
			float4 _LightColor0;
			float4 _RampRed_ST;
			float4 _RampGreen_ST;
			float4 _RampBlue_ST;
			float4 _RampBlack_ST;
			float4 _AmbientOcclusion_ST;
			float4 _Mask_ST;
			float _GlossRed;
			float _GlossGreen;
			float _GlossBlue;
			float _GlossBlack;
			float4 _Normal_ST;
			float _TriplanarNormals;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Normal;
			sampler2D _LightTexture0;
			sampler2D _AmbientOcclusion;
			sampler2D _Mask;
			sampler2D _RampBlack;
			sampler2D _RampRed;
			sampler2D _RampGreen;
			sampler2D _RampBlue;
			
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
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                tmp0.xy = inp.texcoord2.zx * _Normal_ST.xy + _Normal_ST.zw;
                tmp0 = tex2D(_Normal, tmp0.xy);
                tmp0.x = tmp0.w * tmp0.x;
                tmp0.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp0.xy, tmp0.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp0.z = sqrt(tmp0.w);
                tmp1 = inp.texcoord2.xyyz * _Normal_ST + _Normal_ST;
                tmp2 = tex2D(_Normal, tmp1.zw);
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp2.x = tmp2.w * tmp2.x;
                tmp2.xy = tmp2.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp2.z = sqrt(tmp0.w);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.z = sqrt(tmp0.w);
                tmp2.xyz = tmp2.xyz - tmp1.xyz;
                tmp0.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * inp.texcoord3.xyz;
                tmp2.xyz = abs(tmp3.xxx) * tmp2.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.xyz - tmp2.xyz;
                tmp0.xyz = abs(tmp3.yyy) * tmp0.xyz + tmp2.xyz;
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                tmp0.xyz = abs(tmp3.zzz) * tmp1.xyz + tmp0.xyz;
                tmp1.xy = inp.texcoord1.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp1 = tex2D(_Normal, tmp1.xy);
                tmp1.x = tmp1.w * tmp1.x;
                tmp1.xy = tmp1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.w = dot(tmp1.xy, tmp1.xy);
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.z = sqrt(tmp0.w);
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp0.xyz = _TriplanarNormals.xxx * tmp0.xyz + tmp1.xyz;
                tmp0.w = tmp0.z * tmp0.z;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = saturate(tmp0.z * tmp0.w);
                tmp1.xyz = tmp0.yyy * inp.texcoord5.xyz;
                tmp1.xyz = tmp0.xxx * inp.texcoord4.xyz + tmp1.xyz;
                tmp0.xyz = tmp0.zzz * tmp3.xyz + tmp1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp1.xyz;
                tmp2.w = dot(tmp0.xyz, tmp2.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = 1.0 - tmp2.w;
                tmp2.w = log(tmp2.w);
                tmp2.w = tmp2.w * 3.333;
                tmp2.w = exp(tmp2.w);
                tmp2.w = tmp2.w * tmp2.w;
                tmp0.w = tmp0.w * tmp2.w;
                tmp3.xy = inp.texcoord1.xy * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
                tmp3 = tex2D(_AmbientOcclusion, tmp3.xy);
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp0.w = tmp3.x + tmp0.w;
                tmp2.w = dot(-tmp2.xyz, tmp0.xyz);
                tmp2.w = tmp2.w + tmp2.w;
                tmp2.xyz = tmp0.xyz * -tmp2.www + -tmp2.xyz;
                tmp4.xyz = _WorldSpaceLightPos0.www * -inp.texcoord2.xyz + _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp4.xyz, tmp4.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp4.xyz = tmp2.www * tmp4.xyz;
                tmp2.x = dot(tmp4.xyz, tmp2.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.x = log(tmp2.x);
                tmp2.y = _GlossRed - _GlossBlack;
                tmp2.zw = inp.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp5 = tex2D(_Mask, tmp2.zw);
                tmp2.y = tmp5.x * tmp2.y + _GlossBlack;
                tmp2.z = _GlossGreen - tmp2.y;
                tmp2.y = tmp5.y * tmp2.z + tmp2.y;
                tmp2.z = _GlossBlue - tmp2.y;
                tmp2.y = tmp5.z * tmp2.z + tmp2.y;
                tmp2.z = tmp3.x * tmp5.w;
                tmp2.y = tmp2.y * tmp2.z;
                tmp2.zw = tmp2.yy * float2(10.0, 7.0) + float2(1.0, 1.0);
                tmp2.zw = exp(tmp2.zw);
                tmp2.x = tmp2.x * tmp2.w;
                tmp2.x = exp(tmp2.x);
                tmp2.x = tmp2.x * tmp3.z;
                tmp2.w = dot(inp.texcoord6.xyz, inp.texcoord6.xyz);
                tmp3 = tex2D(_LightTexture0, tmp2.ww);
                tmp3.yzw = tmp3.xxx * _LightColor0.xyz;
                tmp2.w = tmp3.x * 0.334 + 0.333;
                tmp2.x = saturate(tmp2.x * tmp3.y);
                tmp0.w = tmp0.w + tmp2.x;
                tmp0.w = tmp0.w * tmp2.w;
                tmp0.w = max(tmp0.w, 0.05);
                tmp0.w = min(tmp0.w, 0.95);
                tmp2.xw = tmp0.ww * _RampRed_ST.xy + _RampRed_ST.zw;
                tmp6 = tex2D(_RampRed, tmp2.xw);
                tmp2.xw = tmp0.ww * _RampBlack_ST.xy + _RampBlack_ST.zw;
                tmp7 = tex2D(_RampBlack, tmp2.xw);
                tmp6.xyz = tmp6.xyz - tmp7.xyz;
                tmp6.xyz = tmp5.xxx * tmp6.xyz + tmp7.xyz;
                tmp2.xw = tmp0.ww * _RampGreen_ST.xy + _RampGreen_ST.zw;
                tmp5.xw = tmp0.ww * _RampBlue_ST.xy + _RampBlue_ST.zw;
                tmp7 = tex2D(_RampBlue, tmp5.xw);
                tmp8 = tex2D(_RampGreen, tmp2.xw);
                tmp8.xyz = tmp8.xyz - tmp6.xyz;
                tmp5.xyw = tmp5.yyy * tmp8.xyz + tmp6.xyz;
                tmp6.xyz = tmp7.xyz - tmp5.xyw;
                tmp5.xyz = tmp5.zzz * tmp6.xyz + tmp5.xyw;
                tmp0.w = dot(tmp0.xyz, tmp4.xyz);
                tmp1.xyz = tmp1.xyz * tmp1.www + tmp4.xyz;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - glstate_lightmodel_ambient.xyz;
                tmp4.xyz = tmp0.www * tmp4.xyz + glstate_lightmodel_ambient.xyz;
                tmp4.xyz = max(tmp4.xyz, float3(0.0, 0.0, 0.0));
                tmp4.xyz = tmp3.yzw * tmp4.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * tmp2.z;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp3.yzw;
                tmp0.xyz = tmp2.yyy * tmp0.xyz;
                o.sv_target.xyz = tmp4.xyz * tmp5.xyz + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}