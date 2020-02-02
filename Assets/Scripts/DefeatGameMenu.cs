using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DefeatGameMenu : MonoBehaviour
{
    public GameObject menu;
    public GameObject player;
    public string level;
    private VictoryGameMenu victoryScript;

    private bool isEnd;
    private bool defeat = false;
    private float timer;
    private bool victory;
    public string homePage;

    // Start is called before the first frame update

    private void Update()
    {
        victoryScript = player.GetComponent<VictoryGameMenu>();
        victoryScript.GetVictory();
        ActiveMenu();
      
    }

    /// <summary>
    /// Say if the timer is finish or not
    /// </summary>
    public void ActiveMenu()
    {
        timer = player.GetComponent<Clock>().timer;
        menu.SetActive(isEnd);
        if (!victory)
        {
            if (timer <= 0)
            {
                isEnd = true;

            }
            else
            {
                isEnd = false;
            }
        }
    }

    public bool GetDefeat()
    {
        return defeat;
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
                defeat = true;
                GUI.Box(new Rect(Screen.width / 2 - 60, Screen.height / 2 - 120, 180, 250), "Défaite");
                if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2 - 50, 160, 50), "Réessayer"))
                {
                    Application.LoadLevel(level);
                }
                if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2 + 10, 160, 50), "Retour au menu principal"))
                {
                    Application.LoadLevel(homePage);
                }
            }
        }
    }
}
