using UnityEngine;

public class Pause : MonoBehaviour
{
    public bool timepause = false;
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
            timepause = !timepause;
            TimeStop.TimeStatus(timepause);

        }
    }

    /// <summary>
    /// Manage the UI.
    /// </summary>
    private void OnGUI()
    {
        if (timepause)
        {
            if (GUI.Button(new Rect(Screen.width / 2 - 40, Screen.height / 2 - 45, 160, 50), "Continuer"))
            {
                timepause = !timepause;
                TimeStop.TimeStatus(timepause);
            }

            if (GUI.Button(new Rect(Screen.width / 2 - 40, Screen.height / 2 + 5, 160, 50), "Retourner au menu"))
            {
                Application.Quit();
                Application.LoadLevel(homePage);
            }
        }
    }
}
