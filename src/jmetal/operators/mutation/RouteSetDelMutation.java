/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.operators.mutation;

import grph.Grph;
import grph.in_memory.InMemoryGrph;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import jmetal.core.Solution;
import jmetal.encodings.solutionType.RouteSetSolutionType;
import jmetal.encodings.variable.Route;
import jmetal.encodings.variable.RouteSet;
import jmetal.problems.TNDP.TNDP;
import jmetal.util.Configuration;
import jmetal.util.JMException;
import jmetal.util.PseudoRandom;

/**
 *
 * @author MAN
 */
public class RouteSetDelMutation extends Mutation
{

    private static final List VALID_TYPES = Arrays.asList(RouteSetSolutionType.class);

    private Double mutationProbability_ = 1.0;
    public static int delCount = 0;

    public RouteSetDelMutation(HashMap<String, Object> parameters)
    {
        super(parameters);
        if (parameters != null)
        {
            if (parameters.get("probability") != null)
            {
                mutationProbability_ = (Double) parameters.get("probability");
            }

        }
    }

    @Override
    public Object execute(Object object) throws JMException
    {
        Solution solution = (Solution) object;

        
        doMutation(solution);
        return solution;
    }

    private void doMutation(Solution solution)
    {
        RouteSet rs = (RouteSet) solution.getDecisionVariables()[0];
        // System.out.println("Delete Mutataion");
        del(rs, (TNDP) solution.getProblem());
        //delCount++;

    }
    
    private void del(RouteSet rs, TNDP prob)
    {
        int minNode = prob.ins.getMinNode();
        int maxNode = prob.ins.getMaxNode();
        int Vertices = prob.ins.getNumOfVertices();
        int I = numberOfNodes(maxNode, rs.size());
        Grph reducedGraph = new InMemoryGrph();
        // reducedGraph.display();
        for (int i = 0; i < rs.size(); i++)
        {
            reducedGraph.addVertex();
        }
        int[][] rAdjMat = new int[rs.size()][rs.size()];
        Set[] nodeDistib = new Set[Vertices];

        for (int i = 0; i < Vertices; i++)
        {
            nodeDistib[i] = new HashSet();
        }
        for (int i = 0; i < rs.size(); i++)
        {
            Route r = rs.getRoute(i);
            for (int node : r.nodeList)
            {
                nodeDistib[node].add(i);
            }
        }
        for (int i = 0; i < rs.size(); i++)
        {
            for (Set<Integer> nd : nodeDistib)
            {
                if (nd.size() > 1 && nd.contains(i))
                {
                    for (int rId : nd)
                    {
                        if (rId > i)
                        {
                            rAdjMat[i][rId] = ++rAdjMat[rId][i];
                            if (rAdjMat[i][rId] == 1)
                            {
                                reducedGraph.addUndirectedSimpleEdge(i, rId);
                            }
                        }
                    }
                }
            }
        }

        int[] rIndex = new int[rs.size()];
        for (int i = 0; i < rs.size(); i++)
        {
            rIndex[i] = i;
        }
        PseudoRandom.shuffleArray(rIndex);
        for (int i = 0; i < rIndex.length; i++)
        {
            Route r = rs.routeSet.get(rIndex[i]);
            if (r.size() == minNode)
            {
                continue;
            }

            for (int j = 1; j > -1; j--)
            {
                while (r.size() > minNode)
                {
                    int termIndex = j * (r.size() - 1);
                    int terminalNode = r.nodeList.get(termIndex);
                    if (nodeDistib[terminalNode].size() < 2)
                    {
                        break;
                    }
                    if (canBeDeleted(rIndex[i], rAdjMat, reducedGraph, nodeDistib[terminalNode]))
                    {
                        r.nodeList.remove(termIndex);
                        I--;
                        if (I == 0)
                        {
                            return;
                        }
                    } else
                    {
                        break;
                    }

                }
            }
        }
    }

    private boolean canBeDeleted(int rId, int[][] rAdjMat, Grph reducedGraph, Set<Integer> routes)
    {
        int[][] rAdjMatBackup = new int[rAdjMat.length][];
        for (int i = 0; i < rAdjMat.length; i++)
        {
            rAdjMatBackup[i] = Arrays.copyOf(rAdjMat[i], rAdjMat[i].length);
        }
        Set<Integer> disconnectedRoutes = new HashSet<>();
        //removal process starts
        routes.remove(rId);
        for (int otherRoute : routes)
        {
            rAdjMat[rId][otherRoute] = --rAdjMat[otherRoute][rId];
            if (rAdjMat[rId][otherRoute] == 0)
            {
                disconnectedRoutes.add(otherRoute);
                reducedGraph.removeEdge(reducedGraph.getEdgesConnecting(rId, otherRoute).getGreatest());
            }

        }
        //removal process ends
        if (disconnectedRoutes.isEmpty())
        {
            return true;
        }

        if (reducedGraph.isConnected())
        {
            return true;
        }

        //undo removal
        routes.add(rId);
        for (int i = 0; i < rAdjMat.length; i++)
        {
            rAdjMat[i] = rAdjMatBackup[i];
        }
        for (int otherId : disconnectedRoutes)
        {
            reducedGraph.addUndirectedSimpleEdge(rId, otherId);
        }
        return false;

    }

    private int numberOfNodes(int Max, int r)
    {
        return PseudoRandom.randInt(1, (int) Math.round(mutationProbability_ * r * Max / 2));
    }

}
