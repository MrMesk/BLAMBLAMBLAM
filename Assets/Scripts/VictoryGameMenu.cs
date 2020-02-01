using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class VictoryGameMenu : MonoBehaviour
{
    public int nbPickupFinal = 10;
    private int nbPickupOjective;
    private bool trigger;
    public Collider constructZone;
    public GameObject player;
    private PlayerInventory inventory;
    private Clock clock = new Clock();

    // Start is called before the first frame update
    void Start()
    {
        nbPickupOjective = 0;
    }

    private void Update()
    {
        clock.timerDecrementation();
        endOfTheGame();
    }
    // Update is called once per frame
    private void endOfTheGame()
    {
        if (trigger)
        {
            nbPickupOjective += inventory.getPickupCount();
            inventory.gainPickup(-inventory.getPickupCount());
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        inventory = other.GetComponent<PlayerInventory>();
        if (inventory != null)
        {
            trigger = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.GetComponent<PlayerInventory>() != null)
        {
            trigger = false;
            inventory = null;
        }
    }

    private void OnGUI()
    {
        if (nbPickupFinal == nbPickupOjective && clock.timer>0)
        {
            GUI.Box(new Rect(Screen.width / 2 - 60, Screen.height / 2 - 120, 180, 250), "Victory");
            if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2 - 50, 160, 50), "Next Level"))
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
