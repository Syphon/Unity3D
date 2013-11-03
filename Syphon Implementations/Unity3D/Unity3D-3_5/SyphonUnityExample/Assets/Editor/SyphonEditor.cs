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
using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
[CustomEditor(typeof(Syphon))]
public class SyphonEditor : Editor {
//	private int GUIServerSelectionIndex = 0;
	private const string SERVERS_LABEL = "SERVERS: ";
	private const string SERVERS_LABEL_NONE = "No Syphon servers detected.";
//	private string serverConfirmKey;
//	private string serverConfirmValue;
//	private bool showServerConfirmState = false;

//	[SerializeField]
//	private int GUIClientSelectionIndex = 0;	
	private const string CLIENTS_LABEL = "CLIENTS: ";
	private const string CLIENTS_LABEL_NONE = "No Syphon clients detected.";
	private string clientConfirmKey;
	private string clientConfirmValue;	
//	[SerializeField]
//	private bool showClientConfirmState = false;
//	[SerializeField]
//	SyphonClientObject selectedClientObj = null;
	
	private bool repaintGUI = false;
	Syphon syphon;
//	private int foldoutState = -1;
	private bool addedSyphonDelegates = false;
	private Syphon syphonTarget;
	public Syphon SyphonTarget{
		get{
			if(!syphonTarget)
				syphonTarget = target as Syphon;
			return syphonTarget;
		}	
	}
	public void addSyphonDelegates(){			
			SyphonTarget.RepaintServerListGUI += new Syphon.RepaintServerListGUIHandler(RepaintGUI);
//			Debug.Log("added event to delegate.");			
			addedSyphonDelegates = true;
	}

	
	public void OnDisable(){
			SyphonTarget.RepaintServerListGUI -= new Syphon.RepaintServerListGUIHandler(RepaintGUI);
			EditorApplication.update -= Update;			
//			Debug.Log("removed event from delegate.");			
			addedSyphonDelegates = false;			
	}
	
	public void OnEnable(){
		EditorApplication.update += Update;
		if(!Application.isPlaying)
		SyphonTarget.Awake();
	}

		
	public void Update(){
		if(repaintGUI){
			this.Repaint();
			repaintGUI = false;
		}
	}
	
	public override void OnInspectorGUI(){



		if(!addedSyphonDelegates){
			addSyphonDelegates();	
		}
		
		//draw the label
		GUILayout.Label(SERVERS_LABEL);
		if(SyphonTarget.serverAppNames.Count == 0)
			GUILayout.Label(SERVERS_LABEL_NONE);
	
		drawGUIServerEditor();		

		GUILayout.Space(5);

//		GUILayout.Label(CLIENTS_LABEL);
//		if(SyphonTarget.clientAppNames.Count == 0)
//			GUILayout.Label(CLIENTS_LABEL_NONE);
		
//		drawGUIClientEditor();	
		

//		if(GUILayout.Button("clear clients list")){
//			foreach(SyphonClientObject obj in Syphon.SyphonClients){
//				DestroyImmediate(obj);
//			}
//			Syphon.SyphonClients.Clear();
////			SyphonTarget.UpdateClientNames();
//		}
		
		
	//	DrawDefaultInspector();
	}		
	
//	public void drawGUIClientEditor(){
//		foreach(KeyValuePair<string,string[]> kvp in SyphonTarget.clientAppNames){
//			GUI.changed = false;
//			int selectIndex = 0;
//			
//			//if you're not drawing the one you've selected, the index is 0.
//			if(kvp.Key != clientConfirmKey){
//				selectIndex = 0;
//			}
//			//otherwise, the index is whatever the selected index is.
//			else
//			selectIndex = GUIClientSelectionIndex;
//			
//			selectIndex = EditorGUILayout.Popup(kvp.Key, selectIndex, kvp.Value);
//			if(GUI.changed){
//				//Debug.Log("Selected: " + kvp.Key + " : " +  kvp.Value[GUIClientSelectionIndex] + "!");
//				GUIClientSelectionIndex = selectIndex;
//				showClientConfirmState = true;
//				clientConfirmKey = kvp.Key;
//				clientConfirmValue = kvp.Value[GUIClientSelectionIndex];
//				selectedClientObj = Syphon.GetSyphonClient(clientConfirmKey, clientConfirmValue);
//			}
//		}
//		
////		if(showClientConfirmState && selectedClientObj != null){
////		
////			SyphonClientObject destroyObj = null;
////
////				GUILayout.BeginHorizontal();
////				GUILayout.BeginVertical();
////				GUILayout.Label("App: "+ selectedClientObj.AttachedServer.SyphonServerDescriptionAppName + "\nName: " +
////				 selectedClientObj.AttachedServer.SyphonServerDescriptionName);
////				if(GUILayout.Button("remove client")){
////					destroyObj = selectedClientObj;
////				}
////				GUILayout.EndVertical();
////				GUILayout.Label(new GUIContent("", selectedClientObj.AttachedTexture,"App: "+
////				 selectedClientObj.AttachedServer.SyphonServerDescriptionAppName + "\nName: "
////				 + selectedClientObj.AttachedServer.SyphonServerDescriptionName), GUILayout.MaxWidth(150), GUILayout.MaxHeight(128));
////				GUILayout.EndHorizontal();
////
////			if(destroyObj != null){
////				Syphon.DestroyClient(destroyObj);
////				showClientConfirmState = false;
////				GUIClientSelectionIndex = 0;
////			}			
////		}
//	}	
//	
	
	public void drawGUIServerEditor(){

		foreach(KeyValuePair<string,string[]> kvp in SyphonTarget.serverAppNames){
			GUI.changed = false;
			int selectIndex = 0;
//			if(kvp.Key != serverConfirmKey){
//				selectIndex = 0;
//			}
//			else
//			selectIndex = GUIServerSelectionIndex;
			
			selectIndex = EditorGUILayout.Popup(kvp.Key, selectIndex, kvp.Value);
//			if(GUI.changed){
//				//Debug.Log("Selected: " + kvp.Key + " : " +  kvp.Value[GUIServerSelectionIndex] + "!");
//				GUIServerSelectionIndex = selectIndex;
//				showServerConfirmState = true;
//				serverConfirmKey = kvp.Key;
//				serverConfirmValue = kvp.Value[selectIndex];
//			}
		}
		
//		if(showServerConfirmState && SyphonTarget.servers.ContainsKey(serverConfirmKey) && SyphonTarget.servers[serverConfirmKey].ContainsKey(serverConfirmValue) ){
//			GUILayout.BeginHorizontal();
//			GUILayout.Label("ADD CLIENT:\nAPP: " + serverConfirmKey + "\nNAME: " + serverConfirmValue);
//			if(GUILayout.Button("YES")){
//				Syphon.CreateClient(serverConfirmKey, serverConfirmValue);
//				showServerConfirmState = false;
//			}
//			else if(GUILayout.Button("NO")){
//				showServerConfirmState = false;				
//			}
//
//			GUILayout.EndHorizontal();
//		}
	}
	
	//this is a nifty way to trigger inspector updates- only triggered by Syphon.cs as needed.
	//this tells the editor to repaint when available, by the EditorApplication.update method. 
	//you can't repaint 'directly' when requested because it may come from another thread, and if you try to repaint from another thread, it may crash.
	public void RepaintGUI(){
		repaintGUI = true;
	}


	
	
	
	// public void drawGUI_non_editor(){
	// 		// int i = 0;
	// 		// bool oneShown = false;
	// 	foreach(KeyValuePair<string,string[]> kvp in Syphon.Instance.serverAppNames){
	// 		//don't delete, may need later for drawGUI (non-editor) - WIP
	// 		// bool showFold = false;
	// 		// if(foldoutState == i)
	// 		// 	showFold = true;						
	// 		// 
	// 		// GUI.changed = false;
	// 		// bool tempShowFold = false;
	// 		// tempShowFold = EditorGUILayout.Foldout(showFold, kvp.Key);
	// 		// if(tempShowFold){
	// 		// 	foldoutState = i;
	// 		// }	
	// 		// 
	// 		// 
	// 		// GUI.changed = false;
	// 		// if(showFold){
	// 		// 	GUIServerSelectionIndex = GUILayout.SelectionGrid(GUIServerSelectionIndex, kvp.Value, 1);
	// 		// 	if(GUI.changed){
	// 		// 		Debug.Log("CHANGED");
	// 		// 	
	// 		// 		oneShown = true;
	// 		// 	}
	// 		// }
	// 		// i++;
	// 		
	// 		GUI.changed = false;
	// 		GUIServerSelectionIndex = EditorGUILayout.Popup(kvp.Key, GUIServerSelectionIndex, kvp.Value);
	// 		if(GUI.changed){
	// 			Debug.Log("Selected: " + kvp.Key + " : " +  kvp.Value[GUIServerSelectionIndex] + "!");
	// 		}
	// 	}
	// }
}
