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


//This script should be applied to any object in the scene, and lets you attach a syphon client texture to any Unity object.
//You may modify the ApplyTexture() method as necessary, to handle projectors, bump maps, etc.
using UnityEngine;
using System.Collections;
#pragma warning disable 0219

public class SyphonClientTexture : MonoBehaviour {
	// Use this for initialization
	public string clientAppName = "Test Server";
	public string clientName = "";
	protected SyphonClientObject clientObject;
	void Start () {
		//this next line creates a syphon instance if it doesn't already exist
		Syphon instance = Syphon.Instance;
		setupTexture();
	}
	
	void OnDestroy(){
		Syphon.UnregisterClientInstance(this);
	}
	
#if UNITY_EDITOR
//i don't trust that this doesn't crash unity. need more testing.
//	public SyphonClientTexture(){
//		Syphon.syphonScriptCount++;
//	}
//	~SyphonClientTexture(){
//		Syphon.syphonScriptCount--;
//	}
#endif

	void setupTexture(){
		//when you initialize the client texture, you should TRY to create the syphon client object. 
		//if it needs to exist because the server is available, it will create it. if the server is offline,
		//nothing will happen. this basically initializes a singleton for that particular server appName/name.		
		clientObject = Syphon.CreateClient (clientAppName, clientName);
//		if the client object exists
		if(clientObject != null){
			//only registers it if it doesn't already exist.
			Syphon.RegisterClientInstance(this, clientObject);
		}		
	}

	//this class has to watch for when servers come online, so that it knows when to create the client.	
	public void AnnounceServer(string appName, string name){
		if(appName == clientAppName && name == clientName){
			setupTexture();
		}
	}
		
	//handle applying the client texture to your object whichever way you please.
	public virtual void ApplyTexture(){
		if(clientObject != null && clientObject.Initialized){
			Material[] matArray = GetComponent<Renderer>().sharedMaterials;			
			for(int i = 0; i < matArray.Length; i++){
				matArray[i].mainTexture = clientObject.AttachedTexture;	
			}
			GetComponent<Renderer>().sharedMaterial.mainTexture.wrapMode = TextureWrapMode.Repeat;
		}
	}

	
	public void handleRetireClient(SyphonClientObject client){
		if(client == clientObject){
			//your syphonClient may soon go null as it is either 1) being destroyed from the clients list as there is no more reason to keep it alive or 2) the server has disappeared
		}
	}
	
	public void handleUpdateClientTextureSize(SyphonClientObject client){
		if(client == clientObject){			
			//the client has a valid texture size, which means the texture is valid, so apply it to the object.
			ApplyTexture();
			//texture resize here- resize your plane, or whatever you want to do. use client.Width and client.Height
			gameObject.SendMessage("UpdateAspectRatio",new Vector2(client.Width, client.Height), SendMessageOptions.DontRequireReceiver);
		}
	}
	
	public void OnDisable(){
		DisableCallbacks();
	}

	public void OnEnable(){
		EnableCallbacks();
	}
	
	private void EnableCallbacks(){
		Syphon.AnnounceServer += new Syphon.AnnounceServerHandler(AnnounceServer);
		SyphonClientObject.RetireClient += new SyphonClientObject.RetireClientHandler(handleRetireClient);
		SyphonClientObject.UpdateClientTextureSize += new SyphonClientObject.UpdateClientTextureSizeHandler(handleUpdateClientTextureSize);
	}
	
	private void DisableCallbacks(){
		Syphon.AnnounceServer -= new Syphon.AnnounceServerHandler(AnnounceServer);
		SyphonClientObject.RetireClient -= new SyphonClientObject.RetireClientHandler(handleRetireClient);
		SyphonClientObject.UpdateClientTextureSize -= new SyphonClientObject.UpdateClientTextureSizeHandler(handleUpdateClientTextureSize);
	}
	


}
