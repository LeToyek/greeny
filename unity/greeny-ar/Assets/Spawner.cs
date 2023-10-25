using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public struct PlantModel {
    public string name;
    public GameObject image;
}

public class Spawner : MonoBehaviour
{
    public Camera cam;

    public PlantModel[] plants;

    public void SpawnPlant(string model = "DefaultPlant")
    {
        GameObject plant = null;
        
        foreach (PlantModel p in plants)
        {
            if (p.name == model)
            {
                plant = p.image;
            }
        }
        
        if (plant == null)
        {
            plant = plants[0].image;
        }
        
        // get GameObject tagged 'plane' in front of camera
        RaycastHit hit;
        Ray ray = cam.ScreenPointToRay(new Vector3(Screen.width / 2, Screen.height / 2, 0));
        
        if (Physics.Raycast(ray, out hit))
        {
            if (hit.collider.gameObject.CompareTag("plane"))
            {
                // spawn plant in front of camera
                Vector3 spawnPos = hit.point + hit.normal * 0.5f;
                Instantiate(plant, spawnPos, transform.rotation);
            }
        }
        // spawn plant in front of camera
        // Vector3 spawnPos = cam.transform.position + cam.transform.forward * 1.5f + cam.transform.up * 0.5f;
        // Instantiate(plant, spawnPos, transform.rotation);
        // Instantiate(plant, transform.position, transform.rotation);
    }

    public void SpawnFromFlutter(string message)
    {
        SpawnPlant(message);
    }
}