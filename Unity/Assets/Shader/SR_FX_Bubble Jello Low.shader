Shader "SR/FX/Bubble Jello Low" {
	Properties {
		_Bubbles ("Bubbles", 2D) = "black" {}
		_Color ("Color", Color) = (0.5,0.5,0.5,1)
		_Gloss ("Gloss", Range(0, 1)) = 0.5
		_SpecColor ("Spec Color", Color) = (1,1,1,1)
		_Noise ("Noise", 2D) = "black" {}
		_GlossPower ("Gloss Power", Float) = 1
		_Offset ("Offset", Float) = 0.1
		_Ripple ("Ripple", 2D) = "gray" {}
		_Alpha ("Alpha", Range(0, 1)) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "IGNOREPROJECTOR" = "true" "QUEUE" = "Transparent" "RenderType" = "TransparentCutout" }
		Pass {
			Name "FORWARD"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Transparent" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
			Cull Off
			GpuProgramID 63721
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
			float4 _Noise_ST;
			float _Offset;
			float4 _Ripple_ST;
			float _Alpha;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _SpecColor;
			float4 _Bubbles_ST;
			float4 _Color;
			float _Gloss;
			float _GlossPower;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Noise;
			sampler2D _Ripple;
			// Texture params for Fragment Shader
			sampler2D _Bubbles;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 0.5;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.y = dot(v.color.xy, _Alpha);
                tmp0.y = tmp0.y - 1.0;
                tmp0.z = -tmp0.x * tmp0.y + 1.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.yw = v.texcoord.xy * _Ripple_ST.xy + _Ripple_ST.zw;
                tmp1 = tex2Dlod(_Ripple, float4(tmp0.yw, 0, 0.0));
                tmp0.y = tmp1.x * 0.2 + 0.4;
                tmp0.w = 1.0 - tmp0.y;
                tmp1.xy = v.texcoord.yy * float2(-0.5, -0.5) + float2(1.0, 0.5);
                tmp1.y = -tmp1.y * 2.0 + 1.0;
                tmp0.w = -tmp1.y * tmp0.w + 1.0;
                tmp0.y = dot(tmp0.xy, tmp1.xy);
                tmp1.x = tmp1.x > 0.5;
                tmp0.y = saturate(tmp1.x ? tmp0.w : tmp0.y);
                tmp0.w = tmp0.y - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.z = -tmp0.w * tmp0.z + 1.0;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = saturate(tmp0.y ? tmp0.z : tmp0.x);
                tmp0.x = saturate(tmp0.x * -5.0 + 3.0);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * _Offset.xxx;
                tmp1.xy = _Time.yy * float2(0.05, 0.1) + v.texcoord.xy;
                tmp1.xy = tmp1.xy * _Noise_ST.xy + _Noise_ST.zw;
                tmp1 = tex2Dlod(_Noise, float4(tmp1.xy, 0, 0.0));
                tmp1.yz = v.normal.xz;
                tmp1.yz = tmp1.yz * tmp1.xx;
                tmp0.w = _Offset;
                tmp1.yz = tmp0.ww * tmp1.yz;
                tmp1.xz = tmp1.xx * tmp1.yz;
                tmp1.y = 0.0;
                tmp0.w = 1.0 - v.texcoord.y;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
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
                tmp0.xy = inp.texcoord.xy * _Ripple_ST.xy + _Ripple_ST.zw;
                tmp0 = tex2D(_Ripple, tmp0.xy);
                tmp0.x = tmp0.x * 0.2 + 0.4;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.zw = inp.texcoord.yy * float2(-0.5, -0.5) + float2(1.0, 0.5);
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.z > 0.5;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.y = tmp0.x - 0.5;
                tmp0.y = -tmp0.y * 2.0 + 1.0;
                tmp1.xyz = inp.texcoord1.xyz - _WorldSpaceCameraPos;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.z = tmp0.z * 0.5;
                tmp0.w = tmp0.z * tmp0.z;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.w = dot(inp.color.xy, _Alpha);
                tmp0.w = tmp0.w - 1.0;
                tmp1.x = -tmp0.z * tmp0.w + 1.0;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.x = tmp0.x > 0.5;
                tmp0.y = -tmp0.y * tmp1.x + 1.0;
                tmp0.x = saturate(tmp0.x ? tmp0.y : tmp0.z);
                tmp0.y = tmp0.x - 0.5;
                tmp0.x = saturate(tmp0.x * -9.999998 + 5.499999);
                tmp0.y = tmp0.y < 0.0;
                if (tmp0.y) {
                    discard;
                }
                tmp1.x = inp.texcoord.y * 3.0;
                tmp1.x = saturate(tmp1.x);
                tmp0.y = inp.texcoord.y * 2.0 + -1.0;
                tmp0.y = saturate(abs(tmp0.y) * -2.0 + 2.0);
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.y = tmp0.z * tmp0.y;
                tmp2 = _Time * float4(0.05, 0.1, 0.0, 0.1) + inp.texcoord.xyxy;
                tmp0.zw = tmp2.xy * _Noise_ST.xy + _Noise_ST.zw;
                tmp3 = tex2D(_Noise, tmp0.zw);
                tmp0.z = tmp3.x * 0.1 + -0.05;
                tmp1.yzw = _WorldSpaceCameraPos - inp.texcoord1.xyz;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp3.xyz = tmp0.www * tmp1.yzw;
                tmp2.x = dot(inp.texcoord3.xyz, tmp3.xyz);
                tmp2.y = dot(inp.texcoord4.xyz, tmp3.xyz);
                tmp2.xy = tmp2.xy * float2(0.625, 0.625) + tmp2.zw;
                tmp2.xy = tmp0.zz + tmp2.xy;
                tmp2.xy = tmp2.xy * _Bubbles_ST.xy + _Bubbles_ST.zw;
                tmp2 = tex2D(_Bubbles, tmp2.xy);
                tmp0.z = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.yzw = tmp0.zzz * inp.texcoord2.xyz;
                tmp0.z = facing.x ? 1.0 : -1.0;
                tmp2.yzw = tmp0.zzz * tmp2.yzw;
                tmp0.z = dot(tmp2.xyz, tmp3.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp4.xy = tmp0.zz * float2(-2.0, 0.25) + float2(1.0, 0.5);
                tmp4.x = saturate(tmp4.x);
                tmp3.w = max(tmp4.y, 0.0);
                tmp2.x = tmp2.x * tmp4.x;
                tmp4.y = tmp2.z * 0.6666667 + 0.6666667;
                tmp4.z = log(tmp0.z);
                tmp4.z = tmp4.z * 1.5;
                tmp4.z = exp(tmp4.z);
                tmp4.y = saturate(tmp4.z * tmp4.y);
                tmp0.y = tmp2.x * tmp0.y + tmp4.y;
                tmp0.y = saturate(tmp0.y * tmp1.x);
                tmp1.x = tmp0.z * 2.0 + -1.0;
                tmp0.z = saturate(tmp0.z * tmp0.z + -0.5);
                tmp1.x = max(tmp1.x, 0.0);
                tmp0.y = tmp0.y + tmp1.x;
                tmp0.y = min(tmp0.y, 1.0);
                tmp0.x = tmp0.x + tmp0.y;
                tmp0.x = min(tmp0.x, 1.0);
                tmp5.xyz = _SpecColor.xyz - _Color.xyz;
                tmp5.xyz = tmp0.xxx * tmp5.xyz + _Color.xyz;
                tmp6.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp6.xyz = tmp6.xyz + tmp6.xyz;
                tmp0.x = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp7.xyz = tmp0.xxx * _WorldSpaceLightPos0.xyz;
                tmp0.x = dot(tmp7.xyz, tmp3.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.y = 1.0 - tmp0.x;
                tmp0.x = tmp0.x * -1.333333 + 1.333333;
                tmp0.y = tmp0.y * tmp4.z;
                tmp0.y = saturate(dot(tmp2.xy, tmp0.xy));
                tmp0.x = tmp0.x * tmp4.x + tmp0.y;
                tmp3.xyz = tmp0.xxx * _LightColor0.xyz;
                tmp4.xyz = -tmp0.xxx * _LightColor0.xyz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = tmp4.xyz * float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz / tmp5.xyz;
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp3.xyz = tmp3.xyz / tmp6.xyz;
                tmp6.xyz = tmp5.xyz > float3(0.5, 0.5, 0.5);
                tmp3.xyz = saturate(tmp6.xyz ? tmp3.xyz : tmp4.xyz);
                tmp0.xyw = tmp1.yzw * tmp0.www + tmp7.xyz;
                tmp1.x = dot(tmp7.xyz, tmp2.xyz);
                tmp1.x = max(tmp1.x, 0.0);
                tmp1.y = dot(tmp0.xyz, tmp0.xyz);
                tmp1.y = rsqrt(tmp1.y);
                tmp0.xyw = tmp0.xyw * tmp1.yyy;
                tmp0.x = dot(tmp2.xyz, tmp0.xyz);
                tmp0.x = max(tmp0.x, 0.0);
                tmp0.x = log(tmp0.x);
                tmp0.y = _Gloss * 10.0 + 1.0;
                tmp0.y = exp(tmp0.y);
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.x = exp(tmp0.x);
                tmp0.x = tmp0.x * tmp1.x;
                tmp0.xyw = tmp0.xxx * _SpecColor.xyz;
                tmp0.xyw = tmp0.xyw * _GlossPower.xxx;
                tmp1.yzw = saturate(tmp0.xyw * float3(9.999998, 9.999998, 9.999998) + float3(-6.999999, -6.999999, -6.999999));
                tmp0.xyw = tmp5.xyz * tmp1.xxx + tmp0.xyw;
                tmp2.xyz = tmp5.xyz * inp.color.xyz;
                tmp0.xyw = tmp1.yzw + tmp0.xyw;
                tmp0.xyw = tmp0.xyw * _LightColor0.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.zzz + tmp0.xyw;
                o.sv_target.xyz = tmp3.www * tmp2.xyz + tmp0.xyz;
                o.sv_target.w = tmp3.w;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "IGNOREPROJECTOR" = "true" "LIGHTMODE" = "SHADOWCASTER" "QUEUE" = "Transparent" "RenderType" = "TransparentCutout" "SHADOWSUPPORT" = "true" }
			Cull Off
			Offset 1, 1
			GpuProgramID 74248
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
			float4 _Noise_ST;
			float _Offset;
			float4 _Ripple_ST;
			float _Alpha;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _Noise;
			sampler2D _Ripple;
			// Texture params for Fragment Shader
			
			// Keywords: SHADOWS_DEPTH
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0.xyz = v.vertex.yyy * unity_ObjectToWorld._m01_m11_m21;
                tmp0.xyz = unity_ObjectToWorld._m00_m10_m20 * v.vertex.xxx + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m02_m12_m22 * v.vertex.zzz + tmp0.xyz;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp0.xyz = tmp0.xyz - _WorldSpaceCameraPos;
                tmp0.x = dot(tmp0.xyz, tmp0.xyz);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x * 0.5;
                tmp0.y = tmp0.x * tmp0.x;
                tmp0.y = tmp0.y * tmp0.y;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.x = min(tmp0.x, 1.0);
                tmp0.y = dot(v.color.xy, _Alpha);
                tmp0.y = tmp0.y - 1.0;
                tmp0.z = -tmp0.x * tmp0.y + 1.0;
                tmp0.x = tmp0.y * tmp0.x;
                tmp0.yw = v.texcoord.xy * _Ripple_ST.xy + _Ripple_ST.zw;
                tmp1 = tex2Dlod(_Ripple, float4(tmp0.yw, 0, 0.0));
                tmp0.y = tmp1.x * 0.2 + 0.4;
                tmp0.w = 1.0 - tmp0.y;
                tmp1.xy = v.texcoord.yy * float2(-0.5, -0.5) + float2(1.0, 0.5);
                tmp1.y = -tmp1.y * 2.0 + 1.0;
                tmp0.w = -tmp1.y * tmp0.w + 1.0;
                tmp0.y = dot(tmp0.xy, tmp1.xy);
                tmp1.x = tmp1.x > 0.5;
                tmp0.y = saturate(tmp1.x ? tmp0.w : tmp0.y);
                tmp0.w = tmp0.y - 0.5;
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.z = -tmp0.w * tmp0.z + 1.0;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.y = tmp0.y > 0.5;
                tmp0.x = saturate(tmp0.y ? tmp0.z : tmp0.x);
                tmp0.x = saturate(tmp0.x * -5.0 + 3.0);
                tmp0.xyz = tmp0.xxx * v.normal.xyz;
                tmp0.xyz = tmp0.xyz * _Offset.xxx;
                tmp1.xy = _Time.yy * float2(0.05, 0.1) + v.texcoord.xy;
                tmp1.xy = tmp1.xy * _Noise_ST.xy + _Noise_ST.zw;
                tmp1 = tex2Dlod(_Noise, float4(tmp1.xy, 0, 0.0));
                tmp1.yz = v.normal.xz;
                tmp1.yz = tmp1.yz * tmp1.xx;
                tmp0.w = _Offset;
                tmp1.yz = tmp0.ww * tmp1.yz;
                tmp1.xz = tmp1.xx * tmp1.yz;
                tmp1.y = 0.0;
                tmp0.w = 1.0 - v.texcoord.y;
                tmp0.xyz = tmp1.xyz * tmp0.www + tmp0.xyz;
                tmp0.xyz = tmp0.xyz + v.vertex.xyz;
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
                float4 tmp0;
                float4 tmp1;
                tmp0.xy = inp.texcoord1.xy * _Ripple_ST.xy + _Ripple_ST.zw;
                tmp0 = tex2D(_Ripple, tmp0.xy);
                tmp0.x = tmp0.x * 0.2 + 0.4;
                tmp0.y = 1.0 - tmp0.x;
                tmp0.zw = inp.texcoord1.yy * float2(-0.5, -0.5) + float2(1.0, 0.5);
                tmp0.w = -tmp0.w * 2.0 + 1.0;
                tmp0.y = -tmp0.w * tmp0.y + 1.0;
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.z = tmp0.z > 0.5;
                tmp0.x = saturate(tmp0.z ? tmp0.y : tmp0.x);
                tmp0.y = tmp0.x - 0.5;
                tmp0.y = -tmp0.y * 2.0 + 1.0;
                tmp1.xyz = inp.texcoord2.xyz - _WorldSpaceCameraPos;
                tmp0.z = dot(tmp1.xyz, tmp1.xyz);
                tmp0.z = sqrt(tmp0.z);
                tmp0.z = tmp0.z * 0.5;
                tmp0.w = tmp0.z * tmp0.z;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.w = dot(inp.color.xy, _Alpha);
                tmp0.w = tmp0.w - 1.0;
                tmp1.x = -tmp0.z * tmp0.w + 1.0;
                tmp0.z = tmp0.w * tmp0.z;
                tmp0.z = dot(tmp0.xy, tmp0.xy);
                tmp0.x = tmp0.x > 0.5;
                tmp0.y = -tmp0.y * tmp1.x + 1.0;
                tmp0.x = saturate(tmp0.x ? tmp0.y : tmp0.z);
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