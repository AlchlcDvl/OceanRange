Shader "SR/Paintlight/Triplanar Glass Desert 2" {
	Properties {
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_Shininess ("Shininess", Range(0, 1)) = 0.08
		_Normal ("Normal", 2D) = "bump" {}
		_g ("g", Float) = 0
		_Thickness ("Thickness", Float) = 1
		_Noise ("Noise", 2D) = "gray" {}
		_Rainbow ("Rainbow", 2D) = "white" {}
		_GlassMask ("GlassMask", 2D) = "black" {}
		_GlossSphere ("GlossSphere", 2D) = "black" {}
		_RainbowOverride ("Rainbow Override", Color) = (0,0.6705883,1,0.5)
		_PrismaticSpeed ("Prismatic Speed", Float) = 0.1
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 34937
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
				float3 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;
			float4 _Normal_ST;
			float _g;
			float _Thickness;
			float4 _Rainbow_ST;
			float4 _Noise_ST;
			float4 _GlassMask_ST;
			float4 _GlossSphere_ST;
			float4 _RainbowOverride;
			float _PrismaticSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Noise;
			sampler2D _Rainbow;
			sampler2D _Normal;
			sampler2D _GlassMask;
			sampler2D _GlossSphere;
			
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord1.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xzw = tmp0.www * tmp0.xyz;
                tmp0.y = saturate(tmp0.y * 0.0125);
                tmp1.x = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp1.yzw = tmp1.xxx * inp.texcoord1.xyz;
                tmp2.x = dot(tmp1.xyz, tmp0.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.x = 1.0 - tmp2.x;
                tmp2.y = inp.texcoord1.x * tmp1.x + -tmp1.w;
                tmp3.xyz = abs(tmp1.yzw) * abs(tmp1.yzw);
                tmp1.y = tmp3.x * tmp2.y + tmp1.w;
                tmp1.z = inp.texcoord1.y * tmp1.x + -tmp1.y;
                tmp1.y = tmp3.y * tmp1.z + tmp1.y;
                tmp1.z = inp.texcoord1.z * tmp1.x + -tmp1.y;
                tmp2.yzw = inp.texcoord1.xyz * tmp1.xxx + float3(0.0, 0.0, 1.0);
                tmp1.x = tmp3.z * tmp1.z + tmp1.y;
                tmp1.y = tmp2.x - tmp1.x;
                tmp1.z = tmp1.y + tmp1.y;
                tmp4.x = dot(inp.texcoord2.xyz, tmp0.xyz);
                tmp4.y = dot(inp.texcoord3.xyz, tmp0.xyz);
                tmp1.zw = tmp1.zz * tmp4.xy + inp.texcoord.zy;
                tmp1.zw = tmp1.zw * _GlassMask_ST.xy + _GlassMask_ST.zw;
                tmp5 = tex2D(_GlassMask, tmp1.zw);
                tmp1.z = tmp1.y * -2.0;
                tmp6 = tmp1.zzzz * tmp4.xyxy + inp.texcoord.xyxz;
                tmp6 = tmp6 * _GlassMask_ST + _GlassMask_ST;
                tmp7 = tex2D(_GlassMask, tmp6.xy);
                tmp6 = tex2D(_GlassMask, tmp6.zw);
                tmp1.z = tmp5.z - tmp7.z;
                tmp1.z = tmp3.x * tmp1.z + tmp7.z;
                tmp1.w = tmp6.z - tmp1.z;
                tmp1.z = tmp3.y * tmp1.w + tmp1.z;
                tmp1.w = tmp7.z - tmp1.z;
                tmp1.z = tmp3.z * tmp1.w + tmp1.z;
                tmp1.z = tmp1.z * 0.1;
                tmp4.zw = tmp1.yy * tmp4.xy + inp.texcoord.zy;
                tmp5 = -tmp1.yyyy * tmp4.xyxy + inp.texcoord.xyxz;
                tmp5 = tmp5 * _GlassMask_ST + _GlassMask_ST;
                tmp1.yw = tmp4.zw * _GlassMask_ST.xy + _GlassMask_ST.zw;
                tmp6 = tex2D(_GlassMask, tmp1.yw);
                tmp7 = tex2D(_GlassMask, tmp5.xy);
                tmp5 = tex2D(_GlassMask, tmp5.zw);
                tmp1.y = tmp6.y - tmp7.y;
                tmp1.y = tmp3.x * tmp1.y + tmp7.y;
                tmp1.w = tmp5.y - tmp1.y;
                tmp1.y = tmp3.y * tmp1.w + tmp1.y;
                tmp1.w = tmp7.y - tmp1.y;
                tmp1.y = tmp3.z * tmp1.w + tmp1.y;
                tmp1.y = tmp1.y * 0.2 + tmp1.z;
                tmp1.zw = inp.texcoord.xz * _Normal_ST.xy + _Normal_ST.zw;
                tmp5 = tex2D(_Normal, tmp1.zw);
                tmp5.x = tmp5.w * tmp5.x;
                tmp5.xy = tmp5.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.z = dot(tmp5.xy, tmp5.xy);
                tmp1.z = min(tmp1.z, 1.0);
                tmp1.xz = float2(1.0, 1.0) - tmp1.xz;
                tmp5.z = sqrt(tmp1.z);
                tmp6 = inp.texcoord.xyzy * _Normal_ST + _Normal_ST;
                tmp7 = tex2D(_Normal, tmp6.zw);
                tmp6 = tex2D(_Normal, tmp6.xy);
                tmp7.x = tmp7.w * tmp7.x;
                tmp7.xy = tmp7.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.z = dot(tmp7.xy, tmp7.xy);
                tmp1.z = min(tmp1.z, 1.0);
                tmp1.z = 1.0 - tmp1.z;
                tmp7.z = sqrt(tmp1.z);
                tmp6.x = tmp6.w * tmp6.x;
                tmp6.xy = tmp6.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp1.z = dot(tmp6.xy, tmp6.xy);
                tmp1.z = min(tmp1.z, 1.0);
                tmp1.z = 1.0 - tmp1.z;
                tmp6.z = sqrt(tmp1.z);
                tmp7.xyz = tmp7.xyz - tmp6.xyz;
                tmp7.xyz = tmp3.xxx * tmp7.xyz + tmp6.xyz;
                tmp5.xyz = tmp5.xyz - tmp7.xyz;
                tmp5.xyz = tmp3.yyy * tmp5.xyz + tmp7.xyz;
                tmp6.xyz = tmp6.xyz - tmp5.xyz;
                tmp5.xyz = tmp3.zzz * tmp6.xyz + tmp5.xyz;
                tmp6.xyz = tmp5.xyz * float3(-1.0, -1.0, 1.0);
                tmp1.z = dot(tmp2.xyz, tmp6.xyz);
                tmp6.xyz = tmp1.zzz * tmp2.yzw;
                tmp2.yzw = tmp6.xyz / tmp2.www;
                tmp2.yzw = -tmp5.xyz * float3(-1.0, -1.0, 1.0) + tmp2.yzw;
                tmp1.z = dot(tmp2.xyz, tmp0.xyz);
                tmp1.z = max(tmp1.z, 0.0);
                tmp1.z = 1.0 - tmp1.z;
                tmp1.w = log(tmp1.z);
                tmp1.w = tmp1.w * 1.148698;
                tmp1.w = exp(tmp1.w);
                tmp1.w = tmp1.w * -2.0 + 1.0;
                tmp1.w = max(tmp1.w, 0.0);
                tmp5.xyz = tmp1.www * _SpecularColor.xyz;
                tmp1.w = inp.texcoord.y - _WorldSpaceCameraPos.y;
                tmp1.w = saturate(tmp1.w * 0.025);
                tmp0.y = tmp0.y * 0.75 + tmp1.w;
                tmp1.w = tmp0.y * -3.333333 + 1.0;
                tmp5.xyz = tmp1.www * tmp5.xyz;
                tmp6.xyz = tmp5.xyz + tmp5.xyz;
                tmp6.xyz = tmp6.xyz * tmp6.xyz;
                tmp6.xyz = tmp1.yyy * tmp6.xyz;
                tmp1.y = tmp1.z * tmp1.z;
                tmp1.y = tmp1.y * tmp1.z;
                tmp1.z = rsqrt(tmp1.z);
                tmp1.z = 1.0 / tmp1.z;
                tmp1.z = tmp1.z * -4.0 + 1.0;
                tmp1.z = max(tmp1.z, 0.0);
                tmp1.y = saturate(tmp1.y * 7.142857);
                tmp5.xyz = tmp5.xyz * float3(2.0, 2.0, 2.0) + tmp1.yyy;
                tmp1.yw = inp.texcoord.xz * _GlassMask_ST.xy;
                tmp1.yw = tmp1.yw * float2(0.25, 0.25) + _GlassMask_ST.zw;
                tmp7 = tex2D(_GlassMask, tmp1.yw);
                tmp8 = inp.texcoord.xyzy * _GlassMask_ST;
                tmp8 = tmp8 * float4(0.25, 0.25, 0.25, 0.25) + _GlassMask_ST;
                tmp9 = tex2D(_GlassMask, tmp8.zw);
                tmp8 = tex2D(_GlassMask, tmp8.xy);
                tmp1.y = tmp9.x - tmp8.x;
                tmp1.y = tmp3.x * tmp1.y + tmp8.x;
                tmp1.w = tmp7.x - tmp1.y;
                tmp1.y = tmp3.y * tmp1.w + tmp1.y;
                tmp1.w = tmp8.x - tmp1.y;
                tmp1.y = tmp3.z * tmp1.w + tmp1.y;
                tmp6.xyz = tmp5.xyz * tmp1.yyy + tmp6.xyz;
                tmp7.xyz = tmp6.xyz * float3(-0.75, -0.75, -0.75) + float3(0.25, 0.25, 0.25);
                tmp7.xyz = tmp7.xyz - tmp6.xyz;
                tmp1.yzw = tmp1.zzz * tmp7.xyz + tmp6.xyz;
                tmp6.xyz = tmp1.yzw - float3(0.5, 0.5, 0.5);
                tmp6.xyz = -tmp6.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp7.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp5.xyz = tmp1.yzw * tmp5.xyz;
                tmp1.yzw = tmp1.yzw > float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp5.xyz + tmp5.xyz;
                tmp6.xyz = -tmp6.xyz * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp1.yzw = saturate(tmp1.yzw ? tmp6.xyz : tmp5.xyz);
                tmp3.w = tmp2.x + tmp0.y;
                tmp2.x = saturate(tmp2.x * -1.332 + 0.333);
                tmp2.x = tmp0.y * 0.5 + tmp2.x;
                tmp3.w = tmp3.w * 0.5;
                tmp1.yzw = tmp3.www * _SpecularColor.xyz + tmp1.yzw;
                tmp4.zw = tmp2.zz * unity_MatrixV._m01_m11;
                tmp4.zw = unity_MatrixV._m00_m10 * tmp2.yy + tmp4.zw;
                tmp4.zw = unity_MatrixV._m02_m12 * tmp2.ww + tmp4.zw;
                tmp4.zw = tmp4.zw * float2(0.5, 0.5) + float2(0.5, 0.5);
                tmp4.zw = tmp4.zw * _GlossSphere_ST.xy + _GlossSphere_ST.zw;
                tmp5 = tex2D(_GlossSphere, tmp4.zw);
                tmp1.yzw = tmp5.xyz * float3(0.5, 0.5, 0.5) + tmp1.yzw;
                tmp1.yzw = float3(1.0, 1.0, 1.0) - tmp1.yzw;
                tmp3.w = tmp1.x + tmp1.x;
                tmp1.x = tmp1.x * -2.0;
                tmp5 = tmp1.xxxx * tmp4.xyxy + inp.texcoord.xyxz;
                tmp4.xy = tmp3.ww * tmp4.xy + inp.texcoord.zy;
                tmp4.xy = tmp4.xy * _Noise_ST.xy + _Noise_ST.zw;
                tmp4 = tex2D(_Noise, tmp4.xy);
                tmp5 = tmp5 * _Noise_ST + _Noise_ST;
                tmp6 = tex2D(_Noise, tmp5.xy);
                tmp5 = tex2D(_Noise, tmp5.zw);
                tmp1.x = tmp4.x - tmp6.x;
                tmp1.x = tmp3.x * tmp1.x + tmp6.x;
                tmp3.x = tmp5.x - tmp1.x;
                tmp1.x = tmp3.y * tmp3.x + tmp1.x;
                tmp3.x = tmp6.x - tmp1.x;
                tmp1.x = tmp3.z * tmp3.x + tmp1.x;
                tmp1.x = _Time.y * _PrismaticSpeed + tmp1.x;
                tmp3.x = tmp1.x * _Rainbow_ST.x;
                tmp3.y = 0.0;
                tmp3.xy = tmp3.xy + _Rainbow_ST.zw;
                tmp3 = tex2D(_Rainbow, tmp3.xy);
                tmp4.xyz = tmp3.wxy - _RainbowOverride.xyz;
                tmp4.xyz = _RainbowOverride.www * tmp4.xyz + _RainbowOverride.xyz;
                tmp4.xyz = max(tmp4.xyz, tmp4.xyz);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp1.x = tmp2.x - 0.5;
                tmp1.x = -tmp1.x * 2.0 + 1.0;
                tmp5.xyz = -tmp1.xxx * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp1.x = tmp2.x + tmp2.x;
                tmp2.x = tmp2.x > 0.5;
                tmp4.xyz = tmp4.xyz * tmp1.xxx;
                tmp4.xyz = saturate(tmp2.xxx ? tmp5.xyz : tmp4.xyz);
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp1.xyz = saturate(-tmp4.xyz * tmp1.yzw + float3(1.0, 1.0, 1.0));
                tmp4.xy = tmp3.yx;
                tmp5.xy = tmp3.xy - tmp4.xy;
                tmp1.w = tmp4.y >= tmp3.y;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp4.zw = float2(-1.0, 0.6666667);
                tmp5.zw = float2(1.0, -1.0);
                tmp4 = tmp1.wwww * tmp5 + tmp4;
                tmp1.w = tmp3.w >= tmp4.x;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp3.xyz = tmp4.xyw;
                tmp4.xyw = tmp3.wyx;
                tmp4 = tmp4 - tmp3;
                tmp3 = tmp1.wwww * tmp4 + tmp3;
                tmp1.w = min(tmp3.y, tmp3.w);
                tmp1.w = tmp3.x - tmp1.w;
                tmp2.x = tmp1.w * 6.0 + 0.0;
                tmp3.y = tmp3.w - tmp3.y;
                tmp2.x = tmp3.y / tmp2.x;
                tmp2.x = tmp2.x + tmp3.z;
                tmp3.yzw = abs(tmp2.xxx) + float3(0.5, 0.1666667, 0.8333334);
                tmp3.yzw = frac(tmp3.yzw);
                tmp3.yzw = -tmp3.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.yzw = saturate(abs(tmp3.yzw) * float3(3.0, 3.0, 3.0) + float3(-1.0, -1.0, -1.0));
                tmp3.yzw = tmp3.yzw - float3(1.0, 1.0, 1.0);
                tmp2.x = tmp3.x + 0.0;
                tmp1.w = tmp1.w / tmp2.x;
                tmp3.yzw = tmp1.www * tmp3.yzw + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp3.xxx * tmp3.yzw;
                tmp4.xyz = tmp2.yzw * _g.xxx;
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp5.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp6.xyz = _WorldSpaceLightPos0.xyz * tmp1.www + tmp0.xzw;
                tmp4.xyz = max(tmp4.xyz, tmp5.xyz);
                tmp1.w = dot(tmp2.xyz, tmp5.xyz);
                tmp1.w = max(tmp1.w, 0.0);
                tmp0.x = dot(tmp0.xyz, -tmp4.xyz);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.xzw = tmp3.xyz * tmp0.xxx;
                tmp0.xzw = tmp0.xzw * _Thickness.xxx;
                tmp2.x = dot(tmp6.xyz, tmp6.xyz);
                tmp2.x = rsqrt(tmp2.x);
                tmp3.xyz = tmp2.xxx * tmp6.xyz;
                tmp2.x = dot(tmp3.xyz, tmp2.xyz);
                tmp2.x = max(tmp2.x, 0.0);
                tmp2.x = log(tmp2.x);
                tmp2.y = _Shininess * 128.0;
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.x = exp(tmp2.x);
                tmp2.yzw = _LightColor0.xyz * _SpecularColor.xyz;
                tmp2.xyz = tmp2.xxx * tmp2.yzw;
                tmp2.w = min(tmp0.y, 0.1);
                tmp0.y = 1.0 - tmp0.y;
                tmp3.xyz = tmp2.www * _Color.xyz;
                tmp3.xyz = tmp3.xyz * _LightColor0.xyz;
                tmp2.xyz = tmp3.xyz * tmp1.www + tmp2.xyz;
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp0.xzw = tmp3.xyz * tmp0.xzw + tmp2.xyz;
                o.sv_target.xyz = tmp0.yyy * tmp0.xzw + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 97571
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
				float3 texcoord3 : TEXCOORD3;
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
			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;
			float4 _Normal_ST;
			float _g;
			float _Thickness;
			float4 _Rainbow_ST;
			float4 _Noise_ST;
			float _PrismaticSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LightTexture0;
			sampler2D _Normal;
			sampler2D _Noise;
			sampler2D _Rainbow;
			
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
                o.texcoord = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord1.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord2.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord3.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp6;
                tmp0.x = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.yzw = tmp0.xxx * inp.texcoord1.xyz;
                tmp1.x = inp.texcoord1.x * tmp0.x + -tmp0.w;
                tmp1.yzw = abs(tmp0.yzw) * abs(tmp0.yzw);
                tmp0.y = tmp1.y * tmp1.x + tmp0.w;
                tmp0.z = inp.texcoord1.y * tmp0.x + -tmp0.y;
                tmp0.y = tmp1.z * tmp0.z + tmp0.y;
                tmp0.z = inp.texcoord1.z * tmp0.x + -tmp0.y;
                tmp0.y = tmp1.w * tmp0.z + tmp0.y;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.xzw = inp.texcoord1.xyz * tmp0.xxx + float3(0.0, 0.0, 1.0);
                tmp1.x = tmp0.y + tmp0.y;
                tmp0.y = tmp0.y * -2.0;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp2.w = dot(tmp2.xyz, tmp2.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp2.xzw = tmp2.www * tmp2.xyz;
                tmp3.x = dot(inp.texcoord2.xyz, tmp2.xyz);
                tmp3.y = dot(inp.texcoord3.xyz, tmp2.xyz);
                tmp3.zw = tmp1.xx * tmp3.xy + inp.texcoord.zy;
                tmp4 = tmp0.yyyy * tmp3.xyxy + inp.texcoord.xyxz;
                tmp4 = tmp4 * _Noise_ST + _Noise_ST;
                tmp3.xy = tmp3.zw * _Noise_ST.xy + _Noise_ST.zw;
                tmp3 = tex2D(_Noise, tmp3.xy);
                tmp5 = tex2D(_Noise, tmp4.xy);
                tmp4 = tex2D(_Noise, tmp4.zw);
                tmp0.y = tmp3.x - tmp5.x;
                tmp0.y = tmp1.y * tmp0.y + tmp5.x;
                tmp1.x = tmp4.x - tmp0.y;
                tmp0.y = tmp1.z * tmp1.x + tmp0.y;
                tmp1.x = tmp5.x - tmp0.y;
                tmp0.y = tmp1.w * tmp1.x + tmp0.y;
                tmp0.y = _Time.y * _PrismaticSpeed + tmp0.y;
                tmp3.x = tmp0.y * _Rainbow_ST.x;
                tmp3.y = 0.0;
                tmp3.xy = tmp3.xy + _Rainbow_ST.zw;
                tmp3 = tex2D(_Rainbow, tmp3.xy);
                tmp0.y = tmp3.x >= tmp3.y;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp4.xy = tmp3.yx;
                tmp5.xy = tmp3.xy - tmp4.xy;
                tmp4.zw = float2(-1.0, 0.6666667);
                tmp5.zw = float2(1.0, -1.0);
                tmp4 = tmp0.yyyy * tmp5 + tmp4;
                tmp0.y = tmp3.w >= tmp4.x;
                tmp0.y = tmp0.y ? 1.0 : 0.0;
                tmp3.xyz = tmp4.xyw;
                tmp4.xyw = tmp3.wyx;
                tmp4 = tmp4 - tmp3;
                tmp3 = tmp0.yyyy * tmp4 + tmp3;
                tmp0.y = min(tmp3.y, tmp3.w);
                tmp0.y = tmp3.x - tmp0.y;
                tmp1.x = tmp0.y * 6.0 + 0.0;
                tmp3.y = tmp3.w - tmp3.y;
                tmp1.x = tmp3.y / tmp1.x;
                tmp1.x = tmp1.x + tmp3.z;
                tmp3.yzw = abs(tmp1.xxx) + float3(0.5, 0.1666667, 0.8333334);
                tmp3.yzw = frac(tmp3.yzw);
                tmp3.yzw = -tmp3.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.yzw = saturate(abs(tmp3.yzw) * float3(3.0, 3.0, 3.0) + float3(-1.0, -1.0, -1.0));
                tmp3.yzw = tmp3.yzw - float3(1.0, 1.0, 1.0);
                tmp1.x = tmp3.x + 0.0;
                tmp0.y = tmp0.y / tmp1.x;
                tmp3.yzw = tmp0.yyy * tmp3.yzw + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp3.xxx * tmp3.yzw;
                tmp4.xy = inp.texcoord.xz * _Normal_ST.xy + _Normal_ST.zw;
                tmp4 = tex2D(_Normal, tmp4.xy);
                tmp4.x = tmp4.w * tmp4.x;
                tmp4.xy = tmp4.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.y = dot(tmp4.xy, tmp4.xy);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp4.z = sqrt(tmp0.y);
                tmp5 = inp.texcoord.xyzy * _Normal_ST + _Normal_ST;
                tmp6 = tex2D(_Normal, tmp5.zw);
                tmp5 = tex2D(_Normal, tmp5.xy);
                tmp6.x = tmp6.w * tmp6.x;
                tmp6.xy = tmp6.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.y = dot(tmp6.xy, tmp6.xy);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp6.z = sqrt(tmp0.y);
                tmp5.x = tmp5.w * tmp5.x;
                tmp5.xy = tmp5.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.y = dot(tmp5.xy, tmp5.xy);
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.y = 1.0 - tmp0.y;
                tmp5.z = sqrt(tmp0.y);
                tmp6.xyz = tmp6.xyz - tmp5.xyz;
                tmp6.xyz = tmp1.yyy * tmp6.xyz + tmp5.xyz;
                tmp4.xyz = tmp4.xyz - tmp6.xyz;
                tmp1.xyz = tmp1.zzz * tmp4.xyz + tmp6.xyz;
                tmp4.xyz = tmp5.xyz - tmp1.xyz;
                tmp1.xyz = tmp1.www * tmp4.xyz + tmp1.xyz;
                tmp4.xyz = tmp1.xyz * float3(-1.0, -1.0, 1.0);
                tmp0.y = dot(tmp0.xyz, tmp4.xyz);
                tmp0.xyz = tmp0.yyy * tmp0.xzw;
                tmp0.xyz = tmp0.xyz / tmp0.www;
                tmp0.xyz = -tmp1.xyz * float3(-1.0, -1.0, 1.0) + tmp0.xyz;
                tmp1.xyz = tmp0.xyz * _g.xxx;
                tmp4.xyz = _WorldSpaceLightPos0.www * -inp.texcoord.xyz + _WorldSpaceLightPos0.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp5.xyz = tmp0.www * tmp4.xyz;
                tmp4.xyz = tmp4.xyz * tmp0.www + tmp2.xzw;
                tmp1.xyz = max(tmp1.xyz, tmp5.xyz);
                tmp0.w = dot(tmp0.xyz, tmp5.xyz);
                tmp1.x = dot(tmp2.xyz, -tmp1.xyz);
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.y = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp5 = tex2D(_LightTexture0, tmp1.yy);
                tmp1.y = tmp5.x + tmp5.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.xzw = tmp3.xyz * tmp1.xxx;
                tmp1.xzw = tmp1.xzw * _Thickness.xxx;
                tmp2.x = inp.texcoord.y - _WorldSpaceCameraPos.y;
                tmp2.xy = saturate(tmp2.xy * float2(0.025, 0.0125));
                tmp2.x = tmp2.y * 0.75 + tmp2.x;
                tmp2.y = min(tmp2.x, 0.1);
                tmp2.x = 1.0 - tmp2.x;
                tmp2.yzw = tmp2.yyy * _Color.xyz;
                tmp2.yzw = tmp2.yzw * _LightColor0.xyz;
                tmp1.xzw = tmp1.xzw * tmp2.yzw;
                tmp3.x = dot(tmp4.xyz, tmp4.xyz);
                tmp3.x = rsqrt(tmp3.x);
                tmp3.xyz = tmp3.xxx * tmp4.xyz;
                tmp0.x = dot(tmp3.xyz, tmp0.xyz);
                tmp0.xw = max(tmp0.xw, float2(0.0, 0.0));
                tmp0.x = log(tmp0.x);
                tmp0.y = _Shininess * 128.0;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = exp(tmp0.x);
                tmp3.xyz = _LightColor0.xyz * _SpecularColor.xyz;
                tmp0.xyz = tmp0.xxx * tmp3.xyz;
                tmp0.xyz = tmp2.yzw * tmp0.www + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * tmp1.yyy + tmp1.xzw;
                o.sv_target.xyz = tmp0.xyz * tmp2.xxx;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}