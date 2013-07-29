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


//you should not have to modify this class and do not add it to any object in your scene. it is used by the Syphon manager.
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Diagnostics;

//[System.Serializable]
public class SyphonClientObject : ScriptableObject {
	
	[SerializeField]
	private RenderTexture attachedTexture;
	public RenderTexture AttachedTexture{ get { return attachedTexture;}} 
	
	[SerializeField]
	private int width = 1;
	[SerializeField]
	private int height = 1;
	public int Height{ get{ return height;}}
	public int Width{ get{ return width;}}
	[SerializeField]
	private SyphonServerObject attachedServer;
	[SerializeField]
	public SyphonServerObject AttachedServer{ get{return attachedServer; } }
	[SerializeField]
	private string boundAppName;
	public string BoundAppName{ get{return boundAppName; } }
	[SerializeField]
	private string boundName;
	public string BoundName{ get{return boundName; } }	
	[NonSerialized]
	private int syphonClientPointer = 0;		
	public int SyphonClientPointer{ get { return syphonClientPointer; } }
	[NonSerialized]
	private bool initialized = false;
	public bool Initialized{ get {return initialized; }}	
	
//	[NonSerialized]
//	public bool retireSyphonClientQueue = false;

	public delegate void AnnounceClientHandler(SyphonClientObject obj);
	public static event AnnounceClientHandler AnnounceClient;

	public delegate void RetireClientHandler(SyphonClientObject obj);
	public static event RetireClientHandler RetireClient;


	public delegate void UpdateClientTextureSizeHandler(SyphonClientObject obj);
	public static event UpdateClientTextureSizeHandler UpdateClientTextureSize;

		
	public void DefineSyphonClient(SyphonServerObject server){
		//hold on to object reference
		attachedServer = server;		
		boundAppName = server.SyphonServerDescriptionAppName;
		if(server.SyphonServerDescriptionName == "")
			boundName = Syphon.UNNAMED_STRING;
		else
			boundName = server.SyphonServerDescriptionName;		
		//initialize the texture
		if(attachedTexture == null){
			attachedTexture = new RenderTexture(16, 16, 0, RenderTextureFormat.ARGB32);
			attachedTexture.filterMode = FilterMode.Bilinear;
			attachedTexture.wrapMode = TextureWrapMode.Clamp;
		}
//				Debug.Log("created syphon client: " + boundName + " " +boundAppName);
		
		//TODO: create the syphon client in plugin
	}
	
//	public void DefineSyphonClient(SyphonClientObject client){
//		
//		// UnityEngine.Debug.Log("created syphon client: " + boundName + " " +boundAppName);
//		//hold on to object reference
//		attachedServer = client.attachedServer;
//		boundAppName = client.AttachedServer.SyphonServerDescriptionAppName;
//		if(client.AttachedServer.SyphonServerDescriptionName == "")
//			boundName = Syphon.UNNAMED_STRING;
//		else
//			boundName = client.AttachedServer.SyphonServerDescriptionName;		
//		
//		//initialize the texture
//		if(attachedTexture == null){
//		attachedTexture = new RenderTexture(128, 128, 0, RenderTextureFormat.ARGB32);
//		attachedTexture.filterMode = FilterMode.Bilinear;
//		attachedTexture.wrapMode = TextureWrapMode.Clamp;
//		}
//		//TODO: create the syphon client in plugin		
//	}
	
	
	public void UpdateTextureSize(int w, int h){
		if(w != 0 && h != 0){
			width = w;
			height = h;
			RenderTexture.active = null;
			attachedTexture.Release();
			attachedTexture.width = width;
			attachedTexture.height = height;
			RenderTexture.active = attachedTexture;
//			Graphics.Blit( Syphon.NullTexture,attachedTexture);
			GL.Clear(false, true, new Color(0, 0, 0, 0));
			
			//every GameObject that is using this syphon server might want to know that the size changed.
			if(UpdateClientTextureSize != null){
				UpdateClientTextureSize(this);
			}
		}
		
	}

	public void InitSyphonClient(){
		//call Syphon initialize method here.		
		//if we have a valid syphon server attached, and not initialized yet, 
		if(Application.isPlaying && attachedServer.SyphonServerPointer != 0 && !initialized){
			// Debug.Log("EXECUTING syphon client: " + boundAppName + " " + boundName);
			attachedTexture.Create();
			Syphon.SafeMaterial.SetPass(0);
			RenderTexture.active = attachedTexture;
			GL.Clear(false, true, new Color(0, 0, 0, 0));
//			Graphics.Blit( Syphon.NullTexture,attachedTexture);
			RenderTexture.active = null;
			
			//this does not allocate GL resources- it simply creates a SyphonCacheData object on the heap
			//and saves the pointer in Unity here
		 	syphonClientPointer = Syphon.CreateClientTexture(attachedServer.SyphonServerPointer);
			Syphon.CacheClientTextureValues(attachedTexture.GetNativeTextureID(), attachedTexture.width, attachedTexture.height, syphonClientPointer);
			initialized = true;
			
			if(AnnounceClient != null)
				AnnounceClient(this);
						
		}
	}
	
	
	//TODO: resize rendertextures on width/height change
	
		public bool MatchesDescription(string appName, string name){
			if(name == ""){
				if(appName == boundAppName && boundName == Syphon.UNNAMED_STRING){
					return true;
				}
			}
			else if(appName == boundAppName && name == boundName){
				return true;
			}
			return false;
		}

	
	public void UpdateServer(string appName, string name){
		if(MatchesDescription(appName, name)){
			//TODO: handle this? how?
			// Debug.Log("updated app:" + appName + " name: " + name );				
		}
	}

	public void DestroySyphonClient(){
//		UnityEngine.Debug.Log("destroying syphon client" + syphonClientPointer + " " + BoundAppName + " " + boundName);
		if(attachedTexture != null){
			RenderTexture.active = null;
			attachedTexture.Release();
			//RenderTexture.active = null;
			UnityEngine.Object.DestroyImmediate(attachedTexture);
			attachedTexture = null;
		}
		
		if(syphonClientPointer != 0 && initialized){
			Syphon.QueueToKillTexture(syphonClientPointer);
			GL.IssuePluginEvent(syphonClientPointer);
			syphonClientPointer = 0; 
			initialized = false;	
			
			//let anySyphonClientTextures who's registered for updates know that we've retired.
			if(RetireClient != null){
				RetireClient(this);
			}
		}
		else{
//			Debug.Log("syphon client: " + boundAppName + " " + boundName + " was not initialized, so not cleaning up the plugin on exit.");
		}			
	}
	
	public static bool Match(SyphonClientObject a, SyphonClientObject b){
		if(a.boundAppName == b.boundAppName && a.boundName == b.boundName){
			return true;	
		}
		else return false;
	}
	

	public void Render(){
		if(syphonClientPointer != 0 && initialized){		
			//you need to render once per frame for each texture.
			Syphon.SafeMaterial.SetPass(0);	
			RenderTexture.active = attachedTexture;
			GL.IssuePluginEvent(syphonClientPointer);
			RenderTexture.active = null;
		}
	}
	
//	public void Update(){
//		if(retireSyphonClientQueue){
//			DestroySyphonClient();
//			retireSyphonClientQueue = false;
//		}
//	}
	
	public void OnDestroy(){
		//when you destroy the client object, destroy the client.
		DestroySyphonClient();
		Syphon.UpdateServer -= new Syphon.UpdateServerHandler(UpdateServer);
	}
	
	public void OnEnable(){
		Syphon.UpdateServer += new Syphon.UpdateServerHandler(UpdateServer);
	}
}
