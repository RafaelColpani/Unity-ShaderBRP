Shader "_Custom/Flames"
{
    Properties
    {
        [Header(Conf Textura)] [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", color) = (1,1,1,1)
        [Space(15)]

        [Header(Conf Alpha)] [Space(5)]
        _Alpha("Alpha", Range(0.0, 1.0)) = 0.443    
        [Space(15)]

        [Header(Animation)] [Space(5)]
        _VertexAnimationSpeed("Vertex Animation Speed", Range(0.0, 10.0)) = 0
        _VertexAnimationOffset("Vertex Animation Offset", Range(0.0, 4.0)) = 0
    }   
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
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

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _Color;
            float _Alpha;
            float _VertexAnimationSpeed, _VertexAnimationOffset;

            v2f vert (appdata v)
            {
                v2f o;

                //Pega a metade da UV e a anima
                if(v.uv.y < 0.5)
                {
                    v.vertex.xy += sin(_Time.y * _VertexAnimationSpeed + v.vertex.xy * _VertexAnimationOffset.x); 
            
                }
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) + _Color;
                col.a *= _Alpha;

                return col;
            }
            ENDCG
        }
    }
}
