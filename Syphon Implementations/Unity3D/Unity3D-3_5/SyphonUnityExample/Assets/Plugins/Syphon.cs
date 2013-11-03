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


//This is the main Syphon manager, and should be attached to your main camera (only one object in the scene)
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Xml;
using System.Xml.Serialization;
using System.IO;

//	[ExecuteInEditMode]
	public class Syphon : MonoBehaviour
{
	//PLUGIN EXPORTS:
	//server related
	[DllImport ("SyphonUnityPlugin")]
		public static extern IntPtr CreateServerTexture(string serverName);
	[DllImport ("SyphonUnityPlugin")]
		public static extern bool CacheServerTextureValues(int textureId, int width, int height, IntPtr syphonServerTextureInstance);
	
	//client related
	[DllImport ("SyphonUnityPlugin")]
		public static extern IntPtr CreateClientTexture(IntPtr serverPtr);
	[DllImport ("SyphonUnityPlugin")]
		public static extern bool CacheClientTextureValues(int textureId, int width, int height, IntPtr syphonClientTextureInstance);
	[DllImport ("SyphonUnityPlugin")]
		public static extern void QueueToKillTexture(IntPtr killMe);
	[DllImport ("SyphonUnityPlugin")]
		public static extern void UpdateTextureSizes();


	[DllImport ("SyphonUnityPlugin")]
		private static extern int cacheGraphicsContext();
	
	[DllImport ("SyphonUnityPlugin")]
		private static extern int SyServerCount();
	[DllImport ("SyphonUnityPlugin")]
		private static extern IntPtr SyServerAtIndex(int counter, StringBuilder myAppName, StringBuilder myName, StringBuilder myUuId);
	
	
	[SerializeField]
	private Dictionary<string, Dictionary<string, SyphonServerObject>> servers = new Dictionary<string, Dictionary<string, SyphonServerObject>>();

	[SerializeField]
	private Dictionary<SyphonClientTexture, SyphonClientObject> clientInstances = new Dictionary<SyphonClientTexture, SyphonClientObject>();
	public static Dictionary<SyphonClientTexture, SyphonClientObject> ClientInstances{ get{ return Syphon.Instance.clientInstances;	}}


	[SerializeField]
	private static List<int[]> textureUpdateRequests = new List<int[]>();	
	
	[SerializeField]
	public List<SyphonClientObject> syphonClients = new List<SyphonClientObject>();	
	public static List<SyphonClientObject> SyphonClients {
		get{
			return Syphon.Instance.syphonClients;
		}
		set{
			Syphon.Instance.syphonClients = value;
		}
	}	
	[SerializeField]
	public Dictionary<string, string[]> serverAppNames = new Dictionary<string, string[]>();	
	


		
	//getters for Client/Server dictionaries and app-sorted arrays.
	public static Dictionary<string, Dictionary<string, SyphonServerObject>> Servers{ get{ return Syphon.Instance.servers;	}}

	public static Dictionary<string, string[]> ServerAppNames{ get{ return Syphon.Instance.serverAppNames;}}
	private static int updateContext = 1;
	private static bool updatedAssembly = false;
	//if you don't have a name, name its dictionary hash unnamed.
	private const string unnamed = "unnamed";
	public static string UNNAMED_STRING{ get{ return unnamed; }}
	private StringBuilder myName, myAppName, myUuId;
	private static Material safeMaterial;
	public static Material SafeMaterial
	{
		get{
			
		if(!safeMaterial){
		safeMaterial = new Material (
		"Shader \"Hidden/Invert\" {" +
		"SubShader {" +
		" Pass {" +
		" ZTest Always Cull Off ZWrite Off" +
		" SetTexture [_RenderTex] { combine texture }" +
		" }" +
		"}" +
		"}"
		);
		safeMaterial.hideFlags = HideFlags.HideAndDontSave;
		safeMaterial.shader.hideFlags = HideFlags.HideAndDontSave;		
		}
		return safeMaterial;
		}
	}

	
	[NonSerialized]
	private bool initialized = false;
	public bool Initialized { get{return initialized;}}
	[SerializeField]
	private static Syphon instance = null;
	public static int syphonScriptCount = 0;

	[SerializeField]
	private Texture2D nullTexture;
	//lazy init this motherfucker.
	public static Texture2D NullTexture {
		get{
			if(Syphon.Instance.nullTexture == null){
					Syphon.Instance.nullTexture = new Texture2D(16, 16, TextureFormat.ARGB32, false);
					Color[] pixels = new Color[Syphon.Instance.nullTexture.width*Syphon.Instance.nullTexture.height];
					for(int i = 0; i < pixels.Length; i++){
						pixels[i] = new Color(0, 0, 0, 0);
					}
					Syphon.Instance.nullTexture.SetPixels(pixels);
					Syphon.Instance.nullTexture.Apply();				
			}
			return Syphon.Instance.nullTexture;
		}
	}

	public static Syphon Instance		
	{
		get
		{		
			if (instance == null)
			{
				//this is only necessary to satisfy remote callbacks in the odd timing after build where the instance might be null
				//a null singleton is a royal pain in the ass.
				instance =  (Syphon)UnityEngine.Object.FindObjectOfType (typeof(Syphon));
				if(!instance){
					UnityEngine.Debug.LogError("You have a SyphonClientTexture or SyphonServerTexture in the scene, so you need a Syphon instance somewhere! adding one now.");
					instance = Camera.main.gameObject.AddComponent<Syphon>();					
				}
			 }
			return instance;
		}
	}


	//these are used to tell the associated Editor script to Repaint the GUI when a new server joins/leaves.
	public delegate void RepaintServerListGUIHandler();
	public event RepaintServerListGUIHandler RepaintServerListGUI;

	[AttributeUsage (AttributeTargets.Method)]
	public sealed class MonoPInvokeCallbackAttribute : Attribute {
	    public MonoPInvokeCallbackAttribute (Type t) {}
	}
	
	private delegate void OnTextureSizeChangedDelegate(int ptr, int width, int height);
	private delegate void OnAnnounceServerDelegate(string appName, string name, string uuid, IntPtr serverPtr);
	private delegate void OnRetireServerDelegate(string appName, string name,  string uuid);
	private delegate void OnUpdateServerDelegate(string appName, string name, string uuid, IntPtr serverPtr);



	[DllImport ("SyphonUnityPlugin")]
		private static extern void InitDelegateCallbacks(OnTextureSizeChangedDelegate texSize, OnAnnounceServerDelegate announceServer, OnRetireServerDelegate retireServer, OnUpdateServerDelegate updateServer);
	

	//these are used to tell the associated client texture gameobject script to announce/etc a server
	public delegate void AnnounceServerHandler(string appName, string name);
	public static event AnnounceServerHandler AnnounceServer;
	public delegate void RetireServerHandler(string appName, string name);
	public static event RetireServerHandler RetireServer;
	public delegate void UpdateServerHandler(string appName, string name);
	public static event UpdateServerHandler UpdateServer;

	//prototype delegate for updating client textures - unneeded now that we're using direct callbacks.
//	public delegate void UpdateClientTexturesHandler();
//	public static event UpdateClientTexturesHandler UpdateClientTextures;

	private void registerClientInstance(SyphonClientTexture tex, SyphonClientObject obj){
		if(!clientInstances.ContainsKey(tex)){
			clientInstances.Add(tex, obj);
		}
	}
	
	private void unregisterClientInstance(SyphonClientTexture tex){
		if(clientInstances.ContainsKey(tex)){
			SyphonClientObject obj = clientInstances[tex];
			clientInstances.Remove(tex);
			//iterate through all the syphonClients.
			//if there are no more objects that match the object listed, destroy the bitch.
			bool found = false;
			foreach(KeyValuePair<SyphonClientTexture,SyphonClientObject> kvp in clientInstances)
			{
				//if you find an object registered that matches the syphon client list, dont destroy it yet.
				if(kvp.Value == obj && kvp.Key != tex)
					found = true;
			}
			if(!found)
			{
				DestroyClient(obj);	
			}
		}
	}
	
	public static void RegisterClientInstance(SyphonClientTexture tex, SyphonClientObject obj){
		if(Syphon.instance != null)
		Syphon.Instance.registerClientInstance(tex, obj);
	}
	
	public static void UnregisterClientInstance(SyphonClientTexture tex){
		if(Syphon.instance != null)
		Syphon.Instance.unregisterClientInstance(tex);
	}
	public void initSyphonServers(){
//		 StackTrace stackTrace = new StackTrace();
//		 UnityEngine.Debug.Log("init'd syphon servers "+ stackTrace.GetFrame(1).GetMethod().Name);
		
		//clear the servers array
		servers.Clear();
		//get the number of servers that exist in the OS-wide syphon servers array
		int myServerCount = SyServerCount();
		for(int i = 0; i < myServerCount; i++){
			myName = new StringBuilder(256); //must be 256 since the plugin says this too
			myAppName = new StringBuilder(256);
			myUuId = new StringBuilder(256);
			IntPtr serverPtr = SyServerAtIndex(i, myAppName, myName, myUuId);
			OnAnnounceServer(myAppName.ToString(), myName.ToString(), myUuId.ToString(), serverPtr);
		}
		 System.GC.Collect();
	}
	
//	public void initSyphonClients(){
//		
//		foreach(SyphonClientObject obj in SyphonClients){
//			//if the server exists and is valid, you may update it with the latest infos about the attached server, and initialize.
//			if(Syphon.Servers.ContainsKey(obj.BoundAppName) && Syphon.Servers[obj.BoundAppName].ContainsKey(obj.BoundName)){
//				//making the assumption here that the client is not initialized when this method is called.				
//				obj.DefineSyphonClient(Syphon.Servers[obj.BoundAppName][obj.BoundName]);
//				obj.InitSyphonClient();
//			}
//		}
//				
//		Instance.UpdateClientNames();
//		
//	}


	public static void cacheAssembly(){
		updatedAssembly = true;
		InitDelegateCallbacks(OnTextureSizeChanged, OnAnnounceServer, OnRetireServer, OnUpdateServer);	
	}
		
	public static bool assemblyIsUpdated(){
		return updatedAssembly;
	}
	
	
	public void Update(){
		if(!updatedAssembly){
			cacheAssembly();
		}
		
		//execute any queued texture update requests here
		if(textureUpdateRequests.Count != 0){
			for(int i = 0; i < textureUpdateRequests.Count; i++){
				foreach(SyphonClientObject obj in Syphon.SyphonClients){
					if((int)obj.SyphonClientPointer == textureUpdateRequests[i][0]){
						obj.UpdateTextureSize((int)textureUpdateRequests[i][1], (int)textureUpdateRequests[i][2]);
					}
				}
			}	
			textureUpdateRequests.Clear();			
		}

		
		for(int i = 0; i < SyphonClients.Count; i++)
		{
			SyphonClients[i].Render();
		}
	}


	

	public void Awake() {

		//first thing you do is make sure callbacks are registered. that's what this method does.
		cacheAssembly();	

		//if there is an extra instance of Syphon that exists, destroy it. 
		//Syphon is supposed to act like a singleton, so force it to behave like one.
		if (Syphon.Instance != null && Syphon.Instance != this) {
			DestroyImmediate(this);
			return;
		} 

		//force the instance references to be valid each time you play the game.
		instance =  this;
		
		//init the syphon servers. this will effectively call OnServerAnnounce for every client object that exists.
		Instance.initSyphonServers();
		//update the server names to be shown in the gui. this is kinda dumb, but...
		UpdateServerNames();
		
//so it's really not correct to call this. 
//		Instance.initSyphonClients();	
		
		//print(serverAppNames.Count +" " + Syphon.ServerAppNames.Count);
		initialized = true;
	}
	

	[MonoPInvokeCallback (typeof (OnTextureSizeChangedDelegate))]
	public static void OnTextureSizeChanged(int ptr, int width, int height){
		if((int)width == 0 || (int)height == 0){
//			UnityEngine.Debug.Log ("h or w is zero! exiting.");
			return;
		}
		
		textureUpdateRequests.Add (new int[]{ptr, width, height});
		
//		UnityEngine.Debug.Log("Syphon Texture size changed! ptr: " + ptr + " w/h: " + width + " " + height);		
	}

	[MonoPInvokeCallback (typeof (OnAnnounceServerDelegate))]
	public static void OnAnnounceServer(string appName, string name, string uuid, IntPtr serverPtr){
//		 UnityEngine.Debug.Log("Announcing the server with the appName: "
//		 + appName + ", name: " + name + ", uuid: " + uuid + " server Pointer: "+ (int)serverPtr);
				
		//if we don't yet have a key for that app, create a new dictionary entry.
		if(!Syphon.Servers.ContainsKey(appName)){
			Syphon.Servers.Add(appName, new Dictionary<string, SyphonServerObject>());
		}
		
		//now if the server name is empty, add an UNNAMED_STRING entry to the app's dictionary list
		if(name == ""){			
			if(!Syphon.Servers[appName].ContainsKey(Syphon.UNNAMED_STRING)){
				Syphon.Servers[appName].Add(Syphon.UNNAMED_STRING, new SyphonServerObject(appName, name, uuid, serverPtr));
			}
		}		
		//if it's not empty, just create a normal entry and SyphonServerObject.
		else if(!Syphon.Servers[appName].ContainsKey(name)){			
				Syphon.Servers[appName].Add(name, new SyphonServerObject(appName, name, uuid, serverPtr));			
		}		
		//TODO: this is dumb, remove this.
		Instance.UpdateServerNames();
		
		//callback to the client textures to let them know a new server came online
		if(AnnounceServer != null)
			AnnounceServer(appName, name);

	}
	
	[MonoPInvokeCallback (typeof (OnUpdateServerDelegate))]
	public static void OnUpdateServer(string appName, string name, string uuid, IntPtr serverPtr){
	//		UnityEngine.Debug.Log("Updating the server with the appName: " + appName + ", name: " + name + ", uuid: " + uuid);

		// 	for(int i = 0; i < myself.myClientObjects.Count; i++){
		// 		//should now check all clients to see if any were using this SyphonClient. if so, respond appropriately.
		// 		myself.myClientObjects[i].handleServerUpdate(myself.myServers[myIndex]);
		// 	}
		
				//TODO: remove this
				Instance.UpdateServerNames();
		
				//TODO: handle 'update server' events, whatever that means?
				if(UpdateServer != null)
					UpdateServer(appName, name);
		}

	[MonoPInvokeCallback (typeof (OnRetireServerDelegate))]
	public static void OnRetireServer(string appName, string name,  string uuid){
		string realAppName = "";
		string realName = "";

//		UnityEngine.Debug.Log("retiring the server with the appName: " + appName + ", name: " + name + ", uuid: " + uuid);

		if(instance == null){
			Instance.UpdateServerNames();
			Instance.OnRepaintServerListGUI();
//			UnityEngine.Debug.Log("no instance of Syphon in Editor. this can happen because of OnRetireServer callback threading. returning early, unsure if this really matters");
			return;
		}
		//if there are any ACTIVE client singleton objects in use, 
		//destroy them immediately.
		//destroy their texture and destroy the pointer to them, and remove them from the SyphonClients list.
		SyphonClientObject result = Syphon.GetSyphonClient(uuid);

		if(result){
			//because the Syphon callback may not have a valid appName and name key in the OnServerRetire Syphon callback, 
			//we need to ensure we get the extract those cached names from the uuid/instance.
			realAppName = result.BoundAppName;	
			realName = result.BoundName;	

			DestroyClient (result);
		}			
		
//		//now remove the server name
//		//if it doesn't contain the appName key, you shouldn't have to do anything.
		if(Syphon.Servers.ContainsKey(realAppName)){
			if(realName == ""){
				//if the name is UNNAMED_STRING and it contains the unnamed string, remove the server from the list.
				if(Syphon.Servers[realAppName].ContainsKey(Syphon.UNNAMED_STRING)){
					Syphon.Servers[realAppName].Remove(Syphon.UNNAMED_STRING);					
				
					//if there are no more objects in the dictionary list for that app, remove the associated appName entry
					if(Syphon.Servers[realAppName].Count == 0){
						Syphon.Servers.Remove(realAppName);
					}
				}
			}
			//if the name is valid and the server's app dictionary contains the name string, remove the server from the list.
			else if(Syphon.Servers[realAppName].ContainsKey(realName)){
					Syphon.Servers[realAppName].Remove(realName);
			
				//if there are no more entries in the dictionary list for that app, remove the associated appName entry
				if(Syphon.Servers[realAppName].Count == 0){
					Syphon.Servers.Remove(realAppName);
				}
			}
		
			//TODO: remove this.
			Instance.UpdateServerNames();
		}
		
		if(RetireServer != null)
			RetireServer(realAppName, realName);	

		Instance.OnRepaintServerListGUI();




	}
	
	public void UpdateServerNames(){
		serverAppNames.Clear();
		foreach(KeyValuePair<string,Dictionary<string, SyphonServerObject>> kvp in Syphon.Servers){
			//add a serverName, String array
	 		serverAppNames.Add(kvp.Key, new string[kvp.Value.Count]);
			int i = 0;
			//populate that array with the series of names indices that exist in the array.
			foreach(KeyValuePair<string, SyphonServerObject> nameAndObject in kvp.Value){
				if(nameAndObject.Key == Syphon.UNNAMED_STRING){
					serverAppNames[kvp.Key][i] = Syphon.UNNAMED_STRING;
				}
				else{
					serverAppNames[kvp.Key][i] = nameAndObject.Key;
				}
				i++;
			}
		}
	
		Instance.OnRepaintServerListGUI();
	}
	
	public void OnRepaintServerListGUI(){
		if(RepaintServerListGUI != null){
			RepaintServerListGUI();
		}
	}
	

	
	public static SyphonClientObject GetSyphonClient(string appName, string name){
		if(Syphon.Instance == null)
			return null;

		return Syphon.SyphonClients.Find( delegate (SyphonClientObject obj) {			
			return obj.MatchesDescription(appName, name);
			});
	}

	public static SyphonClientObject GetSyphonClient(string uuid){
		if(Syphon.Instance == null)
			return null;

		return Syphon.SyphonClients.Find( delegate (SyphonClientObject obj) {			
			return obj.MatchesDescription(uuid);
			});
	}
	
	public static SyphonServerObject GetSyphonServer(string appName, string name){
		if(name == ""){
			if(Syphon.Servers.ContainsKey(appName) && Syphon.Servers[appName].ContainsKey(Syphon.UNNAMED_STRING)){
				return Syphon.Servers[appName][Syphon.UNNAMED_STRING];
			}
		}
		else{
			if(Syphon.Servers.ContainsKey(appName) && Syphon.Servers[appName].ContainsKey(name)){
				return Syphon.Servers[appName][name];
			}			
		}
		
		return null;
	}
		
	public static SyphonClientObject AddClientToSyphonClientsList(string appName, string name, SyphonServerObject server){		
		SyphonClientObject result = GetSyphonClient(appName, name);
		// Debug.Log(result.BoundAppName + " " + result.BoundName + " was the result");
		if(result == null){
//			UnityEngine.Debug.Log("DIDNT EXIST: " + appName + "/" +name);
			//if it was null when trying to add a new client, just add a new one and init.
			result = ScriptableObject.CreateInstance<SyphonClientObject>();
			result.DefineSyphonClient(server);
			Syphon.SyphonClients.Add(result);
		}
		else{			
//			UnityEngine.Debug.Log("EXISTED: " + appName + "/" +name + ". doing nothing.");
		}
		
		return result;
	}

	//CLIENT METHODS
	public static SyphonClientObject CreateClient(string appName, string name){			
		//make sure the server exists in the Syphon.Servers array before trying to add it.
		if( (name == Syphon.UNNAMED_STRING || name == "") && Syphon.Servers.ContainsKey(appName) && Syphon.Servers[appName].ContainsKey(Syphon.UNNAMED_STRING)){
			return AddClientToSyphonClientsList(appName, Syphon.UNNAMED_STRING, Syphon.Servers[appName][Syphon.UNNAMED_STRING]);
		}
		else if(Syphon.Servers.ContainsKey(appName) && Syphon.Servers[appName].ContainsKey(name)){
			return AddClientToSyphonClientsList(appName, name, Syphon.Servers[appName][name]);
		}
		return null;
	}
	

	//removes the client from the clients list and destroys it.
public static void DestroyClient(SyphonClientObject destroyObj){
	if(destroyObj != null){
		Syphon.SyphonClients.Remove(destroyObj);
		DestroyImmediate(destroyObj);
		destroyObj = null;
	}
}
	
public void OnPreRender(){
		//call 1 to cache context.
		GL.IssuePluginEvent(updateContext);
	
}

}