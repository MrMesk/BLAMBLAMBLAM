using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerInventory : MonoBehaviour
{
    public int pickupCount;
    public int GetPickupCount()
    {
        return pickupCount;
    }

    public void GainPickup(int pickupGain)
    {
        pickupCount += pickupGain;
        if (pickupCount < 0)
        {
            pickupCount = 0;
        }
    }

}
