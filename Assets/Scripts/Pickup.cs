using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pickup : MonoBehaviour
{
    public int value = 1;
    public void OnTriggerEnter(Collider other)
    {
        PlayerInventory inventory = other.GetComponent<PlayerInventory>();
        if(inventory != null)
        {
            inventory.gainPickup(value);
            Destroy(gameObject);
        }
    }
}
