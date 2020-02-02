using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageOnTrigger : MonoBehaviour
{
	public float appliedForceOnHit = 5f;
	public GameObject spawnedFX;
	public float distanceOffset = 0.5f;
	public LayerMask platformLayerMask;

	public bool destroyOnImpact = false;

	private void OnTriggerEnter (Collider other)
	{
		Debug.Log("Trigger enter !");
		RaycastHit hit;

		if(Physics.Raycast(transform.position + transform.up * distanceOffset, transform.up * -1f,out hit, distanceOffset * 4f, platformLayerMask))
		{
			Rigidbody r = hit.collider.attachedRigidbody;

			PlatformLife life = other.GetComponent<PlatformLife>();

			if(life)
			{
				life.ModifLifeValue(-1);
			}

			r.AddForceAtPosition(transform.up * -1f * appliedForceOnHit, hit.point);
			if(destroyOnImpact)
			{
				Destroy(gameObject);
			}

            GameObject particle = Instantiate(spawnedFX, transform.position, Quaternion.identity);
            Destroy(particle, 2f);
		}


	}
}
