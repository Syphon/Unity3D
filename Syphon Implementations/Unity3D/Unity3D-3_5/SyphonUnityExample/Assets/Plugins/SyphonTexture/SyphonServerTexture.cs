// Copyright (c)  2010-2012 Brian Chasalow, bangnoise (Tom Butterworth) & vade (Anton Marini).
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

public class SyphonServerTexture : MonoBehaviour {

	private int syphonServerTextureInstance = 0; //returned from CreateServerTexture()
	private bool syphonServerTextureInstanceInitialized = false;
	private int storedWidth = 0;
	private int storedHeight = 0;
	private RenderTexture tex = null;
	private int storedTexID = 0;
	// Use this for initialization
	public bool renderGUI = false;
	
	void Start () {
		Syphon instance = Syphon.Instance;
		syphonServerTextureInstance = Syphon.CreateServerTexture(gameObject.name);
	}
	
	
	public void OnDestroy(){
		if(syphonServerTextureInstance != 0)
		Syphon.KillServerTexture(syphonServerTextureInstance);
		
		syphonServerTextureInstance = 0;
		syphonServerTextureInstanceInitialized = false;
		tex = null; 
		storedWidth = 0;
		storedHeight = 0;
	}
	
	public void OnRenderImage(RenderTexture src, RenderTexture dst){
		
		//if you don't want to render the gui, just blit to the screen, cache the texture values and pass the screen texture to syphon.
		if(!renderGUI)
		{
		Graphics.Blit(src, dst);		
			 if(!syphonServerTextureInstanceInitialized || src.width != storedWidth || src.height != storedHeight || storedTexID != src.GetNativeTextureID()){
				storedWidth = src.width;
				storedHeight = src.height;
				storedTexID = src.GetNativeTextureID();
				cacheTextureValues();
			}

			GL.IssuePluginEvent((int)syphonServerTextureInstance);
		}		
		else{
			 if(tex == null || (!syphonServerTextureInstanceInitialized || src.width != storedWidth || src.height != storedHeight || 
			 storedTexID != src.GetNativeTextureID() )){
				storedWidth = src.width;
				storedHeight = src.height;
				storedTexID = src.GetNativeTextureID();
				tex = src;
				cacheTextureValues();
			}						
		}						
	}

	
	//if you DO want to render the gui in syphon, pass tex to syphon, THEN draw to the screen.
	public IEnumerator OnPostRender(){
			if(renderGUI && tex != null){
				yield return new WaitForEndOfFrame();


				//render to the main screen since the rt is null
				RenderTexture.active = null;
				 tex.SetGlobalShaderProperty ("_RenderTex");
				 GL.PushMatrix ();
				 GL.LoadOrtho ();
				// // activate the first pass (in this case we know it is the only pass)
				 Syphon.SafeMaterial.SetPass (0);
				// // draw a quad that covers the viewport
				GL.Begin (GL.QUADS);
				//set the Z to be +100 so it's rendered on top of everything else
				GL.TexCoord2 (0, 0); GL.Vertex3 (0, 0, 100f);
				GL.TexCoord2 (1, 0); GL.Vertex3 (1, 0, 100f);
				GL.TexCoord2 (1, 1); GL.Vertex3 (1, 1, 100f);
				GL.TexCoord2 (0, 1); GL.Vertex3 (0, 1, 100f);
				GL.End ();
				GL.PopMatrix ();	
				}
				else{
					yield return null;
				}
	}
	
	

	//if you DO want to render the gui in syphon, mark the active render texture as the source tex, and render it.
	public void LateUpdate(){
		if(renderGUI && syphonServerTextureInstance != 0 && syphonServerTextureInstanceInitialized){
			RenderTexture.active = tex;
			GL.IssuePluginEvent((int)syphonServerTextureInstance);
		}
	}
	
	
	public void cacheTextureValues(){
		if(storedWidth != 0 && storedHeight != 0 && storedTexID != 0){
			Syphon.CacheServerTextureValues(storedTexID, storedWidth, storedHeight, syphonServerTextureInstance);
			syphonServerTextureInstanceInitialized = true;
		}
	}
}
