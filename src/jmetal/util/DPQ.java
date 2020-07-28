/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.util;

/**
 *
 * @author mahib
 */
import grph.Grph;
import grph.VertexPair;
import java.util.HashSet; 
import java.util.Set;
import java.util.Queue;
import java.util.List;
import java.util.PriorityQueue;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

public class DPQ { 
    private double dist[]; 
    private int parent[]; 
    private Set<Integer> settled; 
    private Set<Integer> forbidden_node;
    private PriorityQueue<Node> pq; 
    private int V; // Number of vertices 
    List<List<Node> > adj; 
    
  
    public DPQ(int V) 
    { 
        this.V = V; 
        
        adj = new ArrayList<List<Node> >(); 
  
        // Initialize list for every node 
        for (int i = 0; i < V; i++) { 
            List<Node> item = new ArrayList<Node>(); 
            adj.add(item); 
        } 
  
        // Inputs for the DPQ graph 
        adj.get(0).add(new Node(1, 9)); 
        adj.get(0).add(new Node(2, 6)); 
        adj.get(0).add(new Node(3, 5)); 
        adj.get(0).add(new Node(4, 3)); 
  
        adj.get(2).add(new Node(1, 2)); 
        adj.get(2).add(new Node(3, 4)); 
    } 
    
    public DPQ(Grph g, double [][] time) 
    { 
        this.V = g.getNumberOfVertices(); 
        
        adj = new ArrayList<List<Node> >(); 
  
        // Initialize list for every node 
        for (int i = 0; i < V; i++) { 
            List<Node> item = new ArrayList<Node>(); 
            adj.add(item); 
        }
        
        ArrayList<VertexPair> edge_list = new ArrayList<>();
        edge_list = (ArrayList<VertexPair>) g.getEdgePairs();
        for (VertexPair vp: edge_list) {
            if (time[vp.first][vp.second] <= 0) {
                new Error ("There is some errors in my code");
            }
            adj.get(vp.first).add(new Node(vp.second, time[vp.first][vp.second]));
            adj.get(vp.second).add(new Node(vp.first, time[vp.first][vp.second]));
        }
        // System.out.println("All Edges Inserted ... " + index);
    } 
    
    // Function for Dijkstra's Algorithm 
    public ArrayList<Integer> dijkstra(int src, int des) 
    {
        dist = new double[V]; 
        parent = new int[V]; 
        settled = new HashSet<Integer>(); 
        pq = new PriorityQueue<Node>(V, new Node()); 
        ArrayList<Integer> path = new ArrayList<Integer>();
         
  
        for (int i = 0; i < V; i++) 
            dist[i] = Integer.MAX_VALUE; 
  
        // Add source node to the priority queue 
        pq.add(new Node(src, 0)); 
  
        // Distance to the source is 0 
        dist[src] = 0; 
        parent[src] = src;
        while (settled.size() != V) { 
  
            // remove the minimum distance node  
            // from the priority queue 
            int u = pq.remove().node; 
            
            // adding the node whose distance is 
            // finalized 
            settled.add(u); 
            if (u == des)
                break;
  
            e_Neighbours(u); 
        } 
        
        if (parent[des] == 0) {
            new Error("Some errors in shortest path calculation");
        }
        int u = des;
        while (parent[u] != u) {
            path.add(u);
            u = parent[u];
        }
        path.add(u);
        assert(path.get(0) == des);
        assert(path.get(path.size() - 1) == src);
        Collections.reverse(path);
        return path;
    } 
  
    // Function to process all the neighbours  
    // of the passed node 
    private void e_Neighbours(int u) 
    { 
        double edgeDistance = -1; 
        double newDistance = -1; 
        int par = -1;
        
        // All the neighbors of v 
        for (int i = 0; i < adj.get(u).size(); i++) { 
            Node v = adj.get(u).get(i); 
            
            if (forbidden_node.contains(v.node)) {
                continue;
            }
            // If current node hasn't already been processed 
            if (!settled.contains(v.node)) { 
                edgeDistance = v.cost; 
                newDistance = dist[u] + edgeDistance; 
  
                // If new distance is cheaper in cost 
                if (newDistance < dist[v.node]) {
                    dist[v.node] = newDistance; 
                    parent[v.node] = u;
                }
                    
  
                // Add the current node to the queue 
                pq.add(new Node(v.node, dist[v.node])); 
            } 
        } 
    } 
    
    public void set_forbidden_nodes(int [] l, int tar) {
        forbidden_node = new HashSet<Integer>();
        forbidden_node.clear();
        for (int i = 0; i < l.length; i++) {
            if (l[i] == tar) {
                continue;
            }
            forbidden_node.add(l[i]);
        }
    }
  
    // Driver code 
    public static void main(String arg[]) 
    { 
        int V = 5; 
        int source = 0; 
        int destination = 1;
        ArrayList<Integer> p = new ArrayList<Integer>();
        // Adjacency list representation of the  
        // connected edges 
        
  
        // Calculate the single source shortest path 
        DPQ dpq = new DPQ(V); 
        dpq.set_forbidden_nodes(new int[] {2}, 2);
        p = dpq.dijkstra(source, destination); 
  
        // Print the shortest path to all the nodes 
        // from the source node 
        System.out.println("Length of shortest path: " + p.size());
        for (Integer e: p) {
            System.out.println(e);
        }
    } 
} 
  
// Class to represent a node in the graph 
class Node implements Comparator<Node> { 
    public int node; 
    public double cost; 
    public Node() 
    { 
    } 
  
    public Node(int node, double cost) 
    { 
        this.node = node; 
        this.cost = cost; 
    } 
  
    @Override
    public int compare(Node node1, Node node2) 
    { 
        if (node1.cost < node2.cost) 
            return -1; 
        if (node1.cost > node2.cost) 
            return 1; 
        return 0; 
    } 
} 
