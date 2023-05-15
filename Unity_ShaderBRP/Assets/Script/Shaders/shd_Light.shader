Shader "_Customt/shd_Light"
{
    Properties
    {
        [Header(Conf Textura)] [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}
        _TexOffset ("Texture Offset", Range(0, 15.0)) = 1.0
        [Space(15)]

        [Header(Color)] [Space(5)]
        _Color1 ("Color 1", Color) = (0, 0, 0, 0)
        _Color2 ("Color 2", Color) = (0, 0, 0, 0)
        _Color3 ("Color 3", Color) = (0, 0, 0, 0)
        [Space(15)]

        [Header(Animation)] [Space(5)]
        _AnimationTime ("Time", Range(0, 10.0)) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _Color1, _Color2, _Color3;

            float _AnimationTime, _TexOffset;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //Textura principal
                fixed4 col = tex2D(_MainTex, i.uv);
                
                //mapa de cores
                fixed4 color1 = abs(0.1 + length(i.uv) - _TexOffset * abs(sin(_Time.y * _AnimationTime ))) * _Color1;
                fixed4 color2 = abs(0.1 + length(i.uv) - _TexOffset * abs(sin(_Time.y * _AnimationTime ))) * _Color2;
                fixed4 color3 = abs(0.1 + length(i.uv) - _TexOffset * abs(sin(_Time.y * _AnimationTime ))) * _Color3;

                //Gera uma animação com as cores 
                fixed4 allColor = sin(_Time.x + color1 + color2) ;
        
                
                return col * allColor ;
            }
            ENDCG
        }
    }
}
