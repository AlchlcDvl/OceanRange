Shader "SR/Skybox/6 Sided Blend" {
	Properties {
		_Tint ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		[Gamma] _Exposure ("Exposure", Range(0, 8)) = 1
		_Rotation ("Rotation", Range(0, 360)) = 0
		_Blend ("Blend", Range(0, 1)) = 0.5
		[NoScaleOffset] _FrontTex ("Front [+Z]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _BackTex ("Back [-Z]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _LeftTex ("Left [+X]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _RightTex ("Right [-X]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _UpTex ("Up [+Y]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _DownTex ("Down [-Y]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _FrontTex2 ("Front 2 [+Z]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _BackTex2 ("Back 2 [-Z]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _LeftTex2 ("Left 2 [+X]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _RightTex2 ("Right 2 [-X]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _UpTex2 ("Up 2 [+Y]   (HDR)", 2D) = "grey" {}
		[NoScaleOffset] _DownTex2 ("Down 2 [-Y]   (HDR)", 2D) = "grey" {}
	}
	SubShader {
		Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZWrite Off
			Cull Off
			GpuProgramID 45433
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Blend;
			float _Exposure;
			float4 _FrontTex_HDR;
			float4 _FrontTex2_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _FrontTex;
			sampler2D _FrontTex2;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_FrontTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _FrontTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _FrontTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp1 = tex2D(_FrontTex2, inp.texcoord.xy);
                tmp0.w = tmp1.w - 1.0;
                tmp0.w = _FrontTex2_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _FrontTex2_HDR.x;
                tmp1.xyz = tmp0.www * tmp1.xyz + -tmp0.xyz;
                tmp0.xyz = _Blend.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp0.xyz = tmp0.xyz * _Exposure.xxx;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZWrite Off
			Cull Off
			GpuProgramID 102004
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Blend;
			float _Exposure;
			float4 _BackTex_HDR;
			float4 _BackTex2_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _BackTex;
			sampler2D _BackTex2;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_BackTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _BackTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _BackTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp1 = tex2D(_BackTex2, inp.texcoord.xy);
                tmp0.w = tmp1.w - 1.0;
                tmp0.w = _BackTex2_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _BackTex2_HDR.x;
                tmp1.xyz = tmp0.www * tmp1.xyz + -tmp0.xyz;
                tmp0.xyz = _Blend.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp0.xyz = tmp0.xyz * _Exposure.xxx;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZWrite Off
			Cull Off
			GpuProgramID 192060
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Blend;
			float _Exposure;
			float4 _LeftTex_HDR;
			float4 _LeftTex2_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _LeftTex;
			sampler2D _LeftTex2;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_LeftTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _LeftTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _LeftTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp1 = tex2D(_LeftTex2, inp.texcoord.xy);
                tmp0.w = tmp1.w - 1.0;
                tmp0.w = _LeftTex2_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _LeftTex2_HDR.x;
                tmp1.xyz = tmp0.www * tmp1.xyz + -tmp0.xyz;
                tmp0.xyz = _Blend.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp0.xyz = tmp0.xyz * _Exposure.xxx;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZWrite Off
			Cull Off
			GpuProgramID 229286
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Blend;
			float _Exposure;
			float4 _RightTex_HDR;
			float4 _RightTex2_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _RightTex;
			sampler2D _RightTex2;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_RightTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _RightTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _RightTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp1 = tex2D(_RightTex2, inp.texcoord.xy);
                tmp0.w = tmp1.w - 1.0;
                tmp0.w = _RightTex2_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _RightTex2_HDR.x;
                tmp1.xyz = tmp0.www * tmp1.xyz + -tmp0.xyz;
                tmp0.xyz = _Blend.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp0.xyz = tmp0.xyz * _Exposure.xxx;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZWrite Off
			Cull Off
			GpuProgramID 265425
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Blend;
			float _Exposure;
			float4 _UpTex_HDR;
			float4 _UpTex2_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _UpTex;
			sampler2D _UpTex2;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_UpTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _UpTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _UpTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp1 = tex2D(_UpTex2, inp.texcoord.xy);
                tmp0.w = tmp1.w - 1.0;
                tmp0.w = _UpTex2_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _UpTex2_HDR.x;
                tmp1.xyz = tmp0.www * tmp1.xyz + -tmp0.xyz;
                tmp0.xyz = _Blend.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp0.xyz = tmp0.xyz * _Exposure.xxx;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			Tags { "PreviewType" = "Skybox" "QUEUE" = "Background" "RenderType" = "Background" }
			ZWrite Off
			Cull Off
			GpuProgramID 371776
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
			float _Rotation;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _Tint;
			float _Blend;
			float _Exposure;
			float4 _DownTex_HDR;
			float4 _DownTex2_HDR;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _DownTex;
			sampler2D _DownTex2;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                tmp0.x = _Rotation * 0.0174533;
                tmp0.x = sin(tmp0.x);
                tmp1.x = cos(tmp0.x);
                tmp2.x = -tmp0.x;
                tmp2.y = tmp1.x;
                tmp2.z = tmp0.x;
                tmp0.x = dot(tmp2.xy, v.vertex.xy);
                tmp0.y = dot(tmp2.xy, v.vertex.xy);
                tmp1 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp1 = unity_ObjectToWorld._m00_m10_m20_m30 * tmp0.yyyy + tmp1;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * tmp0.xxxx + tmp1;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = tex2D(_DownTex, inp.texcoord.xy);
                tmp0.w = tmp0.w - 1.0;
                tmp0.w = _DownTex_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _DownTex_HDR.x;
                tmp0.xyz = tmp0.xyz * tmp0.www;
                tmp1 = tex2D(_DownTex2, inp.texcoord.xy);
                tmp0.w = tmp1.w - 1.0;
                tmp0.w = _DownTex2_HDR.w * tmp0.w + 1.0;
                tmp0.w = tmp0.w * _DownTex2_HDR.x;
                tmp1.xyz = tmp0.www * tmp1.xyz + -tmp0.xyz;
                tmp0.xyz = _Blend.xxx * tmp1.xyz + tmp0.xyz;
                tmp0.xyz = tmp0.xyz * _Tint.xyz;
                tmp0.xyz = tmp0.xyz * _Exposure.xxx;
                o.sv_target.xyz = tmp0.xyz + tmp0.xyz;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
}