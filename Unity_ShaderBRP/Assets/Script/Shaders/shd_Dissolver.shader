Shader "_Custom/shd_Dissolver"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}  
        _NoiseTex ("Noise Texture", 2D) = "white" {}  

        _Color ("Color", Color) = (1, 1, 1, 1)

        _Intensity("Intensity", Float) = 1
        _Ramp("Ramp", Float) = 1
        _Noise("_Noise", Float) = 0.5
    }

    SubShader
    {
        //Tags { "RenderType"="Opaque" } 
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent" } 
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

            sampler2D _MainTex, _NoiseTex;  
            float4 _MainTex_ST, _NoiseTex_ST;

            fixed4 _Color;
            fixed _Ramp, _Intensity, _Noise;  

            v2f vert (appdata v)
            {
                v2f o;  
                o.vertex = UnityObjectToClipPos(v.vertex); 
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); 

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 col = tex2D(_MainTex, i.uv); 
                
                fixed lumiance = Luminance(col);
                fixed3 mainColor = lumiance * _Color;
                mainColor = pow(mainColor, _Ramp) * _Intensity;

                fixed3 noiseTex = tex2D(_NoiseTex, i.uv);
                fixed noiseMove = abs(sin(noiseTex.r * 10  + _Time.y));
                noiseMove = step(noiseMove, _Noise);

                //return fixed4 (mainColor * noiseMove.rrr, 1);  
                return fixed4 (mainColor * noiseMove, noiseMove);  
            }
            ENDCG  
        }
    }
}