using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class VictoryGameMenu : MonoBehaviour
{
    public int nbPickupFinal;   
    //public Collider constructZone;
    public GameObject player;
    
    private PlayerInventory inventory;
    public int nbPickupOjective;
    private float timer;
    public string nextlevel;
    public string homePage;
    private bool trigger;
    private bool victory;

    // Start is called before the first frame update
    void Start()
    {
        victory = false;
        nbPickupOjective = 0;
    }

    // Update is called once per frame
    private void Update()
    {
        
        GiveToObjective();
    }
    
    /// <summary>
    /// Give Pickups to objective
    /// </summary>
    private void GiveToObjective()
    {
        timer = player.GetComponent<Clock>().timer;
        if (trigger)
        {
           
            nbPickupOjective += inventory.GetPickupCount();
            Debug.Log(nbPickupOjective);
            inventory.GainPickup(-inventory.GetPickupCount());
        }
    }


    /// <summary>
    /// Manage where we can give Pickups to Objective
    /// </summary>
    /// <param name="other">The objects who enter on the trigger</param>
    private void OnTriggerEnter(Collider other)
    {
        inventory = FindObjectOfType<PlayerInventory>();
        if (inventory != null)
        {
            Debug.Log("triger");
            trigger = true;
        }
    }

    public bool GetVictory()
    {
        return victory;
    }

    /// <summary>
    /// Manage where we can't give Pickups to Objective
    /// </summary>
    /// <param name="other">The objects who enter on the trigger</param>
    private void OnTriggerExit(Collider other)
    {
        Debug.Log("trigerexit");
        if (other.GetComponent<PlayerInventory>() != null)
        {
            trigger = false;
            inventory = null;
        }
    }

    /// <summary>
    /// Cast the nbPickupOjective private variable 
    /// </summary>
    /// <returns>The number of Pickup of the objective</returns>
    public int GetNbPickupOjective()
    {
        return nbPickupOjective;
    }

    public int GetNbPickupFinal()
    {
        return nbPickupFinal;
    }
    /// <summary>
    /// Manage the UI
    /// </summary>
    private void OnGUI()
    {
        if (nbPickupFinal == nbPickupOjective && timer>0 || victory)
        {
            victory = true;
            GUI.Box(new Rect(Screen.width / 2 - 60, Screen.height / 2 - 120, 180, 250), "Victoire");
            if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2 - 50, 160, 50), "Niveau suivant"))
            {
                SceneManager.LoadScene(nextlevel);
            }
            if (GUI.Button(new Rect(Screen.width / 2 - 50, Screen.height / 2 + 10, 160, 50), "Retour au menu principal"))
            {
                SceneManager.LoadScene(homePage);
            }
        }
    }
}
