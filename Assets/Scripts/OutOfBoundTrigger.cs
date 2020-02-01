using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutOfBoundTrigger : MonoBehaviour
{
    //private PlayerPlayer2Controleur player;
    private void OnTriggerEnter(Collider other)
    {   /*
        if(other.GetComponent<Player2Controleur>())
        {
            inflict 9999 damage to player wich kill him and trigger respawn procedure and make him loose all of his pickup
            respawn procedure idéa to implement in player controller
            Vector3 respawnPosition;
            float respawnDelay;
            float timeLeft;
            bool isDead;
            if(isDead) {
                timeLeft -= Time.deltaTime;
                if (timeLeft <= 0)
                {
                    player.transform.position = respawnPosition;
                    isDead = false;
                }
            }
            
        } else
        {*/
            Destroy(other);
       // }
    }
}
