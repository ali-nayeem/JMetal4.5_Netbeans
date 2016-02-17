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
public class RouteSetAddlMutation extends Mutation
{

    private static final List VALID_TYPES = Arrays.asList(RouteSetSolutionType.class);

    private Double mutationProbability_ = 1.0;
    private Double addProbability = 0.5;
    public static int addCount = 0;

    public RouteSetAddlMutation(HashMap<String, Object> parameters)
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
        add(rs, (TNDP) solution.getProblem());

    }

    private void add(RouteSet rs, TNDP prob)
    {
        int maxNode = prob.ins.getMaxNode();
        int I = numberOfNodes(maxNode, rs.size());
        int[] rIndex = new int[rs.size()];
        for (int i = 0; i < rs.size(); i++)
        {
            rIndex[i] = i;
        }
        PseudoRandom.shuffleArray(rIndex);
        for (int i = 0; i < rIndex.length; i++)
        {
            Route r = rs.routeSet.get(rIndex[i]);
            if (r.size() == maxNode)
            {
                continue;
            }

            for (int j = 1; j > -1; j--)
            {
                while (r.size() < maxNode)
                {
                    int terminalNode = r.nodeList.get(j * (r.size() - 1));
                    ArrayList<Integer> tAdjList = prob.g.getNeighbours(terminalNode).toIntegerArrayList();
                    tAdjList.removeAll(r.nodeList);
                    if (tAdjList.isEmpty())
                    {
                        break;
                    }
                    if (j == 0)
                    {
                        r.nodeList.add(0, tAdjList.get(PseudoRandom.nextInt(tAdjList.size())));
                    } else
                    {
                        r.nodeList.add(tAdjList.get(PseudoRandom.nextInt(tAdjList.size())));
                    }
                    I--;

                    if (I == 0)
                    {
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
