using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DamageOnTrigger : MonoBehaviour
{
	public float cooldown = .3f;

	public AudioClip slamSFX;
	public OVRInput.Controller vibrateController;
	float timer;
	public float baseAppliedForce = 500;
	public float maxForce = 25000f;
	public float forceDamp = 5f;
	public GameObject spawnedFX;
	public float distanceOffset = 0.5f;
	public LayerMask platformLayerMask;

	public float baseShakeStrength = 1f;
	public float shakeDuration = .2f;

	public float minAvgSpeed = 10f;

	Shaker shaker;

	public bool debugLog = false;

	public int speedSampleSize = 20;

	public bool destroyOnImpact = false;
	Vector3 lastPos;

	List<float> lastSpeeds = new List<float>();

	Rigidbody r;

	float avgSpeed;
	float speed;

	private void Start ()
	{
		shaker = FindObjectOfType<Shaker>();
		r = GetComponent<Rigidbody>();
		timer = 0f;
	}

	void TimerManagement()
	{
		if(timer < cooldown)
		{
			timer += Time.deltaTime;
		}
	}
	private void OnTriggerEnter (Collider other)
	{
		if (timer >= cooldown)
		{
			//Debug.Log("Trigger enter !");
			RaycastHit hit;

			if(Physics.Raycast(transform.position + transform.up * distanceOffset, transform.up * -1f,out hit, distanceOffset * 2f, platformLayerMask))
			{
				Rigidbody r = hit.collider.attachedRigidbody;

				/*PlatformLife life = other.GetComponent<PlatformLife>();

				if(life)
				{
					life.ModifLifeValue(-1);
				}*/
				//Debug.Log("Avg speed : " + avgSpeed);
				if(minAvgSpeed > 0f)
				{
					if(avgSpeed >= minAvgSpeed)
					{
						if(r) r.AddForceAtPosition(transform.up * -1f * GetImpactForce(), hit.point);

						GameObject particle = Instantiate(spawnedFX, hit.point, Quaternion.identity);
						particle.transform.up = hit.normal;
						Destroy(particle, 2f);


						//VibrationManager.instance.TriggerVibration(slamSFX, vibrateController);
						StartCoroutine(Vibrate());
						timer = 0f;

						if(destroyOnImpact)
						{
							Destroy(gameObject);
						}
					}

				}
				else
				{
					if (r)
						r.AddForceAtPosition(transform.up * -1f * GetImpactForce(), hit.point);

					GameObject particle = Instantiate(spawnedFX, hit.point, Quaternion.identity);
					particle.transform.up = hit.normal;
					Destroy(particle, 2f);


					//VibrationManager.instance.TriggerVibration(slamSFX, vibrateController);
					StartCoroutine(Vibrate());
					timer = 0f;

					if (destroyOnImpact)
					{
						Destroy(gameObject);
					}
				}
			}
			
		}
	}

	public IEnumerator Vibrate()
	{
		OVRInput.SetControllerVibration(0.3f, 0.3f, vibrateController);
		yield return new WaitForSeconds(0.3f);
		OVRInput.SetControllerVibration(0, 0, vibrateController);

	}

	float GetSpeed()
	{
		speed = (transform.position - lastPos).magnitude / Time.deltaTime;

		lastPos = transform.position;
		

		if(speed < 3f)
		{
			lastSpeeds.Clear();
			lastSpeeds.Add(speed);
		}
		else
		{
			lastSpeeds.Add(speed);
			if(lastSpeeds.Count > speedSampleSize)
			{
				lastSpeeds.RemoveAt(0);
			}
		}
		return speed;
		
	}

	void GetAverageSpeed()
	{
		float totalSpeed = 0;

		foreach(float s in lastSpeeds)
		{
			totalSpeed += s;
		}

		avgSpeed = totalSpeed / lastSpeeds.Count;
	}

	private void Update ()
	{
		GetSpeed();
		GetAverageSpeed();
		TimerManagement();
	}

	float GetImpactForce()
	{
		float velocity = r.velocity.magnitude;
		float impactForce = Mathf.Clamp(baseAppliedForce, avgSpeed * baseAppliedForce / forceDamp, maxForce);

		if(shaker)shaker.Shake(shakeDuration, impactForce * baseShakeStrength / maxForce);
		//Debug.Log("Velocity : " + GetSpeed());
		if (debugLog) Debug.Log("Avg Speed : " + avgSpeed, gameObject);
		if (debugLog) Debug.Log("Speed : " + speed, gameObject);
		if (debugLog)Debug.Log("Impact Force : " + impactForce, gameObject);
		return impactForce;
	}

	
}
