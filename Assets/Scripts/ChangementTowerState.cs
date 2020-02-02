using System.Collections.Generic;
using UnityEngine;

public class ChangementTowerState : MonoBehaviour
{
    public GameObject player;
    public GameObject tower;
    public int nbOfStates;
    public Mesh mesh1;
    public Mesh mesh2;
    public Mesh mesh3;
    public Mesh mesh4;

    private int nbPickupObjective;
    private int nbPickupFinal;
    List<int> state;
    List<Mesh> mesh;


    // Start is called before the first frame update
    void Start()
    {
        nbPickupFinal = player.GetComponent<VictoryGameMenu>().GetNbPickupFinal();
        state = new List<int>();
        mesh = new List<Mesh>();
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
        for (int i = 0; i <= nbOfStates; i++)
        {
            state.Add((nbPickupFinal / nbOfStates) * (i + 1));
        }
        mesh.Add(mesh1);
        mesh.Add(mesh2);
        mesh.Add(mesh3);
        mesh.Add(mesh4);
    }



    /// <summary>
    /// Manage the State of the Tower
    /// </summary>
    void TowerState()
    {
        nbPickupObjective = player.GetComponent<VictoryGameMenu>().GetNbPickupOjective();

        for (int i = 0; i < state.Count; i++)
        {
            if (nbPickupObjective >= state[i] && nbPickupObjective < state[i + 1])
            {
                tower.GetComponent<MeshFilter>().mesh = mesh[i];
            }
        }
    }
}
