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

[System.Serializable]
public class SyphonServerObject {
	
	[SerializeField]
	private string m_SyphonServerDescriptionName;
	[SerializeField]
	private string m_SyphonServerDescriptionAppName;
	[SerializeField]
	private string m_SyphonServerDescriptionUUID;
	[SerializeField]
	private IntPtr syphonServerPointer = IntPtr.Zero;
	[SerializeField]
	public IntPtr SyphonServerPointer{
		get{ return syphonServerPointer;}
	}
	[SerializeField]
	public string SyphonServerDescriptionName{
		get{ return m_SyphonServerDescriptionName; }
		set{ m_SyphonServerDescriptionName = value; }
	}
	[SerializeField]
	public string SyphonServerDescriptionAppName{
		get{ return m_SyphonServerDescriptionAppName; }
		set{ m_SyphonServerDescriptionAppName = value; }
	}
	[SerializeField]
	public string SyphonServerDescriptionUUID{
		get{ return m_SyphonServerDescriptionUUID; }
		set{ m_SyphonServerDescriptionUUID = value; }
	}
	

	// public void OnEnable(){
	// 	isDestroyed = false;
	// }
	// public void OnDisable(){
	// 	Debug.Log("DESTROYING: " + SyphonServerDescriptionAppName +  " / " + SyphonServerDescriptionName);
	// }
	
	public SyphonServerObject(){
			
	}
	
	//null constructor
	public SyphonServerObject(string a, string n, string uuid, IntPtr ptr){
		SyphonServerDescriptionAppName = a;
		SyphonServerDescriptionName = n;
		SyphonServerDescriptionUUID = uuid;
		syphonServerPointer = ptr;	
	}
	
	public  SyphonServerObject(SyphonServerObject deepCopyConstruct){
		SyphonServerDescriptionAppName = deepCopyConstruct.SyphonServerDescriptionAppName;
		SyphonServerDescriptionName = deepCopyConstruct.SyphonServerDescriptionName;
		SyphonServerDescriptionUUID = deepCopyConstruct.SyphonServerDescriptionUUID;
		syphonServerPointer = deepCopyConstruct.SyphonServerPointer;
	}
	
	
	public void CreateSyphonServer(string a, string n, string uuid, IntPtr ptr){
		SyphonServerDescriptionAppName = a;
		SyphonServerDescriptionName = n;
		SyphonServerDescriptionUUID = uuid;
		syphonServerPointer = ptr;
//		Debug.Log("INITIALIZED AT: " + a + " "  + n + " " + uuid);
	}

	
	public void CreateSyphonServer(SyphonServerObject deepCopy){
		SyphonServerDescriptionAppName = deepCopy.SyphonServerDescriptionAppName;
		SyphonServerDescriptionName = deepCopy.SyphonServerDescriptionName;
		SyphonServerDescriptionUUID = deepCopy.SyphonServerDescriptionUUID;
		syphonServerPointer = deepCopy.SyphonServerPointer;
	}
	


  public static bool operator == (SyphonServerObject a,SyphonServerObject b){
	if(object.ReferenceEquals (a, b))
		return true;
	
	 if (object.ReferenceEquals(a, null) || object.ReferenceEquals(b, null) )
	 	return false;
	
	if(a.SyphonServerDescriptionName == b.SyphonServerDescriptionName && a.SyphonServerDescriptionAppName == b.SyphonServerDescriptionAppName){
		return true;
	}	
	else{
		return false;
	}		
    }

	  public bool Match(string appName, string name) {
	if(SyphonServerDescriptionName == name && SyphonServerDescriptionAppName == appName){
		return true;
	}	
	else{
		return false;
	}
	    }

    public static bool operator != (SyphonServerObject a, SyphonServerObject b) {
	return !(a == b);	
    }

    public override bool Equals (System.Object other) {
        return object.ReferenceEquals (this, other);
    }

    // We get a compile warning if we don't override this one too
    public override int GetHashCode () {
        return base.GetHashCode ();
    }

}
