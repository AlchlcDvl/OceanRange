Shader "Custom/ColoredTextureOverlay"
{
    Properties
    {
        _ColorTex("Color Texture", 2D) = "white" {}
        _RedColor("Red Color", Color) = (1, 0, 0, 1)
        _GreenColor("Green Color", Color) = (0, 1, 0, 1)
        _BlueColor("Blue Color", Color) = (0, 0, 1, 1)
        _Gloss("Gloss", Range(0, 1)) = 0.5
        _Metallic("Metallic", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _ColorTex;

        struct Input
        {
            float2 uv_ColorTex;
        };

        fixed4 _RedColor;
        fixed4 _GreenColor;
        fixed4 _BlueColor;
        half _Gloss;
        half _Metallic;

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 colorMask = tex2D(_ColorTex, IN.uv_ColorTex);
            o.Albedo = (_RedColor * colorMask.r) + (_GreenColor * colorMask.g) + (_BlueColor * colorMask.b);
            o.Smoothness = _Gloss;
            o.Metallic = _Metallic;
            o.Alpha = colorMask.a;
        }
        ENDCG
    }
    FallBack "Standard"
}