Shader "_Custom/WaterEffect"
{
    Properties
    {
        [Header(All Texture)] [Space(5)]
        _WaterTexture("Water Texture", 2D) = "white" {}
        [Space(15)]

        [Header(Conf Alpha)] [Space(5)]
        _Alpha("Alpha", Range(0.0, 1.0)) = 0.443    
        [Space(15)]

        [Header(Fresnel)] [Space(5)]
        _FresnelPower("Fresnel Power", Range(0.0, 10.0)) = 2
        _FresnelRamp("Fresnel Ramp", Range(0.0, 10.0)) = 1
        [Space(10)]

        [Header(Vertex Config)] [Space(5)]
        _vertexSize("Vertex Size", Range(0, 0.5)) = 0
        _vertexAnimation("Vertex Animation", Range(0, 1)) = 0
        
    }   

    SubShader
    {
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100
        AlphaToMask on
        //zWrite Off
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

                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;

                float3 normal : TEXCOORD1; 
                float3 viewDir : TEXCOORD2;
            };


            //Textura
            sampler2D _WaterTexture;
            float4 _WaterTexture_ST;
            float _Alpha;

            float _FresnelPower, _FresnelRamp;
            float _vertexSize, _vertexAnimation;

            
            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);

                //Vertex
                
                v.vertex.xy += sin(_Time.z * _vertexAnimation + v.vertex.y + _vertexSize);
                o.vertex =  UnityObjectToClipPos(v.vertex);
                //o.uv = v.uv;
                


                //Fresnel effect
                o.normal = UnityObjectToWorldNormal(v.normal); //eh semelhante ao node "Position" no URP
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));

                o.uv = TRANSFORM_TEX(v.uv, _WaterTexture);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {   
                //Textura
                fixed4 col = tex2D(_WaterTexture, i.uv);

                //Alpha
                col.a *= _Alpha; 

                //Fresenl
                float fresnelCalc = 1 - max(0, dot(i.normal, i.viewDir)); 
                fresnelCalc = pow(fresnelCalc, _FresnelRamp) * _FresnelPower; 

                //Return material
                return col + fresnelCalc;
            }
            ENDCG
        }
    }
}