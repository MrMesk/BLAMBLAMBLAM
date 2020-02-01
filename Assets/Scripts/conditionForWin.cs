using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class conditionForWin : MonoBehaviour
{
    public int nbPickupFinal = 10;
    private int nbPickupOjective;
    private bool trigger;
    public Collider constructZone;
    public CharacterController player;
    public PlayerInventory inventory;
    // Start is called before the first frame update
    void Start()
    {
        nbPickupOjective = 0;
    }

    // Update is called once per frame
    void Update()
    {
        endOfTheGame();

    }

    private void endOfTheGame()
    {
        if (trigger)
        {
            nbPickupOjective += inventory.getPickupCount();
            inventory.gainPickup(-inventory.getPickupCount());
            if (nbPickupFinal == nbPickupOjective)
            {
                Debug.Log("Win");
            }
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



}
