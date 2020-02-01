using System.Collections.Generic;
using UnityEngine;

public class ChangementTowerState : MonoBehaviour
{
    public GameObject player;
    public int nbOfStates;
    private int multiplier;
    private int nbPickupObjective;
    private int nbPickupFinal;
    List<int> state;

    // Start is called before the first frame update
    void Start()
    {
        state = new List<int>();
        GenerateList();
        nbPickupFinal = player.GetComponent<VictoryGameMenu>().nbPickupFinal;
        multiplier = 0;
    }

    // Update is called once per frame
    void Update()
    {
        TowerState();
    }

    /// <summary>
    /// Add contains of the list
    /// </summary>
    void GenerateList()
    {
        for (int i = 0; i <= nbOfStates; i++)
        {
            state.Add((nbPickupFinal / nbOfStates) * (multiplier + 1));
        }
    }

    /// <summary>
    /// Manage the State of the Tower
    /// </summary>
    void TowerState()
    {
        nbPickupObjective = player.GetComponent<VictoryGameMenu>().GetNbPickupOjective();

        foreach (int s in state)
        {
            if (nbPickupObjective == s)
            {
                //Recupere les niveau de meshs en fonction
            }
        }
    }
}
