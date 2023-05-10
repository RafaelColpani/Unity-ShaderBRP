Shader "_Custom/shd_Dissolver"
{   
    //Variaveis para o inspector
    Properties
    {
        [Header(All Texture)] [Space(5)]
        _MainTex ("Main Texture", 2D) = "white" {}
        _StepIn("aaa", Float) = 0

    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 300
    
        CGPROGRAM
        #pragma surface surf BlinnPhong 
        #pragma target 4.6

        //meshdata (dados da mesh)
        struct appdata
        {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
        };
            
        struct Input 
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;

            float3 viewDir;
        };

        sampler2D _MainTex;
        float4 _StepIn;

        //Function apra criar o Step 
        //https://docs.unity3d.com/Packages/com.unity.shadergraph@6.9/manual/Step-Node.html
        void Unity_Step_float4(float4 Edge, float4 In, out float4 o)
        {
            Edge = 1, 0, 0, 0;
            In = _StepIn;
            o = step(Edge, In);
        }

        
        void surf (Input IN, inout SurfaceOutput o) 
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgba;
        }

      ENDCG
    }
    Fallback "Diffuse"
}
