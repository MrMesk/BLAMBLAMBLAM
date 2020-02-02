using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DefeatGameMenu : MonoBehaviour
{
    public GameObject menu;
    public GameObject player;
    private VictoryGameMenu victoryScript;
    public string level;

    private bool isEnd;
    private float timer;   
    public string homePage;
    private bool victory;

    // Start is called before the first frame update
    private void Start()
    {
        victoryScript = FindObjectOfType<VictoryGameMenu>();
    }
    private void Update()
    {

        timer = player.GetComponent<Clock>().timer;
        victory = victoryScript.GetVictory();
    }


    /// <summary>
    /// Manage the UI.
    /// </summary>
    private void OnGUI()
    {
        if (!victory)
        {
            if (timer <= 0)
            {
                GUI.Box(new Rect(Screen.width / 2 - 60, Screen.height / 2 - 120, 180, 250), "Défaite");
                if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2 - 50, 160, 50), "Réessayer"))
                {
                    SceneManager.LoadScene(level);
                }
                if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2 + 10, 160, 50), "Retour au menu principal"))
                {
                    SceneManager.LoadScene(homePage);
                }
            }
        }
    }
}
