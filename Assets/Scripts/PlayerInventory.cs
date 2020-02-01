using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInventory 
{
    private int pickupCount = 0;
    public int getPickupCount()
    {
        return pickupCount;
    }

    public void gainPickup(int pickupGain)
    {
        pickupCount += pickupGain;
        if (pickupCount < 0)
        {
            pickupCount = 0;
        }
    }

}
