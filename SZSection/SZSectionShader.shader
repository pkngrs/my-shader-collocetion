Shader "SZSection/Origin" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_CrossColor("Cross Section Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
	}
		SubShader{
		Tags{ "RenderType" = "Transparent" }
		//LOD 200

		Cull Back
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
#pragma target 3.0

		sampler2D _MainTex;

	struct Input {
		float2 uv_MainTex;
		float4 vertColor;
	};

	half _Glossiness;
	half _Metallic;
	float4 _Color;

	void vert(inout appdata_full v, out Input o)
	{
		o.vertColor = v.color;
		o.uv_MainTex = v.texcoord.xy;
	}

	void surf(Input IN, inout SurfaceOutputStandard o) {
		if (IN.vertColor.a < 0.5)discard;
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
		o.Albedo = c.rgb;
		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
		o.Alpha = c.a;
	}
	ENDCG

		Cull Front
		CGPROGRAM
#pragma surface surf NoLighting  noambient vertex:vert

		struct Input {
		half2 uv_MainTex;
		float4 vertColor;
	};
	sampler2D _MainTex;
	float4 _Color;
	float4 _CrossColor;

	fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
	{
		fixed4 c;
		c.rgb = s.Albedo;
		c.a = s.Alpha;
		return c;
	}

	void vert(inout appdata_full v, out Input o)
	{
		o.vertColor = v.color;
		o.uv_MainTex = v.texcoord.xy;
	}

	void surf(Input IN, inout SurfaceOutput o)
	{
		if (IN.vertColor.a < 0.5)discard;
		o.Albedo = _CrossColor;
	}
	ENDCG

	}
}