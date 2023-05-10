Shader "_Custom/shd_Grass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        [Header(Vertex Config)] [Space(5)]
        _vertexPlayer("Player Positon", Vector) = (0, 0, 0, 0)
        _Distance("Distance", Vector) = (0, 0, 0, 0)
    }

    SubShader
    {
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
        Cull Off
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

                float3 normal : TEXCOORD1; 
                float3 viewDir : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float3 _vertexPlayer, _Distance;

            v2f vert (appdata v)
            {
                v2f o;
                //v.vertex.x += _vertexPlayer;    
                
                //usar o lenght para calcular a distancia do player com o objeto

                if(v.uv.y > 0.15)
                {
                    v.vertex.x -= _vertexPlayer.x; 
                }
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
    
                return col;
            }
            ENDCG
        }
    }
}
