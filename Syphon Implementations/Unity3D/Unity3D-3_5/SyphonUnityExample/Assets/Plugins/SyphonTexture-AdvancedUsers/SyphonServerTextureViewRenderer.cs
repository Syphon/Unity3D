using UnityEngine;
using System.Collections;
using UnityEngine.UI;
public class SyphonServerTextureViewRenderer : MonoBehaviour {

	private SyphonServerTextureCustomResolution customResolutionScript;
	private Canvas renderCanvas;
	private GameObject renderGO;
	private CanvasScaler renderCanvasScaler;
	private RawImage renderRawImage;
	private GameObject rawImageGO ;
	private RectTransform renderTrans;
	private AspectRatioFitter fitter;
	private int _screenWidth;
	private int _screenHeight;
	private RawImage blackImage;
	private Vector2 texSize;
	private bool initedOnce = false;
	private Camera renderCamera;
	// Use this for initialization
	void Start () {
		customResolutionScript = GetComponent<SyphonServerTextureCustomResolution>();
		customResolutionScript.CreatedRenderTexture += CreatedOrResizedRenderTexture;

		if(customResolutionScript.customRenderTexture != null){
			CreatedOrResizedRenderTexture(customResolutionScript.customRenderTexture);
		}
	}

	public void OnDestroy(){
		if(renderGO != null)
			Destroy(renderGO);

		if(renderCamera != null){
			Destroy(renderCamera.gameObject);
		}

	}

	public void CreatedOrResizedRenderTexture(RenderTexture tex){
		initedOnce = true;

		if(renderGO == null){
			LayerMask layerMask = LayerMask.NameToLayer("UI");

			renderGO = new GameObject();
			renderGO.layer = layerMask;
			renderGO.name = "SyphonServerCustomRezUICanvas";

			renderCanvas = renderGO.AddComponent<Canvas>();
			renderCanvas.gameObject.AddComponent<CanvasScaler>();
			renderCanvas.renderMode = RenderMode.ScreenSpaceCamera; 

			renderCamera = new GameObject().AddComponent<Camera>();
			renderCanvas.worldCamera = renderCamera;
			renderCamera.cullingMask = 1 << layerMask;
			renderCamera.depth = -100;
			renderCamera.name = "SyphonServerCustomRezCam";

			GameObject blackImageGO = new GameObject();
			blackImageGO.layer = layerMask;
			blackImageGO.name = "bg image as black";

			blackImage = blackImageGO.AddComponent<RawImage>();
			blackImage.color = Color.black;
			blackImage.transform.SetParent(renderCanvas.transform, false);

			rawImageGO = new GameObject();
			rawImageGO.name = "SyphonServerCustomResolutionView";
			rawImageGO.layer = layerMask;
			renderRawImage = rawImageGO.AddComponent<RawImage>();
			renderRawImage.transform.SetParent(renderCanvas.transform, false);
			renderRawImage.texture = Camera.main.targetTexture;

			blackImageGO.transform.SetAsFirstSibling();

			renderTrans = (RectTransform) rawImageGO.transform;
			renderTrans.anchorMin = new Vector2(0.5f, 0.5f);
			renderTrans.anchorMax = new Vector2(0.5f, 0.5f);
		}


		if(fitter == null){
			fitter = rawImageGO.AddComponent<AspectRatioFitter>();
		}

		renderRawImage.texture = tex;
		fitter.aspectRatio = tex.width/ (float)tex.height;
		texSize = new Vector2(tex.width, tex.height);
		UpdateScreenWH();
	}

	private void UpdateScreenWH(){
		_screenWidth = Screen.width;
		_screenHeight = Screen.height;
		blackImage.rectTransform.sizeDelta = new Vector2(Screen.width, Screen.height);

		renderTrans.sizeDelta = new Vector2(Screen.width, Screen.height);
		if(Screen.width/(float)texSize.x > Screen.height/(float)texSize.y)
			fitter.aspectMode = AspectRatioFitter.AspectMode.HeightControlsWidth;
		else
			fitter.aspectMode = AspectRatioFitter.AspectMode.WidthControlsHeight;
	}

	// Update is called once per frame
	void Update () {
		if(initedOnce && (Screen.width != _screenWidth || Screen.height != _screenHeight)){
			UpdateScreenWH();
		}
	}
}
