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
using System.Diagnostics;


//	[ExecuteInEditMode]
	public class Syphon : MonoBehaviour
{
	//PLUGIN EXPORTS:
	//server related
	[DllImport ("SyphonUnityPlugin")]
		public static extern int CreateServerTexture(string serverName);
	[DllImport ("SyphonUnityPlugin")]
		public static extern bool CacheServerTextureValues(int textureId, int width, int height, int syphonServerTextureInstance);
	[DllImport ("SyphonUnityPlugin")]
		public static extern void KillServerTexture(int killMe);
	
	//client related
	[DllImport ("SyphonUnityPlugin")]
		public static extern int CreateClientTexture(int serverPtr);
	[DllImport ("SyphonUnityPlugin")]
		public static extern bool CacheClientTextureValues(int textureId, int width, int height, int syphonClientTextureInstance);
	[DllImport ("SyphonUnityPlugin")]
		public static extern void KillClientTexture(int killMe);
	[DllImport ("SyphonUnityPlugin")]
		public static extern void UpdateTextureSizes();


	[DllImport ("SyphonUnityPlugin")]
		private static extern int cacheGraphicsContext();
	[DllImport ("SyphonUnityPlugin")]
		private static extern int SyServerCount();
	[DllImport ("SyphonUnityPlugin")]
		private static extern int SyServerAtIndex(int counter, StringBuilder myAppName, StringBuilder myName, StringBuilder myUuId);
	[DllImport ("SyphonUnityPlugin")]
		private static extern void InitServerPlugin();
	
	
	

	
	[SerializeField]
	public Dictionary<string, Dictionary<string, SyphonServerObject>> servers = new Dictionary<string, Dictionary<string, SyphonServerObject>>();
	[SerializeField]
	public List<SyphonClientObject> unsortedClients = new List<SyphonClientObject>();	
	public static List<SyphonClientObject> UnsortedClients {
		get{
			return Syphon.Instance.unsortedClients;
		}
		set{
			Syphon.Instance.unsortedClients = value;
		}
	}	
	[SerializeField]
	public Dictionary<string, string[]> serverAppNames = new Dictionary<string, string[]>();	
	[SerializeField]
	public Dictionary<string, string[]> clientAppNames = new Dictionary<string, string[]>();
	


		
	//getters for Client/Server dictionaries and app-sorted arrays.
	public static Dictionary<string, Dictionary<string, SyphonServerObject>> Servers{ get{ return Syphon.Instance.servers;	}}
	public static Dictionary<string, string[]> ClientAppNames{  get{	return Syphon.Instance.clientAppNames;	}}
	public static Dictionary<string, string[]> ServerAppNames{ get{ return Syphon.Instance.serverAppNames;}}

	//public List<SyphonClientTexture> clientTextures = new List<SyphonClientTexture>();

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
					UnityEngine.Debug.LogError("you need a Syphon instance somewhere! adding one now.");
					instance = Camera.main.gameObject.AddComponent<Syphon>();					
				}
			 }
			return instance;
		}
	}


	//these are used to tell the associated Editor script to Repaint the GUI when a new server joins/leaves.
	public delegate void RepaintServerListGUIHandler();
	public event RepaintServerListGUIHandler RepaintServerListGUI;

	//these are used to tell the associated client texture gameobject script to announce/etc a server
	public delegate void AnnounceServerHandler(string appName, string name);
	public static event AnnounceServerHandler AnnounceServer;
	public delegate void RetireServerHandler(string appName, string name);
	public static event RetireServerHandler RetireServer;
	public delegate void UpdateServerHandler(string appName, string name);
	public static event UpdateServerHandler UpdateServer;

	//prototype delegate for updating client textures
	public delegate void UpdateClientTexturesHandler();
	public static event UpdateClientTexturesHandler UpdateClientTextures;

      
	public void initSyphonServers(){
		 // StackTrace stackTrace = new StackTrace();
		 // UnityEngine.Debug.Log("init'd syphon servers "+ stackTrace.GetFrame(1).GetMethod().Name);
		
		//clear the servers array
		servers.Clear();
		//get the number of servers that exist in the OS-wide syphon servers array
		int myServerCount = SyServerCount();
		for(int i = 0; i < myServerCount; i++){
			myName = new StringBuilder(256); //must be 256 since the plugin says this too
			myAppName = new StringBuilder(256);
			myUuId = new StringBuilder(256);
			int serverPtr = SyServerAtIndex(i, myAppName, myName, myUuId);
			OnAnnounceServer(myAppName.ToString(), myName.ToString(), myUuId.ToString(), serverPtr);
		}
		 System.GC.Collect();
	}
	
	public void initSyphonClients(){
		
		foreach(SyphonClientObject obj in unsortedClients){
			//if the server exists and is valid, you may update it with the latest infos about the attached server, and initialize.
			if(Syphon.Servers.ContainsKey(obj.BoundAppName) && Syphon.Servers[obj.BoundAppName].ContainsKey(obj.BoundName)){
				//making the assumption here that the client is not initialized when this method is called.				
				obj.DefineSyphonClient(Syphon.Servers[obj.BoundAppName][obj.BoundName]);
				obj.InitSyphonClient();
			}
		}
				
		Instance.UpdateClientNames();
		
	}


	public static void cacheAssembly(){
		updatedAssembly = true;
		InitServerPlugin();
	}
		
	public static bool assemblyIsUpdated(){
		return updatedAssembly;
	}

	public void Update(){
		if(!updatedAssembly){
			cacheAssembly();
		}
		foreach(SyphonClientObject obj in unsortedClients)
			obj.Render();
	}

	public void LateUpdate(){
		
		Syphon.UpdateTextureSizes();
		
		if(UpdateClientTextures != null){
			UpdateClientTextures();
		}
		
	}
	
	public void Awake() {

		cacheAssembly();	
//		DontDestroyOnLoad(this.gameObject);




		//if there is an extra instance of Syphon that exists, destroy it. 
		//Syphon is supposed to act like a singleton, so force it to behave like one.
		if (Syphon.Instance != null && Syphon.Instance != this) {
			DestroyImmediate(this);
			return;
		} 

		//force the instance references to be valid each time you play the game.
		instance =  this;

		Instance.initSyphonServers();
		Instance.initSyphonClients();	
		//print(serverAppNames.Count +" " + Syphon.ServerAppNames.Count);
		initialized = true;
	}
	
	public static void OnTextureSizeChanged(int ptr, int width, int height){
//		Debug.Log("Syphon Texture size changed! ptr: " + ptr + " w/h: " + width + " " + height);
		
		foreach(SyphonClientObject obj in Syphon.UnsortedClients){
			if(obj.SyphonClientPointer == ptr){
				obj.UpdateTextureSize(width, height);
			}
		}
	}

	public static void OnAnnounceServer(string appName, string name, string uuid, int serverPtr){
		// UnityEngine.Debug.Log("Announcing the server with the appName: "
		// + appName + ", name: " + name + ", uuid: " + uuid + " server Pointer: "+ (int)serverPtr);
		
		if(!Syphon.Servers.ContainsKey(appName)){
			Syphon.Servers.Add(appName, new Dictionary<string, SyphonServerObject>());
		}
		if(name == ""){			
			if(!Syphon.Servers[appName].ContainsKey(Syphon.UNNAMED_STRING)){
				Syphon.Servers[appName].Add(Syphon.UNNAMED_STRING, new SyphonServerObject(appName, name, uuid, serverPtr));
			}
		}		
		else if(!Syphon.Servers[appName].ContainsKey(name)){			
				Syphon.Servers[appName].Add(name, new SyphonServerObject(appName, name, uuid, serverPtr));			
		}

		Instance.UpdateServerNames();
		
		if(AnnounceServer != null)
			AnnounceServer(appName, name);
	}
	
		public static void OnUpdateServer(string appName, string name, string uuid, int serverPtr){
	//		UnityEngine.Debug.Log("Updating the server with the appName: " + appName + ", name: " + name + ", uuid: " + uuid);

		// 	for(int i = 0; i < myself.myClientObjects.Count; i++){
		// 		//should now check all clients to see if any were using this SyphonClient. if so, respond appropriately.
		// 		myself.myClientObjects[i].handleServerUpdate(myself.myServers[myIndex]);
		// 	}

				Instance.UpdateServerNames();
				if(UpdateServer != null)
					UpdateServer(appName, name);
		}

		public static void OnRetireServer(string appName, string name,  string uuid){
			if(Syphon.Servers.ContainsKey(appName)){
				if(name == ""){
					if(Syphon.Servers[appName].ContainsKey(Syphon.UNNAMED_STRING)){
						Syphon.Servers[appName].Remove(Syphon.UNNAMED_STRING);					

						if(Syphon.Servers[appName].Count == 0){
							Syphon.Servers.Remove(appName);
						}
					}
				}
				else if(Syphon.Servers[appName].ContainsKey(name)){
						Syphon.Servers[appName].Remove(name);

					if(Syphon.Servers[appName].Count == 0){
						Syphon.Servers.Remove(appName);
					}
				}

				Instance.UpdateServerNames();
			}
			
			RemoveClient(appName, name);

			if(RetireServer != null)
				RetireServer(appName, name);	
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
		if(RepaintServerListGUI != null)
			RepaintServerListGUI();
	}
	

	
	public static SyphonClientObject GetSyphonClient(string appName, string name){
		return Syphon.UnsortedClients.Find( delegate (SyphonClientObject obj) {			
			return obj.MatchesDescription(appName, name);
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
		
	public static void AddClientToUnsortedList(string appName, string name, SyphonServerObject server){		
		SyphonClientObject result = GetSyphonClient(appName, name);
		// Debug.Log(result.BoundAppName + " " + result.BoundName + " was the result");
		if(result == null){
//			Debug.Log("DIDNT EXIST: " + appName + "/" +name);
			//if it was null when trying to add a new client, just add a new one and init.
			Syphon.UnsortedClients.Add(ScriptableObject.CreateInstance<SyphonClientObject>() );
			Syphon.UnsortedClients[Syphon.UnsortedClients.Count -1 ].DefineSyphonClient(server);
			Syphon.UnsortedClients[Syphon.UnsortedClients.Count -1 ].InitSyphonClient();
		}
		else{
//			Debug.Log("EXISTED: " + appName + "/" +name);
			result.DestroySyphonClient();
			result.DefineSyphonClient(server);
			result.InitSyphonClient();
		}
	}

	//CLIENT METHODS
	public static void CreateClient(string appName, string name){
		//make sure the server exists..
		if(name == Syphon.UNNAMED_STRING && Syphon.Servers.ContainsKey(appName) && Syphon.Servers[appName].ContainsKey(Syphon.UNNAMED_STRING)){
			AddClientToUnsortedList(appName, Syphon.UNNAMED_STRING,  Syphon.Servers[appName][Syphon.UNNAMED_STRING]);
		}
		else if(Syphon.Servers.ContainsKey(appName) && Syphon.Servers[appName].ContainsKey(name)){
			AddClientToUnsortedList(appName, name, Syphon.Servers[appName][name]);
		}
		//update the client names array (for gui display)
		Instance.UpdateClientNames();
	}
	

	//removes the client from the clients list and destroys it.
	public static void DestroyClient(SyphonClientObject destroyObj){
		if(destroyObj != null){
			Syphon.UnsortedClients.Remove(destroyObj);
			DestroyImmediate(destroyObj);
			destroyObj = null;
			Syphon.Instance.UpdateClientNames();
		}		
	}
	
	public static void RemoveClient(string appName, string name){
		//make sure the server exists...
// 		SyphonServerObject match = null;
// 		if(name == ""){
// 			if(match = GetServerObject(appName, Syphon.UNNAMED_STRING)){
// 			Syphon.ServersList.Remove(match );
// 			Debug.Log("REMOVED " + appName + " " + Syphon.UNNAMED_STRING);
// 			}			
// 		}
// 		else if(match = GetServerObject(appName, name)){
// 		Syphon.ServersList.Remove(match );
// 		Debug.Log("REMOVED " + appName + " " + name);
// 		}
// 		
// 		if(Syphon.Clients.ContainsKey(appName) && Syphon.Clients[appName].ContainsKey(name)){
// 			//make sure you destroy to remove the texture and clean up plugin references
// //			Syphon.Clients[appName][name].DestroySyphonClient();
// 
// 			Syphon.Clients[appName].Remove(name);
// 			
// 
// 			if(Syphon.Clients[appName].Count == 0){
// 				Syphon.Clients.Remove(appName);
// 			}
// 		}
		
		Instance.UpdateClientNames();
	}
	
	
	public void UpdateClientNames(){
		clientAppNames.Clear();

		foreach(SyphonClientObject obj in Syphon.UnsortedClients){
			//if it doesn't contain the appName key yet...
			if(!clientAppNames.ContainsKey(obj.BoundAppName)){
				//add it and create the name key.
				clientAppNames.Add(obj.BoundAppName, new string[1]);
				clientAppNames[obj.BoundAppName][0] = obj.BoundName;
			}
			else{ //if it DID contain the key already, add 1 to the array and append the boundName to the array.
				bool found = false;
				foreach(string foundString in clientAppNames[obj.BoundAppName]){
					if(foundString == obj.BoundName)
						found = true;
				}
				//if the object doesnt exist in the array yet,
				if(!found){
					//append the appName to the BoundAppName array
					string[] newArr = new string[clientAppNames[obj.BoundAppName].Length+1];
					for(int i = 0; i < newArr.Length; i++){
						if( i < newArr.Length-1){
							newArr[i] = clientAppNames[obj.BoundAppName][i];
						}
						else{
							newArr[i] = obj.BoundName;
						}
					}
					clientAppNames[obj.BoundAppName] = newArr;			
				}
			}								 	
		}
		Instance.OnRepaintServerListGUI();
	}
	
	
	public void OnPreRender(){
		//call 1 to cache context.
//		print("client count: " + Instance.clientAppNames.Count );
		GL.IssuePluginEvent(updateContext);
	}



		
	


}