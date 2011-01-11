using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class SyphonServerBridge : MonoBehaviour {

	private float storedScreenWidth;
	private float storedScreenHeight;

		
	[DllImport ("SyphonUnityPlugin")]
	private static extern void syphonServerPublishTexture(int nativeTexture, int width, int height);

	[DllImport ("SyphonUnityPlugin")]
	private static extern void syphonServerDestroyResources();

	// Use this for initialization
	void Start ()
	{		
		storedScreenWidth = Screen.width;
		storedScreenHeight = Screen.height;
	}

	void OnRenderImage(RenderTexture src, RenderTexture dst)
	{
		Graphics.Blit(src, dst);
		syphonServerPublishTexture(src.GetNativeTextureID(), src.width, src.height);	
	}


	void Update(){
		if(storedScreenWidth != Screen.width || storedScreenHeight != Screen.height){
			storedScreenHeight = Screen.height;
			storedScreenWidth = Screen.width;
			cleanup();
		}
	}


	void cleanup(){
		syphonServerDestroyResources();
	}
	// Also called in the editor when play is stopped
	void OnApplicationQuit ()
	{
		cleanup();
	}

}
