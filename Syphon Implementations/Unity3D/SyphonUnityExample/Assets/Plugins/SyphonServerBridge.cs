using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class SyphonServerBridge : MonoBehaviour {

	private RenderTexture _rTexture = null;
	
	[DllImport ("SyphonUnityPlugin")]
	private static extern void syphonServerPublishTexture(int nativeTexture, int width, int height);

	[DllImport ("SyphonUnityPlugin")]
	private static extern void syphonServerDestroyResources();

	Camera myCamera = null;
		
	// Use this for initialization
	void Start ()
	{
		_rTexture = Resources.Load("RTTexture") as RenderTexture;
		
		myCamera = GetComponent("Camera") as Camera;		
							
		myCamera.targetTexture = _rTexture;
	}
	
	// Update is called once per frame
	void Update ()
	{
		//Camera.main.transform.Rotate(Vector3.up *Time.deltaTime * 20);
		//myCamera.transform.Rotate(Vector3.right *Time.deltaTime * 20);

		RenderTexture.active = _rTexture;
		syphonServerPublishTexture(_rTexture.GetNativeTextureID(), _rTexture.width, _rTexture.height);
	
	}
	
	// Also called in the editor when play is stopped
	void OnApplicationQuit ()
	{
		syphonServerDestroyResources();
	}

}
