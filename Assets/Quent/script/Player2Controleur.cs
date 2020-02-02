﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//using UnityStandardAssets.CrossPlatformInput;

[RequireComponent(typeof(PlayerInventory))]
public class Player2Controleur : MonoBehaviour
{
    public Vector3 respawnPosition;
    public float respawnDelay;
    public int maxLifePoint;

    public float vitesse;
    public string xInput="Horizontal";
    public string zInput="Vertical";
    public string jumpInput = "Jump";
    public float maxVelocity;

    public Transform groundCheckOrigine;
    public Vector3 groundDirection;
    public float groundDistance;
    public Vector3 jumpDirection;
    public float jumpForce;
    public LayerMask groundLayer;
    public ForceMode jumpType;

    public ParticleSystem traineeParticule;
    public float multiplieurRate;
    public float miniRate;
    bool isGrounded;

    private int currentLifePoint;
    private bool isResponing;
    private bool hasBeenSlowDown;

    Rigidbody rigid;

    void Start()
    {
        rigid = transform.GetComponent<Rigidbody>();
        
        isResponing = false;
        currentLifePoint = maxLifePoint;
    }

    void Update()
    {
        isGrounded = GroundCheck(groundCheckOrigine, groundDirection, groundDistance, groundLayer);

        /*if (isResponing)
        {
            if (transform.position.y <= respawnPosition.y + transform.localScale.y * 1 && !hasBeenSlowDown)
            {
                //Rigidbody playerRigidbody = gameObject.GetComponent<Rigidbody>();
                rigid.velocity = rigid.velocity * 0.05f;
                hasBeenSlowDown = true;
            } else if(transform.position == respawnPosition)
            {
                isResponing = false;

                //FIX LES BAILS AVEC UNE COROUTINE
            }
        }*/
        if (isResponing == false)
        {
            transform.LookAt(transform.position + GetPlayerDirection());
            if (Input.GetButtonDown(jumpInput) && GroundCheck(groundCheckOrigine, groundDirection, groundDistance, groundLayer))
            {
                Debug.Log("jump");
                AddForce(jumpForce * jumpDirection, rigid, jumpType, true);
            }
        }

        var emission = traineeParticule.emission;
        emission.rateOverTime = Mathf.Clamp( rigid.velocity.magnitude * multiplieurRate,miniRate,maxVelocity*multiplieurRate);
        //traineeParticule.emission.rateOverTime=rigid.velocity * multiplieurRate;
        if(isGrounded==false && traineeParticule.isPlaying)
        {
            traineeParticule.Stop();
        }
        if (isGrounded && traineeParticule.isPlaying == false)
        {
            traineeParticule.Play();
        }
        Vector3 direc = GetPlayerDirection()*vitesse*Time.deltaTime;
        if (isResponing == false)
        {
            transform.Translate(direc, Space.World);
           /* rigid.AddForce(direc, ForceMode.Acceleration);
            rigid.velocity.Set(Mathf.Clamp(rigid.velocity.x, 0, maxVelocity), rigid.velocity.y, Mathf.Clamp(rigid.velocity.z, 0, maxVelocity));*/
            //Debug.Log(rigid.velocity);
        }
        
    }
    
    public IEnumerator GestionChute()
    {
        while (transform.position.y > respawnPosition.y + transform.localScale.y * 1 && !hasBeenSlowDown)
        {
            yield return null;
        }
        rigid.velocity = rigid.velocity * 0.05f;
        hasBeenSlowDown = true;
        isResponing = false;
    }

    public void Respawn()
    {
        hasBeenSlowDown = false;
        isResponing = true;
        PlayerInventory inventory = gameObject.GetComponent<PlayerInventory>();

        if(inventory)
        {
            inventory.GainPickup(-inventory.GetPickupCount());
        }
        else
        {
            Debug.Log("No player inventory");
        }

        currentLifePoint = maxLifePoint;
        float estimatedHeight = (float)(0.5 * 9.81 * Mathf.Pow(respawnDelay, 2));
        transform.position = new Vector3(respawnPosition.x, respawnPosition.y + estimatedHeight, respawnPosition.z);
        StartCoroutine(GestionChute());
    }

    public void takeDamage(int damage)
    {
        currentLifePoint -= damage;
        if (currentLifePoint <= 0)
        {
            Respawn();
        } else if (currentLifePoint > maxLifePoint)
        {
            currentLifePoint = maxLifePoint;
        }
    }

    public Vector3 GetPlayerDirection()
    {
        return new Vector3(Input.GetAxis(xInput), 0f, Input.GetAxis(zInput));
    }

    public bool GroundCheck(Transform origine, Vector3 direction, float distance, LayerMask layer)
    {
        bool isGround = Physics.Raycast(origine.position, direction, distance, layer);
        return isGround;
    }

    public void AddForce(Vector3 direction, Rigidbody rigid, ForceMode modeForce, bool resetvelocity)
    {
        if (resetvelocity)
        {
            rigid.velocity.Set(rigid.velocity.x, 0, rigid.velocity.z);
        }
        rigid.AddForce(direction, modeForce);
    }
}
