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
        generateList();
        nbPickupFinal = player.GetComponent<VictoryGameMenu>().nbPickupFinal;
        multiplier = 0;
    }

    // Update is called once per frame
    void Update()
    {
        towerState();
    }

    void generateList()
    {
        for (int i = 0; i <= nbOfStates; i++)
        {
            state.Add(nbPickupFinal / nbOfStates * multiplier + 1);
        }
    }

    void towerState()
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
