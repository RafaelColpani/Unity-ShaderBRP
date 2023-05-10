Shader "_Custom/shd_Ice"
{   
    //Variaveis para o inspector
    Properties
    {
        [Header(All Texture)] [Space(5)]
        _MainTex ("Main Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        [Space(15)]

        [Header(Tessellation Config)] [Space(5)]
        _heightTex  ("Height Texture", 2D) = "gray" {}
        _Displacement ("Displacement", Range(0, 2.0)) = 0.3
        [Space(15)]

        [Header(Specular Config)] [Space(5)]
        _SpecColor ("Specular color", color) = (0, 0, 0, 0)
        _SpecRange ("Specular Range", Range(0.058, 1.0)) = 1.0
        _SpecIntensity ("Specular intensity", Range(0, 10.0)) = 1.0
        [Space(15)]

        [Header(Fresnel Config)] [Space(5)]
        _FresnelColor ("Fresnel Color", Color) = (0.26,0.19,0.16,0.0)
        _FresnelPower ("Fresnel Power", Range(0.5,8.0)) = 3.0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 300

        //Não posso usar o pass{} quando uso diferentes tipos de iluminação
        
        CGPROGRAM
        //Usando o modelo de iluminação BlinnPhong para o Specular
        #pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:height nolightmap 
        #pragma target 4.6

        //meshdata (dados da mesh)
        struct appdata
        {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
        };
            
        //Estrutura de entrada
        struct Input 
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;

            float3 viewDir;
        };

        //Variaveis para o codigo
        sampler2D _MainTex, _NormalMap, _heightTex;
        
        //Fresenl
        float4 _FresnelColor;
        float _FresnelPower, _SpecIntensity, _SpecRange, _Displacement;

        //Function apra criar o Tessellation
        //https://docs.unity3d.com/Manual/SL-SurfaceShaderTessellation.html
        void height(inout appdata v)
        {
            float configTessellation = tex2Dlod(_heightTex, float4(v.texcoord.xy, 0, 0)).r * _Displacement;
            v.vertex.xyz += v.normal * configTessellation;
        }

        //Define como os dados de entrada serão usados
        /* Definição do surf:
            IN = Input
            Inout = parâmetro é passado como referência para uma função e que o valor pode ser modificado pela função
            SurfaceOutput o = estrutura que define as informações de saída do shader
            Surf = Responsável por definir os valores de saída para cada pixel renderizado
        */
        void surf (Input IN, inout SurfaceOutput o) 
        {
            /* Definição do col:
                o = Output
                o.Albedo = Representa a cor do material na superfície
                IN.uv_MainTex = Pega acordenada da textura = float4 _MainTex_ST;
                rgb = Pega so a cor da textura
            */
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgba;

            //Fresnel
            half configFresnel = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
            o.Emission = _FresnelColor.rgb * pow (configFresnel, _FresnelPower);

            //Specular
            o.Specular = _SpecRange;
            o.Gloss = _SpecIntensity; //Gloss = Intencidade do Specular

            //UnpackNormal = descompacta um valor normal armazenado em um mapa de textura
            o.Normal = UnpackNormal(tex2D (_NormalMap, IN.uv_NormalMap));
        }

      ENDCG
    }
    //Se o shader não conseguir ser executado ele retorna como Diffuse
    Fallback "Diffuse"
}
