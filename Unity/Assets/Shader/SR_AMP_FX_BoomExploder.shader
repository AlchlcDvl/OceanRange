Shader "SR/AMP/FX/BoomExploder" {
	Properties {
		[NoScaleOffset] _GradientMap ("Gradient Map", 2D) = "white" {}
		_Cutoff ("Mask Clip Value", Float) = 0.5
		_ExplosionMasks ("Explosion Masks", 2D) = "black" {}
		_Alpha ("Alpha", Range(0, 1)) = 1
		_Color0 ("Color 0", Color) = (1,0.1862069,0,0)
		_ScaleMultiplier ("Scale Multiplier", Float) = 3
		[Toggle] _FadeDirection ("Fade Direction", Float) = 0
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "AlphaTest+0" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest+0" "RenderType" = "TransparentCutout" }
			AlphaToMask On
			Cull Off
			GpuProgramID 64472
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _ExplosionMasks_ST;
			float _Alpha;
			float _ScaleMultiplier;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Color0;
			float _FadeDirection;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _ExplosionMasks;
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _GradientMap;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = abs(tmp0.xyz) * abs(tmp0.xyz);
                tmp2.xyz = tmp1.xyz * tmp1.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp1.xy = tmp1.xy * tmp2.xy;
                tmp0.w = tmp1.y + tmp1.x;
                tmp0.w = tmp1.z * tmp2.z + tmp0.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 0.15 + -0.4;
                tmp1.xyz = tmp0.xyz * tmp0.www;
                tmp2.xy = v.texcoord.xy * _ExplosionMasks_ST.xy + _ExplosionMasks_ST.zw;
                tmp3.x = tmp2.x;
                tmp3.y = _Time.y * 0.025 + tmp2.y;
                tmp3 = tex2Dlod(_ExplosionMasks, float4(tmp3.xy, 0, 0.0));
                tmp0.w = v.color.w * _Alpha;
                tmp1.w = saturate(tmp0.w);
                tmp1.w = tmp1.w * 0.25 + 0.25;
                tmp3.xzw = _Alpha.xxx * v.color.www + float3(-0.1, -0.3, -0.3);
                tmp3.xzw = saturate(tmp3.xzw * float3(5.0, 1.428571, 3.333333));
                tmp2.w = tmp3.x * 0.2 + -0.5;
                tmp1.w = tmp1.w - tmp2.w;
                tmp1.w = tmp3.y * tmp1.w + tmp2.w;
                tmp2.w = saturate(tmp0.w + tmp0.w);
                tmp0.w = saturate(tmp0.w * 10.0);
                tmp1.w = tmp2.w * 0.2 + tmp1.w;
                tmp1.w = tmp1.w - 0.1;
                tmp4.xyz = tmp1.www * tmp0.xyz + -tmp1.xyz;
                tmp1.xyz = tmp0.www * tmp4.xyz + tmp1.xyz;
                tmp2.z = tmp3.z * 0.25 + tmp2.y;
                tmp2 = tex2Dlod(_ExplosionMasks, float4(tmp2.xz, 0, 0.0));
                tmp2.xyz = tmp0.xyz * tmp2.xxx;
                o.texcoord1.xyz = tmp0.xyz;
                tmp0.x = 1.0 - tmp3.z;
                tmp0.y = 1.0 - tmp0.x;
                tmp3.y = tmp0.x * -0.5 + 0.5;
                tmp0.xyz = tmp0.yyy * tmp2.xyz;
                tmp3.xz = float2(0.0, 0.0);
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5) + tmp3.xyz;
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp0.xyz = tmp3.www * tmp0.xyz + tmp1.xyz;
                tmp1.x = unity_ObjectToWorld._m00;
                tmp1.y = unity_ObjectToWorld._m01;
                tmp1.z = unity_ObjectToWorld._m02;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp0.w);
                tmp2.x = unity_ObjectToWorld._m10;
                tmp2.y = unity_ObjectToWorld._m11;
                tmp2.z = unity_ObjectToWorld._m12;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.y = sqrt(tmp0.w);
                tmp2.x = unity_ObjectToWorld._m20;
                tmp2.y = unity_ObjectToWorld._m21;
                tmp2.z = unity_ObjectToWorld._m22;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.z = sqrt(tmp0.w);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _ScaleMultiplier.xxx;
                tmp1.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp0.xyw = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp0 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp0;
                tmp0 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp0;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.color = v.color;
                tmp1.x = tmp0.y * _ProjectionParams.x;
                tmp1.w = tmp1.x * 0.5;
                tmp1.xz = tmp0.xw * float2(0.5, 0.5);
                tmp0.xy = tmp1.zz + tmp1.xw;
                o.texcoord3 = tmp0;
                o.texcoord4 = tmp0;
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
                tmp0.x = unity_ObjectToWorld._m00;
                tmp0.y = unity_ObjectToWorld._m01;
                tmp0.z = unity_ObjectToWorld._m02;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = unity_ObjectToWorld._m10;
                tmp1.y = unity_ObjectToWorld._m11;
                tmp1.z = unity_ObjectToWorld._m12;
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.xy = sqrt(tmp0.xy);
                tmp0.x = tmp0.y + tmp0.x;
                tmp1.x = unity_ObjectToWorld._m20;
                tmp1.y = unity_ObjectToWorld._m21;
                tmp1.z = unity_ObjectToWorld._m22;
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp0.y = sqrt(tmp0.y);
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.xy = tmp0.xx * float2(0.333, 1.665);
                tmp1.xyz = inp.texcoord4.zxy / inp.texcoord4.www;
                tmp2 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.w = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.z = tmp0.w - tmp0.z;
                tmp0.x = tmp0.z / tmp0.x;
                tmp0.x = min(abs(tmp0.x), 1.0);
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.z = dot(inp.texcoord1.xyz, tmp1.xyz);
                tmp0.zw = float2(1.0, 1.25) - tmp0.zz;
                tmp1.x = log(tmp0.z);
                tmp1.x = tmp1.x * 0.6;
                tmp1.x = exp(tmp1.x);
                tmp1.x = tmp1.x - 0.43;
                tmp1.y = 1.0 - tmp0.z;
                tmp1.x = facing.x ? tmp1.y : tmp1.x;
                tmp1.x = tmp1.x * 0.2 + 0.4;
                tmp1.y = 1.0 - tmp1.x;
                tmp1.z = inp.texcoord1.y * -2.0 + 1.0;
                tmp1.z = _FadeDirection * tmp1.z + inp.texcoord1.y;
                tmp1.z = tmp1.z + 1.0;
                tmp1.zw = tmp1.zz * float2(0.1, 0.1) + float2(0.4, -0.1);
                tmp1.w = -tmp1.w * 2.0 + 1.0;
                tmp1.y = -tmp1.w * tmp1.y + 1.0;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.z = tmp1.z > 0.5;
                tmp1.x = saturate(tmp1.z ? tmp1.y : tmp1.x);
                tmp1.y = tmp1.x > 0.5;
                tmp1.z = tmp1.x - 0.5;
                tmp1.z = -tmp1.z * 2.0 + 1.0;
                tmp2 = _Alpha.xxxx * inp.color.wwww + float4(-0.3, 0.5, -0.75, -0.3);
                tmp1.w = saturate(tmp2.z * 4.0);
                tmp2 = tmp2.xzwy * float4(1.428571, 5.0, 3.333333, -6.0);
                tmp3.xy = float2(1.0, 0.5) - tmp1.ww;
                tmp1.w = tmp3.x > 0.5;
                tmp3.y = -tmp3.y * 2.0 + 1.0;
                tmp2.xyz = saturate(tmp2.xyz);
                tmp4.x = sin(tmp2.w);
                tmp5.x = cos(tmp2.w);
                tmp4.yz = inp.texcoord.xy * _ExplosionMasks_ST.xy + _ExplosionMasks_ST.zw;
                tmp4.w = tmp2.x * 0.25 + tmp4.z;
                tmp6 = tex2D(_ExplosionMasks, tmp4.yw);
                tmp2.w = 1.0 - tmp6.x;
                tmp2.w = -tmp3.y * tmp2.w + 1.0;
                tmp3.x = dot(tmp6.xy, tmp3.xy);
                tmp1.w = saturate(tmp1.w ? tmp2.w : tmp3.x);
                tmp2.w = 1.0 - tmp1.w;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.z = -tmp1.z * tmp2.w + 1.0;
                tmp1.x = saturate(tmp1.y ? tmp1.z : tmp1.x);
                tmp1.x = tmp1.x * 0.95 + 0.05;
                tmp0.x = tmp1.x * tmp0.x + -_Cutoff;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp1.xy = inp.texcoord1.yy * unity_MatrixV._m01_m11;
                tmp1.xy = unity_MatrixV._m00_m10 * inp.texcoord1.xx + tmp1.xy;
                tmp1.xy = unity_MatrixV._m02_m12 * inp.texcoord1.zz + tmp1.xy;
                tmp1.xy = tmp1.xy * float2(0.5, 0.5);
                tmp3.z = tmp4.x;
                tmp3.y = tmp5.x;
                tmp3.x = -tmp4.x;
                tmp5.y = dot(tmp1.xy, tmp3.xy);
                tmp5.x = dot(tmp1.xy, tmp3.xy);
                tmp1.xy = tmp5.xy + float2(0.5, 0.5);
                tmp1 = tex2D(_ExplosionMasks, tmp1.xy);
                tmp0.x = 1.0 - tmp1.z;
                tmp0.x = tmp2.y * tmp0.x + tmp1.z;
                tmp1.x = 1.0 - tmp2.x;
                tmp1.y = 1.0 - tmp1.x;
                tmp1.x = dot(tmp1.xy, tmp6.xy);
                tmp1.z = tmp6.x - 0.5;
                tmp1.w = tmp6.x > 0.5;
                tmp1.z = -tmp1.z * 2.0 + 1.0;
                tmp1.y = -tmp1.z * tmp1.y + 1.0;
                tmp1.x = saturate(tmp1.w ? tmp1.y : tmp1.x);
                tmp1.y = 1.0 - tmp1.x;
                tmp1.z = inp.texcoord1.y + 1.0;
                tmp1.w = tmp1.z * 0.5;
                tmp1.z = tmp1.z * -0.125 + 0.5;
                tmp1.z = facing.x ? tmp1.w : tmp1.z;
                tmp1.w = tmp1.z - 0.5;
                tmp1.w = -tmp1.w * 2.0 + 1.0;
                tmp1.y = -tmp1.w * tmp1.y + 1.0;
                tmp1.x = dot(tmp1.xy, tmp1.xy);
                tmp1.z = tmp1.z > 0.5;
                tmp1.x = saturate(tmp1.z ? tmp1.y : tmp1.x);
                tmp0.x = saturate(tmp0.x * tmp1.x);
                tmp4.z = _Time.y * 0.025 + tmp4.z;
                tmp1 = tex2D(_ExplosionMasks, tmp4.yz);
                tmp0.w = saturate(tmp0.w * tmp1.y);
                tmp0.z = tmp0.z * tmp0.z;
                tmp1.xyz = abs(inp.texcoord1.xyz) * abs(inp.texcoord1.xyz);
                tmp2.xyw = tmp1.xyz * tmp1.xyz;
                tmp2.xyw = tmp2.xyw * tmp2.xyw;
                tmp2.xyw = tmp2.xyw * tmp2.xyw;
                tmp1.xyz = tmp1.xyz * tmp2.xyw;
                tmp2.xyw = tmp2.xyw * tmp2.xyw;
                tmp1.xy = tmp1.xy * tmp2.xy;
                tmp1.x = tmp1.y + tmp1.x;
                tmp1.x = tmp1.z * tmp2.w + tmp1.x;
                tmp1.x = min(tmp1.x, 1.0);
                tmp0.z = tmp0.z * tmp1.x;
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.w = tmp0.w - tmp0.z;
                tmp1.x = inp.color.w * _Alpha;
                tmp1.z = saturate(tmp1.x * 10.0);
                tmp0.z = tmp1.z * tmp0.w + tmp0.z;
                tmp0.x = tmp0.x - tmp0.z;
                tmp0.x = tmp2.z * tmp0.x + tmp0.z;
                tmp2.xyz = inp.texcoord3.zxy / inp.texcoord3.www;
                tmp3 = tex2D(_CameraDepthTexture, tmp2.yz);
                tmp0.z = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.w = _ZBufferParams.z * tmp3.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.z = tmp0.w - tmp0.z;
                tmp0.y = tmp0.z / tmp0.y;
                tmp0.y = min(abs(tmp0.y), 1.0);
                tmp1.y = tmp0.x * tmp0.y;
                tmp0 = tex2D(_GradientMap, tmp1.xy);
                tmp1.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = glstate_lightmodel_ambient.xyz * float3(1.6, 1.6, 1.6) + float3(0.1, 0.1, 0.1);
                tmp3.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp4.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp4.xyz = -tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp4.xyz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp3.xyz);
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp0.xyz = tmp0.www * tmp0.xyz + tmp1.xyz;
                o.sv_target.xyz = tmp0.www * _Color0.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest+0" "RenderType" = "TransparentCutout" }
			Blend One One, One One
			AlphaToMask On
			ZWrite Off
			Cull Off
			GpuProgramID 94895
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float3 texcoord2 : TEXCOORD2;
				float4 color : COLOR0;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float4 _ExplosionMasks_ST;
			float _Alpha;
			float _ScaleMultiplier;
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _FadeDirection;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _ExplosionMasks;
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = abs(tmp0.xyz) * abs(tmp0.xyz);
                tmp2.xyz = tmp1.xyz * tmp1.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp1.xyz = tmp1.xyz * tmp2.xyz;
                tmp2.xyz = tmp2.xyz * tmp2.xyz;
                tmp1.xy = tmp1.xy * tmp2.xy;
                tmp0.w = tmp1.y + tmp1.x;
                tmp0.w = tmp1.z * tmp2.z + tmp0.w;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.w = tmp0.w * 0.15 + -0.4;
                tmp1.xyz = tmp0.xyz * tmp0.www;
                tmp2.xy = v.texcoord.xy * _ExplosionMasks_ST.xy + _ExplosionMasks_ST.zw;
                tmp3.x = tmp2.x;
                tmp3.y = _Time.y * 0.025 + tmp2.y;
                tmp3 = tex2Dlod(_ExplosionMasks, float4(tmp3.xy, 0, 0.0));
                tmp0.w = v.color.w * _Alpha;
                tmp1.w = saturate(tmp0.w);
                tmp1.w = tmp1.w * 0.25 + 0.25;
                tmp3.xzw = _Alpha.xxx * v.color.www + float3(-0.1, -0.3, -0.3);
                tmp3.xzw = saturate(tmp3.xzw * float3(5.0, 1.428571, 3.333333));
                tmp2.w = tmp3.x * 0.2 + -0.5;
                tmp1.w = tmp1.w - tmp2.w;
                tmp1.w = tmp3.y * tmp1.w + tmp2.w;
                tmp2.w = saturate(tmp0.w + tmp0.w);
                tmp0.w = saturate(tmp0.w * 10.0);
                tmp1.w = tmp2.w * 0.2 + tmp1.w;
                tmp1.w = tmp1.w - 0.1;
                tmp4.xyz = tmp1.www * tmp0.xyz + -tmp1.xyz;
                tmp1.xyz = tmp0.www * tmp4.xyz + tmp1.xyz;
                tmp2.z = tmp3.z * 0.25 + tmp2.y;
                tmp2 = tex2Dlod(_ExplosionMasks, float4(tmp2.xz, 0, 0.0));
                tmp2.xyz = tmp0.xyz * tmp2.xxx;
                o.texcoord1.xyz = tmp0.xyz;
                tmp0.x = 1.0 - tmp3.z;
                tmp0.y = 1.0 - tmp0.x;
                tmp3.y = tmp0.x * -0.5 + 0.5;
                tmp0.xyz = tmp0.yyy * tmp2.xyz;
                tmp3.xz = float2(0.0, 0.0);
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5) + tmp3.xyz;
                tmp0.xyz = tmp0.xyz - tmp1.xyz;
                tmp0.xyz = tmp3.www * tmp0.xyz + tmp1.xyz;
                tmp1.x = unity_ObjectToWorld._m00;
                tmp1.y = unity_ObjectToWorld._m01;
                tmp1.z = unity_ObjectToWorld._m02;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp0.w);
                tmp2.x = unity_ObjectToWorld._m10;
                tmp2.y = unity_ObjectToWorld._m11;
                tmp2.z = unity_ObjectToWorld._m12;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.y = sqrt(tmp0.w);
                tmp2.x = unity_ObjectToWorld._m20;
                tmp2.y = unity_ObjectToWorld._m21;
                tmp2.z = unity_ObjectToWorld._m22;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.z = sqrt(tmp0.w);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz * _ScaleMultiplier.xxx;
                tmp1.xyz = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp0.xyw = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp0.xyw;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                o.color = v.color;
                tmp2.x = tmp1.y * _ProjectionParams.x;
                tmp2.w = tmp2.x * 0.5;
                tmp2.xz = tmp1.xw * float2(0.5, 0.5);
                tmp1.xy = tmp2.zz + tmp2.xw;
                o.texcoord3 = tmp1;
                o.texcoord4 = tmp1;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord5.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
                return o;
			}
			// Keywords: POINT
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(inp.texcoord1.xyz, tmp0.xyz);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = log(tmp0.x);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.y = tmp0.y * 0.6;
                tmp0.y = exp(tmp0.y);
                tmp0.y = tmp0.y - 0.43;
                tmp0.x = facing.x ? tmp0.x : tmp0.y;
                tmp0.x = tmp0.x * 0.2 + 0.4;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.z = inp.texcoord1.y * -2.0 + 1.0;
                tmp0.z = _FadeDirection * tmp0.z + inp.texcoord1.y;
                tmp0.z = tmp0.z + 1.0;
                tmp0.zw = tmp0.zz * float2(0.1, 0.1) + float2(0.4, -0.1);
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.z > 0.5;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.y = tmp0.x - 0.5;
                tmp0.y = -tmp0.y * 2.0 + 1.0;
                tmp0.zw = _Alpha.xx * inp.color.ww + float2(-0.3, -0.75);
                tmp0.zw = saturate(tmp0.zw * float2(1.428571, 4.0));
                tmp1.xy = inp.texcoord.xy * _ExplosionMasks_ST.xy + _ExplosionMasks_ST.zw;
                tmp1.z = tmp0.z * 0.25 + tmp1.y;
                tmp0.zw = float2(1.0, 0.5) - tmp0.ww;
                tmp1 = tex2D(_ExplosionMasks, tmp1.xz);
                tmp1.y = 1.0 - tmp1.x;
                tmp1.x = dot(tmp1.xy, tmp0.xy);
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.z = tmp0.z > 0.5;
                tmp0.w = -tmp0.w * tmp1.y + 1.0;
                tmp0.z = saturate(tmp0.z ? tmp0.w : tmp1.x);
                tmp0.w = 1.0 - tmp0.z;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.x = tmp0.x > 0.5;
                tmp0.y = -tmp0.y * tmp0.w + 1.0;
                tmp0.x = saturate(tmp0.x ? tmp0.y : tmp0.z);
                tmp0.x = tmp0.x * 0.95 + 0.05;
                tmp1.x = unity_ObjectToWorld._m00;
                tmp1.y = unity_ObjectToWorld._m01;
                tmp1.z = unity_ObjectToWorld._m02;
                tmp0.y = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = unity_ObjectToWorld._m10;
                tmp1.y = unity_ObjectToWorld._m11;
                tmp1.z = unity_ObjectToWorld._m12;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.yz = sqrt(tmp0.yz);
                tmp0.y = tmp0.z + tmp0.y;
                tmp1.x = unity_ObjectToWorld._m20;
                tmp1.y = unity_ObjectToWorld._m21;
                tmp1.z = unity_ObjectToWorld._m22;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.y = tmp0.y * 0.333;
                tmp1.xyz = inp.texcoord4.zxy / inp.texcoord4.www;
                tmp2 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp0.z = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.w = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.z = tmp0.w - tmp0.z;
                tmp0.y = tmp0.z / tmp0.y;
                tmp0.y = min(abs(tmp0.y), 1.0);
                tmp0.y = tmp0.y * 0.5 + 0.5;
                tmp0.x = tmp0.x * tmp0.y + -_Cutoff;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                o.sv_target = float4(0.0, 0.0, 0.0, 1.0);
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}