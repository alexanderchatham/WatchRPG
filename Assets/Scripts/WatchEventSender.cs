using UnityEngine;
using System.Runtime.InteropServices;

public class WatchEventSender : MonoBehaviour
{
#if UNITY_IOS && !UNITY_EDITOR
    [DllImport("__Internal")]
    static extern void sendEventToWatch(string eventName);
#endif

    public void Send(string eventName)
    {
#if UNITY_IOS && !UNITY_EDITOR
        sendEventToWatch(eventName);
#endif
        Debug.Log($"Event sent to watch: {eventName}");
    }
}
