Shader "_Custom/shd_Water"
{
    Properties
    {
        [Header(Texturas)] [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}  
        _EffectTex ("Effect Texture", 2D) = "white" {}  
        _Color("Color", color) = (1,1,1,1)
        [Space(15)]

        [Header(Wave Texture Effect)] [Space(5)]
        _OpenEffect ("Open Effect", Range(0.01, 0.1)) = 0.0415
        _CloseEffect ("Close Effect", Range(0.1, 1.0)) = 0.646
        _Intensity("Intensity", Range(0.1, 15.0)) = 9.9
        [Space(15)]

        [Header(Animation)] [Space(5)]
        _PosAnimation("Animation Pos", Vector) = (0, 1, 0, 0)
        _time ("Time", Range(0.1, 1.0)) = 0.377
        [Space(15)]

        [Header(Alpha)] [Space(5)]
        _AlphaTexture("Alpha Texture", Range(0.1, 1.0)) = 0.685
    }

    SubShader
    {
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
            
            //
            sampler2D _MainTex, _EffectTex;  
            float4 _MainTex_ST, _EffectTex_ST;  

            fixed4 _Color;
            float _OpenEffect, _CloseEffect, _Intensity, _AlphaTexture, _time;
            float4 _PosAnimation;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                //UV Animation 
                v.uv += _PosAnimation * frac(_Time.y * _time);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex); 

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
               
               
                //float2 centralPointUV = i.uv * 2 - 1; _PosAnimation
                float2 centralPointUV = i.uv * 2 - 1  -  _PosAnimation; 

                //float2 ring = length(centralPointUV);

                float timer = frac(_Time.y * _time);

                float len = length(centralPointUV);

                float UpperRing = smoothstep(len + _OpenEffect, len - _CloseEffect, timer);

                float inverseRing = 1 - UpperRing;

                float finalRing = UpperRing * inverseRing;

                float finaUV = i.uv - centralPointUV * finalRing * _Intensity * (1 - timer);
                
                //Textures
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 colTex = tex2D(_EffectTex, finaUV) * _Color;

                //Alpha
                col.a *= _AlphaTexture;

                //return
                return col + colTex; 
            }
            ENDCG  
        }
    }
}