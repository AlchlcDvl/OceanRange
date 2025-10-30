Shader "SR/Paintlight/Triplanar Topper Only" {
	Properties {
		[MaterialToggle] _OnlyUpwardFaces ("Only Upward Faces", Float) = 1
		_Topper_MainTex ("Topper _MainTex", 2D) = "white" {}
		_TopperDepth ("Topper Depth", 2D) = "gray" {}
		_TopperCoverage ("Topper Coverage", Range(0, 2)) = 1
		_ToporBottom ("Top or Bottom", Range(0, 1)) = 0
		[MaterialToggle] _TopperEnableDetailTex ("Topper Enable Detail Tex", Float) = 0
		_TopperDetailTex ("Topper Detail Tex", 2D) = "white" {}
		_DetailNoiseMask ("Detail Noise Mask", 2D) = "black" {}
		_TopperDepthStrength ("Topper Depth Strength", Float) = 1
		_RampOffset ("Ramp Offset", Float) = 2
		_RampScale ("Ramp Scale", Float) = 1
		_RampUpper ("RampUpper", Color) = (0.4431373,0.3921569,0.5686275,1)
		_SeaLevelRampOffset ("SeaLevelRamp Offset", Float) = -3
		_SeaLevelRampScale ("SeaLevelRamp Scale", Float) = 1
		_SeaLevelRampLower ("SeaLevelRampLower", Color) = (0.3098039,0.4078431,0.3921569,1)
		[MaterialToggle] _SeaLevelRampObjectPos ("SeaLevelRamp Object Pos", Float) = 0
		_TopperSpecular ("Topper Specular", 2D) = "black" {}
		_SpecularColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
		_Gloss ("Gloss", Range(0, 1)) = 0
		_GlossPower ("Gloss Power", Range(0, 1)) = 0.3
		_TopperSpecularNoiseAdjust ("Topper Specular Noise Adjust", Range(0, 1)) = 0.5
		_VerticalRamp ("Vertical Ramp", 2D) = "gray" {}
		_WindTurbulance ("Wind Turbulance", Float) = 2
		_WindStrength ("Wind Strength", Float) = 0
		_WindSpeed ("Wind Speed", Float) = 1
		[HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 42693
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _LightColor0;
			float4 _TimeEditor;
			float4 _DetailNoiseMask_ST;
			float4 _TopperDepth_ST;
			float4 _Topper_MainTex_ST;
			float4 _TopperDetailTex_ST;
			float _TopperEnableDetailTex;
			float _TopperCoverage;
			float _TopperDepthStrength;
			float _RampOffset;
			float _RampScale;
			float4 _RampUpper;
			float _SeaLevelRampOffset;
			float _SeaLevelRampScale;
			float4 _SeaLevelRampLower;
			float4 _TopperSpecular_ST;
			float _Gloss;
			float _GlossPower;
			float _TopperSpecularNoiseAdjust;
			float4 _SpecularColor;
			float4 _VerticalRamp_ST;
			float _SeaLevelRampObjectPos;
			float _ToporBottom;
			float _OnlyUpwardFaces;
			float _WindTurbulance;
			float _WindStrength;
			float _WindSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _TopperDepth;
			sampler2D _VerticalRamp;
			sampler2D _Topper_MainTex;
			sampler2D _TopperDetailTex;
			sampler2D _DetailNoiseMask;
			sampler2D _TopperSpecular;
			
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
                o.texcoord1.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp10;
                tmp0.x = round(_ToporBottom);
                tmp0.y = saturate(_ToporBottom * 2.0 + -1.0);
                tmp0.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * inp.texcoord1.xyz;
                tmp0.z = saturate(-tmp1.y);
                tmp0.z = tmp0.z - abs(tmp1.y);
                tmp0.y = tmp0.y * tmp0.z + abs(tmp1.y);
                tmp0.z = _ToporBottom + _ToporBottom;
                tmp0.z = saturate(tmp0.z);
                tmp0.w = saturate(tmp1.y);
                tmp1.w = abs(tmp1.y) - tmp0.w;
                tmp0.z = tmp0.z * tmp1.w + tmp0.w;
                tmp0.y = tmp0.y - tmp0.z;
                tmp0.x = tmp0.x * tmp0.y + tmp0.z;
                tmp0.x = tmp0.x - 1.0;
                tmp0.x = _OnlyUpwardFaces * tmp0.x + 1.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * _TopperCoverage;
                tmp0.x = tmp0.x * inp.color.x;
                tmp0.y = _TimeEditor.z + _Time.z;
                tmp0.y = tmp0.y * _WindSpeed;
                tmp2.xy = inp.texcoord.zx * _WindTurbulance.xx;
                tmp0.yz = tmp0.yy * float2(5.0, 5.0) + tmp2.xy;
                tmp0.xyz = tmp0.xyz * float3(1.25, 0.1061033, 0.1061033);
                tmp2.xy = sin(tmp0.yz);
                tmp0.yz = -tmp2.xy * float2(0.5, 0.5) + tmp0.yz;
                tmp0.yz = sin(tmp0.yz);
                tmp0.yz = tmp0.yz * _WindStrength.xx;
                tmp2.xy = tmp0.yz * float2(0.1, 0.1) + inp.texcoord.zx;
                tmp2.z = inp.texcoord.y;
                tmp3 = tmp2.xyyz * _TopperDepth_ST + _TopperDepth_ST;
                tmp4 = tex2D(_TopperDepth, tmp3.zw);
                tmp3 = tex2D(_TopperDepth, tmp3.xy);
                tmp0.yz = tmp2.zx - float2(0.5, 0.5);
                tmp5.x = dot(tmp0.xy, float2(0.0000003, -1.0));
                tmp5.y = dot(tmp0.xy, float2(1.0, 0.0000003));
                tmp0.yz = tmp5.xy + float2(0.5, 0.5);
                tmp3.yz = tmp0.yz * _TopperDepth_ST.xy + _TopperDepth_ST.zw;
                tmp5 = tex2D(_TopperDepth, tmp3.yz);
                tmp3.yzw = abs(tmp1.xyz) * abs(tmp1.xyz);
                tmp1.w = tmp3.x * tmp3.z;
                tmp1.w = tmp3.y * tmp5.x + tmp1.w;
                tmp1.w = tmp3.w * tmp4.x + tmp1.w;
                tmp1.w = tmp1.w - 0.5;
                tmp1.w = _TopperDepthStrength * tmp1.w + 0.5;
                tmp2.w = 1.0 - tmp1.w;
                tmp0.x = tmp2.w / tmp0.x;
                tmp0.x = saturate(1.0 - tmp0.x);
                tmp0.x = tmp0.x * inp.color.x;
                tmp0.x = saturate(tmp0.x * 8.0);
                tmp2.w = tmp0.x - 0.5;
                tmp2.w = tmp2.w < 0.0;
                if (tmp2.w) {
                    discard;
                }
                tmp4 = tmp2.xyyz * _TopperDetailTex_ST + _TopperDetailTex_ST;
                tmp5 = tex2D(_TopperDetailTex, tmp4.zw);
                tmp4 = tex2D(_TopperDetailTex, tmp4.xy);
                tmp4.xyz = tmp3.zzz * tmp4.xyz;
                tmp6.xy = tmp0.yz * _TopperDetailTex_ST.xy + _TopperDetailTex_ST.zw;
                tmp6 = tex2D(_TopperDetailTex, tmp6.xy);
                tmp4.xyz = tmp3.yyy * tmp6.xyz + tmp4.xyz;
                tmp4.xyz = tmp3.www * tmp5.xyz + tmp4.xyz;
                tmp5 = tmp2.xyyz * _Topper_MainTex_ST + _Topper_MainTex_ST;
                tmp6 = tex2D(_Topper_MainTex, tmp5.zw);
                tmp5 = tex2D(_Topper_MainTex, tmp5.xy);
                tmp5.xyz = tmp3.zzz * tmp5.xyz;
                tmp7.xy = tmp0.yz * _Topper_MainTex_ST.xy + _Topper_MainTex_ST.zw;
                tmp7 = tex2D(_Topper_MainTex, tmp7.xy);
                tmp5.xyz = tmp3.yyy * tmp7.xyz + tmp5.xyz;
                tmp5.xyz = tmp3.www * tmp6.xyz + tmp5.xyz;
                tmp4.xyz = tmp4.xyz - tmp5.xyz;
                tmp6.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp2.w = dot(tmp6.xyz, tmp6.xyz);
                tmp3.x = tmp6.y * _RampScale;
                tmp3.x = tmp3.x * 0.1 + -_RampOffset;
                tmp3.x = saturate(tmp3.x * 0.5 + 0.5);
                tmp2.w = sqrt(tmp2.w);
                tmp2.w = tmp2.w * 0.01;
                tmp4.w = tmp2.w * tmp2.w;
                tmp4.w = tmp4.w * tmp4.w;
                tmp2.w = tmp2.w * tmp4.w;
                tmp2.w = min(tmp2.w, 1.0);
                tmp6 = tmp2.xyyz * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp7 = tmp2.xyyz * _TopperSpecular_ST + _TopperSpecular_ST;
                tmp8 = tex2D(_DetailNoiseMask, tmp6.zw);
                tmp6 = tex2D(_DetailNoiseMask, tmp6.xy);
                tmp2.x = tmp3.z * tmp6.x;
                tmp2.yz = tmp0.yz * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp0.yz = tmp0.yz * _TopperSpecular_ST.xy + _TopperSpecular_ST.zw;
                tmp6 = tex2D(_TopperSpecular, tmp0.yz);
                tmp9 = tex2D(_DetailNoiseMask, tmp2.yz);
                tmp0.y = tmp3.y * tmp9.x + tmp2.x;
                tmp0.y = tmp3.w * tmp8.x + tmp0.y;
                tmp0.y = saturate(tmp0.y * 3.0 + -1.5);
                tmp0.y = tmp2.w * -tmp0.y + tmp0.y;
                tmp2.xyz = tmp4.xyz * tmp0.yyy;
                tmp2.xyz = _TopperEnableDetailTex.xxx * tmp2.xyz + tmp5.xyz;
                tmp4.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp4.xyz = -tmp4.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp8.xyz = tmp3.xxx * tmp5.xyz;
                tmp5.xyz = tmp3.xxx * tmp5.xyz + float3(0.5, 0.5, 0.5);
                tmp8.xyz = -tmp8.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp0.z = -_SeaLevelRampObjectPos * unity_ObjectToWorld._m13 + inp.texcoord.y;
                tmp0.z = tmp0.z - _SeaLevelRampOffset;
                tmp0.z = tmp0.z * _SeaLevelRampScale;
                tmp0.z = saturate(tmp0.z * 0.2 + 0.5);
                tmp9.xyz = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp9.xyz = tmp0.zzz * tmp9.xyz + _SeaLevelRampLower.xyz;
                tmp10.xyz = float3(1.0, 1.0, 1.0) - tmp9.xyz;
                tmp9.xyz = tmp5.xyz * tmp9.xyz;
                tmp5.xyz = tmp5.xyz > float3(0.5, 0.5, 0.5);
                tmp9.xyz = tmp9.xyz + tmp9.xyz;
                tmp8.xyz = -tmp8.xyz * tmp10.xyz + float3(1.0, 1.0, 1.0);
                tmp5.xyz = saturate(tmp5.xyz ? tmp8.xyz : tmp9.xyz);
                tmp8.xyz = float3(1.0, 1.0, 1.0) - tmp5.xyz;
                tmp5.xyz = tmp2.xyz * tmp5.xyz;
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp5.xyz + tmp5.xyz;
                tmp4.xyz = -tmp4.xyz * tmp8.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = saturate(tmp2.xyz ? tmp4.xyz : tmp5.xyz);
                tmp4.xyz = float3(1.0, 1.0, 1.0) - tmp2.xyz;
                tmp5.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp0.z = dot(tmp5.xyz, tmp5.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp5.xyz = tmp0.zzz * tmp5.xyz;
                tmp0.z = dot(tmp1.xyz, tmp5.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = 1.0 - tmp0.z;
                tmp3.x = tmp0.z * tmp0.z;
                tmp3.x = tmp0.z * tmp3.x;
                tmp0.z = tmp0.x * tmp0.z + tmp0.x;
                tmp0.z = tmp0.z * 0.5;
                tmp4.w = dot(abs(tmp1.xy), float2(0.333, 0.333));
                tmp0.w = tmp0.w + tmp4.w;
                tmp4.w = tmp0.w * tmp0.w;
                tmp8.xyz = tmp0.www * tmp0.www + glstate_lightmodel_ambient.xyz;
                tmp8.xyz = tmp8.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp8.xyz = tmp8.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp8.xyz = max(tmp8.xyz, float3(0.75, 0.75, 0.75));
                tmp8.xyz = min(tmp8.xyz, float3(1.0, 1.0, 1.0));
                tmp0.w = tmp3.x * tmp4.w;
                tmp0.w = tmp2.w * -tmp0.w + tmp0.w;
                tmp0.w = tmp1.w * tmp0.w;
                tmp2.w = tmp0.w + tmp0.w;
                tmp8.xyz = tmp0.www * float3(0.75, 0.75, 0.75) + tmp8.xyz;
                tmp8.xyz = tmp8.xyz * _LightColor0.xyz;
                tmp0.w = floor(tmp2.w);
                tmp9.xy = tmp1.ww * float2(0.33, 0.1) + float2(0.33, 0.45);
                tmp2.w = tmp9.y - tmp9.x;
                tmp3.x = saturate(tmp1.y * 2.0 + -1.0);
                tmp2.w = tmp3.x * tmp2.w + tmp9.x;
                tmp3.x = 1.0 - tmp2.w;
                tmp4.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                tmp4.w = rsqrt(tmp4.w);
                tmp9.xyz = tmp4.www * _WorldSpaceLightPos0.xyz;
                tmp4.w = dot(tmp9.xyz, tmp1.xyz);
                tmp4.w = max(tmp4.w, 0.0);
                tmp5.w = tmp4.w - 0.5;
                tmp5.w = -tmp5.w * 2.0 + 1.0;
                tmp3.x = -tmp5.w * tmp3.x + 1.0;
                tmp2.w = dot(tmp2.xy, tmp4.xy);
                tmp4.w = tmp4.w > 0.5;
                tmp2.w = saturate(tmp4.w ? tmp3.x : tmp2.w);
                tmp0.w = tmp2.w * 13.0 + tmp0.w;
                tmp0.w = saturate(tmp0.w - 5.0);
                tmp10.xyz = tmp8.xyz * tmp0.www + float3(-0.5, -0.5, -0.5);
                tmp8.xyz = tmp0.www * tmp8.xyz;
                tmp10.xyz = -tmp10.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp4.xyz = -tmp10.xyz * tmp4.xyz + float3(1.0, 1.0, 1.0);
                tmp10.xyz = tmp2.xyz * tmp8.xyz;
                tmp8.xyz = tmp8.xyz > float3(0.5, 0.5, 0.5);
                tmp10.xyz = tmp10.xyz + tmp10.xyz;
                tmp4.xyz = saturate(tmp8.xyz ? tmp4.xyz : tmp10.xyz);
                tmp0.w = dot(-tmp5.xyz, tmp1.xyz);
                tmp0.w = tmp0.w + tmp0.w;
                tmp1.xyz = tmp1.xyz * -tmp0.www + -tmp5.xyz;
                tmp0.w = dot(tmp9.xyz, tmp1.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = log(tmp0.w);
                tmp1.x = _GlossPower * 16.0 + -1.0;
                tmp1.x = exp(tmp1.x);
                tmp0.w = tmp0.w * tmp1.x;
                tmp0.w = exp(tmp0.w);
                tmp0.w = tmp0.w * _Gloss;
                tmp1.xyz = tmp0.www * _LightColor0.xyz;
                tmp1.xyz = tmp1.xyz * _Gloss.xxx;
                tmp1.xyz = tmp1.xyz * float3(50.0, 50.0, 50.0);
                tmp5 = tex2D(_TopperSpecular, tmp7.zw);
                tmp7 = tex2D(_TopperSpecular, tmp7.xy);
                tmp7.xyz = tmp3.zzz * tmp7.xyz;
                tmp6.xyz = tmp3.yyy * tmp6.xyz + tmp7.xyz;
                tmp5.xyz = tmp3.www * tmp5.xyz + tmp6.xyz;
                tmp5.xyz = tmp0.zzz * tmp5.xyz;
                tmp5.xyz = tmp1.www * tmp5.xyz;
                tmp0.z = 1.0 - _TopperSpecularNoiseAdjust;
                tmp0.w = _TopperSpecularNoiseAdjust - tmp0.z;
                tmp0.y = tmp0.y * tmp0.w + tmp0.z;
                tmp0.y = saturate(tmp0.y + tmp0.y);
                tmp0.yzw = tmp0.yyy * tmp5.xyz;
                tmp0.yzw = saturate(tmp0.yzw * tmp1.xyz);
                tmp1.xyz = tmp0.yzw > float3(0.5, 0.5, 0.5);
                tmp5.xyz = tmp0.yzw * _SpecularColor.xyz;
                tmp0.yzw = tmp0.yzw - float3(0.5, 0.5, 0.5);
                tmp0.yzw = -tmp0.yzw * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = tmp5.xyz + tmp5.xyz;
                tmp6.xyz = float3(1.0, 1.0, 1.0) - _SpecularColor.xyz;
                tmp0.yzw = -tmp0.yzw * tmp6.xyz + float3(1.0, 1.0, 1.0);
                tmp0.yzw = saturate(tmp1.xyz ? tmp0.yzw : tmp5.xyz);
                tmp1.xyz = tmp4.xyz + tmp0.yzw;
                tmp4.xy = inp.texcoord.yz - float2(0.5, 0.5);
                tmp5.x = dot(tmp4.xy, float2(0.0000003, -1.0));
                tmp5.y = dot(tmp4.xy, float2(1.0, 0.0000003));
                tmp4.xy = tmp5.xy + float2(0.5, 0.5);
                tmp4.xy = tmp4.xy * _VerticalRamp_ST.xy + _VerticalRamp_ST.zw;
                tmp4 = tex2D(_VerticalRamp, tmp4.xy);
                tmp1.w = tmp3.z * 0.5;
                tmp3.xyz = tmp3.yyy * tmp4.xyz + tmp1.www;
                tmp4.xy = inp.texcoord.xy * float2(-1.0, 1.0) + float2(1.0, 0.0);
                tmp4.xy = tmp4.xy * _VerticalRamp_ST.xy + _VerticalRamp_ST.zw;
                tmp4 = tex2D(_VerticalRamp, tmp4.xy);
                tmp3.xyz = tmp3.www * tmp4.xyz + tmp3.xyz;
                tmp4.xyz = float3(0.5, 0.5, 0.5) - tmp3.xyz;
                tmp3.xyz = tmp0.xxx * tmp4.xyz + tmp3.xyz;
                tmp4.xyz = glstate_lightmodel_ambient.xyz + glstate_lightmodel_ambient.xyz;
                tmp2.xyz = saturate(tmp2.xyz * tmp4.xyz);
                tmp4.xyz = tmp2.xyz * tmp3.xyz;
                tmp3.xyz = float3(1.0, 1.0, 1.0) - tmp3.xyz;
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp5.xyz = tmp2.xyz - float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp2.xyz > float3(0.5, 0.5, 0.5);
                tmp5.xyz = -tmp5.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.xyz = -tmp5.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp2.xyz = saturate(tmp2.xyz ? tmp3.xyz : tmp4.xyz);
                tmp0.xyz = tmp0.yzw + tmp2.xyz;
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
			GpuProgramID 71166
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
				float3 texcoord1 : TEXCOORD1;
				float4 color : COLOR0;
				float3 texcoord2 : TEXCOORD2;
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
			float4 _DetailNoiseMask_ST;
			float4 _TopperDepth_ST;
			float4 _Topper_MainTex_ST;
			float4 _TopperDetailTex_ST;
			float _TopperEnableDetailTex;
			float _TopperCoverage;
			float _TopperDepthStrength;
			float _RampOffset;
			float _RampScale;
			float4 _RampUpper;
			float _SeaLevelRampOffset;
			float _SeaLevelRampScale;
			float4 _SeaLevelRampLower;
			float4 _TopperSpecular_ST;
			float _Gloss;
			float _GlossPower;
			float _TopperSpecularNoiseAdjust;
			float4 _SpecularColor;
			float _SeaLevelRampObjectPos;
			float _ToporBottom;
			float _OnlyUpwardFaces;
			float _WindTurbulance;
			float _WindStrength;
			float _WindSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _TopperDepth;
			sampler2D _LightTexture0;
			sampler2D _TopperSpecular;
			sampler2D _DetailNoiseMask;
			sampler2D _Topper_MainTex;
			sampler2D _TopperDetailTex;
			
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
                o.texcoord = tmp0;
                tmp1.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp1.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp1.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp1.w = dot(tmp1.xyz, tmp1.xyz);
                tmp1.w = rsqrt(tmp1.w);
                o.texcoord1.xyz = tmp1.www * tmp1.xyz;
                o.color = v.color;
                tmp1.xyz = tmp0.yyy * unity_WorldToLight._m01_m11_m21;
                tmp1.xyz = unity_WorldToLight._m00_m10_m20 * tmp0.xxx + tmp1.xyz;
                tmp0.xyz = unity_WorldToLight._m02_m12_m22 * tmp0.zzz + tmp1.xyz;
                o.texcoord2.xyz = unity_WorldToLight._m03_m13_m23 * tmp0.www + tmp0.xyz;
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
                float4 tmp10;
                float4 tmp11;
                tmp0.x = round(_ToporBottom);
                tmp0.y = saturate(_ToporBottom * 2.0 + -1.0);
                tmp0.z = dot(inp.texcoord1.xyz, inp.texcoord1.xyz);
                tmp0.z = rsqrt(tmp0.z);
                tmp1.xyz = tmp0.zzz * inp.texcoord1.xyz;
                tmp0.z = saturate(-tmp1.y);
                tmp0.z = tmp0.z - abs(tmp1.y);
                tmp0.y = tmp0.y * tmp0.z + abs(tmp1.y);
                tmp0.z = _ToporBottom + _ToporBottom;
                tmp0.z = saturate(tmp0.z);
                tmp0.w = saturate(tmp1.y);
                tmp1.w = abs(tmp1.y) - tmp0.w;
                tmp0.z = tmp0.z * tmp1.w + tmp0.w;
                tmp0.y = tmp0.y - tmp0.z;
                tmp0.x = tmp0.x * tmp0.y + tmp0.z;
                tmp0.x = tmp0.x - 1.0;
                tmp0.x = _OnlyUpwardFaces * tmp0.x + 1.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * _TopperCoverage;
                tmp0.x = tmp0.x * inp.color.x;
                tmp0.y = _TimeEditor.z + _Time.z;
                tmp0.y = tmp0.y * _WindSpeed;
                tmp2.xy = inp.texcoord.zx * _WindTurbulance.xx;
                tmp0.yz = tmp0.yy * float2(5.0, 5.0) + tmp2.xy;
                tmp0.xyz = tmp0.xyz * float3(1.25, 0.1061033, 0.1061033);
                tmp2.xy = sin(tmp0.yz);
                tmp0.yz = -tmp2.xy * float2(0.5, 0.5) + tmp0.yz;
                tmp0.yz = sin(tmp0.yz);
                tmp0.yz = tmp0.yz * _WindStrength.xx;
                tmp2.xy = tmp0.yz * float2(0.1, 0.1) + inp.texcoord.zx;
                tmp2.z = inp.texcoord.y;
                tmp3 = tmp2.xyyz * _TopperDepth_ST + _TopperDepth_ST;
                tmp4 = tex2D(_TopperDepth, tmp3.zw);
                tmp3 = tex2D(_TopperDepth, tmp3.xy);
                tmp0.yz = tmp2.zx - float2(0.5, 0.5);
                tmp5.x = dot(tmp0.xy, float2(0.0000003, -1.0));
                tmp5.y = dot(tmp0.xy, float2(1.0, 0.0000003));
                tmp0.yz = tmp5.xy + float2(0.5, 0.5);
                tmp3.yz = tmp0.yz * _TopperDepth_ST.xy + _TopperDepth_ST.zw;
                tmp5 = tex2D(_TopperDepth, tmp3.yz);
                tmp3.yzw = abs(tmp1.xyz) * abs(tmp1.xyz);
                tmp1.w = tmp3.x * tmp3.z;
                tmp1.w = tmp3.y * tmp5.x + tmp1.w;
                tmp1.w = tmp3.w * tmp4.x + tmp1.w;
                tmp1.w = tmp1.w - 0.5;
                tmp1.w = _TopperDepthStrength * tmp1.w + 0.5;
                tmp2.w = 1.0 - tmp1.w;
                tmp0.x = tmp2.w / tmp0.x;
                tmp0.x = saturate(1.0 - tmp0.x);
                tmp0.x = tmp0.x * inp.color.x;
                tmp0.x = saturate(tmp0.x * 8.0);
                tmp2.w = tmp0.x - 0.5;
                tmp2.w = tmp2.w < 0.0;
                if (tmp2.w) {
                    discard;
                }
                tmp4 = tmp2.xyyz * _TopperDetailTex_ST + _TopperDetailTex_ST;
                tmp5 = tex2D(_TopperDetailTex, tmp4.zw);
                tmp4 = tex2D(_TopperDetailTex, tmp4.xy);
                tmp4.xyz = tmp3.zzz * tmp4.xyz;
                tmp6.xy = tmp0.yz * _TopperDetailTex_ST.xy + _TopperDetailTex_ST.zw;
                tmp6 = tex2D(_TopperDetailTex, tmp6.xy);
                tmp4.xyz = tmp3.yyy * tmp6.xyz + tmp4.xyz;
                tmp4.xyz = tmp3.www * tmp5.xyz + tmp4.xyz;
                tmp5 = tmp2.xyyz * _Topper_MainTex_ST + _Topper_MainTex_ST;
                tmp6 = tex2D(_Topper_MainTex, tmp5.zw);
                tmp5 = tex2D(_Topper_MainTex, tmp5.xy);
                tmp5.xyz = tmp3.zzz * tmp5.xyz;
                tmp7.xy = tmp0.yz * _Topper_MainTex_ST.xy + _Topper_MainTex_ST.zw;
                tmp7 = tex2D(_Topper_MainTex, tmp7.xy);
                tmp5.xyz = tmp3.yyy * tmp7.xyz + tmp5.xyz;
                tmp5.xyz = tmp3.www * tmp6.xyz + tmp5.xyz;
                tmp4.xyz = tmp4.xyz - tmp5.xyz;
                tmp6 = tmp2.xyyz * _DetailNoiseMask_ST + _DetailNoiseMask_ST;
                tmp2 = tmp2.xyyz * _TopperSpecular_ST + _TopperSpecular_ST;
                tmp7 = tex2D(_DetailNoiseMask, tmp6.zw);
                tmp6 = tex2D(_DetailNoiseMask, tmp6.xy);
                tmp3.x = tmp3.z * tmp6.x;
                tmp6.xy = tmp0.yz * _DetailNoiseMask_ST.xy + _DetailNoiseMask_ST.zw;
                tmp0.yz = tmp0.yz * _TopperSpecular_ST.xy + _TopperSpecular_ST.zw;
                tmp8 = tex2D(_TopperSpecular, tmp0.yz);
                tmp6 = tex2D(_DetailNoiseMask, tmp6.xy);
                tmp0.y = tmp3.y * tmp6.x + tmp3.x;
                tmp0.y = tmp3.w * tmp7.x + tmp0.y;
                tmp0.y = saturate(tmp0.y * 3.0 + -1.5);
                tmp6.xyz = inp.texcoord.xyz - _WorldSpaceCameraPos;
                tmp0.z = dot(tmp6.xyz, tmp6.xyz);
                tmp3.x = tmp6.y * _RampScale;
                tmp3.x = tmp3.x * 0.1 + -_RampOffset;
                tmp3.x = saturate(tmp3.x * 0.5 + 0.5);
                tmp0.z = sqrt(tmp0.z);
                tmp0.z = tmp0.z * 0.01;
                tmp4.w = tmp0.z * tmp0.z;
                tmp4.w = tmp4.w * tmp4.w;
                tmp0.z = tmp0.z * tmp4.w;
                tmp0.z = min(tmp0.z, 1.0);
                tmp0.y = tmp0.z * -tmp0.y + tmp0.y;
                tmp4.xyz = tmp4.xyz * tmp0.yyy;
                tmp4.xyz = _TopperEnableDetailTex.xxx * tmp4.xyz + tmp5.xyz;
                tmp5.xyz = tmp4.xyz > float3(0.5, 0.5, 0.5);
                tmp6.xyz = _RampUpper.xyz - float3(0.5, 0.5, 0.5);
                tmp7.xyz = tmp3.xxx * tmp6.xyz;
                tmp6.xyz = tmp3.xxx * tmp6.xyz + float3(0.5, 0.5, 0.5);
                tmp7.xyz = -tmp7.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp3.x = -_SeaLevelRampObjectPos * unity_ObjectToWorld._m13 + inp.texcoord.y;
                tmp3.x = tmp3.x - _SeaLevelRampOffset;
                tmp3.x = tmp3.x * _SeaLevelRampScale;
                tmp3.x = saturate(tmp3.x * 0.2 + 0.5);
                tmp9.xyz = float3(0.5, 0.5, 0.5) - _SeaLevelRampLower.xyz;
                tmp9.xyz = tmp3.xxx * tmp9.xyz + _SeaLevelRampLower.xyz;
                tmp10.xyz = float3(1.0, 1.0, 1.0) - tmp9.xyz;
                tmp7.xyz = -tmp7.xyz * tmp10.xyz + float3(1.0, 1.0, 1.0);
                tmp10.xyz = tmp6.xyz + tmp6.xyz;
                tmp6.xyz = tmp6.xyz > float3(0.5, 0.5, 0.5);
                tmp9.xyz = tmp9.xyz * tmp10.xyz;
                tmp6.xyz = saturate(tmp6.xyz ? tmp7.xyz : tmp9.xyz);
                tmp7.xyz = float3(1.0, 1.0, 1.0) - tmp6.xyz;
                tmp9.xyz = tmp4.xyz - float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz + tmp4.xyz;
                tmp4.xyz = tmp6.xyz * tmp4.xyz;
                tmp6.xyz = -tmp9.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp6.xyz = -tmp6.xyz * tmp7.xyz + float3(1.0, 1.0, 1.0);
                tmp4.xyz = saturate(tmp5.xyz ? tmp6.xyz : tmp4.xyz);
                tmp5.xyz = float3(1.0, 1.0, 1.0) - tmp4.xyz;
                tmp6.xy = tmp1.ww * float2(0.33, 0.1) + float2(0.33, 0.45);
                tmp3.x = tmp6.y - tmp6.x;
                tmp4.w = saturate(tmp1.y * 2.0 + -1.0);
                tmp3.x = tmp4.w * tmp3.x + tmp6.x;
                tmp4.w = 1.0 - tmp3.x;
                tmp6.xyz = _WorldSpaceLightPos0.www * -inp.texcoord.xyz + _WorldSpaceLightPos0.xyz;
                tmp5.w = dot(tmp6.xyz, tmp6.xyz);
                tmp5.w = rsqrt(tmp5.w);
                tmp6.xyz = tmp5.www * tmp6.xyz;
                tmp5.w = dot(tmp6.xyz, tmp1.xyz);
                tmp5.w = max(tmp5.w, 0.0);
                tmp6.w = tmp5.w - 0.5;
                tmp6.w = -tmp6.w * 2.0 + 1.0;
                tmp4.w = -tmp6.w * tmp4.w + 1.0;
                tmp6.w = tmp5.w + tmp5.w;
                tmp5.w = tmp5.w > 0.5;
                tmp3.x = tmp3.x * tmp6.w;
                tmp3.x = saturate(tmp5.w ? tmp4.w : tmp3.x);
                tmp4.w = dot(abs(tmp1.xy), float2(0.333, 0.333));
                tmp0.w = tmp0.w + tmp4.w;
                tmp4.w = tmp0.w * tmp0.w;
                tmp7.xyz = tmp0.www * tmp0.www + glstate_lightmodel_ambient.xyz;
                tmp7.xyz = tmp7.xyz * float3(0.33, 0.33, 0.33) + float3(0.33, 0.33, 0.33);
                tmp7.xyz = tmp7.xyz * float3(13.0, 13.0, 13.0) + float3(-6.0, -6.0, -6.0);
                tmp7.xyz = max(tmp7.xyz, float3(0.75, 0.75, 0.75));
                tmp7.xyz = min(tmp7.xyz, float3(1.0, 1.0, 1.0));
                tmp9.xyz = _WorldSpaceCameraPos - inp.texcoord.xyz;
                tmp0.w = dot(tmp9.xyz, tmp9.xyz);
                tmp0.w = rsqrt(tmp0.w);
                tmp9.xyz = tmp0.www * tmp9.xyz;
                tmp0.w = dot(tmp1.xyz, tmp9.xyz);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = 1.0 - tmp0.w;
                tmp5.w = tmp0.w * tmp0.w;
                tmp5.w = tmp0.w * tmp5.w;
                tmp0.x = tmp0.x * tmp0.w + tmp0.x;
                tmp0.x = tmp0.x * 0.5;
                tmp0.w = tmp4.w * tmp5.w;
                tmp0.z = tmp0.z * -tmp0.w + tmp0.w;
                tmp0.z = tmp1.w * tmp0.z;
                tmp0.w = tmp0.z + tmp0.z;
                tmp7.xyz = tmp0.zzz * float3(0.75, 0.75, 0.75) + tmp7.xyz;
                tmp0.z = floor(tmp0.w);
                tmp0.z = tmp3.x * 13.0 + tmp0.z;
                tmp0.z = saturate(tmp0.z - 5.0);
                tmp0.w = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp10 = tex2D(_LightTexture0, tmp0.ww);
                tmp10.xyz = tmp10.xxx * _LightColor0.xyz;
                tmp7.xyz = tmp7.xyz * tmp10.xyz;
                tmp11.xyz = tmp7.xyz * tmp0.zzz + float3(-0.5, -0.5, -0.5);
                tmp7.xyz = tmp0.zzz * tmp7.xyz;
                tmp11.xyz = -tmp11.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp5.xyz = -tmp11.xyz * tmp5.xyz + float3(1.0, 1.0, 1.0);
                tmp11.xyz = tmp7.xyz + tmp7.xyz;
                tmp7.xyz = tmp7.xyz > float3(0.5, 0.5, 0.5);
                tmp4.xyz = tmp4.xyz * tmp11.xyz;
                tmp4.xyz = saturate(tmp7.xyz ? tmp5.xyz : tmp4.xyz);
                tmp0.z = dot(-tmp9.xyz, tmp1.xyz);
                tmp0.z = tmp0.z + tmp0.z;
                tmp1.xyz = tmp1.xyz * -tmp0.zzz + -tmp9.xyz;
                tmp0.z = dot(tmp6.xyz, tmp1.xyz);
                tmp0.z = max(tmp0.z, 0.0);
                tmp0.z = log(tmp0.z);
                tmp0.w = _GlossPower * 16.0 + -1.0;
                tmp0.w = exp(tmp0.w);
                tmp0.z = tmp0.z * tmp0.w;
                tmp0.z = exp(tmp0.z);
                tmp0.z = tmp0.z * _Gloss;
                tmp1.xyz = tmp0.zzz * tmp10.xyz;
                tmp1.xyz = tmp1.xyz * _Gloss.xxx;
                tmp1.xyz = tmp1.xyz * float3(50.0, 50.0, 50.0);
                tmp5 = tex2D(_TopperSpecular, tmp2.xy);
                tmp2 = tex2D(_TopperSpecular, tmp2.zw);
                tmp5.xyz = tmp3.zzz * tmp5.xyz;
                tmp3.xyz = tmp3.yyy * tmp8.xyz + tmp5.xyz;
                tmp2.xyz = tmp3.www * tmp2.xyz + tmp3.xyz;
                tmp0.xzw = tmp0.xxx * tmp2.xyz;
                tmp0.xzw = tmp1.www * tmp0.xzw;
                tmp1.w = 1.0 - _TopperSpecularNoiseAdjust;
                tmp2.x = _TopperSpecularNoiseAdjust - tmp1.w;
                tmp0.y = tmp0.y * tmp2.x + tmp1.w;
                tmp0.y = saturate(tmp0.y + tmp0.y);
                tmp0.xyz = tmp0.yyy * tmp0.xzw;
                tmp0.xyz = saturate(tmp0.xyz * tmp1.xyz);
                tmp1.xyz = tmp0.xyz > float3(0.5, 0.5, 0.5);
                tmp2.xyz = tmp0.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz - float3(0.5, 0.5, 0.5);
                tmp0.xyz = -tmp0.xyz * float3(2.0, 2.0, 2.0) + float3(1.0, 1.0, 1.0);
                tmp2.xyz = tmp2.xyz * _SpecularColor.xyz;
                tmp3.xyz = float3(1.0, 1.0, 1.0) - _SpecularColor.xyz;
                tmp0.xyz = -tmp0.xyz * tmp3.xyz + float3(1.0, 1.0, 1.0);
                tmp0.xyz = saturate(tmp1.xyz ? tmp0.xyz : tmp2.xyz);
                o.sv_target.xyz = tmp4.xyz + tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Name "ShadowCaster"
			Tags { "LIGHTMODE" = "SHADOWCASTER" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			Offset 1, 1
			GpuProgramID 160695
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
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
			float4 _TimeEditor;
			float4 _TopperDepth_ST;
			float _TopperCoverage;
			float _TopperDepthStrength;
			float _ToporBottom;
			float _OnlyUpwardFaces;
			float _WindTurbulance;
			float _WindStrength;
			float _WindSpeed;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _TopperDepth;
			
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
                o.texcoord1 = unity_ObjectToWorld._m03_m13_m23_m33 * v.vertex.wwww + tmp0;
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
                tmp0.x = dot(v.normal.xyz, unity_WorldToObject._m00_m10_m20);
                tmp0.y = dot(v.normal.xyz, unity_WorldToObject._m01_m11_m21);
                tmp0.z = dot(v.normal.xyz, unity_WorldToObject._m02_m12_m22);
                tmp0.w = dot(tmp0.xyz, tmp0.xyz);
                tmp0.w = rsqrt(tmp0.w);
                o.texcoord2.xyz = tmp0.www * tmp0.xyz;
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
                float4 tmp3;
                float4 tmp4;
                tmp0.x = saturate(_ToporBottom * 2.0 + -1.0);
                tmp0.y = dot(inp.texcoord2.xyz, inp.texcoord2.xyz);
                tmp0.y = rsqrt(tmp0.y);
                tmp1 = tmp0.yyyy * inp.texcoord2.yxyz;
                tmp0.y = saturate(-tmp1.z);
                tmp0.y = tmp0.y - abs(tmp1.x);
                tmp0.x = tmp0.x * tmp0.y + abs(tmp1.x);
                tmp0.y = saturate(tmp1.z);
                tmp0.z = abs(tmp1.x) - tmp0.y;
                tmp1.xyz = abs(tmp1.yzw) * abs(tmp1.yzw);
                tmp0.w = _ToporBottom + _ToporBottom;
                tmp0.w = saturate(tmp0.w);
                tmp0.y = tmp0.w * tmp0.z + tmp0.y;
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.z = round(_ToporBottom);
                tmp0.x = tmp0.z * tmp0.x + tmp0.y;
                tmp0.x = tmp0.x - 1.0;
                tmp0.x = _OnlyUpwardFaces * tmp0.x + 1.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * _TopperCoverage;
                tmp0.x = tmp0.x * inp.color.x;
                tmp0.y = _TimeEditor.z + _Time.z;
                tmp0.y = tmp0.y * _WindSpeed;
                tmp0.zw = inp.texcoord1.zx * _WindTurbulance.xx;
                tmp0.yz = tmp0.yy * float2(5.0, 5.0) + tmp0.zw;
                tmp0.xyz = tmp0.xyz * float3(1.25, 0.1061033, 0.1061033);
                tmp2.xy = sin(tmp0.yz);
                tmp0.yz = -tmp2.xy * float2(0.5, 0.5) + tmp0.yz;
                tmp0.yz = sin(tmp0.yz);
                tmp0.yz = tmp0.yz * _WindStrength.xx;
                tmp2.xy = tmp0.yz * float2(0.1, 0.1) + inp.texcoord1.zx;
                tmp2.z = inp.texcoord1.y;
                tmp0.yz = tmp2.zx - float2(0.5, 0.5);
                tmp2 = tmp2.xyyz * _TopperDepth_ST + _TopperDepth_ST;
                tmp3.x = dot(tmp0.xy, float2(0.0000003, -1.0));
                tmp3.y = dot(tmp0.xy, float2(1.0, 0.0000003));
                tmp0.yz = tmp3.xy + float2(0.5, 0.5);
                tmp0.yz = tmp0.yz * _TopperDepth_ST.xy + _TopperDepth_ST.zw;
                tmp3 = tex2D(_TopperDepth, tmp0.yz);
                tmp4 = tex2D(_TopperDepth, tmp2.xy);
                tmp2 = tex2D(_TopperDepth, tmp2.zw);
                tmp0.y = tmp1.y * tmp4.x;
                tmp0.y = tmp1.x * tmp3.x + tmp0.y;
                tmp0.y = tmp1.z * tmp2.x + tmp0.y;
                tmp0.y = tmp0.y - 0.5;
                tmp0.y = _TopperDepthStrength * tmp0.y + 0.5;
                tmp0.y = 1.0 - tmp0.y;
                tmp0.x = tmp0.y / tmp0.x;
                tmp0.x = saturate(1.0 - tmp0.x);
                tmp0.x = tmp0.x * inp.color.x;
                tmp0.x = saturate(tmp0.x * 8.0);
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