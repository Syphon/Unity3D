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
	[HideInInspector]
	public RenderTexture customRenderTexture;

	public int renderWidth = 1920;
	public int renderHeight = 1080;

	private int _renderWidth;
	private int _renderHeight;

	public bool renderMe = true;
	private bool _renderMe = false;


	public delegate void CreatedRenderTextureEvent(RenderTexture tex);
	public event CreatedRenderTextureEvent CreatedRenderTexture;

	public Camera cameraInstance;
	private bool showCameraDebugOnce = false;
	public override void Start(){
		base.Start();

		if(cameraInstance == null)
			cameraInstance = gameObject.GetComponent<Camera>();

		createOrResizeRenderTexture();



		TestIfShouldRender();
		
	}

	public void TestIfShouldRender(){
		_renderMe = renderMe;
		SyphonServerTextureViewRenderer rend = GetComponent<SyphonServerTextureViewRenderer>();	
		if(rend){
			if(!renderMe)
				Destroy(rend);
		}
		else{
			if(renderMe){
				gameObject.AddComponent<SyphonServerTextureViewRenderer>();
			}
		}

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

		if(CreatedRenderTexture != null){
			CreatedRenderTexture(customRenderTexture);
		}
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
			if(renderWidth <= 4)
				renderWidth = 4;
			if(renderHeight <= 4)
				renderHeight = 4;

			if(renderWidth > 8192){
				renderWidth = 8192;
			}

			if(renderHeight > 8192)
				renderHeight = 8192;

			_renderWidth = renderWidth;
			_renderHeight = renderHeight;
			createOrResizeRenderTexture();
		}

		// Update texture data on Syphon server
		if (!syphonServerTextureValuesCached || cachedTexID != (int)cameraInstance.targetTexture.GetNativeTexturePtr()
		    || cameraInstance.targetTexture.width != cachedWidth ||cameraInstance.targetTexture.height != cachedHeight)
			cacheTextureValues(  cameraInstance.targetTexture );
			
			Syphon.SafeMaterial.SetPass(0);
			// Publish texture to Syphon Server
			if (syphonServerTextureInstance != IntPtr.Zero && cachedTexID != -1){
				GL.IssuePluginEvent((int)syphonServerTextureInstance);
			}


		if(_renderMe != renderMe){
			TestIfShouldRender();
		}

	}
	


}
