/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.encodings.variable;

import grph.Grph;
import grph.path.ArrayListPath;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import jmetal.core.Variable;
import jmetal.problems.TNDP.TNDP;
import jmetal.util.PseudoRandom;
import toools.set.IntHashSet;
import toools.set.IntSet;

/**
 *
 * @author MAN
 */
public class RouteSet extends Variable
{

    public ArrayList<Route> routeSet = new ArrayList<>();
    public double d[] =
    {
        0, 0, 0
    };// d0,d1,dun => direct , 1-transfer , unsatisfied 
    static double epsilon = 0.1;
    private int overallConstraintViolation = 0;
   // double totalIVTT;

    public static RouteSet readFromFile(String fileName) throws Exception
    {
        RouteSet rs = new RouteSet();
        FileReader fr = new FileReader(fileName);
        BufferedReader br = new BufferedReader(fr);
        while (true)
        {
            String line = br.readLine();
            if (line == null)
            {
                break;
            }
            rs.routeSet.add(new Route().createRouteFromString(line));
        }
        br.close();
        fr.close();
        return rs;
    }

    public int size()
    {
        return routeSet.size();
    }

    public ArrayList<Integer> getRouteArrayList(int i)
    {
        return routeSet.get(i).nodeList;
    }

    public Route getRoute(int i)
    {
        return routeSet.get(i);
    }

    @Override
    public String toString()
    {
        String s = "";
        for (int i = 0; i < size(); i++)
        {
            s += getRoute(i).toString();
        }
        return s;
    }

    public void generateRouteSet(TNDP prob)
    {
        int numOfRoutes = prob.getNumberOfRoutes();
        int numOfVertices = prob.ins.getNumOfVertices();
        int maxNode = prob.ins.getMaxNode();
        int minNode = prob.ins.getMinNode();
        boolean feasible;
        do
        {
            routeSet.clear();
            overallConstraintViolation = 0;
            Set<Integer> chosen = new HashSet<>();
            double chosenCount[] = new double[numOfVertices];
            Arrays.fill(chosenCount, epsilon);
            for (int count = 0; count < numOfRoutes; count++)
            {
                int routeLength = PseudoRandom.nextInt(maxNode - minNode + 1) + minNode;
                int firstNode;
                if (count == 0)
                {
                    firstNode = PseudoRandom.nextInt(numOfVertices);

                } else
                {
                    Object chosenNodes[] = chosen.toArray();
                    firstNode = (int) chosenNodes[PseudoRandom.nextInt(chosenNodes.length)];
                }
                Route r;
                Set<Integer> chosenLocal;
                double chosenCountLocal[];
                do
                {
                    chosenLocal = (Set<Integer>) ((HashSet<Integer>) chosen).clone();
                    chosenCountLocal = chosenCount.clone();
                    r = new Route();
                    r.addNode(firstNode);
                    chosenLocal.add(firstNode);
                    chosenCountLocal[firstNode]++;

                    int curNode = firstNode;
                    while (r.size() < routeLength && r.revCount < 2)
                    {
                        ArrayList<Integer> unused = prob.g.getNeighbours(curNode).toIntegerArrayList();
                        unused.removeAll(r.nodeList);
                        if (!unused.isEmpty())
                        {
                            double fit[] = new double[unused.size()];
                            double total = 0;
                            for (int k = 0; k < unused.size(); k++)
                            {
                                fit[k] = 1.0 / chosenCountLocal[unused.get(k)];
                                total += fit[k];
                            }
                            curNode = unused.get(PseudoRandom.roulette_wheel(fit, total));
                            r.addNode(curNode);
                            chosenLocal.add(curNode);
                            chosenCountLocal[curNode]++;
                        } else
                        {
                            r.reverseEnd();
                            curNode = r.nodeList.get(0);
                        }
                    }
                } while (r.size() != routeLength);
                routeSet.add(r);
                chosen = chosenLocal;
                chosenCount = chosenCountLocal;
            }
            if (chosen.size() < numOfVertices)
            {
                feasible = repair(chosen, prob);
            } else
            {
                feasible = true;
            }

        } while (!feasible);

    }

    public boolean repair(Set<Integer> chosen, TNDP prob)
    {
        int numOfVertices = prob.ins.getNumOfVertices();
        int maxNode = prob.ins.getMaxNode();
        ArrayList<Integer> absent = new ArrayList<>();
        for (int i = 0; i < numOfVertices; i++)
        {
            if (!chosen.contains(i))
            {
                absent.add(i);
            }
        }
        int[] rIndex = new int[size()];
        for (int i = 0; i < routeSet.size(); i++)
        {
            rIndex[i]=i;
        }
        //Collections.shuffle(rIndex, TripAsssignmentTest.rnd);
        PseudoRandom.shuffleArray(rIndex);
        for (int i = 0; i < rIndex.length; i++)
        {
            Route r = routeSet.get(rIndex[i]);
            if (r.size() == maxNode)
            {
                continue;
            }
            // int end = r.nodeList.get(r.nodeList.size());
            //ArrayList<Integer> eAdjList = TripAsssignmentTest.g.getNeighbours(end).toIntegerArrayList();

            for (int j = 0; j < 2; j++)
            {
                while (r.size() < maxNode)
                {
                    int terminalNode = r.nodeList.get(j * (r.size() - 1));
                    ArrayList<Integer> tAdjList = prob.g.getNeighbours(terminalNode).toIntegerArrayList();
                    tAdjList.retainAll(absent);
                    if (tAdjList.isEmpty())
                    {
                        break;
                    }
                    if (j == 0)
                    {
                        r.nodeList.add(0, tAdjList.get(0));
                    } else
                    {
                        r.nodeList.add(tAdjList.get(0));
                    }

                    absent.remove(tAdjList.get(0));
                    if (absent.isEmpty())
                    {
                        return true;
                    }
                }
            }
        }
        overallConstraintViolation = -1*absent.size();
        return false;
    }


    public void lengthCheck(TNDP prob)
    {
        for (Route r : routeSet)
        {
            if (r.size() < prob.ins.getMinNode() || r.size() > prob.ins.getMaxNode())
            {
                throw new Error("Route break length constraint");
            }
        }
    }
  

    public void  ConnectednessCheck(TNDP prob)
    {
        Grph g = prob.g;
        IntSet edges = new IntHashSet();
        for (int i = 0; i < routeSet.size(); i++)
        {
            Route r = getRoute(i);
            for (int j = 1; j < r.size(); j++)
            {
                try
                {
                    edges.add(g.getEdgesConnecting(r.nodeList.get(j), r.nodeList.get(j - 1)).getGreatest());
                } catch (Exception e)
                {
                    System.out.println("Edge not found");
                }
            }
        }
        if (edges.size() == g.getEdges().size())
        {
            return;
        }
        Grph sg = g.getSubgraphInducedByEdges(edges);
        if (!sg.isConnected())
        {
            throw new Error("Transit network is not connectd");
        }
        
    }
    @Override
    public Variable deepCopy()
    {
        RouteSet nRs = new RouteSet();
        for (int i = 0; i < size(); i++)
        {
            Route r = routeSet.get(i).deepCopy();
            nRs.routeSet.add(r);
        }

        nRs.d = Arrays.copyOf(d, d.length);
      //  nRs.overallConstraintViolation = overallConstraintViolation;
       
        return nRs;
    }

    

    public int getOverallConstraintViolation()
    {
        return overallConstraintViolation;
    }

}
