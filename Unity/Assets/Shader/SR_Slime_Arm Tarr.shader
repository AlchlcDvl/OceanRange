Shader "SR/Slime/Arm Tarr" {
	Properties {
		_BottomColor ("Bottom Color", Color) = (0.1882353,0.1529412,0.1568628,1)
		_MiddleColor ("Middle Color", Color) = (0.2904635,0.2459991,0.3676471,1)
		_TopColor ("Top Color", Color) = (0.4313726,0.3960784,0.4313726,1)
		_Normal ("Normal", 2D) = "bump" {}
		_Depth ("Depth", 2D) = "white" {}
		_Stripes ("Stripes", 2D) = "white" {}
		[MaterialToggle] _StripesInvert ("Stripes Invert", Float) = 0
		_ColorRamp ("Color-Ramp", 2D) = "white" {}
		_Noise ("Noise", Cube) = "_Skybox" {}
		_Alpha ("Alpha", Range(0, 1)) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Cull Off
			GpuProgramID 55354
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
				float3 texcoord3 : TEXCOORD3;
				float3 texcoord4 : TEXCOORD4;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _TimeEditor;
			float4 _Stripes_ST;
			float4 _Depth_ST;
			float _Alpha;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _BottomColor;
			float4 _TopColor;
			float4 _MiddleColor;
			float4 _ColorRamp_ST;
			float4 _Normal_ST;
			float _StripesInvert;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Depth;
			sampler2D _Stripes;
			// Texture params for Fragment Shader
			sampler2D _Normal;
			samplerCUBE _Noise;
			sampler2D _ColorRamp;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                float4 tmp5;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp2.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp2.xyz = tmp2.xyz * v.tangent.www;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp2.xyz;
                tmp0.w = _TimeEditor.y + _Time.y;
                tmp2 = tmp0.wwww * float4(0.05, -0.125, 0.0, 0.2) + v.texcoord.xyxy;
                tmp1.w = 0.0;
                tmp3.x = 0.0;
                while (true) {
                    tmp3.y = i >= 8;
                    if (tmp3.y) {
                        break;
                    }
                    i = i + 1;
                    tmp3.yz = tmp2.xy * tmp3.yy;
                    tmp4.xy = floor(tmp3.yz);
                    tmp3.yz = frac(tmp3.yz);
                    tmp4.zw = tmp3.yz * tmp3.yz;
                    tmp3.yz = -tmp3.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp3.yz = tmp3.yz * tmp4.zw;
                    tmp3.w = tmp4.y * 57.0 + tmp4.x;
                    tmp4.xyz = tmp3.www + float3(1.0, 57.0, 58.0);
                    tmp5.x = sin(tmp3.w);
                    tmp5.yzw = sin(tmp4.xyz);
                    tmp4 = tmp5 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp4 = frac(tmp4);
                    tmp4.yw = tmp4.yw - tmp4.xz;
                    tmp3.yw = tmp3.yy * tmp4.yw + tmp4.xz;
                    tmp3.w = tmp3.w - tmp3.y;
                    tmp3.y = tmp3.z * tmp3.w + tmp3.y;
                    tmp3.z = null.z / 8;
                    tmp1.w = tmp3.y * tmp3.z + tmp1.w;
                }
                tmp1.w = tmp1.w * 0.125;
                tmp2.x = tmp1.w * tmp1.w;
                tmp1.w = tmp1.w * tmp2.x;
                tmp2.xy = float2(1.0, 1.0) - v.texcoord.yx;
                tmp2.xy = tmp2.xy * v.texcoord.yx;
                tmp2.x = tmp2.x * 5.0;
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.x = saturate(tmp2.x * 5.0);
                tmp1.w = tmp1.w * tmp2.x;
                tmp2.xy = tmp1.ww * float2(0.01, 0.01) + tmp2.zw;
                tmp2.xy = tmp2.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp2 = tex2Dlod(_Depth, float4(tmp2.xy, 0, 0.0));
                tmp2.y = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp2.y = tmp2.y + unity_ObjectToWorld._m23;
                tmp2.y = tmp0.w + tmp2.y;
                tmp2.z = tmp2.y > 0.0;
                tmp2.w = tmp2.y < 0.0;
                tmp2.z = tmp2.w - tmp2.z;
                tmp2.z = floor(tmp2.z);
                tmp2.z = tmp2.z + v.texcoord.y;
                tmp3.xy = tmp0.ww * float2(0.0, 0.05) + v.texcoord.xy;
                tmp3.xy = tmp1.ww * float2(0.1, 0.1) + tmp3.xy;
                tmp3.xy = tmp3.xy * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp3 = tex2Dlod(_Stripes, float4(tmp3.xy, 0, 0.0));
                tmp3.yz = tmp2.xx * float2(0.6, 0.6) + float2(0.2, -0.3);
                tmp0.w = tmp3.y > 0.5;
                tmp1.w = -tmp3.z * 2.0 + 1.0;
                tmp2.w = tmp3.x * 0.6 + 0.2;
                tmp3.x = 1.0 - tmp2.w;
                tmp1.w = -tmp1.w * tmp3.x + 1.0;
                tmp2.w = dot(tmp2.xy, tmp3.xy);
                tmp0.w = saturate(tmp0.w ? tmp1.w : tmp2.w);
                tmp1.w = tmp0.w > 0.5;
                tmp2.w = tmp0.w - 0.5;
                tmp2.w = -tmp2.w * 2.0 + 1.0;
                tmp3.x = v.texcoord.y - _Alpha;
                tmp3.x = tmp3.x * -6.0;
                tmp3.y = 1.0 - _Alpha;
                tmp3.x = tmp3.x / tmp3.y;
                tmp3.x = tmp3.x + 1.0;
                tmp3.y = 1.0 - tmp3.x;
                tmp2.w = -tmp2.w * tmp3.y + 1.0;
                tmp0.w = dot(tmp3.xy, tmp0.xy);
                tmp0.w = saturate(tmp1.w ? tmp2.w : tmp0.w);
                tmp3.xyz = tmp2.xxx * v.normal.xyz;
                tmp4.xyz = v.normal.xyz * v.color.xyz;
                tmp1.w = sin(tmp2.y);
                tmp1.w = tmp1.w * 0.125 + 0.125;
                tmp1.w = tmp1.w * 0.15;
                tmp2.xyw = tmp1.www * tmp4.xyz;
                tmp2.xyw = tmp3.xyz * float3(0.025, 0.025, 0.025) + tmp2.xyw;
                tmp1.w = 1.0 - tmp2.z;
                tmp1.w = tmp1.w * tmp2.z;
                tmp1.w = saturate(tmp1.w * 1.428571 + 0.6428571);
                tmp3.xyz = tmp1.www * v.normal.xyz;
                tmp2.xyz = tmp3.xyz * float3(0.0125, 0.0125, 0.0125) + tmp2.xyw;
                tmp2.xyz = tmp2.xyz * tmp0.www + v.vertex.xyz;
                tmp3 = tmp2.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp3 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp2 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp2;
                tmp2 = tmp2 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp3 = tmp2.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp3 = unity_MatrixVP._m00_m10_m20_m30 * tmp2.xxxx + tmp3;
                tmp3 = unity_MatrixVP._m02_m12_m22_m32 * tmp2.zzzz + tmp3;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp2.wwww + tmp3;
                o.color = v.color;
                o.texcoord2.xyz = tmp0.xyz;
                o.texcoord3.xyz = tmp1.xyz;
                o.texcoord.xy = v.texcoord.xy;
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
                tmp0.x = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp0.xyz = tmp0.xxx * inp.texcoord2.xyz;
                tmp1.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp1.w = _TimeEditor.y + _Time.y;
                tmp3 = tmp1.wwww * float4(0.05, -0.125, 0.0, 0.2) + inp.texcoord.xyxy;
                tmp2.w = 0.0;
                tmp4.x = 0.0;
                while (true) {
                    tmp4.y = i >= 8;
                    if (tmp4.y) {
                        break;
                    }
                    i = i + 1;
                    tmp4.yz = tmp3.xy * tmp4.yy;
                    tmp5.xy = floor(tmp4.yz);
                    tmp4.yz = frac(tmp4.yz);
                    tmp5.zw = tmp4.yz * tmp4.yz;
                    tmp4.yz = -tmp4.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp4.yz = tmp4.yz * tmp5.zw;
                    tmp4.w = tmp5.y * 57.0 + tmp5.x;
                    tmp5.xyz = tmp4.www + float3(1.0, 57.0, 58.0);
                    tmp6.x = sin(tmp4.w);
                    tmp6.yzw = sin(tmp5.xyz);
                    tmp5 = tmp6 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp5 = frac(tmp5);
                    tmp5.yw = tmp5.yw - tmp5.xz;
                    tmp4.yw = tmp4.yy * tmp5.yw + tmp5.xz;
                    tmp4.w = tmp4.w - tmp4.y;
                    tmp4.y = tmp4.z * tmp4.w + tmp4.y;
                    tmp4.z = null.z / 8;
                    tmp2.w = tmp4.y * tmp4.z + tmp2.w;
                }
                tmp2.w = tmp2.w * 0.125;
                tmp3.x = tmp2.w * tmp2.w;
                tmp2.w = tmp2.w * tmp3.x;
                tmp3.xy = float2(1.0, 1.0) - inp.texcoord.yx;
                tmp3.xy = tmp3.xy * inp.texcoord.yx;
                tmp4.xy = tmp3.xx * float2(5.0, 4.0);
                tmp3.x = tmp3.y * tmp4.x;
                tmp3.x = saturate(tmp3.x * 5.0);
                tmp2.w = tmp2.w * tmp3.x;
                tmp3.xy = tmp2.ww * float2(0.01, 0.01) + tmp3.zw;
                tmp3.zw = tmp3.xy * _Normal_ST.xy + _Normal_ST.zw;
                tmp5 = tex2D(_Normal, tmp3.zw);
                tmp5.x = tmp5.w * tmp5.x;
                tmp3.zw = tmp5.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp4.x = dot(tmp3.xy, tmp3.xy);
                tmp4.x = min(tmp4.x, 1.0);
                tmp4.x = 1.0 - tmp4.x;
                tmp4.x = sqrt(tmp4.x);
                tmp5.xyz = tmp3.www * inp.texcoord4.xyz;
                tmp5.xyz = tmp3.zzz * inp.texcoord3.xyz + tmp5.xyz;
                tmp4.xzw = tmp4.xxx * tmp0.xyz + tmp5.xyz;
                tmp3.z = dot(tmp4.xyz, tmp4.xyz);
                tmp3.z = rsqrt(tmp3.z);
                tmp4.xzw = tmp3.zzz * tmp4.xzw;
                tmp0.x = dot(tmp2.xyz, tmp0.xyz);
                tmp0.y = tmp0.x > 0.0;
                tmp0.x = tmp0.x < 0.0;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.x = floor(tmp0.x);
                tmp0.xyz = tmp0.xxx * tmp4.xzw;
                tmp3.zw = tmp1.ww * float2(0.0, 0.05) + inp.texcoord.xy;
                tmp3.zw = tmp2.ww * float2(0.1, 0.1) + tmp3.zw;
                tmp3.zw = tmp3.zw * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp5 = tex2D(_Stripes, tmp3.zw);
                tmp3.xy = tmp3.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp3 = tex2D(_Depth, tmp3.xy);
                tmp3.xy = tmp3.xx * float2(0.6, 0.6) + float2(0.2, -0.3);
                tmp2.w = tmp3.x > 0.5;
                tmp3.y = -tmp3.y * 2.0 + 1.0;
                tmp3.z = tmp5.x * 0.6 + 0.2;
                tmp3.w = 1.0 - tmp3.z;
                tmp3.y = -tmp3.y * tmp3.w + 1.0;
                tmp3.x = dot(tmp3.xy, tmp3.xy);
                tmp2.w = saturate(tmp2.w ? tmp3.y : tmp3.x);
                tmp3.x = tmp2.w > 0.5;
                tmp3.y = tmp2.w - 0.5;
                tmp3.y = -tmp3.y * 2.0 + 1.0;
                tmp3.z = inp.texcoord.y - _Alpha;
                tmp3.z = tmp3.z * -6.0;
                tmp3.w = 1.0 - _Alpha;
                tmp3.z = tmp3.z / tmp3.w;
                tmp3.z = tmp3.z + 1.0;
                tmp3.w = 1.0 - tmp3.z;
                tmp3.y = -tmp3.y * tmp3.w + 1.0;
                tmp2.w = dot(tmp3.xy, tmp2.xy);
                tmp2.w = saturate(tmp3.x ? tmp3.y : tmp2.w);
                tmp2.w = tmp2.w - 0.5;
                tmp2.w = tmp2.w < 0.0;
                if (tmp2.w) {
                    discard;
                }
                tmp2.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp2.w = rsqrt(tmp2.w);
                tmp3.xyz = tmp2.www * _WorldSpaceLightPos0.xyz;
                tmp1.xyz = tmp1.xyz * tmp0.www + tmp3.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = dot(tmp0.xyz, tmp2.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp2.xy = float2(1.0, 1.5) - tmp0.ww;
                tmp4.xzw = tmp0.yyy * unity_WorldToObject._m01_m11_m21;
                tmp4.xzw = unity_WorldToObject._m00_m10_m20 * tmp0.xxx + tmp4.xzw;
                tmp4.xzw = unity_WorldToObject._m02_m12_m22 * tmp0.zzz + tmp4.xzw;
                tmp6 = texCUBElod(_Noise, float4(tmp4.xzw, 2.0));
                tmp6.x = tmp1.w * 0.333 + tmp6.x;
                tmp6.y = 0.0;
                tmp2.zw = tmp2.xx + tmp6.xy;
                tmp2.zw = tmp2.zw * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
                tmp6 = tex2D(_ColorRamp, tmp2.zw);
                tmp0.w = dot(tmp6.xyz, float3(0.3, 0.59, 0.11));
                tmp4.xzw = tmp0.www - tmp6.xyz;
                tmp7.xyz = tmp4.xzw * float3(0.5, 0.5, 0.5) + tmp6.xyz;
                tmp8.xyz = _MiddleColor.xyz - tmp7.xyz;
                tmp7.xyz = tmp8.xyz * float3(0.75, 0.75, 0.75) + tmp7.xyz;
                tmp0.w = dot(tmp1.xyz, tmp0.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.xyz = tmp0.www * _LightColor0.xyz;
                tmp1.xyz = tmp7.xyz * tmp1.xyz;
                tmp0.x = dot(tmp0.xyz, tmp3.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.z = saturate(tmp0.y + tmp0.y);
                tmp0.y = saturate(tmp0.y * 0.5 + 0.5);
                tmp0.w = tmp2.x * tmp2.x;
                tmp0.w = min(tmp0.w, 1.0);
                tmp0.y = tmp0.w + tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = saturate(tmp2.y * tmp0.y);
                tmp2.yzw = _MiddleColor.xyz - _BottomColor.xyz;
                tmp2.yzw = tmp0.yyy * tmp2.yzw + _BottomColor.xyz;
                tmp7.xyz = _TopColor.xyz - _MiddleColor.xyz;
                tmp7.xyz = tmp0.yyy * tmp7.xyz + _MiddleColor.xyz;
                tmp0.y = tmp0.y * 2.0 + -1.0;
                tmp0.y = max(tmp0.y, 0.0);
                tmp7.xyz = tmp7.xyz - tmp2.yzw;
                tmp0.yzw = tmp0.yyy * tmp7.xyz + tmp2.yzw;
                tmp2.yzw = tmp0.yzw * float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp0.xxx * _LightColor0.xyz + tmp3.xyz;
                tmp4.xzw = tmp4.xzw * float3(0.25, 0.25, 0.25) + tmp6.xyz;
                tmp6.xy = tmp2.xx * float2(-1.5, -2.0) + float2(1.0, 1.0);
                tmp6.x = saturate(tmp6.x);
                tmp4.xzw = tmp4.xzw * tmp6.xxx;
                tmp0.x = tmp4.y * tmp4.y;
                tmp4.xyz = tmp0.xxx * tmp4.xzw;
                tmp6.xzw = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp6.xzw = tmp6.xzw - tmp5.xyz;
                tmp5.xyz = _StripesInvert.xxx * tmp6.xzw + tmp5.xyz;
                tmp5.xyz = tmp5.xyz * tmp6.yyy + float3(0.05, 0.05, 0.05);
                tmp4.xyz = saturate(tmp4.xyz * tmp5.xyz);
                tmp0.xyz = tmp0.yzw * float3(0.5, 0.5, 0.5) + tmp4.xyz;
                tmp1.xyz = tmp3.xyz * tmp2.yzw + tmp1.xyz;
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 77113
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
			float4 _Stripes_ST;
			float4 _Depth_ST;
			float _Alpha;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Depth;
			sampler2D _Stripes;
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
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
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp1 = tmp0.xxxx * float4(0.05, -0.125, 0.0, 0.2) + v.texcoord.xyxy;
                tmp0.yz = float2(0.0, 0.0);
                while (true) {
                    tmp0.w = i >= 8;
                    if (tmp0.w) {
                        break;
                    }
                    i = i + 1;
                    tmp2.xy = tmp0.ww * tmp1.xy;
                    tmp2.zw = floor(tmp2.xy);
                    tmp2.xy = frac(tmp2.xy);
                    tmp3.xy = tmp2.xy * tmp2.xy;
                    tmp2.xy = -tmp2.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp2.xy = tmp2.xy * tmp3.xy;
                    tmp0.w = tmp2.w * 57.0 + tmp2.z;
                    tmp3.xyz = tmp0.www + float3(1.0, 57.0, 58.0);
                    tmp4.x = sin(tmp0.w);
                    tmp4.yzw = sin(tmp3.xyz);
                    tmp3 = tmp4 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp3 = frac(tmp3);
                    tmp2.zw = tmp3.yw - tmp3.xz;
                    tmp2.xz = tmp2.xx * tmp2.zw + tmp3.xz;
                    tmp0.w = tmp2.z - tmp2.x;
                    tmp0.w = tmp2.y * tmp0.w + tmp2.x;
                    tmp2.x = null.x / 8;
                    tmp0.y = tmp0.w * tmp2.x + tmp0.y;
                }
                tmp0.y = tmp0.y * 0.125;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.zw = float2(1.0, 1.0) - v.texcoord.yx;
                tmp0.zw = tmp0.zw * v.texcoord.yx;
                tmp0.z = tmp0.z * 5.0;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.z = saturate(tmp0.z * 5.0);
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.zw = tmp0.yy * float2(0.01, 0.01) + tmp1.zw;
                tmp0.zw = tmp0.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp1 = tex2Dlod(_Depth, float4(tmp0.zw, 0, 0.0));
                tmp0.z = unity_ObjectToWorld._m13 + unity_ObjectToWorld._m03;
                tmp0.z = tmp0.z + unity_ObjectToWorld._m23;
                tmp0.z = tmp0.z + tmp0.x;
                tmp0.w = tmp0.z > 0.0;
                tmp1.y = tmp0.z < 0.0;
                tmp0.w = tmp1.y - tmp0.w;
                tmp0.w = floor(tmp0.w);
                tmp0.w = tmp0.w + v.texcoord.y;
                tmp1.yz = tmp0.xx * float2(0.0, 0.05) + v.texcoord.xy;
                tmp0.xy = tmp0.yy * float2(0.1, 0.1) + tmp1.yz;
                tmp0.xy = tmp0.xy * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp2 = tex2Dlod(_Stripes, float4(tmp0.xy, 0, 0.0));
                tmp0.xy = tmp1.xx * float2(0.6, 0.6) + float2(0.2, -0.3);
                tmp1.y = tmp0.x > 0.5;
                tmp0.y = -tmp0.y * 2.0 + 1.0;
                tmp1.z = tmp2.x * 0.6 + 0.2;
                tmp1.w = 1.0 - tmp1.z;
                tmp0.y = -tmp0.y * tmp1.w + 1.0;
                tmp0.x = dot(tmp1.xy, tmp0.xy);
                tmp0.x = saturate(tmp1.y ? tmp0.y : tmp0.x);
                tmp0.y = tmp0.x > 0.5;
                tmp1.y = tmp0.x - 0.5;
                tmp1.y = -tmp1.y * 2.0 + 1.0;
                tmp1.z = v.texcoord.y - _Alpha;
                tmp1.z = tmp1.z * -6.0;
                tmp1.w = 1.0 - _Alpha;
                tmp1.z = tmp1.z / tmp1.w;
                tmp1.z = tmp1.z + 1.0;
                tmp1.w = 1.0 - tmp1.z;
                tmp1.y = -tmp1.y * tmp1.w + 1.0;
                tmp0.x = dot(tmp1.xy, tmp0.xy);
                tmp0.x = saturate(tmp0.y ? tmp1.y : tmp0.x);
                tmp1.xyz = tmp1.xxx * v.normal.xyz;
                tmp2.xyz = v.normal.xyz * v.color.xyz;
                tmp0.y = sin(tmp0.z);
                tmp0.y = tmp0.y * 0.125 + 0.125;
                tmp0.y = tmp0.y * 0.15;
                tmp2.xyz = tmp0.yyy * tmp2.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.025, 0.025, 0.025) + tmp2.xyz;
                tmp0.y = 1.0 - tmp0.w;
                tmp0.y = tmp0.y * tmp0.w;
                tmp0.y = saturate(tmp0.y * 1.428571 + 0.6428571);
                tmp0.yzw = tmp0.yyy * v.normal.xyz;
                tmp0.yzw = tmp0.yzw * float3(0.0125, 0.0125, 0.0125) + tmp1.xyz;
                tmp0.xyz = tmp0.yzw * tmp0.xxx + v.vertex.xyz;
                tmp1 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.texcoord2 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                tmp1.x = unity_LightShadowBias.x / tmp0.w;
                tmp1.x = min(tmp1.x, 0.0);
                tmp1.x = max(tmp1.x, -1.0);
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.w, tmp0.z);
                tmp1.x = tmp1.x - tmp0.z;
                o.position.z = unity_LightShadowBias.y * tmp1.x + tmp0.z;
                o.position.xyw = tmp0.xyw;
                o.color = v.color;
                o.texcoord1.xy = v.texcoord.xy;
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
                tmp0.x = _TimeEditor.y + _Time.y;
                tmp1 = tmp0.xxxx * float4(0.05, -0.125, 0.0, 0.05) + inp.texcoord1.xyxy;
                tmp0.yz = float2(0.0, 0.0);
                while (true) {
                    tmp0.w = i >= 8;
                    if (tmp0.w) {
                        break;
                    }
                    i = i + 1;
                    tmp2.xy = tmp0.ww * tmp1.xy;
                    tmp2.zw = floor(tmp2.xy);
                    tmp2.xy = frac(tmp2.xy);
                    tmp3.xy = tmp2.xy * tmp2.xy;
                    tmp2.xy = -tmp2.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                    tmp2.xy = tmp2.xy * tmp3.xy;
                    tmp0.w = tmp2.w * 57.0 + tmp2.z;
                    tmp3.xyz = tmp0.www + float3(1.0, 57.0, 58.0);
                    tmp4.x = sin(tmp0.w);
                    tmp4.yzw = sin(tmp3.xyz);
                    tmp3 = tmp4 * float4(437.5854, 437.5854, 437.5854, 437.5854);
                    tmp3 = frac(tmp3);
                    tmp2.zw = tmp3.yw - tmp3.xz;
                    tmp2.xz = tmp2.xx * tmp2.zw + tmp3.xz;
                    tmp0.w = tmp2.z - tmp2.x;
                    tmp0.w = tmp2.y * tmp0.w + tmp2.x;
                    tmp2.x = null.x / 8;
                    tmp0.y = tmp0.w * tmp2.x + tmp0.y;
                }
                tmp0.y = tmp0.y * 0.125;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.zw = float2(1.0, 1.0) - inp.texcoord1.yx;
                tmp0.zw = tmp0.zw * inp.texcoord1.yx;
                tmp0.z = tmp0.z * 5.0;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.z = saturate(tmp0.z * 5.0);
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.zw = tmp0.yy * float2(0.1, 0.1) + tmp1.zw;
                tmp0.zw = tmp0.zw * _Stripes_ST.xy + _Stripes_ST.zw;
                tmp1 = tex2D(_Stripes, tmp0.zw);
                tmp0.xz = tmp0.xx * float2(0.0, 0.2) + inp.texcoord1.xy;
                tmp0.xy = tmp0.yy * float2(0.01, 0.01) + tmp0.xz;
                tmp0.xy = tmp0.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp0 = tex2D(_Depth, tmp0.xy);
                tmp0.xy = tmp0.xx * float2(0.6, 0.6) + float2(0.2, -0.3);
                tmp0.z = tmp0.x > 0.5;
                tmp0.y = -tmp0.y * 2.0 + 1.0;
                tmp0.w = tmp1.x * 0.6 + 0.2;
                tmp1.x = 1.0 - tmp0.w;
                tmp0.y = -tmp0.y * tmp1.x + 1.0;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.y = tmp0.x > 0.5;
                tmp0.z = tmp0.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.w = inp.texcoord1.y - _Alpha;
                tmp0.w = tmp0.w * -6.0;
                tmp1.x = 1.0 - _Alpha;
                tmp0.w = tmp0.w / tmp1.x;
                tmp0.w = tmp0.w + 1.0;
                tmp1.x = 1.0 - tmp0.w;
                tmp0.z = -tmp0.z * tmp1.x + 1.0;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = saturate(tmp0.y ? tmp0.z : tmp0.x);
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
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}