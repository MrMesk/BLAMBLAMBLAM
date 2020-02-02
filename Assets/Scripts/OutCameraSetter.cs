using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutCameraSetter : MonoBehaviour
{
    Camera cam;
    // Start is called before the first frame update
    void Start()
    {
        cam = GetComponent<Camera>();

        cam.stereoTargetEye = StereoTargetEyeMask.None;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
