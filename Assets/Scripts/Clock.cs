using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Clock :MonoBehaviour
{
    public float timer;

    // Update is called once per frame
    void Update()
    {
        timerDecrementation();
    }


    public void timerDecrementation()
    {
        timer -= Time.deltaTime;
    }

    private void OnGUI()
    {
        GUI.Box(new Rect(0, 0, 30, 30), ((int)timer).ToString());
    }

}
