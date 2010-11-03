using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

public class SyphonServerBridge : MonoBehaviour {

	private GameObject _RTCameraObject;
	private Camera _RTCamera;
	private RenderTexture _rTexture = null;
	public int desiredWidth = 1024;
	public int desiredHeight = 768;


		
	[DllImport ("SyphonUnityPlugin")]
	private static extern void syphonServerPublishTexture(int nativeTexture, int width, int height);

	[DllImport ("SyphonUnityPlugin")]
	private static extern void syphonServerDestroyResources();

	// Use this for initialization
	void Start ()
	{		
		_rTexture = new RenderTexture(desiredWidth, desiredHeight, 24);
		_rTexture.format = RenderTextureFormat.ARGB32;
		_rTexture.isPowerOfTwo = false;
		_rTexture.isCubemap = false;
		_rTexture.Create();
		
		//create a new render texture camera object, parent it to this object
		_RTCameraObject = new GameObject();
		_RTCameraObject.transform.parent = transform;
		_RTCameraObject.name = "RTCamera";
		_RTCameraObject.AddComponent("Camera");
		
		//clone the current camera's settings to the RT Camera
		_RTCameraObject.camera.CopyFrom(camera);
		
		//add the render texture target to the RTCamera object
		_RTCameraObject.camera.targetTexture = _rTexture;
	}

	void LateUpdate()
	{
		RenderTexture.active = _rTexture;
		syphonServerPublishTexture(_rTexture.GetNativeTextureID(), _rTexture.width, _rTexture.height);	
	}




	
	// Also called in the editor when play is stopped
	void OnApplicationQuit ()
	{
		syphonServerDestroyResources();
	}

}
