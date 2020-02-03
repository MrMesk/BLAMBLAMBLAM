using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pickup : MonoBehaviour
{
	public GameObject fx;
    public int value = 1;

    private void OnTriggerEnter(Collider other)
    {
        PlayerInventory inventory = other.GetComponent<PlayerInventory>();
        if(inventory != null)
        {
            inventory.GainPickup(value);

			if(fx !=null)
			{
				GameObject spawnedFX = Instantiate(fx, transform.position, transform.rotation);
				Destroy(spawnedFX, 2f);
			}
            Destroy(gameObject);
        }
    }
}
