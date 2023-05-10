using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class shaderInteraction : MonoBehaviour
{
    private GameObject tracker;
    private Material material;

    // Start is called before the first frame update
    void Start()
    {
        material = GetComponent<Renderer>().material;
        tracker = GameObject.Find("Player");
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 trackerPos = tracker.GetComponent<Transform>().position;
        material.SetVector("_vertexPlayer", trackerPos);
    }
}
