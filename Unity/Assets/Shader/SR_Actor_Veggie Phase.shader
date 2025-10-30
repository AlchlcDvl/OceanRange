Shader "SR/Actor/Veggie Phase" {
	Properties {
		_AmbientOcclusion ("Ambient Occlusion", 2D) = "white" {}
		_Mask ("Mask", 2D) = "white" {}
		_RampRed ("Ramp Red", 2D) = "white" {}
		_GlossRed ("Gloss Red", Range(0, 1)) = 0
		_GlossPowerRed ("Gloss Power Red", Float) = 1
		_RampGreen ("Ramp Green", 2D) = "white" {}
		_GlossGreen ("Gloss Green", Range(0, 1)) = 0
		_GlossPowerGreen ("Gloss Power Green", Float) = 1
		_RampBlue ("Ramp Blue", 2D) = "white" {}
		_GlossBlue ("Gloss Blue", Range(0, 1)) = 0
		_GlossPowerBlue ("Gloss Power Blue", Float) = 1
		_RampBlack ("Ramp Black", 2D) = "white" {}
		_GlossBlack ("Gloss Black", Range(0, 1)) = 0
		_GlossPowerBlack ("Gloss Power Black", Float) = 1
		_Rot ("Rot", Range(0, 1)) = 0
		_AvgCycleLength ("AvgCycleLength", Range(1, 10)) = 3
		_CycleGlitchRatio ("CycleGlitchRatio", Range(0, 1)) = 1
		_Fade ("Fade", Range(0, 1)) = 1
		_Static ("Static", 2D) = "black" {}
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			GpuProgramID 41398
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
				float4 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
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
			float _GlossRed;
			float _GlossGreen;
			float _GlossBlue;
			float _GlossBlack;
			float _Rot;
			float _GlossPowerRed;
			float _GlossPowerGreen;
			float _GlossPowerBlue;
			float _GlossPowerBlack;
			float _AvgCycleLength;
			float _CycleGlitchRatio;
			float _Fade;
			float4 _Static_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Static;
			sampler2D _AmbientOcclusion;
			sampler2D _Mask;
			sampler2D _RampBlack;
			sampler2D _RampRed;
			sampler2D _RampGreen;
			sampler2D _RampBlue;
			
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
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord4 = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp8;
                tmp0.x = inp.texcoord4.y / inp.texcoord4.w;
                tmp0.y = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.x = tmp0.x * _ScreenParams.y;
                tmp0.x = tmp0.x * 0.25;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 4.0;
                tmp0.x = floor(tmp0.x);
                tmp0.y = unity_ObjectToWorld._m23 + unity_ObjectToWorld._m03;
                tmp0.y = tmp0.y * 0.5;
                tmp0.y = frac(tmp0.y);
                tmp0.zw = _TimeEditor.yz + _Time.yz;
                tmp0.w = tmp0.y * 10.0 + tmp0.w;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = frac(tmp0.w);
                tmp1.x = tmp0.w * tmp0.w;
                tmp1.x = tmp0.w * tmp1.x;
                tmp0.w = tmp0.w * 16.0;
                tmp0.w = round(tmp0.w);
                tmp1.x = tmp1.x * 80.0;
                tmp1.x = round(tmp1.x);
                tmp1.y = tmp1.x + 0.2127;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * 0.3713 + tmp1.y;
                tmp1.y = tmp1.x * 489.123;
                tmp1.x = tmp1.x + 1.0;
                tmp1.y = sin(tmp1.y);
                tmp1.y = tmp1.y * 4.789;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.y = tmp0.y + tmp0.z;
                tmp1.zw = tmp1.yy * float2(0.5, 0.25);
                tmp1.xzw = frac(tmp1.xzw);
                tmp1.zw = tmp1.zw * float2(64.0, 4.0);
                tmp1.zw = round(tmp1.zw);
                tmp2.xy = tmp1.zw * float2(0.125, 0.5);
                tmp2.zw = floor(tmp2.xy);
                tmp2.y = -tmp2.z * 8.0 + tmp1.z;
                tmp2.x = -tmp2.w * 2.0 + tmp1.w;
                tmp1.z = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp3.xyz = tmp1.zzz * inp.texcoord3.xyz;
                tmp1.zw = tmp3.yy * unity_MatrixV._m01_m11;
                tmp1.zw = unity_MatrixV._m00_m10 * tmp3.xx + tmp1.zw;
                tmp1.zw = unity_MatrixV._m02_m12 * tmp3.zz + tmp1.zw;
                tmp1.zw = tmp1.zw * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp4.xy = tmp0.ww + tmp1.zw;
                tmp0.yw = tmp0.yy + tmp1.zw;
                tmp0.yz = tmp0.zz * float2(0.75, -0.25) + tmp0.yw;
                tmp0.yz = tmp0.yz * _Static_ST.xy + _Static_ST.zw;
                tmp5 = tex2D(_Static, tmp0.yz);
                tmp0.yz = tmp2.yz + tmp4.xy;
                tmp1.zw = tmp2.xw + tmp4.xy;
                tmp1.zw = tmp1.zw * _Static_ST.xy;
                tmp1.zw = tmp1.zw * float2(0.5, 0.5) + _Static_ST.zw;
                tmp2 = tex2D(_Static, tmp1.zw);
                tmp0.yz = tmp0.yz * _Static_ST.xy;
                tmp0.yz = tmp0.yz * float2(0.125, 0.125) + _Static_ST.zw;
                tmp4 = tex2D(_Static, tmp0.yz);
                tmp0.y = max(tmp2.z, tmp4.z);
                tmp0.y = tmp0.y + tmp5.y;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp4.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.w = dot(tmp3.xyz, tmp4.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.z = log(tmp0.w);
                tmp1.zw = tmp1.zz * float2(1.25, 3.333);
                tmp1.zw = exp(tmp1.zw);
                tmp0.y = tmp0.y * tmp1.z;
                tmp1.z = tmp1.w * tmp1.w;
                tmp0.y = tmp0.y * tmp1.x;
                tmp1.x = frac(tmp1.y);
                tmp1.x = tmp1.y + tmp1.x;
                tmp1.x = tmp1.x / _AvgCycleLength;
                tmp1.x = frac(tmp1.x);
                tmp1.y = _CycleGlitchRatio >= tmp1.x;
                tmp1.x = tmp1.x >= _CycleGlitchRatio;
                tmp1.yw = tmp1.yx ? 1.0 : 0.0;
                tmp1.y = tmp1.w * tmp1.y;
                tmp1.x = tmp1.x ? 0.0 : tmp1.y;
                tmp1.x = tmp1.x + tmp1.w;
                tmp1.y = inp.color.w * _Fade;
                tmp1.w = tmp1.y * 4.0;
                tmp1.w = round(tmp1.w);
                tmp1.x = tmp1.x * tmp1.w;
                tmp1.x = tmp1.x * 0.25;
                tmp0.y = saturate(-tmp1.x * tmp0.y + 1.0);
                tmp1.x = rsqrt(tmp0.w);
                tmp1.x = 1.0 / tmp1.x;
                tmp1.x = saturate(tmp1.x * 2.5 + -0.5);
                tmp0.y = tmp0.y - tmp1.x;
                tmp0.y = tmp0.y + 1.0;
                tmp0.y = saturate(tmp0.y * 20.0 + -14.0);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp1.y * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * 0.6666667 + -0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = dot(-tmp4.xyz, tmp3.xyz);
                tmp0.x = tmp0.x + tmp0.x;
                tmp1.xyw = tmp3.xyz * -tmp0.xxx + -tmp4.xyz;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp4.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp4.xyz, tmp1.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.y = _GlossRed - _GlossBlack;
                tmp1.xy = inp.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp5 = tex2D(_Mask, tmp1.xy);
                tmp0.y = tmp5.x * tmp0.y + _GlossBlack;
                tmp1.x = _GlossGreen - tmp0.y;
                tmp0.y = tmp5.y * tmp1.x + tmp0.y;
                tmp1.x = _GlossBlue - tmp0.y;
                tmp0.y = tmp5.z * tmp1.x + tmp0.y;
                tmp1.xy = inp.texcoord1.xy * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
                tmp6 = tex2D(_AmbientOcclusion, tmp1.xy);
                tmp1.x = tmp6.x * tmp6.x;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp6.x * tmp1.x;
                tmp0.y = tmp0.y * tmp1.x;
                tmp1.y = tmp0.y * 16.0 + -1.0;
                tmp0.y = _Rot * -tmp0.y + tmp0.y;
                tmp1.y = exp(tmp1.y);
                tmp0.x = tmp0.x * tmp1.y;
                tmp0.x = exp(tmp0.x);
                tmp1.y = _GlossPowerRed - _GlossPowerBlack;
                tmp1.y = tmp5.x * tmp1.y + _GlossPowerBlack;
                tmp1.w = _GlossPowerGreen - tmp1.y;
                tmp1.y = tmp5.y * tmp1.w + tmp1.y;
                tmp1.w = _GlossPowerBlue - tmp1.y;
                tmp1.y = tmp5.z * tmp1.w + tmp1.y;
                tmp0.x = tmp0.x * tmp1.y;
                tmp0.x = tmp1.x * tmp0.x;
                tmp1.y = 1.0 - _Rot;
                tmp0.x = tmp0.x * tmp1.y;
                tmp1.y = saturate(tmp6.z + tmp6.z);
                tmp0.x = tmp0.x * tmp1.y;
                tmp1.y = dot(tmp1.xy, tmp1.xy);
                tmp1.y = tmp6.x + tmp1.y;
                tmp1.z = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp0.x = saturate(tmp0.x * tmp1.z);
                tmp0.x = tmp0.x + tmp1.y;
                tmp1.yz = _Rot.xx * float2(-0.5, -0.25) + float2(1.0, 1.0);
                tmp1.y = tmp1.y * 0.667;
                tmp0.x = tmp0.x * tmp1.y;
                tmp0.x = max(tmp0.x, 0.05);
                tmp0.x = min(tmp0.x, 0.95);
                tmp1.yw = tmp0.xx * _RampRed_ST.xy + _RampRed_ST.zw;
                tmp6 = tex2D(_RampRed, tmp1.yw);
                tmp1.yw = tmp0.xx * _RampBlack_ST.xy + _RampBlack_ST.zw;
                tmp7 = tex2D(_RampBlack, tmp1.yw);
                tmp6.xyz = tmp6.xyz - tmp7.xyz;
                tmp6.xyz = tmp5.xxx * tmp6.xyz + tmp7.xyz;
                tmp1.yw = tmp0.xx * _RampGreen_ST.xy + _RampGreen_ST.zw;
                tmp5.xw = tmp0.xx * _RampBlue_ST.xy + _RampBlue_ST.zw;
                tmp7 = tex2D(_RampBlue, tmp5.xw);
                tmp8 = tex2D(_RampGreen, tmp1.yw);
                tmp8.xyz = tmp8.xyz - tmp6.xyz;
                tmp5.xyw = tmp5.yyy * tmp8.xyz + tmp6.xyz;
                tmp6.xyz = tmp7.xyz - tmp5.xyw;
                tmp5.xyz = tmp5.zzz * tmp6.xyz + tmp5.xyw;
                tmp6.xyz = tmp1.zzz * tmp5.xyz;
                tmp0.x = dot(tmp6.xyz, float3(0.3, 0.59, 0.11));
                tmp1.yzw = -tmp5.xyz * tmp1.zzz + tmp0.xxx;
                tmp0.x = _Rot * 0.8;
                tmp1.yzw = tmp0.xxx * tmp1.yzw + tmp6.xyz;
                tmp2.xyz = tmp2.xyz * tmp0.zzz + tmp4.xyz;
                tmp0.x = dot(tmp3.xyz, tmp4.xyz);
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(tmp2.xyz, tmp3.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = log(tmp0.z);
                tmp2.x = tmp0.y * 10.0 + 1.0;
                tmp2.x = exp(tmp2.x);
                tmp0.z = tmp0.z * tmp2.x;
                tmp0.z = exp(tmp0.z);
                tmp2.xyz = tmp0.zzz * _LightColor0.xyz;
                tmp2.xyz = tmp0.yyy * tmp2.xyz;
                tmp3.xyz = float3(1.0, 1.0, 1.0) - glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xxx * tmp3.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.xyz = max(tmp0.xyz, float3(0.0, 0.0, 0.0));
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.xyz = tmp0.xyz * _LightColor0.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.yzw + tmp2.xyz;
                tmp1.y = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.y;
                tmp1.y = dot(tmp5.xyz, float3(0.3, 0.59, 0.11));
                tmp1.yzw = tmp1.yyy - tmp5.xyz;
                tmp1.yzw = tmp1.yzw * float3(0.5, 0.5, 0.5) + tmp5.xyz;
                tmp1.xyz = tmp0.www * tmp1.xxx + tmp1.yzw;
                tmp1.xyz = tmp1.xyz * float3(0.8, 0.8, 0.8);
                o.sv_target.xyz = tmp1.xyz * tmp3.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 97256
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
				float4 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
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
			float4 _TimeEditor;
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
			float _Rot;
			float _GlossPowerRed;
			float _GlossPowerGreen;
			float _GlossPowerBlue;
			float _GlossPowerBlack;
			float _AvgCycleLength;
			float _CycleGlitchRatio;
			float _Fade;
			float4 _Static_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Static;
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
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord4 = tmp1;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1.xy = v.texcoord1.xy;
                o.texcoord2 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord3.xyz = tmp1.www * tmp1.xyz;
                o.color = v.color;
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
                float4 tmp6;
                float4 tmp7;
                float4 tmp8;
                tmp0.x = inp.texcoord4.y / inp.texcoord4.w;
                tmp0.y = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.x = tmp0.x * _ScreenParams.y;
                tmp0.x = tmp0.x * 0.25;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 4.0;
                tmp0.x = floor(tmp0.x);
                tmp0.y = unity_ObjectToWorld._m23 + unity_ObjectToWorld._m03;
                tmp0.y = tmp0.y * 0.5;
                tmp0.y = frac(tmp0.y);
                tmp0.zw = _TimeEditor.yz + _Time.yz;
                tmp0.w = tmp0.y * 10.0 + tmp0.w;
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = frac(tmp0.w);
                tmp1.x = tmp0.w * tmp0.w;
                tmp1.x = tmp0.w * tmp1.x;
                tmp0.w = tmp0.w * 16.0;
                tmp0.w = round(tmp0.w);
                tmp1.x = tmp1.x * 80.0;
                tmp1.x = round(tmp1.x);
                tmp1.y = tmp1.x + 0.2127;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * 0.3713 + tmp1.y;
                tmp1.y = tmp1.x * 489.123;
                tmp1.x = tmp1.x + 1.0;
                tmp1.y = sin(tmp1.y);
                tmp1.y = tmp1.y * 4.789;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.y = tmp0.y + tmp0.z;
                tmp1.zw = tmp1.yy * float2(0.5, 0.25);
                tmp1.xzw = frac(tmp1.xzw);
                tmp1.zw = tmp1.zw * float2(64.0, 4.0);
                tmp1.zw = round(tmp1.zw);
                tmp2.xy = tmp1.zw * float2(0.125, 0.5);
                tmp2.zw = floor(tmp2.xy);
                tmp2.y = -tmp2.z * 8.0 + tmp1.z;
                tmp2.x = -tmp2.w * 2.0 + tmp1.w;
                tmp1.z = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp3.xyz = tmp1.zzz * inp.texcoord3.xyz;
                tmp1.zw = tmp3.yy * unity_MatrixV._m01_m11;
                tmp1.zw = unity_MatrixV._m00_m10 * tmp3.xx + tmp1.zw;
                tmp1.zw = unity_MatrixV._m02_m12 * tmp3.zz + tmp1.zw;
                tmp1.zw = tmp1.zw * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp4.xy = tmp0.ww + tmp1.zw;
                tmp0.yw = tmp0.yy + tmp1.zw;
                tmp0.yz = tmp0.zz * float2(0.75, -0.25) + tmp0.yw;
                tmp0.yz = tmp0.yz * _Static_ST.xy + _Static_ST.zw;
                tmp5 = tex2D(_Static, tmp0.yz);
                tmp0.yz = tmp2.yz + tmp4.xy;
                tmp1.zw = tmp2.xw + tmp4.xy;
                tmp1.zw = tmp1.zw * _Static_ST.xy;
                tmp1.zw = tmp1.zw * float2(0.5, 0.5) + _Static_ST.zw;
                tmp2 = tex2D(_Static, tmp1.zw);
                tmp0.yz = tmp0.yz * _Static_ST.xy;
                tmp0.yz = tmp0.yz * float2(0.125, 0.125) + _Static_ST.zw;
                tmp4 = tex2D(_Static, tmp0.yz);
                tmp0.y = max(tmp2.z, tmp4.z);
                tmp0.y = tmp0.y + tmp5.y;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp4.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.w = dot(tmp3.xyz, tmp4.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.z = log(tmp0.w);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.w = 1.0 / tmp0.w;
                tmp0.w = saturate(tmp0.w * 2.5 + -0.5);
                tmp1.zw = tmp1.zz * float2(1.25, 3.333);
                tmp1.zw = exp(tmp1.zw);
                tmp0.y = tmp0.y * tmp1.z;
                tmp1.z = tmp1.w * tmp1.w;
                tmp0.y = tmp0.y * tmp1.x;
                tmp1.x = frac(tmp1.y);
                tmp1.x = tmp1.y + tmp1.x;
                tmp1.x = tmp1.x / _AvgCycleLength;
                tmp1.x = frac(tmp1.x);
                tmp1.y = _CycleGlitchRatio >= tmp1.x;
                tmp1.x = tmp1.x >= _CycleGlitchRatio;
                tmp1.yw = tmp1.yx ? 1.0 : 0.0;
                tmp1.y = tmp1.w * tmp1.y;
                tmp1.x = tmp1.x ? 0.0 : tmp1.y;
                tmp1.x = tmp1.x + tmp1.w;
                tmp1.y = inp.color.w * _Fade;
                tmp1.w = tmp1.y * 4.0;
                tmp1.w = round(tmp1.w);
                tmp1.x = tmp1.x * tmp1.w;
                tmp1.x = tmp1.x * 0.25;
                tmp0.y = saturate(-tmp1.x * tmp0.y + 1.0);
                tmp0.y = tmp0.y - tmp0.w;
                tmp0.y = tmp0.y + 1.0;
                tmp0.y = saturate(tmp0.y * 20.0 + -14.0);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp1.y * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = tmp0.x * 0.6666667 + -0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = dot(-tmp4.xyz, tmp3.xyz);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.xyw = tmp3.xyz * -tmp0.xxx + -tmp4.xyz;
                tmp1.xyw = _WorldSpaceLightPos0.www * -inp.texcoord2.xyz + _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp1.xyz, tmp1.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp1.xyw = tmp1.xyw * tmp2.www;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.yw = inp.texcoord1.xy * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
                tmp4 = tex2D(_AmbientOcclusion, tmp0.yw);
                tmp0.y = tmp4.x * tmp4.x;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp4.x * tmp0.y;
                tmp0.w = _GlossRed - _GlossBlack;
                tmp4.yw = inp.texcoord.xy * _Mask_ST.xy + _Mask_ST.zw;
                tmp5 = tex2D(_Mask, tmp4.yw);
                tmp0.w = tmp5.x * tmp0.w + _GlossBlack;
                tmp2.w = _GlossGreen - tmp0.w;
                tmp0.w = tmp5.y * tmp2.w + tmp0.w;
                tmp2.w = _GlossBlue - tmp0.w;
                tmp0.w = tmp5.z * tmp2.w + tmp0.w;
                tmp0.w = tmp0.w * tmp0.y;
                tmp2.w = tmp0.w * 16.0 + -1.0;
                tmp0.w = _Rot * -tmp0.w + tmp0.w;
                tmp2.w = exp(tmp2.w);
                tmp0.x = tmp0.x * tmp2.w;
                tmp0.x = exp(tmp0.x);
                tmp2.w = _GlossPowerRed - _GlossPowerBlack;
                tmp2.w = tmp5.x * tmp2.w + _GlossPowerBlack;
                tmp3.w = _GlossPowerGreen - tmp2.w;
                tmp2.w = tmp5.y * tmp3.w + tmp2.w;
                tmp3.w = _GlossPowerBlue - tmp2.w;
                tmp2.w = tmp5.z * tmp3.w + tmp2.w;
                tmp0.x = tmp0.x * tmp2.w;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = 1.0 - _Rot;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.y = saturate(tmp4.z + tmp4.z);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.y = dot(tmp1.xy, tmp0.xy);
                tmp0.y = tmp4.x + tmp0.y;
                tmp1.z = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp2.w = dot(inp.texcoord5.xyz, inp.texcoord5.xyz);
                tmp4 = tex2D(_LightTexture0, tmp2.ww);
                tmp1.z = tmp1.z * tmp4.x;
                tmp0.x = saturate(tmp0.x * tmp1.z);
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.y = tmp4.x * 0.334 + 0.333;
                tmp4.xyz = tmp4.xxx * _LightColor0.xyz;
                tmp6.xy = _Rot.xx * float2(-0.5, -0.25) + float2(1.0, 1.0);
                tmp0.y = tmp0.y * tmp6.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = max(tmp0.x, 0.05);
                tmp0.x = min(tmp0.x, 0.95);
                tmp6.xz = tmp0.xx * _RampRed_ST.xy + _RampRed_ST.zw;
                tmp7 = tex2D(_RampRed, tmp6.xz);
                tmp6.xz = tmp0.xx * _RampBlack_ST.xy + _RampBlack_ST.zw;
                tmp8 = tex2D(_RampBlack, tmp6.xz);
                tmp6.xzw = tmp7.xyz - tmp8.xyz;
                tmp6.xzw = tmp5.xxx * tmp6.xzw + tmp8.xyz;
                tmp5.xw = tmp0.xx * _RampGreen_ST.xy + _RampGreen_ST.zw;
                tmp0.xy = tmp0.xx * _RampBlue_ST.xy + _RampBlue_ST.zw;
                tmp7 = tex2D(_RampBlue, tmp0.xy);
                tmp8 = tex2D(_RampGreen, tmp5.xw);
                tmp8.xyz = tmp8.xyz - tmp6.xzw;
                tmp5.xyw = tmp5.yyy * tmp8.xyz + tmp6.xzw;
                tmp6.xzw = tmp7.xyz - tmp5.xyw;
                tmp5.xyz = tmp5.zzz * tmp6.xzw + tmp5.xyw;
                tmp6.xzw = tmp6.yyy * tmp5.xyz;
                tmp0.x = dot(tmp6.xyz, float3(0.3, 0.59, 0.11));
                tmp5.xyz = -tmp5.xyz * tmp6.yyy + tmp0.xxx;
                tmp0.x = _Rot * 0.8;
                tmp5.xyz = tmp0.xxx * tmp5.xyz + tmp6.xzw;
                tmp0.xyz = tmp2.xyz * tmp0.zzz + tmp1.xyw;
                tmp1.x = dot(tmp3.xyz, tmp1.xyz);
                tmp1.y = dot(tmp0.xyz, tmp0.xyz);
                tmp1.y = rsqrt(tmp1.y);
                tmp0.xyz = tmp0.xyz * tmp1.yyy;
                tmp0.x = dot(tmp0.xyz, tmp3.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.y = tmp0.w * 10.0 + 1.0;
                tmp0.y = exp(tmp0.y);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp4.xyz;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.yzw = float3(1.0, 1.0, 1.0) - glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                tmp1.xyz = tmp4.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp5.xyz + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 160390
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float _AvgCycleLength;
			float _CycleGlitchRatio;
			float _Fade;
			float4 _Static_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Static;
			
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
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp1.x = tmp0.z + tmp1.x;
                tmp1.y = min(tmp0.w, tmp1.x);
                tmp1.y = tmp1.y - tmp1.x;
                o.position.z = unity_LightShadowBias.y * tmp1.y + tmp1.x;
                o.position.xyw = tmp0.xyw;
                o.texcoord3 = tmp0;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xy = tmp0.yy * unity_MatrixV._m01_m11;
                tmp1.xy = unity_MatrixV._m00_m10 * tmp0.xx + tmp1.xy;
                tmp1.xy = unity_MatrixV._m02_m12 * tmp0.zz + tmp1.xy;
                tmp1.xy = tmp1.xy * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp0.w = unity_ObjectToWorld._m23 + unity_ObjectToWorld._m03;
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = frac(tmp0.w);
                tmp1.zw = _TimeEditor.yz + _Time.yz;
                tmp1.w = tmp0.w * 10.0 + tmp1.w;
                tmp1.w = sin(tmp1.w);
                tmp1.w = tmp1.w * 0.5;
                tmp1.w = frac(tmp1.w);
                tmp2.x = tmp1.w * 16.0;
                tmp2.x = round(tmp2.x);
                tmp2.xy = tmp1.xy + tmp2.xx;
                tmp1.xy = tmp0.ww + tmp1.xy;
                tmp0.w = tmp0.w + tmp1.z;
                tmp1.xy = tmp1.zz * float2(0.75, -0.25) + tmp1.xy;
                tmp1.xy = tmp1.xy * _Static_ST.xy + _Static_ST.zw;
                tmp3 = tex2D(_Static, tmp1.xy);
                tmp1.xy = tmp0.ww * float2(0.5, 0.25);
                tmp1.xy = frac(tmp1.xy);
                tmp1.xy = tmp1.xy * float2(64.0, 4.0);
                tmp1.xy = round(tmp1.xy);
                tmp2.zw = tmp1.xy * float2(0.125, 0.5);
                tmp4.zw = floor(tmp2.zw);
                tmp4.y = -tmp4.z * 8.0 + tmp1.x;
                tmp4.x = -tmp4.w * 2.0 + tmp1.y;
                tmp1.xy = tmp2.xy + tmp4.xw;
                tmp2.xy = tmp2.xy + tmp4.yz;
                tmp2.xy = tmp2.xy * _Static_ST.xy;
                tmp2.xy = tmp2.xy * float2(0.125, 0.125) + _Static_ST.zw;
                tmp2 = tex2D(_Static, tmp2.xy);
                tmp1.xy = tmp1.xy * _Static_ST.xy;
                tmp1.xy = tmp1.xy * float2(0.5, 0.5) + _Static_ST.zw;
                tmp4 = tex2D(_Static, tmp1.xy);
                tmp1.x = max(tmp2.z, tmp4.z);
                tmp1.x = tmp1.x + tmp3.y;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.y = dot(tmp2.xyz, tmp2.xyz);
                tmp1.y = rsqrt(tmp1.y);
                tmp2.xyz = tmp1.yyy * tmp2.xyz;
                tmp0.x = dot(tmp0.xyz, tmp2.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = log(tmp0.x);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = saturate(tmp0.x * 2.5 + -0.5);
                tmp0.y = tmp0.y * 1.25;
                tmp0.y = exp(tmp0.y);
                tmp0.z = tmp1.w * tmp1.w;
                tmp0.yz = tmp1.xw * tmp0.yz;
                tmp0.z = tmp0.z * 80.0;
                tmp0.z = round(tmp0.z);
                tmp1.x = tmp0.z + 0.2127;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * 0.3713 + tmp1.x;
                tmp1.x = tmp0.z * 489.123;
                tmp0.z = tmp0.z + 1.0;
                tmp1.x = sin(tmp1.x);
                tmp1.x = tmp1.x * 4.789;
                tmp1.x = tmp1.x * tmp1.x;
                tmp0.z = tmp0.z * tmp1.x;
                tmp0.z = frac(tmp0.z);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = frac(tmp0.w);
                tmp0.z = tmp0.w + tmp0.z;
                tmp0.z = tmp0.z / _AvgCycleLength;
                tmp0.z = frac(tmp0.z);
                tmp0.w = _CycleGlitchRatio >= tmp0.z;
                tmp0.z = tmp0.z >= _CycleGlitchRatio;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp1.x = tmp0.z ? 1.0 : 0.0;
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.z = tmp0.z ? 0.0 : tmp0.w;
                tmp0.z = tmp0.z + tmp1.x;
                tmp0.w = inp.color.w * _Fade;
                tmp1.x = tmp0.w * 4.0;
                tmp1.x = round(tmp1.x);
                tmp0.z = tmp0.z * tmp1.x;
                tmp0.z = tmp0.z * 0.25;
                tmp0.y = saturate(-tmp0.z * tmp0.y + 1.0);
                tmp0.x = tmp0.y - tmp0.x;
                tmp0.x = tmp0.x + 1.0;
                tmp0.x = saturate(tmp0.x * 20.0 + -14.0);
                tmp0.y = inp.texcoord3.y / inp.texcoord3.w;
                tmp0.z = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = tmp0.y * 0.5 + 0.5;
                tmp0.y = tmp0.y * _ScreenParams.y;
                tmp0.y = tmp0.y * 0.25;
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.y * 4.0;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y * tmp0.x;
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 0.6666667 + -0.5;
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