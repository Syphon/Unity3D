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
#pragma warning disable 0219

public class SyphonServerTexture : MonoBehaviour {
	
	protected IntPtr syphonServerTextureInstance = IntPtr.Zero;			// The Syphon plugin cache pointer, returned from CreateServerTexture()
	protected bool syphonServerTextureValuesCached = false;	// Do the server knows our camera size and id?
	protected int cachedTexID = 0;				// current camera gl texture id
	protected int cachedWidth = 0;				// current camera texture width
	protected int cachedHeight = 0;				// current camera texture height


#if UNITY_EDITOR
//i don't trust that this doesn't crash unity. need more testing.
//	public SyphonServerTexture(){
//		Syphon.syphonScriptCount++;
//	}
//	~SyphonServerTexture(){
//		Syphon.syphonScriptCount--;
//	}
#endif

	public virtual void Start() {
		//this next line creates a syphon instance if it doesn't already exist
		Syphon instance = Syphon.Instance;
		syphonServerTextureInstance = Syphon.CreateServerTexture(gameObject.name);
	}
	
	public void OnDestroy() {
		if(syphonServerTextureInstance != IntPtr.Zero){
			Syphon.QueueToKillTexture(syphonServerTextureInstance);
			GL.IssuePluginEvent((int)syphonServerTextureInstance);
		}
		syphonServerTextureInstance = IntPtr.Zero;
		syphonServerTextureValuesCached = false;
		cachedTexID = 0;
	}

	//
	// Cache the current texture data to server
	public void cacheTextureValues( RenderTexture rt ) {
		if (rt.GetNativeTexturePtr() != IntPtr.Zero && rt.width != 0 && rt.height != 0) {
			Syphon.CacheServerTextureValues((int)rt.GetNativeTexturePtr(), rt.width, rt.height, syphonServerTextureInstance);			
			cachedTexID = (int)rt.GetNativeTexturePtr();
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
	public virtual void OnRenderImage(RenderTexture src, RenderTexture dst){
		// Update texture data on Syphon server
		if (!syphonServerTextureValuesCached || cachedTexID != (int)src.GetNativeTexturePtr() || src.width != cachedWidth || src.height != cachedHeight)
			cacheTextureValues( src );

			// Copy src to dst
			Syphon.SafeMaterial.SetPass(0);
			Graphics.Blit(src, dst);
			// Publish texture to Syphon Server
			if (syphonServerTextureInstance != IntPtr.Zero && cachedTexID != -1)
				GL.IssuePluginEvent((int)syphonServerTextureInstance);

	}
}

