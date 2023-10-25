using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dragging : MonoBehaviour
{
    private float dist;
    private bool dragging = false;
    private Vector3 offset;
    private Transform toDrag;
    
    
    // Update is called once per frame
    void Update()
    {
        
        Vector3 v3;
        if (Input.touchCount != 1)
        {
            dragging = false; 
            return;
        }
        
        Touch touch = Input.GetTouch(0);
        
        Vector3 pos = touch.position;
        
        if (touch.phase == TouchPhase.Began)
        {
            RaycastHit hit;
            Ray ray = Camera.main.ScreenPointToRay(pos);
            if (Physics.Raycast(ray, out hit))
            {
                if (!hit.collider.gameObject.CompareTag("plant"))
                {
                    toDrag = hit.transform;
                    dist = hit.transform.position.z - Camera.main.transform.position.z;
                    v3 = new Vector3(pos.x, pos.y, dist);
                    v3 = Camera.main.ScreenToWorldPoint(v3);
                    offset = toDrag.position - v3;
                    dragging = true;
                }
            }
        }
        
        if (dragging && touch.phase == TouchPhase.Moved)
        {
            toDrag.GetComponent<Rigidbody>().useGravity = false;
            v3 = new Vector3(Input.mousePosition.x, Input.mousePosition.y, dist);
            v3 = Camera.main.ScreenToWorldPoint(v3);
            toDrag.position = v3 + offset;
        }
        
        if (dragging && (touch.phase == TouchPhase.Ended || touch.phase == TouchPhase.Canceled))
        {
            dragging = false;
            toDrag.GetComponent<Rigidbody>().useGravity = true;
        }
    }
}
