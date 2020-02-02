using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightObject : MonoBehaviour
{

    public GameObject objectForLight;
    public GameObject player;

    private int tmpObjective;
    private int scoreOfTower;
    private float timer = 0;
    private float timerLight = 2;


    // Update is called once per frame
    void Update()
    {
        ActiveLightForTower();
    }

    void ActiveLightForTower()
    {
        scoreOfTower = player.GetComponent<VictoryGameMenu>().GetNbPickupOjective();

        if (scoreOfTower != tmpObjective)
        {

            if (timer <= timerLight)
            {
                TimerIncrementation();
                objectForLight.GetComponent<Light>().intensity += 2;

                if (timer >= 0)
                {
                    TimerDecrementation();
                    objectForLight.GetComponent<Light>().intensity -= 2;

                }
            }
        }

        tmpObjective = scoreOfTower;
    }

    void TimerIncrementation()
    {
        timer += Time.deltaTime;
    }

    void TimerDecrementation()
    {
        timer -= Time.deltaTime;
    }
}
