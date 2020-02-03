using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class VictoryGameMenu : MonoBehaviour
{
    public int nbPickupFinal;   
    //public Collider constructZone;
    public GameObject player;
	public GameObject spawnedFX;

	public GameObject endUI;
	public Text endUItext;
    
    private PlayerInventory inventory;
    public int nbPickupOjective;

	public float remainingTime = 60f;
    private float timer;

	ChangementTowerState twr;

    public string mainMenuName = "Main_menu";


    private bool trigger;
    private bool endGame;

    // Start is called before the first frame update
    void Start()
    {
		endGame = false;
        nbPickupOjective = 0;

		timer = remainingTime;
		twr = GetComponent<ChangementTowerState>();
	}

    // Update is called once per frame
    private void Update()
    {
		TimerManagement();
    }
    
   void TimerManagement()
	{
		if(!endGame)
		{
			if(timer > 0f)
			{
				timer -= Time.deltaTime;
			}
			else
			{
				endGame = true;
				SpawnDefeatUI();
			}
		}
	}



	/// <summary>
	/// Manage where we can give Pickups to Objective
	/// </summary>
	/// <param name="other">The objects who enter on the trigger</param>
	private void OnTriggerEnter(Collider other)
    {
        inventory = other.GetComponent<PlayerInventory>();
        if (inventory != null && inventory.GetPickupCount() > 0)
        {
			nbPickupOjective += inventory.GetPickupCount();
			inventory.GainPickup(-inventory.GetPickupCount());

			twr.TowerState();

			GameObject fx = Instantiate(spawnedFX, other.transform.position, Quaternion.identity);
			Destroy(fx, 3f);
		}

		if(nbPickupOjective >= nbPickupFinal )
		{
			SpawnVictoryUI();
			endGame = true;
		}

    }

    public bool GetVictory()
    {
        return endGame;
    }

    /// <summary>
    /// Cast the nbPickupOjective private variable 
    /// </summary>
    /// <returns>The number of Pickup of the objective</returns>
    public int GetNbPickupOjective()
    {
        return nbPickupOjective;
    }

    public int GetNbPickupFinal()
    {
        return nbPickupFinal;
    }

	void SpawnVictoryUI()
	{
		endUI.SetActive(true);
		endUItext.text = "Victory !";
	}

	void SpawnDefeatUI ()
	{
		endUI.SetActive(true);
		endUItext.text = "You didn't repair the altar in time..";
	}

	public void ReloadScene()
	{
		SceneManager.LoadScene(SceneManager.GetActiveScene().name);
	}

	public void QuitToMenu()
	{
		SceneManager.LoadScene(mainMenuName);
	}
}
