Shader "SR/AMP/Slime/Body Cloak" {
	Properties {
		_Cutoff ("Mask Clip Value", Float) = 0.5
		_LightingUVHorizontalAdjust ("Lighting UV Horizontal Adjust", Range(0, 1)) = 0
		_LightingUVContribution ("Lighting UV Contribution", Range(0, 1)) = 1
		_TopColor ("Top Color", Color) = (1,0.7688679,0.7688679,1)
		_MiddleColor ("Middle Color", Color) = (1,0.1556604,0.26705,1)
		_BottomColor ("Bottom Color", Color) = (0.4716981,0,0.1533688,1)
		_Gloss ("Gloss", Range(0, 2)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_BodyLightingContribution ("Body Lighting Contribution", Range(0, 1)) = 1
		_Alpha ("Alpha", Range(0, 1)) = 0
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
	}
	SubShader {
		Tags { "IsEmissive" = "true" "QUEUE" = "Overlay+1" "RenderType" = "TransparentCutout" }
		GrabPass {
			"_RefractionCloak"
		}
		Pass {
			Name "FORWARD"
			Tags { "IsEmissive" = "true" "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Overlay+1" "RenderType" = "TransparentCutout" }
			GpuProgramID 62995
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 texcoord3 : TEXCOORD3;
				float4 texcoord4 : TEXCOORD4;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _texcoord_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float _Gloss;
			float _GlossPower;
			float _LightingUVHorizontalAdjust;
			float _LightingUVContribution;
			float _BodyLightingContribution;
			float _Alpha;
			float4 _BottomColor;
			float4 _MiddleColor;
			float4 _TopColor;
			float _Cutoff;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RefractionCloak;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp1 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp0.xyz = unity_ObjectToWorld._m03_m13_m23 * v.vertex.www + tmp0.xyz;
                tmp2 = tmp1.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp2 = unity_MatrixVP._m00_m10_m20_m30 * tmp1.xxxx + tmp2;
                tmp2 = unity_MatrixVP._m02_m12_m22_m32 * tmp1.zzzz + tmp2;
                tmp1 = unity_MatrixVP._m03_m13_m23_m33 * tmp1.wwww + tmp2;
                o.position = tmp1;
                o.texcoord.xy = v.texcoord.xy * _texcoord_ST.xy + _texcoord_ST.zw;
                o.texcoord1.w = tmp0.x;
                tmp2.y = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp2.z = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp2.x = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.x = dot(tmp2.xyz, tmp2.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp2.xyz = tmp0.xxx * tmp2.xyz;
                tmp3.xyz = v.tangent.yyy * unity_ObjectToWorld._m11_m21_m01;
                tmp3.xyz = unity_ObjectToWorld._m10_m20_m00 * v.tangent.xxx + tmp3.xyz;
                tmp3.xyz = unity_ObjectToWorld._m12_m22_m02 * v.tangent.zzz + tmp3.xyz;
                tmp0.x = dot(tmp3.xyz, tmp3.xyz);
                tmp0.x = rsqrt(tmp0.x);
                tmp3.xyz = tmp0.xxx * tmp3.xyz;
                tmp4.xyz = tmp2.xyz * tmp3.xyz;
                tmp4.xyz = tmp2.zxy * tmp3.yzx + -tmp4.xyz;
                tmp0.x = v.tangent.w * unity_WorldTransformParams.w;
                tmp4.xyz = tmp0.xxx * tmp4.xyz;
                o.texcoord1.y = tmp4.x;
                o.texcoord1.x = tmp3.z;
                o.texcoord1.z = tmp2.y;
                o.texcoord2.x = tmp3.x;
                o.texcoord3.x = tmp3.y;
                o.texcoord2.z = tmp2.z;
                o.texcoord3.z = tmp2.x;
                o.texcoord2.w = tmp0.y;
                o.texcoord3.w = tmp0.z;
                o.texcoord2.y = tmp4.y;
                o.texcoord3.y = tmp4.z;
                tmp0.x = tmp1.y * _ProjectionParams.x;
                tmp0.w = tmp0.x * 0.5;
                tmp0.xz = tmp1.xw * float2(0.5, 0.5);
                o.texcoord4.zw = tmp1.zw;
                o.texcoord4.xy = tmp0.zz + tmp0.xw;
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
                tmp0.x = 1.0 - _Cutoff;
                tmp0.x = tmp0.x < 0.0;
                if (tmp0.x) {
                    discard;
                }
                tmp0.xy = inp.texcoord.xy - float2(0.5, -0.0);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.x = tmp0.x - 0.25;
                tmp0.x = saturate(tmp0.x * 1.333333);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.y * tmp0.x + -inp.texcoord.y;
                tmp0.x = _LightingUVHorizontalAdjust * tmp0.x + inp.texcoord.y;
                tmp0.x = tmp0.x - 0.5;
                tmp0.y = _LightingUVContribution * tmp0.x + 0.5;
                tmp0.x = tmp0.x * _LightingUVContribution;
                tmp0.x = -tmp0.x * 2.0 + 1.0;
                tmp0.z = tmp0.y > 0.5;
                tmp0.y = tmp0.y + tmp0.y;
                tmp1.x = inp.texcoord1.z;
                tmp1.z = inp.texcoord3.z;
                tmp1.y = inp.texcoord2.z;
                tmp0.w = dot(tmp1.xyz, tmp1.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp1.w = tmp1.y * tmp0.w + 1.0;
                tmp2.xyz = tmp0.www * tmp1.xyz;
                tmp0.w = saturate(tmp1.w * 0.75 + -0.5);
                tmp1.w = 1.0 - tmp0.w;
                tmp0.y = tmp0.w * tmp0.y;
                tmp0.x = -tmp0.x * tmp1.w + 1.0;
                tmp0.x = saturate(tmp0.z ? tmp0.x : tmp0.y);
                tmp0.x = tmp0.x * 0.85;
                tmp3.x = inp.texcoord1.w;
                tmp3.y = inp.texcoord2.w;
                tmp3.z = inp.texcoord3.w;
                tmp0.yzw = _WorldSpaceCameraPos - tmp3.xyz;
                tmp1.w = dot(tmp0.xyz, tmp0.xyz);
                tmp1.w = max(tmp1.w, 0.001);
                tmp1.w = rsqrt(tmp1.w);
                tmp3.xyz = tmp0.yzw * tmp1.www;
                tmp0.yzw = tmp0.yzw * tmp1.www + float3(0.0, 1.0, 0.0);
                tmp1.w = dot(tmp2.xyz, tmp3.xyz);
                tmp1.x = dot(tmp1.xyz, tmp3.xyz);
                tmp1.xy = float2(1.0, 1.0) - tmp1.xw;
                tmp0.x = tmp1.y * tmp1.y + tmp0.x;
                tmp1.y = dot(tmp0.xyz, tmp0.xyz);
                tmp1.y = rsqrt(tmp1.y);
                tmp0.yzw = tmp0.yzw * tmp1.yyy;
                tmp0.y = dot(tmp2.xyz, tmp0.xyz);
                tmp0.y = tmp0.y + 1.0;
                tmp0.y = tmp0.y * 0.5;
                tmp0.y = log(tmp0.y);
                tmp0.z = _GlossPower * 16.0 + -1.0;
                tmp0.z = exp(tmp0.z);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.y = exp(tmp0.y);
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.z = tmp0.z * _Gloss;
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.x = tmp0.y * 0.625 + tmp0.x;
                tmp0.x = saturate(tmp0.x + 0.15);
                tmp0.x = tmp0.x - tmp1.x;
                tmp0.x = _BodyLightingContribution * tmp0.x + tmp1.x;
                tmp0.z = tmp0.x - 0.5;
                tmp0.z = saturate(tmp0.z + tmp0.z);
                tmp0.w = tmp0.z * -2.0 + 3.0;
                tmp0.z = tmp0.z * tmp0.z;
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.w = tmp0.y * 0.625;
                tmp0.z = tmp0.z * 0.1 + tmp0.w;
                tmp0.w = tmp1.x * tmp1.x;
                tmp0.w = tmp0.w * tmp0.w;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = saturate(tmp1.x * -0.5 + 0.25);
                tmp0.w = saturate(tmp0.w * -2.0 + 1.0);
                tmp0.w = tmp0.w * _ScreenParams.w;
                tmp1.y = _Alpha * _Alpha;
                tmp1.y = tmp1.y * tmp1.y;
                tmp1.y = tmp1.y * _Alpha;
                tmp0.w = tmp0.w * tmp1.y;
                tmp1.z = tmp1.x > 0.5;
                tmp1.w = tmp1.x - 0.5;
                tmp1.x = tmp1.x + tmp1.x;
                tmp1.w = -tmp1.w * 2.0 + 1.0;
                tmp2.xy = tmp1.yy * float2(0.5, -0.75) + float2(0.5, 1.0);
                tmp2.z = 1.0 - tmp2.x;
                tmp1.w = -tmp1.w * tmp2.z + 1.0;
                tmp1.x = tmp1.x * tmp2.x;
                tmp1.x = saturate(tmp1.z ? tmp1.w : tmp1.x);
                tmp1.zw = inp.texcoord2.zz * unity_MatrixV._m01_m11;
                tmp1.zw = unity_MatrixV._m00_m10 * inp.texcoord1.zz + tmp1.zw;
                tmp1.zw = unity_MatrixV._m02_m12 * inp.texcoord3.zz + tmp1.zw;
                tmp1.zw = tmp1.zw + float2(1.0, 1.0);
                tmp2.x = inp.texcoord4.w + 0.0;
                tmp2.z = tmp2.x * 0.5;
                tmp2.w = -tmp2.x * 0.5 + inp.texcoord4.y;
                tmp3.y = -tmp2.w * _ProjectionParams.x + tmp2.z;
                tmp3.x = inp.texcoord4.x;
                tmp2.xz = tmp3.xy / tmp2.xx;
                tmp1.zw = tmp1.zw * float2(0.5, 0.5) + -tmp2.xz;
                tmp1.zw = tmp1.zw * float2(0.2, 0.2) + tmp2.xz;
                tmp2.xz = tmp2.xz - float2(0.5, 0.5);
                tmp2.xy = tmp2.yy * tmp2.xz + float2(0.5, 0.5);
                tmp1.zw = tmp1.zw - tmp2.xy;
                tmp2.xy = tmp1.xx * tmp1.zw + tmp2.xy;
                tmp3 = tmp0.wwww * float4(0.05, 0.05, 0.05, 0.05) + tmp2.xyxy;
                tmp4 = -tmp0.wwww * float4(0.05, 0.05, 0.05, 0.05) + tmp2.xyxy;
                tmp2.zw = tmp3.xy;
                tmp3 = tex2D(_RefractionCloak, tmp3.zw);
                tmp5 = tex2D(_RefractionCloak, tmp2.zy);
                tmp6 = tex2D(_RefractionCloak, tmp2.xy);
                tmp1.xzw = tmp5.xyz + tmp6.xyz;
                tmp5 = tex2D(_RefractionCloak, tmp2.xw);
                tmp1.xzw = tmp1.xzw + tmp5.xyz;
                tmp5.yz = tmp2.yw;
                tmp5.x = tmp4.x;
                tmp6 = tex2D(_RefractionCloak, tmp5.xy);
                tmp5 = tex2D(_RefractionCloak, tmp5.xz);
                tmp1.xzw = tmp1.xzw + tmp6.xyz;
                tmp2.y = tmp4.y;
                tmp4 = tex2D(_RefractionCloak, tmp4.zw);
                tmp6 = tex2D(_RefractionCloak, tmp2.xy);
                tmp2 = tex2D(_RefractionCloak, tmp2.zy);
                tmp1.xzw = tmp1.xzw + tmp6.xyz;
                tmp1.xzw = tmp3.xyz + tmp1.xzw;
                tmp1.xzw = tmp4.xyz + tmp1.xzw;
                tmp1.xzw = tmp2.xyz + tmp1.xzw;
                tmp1.xzw = tmp5.xyz + tmp1.xzw;
                tmp1.xzw = tmp1.xzw * float3(0.1111111, 0.1111111, 0.1111111);
                tmp1.xzw = saturate(tmp0.zzz * tmp1.yyy + tmp1.xzw);
                tmp0.z = tmp1.y * 0.5;
                tmp0.w = saturate(tmp0.x * 2.0 + -1.0);
                tmp2.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _TopColor.xyz;
                tmp3.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = _TopColor.www * tmp2.xyz + tmp3.xyz;
                tmp4.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _MiddleColor.xyz;
                tmp4.xyz = _MiddleColor.www * tmp4.xyz + tmp3.xyz;
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp2.xyz = tmp0.xxx * tmp2.xyz + tmp4.xyz;
                tmp5.xyz = -glstate_lightmodel_ambient.xyz * float3(2.0, 2.0, 2.0) + _BottomColor.xyz;
                tmp5.xyz = _BottomColor.www * tmp5.xyz + tmp3.xyz;
                tmp4.xyz = tmp4.xyz - tmp5.xyz;
                tmp4.xyz = tmp0.xxx * tmp4.xyz + tmp5.xyz;
                tmp2.xyz = tmp2.xyz - tmp4.xyz;
                tmp2.xyz = tmp0.www * tmp2.xyz + tmp4.xyz;
                tmp0.xyw = tmp0.yyy * float3(0.625, 0.625, 0.625) + tmp2.xyz;
                tmp0.xyw = -tmp3.xyz * tmp2.xyz + tmp0.xyw;
                tmp2.xyz = tmp2.xyz * tmp3.xyz;
                tmp0.xyw = tmp0.xyw * float3(0.8, 0.8, 0.8) + tmp2.xyz;
                tmp0.xyw = tmp0.xyw - tmp1.xzw;
                o.sv_target.xyz = tmp0.zzz * tmp0.xyw + tmp1.xzw;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}