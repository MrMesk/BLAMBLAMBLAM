using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlatformLife : MonoBehaviour
{
	[SerializeField] int startLifePoints = 1;
	[SerializeField] int maxLifePoints = 1;

	int currentLifePoints = 1;

	public void ModifLifeValue(int amount)
	{
		currentLifePoints += amount;

		currentLifePoints = Mathf.Clamp(currentLifePoints, 0, maxLifePoints);	

		if(currentLifePoints == 0)
		{
			Debug.Log("DED");
			Destroy(gameObject);
		}
	}
    // Start is called before the first frame update
    void Start()
    {
		currentLifePoints = startLifePoints;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
