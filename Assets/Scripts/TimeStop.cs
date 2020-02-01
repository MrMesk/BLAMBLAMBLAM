using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class TimeStop
{
   /// <summary>
   /// Manage the pause.
   /// </summary>
   /// <param name="timePause"></param>
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
