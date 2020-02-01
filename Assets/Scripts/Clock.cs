using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Clock : MonoBehaviour
{
    public float timer;
    // Start is called before the first frame update
    void Start()
    {
        timer = 10;
    }

    // Update is called once per frame
    void Update()
    {
        timerIncrementation();
    }

    void timerIncrementation()
    {
        timer -= Time.deltaTime;
        if (timer <= 0)
        {
            Debug.Log("reload");
        }
    }
}
