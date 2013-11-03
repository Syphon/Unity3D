using UnityEngine;
using System.Collections;
using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.IO;
using System.Runtime.InteropServices;
using System.Collections.Generic;

public class SyphonServerTextureCustomResolution : SyphonServerTexture {
	public int renderWidth = 1920;
	public int renderHeight = 1080;

	private int _renderWidth;
	private int _renderHeight;

	//you can disable drawing with this bool, for efficiency (but it will still output the syphon texture of the scene)
	public bool drawScene = true;

	private RenderTexture customRenderTexture;
	public delegate void OnControlSurfaceGUIHandler();
	public static event OnControlSurfaceGUIHandler OnControlSurfaceGUI;
	[NonSerialized]
	public Camera cameraInstance;
	private bool showCameraDebugOnce = false;
	public override void Start(){
		base.Start();

		cameraInstance = gameObject.GetComponent<Camera>();
		if(cameraInstance != null && cameraInstance.enabled){
			cameraInstance = camera;
			cameraInstance.enabled = false;	
		}

		createOrResizeRenderTexture();
	}

	public void createOrResizeRenderTexture(){
		if(!testCameraExists()){
			return;
		}

		//if the render texture exists already, release it, and resize it.
		if(customRenderTexture != null){
				RenderTexture.active = null;
				customRenderTexture.Release();
				customRenderTexture.width = renderWidth;
				customRenderTexture.height = renderHeight;
				RenderTexture.active = customRenderTexture;
				GL.Clear(false, true, new Color(0, 0, 0, 0));
		}
		customRenderTexture = new RenderTexture(renderWidth, renderHeight, 0, RenderTextureFormat.ARGB32);
		customRenderTexture.filterMode = FilterMode.Point;
		customRenderTexture.Create();
		Syphon.SafeMaterial.SetPass(0);
		RenderTexture.active = customRenderTexture;
		GL.Clear(false, true, new Color(0, 0, 0, 0));
		RenderTexture.active = null;


		cameraInstance.targetTexture = customRenderTexture;


	}

	public override void OnRenderImage(RenderTexture src, RenderTexture dst){
		Graphics.Blit (src, dst);
	}

	public bool testCameraExists(){
		if(!cameraInstance){
			
			if(!showCameraDebugOnce){
				showCameraDebugOnce = true;
				Debug.LogError ("no camera on the gameObject: '" + gameObject.name +  "'. please add a camera to the object with the syphon server.");
			}
			
			return false;
		}
		return true;
	}

	public void OnRenderObject(){
		if(!testCameraExists()){
			return;
		}

		if(renderWidth != _renderWidth || renderHeight != _renderHeight){
			if(renderWidth == 0)
				renderWidth = 1;
			if(renderHeight == 0)
				renderHeight = 1;
			_renderWidth = renderWidth;
			_renderHeight = renderHeight;
			createOrResizeRenderTexture();
		}

		// Update texture data on Syphon server
		if (!syphonServerTextureValuesCached || cachedTexID != (int)camera.targetTexture.GetNativeTexturePtr()
		    || cameraInstance.targetTexture.width != cachedWidth || camera.targetTexture.height != cachedHeight)
			cacheTextureValues( camera.targetTexture );
			
			Syphon.SafeMaterial.SetPass(0);
			// Publish texture to Syphon Server
			if (syphonServerTextureInstance != IntPtr.Zero && cachedTexID != -1){
				GL.IssuePluginEvent((int)syphonServerTextureInstance);
			}



	}

	void OnGUI () {
		if(!testCameraExists()){
			return;
		}

		if(Event.current.type.Equals(EventType.Repaint)){	
			//clear with a black background (GL.Clear adds weird artifacts if called here...dunno why, unity bug?)
			GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), Syphon.NullTexture,  ScaleMode.ScaleAndCrop, false, 0); 
			//draw the scene rendertexture, but fit it to the window.
			if(drawScene)
			GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), customRenderTexture,  ScaleMode.ScaleToFit, false, 0); 
		}

//		//add additional gui stuff here if necessary.
		//this sucks you can't simply use OnGUI and have it work, but hey, at least this is a workaround to
		//use custom syphon resolution outputs with a visible GUI
		if(OnControlSurfaceGUI != null)
			OnControlSurfaceGUI();

		if(Event.current.type.Equals(EventType.Repaint)){	
			RenderTexture.active = customRenderTexture;				
			camera.Render();			
			RenderTexture.active = null;
		}
	}



}
