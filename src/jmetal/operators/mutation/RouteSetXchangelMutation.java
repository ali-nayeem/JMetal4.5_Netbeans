/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.operators.mutation;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
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
public class RouteSetXchangelMutation extends Mutation
{

    private static final List VALID_TYPES = Arrays.asList(RouteSetSolutionType.class);

    private Double mutationProbability_ = 1.0;
    private Double addProbability = 0.5;
    //public static int addCount = 0;

    public RouteSetXchangelMutation(HashMap<String, Object> parameters)
    {
        super(parameters);
        if (parameters != null)
        {
            if (parameters.get("probability") != null)
            {
                mutationProbability_ = (Double) parameters.get("probability");
            }
            if (parameters.get("addProbability") != null)
            {
                addProbability = (Double) parameters.get("addProbability");
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

        //System.out.println("Add Mutataion");
        xchange(rs, (TNDP) solution.getProblem());

    }

    private void xchange(RouteSet rs, TNDP prob)
    {
        int maxNode = prob.ins.getMaxNode();
        int minNode = prob.ins.getMinNode();
        int I = numberOfNodes(maxNode, rs.size());
        int[] rIndex = new int[rs.size()];
        for (int i = 0; i < rs.size(); i++)
        {
            rIndex[i] = i;
        }
        PseudoRandom.shuffleArray(rIndex);
        for (int i = 0; i < rIndex.length; i++)
        {
            Route ri = rs.routeSet.get(rIndex[i]);
            if (ri.nodeList.size() < 3)
            {
                continue;
            }
            ArrayList<Integer> riNodes = new ArrayList<>(ri.nodeList);
            riNodes.remove(0);
            riNodes.remove(riNodes.size() - 1);
            for (int j = 0; j < rIndex.length; j++)
            {
                if (i == j)
                {
                    continue;
                }
                Route rj = rs.routeSet.get(rIndex[j]);
                if (rj.nodeList.size() < 3)
                {
                    continue;
                }
                ArrayList<Integer> rjNodes = new ArrayList<>(rj.nodeList);
                rjNodes.remove(0);
                rjNodes.remove(rjNodes.size() - 1);
                
                rjNodes.retainAll(riNodes);
                if(rjNodes.size() > 0)
                {

                    while(rjNodes.size() > 0)
                    {
                        int xIndex = PseudoRandom.nextInt(rjNodes.size());
                        int xNode = rjNodes.get(xIndex);
                        rjNodes.remove(xIndex);
                        
                        int riXI = ri.nodeList.indexOf(xNode);
                        ArrayList<Integer> ri1 = new ArrayList<>(ri.nodeList.subList(0, riXI));
                        ArrayList<Integer> ri2 = new ArrayList<>(ri.nodeList.subList(riXI,ri.size()));
                        
                        int rjXI = rj.nodeList.indexOf(xNode);
                        ArrayList<Integer> rj1 = new ArrayList<>(rj.nodeList.subList(0, rjXI));
                        ArrayList<Integer> rj2 = new ArrayList<>(rj.nodeList.subList(rjXI, rj.size()));
                        
                        int riLen = ri1.size()  + rj2.size();
                        if( riLen < minNode || riLen > maxNode)
                        {
                            continue;
                        }
                        
                        int rjLen = rj1.size() + ri2.size();
                        if (rjLen < minNode || rjLen > maxNode)
                        {
                            continue;
                        }
                        
                        ri.nodeList.clear();
                        ri.nodeList.addAll(ri1);
                        ri.nodeList.addAll(rj2);
                        
                        rj.nodeList.clear();
                        rj.nodeList.addAll(rj1);
                        rj.nodeList.addAll(ri2);
                        
                        return;
                    } 
                }
            }
        }
    }

    private int numberOfNodes(int Max, int r)
    {
        return PseudoRandom.randInt(1, (int) Math.round(mutationProbability_ * r * Max / 2));
    }

}

//                    int[] xIndices = new int[rjNodes.size()];
//                    for (int k = 0; k < xIndices.length; k++)
//                    {
//                        xIndices[k] = k;
//                    }
//                    PseudoRandom.shuffleArray(xIndices);
//                    for (int k = 0; k < xIndices.length; k++)
//                    {
//                        
//                    }