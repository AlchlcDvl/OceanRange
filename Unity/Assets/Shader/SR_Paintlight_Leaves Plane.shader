Shader "SR/Paintlight/Leaves Plane" {
	Properties {
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		_Depth ("Depth", 2D) = "white" {}
		[MaterialToggle] _EnableDetailTex ("Enable Detail Tex", Float) = 0
		_DetailTex ("Detail Tex", 2D) = "white" {}
		_DetailNoiseMask ("Detail Noise Mask", 2D) = "white" {}
		_CoreTex ("CoreTex", 2D) = "white" {}
		_SwayStrength ("Sway Strength", Range(0, 2)) = 1
		[MaterialToggle] _VertexColorMask ("Vertex Color Mask", Float) = 0
		[MaterialToggle] _Alpha ("Alpha", Float) = 1
		_Density ("Density", Range(0, 2)) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			GpuProgramID 63508
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			float _SwayStrength;
			float _VertexColorMask;
			float4 _CoreTex_ST;
			float _Alpha;
			float _Density;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Depth;
			sampler2D _CoreTex;
			sampler2D _PrimaryTex;
			sampler2D _DetailTex;
			sampler2D _DetailNoiseMask;
			
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
                tmp0.xy = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = 1.0 - tmp0.x;
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * inp.texcoord2.xyz;
                tmp1.w = dot(tmp1.xyz, tmp0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.x = -tmp1.w * tmp1.w + 1.0;
                tmp0.x = tmp0.x - tmp2.x;
                tmp0.x = _Alpha * tmp0.x + tmp2.x;
                tmp0.x = tmp0.x * _Density;
                tmp0.x = tmp0.x * inp.color.x;
                tmp2.x = tmp0.x > 0.3333333;
                tmp2.y = _Time.z * 0.5305164;
                tmp2.z = sin(tmp2.y);
                tmp2.y = -tmp2.z * 0.5 + tmp2.y;
                tmp2.y = sin(tmp2.y);
                tmp2.y = tmp2.y * 3.333333;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + unity_WorldToObject._m00_m10_m20;
                tmp2.z = dot(tmp3.xyz, tmp3.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp3 = tmp2.zzzz * tmp3.xzxz;
                tmp3 = tmp2.yyyy * tmp3;
                tmp3 = tmp3 * _SwayStrength.xxxx;
                tmp3 = tmp3 * float4(0.03, 0.03, 0.03, 0.03);
                tmp2.y = inp.color.x - inp.texcoord.y;
                tmp2.y = _VertexColorMask * tmp2.y + inp.texcoord.y;
                tmp3 = tmp2.yyyy * tmp3;
                tmp2.yz = tmp3.xy * float2(0.5, 0.5) + inp.texcoord1.xy;
                tmp4.xy = tmp2.yz * _Depth_ST.xy + _Depth_ST.zw;
                tmp4 = tex2D(_Depth, tmp4.xy);
                tmp4.yz = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp5.x = dot(tmp4.xy, float2(0.0000003, -1.0));
                tmp5.y = dot(tmp4.xy, float2(1.0, 0.0000003));
                tmp4.yz = tmp5.xy + float2(0.5, 0.5);
                tmp3.xy = tmp3.xy * float2(0.5, 0.5) + tmp4.yz;
                tmp3.zw = tmp3.zw * float2(-0.5, -0.5) + float2(1.0, 1.0);
                tmp3.zw = tmp3.zw + inp.texcoord1.zx;
                tmp4.yz = tmp3.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp5 = tex2D(_Depth, tmp4.yz);
                tmp4.yz = tmp3.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp6 = tex2D(_Depth, tmp4.yz);
                tmp4.yzw = abs(tmp1.xyz) * abs(tmp1.xyz);
                tmp2.w = tmp6.x * tmp4.z;
                tmp2.w = tmp4.y * tmp5.x + tmp2.w;
                tmp2.w = tmp4.w * tmp4.x + tmp2.w;
                tmp4.x = tmp2.w + tmp2.w;
                tmp5.x = tmp0.x * 3.0 + tmp4.x;
                tmp0.x = tmp0.x * 1.5 + -0.5;
                tmp0.x = tmp0.x * 2.0 + tmp4.x;
                tmp4.x = tmp5.x - 1.0;
                tmp0.x = saturate(tmp2.x ? tmp4.x : tmp0.x);
                tmp2.x = tmp0.x + tmp0.x;
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp2.x = min(tmp2.x, 1.0);
                tmp4.x = tmp2.x - 0.5;
                tmp4.x = tmp4.x < 0.0;
                if (tmp4.x) {
                    discard;
                }
                tmp5.xy = tmp2.yz * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp5 = tex2D(_DetailTex, tmp5.xy);
                tmp6.xy = tmp3.xy * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp6 = tex2D(_DetailTex, tmp6.xy);
                tmp7.xy = tmp3.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp7 = tex2D(_DetailTex, tmp7.xy);
                tmp7.xyz = tmp4.zzz * tmp7.xyz;
                tmp6.xyz = tmp4.yyy * tmp6.xyz + tmp7.xyz;
                tmp5.xyz = tmp4.www * tmp5.xyz + tmp6.xyz;
                tmp6.xy = tmp2.yz * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp2.yz = tmp2.yz * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp7 = tex2D(_DetailNoiseMask, tmp2.yz);
                tmp6 = tex2D(_PrimaryTex, tmp6.xy);
                tmp2.yz = tmp3.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp3.xy = tmp3.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp8 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp9 = tex2D(_PrimaryTex, tmp2.yz);
                tmp2.yz = tmp3.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp3.xy = tmp3.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp3.x = tmp3.x * tmp4.z;
                tmp3.x = tmp4.y * tmp8.x + tmp3.x;
                tmp3.x = tmp4.w * tmp7.x + tmp3.x;
                tmp3.x = saturate(tmp3.x * 3.0 + -1.5);
                tmp7 = tex2D(_PrimaryTex, tmp2.yz);
                tmp3.yzw = tmp4.zzz * tmp7.xyz;
                tmp3.yzw = tmp4.yyy * tmp9.xyz + tmp3.yzw;
                tmp3.yzw = tmp4.www * tmp6.xyz + tmp3.yzw;
                tmp5.xyz = tmp5.xyz - tmp3.yzw;
                tmp5.xyz = tmp3.xxx * tmp5.xyz;
                tmp3.xyz = _EnableDetailTex.xxx * tmp5.xyz + tmp3.yzw;
                tmp2.yz = inp.texcoord1.xy * _CoreTex_ST.xy + _CoreTex_ST.zw;
                tmp5 = tex2D(_CoreTex, tmp2.yz);
                tmp6 = inp.texcoord1.yzzx * _CoreTex_ST + _CoreTex_ST;
                tmp7 = tex2D(_CoreTex, tmp6.xy);
                tmp6 = tex2D(_CoreTex, tmp6.zw);
                tmp6.xyz = tmp4.zzz * tmp6.xyz;
                tmp4.xyz = tmp4.yyy * tmp7.xyz + tmp6.xyz;
                tmp4.xyz = tmp4.www * tmp5.xyz + tmp4.xyz;
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + tmp4.xyz;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp2.y = saturate(tmp1.y);
                tmp2.z = dot(abs(tmp1.xy), float2(0.333, 0.333));
                tmp2.y = tmp2.y + tmp2.z;
                tmp2.y = tmp2.y * tmp2.y;
                tmp2.z = tmp0.x * tmp2.y;
                tmp5.xyz = tmp2.yyy * tmp0.xxx + glstate_lightmodel_ambient.xyz;
                tmp5.xyz = tmp5.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp5.xyz = tmp5.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp5.xyz = max(tmp5.xyz, float3(0.75, 0.75, 0.75));
                tmp5.xyz = min(tmp5.xyz, float3(1.0, 1.0, 1.0));
                tmp0.x = tmp1.w * tmp1.w;
                tmp0.x = tmp0.x * tmp1.w;
                tmp0.x = tmp0.x * tmp2.z;
                tmp0.x = dot(tmp0.xy, tmp2.xy);
                tmp5.xyz = tmp0.xxx + tmp5.xyz;
                tmp0.x = floor(tmp0.x);
                tmp1.w = dot(-tmp0.xyz, tmp1.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp0.yzw = tmp1.xyz * -tmp1.www + -tmp0.yzw;
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp6.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp0.y = dot(tmp6.xyz, tmp0.xyz);
                tmp0.z = dot(tmp6.xyz, tmp1.xyz);
                tmp0.yz = max(tmp0.yz, float2(0.0, 0.0));
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp2.w;
                tmp0.w = tmp2.w * 0.334 + 0.333;
                tmp0.y = tmp0.y * 2.5 + -0.5;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = min(tmp0.y, 0.3);
                tmp1.xyz = tmp0.yyy + tmp5.xyz;
                tmp1.xyz = tmp1.xyz * _LightColor0.xyz;
                tmp0.y = 1.0 - tmp0.w;
                tmp1.w = tmp0.z - 0.5;
                tmp1.w = -tmp1.w * 2.0 + 1.0;
                tmp0.y = -tmp1.w * tmp0.y + 1.0;
                tmp1.w = tmp0.z + tmp0.z;
                tmp0.z = tmp0.z > 0.5;
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.y = saturate(tmp0.z ? tmp0.y : tmp0.w);
                tmp0.x = tmp0.y * 13.0 + tmp0.x;
                tmp0.x = saturate(tmp0.x - 5.0);
                tmp0.xyz = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = tmp0.xyz * tmp2.xxx + float3(-0.5, -0.5, -0.5);
                tmp0.xyz = tmp2.xxx * tmp0.xyz;
                tmp1.xyz = -tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp1.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp3.xyz * tmp2.xyz;
                tmp0.xyz = saturate(tmp0.xyz ? tmp1.xyz : tmp2.xyz);
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = saturate(tmp3.xyz * tmp1.xyz);
                tmp0.w = inp.color.z * -0.3 + 1.15;
                o.sv_target.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 104812
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			float _SwayStrength;
			float _VertexColorMask;
			float4 _CoreTex_ST;
			float _Alpha;
			float _Density;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Depth;
			sampler2D _LightTexture0;
			sampler2D _CoreTex;
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
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
                o.color = v.color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord3.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                tmp0.xy = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.x = 1.0 - tmp0.x;
                tmp0.yzw = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.x = dot(tmp0.xyz, tmp0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp0.yzw = tmp0.yzw * tmp1.xxx;
                tmp1.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.xyz = tmp1.xxx * inp.texcoord2.xyz;
                tmp1.w = dot(tmp1.xyz, tmp0.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp2.x = -tmp1.w * tmp1.w + 1.0;
                tmp0.x = tmp0.x - tmp2.x;
                tmp0.x = _Alpha * tmp0.x + tmp2.x;
                tmp0.x = tmp0.x * _Density;
                tmp0.x = tmp0.x * inp.color.x;
                tmp2.x = tmp0.x > 0.3333333;
                tmp2.y = _Time.z * 0.5305164;
                tmp2.z = sin(tmp2.y);
                tmp2.y = -tmp2.z * 0.5 + tmp2.y;
                tmp2.y = sin(tmp2.y);
                tmp2.y = tmp2.y * 3.333333;
                tmp3.xyz = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + unity_WorldToObject._m00_m10_m20;
                tmp2.z = dot(tmp3.xyz, tmp3.xyz);
                tmp2.z = rsqrt(tmp2.z);
                tmp3 = tmp2.zzzz * tmp3.xzxz;
                tmp3 = tmp2.yyyy * tmp3;
                tmp3 = tmp3 * _SwayStrength.xxxx;
                tmp3 = tmp3 * float4(0.03, 0.03, 0.03, 0.03);
                tmp2.y = inp.color.x - inp.texcoord.y;
                tmp2.y = _VertexColorMask * tmp2.y + inp.texcoord.y;
                tmp3 = tmp2.yyyy * tmp3;
                tmp4 = tmp3 * float4(-0.5, -0.5, 0.5, 0.5) + inp.texcoord1.zxxy;
                tmp2.yz = tmp4.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp5 = tex2D(_Depth, tmp2.yz);
                tmp2.yz = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp3.x = dot(tmp2.xy, float2(0.0000003, -1.0));
                tmp3.y = dot(tmp2.xy, float2(1.0, 0.0000003));
                tmp2.yz = tmp3.xy + float2(0.5, 0.5);
                tmp2.yz = tmp3.zw * float2(0.5, 0.5) + tmp2.yz;
                tmp3.xy = tmp2.yz * _Depth_ST.xy + _Depth_ST.zw;
                tmp3 = tex2D(_Depth, tmp3.xy);
                tmp3.yz = tmp4.xy + float2(1.0, 1.0);
                tmp4.xy = tmp3.yz * _Depth_ST.xy + _Depth_ST.zw;
                tmp6 = tex2D(_Depth, tmp4.xy);
                tmp5.yzw = abs(tmp1.xyz) * abs(tmp1.xyz);
                tmp2.w = tmp6.x * tmp5.z;
                tmp2.w = tmp5.y * tmp3.x + tmp2.w;
                tmp2.w = tmp5.w * tmp5.x + tmp2.w;
                tmp3.x = tmp2.w + tmp2.w;
                tmp3.w = tmp0.x * 3.0 + tmp3.x;
                tmp0.x = tmp0.x * 1.5 + -0.5;
                tmp0.x = tmp0.x * 2.0 + tmp3.x;
                tmp3.x = tmp3.w - 1.0;
                tmp0.x = saturate(tmp2.x ? tmp3.x : tmp0.x);
                tmp2.x = tmp0.x + tmp0.x;
                tmp0.x = tmp0.x * 2.0 + -1.0;
                tmp0.x = max(tmp0.x, 0.0);
                tmp2.x = min(tmp2.x, 1.0);
                tmp3.x = tmp2.x - 0.5;
                tmp3.x = tmp3.x < 0.0;
                if (tmp3.x) {
                    discard;
                }
                tmp3.xw = tmp4.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp6 = tex2D(_DetailTex, tmp3.xw);
                tmp3.xw = tmp2.yz * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp7 = tex2D(_DetailTex, tmp3.xw);
                tmp3.xw = tmp3.yz * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp8 = tex2D(_DetailTex, tmp3.xw);
                tmp8.xyz = tmp5.zzz * tmp8.xyz;
                tmp7.xyz = tmp5.yyy * tmp7.xyz + tmp8.xyz;
                tmp6.xyz = tmp5.www * tmp6.xyz + tmp7.xyz;
                tmp3.xw = tmp4.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp4.xy = tmp4.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp4 = tex2D(_DetailNoiseMask, tmp4.xy);
                tmp7 = tex2D(_PrimaryTex, tmp3.xw);
                tmp3.xw = tmp2.yz * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp2.yz = tmp2.yz * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp8 = tex2D(_DetailNoiseMask, tmp2.yz);
                tmp9 = tex2D(_PrimaryTex, tmp3.xw);
                tmp2.yz = tmp3.yz * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp3.xy = tmp3.yz * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp3 = tex2D(_DetailNoiseMask, tmp3.xy);
                tmp3.x = tmp3.x * tmp5.z;
                tmp3.x = tmp5.y * tmp8.x + tmp3.x;
                tmp3.x = tmp5.w * tmp4.x + tmp3.x;
                tmp3.x = saturate(tmp3.x * 3.0 + -1.5);
                tmp4 = tex2D(_PrimaryTex, tmp2.yz);
                tmp3.yzw = tmp4.xyz * tmp5.zzz;
                tmp3.yzw = tmp5.yyy * tmp9.xyz + tmp3.yzw;
                tmp3.yzw = tmp5.www * tmp7.xyz + tmp3.yzw;
                tmp4.xyz = tmp6.xyz - tmp3.yzw;
                tmp4.xyz = tmp3.xxx * tmp4.xyz;
                tmp3.xyz = _EnableDetailTex.xxx * tmp4.xyz + tmp3.yzw;
                tmp2.yz = inp.texcoord1.xy * _CoreTex_ST.xy + _CoreTex_ST.zw;
                tmp4 = tex2D(_CoreTex, tmp2.yz);
                tmp6 = inp.texcoord1.yzzx * _CoreTex_ST + _CoreTex_ST;
                tmp7 = tex2D(_CoreTex, tmp6.xy);
                tmp6 = tex2D(_CoreTex, tmp6.zw);
                tmp6.xyz = tmp5.zzz * tmp6.xyz;
                tmp5.xyz = tmp5.yyy * tmp7.xyz + tmp6.xyz;
                tmp4.xyz = tmp5.www * tmp4.xyz + tmp5.xyz;
                tmp3.xyz = tmp3.xyz - tmp4.xyz;
                tmp3.xyz = tmp0.xxx * tmp3.xyz + tmp4.xyz;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp2.y = saturate(tmp1.y);
                tmp2.z = dot(abs(tmp1.xy), float2(0.333, 0.333));
                tmp2.y = tmp2.y + tmp2.z;
                tmp2.y = tmp2.y * tmp2.y;
                tmp2.z = tmp0.x * tmp2.y;
                tmp5.xyz = tmp2.yyy * tmp0.xxx + glstate_lightmodel_ambient.xyz;
                tmp5.xyz = tmp5.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp5.xyz = tmp5.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp5.xyz = max(tmp5.xyz, float3(0.75, 0.75, 0.75));
                tmp5.xyz = min(tmp5.xyz, float3(1.0, 1.0, 1.0));
                tmp0.x = tmp1.w * tmp1.w;
                tmp0.x = tmp0.x * tmp1.w;
                tmp0.x = tmp0.x * tmp2.z;
                tmp0.x = dot(tmp0.xy, tmp2.xy);
                tmp5.xyz = tmp0.xxx + tmp5.xyz;
                tmp0.x = floor(tmp0.x);
                tmp1.w = dot(-tmp0.xyz, tmp1.xyz);
                tmp1.w = tmp1.w + tmp1.w;
                tmp0.yzw = tmp1.xyz * -tmp1.www + -tmp0.yzw;
                tmp6.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp6.xyz, tmp6.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp6.xyz = tmp1.www * tmp6.xyz;
                tmp0.y = dot(tmp6.xyz, tmp0.xyz);
                tmp0.z = dot(tmp6.xyz, tmp1.xyz);
                tmp0.yz = max(tmp0.yz, float2(0.0, 0.0));
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp2.w;
                tmp0.w = tmp2.w * 0.334 + 0.333;
                tmp0.y = tmp0.y * 2.5 + -0.5;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = min(tmp0.y, 0.3);
                tmp1.xyz = tmp0.yyy + tmp5.xyz;
                tmp0.y = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp5 = tex2D(_LightTexture0, tmp0.yy);
                tmp2.yzw = tmp5.xxx * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * tmp2.yzw;
                tmp0.y = 1.0 - tmp0.w;
                tmp1.w = tmp0.z - 0.5;
                tmp1.w = -tmp1.w * 2.0 + 1.0;
                tmp0.y = -tmp1.w * tmp0.y + 1.0;
                tmp1.w = tmp0.z + tmp0.z;
                tmp0.z = tmp0.z > 0.5;
                tmp0.w = tmp0.w * tmp1.w;
                tmp0.y = saturate(tmp0.z ? tmp0.y : tmp0.w);
                tmp0.x = tmp0.y * 13.0 + tmp0.x;
                tmp0.x = saturate(tmp0.x - 5.0);
                tmp0.xyz = tmp0.xxx * tmp1.xyz;
                tmp1.xyz = tmp0.xyz * tmp2.xxx + float3(-0.5, -0.5, -0.5);
                tmp0.xyz = tmp2.xxx * tmp0.xyz;
                tmp1.xyz = -tmp1.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp1.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp3.xyz * tmp2.xyz;
                o.sv_target.xyz = saturate(tmp0.xyz ? tmp1.xyz : tmp2.xyz);
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 153079
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
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Depth_ST;
			float _SwayStrength;
			float _VertexColorMask;
			float _Alpha;
			float _Density;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Depth;
			
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
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Time.z * 0.5305164;
                tmp0.y = sin(tmp0.x);
                tmp0.x = -tmp0.y * 0.5 + tmp0.x;
                tmp0.x = sin(tmp0.x);
                tmp0.x = tmp0.x * 3.333333;
                tmp0.yzw = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + unity_WorldToObject._m00_m10_m20;
                tmp0.z = dot(tmp0.xyz, tmp0.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1 = tmp0.zzzz * tmp0.ywyw;
                tmp0 = tmp0.xxxx * tmp1;
                tmp0 = tmp0 * _SwayStrength.xxxx;
                tmp0 = tmp0 * float4(0.03, 0.03, 0.03, 0.03);
                tmp1.x = inp.color.x - inp.texcoord1.y;
                tmp1.x = _VertexColorMask * tmp1.x + inp.texcoord1.y;
                tmp0 = tmp0 * tmp1.xxxx;
                tmp1.xy = inp.texcoord2.yz - float2(0.5, 0.5);
                tmp2.x = dot(tmp1.xy, float2(0.0000003, -1.0));
                tmp2.y = dot(tmp1.xy, float2(1.0, 0.0000003));
                tmp1.xy = tmp2.xy + float2(0.5, 0.5);
                tmp1.xy = tmp0.zw * float2(0.5, 0.5) + tmp1.xy;
                tmp0 = tmp0 * float4(-0.5, -0.5, 0.5, 0.5) + inp.texcoord2.zxxy;
                tmp1.xy = tmp1.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp1 = tex2D(_Depth, tmp1.xy);
                tmp0.xy = tmp0.xy + float2(1.0, 1.0);
                tmp0.zw = tmp0.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp2 = tex2D(_Depth, tmp0.zw);
                tmp0.xy = tmp0.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp0 = tex2D(_Depth, tmp0.xy);
                tmp0.y = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * inp.texcoord3.xyz;
                tmp1.yzw = abs(tmp0.yzw) * abs(tmp0.yzw);
                tmp0.x = tmp0.x * tmp1.z;
                tmp0.x = tmp1.y * tmp1.x + tmp0.x;
                tmp0.x = tmp1.w * tmp2.x + tmp0.x;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp0.y = dot(tmp0.xyz, tmp1.xyz);
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp0.y = -tmp0.y * tmp0.y + 1.0;
                tmp0.zw = inp.texcoord1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.zw = tmp0.zw * tmp0.zw;
                tmp0.xz = tmp0.xw + tmp0.xz;
                tmp0.z = 1.0 - tmp0.z;
                tmp0.z = tmp0.z - tmp0.y;
                tmp0.y = _Alpha * tmp0.z + tmp0.y;
                tmp0.y = tmp0.y * _Density;
                tmp0.y = tmp0.y * inp.color.x;
                tmp0.z = tmp0.y * 3.0 + tmp0.x;
                tmp0.z = tmp0.z - 1.0;
                tmp0.w = tmp0.y * 1.5 + -0.5;
                tmp0.y = tmp0.y > 0.3333333;
                tmp0.x = tmp0.w * 2.0 + tmp0.x;
                tmp0.x = saturate(tmp0.y ? tmp0.z : tmp0.x);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.x = tmp0.x - 0.5;
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
	CustomEditor "ShaderForgeMaterialInspector"
}