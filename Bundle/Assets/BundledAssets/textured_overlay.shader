Shader "Custom/TexturedOverlay"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1, 1, 1, 1)
        _MainTex ("Overlay Texture", 2D) = "white" {}
        _Gloss ("Gloss", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        half _Gloss;
        half _Metallic;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = texColor.rgb;
            o.Smoothness = _Gloss;
            o.Metallic = _Metallic;
            o.Alpha = texColor.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}