Shader "_Custom/shd_Laser"
{
    Properties
    {
        [Header(Conf Textura)] [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color", color) = (1,1,1,1)
        _Gamma ("Gamma", Range (0, 1)) = 0
        [Space(15)]

        [Header(Conf Alpha)] [Space(5)]
        _Alpha("Alpha", Range(0.0, 1.0)) = 0.5    
        [Space(15)]

        [Header(Animation)] [Space(5)]
        _VertexAnimation("Animation", Vector) = (0, 0, 0, 0)
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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _Color;
            float _Alpha, _Gamma;
            float4 _VertexAnimation;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                v.uv += _VertexAnimation.xy * frac(_Time.yy);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a *= _Alpha;

                return col * _Color + _Gamma;
            }
            ENDCG
        }
    }
}
