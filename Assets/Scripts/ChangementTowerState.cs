using System.Collections.Generic;
using UnityEngine;

public class ChangementTowerState : MonoBehaviour
{
    public GameObject player;
    public GameObject tower;
    public int nbOfStates;

    private int nbPickupObjective;
    private int nbPickupFinal;

    public List<Mesh> mesh;
    public List<int> state;

	MeshFilter towerMesh;
	VictoryGameMenu menu;

    // Start is called before the first frame update
    void Start()
    {
        nbPickupFinal = FindObjectOfType<VictoryGameMenu>().GetNbPickupFinal();
        state = new List<int>();

		towerMesh = tower.GetComponent<MeshFilter>();
		menu = GetComponent<VictoryGameMenu>();

		GenerateListAndMesh();

    }

    // Update is called once per frame
    void Update()
    {

       // TowerState();
    }

    /// <summary>
    /// Add contains of lists
    /// </summary>
    void GenerateListAndMesh()
    {
        for (int i = 0; i < nbOfStates; i++)
        {
            state.Add((nbPickupFinal / nbOfStates) * (i + 1));  //pickf=4 
        }

    }



    /// <summary>
    /// Manage the State of the Tower
    /// </summary>
   public  void TowerState()
    {
        nbPickupObjective = FindObjectOfType<VictoryGameMenu>().GetNbPickupOjective();

        for (int i = 0; i < state.Count-1; i++)
        {
            if (nbPickupObjective >= state[i] && nbPickupObjective < state[i+1])
            {
				towerMesh.mesh = mesh[i];
            }
        }
        if (nbPickupObjective >= state[state.Count - 1])
        {
			towerMesh.mesh = mesh[mesh.Count - 1];
        }
    }
}
