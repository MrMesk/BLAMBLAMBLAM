using UnityEngine;

public class Pause : MonoBehaviour
{
    public bool timePause = false;
    public string homePage;

    // Update is called once per frame
    void Update()
    {
        GamePause();
    }

    /// <summary>
    /// Make the game to pause when we use the Key.
    /// </summary>
    void GamePause()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
            timePause = !timePause;
            TimeStop.TimeStatus(timePause);

        }
    }

    /// <summary>
    /// Manage the UI.
    /// </summary>
    private void OnGUI()
    {
        if (timePause)
        {
            if (GUI.Button(new Rect(Screen.width / 2 - 40, Screen.height / 2 - 45, 160, 50), "Continuer"))
            {
                timePause = !timePause;
                TimeStop.TimeStatus(timePause);
            }

            if (GUI.Button(new Rect(Screen.width / 2 - 40, Screen.height / 2 + 5, 160, 50), "Retourner au menu"))
            {
                Application.Quit();
                Application.LoadLevel(homePage);
            }
        }
    }
}
