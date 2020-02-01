using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DefeatGameMenu : MonoBehaviour
{
   
    private float timer;
    public GameObject menu;
    private bool isEnd;
    public GameObject player;
    public string level;
    public string homePage;

    // Start is called before the first frame update

    private void Update()
    {
       
        ActiveMenu();
    }

    /// <summary>
    /// Say if the timer is finish or not
    /// </summary>
    public void ActiveMenu()
    {
        timer = player.GetComponent<Clock>().timer;
        menu.SetActive(isEnd);
        if (timer <= 0)
        {
            isEnd = true;
            
        }
        else
        {
            isEnd = false;
        }
       
    }

    /// <summary>
    /// Manage the UI.
    /// </summary>
    private void OnGUI()
    {
        if (timer <= 0)
        {
            GUI.Box(new Rect(Screen.width / 2 - 60, Screen.height / 2 - 120, 180, 250), "Défaite");
            if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2-50, 160, 50), "Réessayer"))
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
