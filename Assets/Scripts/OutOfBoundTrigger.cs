using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutOfBoundTrigger : MonoBehaviour
{
	[FMODUnity.EventRef]
	public string respawnEventName;
    private void Update()
    {
    }
    private void OnTriggerEnter(Collider other)
    {
        Player2Controleur player = other.GetComponent<Player2Controleur>();

		FMODUnity.RuntimeManager.PlayOneShot(respawnEventName, transform.position);

		if (player != null)
        {

            Debug.Log("Player ded");
            player.Respawn();
        } else
        {
            Destroy(other);
        }
    }
}
