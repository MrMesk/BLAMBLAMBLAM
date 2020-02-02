using System.Collections.Generic;
using UnityEngine;

public class ChangementTowerState : MonoBehaviour
{
    public GameObject player;
    public GameObject tower;
    public int nbOfStates;

    private int nbPickupObjective;
    private int nbPickupFinal;
    List<int> state;
    public List<Mesh> mesh;


    // Start is called before the first frame update
    void Start()
    {
        nbPickupFinal = player.GetComponent<VictoryGameMenu>().GetNbPickupFinal();
        state = new List<int>();
        GenerateListAndMesh();

    }

    // Update is called once per frame
    void Update()
    {

        TowerState();
    }

    /// <summary>
    /// Add contains of lists
    /// </summary>
    void GenerateListAndMesh()
    {
        for (int i = 0; i < nbOfStates; i++)
        {
            state.Add((nbPickupFinal / nbOfStates) * (i + 1));
        }
    }



    /// <summary>
    /// Manage the State of the Tower
    /// </summary>
    void TowerState()
    {
        nbPickupObjective = player.GetComponent<VictoryGameMenu>().GetNbPickupOjective();

        for (int i = 0; i < state.Count-1; i++)
        {
            if (nbPickupObjective >= state[i] && nbPickupObjective < state[i + 1])
            {
                tower.GetComponent<MeshFilter>().mesh = mesh[i];         
            }

            if (nbPickupObjective >= state[state.Count - 1])
            {
                tower.GetComponent<MeshFilter>().mesh = mesh[state.Count - 1];
            }


        }
    }
}
