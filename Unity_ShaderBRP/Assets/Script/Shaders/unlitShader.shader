Shader "Unlit/unlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}  // Define a textura a ser usada como entrada para o shader
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }  // Define as tags que descrevem o tipo de renderização a ser usada
        LOD 100  // Define o nível de detalhe (LOD) para o shader

        Pass
        {
            CGPROGRAM
            #pragma vertex vert  // Define a função de vértice (vertex shader)
            #pragma fragment frag  // Define a função de fragmento (pixel shader)
            // make fog work
            #pragma multi_compile_fog  // Habilita a compilação para suportar neblina (fog)

            #include "UnityCG.cginc"  // Inclui o arquivo UnityCG.cginc que contém definições úteis

            struct appdata
            {
                float4 vertex : POSITION;  // Define a posição do vértice
                float2 uv : TEXCOORD0;  // Define as coordenadas de textura do vértice
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;  // Define as coordenadas de textura interpoladas a serem passadas para a função de fragmento
                UNITY_FOG_COORDS(1)  // Define a coordenada de neblina para ser usada com a tag multi_compile_fog
                float4 vertex : SV_POSITION;  // Define a posição do vértice interpolada a ser passada para a função de fragmento
            };

            sampler2D _MainTex;  // Declara a textura a ser usada no shader
            float4 _MainTex_ST;  // Define o espaço de textura a ser usado para a textura (usado para controlar o tamanho e posicionamento da textura)

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);  // Converte a posição do vértice do espaço do objeto para o espaço de recorte
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);  // Converte as coordenadas de textura do vértice no espaço de textura definido pelo _MainTex_ST
                UNITY_TRANSFER_FOG(o,o.vertex);  // Transfere a coordenada de neblina para o fragmento
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);  // Amostra a textura na coordenada de textura interpolada i.uv
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);  // Aplica a neblina à cor da amostra da textura
                return col;  // Retorna a cor da amostra da textura com a neblina aplicada
            }
            ENDCG  // Encerra a definição do CGPROGRAM
        }
    }
}