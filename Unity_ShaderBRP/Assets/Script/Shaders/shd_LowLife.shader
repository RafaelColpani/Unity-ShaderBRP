Shader "_Custom/LowLife"
{
    Properties
    {
        [Header(Conf Textura)] [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Gradient Color", color) = (1,1,1,1)
        [Space(10)]

        [Header(Fresnel)] [Space(5)]
        _FresnelPower("Fresnel Power", Range(0.0, 10.0)) = 2
        _FresnelRamp("Fresnel Ramp", Range(0.0, 10.0)) = 1
        [Space(10)]
        
        [Header(Alpha)] [Space(5)]
        _Alpha("Alpha", Range(0.0, 1.0)) = 0.4
        [Space(10)]
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
            //Texture
            sampler2D _MainTex;
            float4 _MainTex_ST;

            //Alpha
            float _Alpha;

            //Fresnel
            float _FresnelPower, _FresnelRamp;
            
            v2f vert (appdata v)
            {
                v2f o;

                //Animation
                v.vertex.xy += sin(_Time.y * _VertexAnimationSpeed + v.vertex.xy * _VertexAnimationOffset.x); 
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {   
                //Texture + color
                fixed4 col = tex2D(_MainTex, i.uv) + _Color;
                
                //Alpha
                col.a *= _Alpha;
                
                //Fresnel
                float fresnelCalc = 1 - max(0, dot(i.normal, i.viewDir)); //instancia o fresnel
                fresnelCalc = pow(fresnelCalc, _FresnelRamp) * _FresnelPower; //pow = Power node
                
                //Return
                col = fresnelCalc + col;
                return col;
            }
            ENDCG
        }
    }
}