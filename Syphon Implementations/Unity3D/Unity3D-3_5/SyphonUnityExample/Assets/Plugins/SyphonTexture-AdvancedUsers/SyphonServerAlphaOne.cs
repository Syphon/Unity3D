using UnityEngine;
using System.Collections;

public class SyphonServerAlphaOne : MonoBehaviour {

	public Material alphaOneMat;
	// Use this for initialization
	void Start () {
		if(!alphaOneMat){
			alphaOneMat = new Material(Shader.Find ("Syphon/AlphaOne"));
		}
	}
	
	// Update is called once per frame
	void OnRenderImage (RenderTexture src, RenderTexture dst) {
		Syphon.SafeMaterial.SetPass (0);
		Graphics.Blit (src, dst, alphaOneMat);

	}
}
