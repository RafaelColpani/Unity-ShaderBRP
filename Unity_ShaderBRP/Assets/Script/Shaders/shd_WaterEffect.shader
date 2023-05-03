Shader "_Custom/WaterEffect"
{
    Properties
    {
        [Header(Basic Color)] [Space(5)]
        _BasicColor("Basic color", color) = (1, 1, 1, 1) //Cor base da agua
        [Space(15)]

        [Header(All Texture)] [Space(5)]
        _WaterTexture("Water Texture", 2D) = "white" {}
        [Space(15)]

        [Header(Texture Color)][Space(5)]
        _ColorTexture("Color Texture", color) = (1, 1, 1, 1) // cor da textura 
        [Space(15)]

        //
        // Espaço para o Voronoi
        //

        [Header(Animation)] [Space(5)]
        _VertexAnimationSpeed("Vertex Animation Speed", Range(0.0, 10.0)) = 0
        _VertexAnimationOffset("Vertex Animation Offset", Range(0.0, 4.0)) = 0
        [Space(15)]

        [Header(Conf Alpha)] [Space(5)]
        _Alpha("Alpha", Range(0.0, 1.0)) = 0.443    
        
    }   

    SubShader
    {
        //Render
        //Tags { "RenderType"="Opaque" }
        Tags {"Queue" = "Transparent" "RenderType"="Transparent" } 
        LOD 100

        //Alpha
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            //Variaveis para o codigo
            fixed4 _BasicColor;

            //Textura
            sampler2D _WaterTexture;
            float4 _WaterTexture_ST;
            fixed4 _ColorTexture;

            //Animation
            float _VertexAnimationSpeed, _VertexAnimationOffset;
            
            //Alpha
            float _Alpha;
            
            v2f vert (appdata v)
            {
                v2f o;

                //Animation
                v.vertex.xy += sin(_Time.y * _VertexAnimationSpeed + v.vertex.xy * _VertexAnimationOffset.x); 
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _WaterTexture);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {   
                //return 1; //Retorna a cor branca

                //Tudo teoria agora == Testar na engine depois 
                //Cor base 
                fixed4 col = _BasicColor;

                //Alpha
                col.a *= _Alpha; // a = alpha
                
                //Textura + cor da textura
                col = tex2D(_WaterTexture, i.uv) + _ColorTexture;

                //Cor base + textura já misturada com a sua cor
                
                
                //Return material
                return col;
            }
            ENDCG
        }
    }
}