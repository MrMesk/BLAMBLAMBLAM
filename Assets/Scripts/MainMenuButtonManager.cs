using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenuButtonManager : MonoBehaviour
{
    public void newGameButtonAction(string levelName)
    {
        SceneManager.LoadScene(levelName);
    }

    public void exitGameButtonAction()
    {
        Application.Quit();
    }
}
