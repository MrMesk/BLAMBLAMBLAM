using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutCameraSetter : MonoBehaviour
{
    Camera cam;
    // Start is called before the first frame update
    void Awake()
    {
	/*for (int i = 1; i < Display.displays.Length; i++)
		{
			Display.displays[i].Activate();
		}*/

		cam = GetComponent<Camera>();

        cam.stereoTargetEye = StereoTargetEyeMask.None;
		//cam.fieldOfView = 60f;

		Screen.SetResolution(1920, 1080, true);

	}

    // Update is called once per frame
    void Update()
    {
		//cam.fieldOfView = 60f;
	}
}
