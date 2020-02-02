using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Clock :MonoBehaviour
{
    public float timer;

    // Update is called once per frame
    void Update()
    {
        TimerDecrementation();
    }

    /// <summary>
    /// Decrement the timer
    /// </summary>
    public void TimerDecrementation()
    {
        timer -= Time.deltaTime;
    }

    /// <summary>
    /// Manage the UI.
    /// </summary>
    private void OnGUI()
    {
        if (timer >= 0)
        {
            GUI.Box(new Rect(0, 0, 30, 30), ((int)timer).ToString());
        }
    }

}
