/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.operators.crossover;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import jmetal.core.Solution;
import jmetal.core.Variable;
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
public class RouteSetCrossover extends Crossover
{

    private static final List VALID_TYPES = Arrays.asList(RouteSetSolutionType.class);
    private int numOfOffspring = 1;
    private double crossoverProbability_ = 1.0;

    public RouteSetCrossover(HashMap<String, Object> parameters)
    {
        super(parameters);
        if (parameters != null)
        {
            if (parameters.get("probability") != null)
            {
                crossoverProbability_ = (Double) parameters.get("probability");
            }
        }
    }

    @Override
    public Object execute(Object object) throws JMException
    {
        Solution[] parents = (Solution[]) object;
        if (parents.length != 2)
        {
            Configuration.logger_.severe("RouteSetCrossover.execute: operator needs two "
                    + "parents");
            Class cls = java.lang.String.class;
            String name = cls.getName();
            throw new JMException("Exception in " + name + ".execute()");
        }
        if (!(VALID_TYPES.contains(parents[0].getType().getClass())
                && VALID_TYPES.contains(parents[1].getType().getClass())))
        {
            Configuration.logger_.severe("RouteSetCrossover.execute: the solutions "
                    + "type " + parents[0].getType() + " is not allowed with this operator");

            Class cls = java.lang.String.class;
            String name = cls.getName();
            throw new JMException("Exception in " + name + ".execute()");
        } // if 

        if (crossoverProbability_ >= PseudoRandom.randDouble())
        {
            Solution[] offSpring;
            offSpring = doCrossover(parents[0], parents[1]);
            return offSpring;
        } 
        else
        {
            Solution[] offSpring = new Solution[numOfOffspring];
            offSpring[0] = new Solution(parents[0]);
            //offSpring[1] = new Solution(parents[1]);
            return offSpring;
        }

    }

    private Solution[] doCrossover(Solution parent1, Solution parent2)
    {

        RouteSet[] rsParents = new RouteSet[2];
        rsParents[0] = (RouteSet) (parent1.getDecisionVariables())[0];
        rsParents[1] = (RouteSet) (parent2.getDecisionVariables())[0];
        RouteSet[] rsOffspring = doRouteSetCrossover(rsParents, (TNDP) parent1.getProblem());

        Solution[] offSpring = new Solution[numOfOffspring];

        Variable[] vars1 = new Variable[1];
        vars1[0] = rsOffspring[0];
        offSpring[0] = new Solution(parent1.getProblem(), vars1);

//        Variable[] vars2 = new Variable[1];
//        vars2[0] = rsOffspring[1];
//        offSpring[1] = new Solution(parent2.getProblem(), vars2);
        return offSpring;
    }

    private RouteSet[] doRouteSetCrossover(RouteSet[] parent, TNDP prob)
    {
        RouteSet[] children = new RouteSet[numOfOffspring];
        RouteSet[] parentCopy = new RouteSet[2];
        parentCopy[0] = (RouteSet) parent[0].deepCopy();
        parentCopy[1] = (RouteSet) parent[1].deepCopy();
        int routeSetSize = prob.getNumberOfRoutes();
        //Route removedRoute = null;
        int Vertices = prob.ins.getNumOfVertices();

        for (int count = 0; count < numOfOffspring; count++) //for getting 2 children
        {
            boolean feasible = false;
            int attempt = 0;
            // do //untill a feasible child is found
            // {
            if (count == 0 && attempt > 0)
            {
                parentCopy[0] = (RouteSet) parent[0].deepCopy();
            }
            children[count] = new RouteSet();
            Set<Integer> chosen = new HashSet<>();
            int curParent = count;
            int randomindex = PseudoRandom.nextInt(parentCopy[curParent].size());
            Route r = parentCopy[curParent].getRoute(randomindex);
            if (count == 0)
            {
                //removedRoute = r;
                parentCopy[0].routeSet.remove(randomindex);
            }

            children[count].routeSet.add(r.deepCopy());
            chosen.addAll(r.nodeList);

            while (children[count].size() < routeSetSize)
            {
                curParent = (curParent + 1) % 2; //pick routes from 2 parentCopy alternatively
                ArrayList<Route> eligileRoutes = new ArrayList<>();
                ArrayList<Double> props = new ArrayList<>();

                for (int i = 0; i < parentCopy[curParent].size(); i++)
                {
                    Route cr = parentCopy[curParent].getRoute(i);
                    Set<Integer> commonNodes = intersect(chosen, new HashSet<>(cr.nodeList));
                    if (!commonNodes.isEmpty())
                    {
                        eligileRoutes.add(cr);
                        props.add(1.0 * (cr.size() - commonNodes.size()) / cr.size());
                    }
                }
                if (eligileRoutes.isEmpty())
                {
                    continue;
                    //throw new Error("Eligible list empty");
                }
                double maxProp = Collections.max(props);
                ArrayList<Integer> maxIndices = new ArrayList<>();

                for (int i = 0; i < eligileRoutes.size(); i++)
                {
                    if (props.get(i) == maxProp)
                    {
                        // maxProp = props.get(i);
                        // maxPropIndex = i;
                        maxIndices.add(i);
                    }
                }
                int maxPropIndex = maxIndices.get(PseudoRandom.nextInt(maxIndices.size()));
                Route sr = eligileRoutes.get(maxPropIndex);
                //parents[curParent].routeSet.remove(sr);
                children[count].routeSet.add(sr.deepCopy());
                chosen.addAll(sr.nodeList);
            }
            if (chosen.size() < Vertices)
            {
                feasible = children[count].repair(chosen, prob);
            } else
            {
                feasible = true;
            }
            attempt++;
            //System.out.print(attempt + ",");
            // } while (!feasible);
        }

        return children;
    }

    private Set<Integer> intersect(Set<Integer> set1, Set<Integer> set2)
    {
        Set<Integer> a;
        Set<Integer> b;
        Set<Integer> res = new HashSet<>();
        if (set1.size() <= set2.size())
        {
            a = set1;
            b = set2;
        } else
        {
            a = set2;
            b = set1;
        }
        for (Integer e : a)
        {
            if (b.contains(e))
            {
                res.add(e);
            }
        }
        return res;
    }

}
