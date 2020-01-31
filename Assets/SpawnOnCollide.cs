using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnOnCollide : MonoBehaviour
{
	public GameObject spawnedFX;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

	void OnCollisionEnter (Collision collision)
	{
		GameObject fx = Instantiate(spawnedFX, collision.contacts[0].point, transform.rotation);
		Destroy(fx, 5f);
	}
}
