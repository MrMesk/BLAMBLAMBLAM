Shader "Unlit Master"
{
    Properties
    {
        Vector4_BB4A05DE("Rotate Projection", Vector) = (1, 0, 0, 0)
        Vector1_90375CD9("Noise Scale", Float) = 10
        Vector1_2054E851("Noise Speed", Float) = 0.1
        Vector1_1A1B6BF6("Noise Height", Float) = 1
        Vector4_67B432D6("Noise Remap", Vector) = (0, 0, 0, 0)
        [HDR]Color_9C65A9BE("Color Peak", Color) = (0, 0, 0, 0)
        [HDR]Color_BA7844FA("Color Valley", Color) = (4.924578, 4.924578, 4.924578, 0)
        Vector1_F1A2C64C("Noise Edge 1", Float) = 0
        Vector1_5751AA70("Noise Edge 2", Float) = 1
        Vector1_9325DD9F("Noise Power", Float) = 2
        Vector1_84571B0F("Base Scale", Float) = 5
        Vector1_3815E790("Base Speed", Float) = 1
        Vector1_F74AD796("Base Strength", Float) = 1
        Vector1_F195D796("Emission Strength", Float) = 0
        Vector1_94E8DF3("Curvature Radius", Float) = 1
        Vector1_C2E29679("Fade Depth", Float) = 1000
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent+0"
        }
        
        Pass
        {
            Name "Pass"
            Tags 
            { 
                // LightMode: <None>
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma shader_feature _ _SAMPLE_GI
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_UNLIT
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_BB4A05DE;
            float Vector1_90375CD9;
            float Vector1_2054E851;
            float Vector1_1A1B6BF6;
            float4 Vector4_67B432D6;
            float4 Color_9C65A9BE;
            float4 Color_BA7844FA;
            float Vector1_F1A2C64C;
            float Vector1_5751AA70;
            float Vector1_9325DD9F;
            float Vector1_84571B0F;
            float Vector1_3815E790;
            float Vector1_F74AD796;
            float Vector1_F195D796;
            float Vector1_94E8DF3;
            float Vector1_C2E29679;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Property_4F4BC94_Out_0 = Vector1_F1A2C64C;
                float _Property_3B11A91B_Out_0 = Vector1_5751AA70;
                float4 _Property_6385DF_Out_0 = Vector4_BB4A05DE;
                float _Split_EC8AF49C_R_1 = _Property_6385DF_Out_0[0];
                float _Split_EC8AF49C_G_2 = _Property_6385DF_Out_0[1];
                float _Split_EC8AF49C_B_3 = _Property_6385DF_Out_0[2];
                float _Split_EC8AF49C_A_4 = _Property_6385DF_Out_0[3];
                float3 _RotateAboutAxis_394A7E2F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_6385DF_Out_0.xyz), _Split_EC8AF49C_A_4, _RotateAboutAxis_394A7E2F_Out_3);
                float _Property_B3784067_Out_0 = Vector1_2054E851;
                float _Multiply_BD5D9623_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_B3784067_Out_0, _Multiply_BD5D9623_Out_2);
                float2 _TilingAndOffset_D8BEF97F_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), (_Multiply_BD5D9623_Out_2.xx), _TilingAndOffset_D8BEF97F_Out_3);
                float _Property_DC3D85C0_Out_0 = Vector1_90375CD9;
                float _GradientNoise_FE674E0_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_D8BEF97F_Out_3, _Property_DC3D85C0_Out_0, _GradientNoise_FE674E0_Out_2);
                float2 _TilingAndOffset_7F5C5522_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7F5C5522_Out_3);
                float _GradientNoise_910492E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7F5C5522_Out_3, _Property_DC3D85C0_Out_0, _GradientNoise_910492E_Out_2);
                float _Add_D53A0B66_Out_2;
                Unity_Add_float(_GradientNoise_FE674E0_Out_2, _GradientNoise_910492E_Out_2, _Add_D53A0B66_Out_2);
                float _Divide_D8AA1351_Out_2;
                Unity_Divide_float(_Add_D53A0B66_Out_2, 2, _Divide_D8AA1351_Out_2);
                float _Saturate_B075C8F_Out_1;
                Unity_Saturate_float(_Divide_D8AA1351_Out_2, _Saturate_B075C8F_Out_1);
                float _Property_80ABB889_Out_0 = Vector1_9325DD9F;
                float _Power_8DECBE9E_Out_2;
                Unity_Power_float(_Saturate_B075C8F_Out_1, _Property_80ABB889_Out_0, _Power_8DECBE9E_Out_2);
                float4 _Property_E1931619_Out_0 = Vector4_67B432D6;
                float _Split_F4280DE9_R_1 = _Property_E1931619_Out_0[0];
                float _Split_F4280DE9_G_2 = _Property_E1931619_Out_0[1];
                float _Split_F4280DE9_B_3 = _Property_E1931619_Out_0[2];
                float _Split_F4280DE9_A_4 = _Property_E1931619_Out_0[3];
                float4 _Combine_8392993F_RGBA_4;
                float3 _Combine_8392993F_RGB_5;
                float2 _Combine_8392993F_RG_6;
                Unity_Combine_float(_Split_F4280DE9_R_1, _Split_F4280DE9_G_2, 0, 0, _Combine_8392993F_RGBA_4, _Combine_8392993F_RGB_5, _Combine_8392993F_RG_6);
                float4 _Combine_E4DC68AA_RGBA_4;
                float3 _Combine_E4DC68AA_RGB_5;
                float2 _Combine_E4DC68AA_RG_6;
                Unity_Combine_float(_Split_F4280DE9_B_3, _Split_F4280DE9_A_4, 0, 0, _Combine_E4DC68AA_RGBA_4, _Combine_E4DC68AA_RGB_5, _Combine_E4DC68AA_RG_6);
                float _Remap_A0DC06D3_Out_3;
                Unity_Remap_float(_Power_8DECBE9E_Out_2, _Combine_8392993F_RG_6, _Combine_E4DC68AA_RG_6, _Remap_A0DC06D3_Out_3);
                float _Absolute_7998CC52_Out_1;
                Unity_Absolute_float(_Remap_A0DC06D3_Out_3, _Absolute_7998CC52_Out_1);
                float _Smoothstep_5A2E05E5_Out_3;
                Unity_Smoothstep_float(_Property_4F4BC94_Out_0, _Property_3B11A91B_Out_0, _Absolute_7998CC52_Out_1, _Smoothstep_5A2E05E5_Out_3);
                float _Property_56E8314A_Out_0 = Vector1_F74AD796;
                float _Property_62A32639_Out_0 = Vector1_3815E790;
                float _Multiply_91E9E681_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_62A32639_Out_0, _Multiply_91E9E681_Out_2);
                float2 _TilingAndOffset_D8A7602C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), (_Multiply_91E9E681_Out_2.xx), _TilingAndOffset_D8A7602C_Out_3);
                float _Property_F82D9F2D_Out_0 = Vector1_84571B0F;
                float _GradientNoise_3BA44727_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_D8A7602C_Out_3, _Property_F82D9F2D_Out_0, _GradientNoise_3BA44727_Out_2);
                float _Multiply_B1070B53_Out_2;
                Unity_Multiply_float(_Property_56E8314A_Out_0, _GradientNoise_3BA44727_Out_2, _Multiply_B1070B53_Out_2);
                float _Add_662237EB_Out_2;
                Unity_Add_float(_Smoothstep_5A2E05E5_Out_3, _Multiply_B1070B53_Out_2, _Add_662237EB_Out_2);
                float _Add_EF2BAD9E_Out_2;
                Unity_Add_float(1, _Property_56E8314A_Out_0, _Add_EF2BAD9E_Out_2);
                float _Divide_98E30F0_Out_2;
                Unity_Divide_float(_Add_662237EB_Out_2, _Add_EF2BAD9E_Out_2, _Divide_98E30F0_Out_2);
                float3 _Multiply_BE699F73_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_98E30F0_Out_2.xxx), _Multiply_BE699F73_Out_2);
                float _Property_71EA8396_Out_0 = Vector1_1A1B6BF6;
                float3 _Multiply_35A54FBD_Out_2;
                Unity_Multiply_float(_Multiply_BE699F73_Out_2, (_Property_71EA8396_Out_0.xxx), _Multiply_35A54FBD_Out_2);
                float3 _Add_CC20ED78_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_35A54FBD_Out_2, _Add_CC20ED78_Out_2);
                description.VertexPosition = _Add_CC20ED78_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Color;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_35D419CB_Out_0 = Color_BA7844FA;
                float4 _Property_C26FE511_Out_0 = Color_9C65A9BE;
                float _Property_4F4BC94_Out_0 = Vector1_F1A2C64C;
                float _Property_3B11A91B_Out_0 = Vector1_5751AA70;
                float4 _Property_6385DF_Out_0 = Vector4_BB4A05DE;
                float _Split_EC8AF49C_R_1 = _Property_6385DF_Out_0[0];
                float _Split_EC8AF49C_G_2 = _Property_6385DF_Out_0[1];
                float _Split_EC8AF49C_B_3 = _Property_6385DF_Out_0[2];
                float _Split_EC8AF49C_A_4 = _Property_6385DF_Out_0[3];
                float3 _RotateAboutAxis_394A7E2F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_6385DF_Out_0.xyz), _Split_EC8AF49C_A_4, _RotateAboutAxis_394A7E2F_Out_3);
                float _Property_B3784067_Out_0 = Vector1_2054E851;
                float _Multiply_BD5D9623_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_B3784067_Out_0, _Multiply_BD5D9623_Out_2);
                float2 _TilingAndOffset_D8BEF97F_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), (_Multiply_BD5D9623_Out_2.xx), _TilingAndOffset_D8BEF97F_Out_3);
                float _Property_DC3D85C0_Out_0 = Vector1_90375CD9;
                float _GradientNoise_FE674E0_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_D8BEF97F_Out_3, _Property_DC3D85C0_Out_0, _GradientNoise_FE674E0_Out_2);
                float2 _TilingAndOffset_7F5C5522_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7F5C5522_Out_3);
                float _GradientNoise_910492E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7F5C5522_Out_3, _Property_DC3D85C0_Out_0, _GradientNoise_910492E_Out_2);
                float _Add_D53A0B66_Out_2;
                Unity_Add_float(_GradientNoise_FE674E0_Out_2, _GradientNoise_910492E_Out_2, _Add_D53A0B66_Out_2);
                float _Divide_D8AA1351_Out_2;
                Unity_Divide_float(_Add_D53A0B66_Out_2, 2, _Divide_D8AA1351_Out_2);
                float _Saturate_B075C8F_Out_1;
                Unity_Saturate_float(_Divide_D8AA1351_Out_2, _Saturate_B075C8F_Out_1);
                float _Property_80ABB889_Out_0 = Vector1_9325DD9F;
                float _Power_8DECBE9E_Out_2;
                Unity_Power_float(_Saturate_B075C8F_Out_1, _Property_80ABB889_Out_0, _Power_8DECBE9E_Out_2);
                float4 _Property_E1931619_Out_0 = Vector4_67B432D6;
                float _Split_F4280DE9_R_1 = _Property_E1931619_Out_0[0];
                float _Split_F4280DE9_G_2 = _Property_E1931619_Out_0[1];
                float _Split_F4280DE9_B_3 = _Property_E1931619_Out_0[2];
                float _Split_F4280DE9_A_4 = _Property_E1931619_Out_0[3];
                float4 _Combine_8392993F_RGBA_4;
                float3 _Combine_8392993F_RGB_5;
                float2 _Combine_8392993F_RG_6;
                Unity_Combine_float(_Split_F4280DE9_R_1, _Split_F4280DE9_G_2, 0, 0, _Combine_8392993F_RGBA_4, _Combine_8392993F_RGB_5, _Combine_8392993F_RG_6);
                float4 _Combine_E4DC68AA_RGBA_4;
                float3 _Combine_E4DC68AA_RGB_5;
                float2 _Combine_E4DC68AA_RG_6;
                Unity_Combine_float(_Split_F4280DE9_B_3, _Split_F4280DE9_A_4, 0, 0, _Combine_E4DC68AA_RGBA_4, _Combine_E4DC68AA_RGB_5, _Combine_E4DC68AA_RG_6);
                float _Remap_A0DC06D3_Out_3;
                Unity_Remap_float(_Power_8DECBE9E_Out_2, _Combine_8392993F_RG_6, _Combine_E4DC68AA_RG_6, _Remap_A0DC06D3_Out_3);
                float _Absolute_7998CC52_Out_1;
                Unity_Absolute_float(_Remap_A0DC06D3_Out_3, _Absolute_7998CC52_Out_1);
                float _Smoothstep_5A2E05E5_Out_3;
                Unity_Smoothstep_float(_Property_4F4BC94_Out_0, _Property_3B11A91B_Out_0, _Absolute_7998CC52_Out_1, _Smoothstep_5A2E05E5_Out_3);
                float _Property_56E8314A_Out_0 = Vector1_F74AD796;
                float _Property_62A32639_Out_0 = Vector1_3815E790;
                float _Multiply_91E9E681_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_62A32639_Out_0, _Multiply_91E9E681_Out_2);
                float2 _TilingAndOffset_D8A7602C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), (_Multiply_91E9E681_Out_2.xx), _TilingAndOffset_D8A7602C_Out_3);
                float _Property_F82D9F2D_Out_0 = Vector1_84571B0F;
                float _GradientNoise_3BA44727_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_D8A7602C_Out_3, _Property_F82D9F2D_Out_0, _GradientNoise_3BA44727_Out_2);
                float _Multiply_B1070B53_Out_2;
                Unity_Multiply_float(_Property_56E8314A_Out_0, _GradientNoise_3BA44727_Out_2, _Multiply_B1070B53_Out_2);
                float _Add_662237EB_Out_2;
                Unity_Add_float(_Smoothstep_5A2E05E5_Out_3, _Multiply_B1070B53_Out_2, _Add_662237EB_Out_2);
                float _Add_EF2BAD9E_Out_2;
                Unity_Add_float(1, _Property_56E8314A_Out_0, _Add_EF2BAD9E_Out_2);
                float _Divide_98E30F0_Out_2;
                Unity_Divide_float(_Add_662237EB_Out_2, _Add_EF2BAD9E_Out_2, _Divide_98E30F0_Out_2);
                float4 _Lerp_CD4D093C_Out_3;
                Unity_Lerp_float4(_Property_35D419CB_Out_0, _Property_C26FE511_Out_0, (_Divide_98E30F0_Out_2.xxxx), _Lerp_CD4D093C_Out_3);
                float _SceneDepth_21E7F1EA_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_21E7F1EA_Out_1);
                float4 _ScreenPosition_AB8F5F5E_Out_0 = IN.ScreenPosition;
                float _Split_65703DA5_R_1 = _ScreenPosition_AB8F5F5E_Out_0[0];
                float _Split_65703DA5_G_2 = _ScreenPosition_AB8F5F5E_Out_0[1];
                float _Split_65703DA5_B_3 = _ScreenPosition_AB8F5F5E_Out_0[2];
                float _Split_65703DA5_A_4 = _ScreenPosition_AB8F5F5E_Out_0[3];
                float _Subtract_2984ECBD_Out_2;
                Unity_Subtract_float(_Split_65703DA5_A_4, 1, _Subtract_2984ECBD_Out_2);
                float _Subtract_5CB4794D_Out_2;
                Unity_Subtract_float(_SceneDepth_21E7F1EA_Out_1, _Subtract_2984ECBD_Out_2, _Subtract_5CB4794D_Out_2);
                float _Property_807CA614_Out_0 = Vector1_C2E29679;
                float _Divide_16288DDF_Out_2;
                Unity_Divide_float(_Subtract_5CB4794D_Out_2, _Property_807CA614_Out_0, _Divide_16288DDF_Out_2);
                float _Saturate_8912304_Out_1;
                Unity_Saturate_float(_Divide_16288DDF_Out_2, _Saturate_8912304_Out_1);
                surface.Color = (_Lerp_CD4D093C_Out_3.xyz);
                surface.Alpha = _Saturate_8912304_Out_1;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "ShadowCaster"
            Tags 
            { 
                "LightMode" = "ShadowCaster"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_SHADOWCASTER
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_BB4A05DE;
            float Vector1_90375CD9;
            float Vector1_2054E851;
            float Vector1_1A1B6BF6;
            float4 Vector4_67B432D6;
            float4 Color_9C65A9BE;
            float4 Color_BA7844FA;
            float Vector1_F1A2C64C;
            float Vector1_5751AA70;
            float Vector1_9325DD9F;
            float Vector1_84571B0F;
            float Vector1_3815E790;
            float Vector1_F74AD796;
            float Vector1_F195D796;
            float Vector1_94E8DF3;
            float Vector1_C2E29679;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Property_4F4BC94_Out_0 = Vector1_F1A2C64C;
                float _Property_3B11A91B_Out_0 = Vector1_5751AA70;
                float4 _Property_6385DF_Out_0 = Vector4_BB4A05DE;
                float _Split_EC8AF49C_R_1 = _Property_6385DF_Out_0[0];
                float _Split_EC8AF49C_G_2 = _Property_6385DF_Out_0[1];
                float _Split_EC8AF49C_B_3 = _Property_6385DF_Out_0[2];
                float _Split_EC8AF49C_A_4 = _Property_6385DF_Out_0[3];
                float3 _RotateAboutAxis_394A7E2F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_6385DF_Out_0.xyz), _Split_EC8AF49C_A_4, _RotateAboutAxis_394A7E2F_Out_3);
                float _Property_B3784067_Out_0 = Vector1_2054E851;
                float _Multiply_BD5D9623_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_B3784067_Out_0, _Multiply_BD5D9623_Out_2);
                float2 _TilingAndOffset_D8BEF97F_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), (_Multiply_BD5D9623_Out_2.xx), _TilingAndOffset_D8BEF97F_Out_3);
                float _Property_DC3D85C0_Out_0 = Vector1_90375CD9;
                float _GradientNoise_FE674E0_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_D8BEF97F_Out_3, _Property_DC3D85C0_Out_0, _GradientNoise_FE674E0_Out_2);
                float2 _TilingAndOffset_7F5C5522_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7F5C5522_Out_3);
                float _GradientNoise_910492E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7F5C5522_Out_3, _Property_DC3D85C0_Out_0, _GradientNoise_910492E_Out_2);
                float _Add_D53A0B66_Out_2;
                Unity_Add_float(_GradientNoise_FE674E0_Out_2, _GradientNoise_910492E_Out_2, _Add_D53A0B66_Out_2);
                float _Divide_D8AA1351_Out_2;
                Unity_Divide_float(_Add_D53A0B66_Out_2, 2, _Divide_D8AA1351_Out_2);
                float _Saturate_B075C8F_Out_1;
                Unity_Saturate_float(_Divide_D8AA1351_Out_2, _Saturate_B075C8F_Out_1);
                float _Property_80ABB889_Out_0 = Vector1_9325DD9F;
                float _Power_8DECBE9E_Out_2;
                Unity_Power_float(_Saturate_B075C8F_Out_1, _Property_80ABB889_Out_0, _Power_8DECBE9E_Out_2);
                float4 _Property_E1931619_Out_0 = Vector4_67B432D6;
                float _Split_F4280DE9_R_1 = _Property_E1931619_Out_0[0];
                float _Split_F4280DE9_G_2 = _Property_E1931619_Out_0[1];
                float _Split_F4280DE9_B_3 = _Property_E1931619_Out_0[2];
                float _Split_F4280DE9_A_4 = _Property_E1931619_Out_0[3];
                float4 _Combine_8392993F_RGBA_4;
                float3 _Combine_8392993F_RGB_5;
                float2 _Combine_8392993F_RG_6;
                Unity_Combine_float(_Split_F4280DE9_R_1, _Split_F4280DE9_G_2, 0, 0, _Combine_8392993F_RGBA_4, _Combine_8392993F_RGB_5, _Combine_8392993F_RG_6);
                float4 _Combine_E4DC68AA_RGBA_4;
                float3 _Combine_E4DC68AA_RGB_5;
                float2 _Combine_E4DC68AA_RG_6;
                Unity_Combine_float(_Split_F4280DE9_B_3, _Split_F4280DE9_A_4, 0, 0, _Combine_E4DC68AA_RGBA_4, _Combine_E4DC68AA_RGB_5, _Combine_E4DC68AA_RG_6);
                float _Remap_A0DC06D3_Out_3;
                Unity_Remap_float(_Power_8DECBE9E_Out_2, _Combine_8392993F_RG_6, _Combine_E4DC68AA_RG_6, _Remap_A0DC06D3_Out_3);
                float _Absolute_7998CC52_Out_1;
                Unity_Absolute_float(_Remap_A0DC06D3_Out_3, _Absolute_7998CC52_Out_1);
                float _Smoothstep_5A2E05E5_Out_3;
                Unity_Smoothstep_float(_Property_4F4BC94_Out_0, _Property_3B11A91B_Out_0, _Absolute_7998CC52_Out_1, _Smoothstep_5A2E05E5_Out_3);
                float _Property_56E8314A_Out_0 = Vector1_F74AD796;
                float _Property_62A32639_Out_0 = Vector1_3815E790;
                float _Multiply_91E9E681_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_62A32639_Out_0, _Multiply_91E9E681_Out_2);
                float2 _TilingAndOffset_D8A7602C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), (_Multiply_91E9E681_Out_2.xx), _TilingAndOffset_D8A7602C_Out_3);
                float _Property_F82D9F2D_Out_0 = Vector1_84571B0F;
                float _GradientNoise_3BA44727_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_D8A7602C_Out_3, _Property_F82D9F2D_Out_0, _GradientNoise_3BA44727_Out_2);
                float _Multiply_B1070B53_Out_2;
                Unity_Multiply_float(_Property_56E8314A_Out_0, _GradientNoise_3BA44727_Out_2, _Multiply_B1070B53_Out_2);
                float _Add_662237EB_Out_2;
                Unity_Add_float(_Smoothstep_5A2E05E5_Out_3, _Multiply_B1070B53_Out_2, _Add_662237EB_Out_2);
                float _Add_EF2BAD9E_Out_2;
                Unity_Add_float(1, _Property_56E8314A_Out_0, _Add_EF2BAD9E_Out_2);
                float _Divide_98E30F0_Out_2;
                Unity_Divide_float(_Add_662237EB_Out_2, _Add_EF2BAD9E_Out_2, _Divide_98E30F0_Out_2);
                float3 _Multiply_BE699F73_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_98E30F0_Out_2.xxx), _Multiply_BE699F73_Out_2);
                float _Property_71EA8396_Out_0 = Vector1_1A1B6BF6;
                float3 _Multiply_35A54FBD_Out_2;
                Unity_Multiply_float(_Multiply_BE699F73_Out_2, (_Property_71EA8396_Out_0.xxx), _Multiply_35A54FBD_Out_2);
                float3 _Add_CC20ED78_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_35A54FBD_Out_2, _Add_CC20ED78_Out_2);
                description.VertexPosition = _Add_CC20ED78_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_21E7F1EA_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_21E7F1EA_Out_1);
                float4 _ScreenPosition_AB8F5F5E_Out_0 = IN.ScreenPosition;
                float _Split_65703DA5_R_1 = _ScreenPosition_AB8F5F5E_Out_0[0];
                float _Split_65703DA5_G_2 = _ScreenPosition_AB8F5F5E_Out_0[1];
                float _Split_65703DA5_B_3 = _ScreenPosition_AB8F5F5E_Out_0[2];
                float _Split_65703DA5_A_4 = _ScreenPosition_AB8F5F5E_Out_0[3];
                float _Subtract_2984ECBD_Out_2;
                Unity_Subtract_float(_Split_65703DA5_A_4, 1, _Subtract_2984ECBD_Out_2);
                float _Subtract_5CB4794D_Out_2;
                Unity_Subtract_float(_SceneDepth_21E7F1EA_Out_1, _Subtract_2984ECBD_Out_2, _Subtract_5CB4794D_Out_2);
                float _Property_807CA614_Out_0 = Vector1_C2E29679;
                float _Divide_16288DDF_Out_2;
                Unity_Divide_float(_Subtract_5CB4794D_Out_2, _Property_807CA614_Out_0, _Divide_16288DDF_Out_2);
                float _Saturate_8912304_Out_1;
                Unity_Saturate_float(_Divide_16288DDF_Out_2, _Saturate_8912304_Out_1);
                surface.Alpha = _Saturate_8912304_Out_1;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "DepthOnly"
            Tags 
            { 
                "LightMode" = "DepthOnly"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            ColorMask 0
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_DEPTHONLY
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_BB4A05DE;
            float Vector1_90375CD9;
            float Vector1_2054E851;
            float Vector1_1A1B6BF6;
            float4 Vector4_67B432D6;
            float4 Color_9C65A9BE;
            float4 Color_BA7844FA;
            float Vector1_F1A2C64C;
            float Vector1_5751AA70;
            float Vector1_9325DD9F;
            float Vector1_84571B0F;
            float Vector1_3815E790;
            float Vector1_F74AD796;
            float Vector1_F195D796;
            float Vector1_94E8DF3;
            float Vector1_C2E29679;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float3 WorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Property_4F4BC94_Out_0 = Vector1_F1A2C64C;
                float _Property_3B11A91B_Out_0 = Vector1_5751AA70;
                float4 _Property_6385DF_Out_0 = Vector4_BB4A05DE;
                float _Split_EC8AF49C_R_1 = _Property_6385DF_Out_0[0];
                float _Split_EC8AF49C_G_2 = _Property_6385DF_Out_0[1];
                float _Split_EC8AF49C_B_3 = _Property_6385DF_Out_0[2];
                float _Split_EC8AF49C_A_4 = _Property_6385DF_Out_0[3];
                float3 _RotateAboutAxis_394A7E2F_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_6385DF_Out_0.xyz), _Split_EC8AF49C_A_4, _RotateAboutAxis_394A7E2F_Out_3);
                float _Property_B3784067_Out_0 = Vector1_2054E851;
                float _Multiply_BD5D9623_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_B3784067_Out_0, _Multiply_BD5D9623_Out_2);
                float2 _TilingAndOffset_D8BEF97F_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), (_Multiply_BD5D9623_Out_2.xx), _TilingAndOffset_D8BEF97F_Out_3);
                float _Property_DC3D85C0_Out_0 = Vector1_90375CD9;
                float _GradientNoise_FE674E0_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_D8BEF97F_Out_3, _Property_DC3D85C0_Out_0, _GradientNoise_FE674E0_Out_2);
                float2 _TilingAndOffset_7F5C5522_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_7F5C5522_Out_3);
                float _GradientNoise_910492E_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_7F5C5522_Out_3, _Property_DC3D85C0_Out_0, _GradientNoise_910492E_Out_2);
                float _Add_D53A0B66_Out_2;
                Unity_Add_float(_GradientNoise_FE674E0_Out_2, _GradientNoise_910492E_Out_2, _Add_D53A0B66_Out_2);
                float _Divide_D8AA1351_Out_2;
                Unity_Divide_float(_Add_D53A0B66_Out_2, 2, _Divide_D8AA1351_Out_2);
                float _Saturate_B075C8F_Out_1;
                Unity_Saturate_float(_Divide_D8AA1351_Out_2, _Saturate_B075C8F_Out_1);
                float _Property_80ABB889_Out_0 = Vector1_9325DD9F;
                float _Power_8DECBE9E_Out_2;
                Unity_Power_float(_Saturate_B075C8F_Out_1, _Property_80ABB889_Out_0, _Power_8DECBE9E_Out_2);
                float4 _Property_E1931619_Out_0 = Vector4_67B432D6;
                float _Split_F4280DE9_R_1 = _Property_E1931619_Out_0[0];
                float _Split_F4280DE9_G_2 = _Property_E1931619_Out_0[1];
                float _Split_F4280DE9_B_3 = _Property_E1931619_Out_0[2];
                float _Split_F4280DE9_A_4 = _Property_E1931619_Out_0[3];
                float4 _Combine_8392993F_RGBA_4;
                float3 _Combine_8392993F_RGB_5;
                float2 _Combine_8392993F_RG_6;
                Unity_Combine_float(_Split_F4280DE9_R_1, _Split_F4280DE9_G_2, 0, 0, _Combine_8392993F_RGBA_4, _Combine_8392993F_RGB_5, _Combine_8392993F_RG_6);
                float4 _Combine_E4DC68AA_RGBA_4;
                float3 _Combine_E4DC68AA_RGB_5;
                float2 _Combine_E4DC68AA_RG_6;
                Unity_Combine_float(_Split_F4280DE9_B_3, _Split_F4280DE9_A_4, 0, 0, _Combine_E4DC68AA_RGBA_4, _Combine_E4DC68AA_RGB_5, _Combine_E4DC68AA_RG_6);
                float _Remap_A0DC06D3_Out_3;
                Unity_Remap_float(_Power_8DECBE9E_Out_2, _Combine_8392993F_RG_6, _Combine_E4DC68AA_RG_6, _Remap_A0DC06D3_Out_3);
                float _Absolute_7998CC52_Out_1;
                Unity_Absolute_float(_Remap_A0DC06D3_Out_3, _Absolute_7998CC52_Out_1);
                float _Smoothstep_5A2E05E5_Out_3;
                Unity_Smoothstep_float(_Property_4F4BC94_Out_0, _Property_3B11A91B_Out_0, _Absolute_7998CC52_Out_1, _Smoothstep_5A2E05E5_Out_3);
                float _Property_56E8314A_Out_0 = Vector1_F74AD796;
                float _Property_62A32639_Out_0 = Vector1_3815E790;
                float _Multiply_91E9E681_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_62A32639_Out_0, _Multiply_91E9E681_Out_2);
                float2 _TilingAndOffset_D8A7602C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_394A7E2F_Out_3.xy), float2 (1, 1), (_Multiply_91E9E681_Out_2.xx), _TilingAndOffset_D8A7602C_Out_3);
                float _Property_F82D9F2D_Out_0 = Vector1_84571B0F;
                float _GradientNoise_3BA44727_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_D8A7602C_Out_3, _Property_F82D9F2D_Out_0, _GradientNoise_3BA44727_Out_2);
                float _Multiply_B1070B53_Out_2;
                Unity_Multiply_float(_Property_56E8314A_Out_0, _GradientNoise_3BA44727_Out_2, _Multiply_B1070B53_Out_2);
                float _Add_662237EB_Out_2;
                Unity_Add_float(_Smoothstep_5A2E05E5_Out_3, _Multiply_B1070B53_Out_2, _Add_662237EB_Out_2);
                float _Add_EF2BAD9E_Out_2;
                Unity_Add_float(1, _Property_56E8314A_Out_0, _Add_EF2BAD9E_Out_2);
                float _Divide_98E30F0_Out_2;
                Unity_Divide_float(_Add_662237EB_Out_2, _Add_EF2BAD9E_Out_2, _Divide_98E30F0_Out_2);
                float3 _Multiply_BE699F73_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_98E30F0_Out_2.xxx), _Multiply_BE699F73_Out_2);
                float _Property_71EA8396_Out_0 = Vector1_1A1B6BF6;
                float3 _Multiply_35A54FBD_Out_2;
                Unity_Multiply_float(_Multiply_BE699F73_Out_2, (_Property_71EA8396_Out_0.xxx), _Multiply_35A54FBD_Out_2);
                float3 _Add_CC20ED78_Out_2;
                Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_35A54FBD_Out_2, _Add_CC20ED78_Out_2);
                description.VertexPosition = _Add_CC20ED78_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_21E7F1EA_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_21E7F1EA_Out_1);
                float4 _ScreenPosition_AB8F5F5E_Out_0 = IN.ScreenPosition;
                float _Split_65703DA5_R_1 = _ScreenPosition_AB8F5F5E_Out_0[0];
                float _Split_65703DA5_G_2 = _ScreenPosition_AB8F5F5E_Out_0[1];
                float _Split_65703DA5_B_3 = _ScreenPosition_AB8F5F5E_Out_0[2];
                float _Split_65703DA5_A_4 = _ScreenPosition_AB8F5F5E_Out_0[3];
                float _Subtract_2984ECBD_Out_2;
                Unity_Subtract_float(_Split_65703DA5_A_4, 1, _Subtract_2984ECBD_Out_2);
                float _Subtract_5CB4794D_Out_2;
                Unity_Subtract_float(_SceneDepth_21E7F1EA_Out_1, _Subtract_2984ECBD_Out_2, _Subtract_5CB4794D_Out_2);
                float _Property_807CA614_Out_0 = Vector1_C2E29679;
                float _Divide_16288DDF_Out_2;
                Unity_Divide_float(_Subtract_5CB4794D_Out_2, _Property_807CA614_Out_0, _Divide_16288DDF_Out_2);
                float _Saturate_8912304_Out_1;
                Unity_Saturate_float(_Divide_16288DDF_Out_2, _Saturate_8912304_Out_1);
                surface.Alpha = _Saturate_8912304_Out_1;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
                output.WorldSpacePosition =          TransformObjectToWorld(input.positionOS);
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
            ENDHLSL
        }
        
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
