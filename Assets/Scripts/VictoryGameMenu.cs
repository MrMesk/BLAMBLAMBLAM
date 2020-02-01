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
    private float timer;
    public string nextlevel;
    public string homePage;

    // Start is called before the first frame update
    void Start()
    {
        nbPickupOjective = 0;
    }

    private void Update()
    {
        
        endOfTheGame();
    }
    // Update is called once per frame
    private void endOfTheGame()
    {
        timer = player.GetComponent<Clock>().timer;
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

    public int GetNbPickupOjective()
    {
        return nbPickupOjective;
    }

    private void OnGUI()
    {
        if (nbPickupFinal == nbPickupOjective && timer>0)
        {
            GUI.Box(new Rect(Screen.width / 2 - 60, Screen.height / 2 - 120, 180, 250), "Victoire");
            if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2 - 50, 160, 50), "Niveau suivant"))
            {
                Application.LoadLevel(nextlevel);
            }
            if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2 + 10, 160, 50), "Retour au menu principal"))
            {
                Application.LoadLevel(homePage);
            }
        }
    }
}
