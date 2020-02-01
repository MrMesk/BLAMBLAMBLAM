using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class spikeGround : MonoBehaviour
{
    public float attackDelay;
    public float dammageDeal;

    private bool triggered;
    private bool onCouldown;
    private float delaySinceTriggered;
    private PlayerInventory player;

    void Start()
    {
        triggered = false;
        delaySinceTriggered = 0;
        player = null;
    }

    void Update()
    {
        if(triggered)
        {
            delaySinceTriggered += Time.deltaTime;
            if(delaySinceTriggered >= attackDelay)
            {
                delaySinceTriggered = 0;
                if (onCouldown)
                {
                    onCouldown = false;
                } 
                else
                {
                    //take damage de damageDeal + potential slow
                    onCouldown = true;
                }
                delaySinceTriggered = 0;
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        player = other.GetComponent<PlayerInventory>(); 
        if(player != null)
        {
            triggered = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.GetComponent<PlayerInventory>() != null)
        {
            triggered = false;
            player = null;
        }
    }
}
