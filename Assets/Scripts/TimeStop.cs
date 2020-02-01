using UnityEngine;

public static class TimeStop
{
    /// <summary>
    /// Manage the pause.
    /// </summary>
    /// <param name="timePause">The state of the time for test him</param>
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
