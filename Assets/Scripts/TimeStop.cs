using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class TimeStop
{
    // Start is called before the first frame update
    public static void TimeStatus(bool timePause)
    {
        if (timePause)
        {
            Time.timeScale = 0;
        }
        else
        {
            Time.timeScale = 1;
        }

    }
}
