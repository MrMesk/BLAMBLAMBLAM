﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pause : MonoBehaviour
{
    public bool timepause = false;
    // Start is called before the first frame update
    void Start()
    {
       
    }

    // Update is called once per frame
    void Update()
    {
        GamePause(); 
    }

    void GamePause()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
            timepause = !timepause;
            TimeStop.TimeStatus(timepause);

        }
    }

    private void OnGUI()
    {
        if (timepause)
        {
           if(GUI.Button(new Rect(Screen.width / 2 - 40, Screen.height / 2 - 45, 160, 50), "Continuer")){
                timepause = !timepause;
                TimeStop.TimeStatus(timepause);
            }

           if(GUI.Button(new Rect(Screen.width / 2 - 40, Screen.height / 2+5, 160, 50),"Retourner au menu"))
            {
                Application.Quit();
                Application.LoadLevel("Main menu");
            }
        }
    }
}