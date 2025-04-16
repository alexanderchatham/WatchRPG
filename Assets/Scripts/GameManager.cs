// GameManager.cs
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public void OnXPReceivedFromWatch(string xpString)
    {
        int xp = int.Parse(xpString);
        Debug.Log("Received XP from Watch: " + xp);
        // Apply XP to your character, update UI, etc.
    }
    void Awake()
    {
        Application.runInBackground = true;
    }

}
