using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DefeatGameMenu : MonoBehaviour
{
   
    private float timer;
    private Clock clock= new Clock();
    public GameObject menu;
    private bool isEnd;

    // Start is called before the first frame update

    private void Update()
    {
        clock.timerDecrementation();
        Debug.Log(clock.timer);
        activeMenu();
    }

    public void activeMenu()
    {
        timer = clock.timer;
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

    private void OnGUI()
    {
        if (timer <= 0)
        {
            GUI.Box(new Rect(Screen.width / 2 - 60, Screen.height / 2 - 120, 180, 250), "Defeat");
            if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2-50, 160, 50), "Retry"))
            {
                Application.LoadLevel("level1");
            }
            if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2 + 10, 160, 50), "Retour au menu principal"))
            {
                Application.LoadLevel("Main menu");
            }
        }
    }
}
