Shader "_Custom/Player/ShieldEffect"
{
    Properties //Variaveis para o Inspector
    {   
        [Header(Conf Textura)] [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Gradient Color", color) = (1,1,1,1)
        [Space(10)]

        [Header(Intensidade da transparencia)] [Space(5)]
        _Alpha("Alpha", Range(0.0, 1.0)) = 0.4
        [Space(10)]

        [Header(Fresnel)] [Space(5)]
        _FresnelPower("Fresnel Power", Range(0.0, 10.0)) = 2
        _FresnelRamp("Fresnel Ramp", Range(0.0, 10.0)) = 1
        //[Space(10)]

        [Header(Vertex Config)] [Space(5)]
        _vertexSize("Vertex Size", Range(0, 0.5)) = 0
        _vertexAnimation("Vertex Animation", Range(0, 0.01)) = 0
    }
    SubShader
    {
        //Tags { "RenderType"="Opaque" }
        //https://docs.unity3d.com/2019.3/Documentation/Manual/SL-SubShaderTags.html
        //Muda a ordem de renderização
        Tags {"Queue" = "Transparent" "RenderType"="Transparent" } 
        LOD 100

        //https://docs.unity3d.com/2019.3/Documentation/Manual/SL-Blend.html
        //zWrite Off //Não renderiza a pronfundidade
        AlphaToMask on
        Blend SrcAlpha OneMinusSrcAlpha // Mesclar os pixels do shader com o ambiente (se for "Transparent")
       
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
       

            #include "UnityCG.cginc"

            struct appdata //meshdata (dados da mesh)
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

                float3 normal : NORMAL; //Pega as normais do objeto
            };

            struct v2f //é usada como entrada para a função frag, que é responsável por calcular a cor final de cada fragmento (ou pixel) do modelo.
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;

                float3 normal : TEXCOORD1; //coordenadas de textura de um vértice
                float3 viewDir : TEXCOORD2; //pegar a direção da visão do player
            };

            //Declarações (Variaveis para o codigo)
            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _Color; //Pq de fixed4 - São 4 variaveis no gradient R,G,B,A
            float _Alpha;

            float _FresnelPower, _FresnelRamp;

            float _vertexSize, _vertexAnimation;

            v2f vert (appdata v) //Atribuir na vertex
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                o.vertex.z -= sin(_Time.z * _vertexAnimation);
                o.vertex.w -=  _vertexSize;

                o.normal = UnityObjectToWorldNormal(v.normal); //eh semelhante ao node "Position" no URP
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = fixed4(i.uv.xxx, 1); //Gradient color (Check UV)
                // sample the texture
                
                fixed4 col = tex2D(_MainTex, i.uv) + _Color;
                col.a *= _Alpha; //a = alpha dentro da unity (Ta aplicando o alpha na textura inteira)
                //return col;

                float fresnelCalc = 1 - max(0, dot(i.normal, i.viewDir)); //instancia o fresnel
                fresnelCalc = pow(fresnelCalc, _FresnelRamp) * _FresnelPower; //pow = Power node
                //return fresnelCalc;

                col = fresnelCalc + col;
                return col;
            }
            ENDCG
        }
    }
}
