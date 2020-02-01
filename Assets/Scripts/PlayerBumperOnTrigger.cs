using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBumperOnTrigger : MonoBehaviour
{
	[SerializeField] float bumpRange = 5f;
	[SerializeField] float bumpForce = 10f;
	[SerializeField] LayerMask playerMask = 0;

	public void BumpPlayer()
	{
		Collider[] c = Physics.OverlapSphere(transform.position, bumpRange, playerMask);
		foreach(Collider player in c)
		{
			Player2Controleur p = player.GetComponent<Player2Controleur>();

			if(p != null)
			{
				Rigidbody r = p.GetComponent<Rigidbody>();
				p.AddForce(transform.up * bumpForce, r, ForceMode.Impulse, true);
			}
		}
	}

	private void OnTriggerEnter (Collider other)
	{
		BumpPlayer();
	}
}
