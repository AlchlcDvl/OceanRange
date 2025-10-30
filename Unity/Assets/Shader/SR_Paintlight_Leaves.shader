Shader "SR/Paintlight/Leaves" {
	Properties {
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		_Depth ("Depth", 2D) = "white" {}
		[MaterialToggle] _EnableDetailTex ("Enable Detail Tex", Float) = 0
		_DetailTex ("Detail Tex", 2D) = "white" {}
		_DetailNoiseMask ("Detail Noise Mask", 2D) = "white" {}
		_CoreTex ("CoreTex", 2D) = "white" {}
		_VertexOffset ("Vertex Offset", Range(-0.15, 0.15)) = 0
		_SwayStrength ("Sway Strength", Range(0, 2)) = 1
		[MaterialToggle] _VertexColorMask ("Vertex Color Mask", Float) = 0
		_WindTurbulance ("Wind Turbulance", Float) = 2
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 24036
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
			float _SwayStrength;
			float _VertexColorMask;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			float4 _CoreTex_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CoreTex;
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
                float4 tmp2;
                tmp0.x = _Time.z * 0.5305164;
                tmp0.y = sin(tmp0.x);
                tmp0.x = -tmp0.y * 0.5 + tmp0.x;
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
                tmp1.x = inp.color.x - inp.texcoord.y;
                tmp1.x = _VertexColorMask * tmp1.x + inp.texcoord.y;
                tmp0 = tmp0 * tmp1.xxxx;
                tmp1.xy = tmp0.xy * float2(0.5, 0.5) + inp.texcoord1.xy;
                tmp1.zw = tmp1.xy * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp2 = tex2D(_DetailTex, tmp1.zw);
                tmp1.zw = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp3.x = dot(tmp1.xy, float2(0.0000003, -1.0));
                tmp3.y = dot(tmp1.xy, float2(1.0, 0.0000003));
                tmp1.zw = tmp3.xy + float2(0.5, 0.5);
                tmp0.xy = tmp0.xy * float2(0.5, 0.5) + tmp1.zw;
                tmp0.zw = tmp0.zw * float2(-0.5, -0.5) + float2(1.0, 1.0);
                tmp0.zw = tmp0.zw + inp.texcoord1.zx;
                tmp1.zw = tmp0.xy * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp3 = tex2D(_DetailTex, tmp1.zw);
                tmp1.zw = tmp0.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp4 = tex2D(_DetailTex, tmp1.zw);
                tmp1.z = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.z = rsqrt(tmp1.z);
                tmp5.xyz = tmp1.zzz * inp.texcoord2.xyz;
                tmp6.xyz = abs(tmp5.xyz) * abs(tmp5.xyz);
                tmp4.xyz = tmp4.xyz * tmp6.yyy;
                tmp3.xyz = tmp6.xxx * tmp3.xyz + tmp4.xyz;
                tmp2.xyz = tmp6.zzz * tmp2.xyz + tmp3.xyz;
                tmp1.zw = tmp1.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp3 = tex2D(_PrimaryTex, tmp1.zw);
                tmp1.zw = tmp0.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp4 = tex2D(_PrimaryTex, tmp1.zw);
                tmp1.zw = tmp0.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp7 = tex2D(_PrimaryTex, tmp1.zw);
                tmp7.xyz = tmp6.yyy * tmp7.xyz;
                tmp4.xyz = tmp6.xxx * tmp4.xyz + tmp7.xyz;
                tmp3.xyz = tmp6.zzz * tmp3.xyz + tmp4.xyz;
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp1.zw = tmp1.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp1.xy = tmp1.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp4 = tex2D(_Depth, tmp1.xy);
                tmp1 = tex2D(_DetailNoiseMask, tmp1.zw);
                tmp1.yz = tmp0.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp0.xy = tmp0.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp7 = tex2D(_Depth, tmp0.xy);
                tmp8 = tex2D(_DetailNoiseMask, tmp1.yz);
                tmp0.xy = tmp0.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp0.zw = tmp0.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp9 = tex2D(_Depth, tmp0.zw);
                tmp0.z = tmp6.y * tmp9.x;
                tmp0.z = tmp6.x * tmp7.x + tmp0.z;
                tmp0.z = tmp6.z * tmp4.x + tmp0.z;
                tmp4 = tex2D(_DetailNoiseMask, tmp0.xy);
                tmp0.x = tmp4.x * tmp6.y;
                tmp0.x = tmp6.x * tmp8.x + tmp0.x;
                tmp0.x = tmp6.z * tmp1.x + tmp0.x;
                tmp0.x = saturate(tmp0.x * 3.0 + -1.5);
                tmp0.xyw = tmp2.xyz * tmp0.xxx;
                tmp0.xyw = _EnableDetailTex.xxx * tmp0.xyw + tmp3.xyz;
                tmp1.xy = inp.texcoord1.xy * _CoreTex_ST.xy + _CoreTex_ST.zw;
                tmp1 = tex2D(_CoreTex, tmp1.xy);
                tmp2 = inp.texcoord1.yzzx * _CoreTex_ST + _CoreTex_ST;
                tmp3 = tex2D(_CoreTex, tmp2.xy);
                tmp2 = tex2D(_CoreTex, tmp2.zw);
                tmp2.xyz = tmp2.xyz * tmp6.yyy;
                tmp2.xyz = tmp6.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = tmp6.zzz * tmp1.xyz + tmp2.xyz;
                tmp0.xyw = tmp0.xyw - tmp1.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp1.w = dot(tmp5.xyz, tmp2.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp3.xy = -tmp1.ww * tmp1.ww + float2(1.0, 0.5);
                tmp3.yz = tmp3.xy + tmp3.xy;
                tmp2.w = tmp3.x > 0.5;
                tmp3.xy = tmp0.zz * float2(2.0, 2.0) + tmp3.yz;
                tmp3.x = tmp3.x - 1.0;
                tmp2.w = saturate(tmp2.w ? tmp3.x : tmp3.y);
                tmp3.x = tmp2.w * 2.0 + -1.0;
                tmp2.w = tmp2.w + tmp2.w;
                tmp3.x = max(tmp3.x, 0.0);
                tmp0.xyw = tmp3.xxx * tmp0.xyw + tmp1.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyw;
                tmp3.y = saturate(tmp5.y);
                tmp3.z = dot(abs(tmp5.xy), float2(0.333, 0.333));
                tmp3.y = tmp3.y + tmp3.z;
                tmp3.y = tmp3.y * tmp3.y;
                tmp3.z = tmp3.x * tmp3.y;
                tmp3.xyw = tmp3.yyy * tmp3.xxx + glstate_lightmodel_ambient.xyz;
                tmp3.xyw = tmp3.xyw * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp3.xyw = tmp3.xyw * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp3.xyw = max(tmp3.xyw, float3(0.75, 0.75, 0.75));
                tmp3.xyw = min(tmp3.xyw, float3(1.0, 1.0, 1.0));
                tmp4.x = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp4.x;
                tmp1.w = tmp1.w * tmp3.z;
                tmp1.w = dot(tmp1.xy, tmp0.xy);
                tmp3.xyz = tmp1.www + tmp3.xyw;
                tmp1.w = floor(tmp1.w);
                tmp3.w = dot(-tmp2.xyz, tmp5.xyz);
                tmp3.w = tmp3.w + tmp3.w;
                tmp2.xyz = tmp5.xyz * -tmp3.www + -tmp2.xyz;
                tmp3.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp4.xyz = tmp3.www * _WorldSpaceLightPos0.xyz;
                tmp2.x = dot(tmp4.xyz, tmp2.xyz);
                tmp2.y = dot(tmp4.xyz, tmp5.xyz);
                tmp2.xy = max(tmp2.xy, float2(0.0, 0.0));
                tmp2.x = tmp2.x * tmp2.x;
                tmp2.x = tmp0.z * tmp2.x;
                tmp0.z = tmp0.z * 0.334 + 0.333;
                tmp2.x = tmp2.x * 2.5 + -0.5;
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.xw = min(tmp2.xw, float2(0.3, 1.0));
                tmp3.xyz = tmp2.xxx + tmp3.xyz;
                tmp3.xyz = tmp3.xyz * _LightColor0.xyz;
                tmp2.x = 1.0 - tmp0.z;
                tmp2.z = tmp2.y - 0.5;
                tmp2.z = -tmp2.z * 2.0 + 1.0;
                tmp2.x = -tmp2.z * tmp2.x + 1.0;
                tmp2.z = tmp2.y + tmp2.y;
                tmp2.y = tmp2.y > 0.5;
                tmp0.z = tmp0.z * tmp2.z;
                tmp0.z = saturate(tmp2.y ? tmp2.x : tmp0.z);
                tmp0.z = tmp0.z * 13.0 + tmp1.w;
                tmp0.z = saturate(tmp0.z - 5.0);
                tmp2.xyz = tmp0.zzz * tmp3.xyz;
                tmp3.xyz = tmp2.xyz * tmp2.www + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp2.xyz + tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp0.xyw * tmp3.xyz;
                tmp1.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp3.xyz);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.xyz = saturate(tmp0.xyw * tmp2.xyz);
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
			GpuProgramID 100832
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
			float _SwayStrength;
			float _VertexColorMask;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			float4 _CoreTex_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _CoreTex;
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
                tmp0.x = _Time.z * 0.5305164;
                tmp0.y = sin(tmp0.x);
                tmp0.x = -tmp0.y * 0.5 + tmp0.x;
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
                tmp1.x = inp.color.x - inp.texcoord.y;
                tmp1.x = _VertexColorMask * tmp1.x + inp.texcoord.y;
                tmp0 = tmp0 * tmp1.xxxx;
                tmp1 = tmp0 * float4(-0.5, -0.5, 0.5, 0.5) + inp.texcoord1.zxxy;
                tmp0.xy = tmp1.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp2 = tex2D(_DetailTex, tmp0.xy);
                tmp0.xy = inp.texcoord1.yz - float2(0.5, 0.5);
                tmp3.x = dot(tmp0.xy, float2(0.0000003, -1.0));
                tmp3.y = dot(tmp0.xy, float2(1.0, 0.0000003));
                tmp0.xy = tmp3.xy + float2(0.5, 0.5);
                tmp0.xy = tmp0.zw * float2(0.5, 0.5) + tmp0.xy;
                tmp0.zw = tmp0.xy * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp3 = tex2D(_DetailTex, tmp0.zw);
                tmp0.zw = tmp1.xy + float2(1.0, 1.0);
                tmp1.xy = tmp0.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp4 = tex2D(_DetailTex, tmp1.xy);
                tmp1.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp5.xyz = tmp1.xxx * inp.texcoord2.xyz;
                tmp6.xyz = abs(tmp5.xyz) * abs(tmp5.xyz);
                tmp4.xyz = tmp4.xyz * tmp6.yyy;
                tmp3.xyz = tmp6.xxx * tmp3.xyz + tmp4.xyz;
                tmp2.xyz = tmp6.zzz * tmp2.xyz + tmp3.xyz;
                tmp1.xy = tmp1.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp3 = tex2D(_PrimaryTex, tmp1.xy);
                tmp1.xy = tmp0.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp4 = tex2D(_PrimaryTex, tmp1.xy);
                tmp1.xy = tmp0.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp7 = tex2D(_PrimaryTex, tmp1.xy);
                tmp7.xyz = tmp6.yyy * tmp7.xyz;
                tmp4.xyz = tmp6.xxx * tmp4.xyz + tmp7.xyz;
                tmp3.xyz = tmp6.zzz * tmp3.xyz + tmp4.xyz;
                tmp2.xyz = tmp2.xyz - tmp3.xyz;
                tmp1.xy = tmp1.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp1.zw = tmp1.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp4 = tex2D(_Depth, tmp1.zw);
                tmp1 = tex2D(_DetailNoiseMask, tmp1.xy);
                tmp1.yz = tmp0.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp0.xy = tmp0.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp7 = tex2D(_Depth, tmp0.xy);
                tmp8 = tex2D(_DetailNoiseMask, tmp1.yz);
                tmp0.xy = tmp0.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp0.zw = tmp0.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp9 = tex2D(_Depth, tmp0.zw);
                tmp0.z = tmp6.y * tmp9.x;
                tmp0.z = tmp6.x * tmp7.x + tmp0.z;
                tmp0.z = tmp6.z * tmp4.x + tmp0.z;
                tmp4 = tex2D(_DetailNoiseMask, tmp0.xy);
                tmp0.x = tmp4.x * tmp6.y;
                tmp0.x = tmp6.x * tmp8.x + tmp0.x;
                tmp0.x = tmp6.z * tmp1.x + tmp0.x;
                tmp0.x = saturate(tmp0.x * 3.0 + -1.5);
                tmp0.xyw = tmp2.xyz * tmp0.xxx;
                tmp0.xyw = _EnableDetailTex.xxx * tmp0.xyw + tmp3.xyz;
                tmp1.xy = inp.texcoord1.xy * _CoreTex_ST.xy + _CoreTex_ST.zw;
                tmp1 = tex2D(_CoreTex, tmp1.xy);
                tmp2 = inp.texcoord1.yzzx * _CoreTex_ST + _CoreTex_ST;
                tmp3 = tex2D(_CoreTex, tmp2.xy);
                tmp2 = tex2D(_CoreTex, tmp2.zw);
                tmp2.xyz = tmp2.xyz * tmp6.yyy;
                tmp2.xyz = tmp6.xxx * tmp3.xyz + tmp2.xyz;
                tmp1.xyz = tmp6.zzz * tmp1.xyz + tmp2.xyz;
                tmp0.xyw = tmp0.xyw - tmp1.xyz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp1.w = dot(tmp5.xyz, tmp2.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp1.w = 1.0 - tmp1.w;
                tmp3.xy = -tmp1.ww * tmp1.ww + float2(1.0, 0.5);
                tmp3.yz = tmp3.xy + tmp3.xy;
                tmp2.w = tmp3.x > 0.5;
                tmp3.xy = tmp0.zz * float2(2.0, 2.0) + tmp3.yz;
                tmp3.x = tmp3.x - 1.0;
                tmp2.w = saturate(tmp2.w ? tmp3.x : tmp3.y);
                tmp3.x = tmp2.w * 2.0 + -1.0;
                tmp2.w = tmp2.w + tmp2.w;
                tmp3.x = max(tmp3.x, 0.0);
                tmp0.xyw = tmp3.xxx * tmp0.xyw + tmp1.xyz;
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyw;
                tmp3.y = saturate(tmp5.y);
                tmp3.z = dot(abs(tmp5.xy), float2(0.333, 0.333));
                tmp3.y = tmp3.y + tmp3.z;
                tmp3.y = tmp3.y * tmp3.y;
                tmp3.z = tmp3.x * tmp3.y;
                tmp3.xyw = tmp3.yyy * tmp3.xxx + glstate_lightmodel_ambient.xyz;
                tmp3.xyw = tmp3.xyw * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp3.xyw = tmp3.xyw * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp3.xyw = max(tmp3.xyw, float3(0.75, 0.75, 0.75));
                tmp3.xyw = min(tmp3.xyw, float3(1.0, 1.0, 1.0));
                tmp4.x = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp4.x;
                tmp1.w = tmp1.w * tmp3.z;
                tmp1.w = dot(tmp1.xy, tmp0.xy);
                tmp3.xyz = tmp1.www + tmp3.xyw;
                tmp1.w = floor(tmp1.w);
                tmp3.w = dot(-tmp2.xyz, tmp5.xyz);
                tmp3.w = tmp3.w + tmp3.w;
                tmp2.xyz = tmp5.xyz * -tmp3.www + -tmp2.xyz;
                tmp4.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp3.w = dot(tmp4.xyz, tmp4.xyz);
                tmp3.w = rsqrt(tmp3.w);
                tmp4.xyz = tmp3.www * tmp4.xyz;
                tmp2.x = dot(tmp4.xyz, tmp2.xyz);
                tmp2.y = dot(tmp4.xyz, tmp5.xyz);
                tmp2.xy = max(tmp2.xy, float2(0.0, 0.0));
                tmp2.x = tmp2.x * tmp2.x;
                tmp2.x = tmp0.z * tmp2.x;
                tmp0.z = tmp0.z * 0.334 + 0.333;
                tmp2.x = tmp2.x * 2.5 + -0.5;
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.xw = min(tmp2.xw, float2(0.3, 1.0));
                tmp3.xyz = tmp2.xxx + tmp3.xyz;
                tmp2.x = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp4 = tex2D(_LightTexture0, tmp2.xx);
                tmp4.xyz = tmp4.xxx * _LightColor0.xyz;
                tmp3.xyz = tmp3.xyz * tmp4.xyz;
                tmp2.x = 1.0 - tmp0.z;
                tmp0.z = dot(tmp0.xy, tmp2.xy);
                tmp2.z = tmp2.y - 0.5;
                tmp2.y = tmp2.y > 0.5;
                tmp2.z = -tmp2.z * 2.0 + 1.0;
                tmp2.x = -tmp2.z * tmp2.x + 1.0;
                tmp0.z = saturate(tmp2.y ? tmp2.x : tmp0.z);
                tmp0.z = tmp0.z * 13.0 + tmp1.w;
                tmp0.z = saturate(tmp0.z - 5.0);
                tmp2.xyz = tmp0.zzz * tmp3.xyz;
                tmp3.xyz = tmp2.xyz * tmp2.www + float3(-0.5, -0.5, -0.5);
                tmp2.xyz = tmp2.www * tmp2.xyz;
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = -tmp3.xyz * tmp1.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyw * tmp2.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.xyz = saturate(tmp2.xyz ? tmp1.xyz : tmp0.xyz);
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 188341
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
			float _SwayStrength;
			float _VertexColorMask;
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
                tmp0.x = _Time.z * 0.5305164;
                tmp0.y = sin(tmp0.x);
                tmp0.x = -tmp0.y * 0.5 + tmp0.x;
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
			fout frag(v2f inp)
			{
                fout o;
                o.sv_target = float4(0.0, 0.0, 0.0, 0.0);
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ShaderForgeMaterialInspector"
}