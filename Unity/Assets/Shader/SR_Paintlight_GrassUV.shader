Shader "SR/Paintlight/GrassUV" {
	Properties {
		_SwayStrength ("Sway Strength", Range(0, 2)) = 1
		[MaterialToggle] _VertexColorMask ("Vertex Color Mask", Float) = 0
		_EmissiveColor ("Emissive Color", Color) = (0,0,0,0)
		_DisperseSizeSpeed ("Disperse Size/Speed", Vector) = (1,1,0,2)
		[MaterialToggle] _DisableNoise ("Disable Noise", Float) = 1.544346
		[MaterialToggle] _DisableNearCamClip ("Disable NearCamClip", Float) = 1
		_MainTex ("MainTex", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_RampOffset ("Ramp Offset", Float) = 2
		_RampScale ("Ramp Scale", Float) = 1
		_RampUpper ("RampUpper", Color) = (0.5,0.5,0.5,1)
		_SeaLevelRampOffset ("SeaLevelRamp Offset", Float) = -3
		_SeaLevelRampScale ("SeaLevelRamp Scale", Float) = 1
		_SeaLevelRampLower ("SeaLevelRampLower", Color) = (0.5,0.5,0.5,1)
		_TopRampOffset ("TopRamp Offset", Float) = 30
		_TopRampScale ("TopRamp Scale", Float) = 1
		_RampTop ("RampTop", Color) = (0.5,0.5,0.5,1)
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		LOD 550
		Tags { "PreviewType" = "Plane" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			LOD 550
			Tags { "LIGHTMODE" = "FORWARDBASE" "PreviewType" = "Plane" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			GpuProgramID 20972
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
			float _SwayStrength;
			float _VertexColorMask;
			float4 _DisperseSizeSpeed;
			float _DisableNoise;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _EmissiveColor;
			float _DisableNearCamClip;
			float4 _MainTex_ST;
			float4 _Color;
			float _RampOffset;
			float _RampScale;
			float4 _RampUpper;
			float _SeaLevelRampOffset;
			float _SeaLevelRampScale;
			float4 _SeaLevelRampLower;
			float _TopRampOffset;
			float _TopRampScale;
			float4 _RampTop;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = _DisperseSizeSpeed.zw * _Time.yy;
                tmp1.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m21_m11;
                tmp1.xyz = unity_ObjectToWorld._m00_m20_m10 * v.vertex.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m22_m12 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m23_m13 * v.vertex.www + tmp1.xyz;
                tmp0.xy = tmp1.xy * _DisperseSizeSpeed.xy + tmp0.xy;
                tmp0.zw = floor(tmp0.xy);
                tmp0.xy = frac(tmp0.xy);
                tmp2.xy = tmp0.zw + float2(1.2127, 1.2127);
                tmp3 = tmp0.zwzw + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp1.w = tmp3.w * tmp3.z;
                tmp2.xy = tmp1.ww * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.yz = tmp2.xy * float2(489.123, 489.123);
                tmp1.w = tmp2.x + 1.0;
                tmp2.xy = sin(tmp2.yz);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp2.x = tmp2.y * tmp2.x;
                tmp1.w = tmp1.w * tmp2.x;
                tmp1.w = frac(tmp1.w);
                tmp2 = tmp0.zwzw + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp2.z = tmp2.w * tmp2.z;
                tmp2.zw = tmp2.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp3.xy = tmp2.zw * float2(489.123, 489.123);
                tmp2.z = tmp2.z + 1.0;
                tmp3.xy = sin(tmp3.xy);
                tmp3.xy = tmp3.xy * float2(4.789, 4.789);
                tmp2.w = tmp3.y * tmp3.x;
                tmp2.z = tmp2.z * tmp2.w;
                tmp2.z = frac(tmp2.z);
                tmp1.w = tmp1.w - tmp2.z;
                tmp3.xy = -tmp0.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.xy = tmp3.xy * tmp0.xy;
                tmp1.w = tmp0.x * tmp1.w + tmp2.z;
                tmp3 = tmp0.zwzw + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.zw = tmp0.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp2.z = tmp3.w * tmp3.z;
                tmp2.xy = tmp2.zz * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.yz = tmp2.xy * float2(489.123, 489.123);
                tmp2.x = tmp2.x + 1.0;
                tmp2.yz = sin(tmp2.yz);
                tmp2.yz = tmp2.yz * float2(4.789, 4.789);
                tmp2.y = tmp2.z * tmp2.y;
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.x = frac(tmp2.x);
                tmp2.yz = tmp0.zw * float2(489.123, 489.123);
                tmp0.z = tmp0.z + 1.0;
                tmp2.yz = sin(tmp2.yz);
                tmp2.yz = tmp2.yz * float2(4.789, 4.789);
                tmp0.w = tmp2.z * tmp2.y;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = frac(tmp0.z);
                tmp0.w = tmp2.x - tmp0.z;
                tmp0.x = tmp0.x * tmp0.w + tmp0.z;
                tmp0.z = tmp1.w - tmp0.x;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * 3.5 + -0.5;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.x = _DisableNoise * tmp0.y + tmp0.x;
                tmp0.y = tmp1.z + tmp1.x;
                tmp0.y = tmp1.y + tmp0.y;
                tmp0.y = tmp0.y * 0.3333333 + _Time.z;
                tmp0.y = tmp0.y * 0.5305164;
                tmp0.z = sin(tmp0.y);
                tmp0.y = -tmp0.z * 0.5 + tmp0.y;
                tmp0.y = sin(tmp0.y);
                tmp0.y = tmp0.y * 3.333333;
                tmp1.xyz = unity_WorldToObject._m01_m11_m21 * float3(0.1, 0.1, 0.1) + unity_WorldToObject._m00_m10_m20;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + tmp1.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.w = v.color.x - v.texcoord.y;
                tmp0.w = _VertexColorMask * tmp0.w + v.texcoord.y;
                tmp1.x = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.w = dot(tmp0.xy, float2(_SwayStrength.x, _VertexColorMask.x));
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * float3(0.03, 0.03, 0.03);
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
                tmp0.xyz = tmp0.www * tmp0.xyz;
                o.texcoord2.xyz = tmp0.xyz;
                tmp1.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp1.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * tmp1.xyz;
                o.texcoord3.xyz = tmp1.xyz;
                tmp2.xyz = tmp0.zxy * tmp1.yzx;
                tmp0.xyz = tmp0.yzx * tmp1.zxy + -tmp2.xyz;
                tmp0.xyz = tmp0.xyz * v.tangent.www;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord4.xyz = tmp0.www * tmp0.xyz;
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
                tmp0.xyz = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.y = tmp0.y * _RampScale;
                tmp0.y = tmp0.y * 0.1 + -_RampOffset;
                tmp0.y = saturate(tmp0.y * 0.5 + 0.5);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.z = tmp0.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.w = 1.0 - inp.texcoord.y;
                tmp0.z = -tmp0.z * tmp0.w + 1.0;
                tmp0.w = tmp0.x + tmp0.x;
                tmp0.x = tmp0.x > 0.5;
                tmp0.w = tmp0.w * inp.texcoord.y;
                tmp0.x = saturate(tmp0.x ? tmp0.z : tmp0.w);
                tmp0.z = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * inp.texcoord2.xyz;
                tmp2.xyz = inp.texcoord4.xyz * unity_WorldToObject._m11_m11_m11;
                tmp2.xyz = unity_WorldToObject._m01_m01_m01 * inp.texcoord3.xyz + tmp2.xyz;
                tmp1.xyz = unity_WorldToObject._m21_m21_m21 * tmp1.xyz + tmp2.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.yxz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(tmp1.xyz, tmp2.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp0.z = log(tmp0.z);
                tmp0.z = tmp0.z * 0.175;
                tmp0.z = exp(tmp0.z);
                tmp0.w = tmp0.x * tmp0.z;
                tmp0.x = -tmp0.z * tmp0.x + 1.0;
                tmp0.x = _DisableNearCamClip * tmp0.x + tmp0.w;
                tmp0.zw = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp0.zw);
                tmp3 = tmp3.wxyz * _Color;
                tmp0.x = tmp0.x * tmp3.x + -0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = dot(-tmp2.xyz, tmp1.xyz);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.xzw = tmp1.yxz * -tmp0.xxx + -tmp2.xyz;
                tmp1.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp2.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * 2.5 + -0.5;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = min(tmp0.x, 0.3);
                tmp1.x = saturate(tmp1.x);
                tmp0.z = dot(abs(tmp1.xy), float2(0.333, 0.333));
                tmp0.z = tmp1.x + tmp0.z;
                tmp1.xyz = tmp0.zzz * tmp0.zzz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp1.xyz = tmp1.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp1.xyz = max(tmp1.xyz, float3(0.75, 0.75, 0.75));
                tmp1.xyz = min(tmp1.xyz, float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xxx + tmp1.xyz;
                tmp1.xyz = tmp0.xzw * _LightColor0.xyz;
                tmp0.xzw = _LightColor0.xyz * tmp0.xzw + float3(-0.5, -0.5, -0.5);
                tmp0.xzw = -tmp0.xzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp1.xyz > float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp1.xyz + tmp1.xyz;
                tmp4.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp0.yyy * tmp4.xyz;
                tmp4.xyz = tmp0.yyy * tmp4.xyz + float3(0.5, 0.5, 0.5);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.y = inp.texcoord1.y - _SeaLevelRampOffset;
                tmp0.y = tmp0.y * _SeaLevelRampScale;
                tmp0.y = saturate(tmp0.y * 0.2 + 0.5);
                tmp6.xyz = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp6.xyz = tmp0.yyy * tmp6.xyz + _SeaLevelRampLower.xyz;
                tmp7.xyz = float3(1.0, 1.0, 1.0) - tmp6.xyz;
                tmp5.xyz = -tmp5.xyz * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp6.xyz = tmp6.xyz * tmp7.xyz;
                tmp4.xyz = saturate(tmp4.xyz ? tmp5.xyz : tmp6.xyz);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp6.xy = _DisperseSizeSpeed.zw * _Time.yy;
                tmp6.xy = inp.texcoord1.xz * _DisperseSizeSpeed.xy + tmp6.xy;
                tmp6.zw = floor(tmp6.xy);
                tmp6.xy = frac(tmp6.xy);
                tmp7 = tmp6.zwzw + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp0.y = tmp7.w * tmp7.z;
                tmp7.zw = tmp6.zw + float2(1.2127, 1.2127);
                tmp7.zw = tmp0.yy * float2(0.3713, 0.3713) + tmp7.zw;
                tmp8.xy = tmp7.zw * float2(489.123, 489.123);
                tmp0.y = tmp7.z + 1.0;
                tmp7.zw = sin(tmp8.xy);
                tmp7.zw = tmp7.zw * float2(4.789, 4.789);
                tmp1.w = tmp7.w * tmp7.z;
                tmp0.y = tmp0.y * tmp1.w;
                tmp0.y = frac(tmp0.y);
                tmp8 = tmp6.zwzw + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp1.w = tmp8.w * tmp8.z;
                tmp7.xy = tmp1.ww * float2(0.3713, 0.3713) + tmp7.xy;
                tmp7.yz = tmp7.xy * float2(489.123, 489.123);
                tmp1.w = tmp7.x + 1.0;
                tmp7.xy = sin(tmp7.yz);
                tmp7.xy = tmp7.xy * float2(4.789, 4.789);
                tmp2.w = tmp7.y * tmp7.x;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = frac(tmp1.w);
                tmp0.y = tmp0.y - tmp1.w;
                tmp7.xy = -tmp6.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp6.xy = tmp6.xy * tmp6.xy;
                tmp6.xy = tmp7.xy * tmp6.xy;
                tmp0.y = tmp6.x * tmp0.y + tmp1.w;
                tmp7 = tmp6.zwzw + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp1.w = tmp6.w * tmp6.z;
                tmp6.zw = tmp1.ww * float2(0.3713, 0.3713) + tmp7.xy;
                tmp1.w = tmp7.w * tmp7.z;
                tmp7.xy = tmp1.ww * float2(0.3713, 0.3713) + tmp8.xy;
                tmp7.yz = tmp7.xy * float2(489.123, 489.123);
                tmp1.w = tmp7.x + 1.0;
                tmp7.xy = sin(tmp7.yz);
                tmp7.xy = tmp7.xy * float2(4.789, 4.789);
                tmp2.w = tmp7.y * tmp7.x;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = frac(tmp1.w);
                tmp7.xy = tmp6.zw * float2(489.123, 489.123);
                tmp2.w = tmp6.z + 1.0;
                tmp6.zw = sin(tmp7.xy);
                tmp6.zw = tmp6.zw * float2(4.789, 4.789);
                tmp3.x = tmp6.w * tmp6.z;
                tmp2.w = tmp2.w * tmp3.x;
                tmp2.w = frac(tmp2.w);
                tmp1.w = tmp1.w - tmp2.w;
                tmp1.w = tmp6.x * tmp1.w + tmp2.w;
                tmp0.y = tmp0.y - tmp1.w;
                tmp0.y = tmp6.y * tmp0.y + tmp1.w;
                tmp0.y = tmp0.y * 3.5 + -0.5;
                tmp1.w = 1.0 - tmp0.y;
                tmp0.y = _DisableNoise * tmp1.w + tmp0.y;
                tmp0.y = tmp0.y * 1.428571 + 0.7142857;
                tmp1.w = _EmissiveColor.w * 10.0;
                tmp0.y = tmp0.y * tmp1.w;
                tmp6.xyz = tmp0.yyy * _EmissiveColor.xyz;
                tmp0.y = inp.texcoord1.x + _Time.y;
                tmp0.y = tmp0.y + inp.texcoord1.y;
                tmp0.y = tmp0.y + inp.texcoord1.z;
                tmp0.y = sin(tmp0.y);
                tmp0.y = tmp0.y * 0.875 + 1.125;
                tmp6.xyz = tmp0.yyy * tmp6.xyz;
                tmp0.y = inp.texcoord.y * inp.color.x;
                tmp3.xyz = tmp6.xyz * tmp0.yyy + tmp3.yzw;
                tmp6.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.y = -_TopRampScale * 0.5 + _TopRampOffset;
                tmp1.w = _TopRampScale * 0.5 + _TopRampOffset;
                tmp0.y = tmp0.y - tmp1.w;
                tmp1.w = inp.texcoord1.y - tmp1.w;
                tmp0.y = saturate(tmp1.w / tmp0.y);
                tmp8.xyz = _RampTop.xyz - float3(0.5, 0.5, 0.5);
                tmp8.xyz = _RampTop.www * tmp8.xyz + float3(0.5, 0.5, 0.5);
                tmp9.xyz = float3(0.5, 0.5, 0.5) - tmp8.xyz;
                tmp8.xyz = tmp0.yyy * tmp9.xyz + tmp8.xyz;
                tmp9.xyz = float3(1.0, 1.0, 1.0) - tmp8.xyz;
                tmp3.xyz = tmp3.xyz * tmp8.xyz;
                tmp7.xyz = -tmp7.xyz * tmp9.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = saturate(tmp6.xyz ? tmp7.xyz : tmp3.xyz);
                tmp6.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp6.xyz = -tmp6.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp6.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp3.xyz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz * tmp6.xyz;
                tmp3.xyz = saturate(tmp3.xyz ? tmp5.xyz : tmp4.xyz);
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp0.xyz = -tmp0.xzw * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp1.xyz * tmp3.xyz;
                tmp0.xyz = saturate(tmp2.xyz ? tmp0.xyz : tmp1.xyz);
                tmp1.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = saturate(tmp3.xyz * tmp1.xyz);
                o.sv_target.xyz = tmp0.xyz + tmp1.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "FORWARD_DELTA"
			LOD 550
			Tags { "LIGHTMODE" = "FORWARDADD" "PreviewType" = "Plane" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One One, One One
			GpuProgramID 93534
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
				float3 texcoord5 : TEXCOORD5;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4x4 unity_WorldToLight;
			float _SwayStrength;
			float _VertexColorMask;
			float4 _DisperseSizeSpeed;
			float _DisableNoise;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _EmissiveColor;
			float _DisableNearCamClip;
			float4 _MainTex_ST;
			float4 _Color;
			float _RampOffset;
			float _RampScale;
			float4 _RampUpper;
			float _SeaLevelRampOffset;
			float _SeaLevelRampScale;
			float4 _SeaLevelRampLower;
			float _TopRampOffset;
			float _TopRampScale;
			float4 _RampTop;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _LightTexture0;
			
			// Keywords: POINT
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = _DisperseSizeSpeed.zw * _Time.yy;
                tmp1.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m21_m11;
                tmp1.xyz = unity_ObjectToWorld._m00_m20_m10 * v.vertex.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m22_m12 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m23_m13 * v.vertex.www + tmp1.xyz;
                tmp0.xy = tmp1.xy * _DisperseSizeSpeed.xy + tmp0.xy;
                tmp0.zw = floor(tmp0.xy);
                tmp0.xy = frac(tmp0.xy);
                tmp2.xy = tmp0.zw + float2(1.2127, 1.2127);
                tmp3 = tmp0.zwzw + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp1.w = tmp3.w * tmp3.z;
                tmp2.xy = tmp1.ww * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.yz = tmp2.xy * float2(489.123, 489.123);
                tmp1.w = tmp2.x + 1.0;
                tmp2.xy = sin(tmp2.yz);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp2.x = tmp2.y * tmp2.x;
                tmp1.w = tmp1.w * tmp2.x;
                tmp1.w = frac(tmp1.w);
                tmp2 = tmp0.zwzw + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp2.z = tmp2.w * tmp2.z;
                tmp2.zw = tmp2.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp3.xy = tmp2.zw * float2(489.123, 489.123);
                tmp2.z = tmp2.z + 1.0;
                tmp3.xy = sin(tmp3.xy);
                tmp3.xy = tmp3.xy * float2(4.789, 4.789);
                tmp2.w = tmp3.y * tmp3.x;
                tmp2.z = tmp2.z * tmp2.w;
                tmp2.z = frac(tmp2.z);
                tmp1.w = tmp1.w - tmp2.z;
                tmp3.xy = -tmp0.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.xy = tmp3.xy * tmp0.xy;
                tmp1.w = tmp0.x * tmp1.w + tmp2.z;
                tmp3 = tmp0.zwzw + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.zw = tmp0.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp2.z = tmp3.w * tmp3.z;
                tmp2.xy = tmp2.zz * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.yz = tmp2.xy * float2(489.123, 489.123);
                tmp2.x = tmp2.x + 1.0;
                tmp2.yz = sin(tmp2.yz);
                tmp2.yz = tmp2.yz * float2(4.789, 4.789);
                tmp2.y = tmp2.z * tmp2.y;
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.x = frac(tmp2.x);
                tmp2.yz = tmp0.zw * float2(489.123, 489.123);
                tmp0.z = tmp0.z + 1.0;
                tmp2.yz = sin(tmp2.yz);
                tmp2.yz = tmp2.yz * float2(4.789, 4.789);
                tmp0.w = tmp2.z * tmp2.y;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = frac(tmp0.z);
                tmp0.w = tmp2.x - tmp0.z;
                tmp0.x = tmp0.x * tmp0.w + tmp0.z;
                tmp0.z = tmp1.w - tmp0.x;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * 3.5 + -0.5;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.x = _DisableNoise * tmp0.y + tmp0.x;
                tmp0.y = tmp1.z + tmp1.x;
                tmp0.y = tmp1.y + tmp0.y;
                tmp0.y = tmp0.y * 0.3333333 + _Time.z;
                tmp0.y = tmp0.y * 0.5305164;
                tmp0.z = sin(tmp0.y);
                tmp0.y = -tmp0.z * 0.5 + tmp0.y;
                tmp0.y = sin(tmp0.y);
                tmp0.y = tmp0.y * 3.333333;
                tmp1.xyz = unity_WorldToObject._m01_m11_m21 * float3(0.1, 0.1, 0.1) + unity_WorldToObject._m00_m10_m20;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + tmp1.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.w = v.color.x - v.texcoord.y;
                tmp0.w = _VertexColorMask * tmp0.w + v.texcoord.y;
                tmp1.x = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.w = dot(tmp0.xy, float2(_SwayStrength.x, _VertexColorMask.x));
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * float3(0.03, 0.03, 0.03);
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
                tmp1.xyz = tmp1.www * tmp1.xyz;
                o.texcoord2.xyz = tmp1.xyz;
                tmp2.xyz = v.tangent.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp2.xyz = unity_ObjectToWorld._m00_m10_m20 * v.tangent.xxx + tmp2.xyz;
                tmp2.xyz = unity_ObjectToWorld._m02_m12_m22 * v.tangent.zzz + tmp2.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                o.texcoord3.xyz = tmp2.xyz;
                tmp3.xyz = tmp1.zxy * tmp2.yzx;
                tmp1.xyz = tmp1.yzx * tmp2.zxy + -tmp3.xyz;
                tmp1.xyz = tmp1.xyz * v.tangent.www;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord4.xyz = tmp1.www * tmp1.xyz;
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
                float4 tmp9;
                tmp0.xyz = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.y = tmp0.y * _RampScale;
                tmp0.y = tmp0.y * 0.1 + -_RampOffset;
                tmp0.y = saturate(tmp0.y * 0.5 + 0.5);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 0.5;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.z = tmp0.x - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.w = 1.0 - inp.texcoord.y;
                tmp0.z = -tmp0.z * tmp0.w + 1.0;
                tmp0.w = tmp0.x + tmp0.x;
                tmp0.x = tmp0.x > 0.5;
                tmp0.w = tmp0.w * inp.texcoord.y;
                tmp0.x = saturate(tmp0.x ? tmp0.z : tmp0.w);
                tmp0.z = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * inp.texcoord2.xyz;
                tmp2.xyz = inp.texcoord4.xyz * unity_WorldToObject._m11_m11_m11;
                tmp2.xyz = unity_WorldToObject._m01_m01_m01 * inp.texcoord3.xyz + tmp2.xyz;
                tmp1.xyz = unity_WorldToObject._m21_m21_m21 * tmp1.xyz + tmp2.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.yxz;
                tmp2.xyz = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.z = dot(tmp2.xyz, tmp2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp2.xyz;
                tmp0.z = dot(tmp1.xyz, tmp2.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp0.z = log(tmp0.z);
                tmp0.z = tmp0.z * 0.175;
                tmp0.z = exp(tmp0.z);
                tmp0.w = tmp0.x * tmp0.z;
                tmp0.x = -tmp0.z * tmp0.x + 1.0;
                tmp0.x = _DisableNearCamClip * tmp0.x + tmp0.w;
                tmp0.zw = inp.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp3 = tex2D(_MainTex, tmp0.zw);
                tmp3 = tmp3.wxyz * _Color;
                tmp0.x = tmp0.x * tmp3.x + -0.5;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.x = dot(-tmp2.xyz, tmp1.xyz);
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.xzw = tmp1.yxz * -tmp0.xxx + -tmp2.xyz;
                tmp2.xyz = _WorldSpaceLightPos0.www * -inp.texcoord1.xyz + _WorldSpaceLightPos0.xyz;
                tmp1.w = dot(tmp2.xyz, tmp2.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp2.xyz = tmp1.www * tmp2.xyz;
                tmp0.x = dot(tmp2.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * 2.5 + -0.5;
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = min(tmp0.x, 0.3);
                tmp1.x = saturate(tmp1.x);
                tmp0.z = dot(abs(tmp1.xy), float2(0.333, 0.333));
                tmp0.z = tmp1.x + tmp0.z;
                tmp1.xyz = tmp0.zzz * tmp0.zzz + glstate_lightmodel_ambient.xyz;
                tmp1.xyz = tmp1.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp1.xyz = tmp1.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp1.xyz = max(tmp1.xyz, float3(0.75, 0.75, 0.75));
                tmp1.xyz = min(tmp1.xyz, float3(1.0, 1.0, 1.0));
                tmp0.xzw = tmp0.xxx + tmp1.xyz;
                tmp1.x = dot(inp.texcoord5.xyz, inp.texcoord5.xyz);
                tmp1 = tex2D(_LightTexture0, tmp1.xx);
                tmp1.xyz = tmp1.xxx * _LightColor0.xyz;
                tmp2.xyz = tmp0.xzw * tmp1.xyz;
                tmp0.xzw = tmp1.xyz * tmp0.xzw + float3(-0.5, -0.5, -0.5);
                tmp0.xzw = -tmp0.xzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp1.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz + tmp2.xyz;
                tmp4.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp0.yyy * tmp4.xyz;
                tmp4.xyz = tmp0.yyy * tmp4.xyz + float3(0.5, 0.5, 0.5);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.y = inp.texcoord1.y - _SeaLevelRampOffset;
                tmp0.y = tmp0.y * _SeaLevelRampScale;
                tmp0.y = saturate(tmp0.y * 0.2 + 0.5);
                tmp6.xyz = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp6.xyz = tmp0.yyy * tmp6.xyz + _SeaLevelRampLower.xyz;
                tmp7.xyz = float3(1.0, 1.0, 1.0) - tmp6.xyz;
                tmp5.xyz = -tmp5.xyz * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp7.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp6.xyz = tmp6.xyz * tmp7.xyz;
                tmp4.xyz = saturate(tmp4.xyz ? tmp5.xyz : tmp6.xyz);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp6.xy = _DisperseSizeSpeed.zw * _Time.yy;
                tmp6.xy = inp.texcoord1.xz * _DisperseSizeSpeed.xy + tmp6.xy;
                tmp6.zw = floor(tmp6.xy);
                tmp6.xy = frac(tmp6.xy);
                tmp7 = tmp6.zwzw + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp0.y = tmp7.w * tmp7.z;
                tmp7.zw = tmp6.zw + float2(1.2127, 1.2127);
                tmp7.zw = tmp0.yy * float2(0.3713, 0.3713) + tmp7.zw;
                tmp8.xy = tmp7.zw * float2(489.123, 489.123);
                tmp0.y = tmp7.z + 1.0;
                tmp7.zw = sin(tmp8.xy);
                tmp7.zw = tmp7.zw * float2(4.789, 4.789);
                tmp1.w = tmp7.w * tmp7.z;
                tmp0.y = tmp0.y * tmp1.w;
                tmp0.y = frac(tmp0.y);
                tmp8 = tmp6.zwzw + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp1.w = tmp8.w * tmp8.z;
                tmp7.xy = tmp1.ww * float2(0.3713, 0.3713) + tmp7.xy;
                tmp7.yz = tmp7.xy * float2(489.123, 489.123);
                tmp1.w = tmp7.x + 1.0;
                tmp7.xy = sin(tmp7.yz);
                tmp7.xy = tmp7.xy * float2(4.789, 4.789);
                tmp2.w = tmp7.y * tmp7.x;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = frac(tmp1.w);
                tmp0.y = tmp0.y - tmp1.w;
                tmp7.xy = -tmp6.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp6.xy = tmp6.xy * tmp6.xy;
                tmp6.xy = tmp7.xy * tmp6.xy;
                tmp0.y = tmp6.x * tmp0.y + tmp1.w;
                tmp7 = tmp6.zwzw + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp1.w = tmp6.w * tmp6.z;
                tmp6.zw = tmp1.ww * float2(0.3713, 0.3713) + tmp7.xy;
                tmp1.w = tmp7.w * tmp7.z;
                tmp7.xy = tmp1.ww * float2(0.3713, 0.3713) + tmp8.xy;
                tmp7.yz = tmp7.xy * float2(489.123, 489.123);
                tmp1.w = tmp7.x + 1.0;
                tmp7.xy = sin(tmp7.yz);
                tmp7.xy = tmp7.xy * float2(4.789, 4.789);
                tmp2.w = tmp7.y * tmp7.x;
                tmp1.w = tmp1.w * tmp2.w;
                tmp1.w = frac(tmp1.w);
                tmp7.xy = tmp6.zw * float2(489.123, 489.123);
                tmp2.w = tmp6.z + 1.0;
                tmp6.zw = sin(tmp7.xy);
                tmp6.zw = tmp6.zw * float2(4.789, 4.789);
                tmp3.x = tmp6.w * tmp6.z;
                tmp2.w = tmp2.w * tmp3.x;
                tmp2.w = frac(tmp2.w);
                tmp1.w = tmp1.w - tmp2.w;
                tmp1.w = tmp6.x * tmp1.w + tmp2.w;
                tmp0.y = tmp0.y - tmp1.w;
                tmp0.y = tmp6.y * tmp0.y + tmp1.w;
                tmp0.y = tmp0.y * 3.5 + -0.5;
                tmp1.w = 1.0 - tmp0.y;
                tmp0.y = _DisableNoise * tmp1.w + tmp0.y;
                tmp0.y = tmp0.y * 1.428571 + 0.7142857;
                tmp1.w = _EmissiveColor.w * 10.0;
                tmp0.y = tmp0.y * tmp1.w;
                tmp6.xyz = tmp0.yyy * _EmissiveColor.xyz;
                tmp0.y = inp.texcoord1.x + _Time.y;
                tmp0.y = tmp0.y + inp.texcoord1.y;
                tmp0.y = tmp0.y + inp.texcoord1.z;
                tmp0.y = sin(tmp0.y);
                tmp0.y = tmp0.y * 0.875 + 1.125;
                tmp6.xyz = tmp0.yyy * tmp6.xyz;
                tmp0.y = inp.texcoord.y * inp.color.x;
                tmp3.xyz = tmp6.xyz * tmp0.yyy + tmp3.yzw;
                tmp6.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp3.xyz = tmp3.xyz + tmp3.xyz;
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.y = -_TopRampScale * 0.5 + _TopRampOffset;
                tmp1.w = _TopRampScale * 0.5 + _TopRampOffset;
                tmp0.y = tmp0.y - tmp1.w;
                tmp1.w = inp.texcoord1.y - tmp1.w;
                tmp0.y = saturate(tmp1.w / tmp0.y);
                tmp8.xyz = _RampTop.xyz - float3(0.5, 0.5, 0.5);
                tmp8.xyz = _RampTop.www * tmp8.xyz + float3(0.5, 0.5, 0.5);
                tmp9.xyz = float3(0.5, 0.5, 0.5) - tmp8.xyz;
                tmp8.xyz = tmp0.yyy * tmp9.xyz + tmp8.xyz;
                tmp9.xyz = float3(1.0, 1.0, 1.0) - tmp8.xyz;
                tmp3.xyz = tmp3.xyz * tmp8.xyz;
                tmp7.xyz = -tmp7.xyz * tmp9.xyz + float3(1.0, 1.0, 1.0);
                tmp3.xyz = saturate(tmp6.xyz ? tmp7.xyz : tmp3.xyz);
                tmp6.xyz = tmp3.xyz - float3(0.5, 0.5, 0.5);
                tmp6.xyz = -tmp6.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp6.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp6.xyz = tmp3.xyz + tmp3.xyz;
                tmp3.xyz = tmp3.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz * tmp6.xyz;
                tmp3.xyz = saturate(tmp3.xyz ? tmp5.xyz : tmp4.xyz);
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp0.xyz = -tmp0.xzw * tmp4.xyz + float3(1.0, 1.0, 1.0);
                o.sv_target.xyz = saturate(tmp1.xyz ? tmp0.xyz : tmp2.xyz);
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			LOD 550
			Tags { "LIGHTMODE" = "SHADOWCASTER" "PreviewType" = "Plane" "QUEUE" = "AlphaTest" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 164169
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
			float _SwayStrength;
			float _VertexColorMask;
			float4 _DisperseSizeSpeed;
			float _DisableNoise;
			// $Globals ConstantBuffers for Fragment Shader
			float _DisableNearCamClip;
			float4 _MainTex_ST;
			float4 _Color;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.xy = _DisperseSizeSpeed.zw * _Time.yy;
                tmp1.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m21_m11;
                tmp1.xyz = unity_ObjectToWorld._m00_m20_m10 * v.vertex.xxx + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m02_m22_m12 * v.vertex.zzz + tmp1.xyz;
                tmp1.xyz = unity_ObjectToWorld._m03_m23_m13 * v.vertex.www + tmp1.xyz;
                tmp0.xy = tmp1.xy * _DisperseSizeSpeed.xy + tmp0.xy;
                tmp0.zw = floor(tmp0.xy);
                tmp0.xy = frac(tmp0.xy);
                tmp2.xy = tmp0.zw + float2(1.2127, 1.2127);
                tmp3 = tmp0.zwzw + float4(0.2127, 1.2127, 1.0, 1.0);
                tmp1.w = tmp3.w * tmp3.z;
                tmp2.xy = tmp1.ww * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.yz = tmp2.xy * float2(489.123, 489.123);
                tmp1.w = tmp2.x + 1.0;
                tmp2.xy = sin(tmp2.yz);
                tmp2.xy = tmp2.xy * float2(4.789, 4.789);
                tmp2.x = tmp2.y * tmp2.x;
                tmp1.w = tmp1.w * tmp2.x;
                tmp1.w = frac(tmp1.w);
                tmp2 = tmp0.zwzw + float4(1.2127, 0.2127, 0.0, 1.0);
                tmp2.z = tmp2.w * tmp2.z;
                tmp2.zw = tmp2.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp3.xy = tmp2.zw * float2(489.123, 489.123);
                tmp2.z = tmp2.z + 1.0;
                tmp3.xy = sin(tmp3.xy);
                tmp3.xy = tmp3.xy * float2(4.789, 4.789);
                tmp2.w = tmp3.y * tmp3.x;
                tmp2.z = tmp2.z * tmp2.w;
                tmp2.z = frac(tmp2.z);
                tmp1.w = tmp1.w - tmp2.z;
                tmp3.xy = -tmp0.xy * float2(2.0, 2.0) + float2(3.0, 3.0);
                tmp0.xy = tmp0.xy * tmp0.xy;
                tmp0.xy = tmp3.xy * tmp0.xy;
                tmp1.w = tmp0.x * tmp1.w + tmp2.z;
                tmp3 = tmp0.zwzw + float4(0.2127, 0.2127, 1.0, 0.0);
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.zw = tmp0.zz * float2(0.3713, 0.3713) + tmp3.xy;
                tmp2.z = tmp3.w * tmp3.z;
                tmp2.xy = tmp2.zz * float2(0.3713, 0.3713) + tmp2.xy;
                tmp2.yz = tmp2.xy * float2(489.123, 489.123);
                tmp2.x = tmp2.x + 1.0;
                tmp2.yz = sin(tmp2.yz);
                tmp2.yz = tmp2.yz * float2(4.789, 4.789);
                tmp2.y = tmp2.z * tmp2.y;
                tmp2.x = tmp2.x * tmp2.y;
                tmp2.x = frac(tmp2.x);
                tmp2.yz = tmp0.zw * float2(489.123, 489.123);
                tmp0.z = tmp0.z + 1.0;
                tmp2.yz = sin(tmp2.yz);
                tmp2.yz = tmp2.yz * float2(4.789, 4.789);
                tmp0.w = tmp2.z * tmp2.y;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = frac(tmp0.z);
                tmp0.w = tmp2.x - tmp0.z;
                tmp0.x = tmp0.x * tmp0.w + tmp0.z;
                tmp0.z = tmp1.w - tmp0.x;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.x = tmp0.x * 3.5 + -0.5;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.x = _DisableNoise * tmp0.y + tmp0.x;
                tmp0.y = tmp1.z + tmp1.x;
                tmp0.y = tmp1.y + tmp0.y;
                tmp0.y = tmp0.y * 0.3333333 + _Time.z;
                tmp0.y = tmp0.y * 0.5305164;
                tmp0.z = sin(tmp0.y);
                tmp0.y = -tmp0.z * 0.5 + tmp0.y;
                tmp0.y = sin(tmp0.y);
                tmp0.y = tmp0.y * 3.333333;
                tmp1.xyz = unity_WorldToObject._m01_m11_m21 * float3(0.1, 0.1, 0.1) + unity_WorldToObject._m00_m10_m20;
                tmp1.xyz = unity_WorldToObject._m02_m12_m22 * float3(0.5, 0.5, 0.5) + tmp1.xyz;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.yzw = tmp0.yyy * tmp1.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw;
                tmp0.w = v.color.x - v.texcoord.y;
                tmp0.w = _VertexColorMask * tmp0.w + v.texcoord.y;
                tmp1.x = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.w = dot(tmp0.xy, float2(_SwayStrength.x, _VertexColorMask.x));
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp0.xyz = tmp0.xyz * float3(0.03, 0.03, 0.03);
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
                tmp0.xyz = _WorldSpaceCameraPos - inp.texcoord2.xyz;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.w = dot(inp.texcoord3.xyz, inp.texcoord3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.xyz = tmp0.www * inp.texcoord3.xyz;
                tmp0.x = dot(tmp1.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = 1.0 - tmp0.x;
                tmp0.x = log(tmp0.x);
                tmp0.x = tmp0.x * 0.175;
                tmp0.x = exp(tmp0.x);
                tmp0.yzw = inp.texcoord2.xyz - _WorldSpaceCameraPos;
                tmp0.y = dot(tmp0.xyz, tmp0.xyz);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y * 0.5;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.z = tmp0.y - 0.5;
                tmp0.z = -tmp0.z * 2.0 + 1.0;
                tmp0.w = 1.0 - inp.texcoord1.y;
                tmp0.z = -tmp0.z * tmp0.w + 1.0;
                tmp0.w = tmp0.y > 0.5;
                tmp0.y = dot(inp.texcoord1.xy, tmp0.xy);
                tmp0.y = saturate(tmp0.w ? tmp0.z : tmp0.y);
                tmp0.z = tmp0.y * tmp0.x;
                tmp0.x = -tmp0.x * tmp0.y + 1.0;
                tmp0.x = _DisableNearCamClip * tmp0.x + tmp0.z;
                tmp0.yz = inp.texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                tmp1 = tex2D(_MainTex, tmp0.yz);
                tmp0.y = tmp1.w * _Color.w;
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
	Fallback "SR/Paintlight/GrassUV Low"
	CustomEditor "ShaderForgeMaterialInspector"
}