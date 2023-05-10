Shader "_Custom/Flames"
{
    Properties
    {
        [Header(Conf Textura)] [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}
        _DistText ("Dist Texture", 2D) = "white" {}
        _Color("Color", color) = (1,1,1,1)
        [Space(15)]

        [Header(Conf Alpha)] [Space(5)]
        _Alpha("Alpha", Range(0.0, 1.0)) = 0.443    
        [Space(15)]

        [Header(Animation)] [Space(5)]
        _Speed("Speed", Range(0.0, 1.8)) = 0

    }   
    SubShader
    {
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
        Cull off
        AlphaToMask on
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 distText: TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 distText: TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex, _DistText;
            float4 _MainTex_ST, _DistText_ST;

            fixed4 _Color;
            float _Alpha;
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                
                o.distText = TRANSFORM_TEX(v.distText, _DistText);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed2 speed = float2(i.distText.x, i.distText.y + (_Time.y * _Speed));
                fixed4 distortion = tex2D(_DistText, speed);
                fixed2 colset = float2(distortion.x, i.uv.y);

                fixed4 col = tex2D(_MainTex, colset);
                col.a *= _Alpha;

                return col;
            }
            ENDCG
        }
    }
}
