Shader "SR/Night Cycle Textures" {
	Properties {
		_DayTex ("DayTex", 2D) = "white" {}
		_NightTex ("NightTex", 2D) = "white" {}
		_DuskTex ("DuskTex", 2D) = "white" {}
		_DawnTex ("DawnTex", 2D) = "white" {}
		_DayFraction ("DayFraction", Float) = 0.25
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		Pass {
			Name "FORWARD"
			Tags { "LIGHTMODE" = "FORWARDBASE" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
			GpuProgramID 31620
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			// $Globals ConstantBuffers for Fragment Shader
			float4 _DayTex_ST;
			float4 _NightTex_ST;
			float _DayFraction;
			float4 _DuskTex_ST;
			float4 _DawnTex_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DayTex;
			sampler2D _NightTex;
			sampler2D _DuskTex;
			sampler2D _DawnTex;
			
			// Keywords: DIRECTIONAL
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
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
                tmp0.x = 0.5 - _DayFraction;
                tmp0.x = tmp0.x + tmp0.x;
                tmp0.x = min(abs(tmp0.x), 1.0);
                tmp0.y = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.y;
                tmp0.yz = inp.texcoord.xy * _NightTex_ST.xy + _NightTex_ST.zw;
                tmp1 = tex2D(_NightTex, tmp0.yz);
                tmp0.yz = inp.texcoord.xy * _DayTex_ST.xy + _DayTex_ST.zw;
                tmp2 = tex2D(_DayTex, tmp0.yz);
                tmp0.yzw = tmp1.xyz - tmp2.xyz;
                tmp0.xyz = tmp0.xxx * tmp0.yzw + tmp2.xyz;
                tmp1.xy = _DayFraction.xx - float2(1.0, 0.25);
                tmp1.x = saturate(-tmp1.x);
                tmp0.w = tmp1.y * 12.56636;
                tmp0.w = cos(tmp0.w);
                tmp0.w = max(tmp0.w, 0.0);
                tmp0.w = tmp0.w * tmp0.w;
                tmp1.y = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.yz = inp.texcoord.xy * _DawnTex_ST.xy + _DawnTex_ST.zw;
                tmp2 = tex2D(_DawnTex, tmp1.yz);
                tmp1.yz = inp.texcoord.xy * _DuskTex_ST.xy + _DuskTex_ST.zw;
                tmp3 = tex2D(_DuskTex, tmp1.yz);
                tmp1.yzw = tmp2.xyz - tmp3.xyz;
                tmp1.xyz = tmp1.xxx * tmp1.yzw + tmp3.xyz;
                tmp1.xyz = tmp1.xyz - tmp0.xyz;
                o.sv_target.xyz = tmp0.www * tmp1.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ShaderForgeMaterialInspector"
}