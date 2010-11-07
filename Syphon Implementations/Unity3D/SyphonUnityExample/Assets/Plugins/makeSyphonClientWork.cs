using UnityEngine;
using System.Collections;

 public class makeSyphonClientWork : MonoBehaviour {
 	//ridiculously dumb fix courtesy of brian@chasalow.com 
 	//attach this script to the main camera. 
 	//then attach your SyphonClientBridge to whatever objects (plane, etc) you want to receive the texture on.
 	public string infos = "attachToMainCameraPlz!";
	void Start () {
	}
	
	static Material lineMaterial;
static void CreateLineMaterial() {
    if( !lineMaterial ) {
        lineMaterial = new Material( "Shader \"Lines/Colored Blended\" {" +
            "SubShader { Pass { " +
            "    Blend SrcAlpha OneMinusSrcAlpha " +
            "    ZWrite Off Cull Off Fog { Mode Off } " +
            "    BindChannels {" +
            "      Bind \"vertex\", vertex Bind \"color\", color }" +
            "} } }" );
        lineMaterial.hideFlags = HideFlags.HideAndDontSave;
        lineMaterial.shader.hideFlags = HideFlags.HideAndDontSave;
    }
}
	
void OnPostRender() {
    CreateLineMaterial();
    lineMaterial.SetPass( 0 );
} 

void OnRenderObject() {
    CreateLineMaterial();
    lineMaterial.SetPass( 0 );

} 



}
