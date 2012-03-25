using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class SyphonServerBridge : MonoBehaviour {

	private float storedScreenWidth;
	private float storedScreenHeight;
	private RenderTexture myRT;
	private Material mat;
	
		
	[DllImport ("SyphonUnityPlugin")]
	private static extern void syphonServerPublishTexture(int nativeTexture, int width, int height);

	[DllImport ("SyphonUnityPlugin")]
	private static extern void syphonServerDestroyResources();

	// Use this for initialization
	void Start ()
	{		
		storedScreenWidth = Screen.width;
		storedScreenHeight = Screen.height;
		myRT = new RenderTexture(Screen.width, Screen.height, 24);
		myRT.format = RenderTextureFormat.ARGB32;
		myRT.filterMode = FilterMode.Point;
		myRT.isPowerOfTwo = false;
		myRT.isCubemap = false;
		myRT.Create();
		
		mat = new Material (
		"Shader \"Hidden/Invert\" {" +
		"SubShader {" +
		" Pass {" +
		" ZTest Always Cull Off ZWrite Off" +
		" SetTexture [_RenderTexy] { combine texture }" +
		" }" +
		"}" +
		"}"
		);
	}

	public void OnRenderImage(RenderTexture src, RenderTexture dst){
		Graphics.Blit(src, myRT);
		RenderTexture.active = dst;
		//sets the global shader property of the material to be src
		src.SetGlobalShaderProperty ("_RenderTexy");
		GL.PushMatrix ();
		GL.LoadOrtho ();
		// activate the first pass (in this case we know it is the only pass)
		mat.SetPass (0);
		// draw a quad that covers the viewport
		GL.Begin (GL.QUADS);
		GL.TexCoord2 (0, 0); GL.Vertex3 (0, 0, 0.1f);
		GL.TexCoord2 (1, 0); GL.Vertex3 (1, 0, 0.1f);
		GL.TexCoord2 (1, 1); GL.Vertex3 (1, 1, 0.1f);
		GL.TexCoord2 (0, 1); GL.Vertex3 (0, 1, 0.1f);
		GL.End ();
		GL.PopMatrix ();
	}




	void LateUpdate(){
		//this cleans up the opengl matrices internally. it's a little bit of a hack
		Graphics.DrawTexture(new Rect(0, 0, 0, 0), myRT);
		
		//publish the server
		syphonServerPublishTexture(myRT.GetNativeTextureID(), myRT.width, myRT.height);
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
	void OnDisable ()
	{
		cleanup();
		Destroy(myRT);
		GL.InvalidateState();
	}

}
