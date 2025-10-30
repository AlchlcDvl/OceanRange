Shader "SR/Paintlight/Leaves Plane Phase" {
	Properties {
		_PrimaryTex ("PrimaryTex", 2D) = "white" {}
		_Depth ("Depth", 2D) = "white" {}
		[MaterialToggle] _EnableDetailTex ("Enable Detail Tex", Float) = 0
		_DetailTex ("Detail Tex", 2D) = "white" {}
		_DetailNoiseMask ("Detail Noise Mask", 2D) = "white" {}
		_CoreTex ("CoreTex", 2D) = "white" {}
		_WindTurbulance ("Wind Turbulance", Float) = 2
		_WindStrength ("Wind Strength", Float) = 0
		_WindSpeed ("Wind Speed", Float) = 1
		_DisperseSizeSpeed ("Disperse Size/Speed", Vector) = (1,1,0,2)
		[MaterialToggle] _DisableNoise ("Disable Noise", Float) = 1.544346
		_Fade ("Fade", Range(0, 1)) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 23947
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
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _TimeEditor;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			float4 _CoreTex_ST;
			float _WindTurbulance;
			float _WindStrength;
			float _WindSpeed;
			float4 _DisperseSizeSpeed;
			float _DisableNoise;
			float _Fade;
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
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp0;
                o.position = tmp0;
                o.texcoord3 = tmp0;
                o.texcoord.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.x = inp.texcoord3.y / inp.texcoord3.w;
                tmp0.y = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.x = tmp0.x * _ScreenParams.y;
                tmp0.x = tmp0.x * 0.25;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 4.0;
                tmp0.x = floor(tmp0.x);
                tmp0.x = tmp0.x * _Fade;
                tmp0.x = tmp0.x * 0.6666667;
                tmp0.yz = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.yz = tmp0.yy * float2(-1.333333, -1.333333) + float2(1.333333, 0.833333);
                tmp0.w = tmp0.y > 0.5;
                tmp0.yz = tmp0.yz + tmp0.yz;
                tmp1.xy = _TimeEditor.zy + _Time.zy;
                tmp1.yz = tmp1.yy * _DisperseSizeSpeed.zw;
                tmp1.x = tmp1.x * _WindSpeed;
                tmp1.yz = inp.texcoord1.yz * _DisperseSizeSpeed.xy + tmp1.yz;
                tmp2.xy = floor(tmp1.yz);
                tmp3 = tmp2.xyxy + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp1.w = tmp3.w * tmp3.z;
                tmp2.zw = tmp2.xy + float2(1.2127, 1.2127);
                tmp2.zw = tmp1.ww * float2(0.3713, 0.3713) + tmp2.zw;
                tmp3.zw = tmp2.zw * float2(489.123, 489.123);
                tmp1.w = tmp2.z + 1.0;
                tmp2.zw = sin(tmp3.zw);
                tmp2.zw = tmp2.zw * float2(4.789, 4.789);
                tmp2.z = tmp2.w * tmp2.z;
                tmp1.w = tmp1.w * tmp2.z;
                tmp1.yzw = frac(tmp1.yzw);
                tmp4 = tmp2.xyxy + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp2.z = tmp4.w * tmp4.z;
                tmp2.zw = tmp2.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp3.xy = tmp2.zw * float2(489.123, 489.123);
                tmp2.z = tmp2.z + 1.0;
                tmp3.xy = sin(tmp3.xy);
                tmp3.xy = tmp3.xy * float2(4.789, 4.789);
                tmp2.w = tmp3.y * tmp3.x;
                tmp2.z = tmp2.z * tmp2.w;
                tmp2.z = frac(tmp2.z);
                tmp1.w = tmp1.w - tmp2.z;
                tmp3.xy = -tmp1.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp1.yz = tmp1.yz * tmp1.yz;
                tmp1.yz = tmp3.xy * tmp1.yz;
                tmp1.w = tmp1.y * tmp1.w + tmp2.z;
                tmp3 = tmp2.xyxy + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.xy = tmp2.xx * float2(0.3713, 0.3713) + tmp3.xy;
                tmp2.z = tmp3.w * tmp3.z;
                tmp2.zw = tmp2.zz * float2(0.3713, 0.3713) + tmp4.xy;
                tmp3.xy = tmp2.zw * float2(489.123, 489.123);
                tmp2.z = tmp2.z + 1.0;
                tmp3.xy = sin(tmp3.xy);
                tmp3.xy = tmp3.xy * float2(4.789, 4.789);
                tmp2.w = tmp3.y * tmp3.x;
                tmp2.z = tmp2.z * tmp2.w;
                tmp2.yw = tmp2.xy * float2(489.123, 489.123);
                tmp2.x = tmp2.x + 1.0;
                tmp2.yw = sin(tmp2.yw);
                tmp2.yw = tmp2.yw * float2(4.789, 4.789);
                tmp2.y = tmp2.w * tmp2.y;
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.xz = frac(tmp2.xz);
                tmp2.y = tmp2.z - tmp2.x;
                tmp1.y = tmp1.y * tmp2.y + tmp2.x;
                tmp1.w = tmp1.w - tmp1.y;
                tmp1.y = tmp1.z * tmp1.w + tmp1.y;
                tmp1.y = tmp1.y * 3.5 + -0.5;
                tmp1.z = 1.0 - tmp1.y;
                tmp1.y = _DisableNoise * tmp1.z + tmp1.y;
                tmp1.zw = inp.texcoord1.xz * _WindTurbulance.xx;
                tmp1.xz = tmp1.xx * float2(5.0, 5.0) + tmp1.zw;
                tmp1.xz = tmp1.xz * float2(0.1061033, 0.1061033);
                tmp2.xy = sin(tmp1.xz);
                tmp1.xz = -tmp2.xy * float2(0.5, 0.5) + tmp1.xz;
                tmp1.xz = sin(tmp1.xz);
                tmp1.xz = tmp1.xz * _WindStrength.xx;
                tmp1.xz = tmp1.yy * tmp1.xz;
                tmp2.xz = tmp1.xz * float2(0.1, 0.1);
                tmp2.y = 0.0;
                tmp2.xyz = tmp2.xyz + inp.texcoord1.xyz;
                tmp1.xz = tmp2.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp3 = tex2D(_Depth, tmp1.xz);
                tmp2.w = inp.texcoord1.y;
                tmp4 = tmp2.wzzx + float4(-0.5, -0.5, 1.0, 1.0);
                tmp5.x = dot(tmp4.xy, float2(0.0000003, -1.0));
                tmp5.y = dot(tmp4.xy, float2(1.0, 0.0000003));
                tmp1.xz = tmp5.xy + float2(0.5, 0.5);
                tmp2.zw = tmp1.xz * _Depth_ST.xy + _Depth_ST.zw;
                tmp5 = tex2D(_Depth, tmp2.zw);
                tmp2.zw = tmp4.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp6 = tex2D(_Depth, tmp2.zw);
                tmp1.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.yzw = tmp1.www * inp.texcoord2.xyz;
                tmp5.yzw = abs(tmp3.yzw) * abs(tmp3.yzw);
                tmp1.w = tmp6.x * tmp5.z;
                tmp1.w = tmp5.y * tmp5.x + tmp1.w;
                tmp1.w = tmp5.w * tmp3.x + tmp1.w;
                tmp0.yz = tmp1.ww * float2(2.0, 2.0) + tmp0.yz;
                tmp0.y = tmp0.y - 1.0;
                tmp0.y = saturate(tmp0.w ? tmp0.y : tmp0.z);
                tmp0.z = tmp0.y + tmp0.y;
                tmp0.y = tmp0.y * 2.0 + -1.0;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.x = tmp0.z * tmp0.x + -0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.xz = tmp2.xy * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp6 = tex2D(_DetailTex, tmp0.xz);
                tmp0.xz = tmp1.xz * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp7 = tex2D(_DetailTex, tmp0.xz);
                tmp0.xz = tmp4.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp8 = tex2D(_DetailTex, tmp0.xz);
                tmp0.xzw = tmp5.zzz * tmp8.xyz;
                tmp0.xzw = tmp5.yyy * tmp7.xyz + tmp0.xzw;
                tmp0.xzw = tmp5.www * tmp6.xyz + tmp0.xzw;
                tmp2.zw = tmp2.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp2.xy = tmp2.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp6 = tex2D(_DetailNoiseMask, tmp2.xy);
                tmp2 = tex2D(_PrimaryTex, tmp2.zw);
                tmp4.xy = tmp1.xz * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp1.xz = tmp1.xz * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp7 = tex2D(_DetailNoiseMask, tmp1.xz);
                tmp8 = tex2D(_PrimaryTex, tmp4.xy);
                tmp1.xz = tmp4.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp4.xy = tmp4.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp4 = tex2D(_DetailNoiseMask, tmp4.xy);
                tmp2.w = tmp4.x * tmp5.z;
                tmp2.w = tmp5.y * tmp7.x + tmp2.w;
                tmp2.w = tmp5.w * tmp6.x + tmp2.w;
                tmp2.w = saturate(tmp2.w * 3.0 + -1.5);
                tmp4 = tex2D(_PrimaryTex, tmp1.xz);
                tmp4.xyz = tmp4.xyz * tmp5.zzz;
                tmp4.xyz = tmp5.yyy * tmp8.xyz + tmp4.xyz;
                tmp2.xyz = tmp5.www * tmp2.xyz + tmp4.xyz;
                tmp0.xzw = tmp0.xzw - tmp2.xyz;
                tmp0.xzw = tmp0.xzw * tmp2.www;
                tmp0.xzw = _EnableDetailTex.xxx * tmp0.xzw + tmp2.xyz;
                tmp1.xz = inp.texcoord1.xy * _CoreTex_ST.xy + _CoreTex_ST.zw;
                tmp2 = tex2D(_CoreTex, tmp1.xz);
                tmp4 = inp.texcoord1.yzzx * _CoreTex_ST + _CoreTex_ST;
                tmp6 = tex2D(_CoreTex, tmp4.xy);
                tmp4 = tex2D(_CoreTex, tmp4.zw);
                tmp4.xyz = tmp4.xyz * tmp5.zzz;
                tmp4.xyz = tmp5.yyy * tmp6.xyz + tmp4.xyz;
                tmp2.xyz = tmp5.www * tmp2.xyz + tmp4.xyz;
                tmp0.xzw = tmp0.xzw - tmp2.xyz;
                tmp0.xyz = tmp0.yyy * tmp0.xzw + tmp2.xyz;
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp4.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = dot(-tmp4.xyz, tmp3.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp5.xyz = tmp3.yzw * -tmp0.www + -tmp4.xyz;
                tmp0.w = dot(tmp3.xyz, tmp4.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp1.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp4.xyz = tmp1.xxx * _WorldSpaceLightPos0.xyz;
                tmp1.x = dot(tmp4.xyz, tmp5.xyz);
                tmp1.z = dot(tmp4.xyz, tmp3.xyz);
                tmp1.xz = max(tmp1.xz, float2(0.0, 0.0));
                tmp1.x = tmp1.x * tmp1.x;
                tmp2.w = tmp1.x * tmp1.w;
                tmp2.w = tmp2.w * 2.5 + -0.5;
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = min(tmp2.w, 0.3);
                tmp1.x = tmp1.w * tmp1.x + tmp2.w;
                tmp3.xy = tmp1.ww * float2(0.334, 0.334) + float2(0.333, -0.167);
                tmp1.w = dot(tmp0.xy, tmp1.xy);
                tmp0.w = tmp0.w * 0.6 + -0.18;
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.w = floor(tmp1.w);
                tmp2.w = 1.0 - tmp3.x;
                tmp3.z = tmp1.z - 0.5;
                tmp3.z = -tmp3.z * 2.0 + 1.0;
                tmp2.w = -tmp3.z * tmp2.w + 1.0;
                tmp3.z = dot(tmp3.xy, tmp1.xy);
                tmp1.z = tmp1.z > 0.5;
                tmp1.z = saturate(tmp1.z ? tmp2.w : tmp3.z);
                tmp1.z = tmp1.z * 13.0 + -5.0;
                tmp2.w = 1.0 - tmp1.z;
                tmp1.z = tmp1.z + tmp1.w;
                tmp1.y = saturate(tmp1.y * 0.5 + tmp1.z);
                tmp0.w = saturate(tmp0.w * tmp2.w);
                tmp4.xyz = glstate_lightmodel_ambient.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp4.xyz = tmp4.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.75, 0.75, 0.75));
                tmp4.xyz = min(tmp4.xyz, float3(1.0, 1.0, 1.0));
                tmp4.xyz = tmp0.www + tmp4.xyz;
                tmp1.xzw = tmp1.xxx + tmp4.xyz;
                tmp1.xzw = tmp1.xzw * _LightColor0.xyz;
                tmp2.w = -tmp3.y * 2.0 + 1.0;
                tmp3.y = 1.0 - tmp0.w;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp3.x = tmp3.x > 0.5;
                tmp2.w = -tmp2.w * tmp3.y + 1.0;
                tmp0.w = saturate(tmp3.x ? tmp2.w : tmp0.w);
                tmp0.w = tmp1.y + tmp0.w;
                tmp3.xyz = tmp1.xzw * tmp0.www + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp0.www * tmp1.xzw;
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp3.xyz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = tmp0.xyz * tmp1.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp1.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp3.xyz);
                tmp2.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp0.xyz = saturate(tmp0.xyz * tmp2.xyz);
                o.sv_target.xyz = tmp1.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			Tags { "LIGHTMODE" = "FORWARDADD" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 104855
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
				float4 texcoord3 : TEXCOORD3;
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
			float4 _TimeEditor;
			float4 _PrimaryTex_ST;
			float4 _Depth_ST;
			float4 _DetailTex_ST;
			float4 _DetailNoiseMask_ST;
			float _EnableDetailTex;
			float4 _CoreTex_ST;
			float _WindTurbulance;
			float _WindStrength;
			float _WindSpeed;
			float4 _DisperseSizeSpeed;
			float _DisableNoise;
			float _Fade;
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
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord3 = tmp1;
                o.texcoord.xy = v.texcoord.xy;
                o.texcoord1 = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord2.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp7;
                float4 tmp8;
                tmp0.x = inp.texcoord3.y / inp.texcoord3.w;
                tmp0.y = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = tmp0.x * 0.5 + 0.5;
                tmp0.x = tmp0.x * _ScreenParams.y;
                tmp0.x = tmp0.x * 0.25;
                tmp0.x = frac(tmp0.x);
                tmp0.x = tmp0.x * 4.0;
                tmp0.x = floor(tmp0.x);
                tmp0.x = tmp0.x * _Fade;
                tmp0.x = tmp0.x * 0.6666667;
                tmp0.yz = inp.texcoord.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.yz = tmp0.yy * float2(-1.333333, -1.333333) + float2(1.333333, 0.833333);
                tmp0.w = tmp0.y > 0.5;
                tmp0.yz = tmp0.yz + tmp0.yz;
                tmp1.xy = _TimeEditor.zy + _Time.zy;
                tmp1.yz = tmp1.yy * _DisperseSizeSpeed.zw;
                tmp1.x = tmp1.x * _WindSpeed;
                tmp1.yz = inp.texcoord1.yz * _DisperseSizeSpeed.xy + tmp1.yz;
                tmp2.xy = floor(tmp1.yz);
                tmp3 = tmp2.xyxy + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp1.w = tmp3.w * tmp3.z;
                tmp2.zw = tmp2.xy + float2(1.2127, 1.2127);
                tmp2.zw = tmp1.ww * float2(0.3713, 0.3713) + tmp2.zw;
                tmp3.zw = tmp2.zw * float2(489.123, 489.123);
                tmp1.w = tmp2.z + 1.0;
                tmp2.zw = sin(tmp3.zw);
                tmp2.zw = tmp2.zw * float2(4.789, 4.789);
                tmp2.z = tmp2.w * tmp2.z;
                tmp1.w = tmp1.w * tmp2.z;
                tmp1.yzw = frac(tmp1.yzw);
                tmp4 = tmp2.xyxy + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp2.z = tmp4.w * tmp4.z;
                tmp2.zw = tmp2.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp3.xy = tmp2.zw * float2(489.123, 489.123);
                tmp2.z = tmp2.z + 1.0;
                tmp3.xy = sin(tmp3.xy);
                tmp3.xy = tmp3.xy * float2(4.789, 4.789);
                tmp2.w = tmp3.y * tmp3.x;
                tmp2.z = tmp2.z * tmp2.w;
                tmp2.z = frac(tmp2.z);
                tmp1.w = tmp1.w - tmp2.z;
                tmp3.xy = -tmp1.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp1.yz = tmp1.yz * tmp1.yz;
                tmp1.yz = tmp3.xy * tmp1.yz;
                tmp1.w = tmp1.y * tmp1.w + tmp2.z;
                tmp3 = tmp2.xyxy + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp2.x = tmp2.y * tmp2.x;
                tmp2.xy = tmp2.xx * float2(0.3713, 0.3713) + tmp3.xy;
                tmp2.z = tmp3.w * tmp3.z;
                tmp2.zw = tmp2.zz * float2(0.3713, 0.3713) + tmp4.xy;
                tmp3.xy = tmp2.zw * float2(489.123, 489.123);
                tmp2.z = tmp2.z + 1.0;
                tmp3.xy = sin(tmp3.xy);
                tmp3.xy = tmp3.xy * float2(4.789, 4.789);
                tmp2.w = tmp3.y * tmp3.x;
                tmp2.z = tmp2.z * tmp2.w;
                tmp2.yw = tmp2.xy * float2(489.123, 489.123);
                tmp2.x = tmp2.x + 1.0;
                tmp2.yw = sin(tmp2.yw);
                tmp2.yw = tmp2.yw * float2(4.789, 4.789);
                tmp2.y = tmp2.w * tmp2.y;
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.xz = frac(tmp2.xz);
                tmp2.y = tmp2.z - tmp2.x;
                tmp1.y = tmp1.y * tmp2.y + tmp2.x;
                tmp1.w = tmp1.w - tmp1.y;
                tmp1.y = tmp1.z * tmp1.w + tmp1.y;
                tmp1.y = tmp1.y * 3.5 + -0.5;
                tmp1.z = 1.0 - tmp1.y;
                tmp1.y = _DisableNoise * tmp1.z + tmp1.y;
                tmp1.zw = inp.texcoord1.xz * _WindTurbulance.xx;
                tmp1.xz = tmp1.xx * float2(5.0, 5.0) + tmp1.zw;
                tmp1.xz = tmp1.xz * float2(0.1061033, 0.1061033);
                tmp2.xy = sin(tmp1.xz);
                tmp1.xz = -tmp2.xy * float2(0.5, 0.5) + tmp1.xz;
                tmp1.xz = sin(tmp1.xz);
                tmp1.xz = tmp1.xz * _WindStrength.xx;
                tmp1.xz = tmp1.yy * tmp1.xz;
                tmp2.xz = tmp1.xz * float2(0.1, 0.1);
                tmp2.y = 0.0;
                tmp2.xyz = tmp2.xyz + inp.texcoord1.xyz;
                tmp1.xz = tmp2.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp3 = tex2D(_Depth, tmp1.xz);
                tmp2.w = inp.texcoord1.y;
                tmp4 = tmp2.wzzx + float4(-0.5, -0.5, 1.0, 1.0);
                tmp5.x = dot(tmp4.xy, float2(0.0000003, -1.0));
                tmp5.y = dot(tmp4.xy, float2(1.0, 0.0000003));
                tmp1.xz = tmp5.xy + float2(0.5, 0.5);
                tmp2.zw = tmp1.xz * _Depth_ST.xy + _Depth_ST.zw;
                tmp5 = tex2D(_Depth, tmp2.zw);
                tmp2.zw = tmp4.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp6 = tex2D(_Depth, tmp2.zw);
                tmp1.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.yzw = tmp1.www * inp.texcoord2.xyz;
                tmp5.yzw = abs(tmp3.yzw) * abs(tmp3.yzw);
                tmp1.w = tmp6.x * tmp5.z;
                tmp1.w = tmp5.y * tmp5.x + tmp1.w;
                tmp1.w = tmp5.w * tmp3.x + tmp1.w;
                tmp0.yz = tmp1.ww * float2(2.0, 2.0) + tmp0.yz;
                tmp0.y = tmp0.y - 1.0;
                tmp0.y = saturate(tmp0.w ? tmp0.y : tmp0.z);
                tmp0.z = tmp0.y + tmp0.y;
                tmp0.y = tmp0.y * 2.0 + -1.0;
                tmp0.y = max(tmp0.y, 0.0);
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.x = tmp0.z * tmp0.x + -0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.xz = tmp2.xy * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp6 = tex2D(_DetailTex, tmp0.xz);
                tmp0.xz = tmp1.xz * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp7 = tex2D(_DetailTex, tmp0.xz);
                tmp0.xz = tmp4.zw * _DetailTex_ST.xy + _DetailTex_ST.zw;
                tmp8 = tex2D(_DetailTex, tmp0.xz);
                tmp0.xzw = tmp5.zzz * tmp8.xyz;
                tmp0.xzw = tmp5.yyy * tmp7.xyz + tmp0.xzw;
                tmp0.xzw = tmp5.www * tmp6.xyz + tmp0.xzw;
                tmp2.zw = tmp2.xy * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp2.xy = tmp2.xy * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp6 = tex2D(_DetailNoiseMask, tmp2.xy);
                tmp2 = tex2D(_PrimaryTex, tmp2.zw);
                tmp4.xy = tmp1.xz * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp1.xz = tmp1.xz * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp7 = tex2D(_DetailNoiseMask, tmp1.xz);
                tmp8 = tex2D(_PrimaryTex, tmp4.xy);
                tmp1.xz = tmp4.zw * _PrimaryTex_ST.xy + _PrimaryTex_ST.zw;
                tmp4.xy = tmp4.zw * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp4 = tex2D(_DetailNoiseMask, tmp4.xy);
                tmp2.w = tmp4.x * tmp5.z;
                tmp2.w = tmp5.y * tmp7.x + tmp2.w;
                tmp2.w = tmp5.w * tmp6.x + tmp2.w;
                tmp2.w = saturate(tmp2.w * 3.0 + -1.5);
                tmp4 = tex2D(_PrimaryTex, tmp1.xz);
                tmp4.xyz = tmp4.xyz * tmp5.zzz;
                tmp4.xyz = tmp5.yyy * tmp8.xyz + tmp4.xyz;
                tmp2.xyz = tmp5.www * tmp2.xyz + tmp4.xyz;
                tmp0.xzw = tmp0.xzw - tmp2.xyz;
                tmp0.xzw = tmp0.xzw * tmp2.www;
                tmp0.xzw = _EnableDetailTex.xxx * tmp0.xzw + tmp2.xyz;
                tmp1.xz = inp.texcoord1.xy * _CoreTex_ST.xy + _CoreTex_ST.zw;
                tmp2 = tex2D(_CoreTex, tmp1.xz);
                tmp4 = inp.texcoord1.yzzx * _CoreTex_ST + _CoreTex_ST;
                tmp6 = tex2D(_CoreTex, tmp4.xy);
                tmp4 = tex2D(_CoreTex, tmp4.zw);
                tmp4.xyz = tmp4.xyz * tmp5.zzz;
                tmp4.xyz = tmp5.yyy * tmp6.xyz + tmp4.xyz;
                tmp2.xyz = tmp5.www * tmp2.xyz + tmp4.xyz;
                tmp0.xzw = tmp0.xzw - tmp2.xyz;
                tmp0.xyz = tmp0.yyy * tmp0.xzw + tmp2.xyz;
                tmp2.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp4.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp4.xyz, tmp4.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp4.xyz = tmp0.www * tmp4.xyz;
                tmp0.w = dot(-tmp4.xyz, tmp3.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp5.xyz = tmp3.yzw * -tmp0.www + -tmp4.xyz;
                tmp0.w = dot(tmp3.xyz, tmp4.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp4.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp1.x = dot(tmp4.xyz, tmp4.xyz);
                tmp1.x = rsqrt(tmp1.x);
                tmp4.xyz = tmp1.xxx * tmp4.xyz;
                tmp1.x = dot(tmp4.xyz, tmp5.xyz);
                tmp1.z = dot(tmp4.xyz, tmp3.xyz);
                tmp1.xz = max(tmp1.xz, float2(0.0, 0.0));
                tmp1.x = tmp1.x * tmp1.x;
                tmp2.w = tmp1.x * tmp1.w;
                tmp2.w = tmp2.w * 2.5 + -0.5;
                tmp2.w = max(tmp2.w, 0.0);
                tmp2.w = min(tmp2.w, 0.3);
                tmp1.x = tmp1.w * tmp1.x + tmp2.w;
                tmp3.xy = tmp1.ww * float2(0.334, 0.334) + float2(0.333, -0.167);
                tmp1.w = dot(tmp0.xy, tmp1.xy);
                tmp0.w = tmp0.w * 0.6 + -0.18;
                tmp0.w = tmp0.w * 0.5;
                tmp0.w = max(tmp0.w, 0.0);
                tmp1.w = floor(tmp1.w);
                tmp2.w = 1.0 - tmp3.x;
                tmp3.z = tmp1.z - 0.5;
                tmp3.z = -tmp3.z * 2.0 + 1.0;
                tmp2.w = -tmp3.z * tmp2.w + 1.0;
                tmp3.z = dot(tmp3.xy, tmp1.xy);
                tmp1.z = tmp1.z > 0.5;
                tmp1.z = saturate(tmp1.z ? tmp2.w : tmp3.z);
                tmp1.z = tmp1.z * 13.0 + -5.0;
                tmp2.w = 1.0 - tmp1.z;
                tmp1.z = tmp1.z + tmp1.w;
                tmp1.y = saturate(tmp1.y * 0.5 + tmp1.z);
                tmp0.w = saturate(tmp0.w * tmp2.w);
                tmp4.xyz = glstate_lightmodel_ambient.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp4.xyz = tmp4.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp4.xyz = max(tmp4.xyz, float3(0.75, 0.75, 0.75));
                tmp4.xyz = min(tmp4.xyz, float3(1.0, 1.0, 1.0));
                tmp4.xyz = tmp0.www + tmp4.xyz;
                tmp1.xzw = tmp1.xxx + tmp4.xyz;
                tmp2.w = dot(inp.texcoord4.xyz, inp.texcoord4.xyz);
                tmp4 = tex2D(_LightTexture0, tmp2.ww);
                tmp4.xyz = tmp4.xxx * _LightColor0.xyz;
                tmp1.xzw = tmp1.xzw * tmp4.xyz;
                tmp2.w = -tmp3.y * 2.0 + 1.0;
                tmp3.y = 1.0 - tmp0.w;
                tmp0.w = dot(tmp0.xy, tmp3.xy);
                tmp3.x = tmp3.x > 0.5;
                tmp2.w = -tmp2.w * tmp3.y + 1.0;
                tmp0.w = saturate(tmp3.x ? tmp2.w : tmp0.w);
                tmp0.w = tmp1.y + tmp0.w;
                tmp3.xyz = tmp1.xzw * tmp0.www + float3(-0.5, -0.5, -0.5);
                tmp1.xyz = tmp0.www * tmp1.xzw;
                tmp3.xyz = -tmp3.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = -tmp3.xyz * tmp2.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.xyz * tmp1.xyz;
                tmp1.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp0.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.xyz = saturate(tmp1.xyz ? tmp2.xyz : tmp0.xyz);
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 140163
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
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _TimeEditor;
			float4 _Depth_ST;
			float _WindTurbulance;
			float _WindStrength;
			float _WindSpeed;
			float4 _DisperseSizeSpeed;
			float _DisableNoise;
			float _Fade;
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
                tmp1.x = tmp0.z + tmp1.x;
                tmp1.y = min(tmp0.w, tmp1.x);
                tmp1.y = tmp1.y - tmp1.x;
                o.position.z = unity_LightShadowBias.y * tmp1.y + tmp1.x;
                o.position.xyw = tmp0.xyw;
                o.texcoord4 = tmp0;
                o.texcoord1.xy = v.texcoord.xy;
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord3.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.xy = _TimeEditor.zy + _Time.zy;
                tmp0.yz = tmp0.yy * _DisperseSizeSpeed.zw;
                tmp0.x = tmp0.x * _WindSpeed;
                tmp0.yz = inp.texcoord2.yz * _DisperseSizeSpeed.xy + tmp0.yz;
                tmp1.xy = floor(tmp0.yz);
                tmp2 = tmp1.xyxy + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp0.w = tmp2.w * tmp2.z;
                tmp1.zw = tmp1.xy + float2(1.2127, 1.2127);
                tmp1.zw = tmp0.ww * float2(0.3713, 0.3713) + tmp1.zw;
                tmp2.zw = tmp1.zw * float2(489.123, 489.123);
                tmp0.w = tmp1.z + 1.0;
                tmp1.zw = sin(tmp2.zw);
                tmp1.zw = tmp1.zw * float2(4.789, 4.789);
                tmp1.z = tmp1.w * tmp1.z;
                tmp0.w = tmp0.w * tmp1.z;
                tmp0.yzw = frac(tmp0.yzw);
                tmp3 = tmp1.xyxy + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp1.z = tmp3.w * tmp3.z;
                tmp1.zw = tmp1.zz * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.xy = tmp1.zw * float2(489.123, 489.123);
                tmp1.z = tmp1.z + 1.0;
                tmp2.xy = sin(tmp2.xy);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp1.w = tmp2.y * tmp2.x;
                tmp1.z = tmp1.z * tmp1.w;
                tmp1.z = frac(tmp1.z);
                tmp0.w = tmp0.w - tmp1.z;
                tmp2.xy = -tmp0.yz * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.yz = tmp2.xy * tmp0.yz;
                tmp0.w = tmp0.y * tmp0.w + tmp1.z;
                tmp2 = tmp1.xyxy + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp1.x = tmp1.y * tmp1.x;
                tmp1.xy = tmp1.xx * float2(0.3713, 0.3713) + tmp2.xy;
                tmp1.z = tmp2.w * tmp2.z;
                tmp1.zw = tmp1.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp2.xy = tmp1.zw * float2(489.123, 489.123);
                tmp1.z = tmp1.z + 1.0;
                tmp2.xy = sin(tmp2.xy);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp1.w = tmp2.y * tmp2.x;
                tmp1.z = tmp1.z * tmp1.w;
                tmp1.yw = tmp1.xy * float2(489.123, 489.123);
                tmp1.x = tmp1.x + 1.0;
                tmp1.yw = sin(tmp1.yw);
                tmp1.yw = tmp1.yw * float2(4.789, 4.789);
                tmp1.y = tmp1.w * tmp1.y;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.xz = frac(tmp1.xz);
                tmp1.y = tmp1.z - tmp1.x;
                tmp0.y = tmp0.y * tmp1.y + tmp1.x;
                tmp0.w = tmp0.w - tmp0.y;
                tmp0.y = tmp0.z * tmp0.w + tmp0.y;
                tmp0.y = tmp0.y * 3.5 + -0.5;
                tmp0.z = 1.0 - tmp0.y;
                tmp0.y = _DisableNoise * tmp0.z + tmp0.y;
                tmp0.zw = inp.texcoord2.xz * _WindTurbulance.xx;
                tmp0.xz = tmp0.xx * float2(5.0, 5.0) + tmp0.zw;
                tmp0.xz = tmp0.xz * float2(0.1061033, 0.1061033);
                tmp1.xy = sin(tmp0.xz);
                tmp0.xz = -tmp1.xy * float2(0.5, 0.5) + tmp0.xz;
                tmp0.xz = sin(tmp0.xz);
                tmp0.xz = tmp0.xz * _WindStrength.xx;
                tmp0.xy = tmp0.yy * tmp0.xz;
                tmp0.xz = tmp0.xy * float2(0.1, 0.1);
                tmp0.y = 0.0;
                tmp0.xyz = tmp0.xyz + inp.texcoord2.xyz;
                tmp1.xy = tmp0.xy * _Depth_ST.xy + _Depth_ST.zw;
                tmp1 = tex2D(_Depth, tmp1.xy);
                tmp0.w = inp.texcoord2.y;
                tmp0 = tmp0.wzzx + float4(-0.5, -0.5, 1.0, 1.0);
                tmp2.x = dot(tmp0.xy, float2(0.0000003, -1.0));
                tmp2.y = dot(tmp0.xy, float2(1.0, 0.0000003));
                tmp0.xy = tmp0.zw * _Depth_ST.xy + _Depth_ST.zw;
                tmp0 = tex2D(_Depth, tmp0.xy);
                tmp0.yz = tmp2.xy + float2(0.5, 0.5);
                tmp0.yz = tmp0.yz * _Depth_ST.xy + _Depth_ST.zw;
                tmp2 = tex2D(_Depth, tmp0.yz);
                tmp0.y = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp0.yzw = tmp0.yyy * inp.texcoord3.xyz;
                tmp0.yzw = abs(tmp0.yzw) * abs(tmp0.yzw);
                tmp0.x = tmp0.x * tmp0.z;
                tmp0.x = tmp0.y * tmp2.x + tmp0.x;
                tmp0.x = tmp0.w * tmp1.x + tmp0.x;
                tmp0.yz = inp.texcoord1.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                tmp0.yz = tmp0.yz * tmp0.yz;
                tmp0.y = tmp0.z + tmp0.y;
                tmp0.yz = tmp0.yy * float2(-1.333333, -1.333333) + float2(1.333333, 0.833333);
                tmp0.zw = tmp0.yz + tmp0.yz;
                tmp0.y = tmp0.y > 0.5;
                tmp0.xz = tmp0.xx * float2(2.0, 2.0) + tmp0.zw;
                tmp0.x = tmp0.x - 1.0;
                tmp0.x = saturate(tmp0.y ? tmp0.x : tmp0.z);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.y = inp.texcoord4.y / inp.texcoord4.w;
                tmp0.z = _ProjectionParams.x * -_ProjectionParams.x;
                tmp0.y = tmp0.z * tmp0.y;
                tmp0.y = tmp0.y * 0.5 + 0.5;
                tmp0.y = tmp0.y * _ScreenParams.y;
                tmp0.y = tmp0.y * 0.25;
                tmp0.y = frac(tmp0.y);
                tmp0.y = tmp0.y * 4.0;
                tmp0.y = floor(tmp0.y);
                tmp0.y = tmp0.y * _Fade;
                tmp0.y = tmp0.y * 0.6666667;
                tmp0.x = tmp0.x * tmp0.y + -0.5;
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