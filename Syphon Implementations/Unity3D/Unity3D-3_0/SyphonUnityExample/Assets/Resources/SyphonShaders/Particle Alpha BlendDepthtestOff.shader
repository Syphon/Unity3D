Shader "Syphon/Particles/Alpha BlendedDepthOff" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}

SubShader {
	Tags {"IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	LOD 200
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaTest Greater 0
		ZWrite On
		//ColorMask RGB
	//	Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
	//	ZTest Less
	
	
CGPROGRAM
#pragma surface surf Lambert alphatest:_Cutoff

sampler2D _MainTex;
float4 _Color;

struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;
	o.Alpha = c.a;
}
ENDCG
}

Fallback "Transparent/Cutout/VertexLit"
}

