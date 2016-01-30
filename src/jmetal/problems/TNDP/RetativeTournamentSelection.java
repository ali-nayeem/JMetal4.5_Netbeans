/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import jmetal.core.Solution;
import jmetal.core.SolutionSet;
import jmetal.operators.selection.Selection;
import jmetal.util.JMException;
import jmetal.util.PseudoRandom;

/**
 *
 * @author MAN
 */
public class RetativeTournamentSelection extends Selection
{

    private int tSize_ = 40;

    public RetativeTournamentSelection(HashMap<String, Object> parameters)
    {
        super(parameters);
        if ((parameters != null) && (parameters.get("tSize") != null))
        {
            tSize_ = (Integer) parameters.get("tSize");
        }
    }

    @Override
    public Object execute(Object object) throws JMException
    {
        SolutionSet population = (SolutionSet) object;
        ArrayList<Integer> candIndex = new ArrayList<>();
        for (int i = 0; i < population.size(); i++)
        {
            candIndex.add(i);
        }
        int pos1;
        pos1 = PseudoRandom.randInt(0, population.size() - 1);
        Solution[] parents = new Solution[2];
        parents[0] = population.get(pos1);
        candIndex.remove(pos1);
        parents[1] = doRelativeTournament(parents[0], candIndex,population );

        return parents;
    }

    private Solution doRelativeTournament(Solution ref, ArrayList<Integer> candIndex, SolutionSet population)
    {
        int ci = candIndex.get(PseudoRandom.randInt(0, candIndex.size() - 1));
        Solution nearest = population.get(ci);
        double nearestDist = getEuclideanDistance(ref,nearest);
        for (int i = 0; i < tSize_ - 1; i++)
        {
            ci = candIndex.get(PseudoRandom.randInt(0, candIndex.size() - 1));
            Solution next = population.get(ci);
            double nextDist = getEuclideanDistance(ref, next);
            if(nextDist < nearestDist)
            {
                nearest = next;
                nearestDist = nextDist;
            }
            
        }
        
        return nearest;
    }

    private double getEuclideanDistance(Solution ref, Solution nearest)
    {
        double dist = 0;
        for (int i = 0; i < ref.getNumberOfObjectives(); i++)
        {
            dist += (ref.getNormalizedObjective(i) - nearest.getNormalizedObjective(i)) * (ref.getNormalizedObjective(i) - nearest.getNormalizedObjective(i));
        }
        return dist;
    }

}
