Shader "SR/AMP/Slime/Body/OceanRange"
{
    Properties
    {
        [Header(Slime Colors)]
        _TopColor ("Top Color", Color) = (1, 0.7688679, 0.7688679, 1)
        _MiddleColor ("Middle Color", Color) = (1, 0.1556604, 0.26705, 1)
        _BottomColor ("Bottom Color", Color) = (0.4716981, 0, 0.1533688, 1)

        [Header(Glossiness)]
        _Gloss ("Gloss", Range(0, 2)) = 0.5
        _GlossPower ("Gloss Power", Range(0, 1)) = 0.3

        [Header(Lighting Influence)]
        _LightingUVHorizontalAdjust ("Lighting UV Horizontal Adjust", Range(0, 1)) = 0
        _LightingUVContribution ("Lighting UV Contribution", Range(0, 1)) = 1
        _BodyLightingContribution ("Body Lighting Contribution", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }

        LOD 100

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        fixed4 _TopColor;
        fixed4 _MiddleColor;
        fixed4 _BottomColor;
        half _Gloss;
        half _GlossPower;
        half _LightingUVHorizontalAdjust;
        half _LightingUVContribution;
        half _BodyLightingContribution;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
            float3 worldNormal;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float gradientFactor = saturate(IN.worldPos.y * 0.5 + 0.5);
            fixed4 finalColor;

            if (gradientFactor > 0.5)
                finalColor = lerp(_MiddleColor, _TopColor, (gradientFactor - 0.5) * 2.0);
            else
                finalColor = lerp(_BottomColor, _MiddleColor, gradientFactor * 2.0);

            float lightingInfluence = dot(IN.worldNormal, _WorldSpaceLightPos0.xyz);
            lightingInfluence = saturate(lightingInfluence);

            gradientFactor += (IN.worldPos.x * _LightingUVHorizontalAdjust);
            gradientFactor = saturate(gradientFactor);

            if (gradientFactor > 0.5)
                finalColor = lerp(_MiddleColor, _TopColor, (gradientFactor - 0.5) * 2.0);
            else
                finalColor = lerp(_BottomColor, _MiddleColor, gradientFactor * 2.0);

            finalColor.rgb = lerp(finalColor.rgb * 0.8, finalColor.rgb, _BodyLightingContribution);

            o.Albedo = finalColor.rgb;
            o.Alpha = finalColor.a;

            o.Smoothness = _Gloss;
            o.Specular = _GlossPower;
        }
        ENDCG
    }
    FallBack "Standard"
}