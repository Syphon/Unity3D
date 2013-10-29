using UnityEngine;
using System.Collections;

public class ControlSurfaceExample : MonoBehaviour {
	float slider1Val = 0;
	float slider2Val = 0;

	//implement a function OnControlSurfaceGUI(), and write any OnGUI code you like, in it.
	void OnControlSurfaceGUI(){
		GUILayout.Label ("this code shows how to have a GUI as a control surface, " +
			"while feeding a custom rez video texture to Syphon." +
			"note that your Syphon output does not show this gui- it's only visible in the unity app." +
		                 "Just add the OnControlSurfaceGUI delegate like this example shows");
		GUILayout.BeginHorizontal (GUILayout.Width (100));

		GUILayout.BeginVertical ();
		GUILayout.Label ("slider1: " + slider1Val, GUILayout.Height (50), GUILayout.Width (50));
		slider1Val = GUILayout.VerticalSlider(slider1Val, 0.0f, 1.0f, GUILayout.Height (200), GUILayout.Width (50));
		GUILayout.EndVertical ();

		GUILayout.BeginVertical ();
		GUILayout.Label ("slider2: " + slider2Val,GUILayout.Height (50), GUILayout.Width (50));
		slider2Val = GUILayout.VerticalSlider(slider2Val, 0.0f, 1.0f, GUILayout.Height (200), GUILayout.Width (50));
		GUILayout.EndVertical ();
		GUILayout.EndHorizontal ();
	}


	//enable and disable the delegate callbacks as shown below, for OnControlSurfaceGUI
	void OnDisable(){
		SyphonServerTextureCustomResolution.OnControlSurfaceGUI -= new SyphonServerTextureCustomResolution.OnControlSurfaceGUIHandler(OnControlSurfaceGUI);
	}

	void OnEnable(){
		SyphonServerTextureCustomResolution.OnControlSurfaceGUI += new SyphonServerTextureCustomResolution.OnControlSurfaceGUIHandler(OnControlSurfaceGUI);
	}


}
