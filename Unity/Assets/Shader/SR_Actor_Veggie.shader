Shader "SR/Actor/Veggie" {
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
		_SwayStrength ("Sway Strength", Range(0, 2)) = 1
		[MaterialToggle] _VertexColorMask ("Vertex Color Mask", Float) = 0
		_WindTurbulance ("Wind Turbulance", Float) = 2
		_Rot ("Rot", Range(0, 1)) = 0
		_RotDirection ("Rot Direction", Vector) = (0,1,1,1)
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Cull Off
			GpuProgramID 52085
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
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			float _SwayStrength;
			float _VertexColorMask;
			float _Rot;
			float4 _RotDirection;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _RampRed_ST;
			float4 _RampGreen_ST;
			float4 _RampBlue_ST;
			float4 _RampBlack_ST;
			float _GlossRed;
			float _GlossGreen;
			float _GlossBlue;
			float _GlossBlack;
			float _GlossPowerRed;
			float _GlossPowerGreen;
			float _GlossPowerBlue;
			float _GlossPowerBlack;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
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
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.w = tmp0.y + tmp0.x;
                tmp0.w = tmp0.z + tmp0.w;
                tmp0.xyz = tmp0.xyz - unity_ObjectToWorld._m03_m13_m23;
                tmp1.x = _TimeEditor.z + _Time.z;
                tmp0.w = tmp0.w * 0.3333333 + tmp1.x;
                tmp0.w = tmp0.w * 0.5305164;
                tmp0.w = sin(tmp0.w);
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 3.333333;
                tmp1.xyz = unity_WorldToObject._m01_m11_m21 * float3(0.1, 0.1, 0.1) + unity_WorldToObject._m00_m10_m20;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + tmp1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _SwayStrength.xxx;
                tmp0.w = v.color.x - v.texcoord.y;
                tmp0.w = _VertexColorMask * tmp0.w + v.texcoord.y;
                tmp1.xyz = tmp1.xyz * tmp0.www;
                tmp1.xyz = tmp1.xyz * float3(0.1, 0.1, 0.1);
                tmp1.w = _RotDirection.w * -0.15;
                tmp2.xyz = tmp1.www * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = tmp2.xyz * tmp0.www + -tmp1.xyz;
                tmp1.xyz = _Rot.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.w = 1.0 - tmp0.w;
                tmp1.w = _Rot * -0.15;
                tmp2.xyz = tmp1.www * v.normal.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _RotDirection.xyz;
                tmp1.xyz = tmp2.xyz * float3(0.15, 0.15, 0.15) + tmp1.xyz;
                tmp2.x = unity_WorldToObject._m00;
                tmp2.y = unity_WorldToObject._m01;
                tmp2.z = unity_WorldToObject._m02;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp2.x = 1.0 / tmp0.w;
                tmp3.x = unity_WorldToObject._m10;
                tmp3.y = unity_WorldToObject._m11;
                tmp3.z = unity_WorldToObject._m12;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp2.y = 1.0 / tmp0.w;
                tmp3.x = unity_WorldToObject._m20;
                tmp3.y = unity_WorldToObject._m21;
                tmp3.z = unity_WorldToObject._m22;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp2.z = 1.0 / tmp0.w;
                tmp1.xyz = tmp1.xyz / tmp2.xyz;
                tmp2.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp0.xyw = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp2.xyz;
                tmp0.xyz = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
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
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
                return o;
			}
			// Keywords: DIRECTIONAL
			fout frag(v2f inp, float facing: VFACE)
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
                tmp0.x = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord3.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = dot(-tmp2.xyz, tmp0.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp3.xyz = tmp0.xyz * -tmp1.www + -tmp2.xyz;
                tmp1.w = dot(tmp0.xyz, tmp2.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp2.xyz = tmp2.xxx * _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp2.xyz, tmp3.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = log(tmp2.w);
                tmp3.x = _GlossRed - _GlossBlack;
                tmp4 = tex2D(_Mask, inp.texcoord.xy);
                tmp3.x = tmp4.x * tmp3.x + _GlossBlack;
                tmp3.y = _GlossGreen - tmp3.x;
                tmp3.x = tmp4.y * tmp3.y + tmp3.x;
                tmp3.y = _GlossBlue - tmp3.x;
                tmp3.x = tmp4.z * tmp3.y + tmp3.x;
                tmp5 = tex2D(_AmbientOcclusion, inp.texcoord1.xy);
                tmp3.y = tmp5.x * tmp5.x;
                tmp3.y = tmp3.y * tmp3.y;
                tmp3.y = tmp5.x * tmp3.y;
                tmp3.x = tmp3.x * tmp3.y;
                tmp3.z = tmp3.x * 16.0 + -1.0;
                tmp3.x = _Rot * -tmp3.x + tmp3.x;
                tmp3.z = exp(tmp3.z);
                tmp2.w = tmp2.w * tmp3.z;
                tmp2.w = exp(tmp2.w);
                tmp3.z = _GlossPowerRed - _GlossPowerBlack;
                tmp3.z = tmp4.x * tmp3.z + _GlossPowerBlack;
                tmp3.w = _GlossPowerGreen - tmp3.z;
                tmp3.z = tmp4.y * tmp3.w + tmp3.z;
                tmp3.w = _GlossPowerBlue - tmp3.z;
                tmp3.z = tmp4.z * tmp3.w + tmp3.z;
                tmp2.w = tmp2.w * tmp3.z;
                tmp2.w = tmp3.y * tmp2.w;
                tmp3.z = 1.0 - _Rot;
                tmp2.w = tmp2.w * tmp3.z;
                tmp3.z = saturate(tmp5.z + tmp5.z);
                tmp2.w = tmp2.w * tmp3.z;
                tmp3.w = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp2.w = saturate(tmp2.w * tmp3.w);
                tmp3.w = log(tmp1.w);
                tmp3.w = tmp3.w * 3.333;
                tmp3.w = exp(tmp3.w);
                tmp3.w = tmp3.w * tmp3.w;
                tmp3.z = dot(tmp3.xy, tmp3.xy);
                tmp3.z = tmp5.x + tmp3.z;
                tmp2.w = tmp2.w + tmp3.z;
                tmp3.zw = _Rot.xx * float2(-0.5, -0.25) + float2(1.0, 1.0);
                tmp3.z = tmp3.z * 0.667;
                tmp2.w = tmp2.w * tmp3.z;
                tmp2.w = max(tmp2.w, 0.05);
                tmp2.w = min(tmp2.w, 0.95);
                tmp5.xy = tmp2.ww * _RampRed_ST.xy + _RampRed_ST.zw;
                tmp5 = tex2D(_RampRed, tmp5.xy);
                tmp6.xy = tmp2.ww * _RampBlack_ST.xy + _RampBlack_ST.zw;
                tmp6 = tex2D(_RampBlack, tmp6.xy);
                tmp5.xyz = tmp5.xyz - tmp6.xyz;
                tmp5.xyz = tmp4.xxx * tmp5.xyz + tmp6.xyz;
                tmp4.xw = tmp2.ww * _RampGreen_ST.xy + _RampGreen_ST.zw;
                tmp6.xy = tmp2.ww * _RampBlue_ST.xy + _RampBlue_ST.zw;
                tmp6 = tex2D(_RampBlue, tmp6.xy);
                tmp7 = tex2D(_RampGreen, tmp4.xw);
                tmp7.xyz = tmp7.xyz - tmp5.xyz;
                tmp4.xyw = tmp4.yyy * tmp7.xyz + tmp5.xyz;
                tmp5.xyz = tmp6.xyz - tmp4.xyw;
                tmp4.xyz = tmp4.zzz * tmp5.xyz + tmp4.xyw;
                tmp5.xyz = tmp3.www * tmp4.xyz;
                tmp2.w = dot(tmp5.xyz, float3(0.3, 0.59, 0.11));
                tmp6.xyz = -tmp4.xyz * tmp3.www + tmp2.www;
                tmp2.w = _Rot * 0.8;
                tmp5.xyz = tmp2.www * tmp6.xyz + tmp5.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp2.xyz);
                tmp2.x = dot(tmp1.xyz, tmp1.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp1.xyz = tmp1.xyz * tmp2.xxx;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.y = tmp3.x * 10.0 + 1.0;
                tmp0.y = exp(tmp0.y);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp3.xxx * tmp0.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz + tmp2.xyz;
                tmp0.xyz = tmp1.xyz * tmp5.xyz + tmp0.xyz;
                tmp0.w = tmp1.w * tmp1.w;
                tmp0.w = tmp0.w * tmp1.w;
                tmp1.x = dot(tmp4.xyz, float3(0.3, 0.59, 0.11));
                tmp1.xyz = tmp1.xxx - tmp4.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp4.xyz;
                tmp1.xyz = tmp0.www * tmp3.yyy + tmp1.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.8, 0.8, 0.8);
                o.sv_target.xyz = tmp1.xyz * tmp2.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			Cull Off
			GpuProgramID 85432
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
				float4 color : COLOR0;
				float3 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _TimeEditor;
			float _SwayStrength;
			float _VertexColorMask;
			float _Rot;
			float4 _RotDirection;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _RampRed_ST;
			float4 _RampGreen_ST;
			float4 _RampBlue_ST;
			float4 _RampBlack_ST;
			float _GlossRed;
			float _GlossGreen;
			float _GlossBlue;
			float _GlossBlack;
			float _GlossPowerRed;
			float _GlossPowerGreen;
			float _GlossPowerBlue;
			float _GlossPowerBlack;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
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
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.w = tmp0.y + tmp0.x;
                tmp0.w = tmp0.z + tmp0.w;
                tmp0.xyz = tmp0.xyz - unity_ObjectToWorld._m03_m13_m23;
                tmp1.x = _TimeEditor.z + _Time.z;
                tmp0.w = tmp0.w * 0.3333333 + tmp1.x;
                tmp0.w = tmp0.w * 0.5305164;
                tmp0.w = sin(tmp0.w);
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 3.333333;
                tmp1.xyz = unity_WorldToObject._m01_m11_m21 * float3(0.1, 0.1, 0.1) + unity_WorldToObject._m00_m10_m20;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + tmp1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _SwayStrength.xxx;
                tmp0.w = v.color.x - v.texcoord.y;
                tmp0.w = _VertexColorMask * tmp0.w + v.texcoord.y;
                tmp1.xyz = tmp1.xyz * tmp0.www;
                tmp1.xyz = tmp1.xyz * float3(0.1, 0.1, 0.1);
                tmp1.w = _RotDirection.w * -0.15;
                tmp2.xyz = tmp1.www * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = tmp2.xyz * tmp0.www + -tmp1.xyz;
                tmp1.xyz = _Rot.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.w = 1.0 - tmp0.w;
                tmp1.w = _Rot * -0.15;
                tmp2.xyz = tmp1.www * v.normal.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _RotDirection.xyz;
                tmp1.xyz = tmp2.xyz * float3(0.15, 0.15, 0.15) + tmp1.xyz;
                tmp2.x = unity_WorldToObject._m00;
                tmp2.y = unity_WorldToObject._m01;
                tmp2.z = unity_WorldToObject._m02;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp2.x = 1.0 / tmp0.w;
                tmp3.x = unity_WorldToObject._m10;
                tmp3.y = unity_WorldToObject._m11;
                tmp3.z = unity_WorldToObject._m12;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp2.y = 1.0 / tmp0.w;
                tmp3.x = unity_WorldToObject._m20;
                tmp3.y = unity_WorldToObject._m21;
                tmp3.z = unity_WorldToObject._m22;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp2.z = 1.0 / tmp0.w;
                tmp1.xyz = tmp1.xyz / tmp2.xyz;
                tmp2.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp0.xyw = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp2.xyz;
                tmp0.xyz = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
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
                o.texcoord3.xyz = tmp1.www * tmp1.xyz;
                o.color = v.color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord4.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp, float facing: VFACE)
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
                tmp0.x = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord3.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = dot(-tmp2.xyz, tmp0.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp3.xyz = tmp0.xyz * -tmp1.www + -tmp2.xyz;
                tmp1.w = dot(tmp0.xyz, tmp2.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp1.w = log(tmp1.w);
                tmp1.w = tmp1.w * 3.333;
                tmp1.w = exp(tmp1.w);
                tmp1.w = tmp1.w * tmp1.w;
                tmp2.xyz = _WorldSpaceLightPos0.www * -inp.texcoord2.xyz + _WorldSpaceLightPos0.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp2.w = dot(tmp2.xyz, tmp3.xyz);
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = log(tmp2.w);
                tmp3 = tex2D(_AmbientOcclusion, inp.texcoord1.xy);
                tmp3.y = tmp3.x * tmp3.x;
                tmp3.y = tmp3.y * tmp3.y;
                tmp3.y = tmp3.x * tmp3.y;
                tmp3.w = _GlossRed - _GlossBlack;
                tmp4 = tex2D(_Mask, inp.texcoord.xy);
                tmp3.w = tmp4.x * tmp3.w + _GlossBlack;
                tmp4.w = _GlossGreen - tmp3.w;
                tmp3.w = tmp4.y * tmp4.w + tmp3.w;
                tmp4.w = _GlossBlue - tmp3.w;
                tmp3.w = tmp4.z * tmp4.w + tmp3.w;
                tmp3.w = tmp3.w * tmp3.y;
                tmp4.w = tmp3.w * 16.0 + -1.0;
                tmp3.w = _Rot * -tmp3.w + tmp3.w;
                tmp4.w = exp(tmp4.w);
                tmp2.w = tmp2.w * tmp4.w;
                tmp2.w = exp(tmp2.w);
                tmp4.w = _GlossPowerRed - _GlossPowerBlack;
                tmp4.w = tmp4.x * tmp4.w + _GlossPowerBlack;
                tmp5.x = _GlossPowerGreen - tmp4.w;
                tmp4.w = tmp4.y * tmp5.x + tmp4.w;
                tmp5.x = _GlossPowerBlue - tmp4.w;
                tmp4.w = tmp4.z * tmp5.x + tmp4.w;
                tmp2.w = tmp2.w * tmp4.w;
                tmp2.w = tmp3.y * tmp2.w;
                tmp3.y = 1.0 - _Rot;
                tmp2.w = tmp2.w * tmp3.y;
                tmp3.y = saturate(tmp3.z + tmp3.z);
                tmp2.w = tmp2.w * tmp3.y;
                tmp1.w = dot(tmp1.xy, tmp3.xy);
                tmp1.w = tmp3.x + tmp1.w;
                tmp3.x = dot(_LightColor0.xyz, float3(0.3, 0.59, 0.11));
                tmp3.y = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp5 = tex2D(_LightTexture0, tmp3.yy);
                tmp3.x = tmp3.x * tmp5.x;
                tmp2.w = saturate(tmp2.w * tmp3.x);
                tmp1.w = tmp1.w + tmp2.w;
                tmp2.w = tmp5.x * 0.334 + 0.333;
                tmp3.xyz = tmp5.xxx * _LightColor0.xyz;
                tmp5.xy = _Rot.xx * float2(-0.5, -0.25) + float2(1.0, 1.0);
                tmp2.w = tmp2.w * tmp5.x;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = max(tmp1.w, 0.05);
                tmp1.w = min(tmp1.w, 0.95);
                tmp5.xz = tmp1.ww * _RampRed_ST.xy + _RampRed_ST.zw;
                tmp6 = tex2D(_RampRed, tmp5.xz);
                tmp5.xz = tmp1.ww * _RampBlack_ST.xy + _RampBlack_ST.zw;
                tmp7 = tex2D(_RampBlack, tmp5.xz);
                tmp5.xzw = tmp6.xyz - tmp7.xyz;
                tmp5.xzw = tmp4.xxx * tmp5.xzw + tmp7.xyz;
                tmp4.xw = tmp1.ww * _RampGreen_ST.xy + _RampGreen_ST.zw;
                tmp6.xy = tmp1.ww * _RampBlue_ST.xy + _RampBlue_ST.zw;
                tmp6 = tex2D(_RampBlue, tmp6.xy);
                tmp7 = tex2D(_RampGreen, tmp4.xw);
                tmp7.xyz = tmp7.xyz - tmp5.xzw;
                tmp4.xyw = tmp4.yyy * tmp7.xyz + tmp5.xzw;
                tmp5.xzw = tmp6.xyz - tmp4.xyw;
                tmp4.xyz = tmp4.zzz * tmp5.xzw + tmp4.xyw;
                tmp5.xzw = tmp5.yyy * tmp4.xyz;
                tmp1.w = dot(tmp5.xyz, float3(0.3, 0.59, 0.11));
                tmp4.xyz = -tmp4.xyz * tmp5.yyy + tmp1.www;
                tmp1.w = _Rot * 0.8;
                tmp4.xyz = tmp1.www * tmp4.xyz + tmp5.xzw;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp2.xyz);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.y = tmp3.w * 10.0 + 1.0;
                tmp0.y = exp(tmp0.y);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = exp(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.xyz = tmp3.www * tmp0.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                tmp1.xyz = tmp3.xyz * tmp1.xyz;
                o.sv_target.xyz = tmp1.xyz * tmp4.xyz + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 141671
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float3 texcoord3 : TEXCOORD3;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			float _SwayStrength;
			float _VertexColorMask;
			float _Rot;
			float4 _RotDirection;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.w = tmp0.y + tmp0.x;
                tmp0.w = tmp0.z + tmp0.w;
                tmp0.xyz = tmp0.xyz - unity_ObjectToWorld._m03_m13_m23;
                tmp1.x = _TimeEditor.z + _Time.z;
                tmp0.w = tmp0.w * 0.3333333 + tmp1.x;
                tmp0.w = tmp0.w * 0.5305164;
                tmp0.w = sin(tmp0.w);
                tmp0.w = sin(tmp0.w);
                tmp0.w = tmp0.w * 3.333333;
                tmp1.xyz = unity_WorldToObject._m01_m11_m21 * float3(0.1, 0.1, 0.1) + unity_WorldToObject._m00_m10_m20;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + tmp1.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp1.xyz = tmp1.xyz * _SwayStrength.xxx;
                tmp0.w = v.color.x - v.texcoord.y;
                tmp0.w = _VertexColorMask * tmp0.w + v.texcoord.y;
                tmp1.xyz = tmp1.xyz * tmp0.www;
                tmp1.xyz = tmp1.xyz * float3(0.1, 0.1, 0.1);
                tmp1.w = _RotDirection.w * -0.15;
                tmp2.xyz = tmp1.www * unity_WorldToObject._m01_m11_m21;
                tmp2.xyz = tmp2.xyz * tmp0.www + -tmp1.xyz;
                tmp1.xyz = _Rot.xxx * tmp2.xyz + tmp1.xyz;
                tmp0.w = 1.0 - tmp0.w;
                tmp1.w = _Rot * -0.15;
                tmp2.xyz = tmp1.www * v.normal.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * _RotDirection.xyz;
                tmp1.xyz = tmp2.xyz * float3(0.15, 0.15, 0.15) + tmp1.xyz;
                tmp2.x = unity_WorldToObject._m00;
                tmp2.y = unity_WorldToObject._m01;
                tmp2.z = unity_WorldToObject._m02;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp2.x = 1.0 / tmp0.w;
                tmp3.x = unity_WorldToObject._m10;
                tmp3.y = unity_WorldToObject._m11;
                tmp3.z = unity_WorldToObject._m12;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp2.y = 1.0 / tmp0.w;
                tmp3.x = unity_WorldToObject._m20;
                tmp3.y = unity_WorldToObject._m21;
                tmp3.z = unity_WorldToObject._m22;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp2.z = 1.0 / tmp0.w;
                tmp1.xyz = tmp1.xyz / tmp2.xyz;
                tmp2.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp0.xyw = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp2.xyz;
                tmp0.xyz = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
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
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
                o.color = v.color;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}