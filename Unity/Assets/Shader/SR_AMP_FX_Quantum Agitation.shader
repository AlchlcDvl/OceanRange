Shader "SR/AMP/FX/Quantum Agitation" {
	Properties {
		_MainTexture ("Main Texture", 2D) = "black" {}
		[HDR] _SmokeColor ("Smoke Color", Color) = (1,1,1,1)
		[HDR] _BitsColor ("Bits Color", Color) = (1,1,1,1)
		[HDR] _OrbitsColorA ("Orbits Color A", Color) = (1,1,1,1)
		[HDR] _OrbitsColorB ("Orbits Color B", Color) = (1,1,1,1)
		_DepthFade ("Depth Fade", Float) = 0.25
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
		Pass {
			Name "FORWARD"
			Tags { "DisableBatching" = "true" "IGNOREPROJECTOR" = "true" "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent+0" "RenderType" = "Custom" }
			Blend One One, SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			GpuProgramID 15743
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
				float4 texcoord3 : TEXCOORD3;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _OrbitsColorB;
			float4 _OrbitsColorA;
			float4 _SmokeColor;
			float4 _BitsColor;
			float _DepthFade;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTexture;
			sampler2D _CameraDepthTexture;
			
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
                tmp0.x = unity_MatrixV._m00;
                tmp0.y = unity_MatrixV._m01;
                tmp0.z = unity_MatrixV._m02;
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.yxz;
                tmp1.x = tmp0.y;
                tmp2.x = unity_MatrixV._m10;
                tmp2.y = unity_MatrixV._m11;
                tmp2.z = unity_MatrixV._m12;
                tmp0.w = dot(tmp2.xyz, tmp2.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp2.xyz = tmp0.www * tmp2.xzy;
                tmp1.y = tmp2.x;
                tmp3.x = unity_MatrixV._m20;
                tmp3.y = unity_MatrixV._m21;
                tmp3.z = unity_MatrixV._m22;
                tmp0.w = dot(tmp3.xyz, tmp3.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp3.xyz;
                tmp1.z = -tmp3.x;
                tmp0.w = dot(unity_ObjectToWorld._m00_m10_m20, unity_ObjectToWorld._m00_m10_m20);
                tmp0.w = sqrt(tmp0.w);
                tmp4.x = tmp0.w * v.vertex.x;
                tmp0.w = dot(unity_ObjectToWorld._m01_m11_m21, unity_ObjectToWorld._m01_m11_m21);
                tmp0.w = sqrt(tmp0.w);
                tmp4.y = tmp0.w * v.vertex.y;
                tmp0.w = dot(unity_ObjectToWorld._m02_m12_m22, unity_ObjectToWorld._m02_m12_m22);
                tmp0.w = sqrt(tmp0.w);
                tmp4.z = tmp0.w * v.vertex.z;
                tmp5.x = dot(tmp4.xyz, tmp1.xyz);
                tmp1.x = dot(v.normal.xyz, tmp1.xyz);
                tmp2.x = tmp0.z;
                tmp0.y = tmp2.z;
                tmp0.z = -tmp3.y;
                tmp2.z = -tmp3.z;
                tmp5.y = dot(tmp4.xyz, tmp0.xyz);
                tmp1.y = dot(v.normal.xyz, tmp0.xyz);
                tmp5.z = dot(tmp4.xyz, tmp2.xyz);
                tmp1.z = dot(v.normal.xyz, tmp2.xyz);
                tmp0.xyz = tmp5.xyz + unity_ObjectToWorld._m03_m13_m23;
                tmp2 = tmp0.yyyy * unity_WorldToObject._m01_m11_m21_m31;
                tmp2 = unity_WorldToObject._m00_m10_m20_m30 * tmp0.xxxx + tmp2;
                tmp0 = unity_WorldToObject._m02_m12_m22_m32 * tmp0.zzzz + tmp2;
                tmp0 = unity_WorldToObject._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
                tmp2 = tmp0.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp2 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.xxxx + tmp2;
                tmp2 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.zzzz + tmp2;
                o.texcoord2.xyz = unity_ObjectToWorld._m03_m13_m23 * tmp0.www + tmp2.xyz;
                tmp0 = tmp2 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp2 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp2;
                tmp0 = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp2;
                o.position = tmp0;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                tmp1.xyz = tmp1.www * tmp1.xyz;
                tmp2.x = dot(tmp1.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.y = dot(tmp1.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.z = dot(tmp1.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.x = dot(tmp2.xyz, tmp2.xyz);
                tmp1.x = rsqrt(tmp1.x);
                o.texcoord1.xyz = tmp1.xxx * tmp2.xyz;
                tmp0.y = tmp0.y * _ProjectionParams.x;
                tmp1.xzw = tmp0.xwy * float3(0.5, 0.5, 0.5);
                o.texcoord3.zw = tmp0.zw;
                o.texcoord3.xy = tmp1.zz + tmp1.xw;
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
                tmp0 = _Time * float4(7.919, 7.85, 8.21, 3.21);
                tmp1.x = sin(tmp0.z);
                tmp2.x = cos(tmp0.z);
                tmp3.z = tmp1.x;
                tmp3.y = tmp2.x;
                tmp3.x = -tmp1.x;
                tmp1 = inp.texcoord.xyxy * float4(1.2, 1.8, 1.5, 4.27) + float4(-0.6, -0.9, -0.98, -2.19);
                tmp2.x = dot(tmp1.xy, tmp3.xy);
                tmp2.y = dot(tmp1.xy, tmp3.xy);
                tmp1.zw = saturate(tmp2.xy + float2(0.5, 0.5));
                tmp2 = tex2D(_MainTexture, tmp1.zw);
                tmp2.yzw = _Time.yyy * float3(4.0, 8.13, 0.1);
                tmp1.zw = sin(tmp2.yz);
                tmp3.x = sin(tmp2.w);
                tmp4.x = cos(tmp2.w);
                tmp1.zw = tmp1.zw + float2(1.0, 1.0);
                tmp1.zw = tmp1.zw * float2(-0.5, -0.25) + float2(1.0, 0.5);
                tmp0.x = sin(tmp0.x);
                tmp5.x = cos(tmp0.x);
                tmp0.yz = sin(tmp0.yw);
                tmp0.yz = tmp0.yz + float2(1.0, 1.0);
                tmp0.yz = tmp0.yz * float2(-0.25, -0.5) + float2(0.5, 1.0);
                tmp6.z = tmp0.x;
                tmp6.y = tmp5.x;
                tmp6.x = -tmp0.x;
                tmp5 = inp.texcoord.xyxy * float4(3.72, 1.52, 1.6, 1.6) + float4(-1.75, -0.98, -0.8, -0.8);
                tmp7.x = dot(tmp5.xy, tmp6.xy);
                tmp8.x = dot(tmp5.xy, tmp6.xy);
                tmp7.y = dot(tmp5.xy, tmp6.xy);
                tmp8.y = dot(tmp5.xy, tmp6.xy);
                tmp0.xw = saturate(tmp8.xy + float2(0.5, 0.5));
                tmp5 = tex2D(_MainTexture, tmp0.xw);
                tmp0.xw = saturate(tmp7.xy + float2(0.5, 0.5));
                tmp6 = tex2D(_MainTexture, tmp0.xw);
                tmp0.x = tmp1.z * tmp6.x;
                tmp0.x = tmp2.x * tmp0.z + tmp0.x;
                tmp0.x = saturate(tmp5.x * tmp1.w + tmp0.x);
                tmp0.x = tmp0.x * _OrbitsColorA.w;
                tmp2.xyz = tmp0.xxx * _OrbitsColorA.xyz;
                tmp0.z = _Time.y * 7.919 + 0.3;
                tmp5.x = sin(tmp0.z);
                tmp6.x = cos(tmp0.z);
                tmp7.z = tmp5.x;
                tmp7.y = tmp6.x;
                tmp7.x = -tmp5.x;
                tmp5.y = dot(tmp1.xy, tmp7.xy);
                tmp5.x = dot(tmp1.xy, tmp7.xy);
                tmp0.zw = saturate(tmp5.xy + float2(0.5, 0.5));
                tmp1 = tex2D(_MainTexture, tmp0.zw);
                tmp5 = _Time * float4(7.9, 5.5, 8.123, 6.1);
                tmp6.x = sin(tmp5.z);
                tmp7.x = cos(tmp5.z);
                tmp8.z = tmp6.x;
                tmp8.y = tmp7.x;
                tmp8.x = -tmp6.x;
                tmp6 = inp.texcoord.xyxy * float4(1.5, 4.0, 3.39, 1.5) + float4(-0.58, -2.0, -1.72, -0.58);
                tmp7.x = dot(tmp6.xy, tmp8.xy);
                tmp7.y = dot(tmp6.xy, tmp8.xy);
                tmp0.zw = saturate(tmp7.xy + float2(0.5, 0.5));
                tmp7 = tex2D(_MainTexture, tmp0.zw);
                tmp0.zw = sin(tmp5.yw);
                tmp5.x = sin(tmp5.x);
                tmp8.x = cos(tmp5.x);
                tmp0.zw = tmp0.zw + float2(1.0, 1.0);
                tmp0.w = tmp0.w * -0.5 + 1.0;
                tmp0.w = tmp0.w * tmp7.x;
                tmp7.z = tmp5.x;
                tmp7.y = tmp8.x;
                tmp7.x = -tmp5.x;
                tmp5.y = dot(tmp6.xy, tmp7.xy);
                tmp5.x = dot(tmp6.xy, tmp7.xy);
                tmp1.yz = saturate(tmp5.xy + float2(0.5, 0.5));
                tmp5 = tex2D(_MainTexture, tmp1.yz);
                tmp0.z = tmp0.z * tmp5.x;
                tmp0.z = tmp0.z * 0.5 + tmp0.w;
                tmp0.y = saturate(tmp1.x * tmp0.y + tmp0.z);
                tmp0.z = tmp0.y * _OrbitsColorB.w;
                tmp0.x = _OrbitsColorB.w * tmp0.y + tmp0.x;
                tmp0.yzw = _OrbitsColorB.xyz * tmp0.zzz + tmp2.xyz;
                tmp1.x = _Time.y * 2.0 + 0.5;
                tmp1.x = frac(tmp1.x);
                tmp1.x = tmp1.x * -0.8 + 1.0;
                tmp1.yz = inp.texcoord.xy - float2(0.5, 0.5);
                tmp1.xw = tmp1.yz * tmp1.xx;
                tmp2 = _Time * float4(0.21, -0.16, 0.5, -0.76);
                tmp2.x = sin(tmp2.x);
                tmp5.x = cos(tmp2.x);
                tmp6.z = tmp2.x;
                tmp6.y = tmp5.x;
                tmp6.x = -tmp2.x;
                tmp5.y = dot(tmp1.xy, tmp6.xy);
                tmp5.x = dot(tmp1.xy, tmp6.xy);
                tmp1.xw = _Time.yy * float2(0.0, 0.1) + tmp5.xy;
                tmp1.xw = tmp1.xw + float2(0.5, 0.5);
                tmp5 = tex2D(_MainTexture, tmp1.xw);
                tmp1.x = _Time.y + _Time.y;
                tmp1.x = frac(tmp1.x);
                tmp1.w = tmp1.x * -0.7 + 0.8;
                tmp1.x = tmp1.x * 2.0 + -1.0;
                tmp1.x = 1.0 - abs(tmp1.x);
                tmp3.yz = tmp1.ww * tmp1.yz;
                tmp2.x = sin(tmp2.y);
                tmp5.x = cos(tmp2.y);
                tmp6.z = tmp2.x;
                tmp6.y = tmp5.x;
                tmp6.x = -tmp2.x;
                tmp2.y = dot(tmp3.xy, tmp6.xy);
                tmp2.x = dot(tmp3.xy, tmp6.xy);
                tmp2.xy = _Time.yy * float2(0.0, 0.1) + tmp2.xy;
                tmp2.xy = tmp2.xy + float2(0.5, 0.5);
                tmp6 = tex2D(_MainTexture, tmp2.xy);
                tmp1.w = tmp6.w - tmp5.w;
                tmp1.x = tmp1.x * tmp1.w + tmp5.w;
                tmp2.x = sin(tmp2.z);
                tmp5.x = cos(tmp2.z);
                tmp6.x = sin(tmp2.w);
                tmp7.x = cos(tmp2.w);
                tmp8.z = tmp2.x;
                tmp8.y = tmp5.x;
                tmp8.x = -tmp2.x;
                tmp2.y = dot(tmp1.xy, tmp8.xy);
                tmp2.x = dot(tmp1.xy, tmp8.xy);
                tmp2.xy = saturate(tmp2.xy + float2(0.5, 0.5));
                tmp2 = tex2D(_MainTexture, tmp2.xy);
                tmp5.z = tmp6.x;
                tmp5.y = tmp7.x;
                tmp5.x = -tmp6.x;
                tmp2.xy = inp.texcoord.xy * float2(0.75, 0.75) + float2(-0.375, -0.375);
                tmp6.x = dot(tmp2.xy, tmp5.xy);
                tmp6.y = dot(tmp2.xy, tmp5.xy);
                tmp2.xy = saturate(tmp6.xy + float2(0.5, 0.5));
                tmp5 = tex2D(_MainTexture, tmp2.xy);
                tmp2.xy = tmp2.zw * tmp5.zw;
                tmp1.x = tmp1.x * tmp2.x;
                tmp1.w = tmp2.y * 0.3 + -0.05;
                tmp1.yz = tmp1.yz + tmp1.ww;
                tmp1.w = tmp1.x * _SmokeColor.w;
                tmp0.x = _SmokeColor.w * tmp1.x + tmp0.x;
                tmp0.yzw = _SmokeColor.xyz * tmp1.www + tmp0.yzw;
                tmp1.x = _Time.y + 0.5;
                tmp1.x = frac(tmp1.x);
                tmp1.w = rsqrt(tmp1.x);
                tmp1.w = 1.0 / tmp1.w;
                tmp1.w = tmp1.w * -9.99 + 10.0;
                tmp2.xy = tmp1.yz * tmp1.ww;
                tmp5.z = tmp3.x;
                tmp5.y = tmp4.x;
                tmp5.x = -tmp3.x;
                tmp3.y = dot(tmp2.xy, tmp5.xy);
                tmp3.x = dot(tmp2.xy, tmp5.xy);
                tmp2.xy = saturate(tmp3.xy + float2(0.5, 0.5));
                tmp2 = tex2D(_MainTexture, tmp2.xy);
                tmp1.w = frac(_Time.y);
                tmp2.x = rsqrt(tmp1.w);
                tmp2.x = 1.0 / tmp2.x;
                tmp2.x = tmp2.x * -9.99 + 10.0;
                tmp1.yz = tmp1.yz * tmp2.xx;
                tmp2.x = _Time.y * 0.1 + 0.5;
                tmp2.x = sin(tmp2.x);
                tmp3.x = cos(tmp2.x);
                tmp4.z = tmp2.x;
                tmp4.y = tmp3.x;
                tmp4.x = -tmp2.x;
                tmp3.y = dot(tmp1.xy, tmp4.xy);
                tmp3.x = dot(tmp1.xy, tmp4.xy);
                tmp1.yz = saturate(tmp3.xy + float2(0.5, 0.5));
                tmp3 = tex2D(_MainTexture, tmp1.yz);
                tmp1.y = tmp1.w - 0.5;
                tmp1.z = tmp1.w * 10.0;
                tmp1.y = tmp1.y * -2.0 + 1.0;
                tmp1.yz = min(tmp1.yz, float2(1.0, 1.0));
                tmp1.y = tmp1.z * tmp1.y;
                tmp1.y = tmp1.y * tmp3.y;
                tmp1.z = tmp1.x - 0.5;
                tmp1.x = tmp1.x * 10.0;
                tmp1.z = tmp1.z * -2.0 + 1.0;
                tmp1.xz = min(tmp1.xz, float2(1.0, 1.0));
                tmp1.x = tmp1.z * tmp1.x;
                tmp1.x = tmp2.y * tmp1.x + tmp1.y;
                tmp1.x = tmp1.x - 0.333;
                tmp1.x = saturate(tmp1.x * 2.994012);
                tmp1.y = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.y = tmp1.x * _BitsColor.w;
                tmp0.x = saturate(_BitsColor.w * tmp1.x + tmp0.x);
                tmp0.yzw = _BitsColor.xyz * tmp1.yyy + tmp0.yzw;
                tmp1.x = inp.texcoord3.w + 0.0;
                tmp1.xyz = inp.texcoord3.zxy / tmp1.xxx;
                tmp2 = tex2D(_CameraDepthTexture, tmp1.yz);
                tmp1.x = _ZBufferParams.z * tmp1.x + _ZBufferParams.w;
                tmp1.x = 1.0 / tmp1.x;
                tmp1.y = _ZBufferParams.z * tmp2.x + _ZBufferParams.w;
                tmp1.y = 1.0 / tmp1.y;
                tmp1.x = tmp1.y - tmp1.x;
                tmp1.x = tmp1.x / _DepthFade;
                tmp1.x = min(abs(tmp1.x), 1.0);
                o.sv_target.xyz = tmp0.yzw * tmp1.xxx;
                o.sv_target.w = tmp0.x * tmp1.x;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}