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

public class SyphonClientTexture : MonoBehaviour {
	// Use this for initialization
	public string clientAppName = "Test Server";
	public string clientName = "";
	private SyphonClientObject clientObject;
	void Start () {
		clientObject =  Syphon.GetSyphonClient(clientAppName, clientName);
		//if the client object exists,
		if(clientObject != null){
			//if the texture has been initialized, apply its texture to something.
			ApplyTexture();
		}
		
	}

	//handle applying the client texture to your object whichever way you please.
	public void ApplyTexture(){
		if(clientObject.Initialized){
		renderer.sharedMaterial.mainTexture = clientObject.AttachedTexture;		
		renderer.sharedMaterial.mainTexture.wrapMode = TextureWrapMode.Repeat;
		}
	}

	public void handleAnnounceClient(SyphonClientObject client){
		if(!client.MatchesDescription(clientAppName, clientName)){
			return; //if the announced client was not this client, ignore it.
		}
		
		if(clientObject == null){
			//if the client had been previously destroyed or not initialized, re-init now.
			Start();
		}
		else if(clientObject != null){ 
			ApplyTexture();
		}
	}
	
	public void handleRetireClient(SyphonClientObject client){
		if(client == clientObject){
			//your syphonClient may soon go null as it is either 1) being destroyed from the clients list or 2) the server has disappeared
		}
	}
	
	public void handleUpdateClientTextureSize(SyphonClientObject client){
		if(client == clientObject){
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
		SyphonClientObject.AnnounceClient += new SyphonClientObject.AnnounceClientHandler(handleAnnounceClient);
		SyphonClientObject.RetireClient += new SyphonClientObject.RetireClientHandler(handleRetireClient);
		SyphonClientObject.UpdateClientTextureSize += new SyphonClientObject.UpdateClientTextureSizeHandler(handleUpdateClientTextureSize);
	}
	
	private void DisableCallbacks(){
		SyphonClientObject.AnnounceClient -= new SyphonClientObject.AnnounceClientHandler(handleAnnounceClient);
		SyphonClientObject.RetireClient -= new SyphonClientObject.RetireClientHandler(handleRetireClient);
		SyphonClientObject.UpdateClientTextureSize -= new SyphonClientObject.UpdateClientTextureSizeHandler(handleUpdateClientTextureSize);
	}
	

}
