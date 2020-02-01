using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnOnCollide : MonoBehaviour
{
	public float appliedForceOnHit = 5f;
	public GameObject spawnedFX;
	public float distanceOffset = 0.5f;
	public LayerMask platformLayerMask;
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
	
	}

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(transform.position, transform.position + transform.up * distanceOffset);
    }

    void OnTriggerEnter(Collider other)
	{
		Debug.Log("Trigger enter !");
		RaycastHit hit;

		if(Physics.Raycast(transform.position + transform.up * distanceOffset, transform.up * -1f, out hit, distanceOffset * 4f, platformLayerMask))
		{
			Rigidbody r = hit.collider.attachedRigidbody;

            r.angularVelocity = Vector3.zero;

			Debug.Log("Raycast hit !");
			r.AddForceAtPosition(transform.up * -1f * appliedForceOnHit, hit.point);

            GameObject fx = Instantiate(spawnedFX, hit.point, transform.rotation);
            Destroy(fx, 5f);
        }
	}
}
