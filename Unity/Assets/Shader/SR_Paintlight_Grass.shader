Shader "SR/Paintlight/Grass" {
	Properties {
		_AlphaClip ("Alpha Clip", 2D) = "white" {}
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		[MaterialToggle] _EnableDetailTex ("Enable Detail Tex", Float) = 0
		_DetailTex ("Detail Tex", 2D) = "white" {}
		_DetailNoiseMask ("Detail Noise Mask", 2D) = "white" {}
		_SwayStrength ("Sway Strength", Range(0, 2)) = 1
		[MaterialToggle] _VertexColorMask ("Vertex Color Mask", Float) = 0
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "QUEUE" = "Geometry+50" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry+50" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			Cull Off
			GpuProgramID 48719
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _AlphaClip_ST;
			float4 _PrimaryTex_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AlphaClip;
			sampler2D _PrimaryTex;
			sampler2D _DetailTex;
			sampler2D _DetailNoiseMask;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _TimeEditor.z + _Time.z;
                tmp0.x = tmp0.x * 0.3183099;
                tmp0.x = sin(tmp0.x);
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 3.333333;
                tmp0.yzw = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + unity_WorldToObject._m00_m10_m20;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp0.xyz * _SwayStrength.xxx;
                tmp0.xyz = tmp0.xyz * float3(0.03, 0.03, 0.03);
                tmp0.w = v.color.x - v.texcoord.y;
                tmp0.w = _VertexColorMask * tmp0.w + v.texcoord.y;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_WorldToObject._m00;
                tmp1.y = unity_WorldToObject._m01;
                tmp1.z = unity_WorldToObject._m02;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp1.x = 1.0 / tmp0.w;
                tmp2.x = unity_WorldToObject._m10;
                tmp2.y = unity_WorldToObject._m11;
                tmp2.z = unity_WorldToObject._m12;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp1.y = 1.0 / tmp0.w;
                tmp2.x = unity_WorldToObject._m20;
                tmp2.y = unity_WorldToObject._m21;
                tmp2.z = unity_WorldToObject._m22;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp1.z = 1.0 / tmp0.w;
                tmp0.xyz = tmp0.xyz / tmp1.xyz;
                tmp1.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = tmp1.xyz - unity_ObjectToWorld._m03_m13_m23;
                tmp2.xyz = tmp1.yyy * unity_WorldToObject._m01_m11_m21;
                tmp1.xyw = unity_WorldToObject._m00_m10_m20 * tmp1.xxx + tmp2.xyz;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * tmp1.zzz + tmp1.xyw;
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
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
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.xy = inp.texcoord.xy * _AlphaClip_ST.xy + _AlphaClip_ST.zw;
                tmp0 = tex2D(_AlphaClip, tmp0.xy);
                tmp0.x = tmp0.w - 0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(-tmp1.xyz, tmp2.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp1.xyz = tmp2.xyz * -tmp0.www + -tmp1.xyz;
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = tmp0.x - 1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.y = saturate(tmp2.y);
                tmp0.z = dot(abs(tmp2.xy), float2(0.333, 0.333));
                tmp1.xyz = abs(tmp2.xyz) * abs(tmp2.xyz);
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.yzw = tmp0.yyy * tmp0.yyy + glstate_lightmodel_ambient.xyz;
                tmp0.yzw = tmp0.yzw * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp0.yzw = tmp0.yzw * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp0.yzw = max(tmp0.yzw, float3(0.75, 0.75, 0.75));
                tmp0 = min(tmp0, float4(0.3, 1.0, 1.0, 1.0));
                tmp0.xyz = tmp0.xxx + tmp0.yzw;
                tmp0.xyz = tmp0.xyz * _LightColor0.xyz;
                tmp2.xyz = tmp0.xyz * inp.color.xyz + float3(-0.5, -0.5, -0.5);
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xy = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp4.x = dot(tmp3.xy, float2(0.0000003, -1.0));
                tmp4.y = dot(tmp3.xy, float2(1.0, 0.0000003));
                tmp3.zw = tmp4.xy + float2(0.5, 0.5);
                tmp3.zw = tmp3.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp4 = tex2D(_DetailTex, tmp3.zw);
                tmp5 = inp.texcoord1.zxxy * _DetailTex_ST + _DetailTex_ST;
                tmp6 = tex2D(_DetailTex, tmp5.xy);
                tmp5 = tex2D(_DetailTex, tmp5.zw);
                tmp6.xyz = tmp1.yyy * tmp6.xyz;
                tmp4.xyz = tmp1.xxx * tmp4.xyz + tmp6.xyz;
                tmp4.xyz = tmp1.zzz * tmp5.xyz + tmp4.xyz;
                tmp5.x = dot(tmp3.xy, float2(0.0000003, -1.0));
                tmp5.y = dot(tmp3.xy, float2(1.0, 0.0000003));
                tmp3.zw = tmp5.xy + float2(0.5, 0.5);
                tmp3.zw = tmp3.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp5 = tex2D(_PrimaryTex, tmp3.zw);
                tmp6 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp7 = tex2D(_PrimaryTex, tmp6.xy);
                tmp6 = tex2D(_PrimaryTex, tmp6.zw);
                tmp7.xyz = tmp1.yyy * tmp7.xyz;
                tmp5.xyz = tmp1.xxx * tmp5.xyz + tmp7.xyz;
                tmp5.xyz = tmp1.zzz * tmp6.xyz + tmp5.xyz;
                tmp4.xyz = tmp4.xyz - tmp5.xyz;
                tmp6.x = dot(tmp3.xy, float2(0.0000003, -1.0));
                tmp6.y = dot(tmp3.xy, float2(1.0, 0.0000003));
                tmp3.xy = tmp6.xy + float2(0.5, 0.5);
                tmp3.xy = tmp3.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp6 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp7 = tex2D(_DetailNoiseMask, tmp6.xy);
                tmp6 = tex2D(_DetailNoiseMask, tmp6.zw);
                tmp0.w = tmp1.y * tmp7.x;
                tmp0.w = tmp1.x * tmp3.x + tmp0.w;
                tmp0.w = tmp1.z * tmp6.x + tmp0.w;
                tmp0.w = saturate(tmp0.w * 3.0 + -1.5);
                tmp1.xyz = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x * 0.01;
                tmp1.y = tmp1.x * tmp1.x;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.x = min(tmp1.x, 1.0);
                tmp0.w = tmp1.x * -tmp0.w + tmp0.w;
                tmp1.xyz = tmp4.xyz * tmp0.www;
                tmp1.xyz = _EnableDetailTex.xxx * tmp1.xyz + tmp5.xyz;
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp2.xyz = -tmp2.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp1.xyz * tmp3.xyz;
                tmp0.xyz = saturate(tmp0.xyz ? tmp2.xyz : tmp3.xyz);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = saturate(tmp1.xyz * tmp2.xyz);
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "Geometry+50" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			Cull Off
			GpuProgramID 118857
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
				float4 color : COLOR0;
				float3 texcoord3 : TEXCOORD3;
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _AlphaClip_ST;
			float4 _PrimaryTex_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AlphaClip;
			sampler2D _LightTexture0;
			sampler2D _PrimaryTex;
			sampler2D _DetailTex;
			sampler2D _DetailNoiseMask;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _TimeEditor.z + _Time.z;
                tmp0.x = tmp0.x * 0.3183099;
                tmp0.x = sin(tmp0.x);
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 3.333333;
                tmp0.yzw = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + unity_WorldToObject._m00_m10_m20;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp0.xyz * _SwayStrength.xxx;
                tmp0.xyz = tmp0.xyz * float3(0.03, 0.03, 0.03);
                tmp0.w = v.color.x - v.texcoord.y;
                tmp0.w = _VertexColorMask * tmp0.w + v.texcoord.y;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_WorldToObject._m00;
                tmp1.y = unity_WorldToObject._m01;
                tmp1.z = unity_WorldToObject._m02;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp1.x = 1.0 / tmp0.w;
                tmp2.x = unity_WorldToObject._m10;
                tmp2.y = unity_WorldToObject._m11;
                tmp2.z = unity_WorldToObject._m12;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp1.y = 1.0 / tmp0.w;
                tmp2.x = unity_WorldToObject._m20;
                tmp2.y = unity_WorldToObject._m21;
                tmp2.z = unity_WorldToObject._m22;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp1.z = 1.0 / tmp0.w;
                tmp0.xyz = tmp0.xyz / tmp1.xyz;
                tmp1.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = tmp1.xyz - unity_ObjectToWorld._m03_m13_m23;
                tmp2.xyz = tmp1.yyy * unity_WorldToObject._m01_m11_m21;
                tmp1.xyw = unity_WorldToObject._m00_m10_m20 * tmp1.xxx + tmp2.xyz;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * tmp1.zzz + tmp1.xyw;
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
                o.texcoord1 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                o.color = v.color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord3.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                tmp0.xy = inp.texcoord.xy * _AlphaClip_ST.xy + _AlphaClip_ST.zw;
                tmp0 = tex2D(_AlphaClip, tmp0.xy);
                tmp0.x = tmp0.w - 0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * inp.texcoord2.xyz;
                tmp0.w = facing.x ? 1.0 : -1.0;
                tmp2.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = dot(-tmp1.xyz, tmp2.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp1.xyz = tmp2.xyz * -tmp0.www + -tmp1.xyz;
                tmp0.x = dot(tmp0.xyz, tmp1.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = tmp0.x - 1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.y = saturate(tmp2.y);
                tmp0.z = dot(abs(tmp2.xy), float2(0.333, 0.333));
                tmp1.xyz = abs(tmp2.xyz) * abs(tmp2.xyz);
                tmp0.y = tmp0.y + tmp0.z;
                tmp0.yzw = tmp0.yyy * tmp0.yyy + glstate_lightmodel_ambient.xyz;
                tmp0.yzw = tmp0.yzw * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp0.yzw = tmp0.yzw * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp0.yzw = max(tmp0.yzw, float3(0.75, 0.75, 0.75));
                tmp0 = min(tmp0, float4(0.3, 1.0, 1.0, 1.0));
                tmp0.xyz = tmp0.xxx + tmp0.yzw;
                tmp0.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp2 = tex2D(_LightTexture0, tmp0.ww);
                tmp2.xyz = tmp2.xxx * _LightColor0.xyz;
                tmp0.xyz = tmp0.xyz * tmp2.xyz;
                tmp2.xyz = tmp0.xyz * inp.color.xyz + float3(-0.5, -0.5, -0.5);
                tmp0.xyz = tmp0.xyz * inp.color.xyz;
                tmp2.xyz = -tmp2.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xy = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp4.x = dot(tmp3.xy, float2(0.0000003, -1.0));
                tmp4.y = dot(tmp3.xy, float2(1.0, 0.0000003));
                tmp3.zw = tmp4.xy + float2(0.5, 0.5);
                tmp3.zw = tmp3.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp4 = tex2D(_DetailTex, tmp3.zw);
                tmp5 = inp.texcoord1.zxxy * _DetailTex_ST + _DetailTex_ST;
                tmp6 = tex2D(_DetailTex, tmp5.xy);
                tmp5 = tex2D(_DetailTex, tmp5.zw);
                tmp6.xyz = tmp1.yyy * tmp6.xyz;
                tmp4.xyz = tmp1.xxx * tmp4.xyz + tmp6.xyz;
                tmp4.xyz = tmp1.zzz * tmp5.xyz + tmp4.xyz;
                tmp5.x = dot(tmp3.xy, float2(0.0000003, -1.0));
                tmp5.y = dot(tmp3.xy, float2(1.0, 0.0000003));
                tmp3.zw = tmp5.xy + float2(0.5, 0.5);
                tmp3.zw = tmp3.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp5 = tex2D(_PrimaryTex, tmp3.zw);
                tmp6 = inp.texcoord1.zxxy * _PrimaryTex_ST + _PrimaryTex_ST;
                tmp7 = tex2D(_PrimaryTex, tmp6.xy);
                tmp6 = tex2D(_PrimaryTex, tmp6.zw);
                tmp7.xyz = tmp1.yyy * tmp7.xyz;
                tmp5.xyz = tmp1.xxx * tmp5.xyz + tmp7.xyz;
                tmp5.xyz = tmp1.zzz * tmp6.xyz + tmp5.xyz;
                tmp4.xyz = tmp4.xyz - tmp5.xyz;
                tmp6.x = dot(tmp3.xy, float2(0.0000003, -1.0));
                tmp6.y = dot(tmp3.xy, float2(1.0, 0.0000003));
                tmp3.xy = tmp6.xy + float2(0.5, 0.5);
                tmp3.xy = tmp3.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp6 = inp.texcoord1.zxxy * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp7 = tex2D(_DetailNoiseMask, tmp6.xy);
                tmp6 = tex2D(_DetailNoiseMask, tmp6.zw);
                tmp0.w = tmp1.y * tmp7.x;
                tmp0.w = tmp1.x * tmp3.x + tmp0.w;
                tmp0.w = tmp1.z * tmp6.x + tmp0.w;
                tmp0.w = saturate(tmp0.w * 3.0 + -1.5);
                tmp1.xyz = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp1.x = dot(tmp1.xyz, tmp1.xyz);
                tmp1.x = sqrt(tmp1.x);
                tmp1.x = tmp1.x * 0.01;
                tmp1.y = tmp1.x * tmp1.x;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.x = min(tmp1.x, 1.0);
                tmp0.w = tmp1.x * -tmp0.w + tmp0.w;
                tmp1.xyz = tmp4.xyz * tmp0.www;
                tmp1.xyz = _EnableDetailTex.xxx * tmp1.xyz + tmp5.xyz;
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp1.xyz;
                tmp1.xyz = tmp0.xyz * tmp1.xyz;
                tmp0.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp2.xyz = -tmp2.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                o.sv_target.xyz = saturate(tmp0.xyz ? tmp2.xyz : tmp1.xyz);
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Geometry+50" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 188686
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
			float4 _TimeEditor;
			float _SwayStrength;
			float _VertexColorMask;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _AlphaClip_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _AlphaClip;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _TimeEditor.z + _Time.z;
                tmp0.x = tmp0.x * 0.3183099;
                tmp0.x = sin(tmp0.x);
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 3.333333;
                tmp0.yzw = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + unity_WorldToObject._m00_m10_m20;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.xyz = tmp0.xyz * _SwayStrength.xxx;
                tmp0.xyz = tmp0.xyz * float3(0.03, 0.03, 0.03);
                tmp0.w = v.color.x - v.texcoord.y;
                tmp0.w = _VertexColorMask * tmp0.w + v.texcoord.y;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.x = unity_WorldToObject._m00;
                tmp1.y = unity_WorldToObject._m01;
                tmp1.z = unity_WorldToObject._m02;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp1.x = 1.0 / tmp0.w;
                tmp2.x = unity_WorldToObject._m10;
                tmp2.y = unity_WorldToObject._m11;
                tmp2.z = unity_WorldToObject._m12;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp1.y = 1.0 / tmp0.w;
                tmp2.x = unity_WorldToObject._m20;
                tmp2.y = unity_WorldToObject._m21;
                tmp2.z = unity_WorldToObject._m22;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = sqrt(tmp0.w);
                tmp1.z = 1.0 / tmp0.w;
                tmp0.xyz = tmp0.xyz / tmp1.xyz;
                tmp1.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp1.xyz;
                tmp1.xyz = tmp1.xyz - unity_ObjectToWorld._m03_m13_m23;
                tmp2.xyz = tmp1.yyy * unity_WorldToObject._m01_m11_m21;
                tmp1.xyw = unity_WorldToObject._m00_m10_m20 * tmp1.xxx + tmp2.xyz;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * tmp1.zzz + tmp1.xyw;
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
                o.color = v.color;
                return o;
			}
			// Keywords: SHADOWS_DEPTH
			fout frag(v2f inp, float facing: VFACE)
			{
                fout o;
                float4 tmp0;
                tmp0.xy = inp.texcoord1.xy * _AlphaClip_ST.xy + _AlphaClip_ST.zw;
                tmp0 = tex2D(_AlphaClip, tmp0.xy);
                tmp0.x = tmp0.w - 0.5;
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