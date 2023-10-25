using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spawner : MonoBehaviour
{
    // method to spawn plant
    public GameObject plant;
    public Camera cam;

    public void SpawnPlant()
    {
        // spawn plant in front of camera
        Vector3 spawnPos = cam.transform.position + cam.transform.forward * 1.5f + cam.transform.up * 0.5f;
        Instantiate(plant, spawnPos, transform.rotation);
        // Instantiate(plant, transform.position, transform.rotation);
    }
}
