using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleTestCharacter : MonoBehaviour
{
	[SerializeField] float moveSpeed = 5f;
	Rigidbody r;
    // Start is called before the first frame update
    void Start()
    {
		r = GetComponent<Rigidbody>();
    }

	Vector3 GetMoveDir()
	{
		Vector3 moveDir = new Vector3(Input.GetAxis("Horizontal"), 0f, Input.GetAxis("Vertical"));

		return moveDir;
	}
    // Update is called once per frame
    void Update()
    {
		transform.Translate(GetMoveDir() * Time.deltaTime * moveSpeed);
    }
}
