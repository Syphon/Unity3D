// Copyright(c)  2010-2012 Brian Chasalow, bangnoise (Tom Butterworth) & vade (Anton Marini).
/*
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

   * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

   * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
   DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
   ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#if UNITY_STANDALONE_OSX

//This script should be applied to any camera in the scene, and lets you host a syphon server. 
//you may optionally use public variable renderGUI to show the GUI rendered by the camera. 
using UnityEngine;
using System.Collections;
using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.IO;
using System.Runtime.InteropServices;
using System.Collections.Generic;

public class SyphonServerTexture : MonoBehaviour {

	// From Inspector
	public bool renderGUI = true;
	
	private int syphonServerTextureInstance = 0;			// The Syphon plugin cache pointer, returned from CreateServerTexture()
	private bool syphonServerTextureValuesCached = false;	// Do the server knows our camera size and id?
	private int cachedTexID = 0;				// current camera gl texture id
	private int cachedWidth = 0;				// current camera texture width
	private int cachedHeight = 0;				// current camera texture height
	private RenderTexture srcTex = null;		// reference to the camera render source (when GUI in ON)
	private RenderTexture dstTex = null;		// reference to the camera render destination (when GUI in ON)

	void Start() {
		//Syphon instance = Syphon.Instance;
		syphonServerTextureInstance = Syphon.CreateServerTexture(gameObject.name);
	}
	
	public void OnDestroy() {
		if(syphonServerTextureInstance != 0)
			Syphon.KillServerTexture(syphonServerTextureInstance);
		syphonServerTextureInstance = 0;
		syphonServerTextureValuesCached = false;
		srcTex = null;
		cachedTexID = 0;
	}

	//
	// Cache the current texture data to server
	public void cacheTextureValues( RenderTexture rt ) {
		if (rt.GetNativeTextureID() != 0 && rt.width != 0 && rt.height != 0) {
			Syphon.CacheServerTextureValues(rt.GetNativeTextureID(), rt.width, rt.height, syphonServerTextureInstance);
			cachedTexID = rt.GetNativeTextureID();
			cachedWidth = rt.width;
			cachedHeight = rt.height;
			syphonServerTextureValuesCached = true;
		}
	}
	
	
	//////////////////////////////////////////////////////////////
	//
	// GAME LOOP CALLBACKS -- In order they are called
	//
	
	//
	// OnRenderImage() is called after all rendering is complete to render image, but the GUI is not rendered yet
	// http://docs.unity3d.com/Documentation/ScriptReference/Camera.OnRenderImage.html
	public void OnRenderImage(RenderTexture src, RenderTexture dst){
		// Update texture data on Syphon server
		if (!syphonServerTextureValuesCached || cachedTexID != src.GetNativeTextureID() || src.width != cachedWidth || src.height != cachedHeight)
			cacheTextureValues( src );

		// WITHOUT GUI: just blit to the screen and publish to syphon.
		if (!renderGUI) {
			// Reset shader (avoid bad frames, now sure why)
			Syphon.SafeMaterial.SetPass(0);
			// Copy src to dst
			Graphics.Blit(src, dst);
			// Publish texture to Syphon Server
			if (syphonServerTextureInstance != 0)
				GL.IssuePluginEvent((int)syphonServerTextureInstance);
		}
		// WITH GUI: save reference to render textures
		else {
			srcTex = src;
			dstTex = dst;
		}
	}

	//
	// OnPostRender() is called after a camera has finished rendering the scene
	// WaitForEndOfFrame() will make it be executed after GUI is rendered
	public IEnumerator OnPostRender(){
		// WITH GUI: wait Unity to render GUI, then blit to screen
		if (renderGUI && srcTex != null) {
			// Waits until the end of the frame after all cameras and GUI is rendered, just before displaying the frame on screen
			yield return new WaitForEndOfFrame();
			// Reset shader (avoid bad frames, now sure why)
			Syphon.SafeMaterial.SetPass(0);
			// Copy sr to dst
			Graphics.Blit(srcTex, dstTex);
			// Publish texture to Syphon Server
			if (syphonServerTextureInstance != 0)
				GL.IssuePluginEvent((int)syphonServerTextureInstance);
		}
		else {
			yield return null;
		}
	}
}

#endif	// UNITY_STANDALONE_OSX
