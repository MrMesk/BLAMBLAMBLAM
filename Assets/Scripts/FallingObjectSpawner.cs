using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FallingObjectSpawner : MonoBehaviour
{
    public GameObject objectToSpawn;
    public float timeBetweenSpawn;
    public float variation;
    public float spawningHeight;
    public Vector2 minPos;
    public Vector2 maxPos;

    private float nextSpawnDecount;

    void Start()
    {
        nextSpawnDecount = calculateNextSpawn();
    }

    void Update()
    {
        nextSpawnDecount -= Time.deltaTime;
        if(nextSpawnDecount <= 0)
        {
            Vector3 spawningPosition = new Vector3(Random.Range(minPos.x, maxPos.x), spawningHeight, Random.Range(minPos.y, maxPos.y));
            Instantiate(objectToSpawn, spawningPosition, new Quaternion(0,0,0,0));
            nextSpawnDecount = calculateNextSpawn();
        }
    }

    private float calculateNextSpawn()
    {
		float time = timeBetweenSpawn + variation * Random.Range(-1, 1);
		time = Mathf.Clamp(time, 0f, timeBetweenSpawn + variation);

		return time;
    }
}
