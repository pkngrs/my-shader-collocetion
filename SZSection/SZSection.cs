using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SZSection : MonoBehaviour
{
    public GameObject sector;
    public ComputeShader shader;
    public float radius;

    private int m_kernel;
    private Mesh m_mesh;
    void Start()
    {
        m_kernel = shader.FindKernel("Assert");
        m_mesh = GetComponent<MeshFilter>().mesh;
        Color[] colors = new Color[m_mesh.vertexCount];
        for (int i = 0; i < m_mesh.vertexCount; i++)
        {
            colors[i] = new Color(1, 1, 1, 1);
        }
        m_mesh.colors = colors;
    }

    void Update()
    {
        m_mesh.colors = GPGPU(m_mesh);
    }

    Color[] GPGPU(Mesh m)
    {
        Color[] result = new Color[m.vertexCount];

        ComputeBuffer vertices = new ComputeBuffer(m.vertexCount, 12);
        ComputeBuffer colors = new ComputeBuffer(m.vertexCount, 16);
        vertices.SetData(m.vertices);
        colors.SetData(m.colors);

        shader.SetBuffer(m_kernel, "Vertices", vertices);
        shader.SetBuffer(m_kernel, "VertColors", colors);
        shader.SetFloat("SectorRadius", radius);
        shader.SetVector("SectorPos", sector.transform.position);

        shader.Dispatch(m_kernel, m.vertexCount, 1, 1);
        colors.GetData(result);

        colors.Dispose();
        vertices.Dispose();

        return result;
    }
}
