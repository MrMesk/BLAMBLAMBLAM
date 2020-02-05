using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VibrationManager : MonoBehaviour
{
	public static VibrationManager instance;
	void Start()
	{
		if(instance && instance != this)
		{
			Destroy(this);
		}
		else
		{
			instance = this;
		}

	}

   public void TriggerVibration(int iteration, int frequency, int strength , OVRInput.Controller controller)
	{
		OVRHapticsClip clip = new OVRHapticsClip();

		for(int i = 0; i < iteration; i++)
		{
			//clip.WriteSample
		}

		if(controller == OVRInput.Controller.LTouch)
		{
			OVRHaptics.LeftChannel.Preempt(clip);
		}
		else if(controller == OVRInput.Controller.RTouch)
		{
			OVRHaptics.RightChannel.Preempt(clip);
		}
		else
		{
			OVRHaptics.LeftChannel.Preempt(clip);
			OVRHaptics.RightChannel.Preempt(clip);

		}
	}
}
