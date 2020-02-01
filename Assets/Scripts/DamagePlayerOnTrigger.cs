using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamagePlayerOnTrigger : MonoBehaviour
{
	[SerializeField] float impactRange = 3f;
	[SerializeField] int damage = 1;
	[SerializeField] LayerMask playerLayer = 0;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

	private void OnTriggerEnter (Collider other)
	{
		Collider[] t = Physics.OverlapSphere(transform.position, impactRange, playerLayer);
		foreach(Collider player in t)
		{
			Player2Controleur c = player.GetComponent<Player2Controleur>();
			if(c != null)
			{
				//c.DAMAGEASFUCK
			}
		}
	}
}
