using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using UnityStandardAssets.CrossPlatformInput;

public class Player2Controleur : MonoBehaviour
{
    public Vector3 respawnPosition;
    public float respawnDelay;
    public int maxLifePoint;

    private int currentLifePoint;
    private bool isResponing;
    private bool hasBeenSlowDown;
    void Start()
    {
        isResponing = false;
        currentLifePoint = maxLifePoint;
    }

    void Update()
    {
        if (isResponing)
        {
            if (transform.position.y <= respawnPosition.y + transform.localScale.y * 1 && !hasBeenSlowDown)
            {
                Rigidbody playerRigidbody = gameObject.GetComponent<Rigidbody>();
                playerRigidbody.velocity = playerRigidbody.velocity * 0.05f;
                hasBeenSlowDown = true;
            } else if(transform.position == respawnPosition)
            {
                isResponing = false;
            }
        } else
        {
            //gérer les déplacements
        }
    }
    public void respawn()
    {
        hasBeenSlowDown = false;
        isResponing = true;
        PlayerInventory inventory = gameObject.GetComponent<PlayerInventory>();
        inventory.gainPickup(-inventory.getPickupCount());
        currentLifePoint = maxLifePoint;
        float estimatedHeight = (float)(0.5 * 9.81 * Mathf.Pow(respawnDelay, 2));
        transform.position = new Vector3(respawnPosition.x, respawnPosition.y + estimatedHeight, respawnPosition.z);
    }

    public void takeDamage(int damage)
    {
        currentLifePoint -= damage;
        if (currentLifePoint <= 0)
        {
            respawn();
        } else if (currentLifePoint > maxLifePoint)
        {
            currentLifePoint = maxLifePoint;
        }
    }
}
