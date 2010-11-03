using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class SyphonClientBridge : MonoBehaviour 
{
	public int desiredWidth = 1024;
	public int desiredHeight = 768;
	private Texture2D _texture;
			
	// Frees the Syphon Server and clears our Unity Plugin's GL resources
	[DllImport ("SyphonUnityPlugin")]
	private static extern void syphonClientDestroyResources();

	// Syphon Client Update Texture takes in a texture from Unity, and populates it with the contents of a
	// Syphon Server. This also lazily inits the server for you, ensuring the proper OpenGL context is set.
	[DllImport ("SyphonUnityPlugin")]
	private static extern void syphonClientUpdateTexture(int nativeTexture, int width, int height);

	// Use this for initialization
	void Awake () 
	{		
		_texture = new Texture2D(desiredWidth, desiredHeight, TextureFormat.ARGB32, false);
		_texture.Apply(false);
		
		if(renderer)
			renderer.material.mainTexture = _texture;		
	}
	
	// YOU MUST USE ON RENDER OBJECT FOR UNITY CLIENT.
	void OnRenderObject ()
	{
		// Unity 3.0 has GetNativeTextureID, which returns the texture ID.
		// 2.x requires us to call GetInstanceID instead. 
//		#if UNITY_3	
			syphonClientUpdateTexture(_texture.GetNativeTextureID(), _texture.width, _texture.height);
//		#elif UNITY_2
//			syphonClientUpdateTexture(_texture.GetInstanceID());
//		#endif
	}
	
	// Also called in the editor when play is stopped
	void OnApplicationQuit ()
	{
		syphonClientDestroyResources();
	}
}