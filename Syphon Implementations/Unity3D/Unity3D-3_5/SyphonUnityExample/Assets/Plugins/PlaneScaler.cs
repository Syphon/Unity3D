using UnityEngine;
using System.Collections;

public class PlaneScaler : MonoBehaviour {

// Copyright 2011-2013 Brian Chasalow & Anton Marini - brian@chasalow.com - All Rights Reserved.

	//simply scales a square-sized gameObject based on the dimensions given
	public void UpdateAspectRatio(Vector2 texWidthHeight){		
		//if you just want a simple way to resize a mesh, use the following.
		float aspectRatio = 0.0f;
		float myWidth, myHeight;
		if(texWidthHeight.x >= texWidthHeight.y){
		aspectRatio  = texWidthHeight.y/(float)texWidthHeight.x;
		myWidth = 1;
		myHeight = aspectRatio;
		transform.localScale = new Vector3(myWidth, 1, myHeight);
		 }
		
		//weird tall movie
		else{			
		aspectRatio  = texWidthHeight.x/(float)texWidthHeight.y;
		myHeight = 1;
		myWidth = aspectRatio;	
		transform.localScale = new Vector3(myWidth, 1, myHeight);
		}
	}
	

}
