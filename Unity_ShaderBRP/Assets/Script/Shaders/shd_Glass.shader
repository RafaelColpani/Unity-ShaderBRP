Shader "_Custom/shd_Glass"
{
    Properties
    {
        [Header(Texture)] [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}  
        [Space(15)]
        
        [Header(Color)] [Space(5)]
        _Color ("Color", Color) = (1, 1, 1, 1)
        [Space(15)]
        
        [Header(Texture Config)] [Space(5)]
        _Intensity("Intensity", Float) = 1
        _Ramp("Ramp", Float) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }  
        LOD 100  
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
            fixed _Ramp, _Intensity;  

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
                
                //Retorna um grayscale
                fixed4 lumiance = Luminance(col);

                //2 return para dar o efeito da camera
                return lumiance;
                return col;  
            }
            ENDCG  
        }
    }
}