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
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import jmetal.core.Variable;
import jmetal.problems.TNDP.TNDP;
import jmetal.util.PseudoRandom;
import toools.set.IntHashSet;
import toools.set.IntSet;
import com.google.common.collect.Sets;
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
    HashMap<Integer, ArrayList<Integer>> zoneNeedAttention = new HashMap<Integer, ArrayList<Integer>>();
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
            rs.routeSet.add( Route.createRouteFromString(line));
        }
        br.close();
        fr.close();
        return rs;
    }
    public static RouteSet readFromString(String srs) throws Exception
    {
        RouteSet rs = new RouteSet();
        char[] trs = srs.trim().toCharArray();
        trs[0] = trs[trs.length - 1] = ' ';
        srs = new String(trs);
        String[] r = srs.trim().split("\\]\\[");
        for (int i = 0; i < r.length; i++)
        {
            rs.routeSet.add( Route.createRouteFromCommaSeparatedString(r[i]));
        }
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
        ArrayList<Route> copy = new ArrayList<>(routeSet);
        Collections.sort(copy);
        String s = "";
        for (int i = 0; i < size(); i++)
        {
            s += copy.get(i).toString();
        }
        return s;
    }

    public void generateRouteSet(TNDP prob)
    {
        int numOfRoutes = prob.getNumberOfRoutes();
        int numOfVertices = prob.ins.getNumOfVertices();
        int maxNode = prob.ins.getMaxNode();
        int minNode = prob.ins.getMinNode();
        Set <Integer> zones = prob.getAllZones();
        ArrayList<Integer> uncovered = new ArrayList<Integer>();
        for (int i = 0; i < prob.shelters.length; i++) {
            zoneNeedAttention.put(prob.shelters[i], new ArrayList<Integer>());
            for (Integer z: zones) {
                zoneNeedAttention.get(prob.shelters[i]).add(z);
            }
        }
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
                int shelter = prob.shelters[PseudoRandom.nextInt(prob.shelters.length)];
                uncovered.clear();
                for (Integer  z: zoneNeedAttention.get(shelter)) {
                    uncovered.addAll(prob.getAllStops(z));
                }
                if (uncovered.isEmpty()) {
                    while(prob.isShelter(firstNode = PseudoRandom.nextInt(numOfVertices)));
                }
                else {
                    firstNode = uncovered.get(PseudoRandom.nextInt(uncovered.size()));
                }
                
                
                // if (count == 0)
                // {
                //     firstNode = PseudoRandom.nextInt(numOfVertices);

                // } else
                // {
                //     Object chosenNodes[] = chosen.toArray();
                //     firstNode = (int) chosenNodes[PseudoRandom.nextInt(chosenNodes.length)];
                // }
                Route r;
                Set<Integer> chosenLocal;
                double chosenCountLocal[];
                do
                {
                    boolean reverse_done = false;
                    // determine shelter and primary route
                    int [] primary_route = prob.determineRoute(firstNode, shelter);
                    shelter = primary_route[primary_route.length - 1];
                    if (!prob.isShelter(primary_route[primary_route.length - 1]))
                    {
                        throw new Error("No shelter in the path");
                    }
                    if (!prob.isImmediateNode(primary_route[primary_route.length - 2]))
                    {
                        throw new Error("No immediate node in the path");
                    }
                    chosenLocal = (Set<Integer>) ((HashSet<Integer>) chosen).clone();
                    chosenCountLocal = chosenCount.clone();
                    r = new Route();
                    r.addShelter(primary_route[primary_route.length - 1]);
                    for (int i = 0; i < primary_route.length; i++) {
                        r.nodeList.add(primary_route[i]);
                        chosenLocal.add(primary_route[i]);
                        chosenCountLocal[primary_route[i]]++;
                        if (!prob.isShelter(primary_route[i])) {
                            zoneNeedAttention.get(shelter).remove(new Integer(prob.getZone(primary_route[i])));
                        }
                    }

                    int curNode = firstNode;
                    while (r.size() < routeLength && r.revCount < 1)
                    {
                        ArrayList<Integer> unused = prob.g.getNeighbours(curNode).toIntegerArrayList();
                        unused.removeAll(r.nodeList);
                        if (!unused.isEmpty())
                        {
                            // double fit[] = new double[unused.size()];
                            // double total = 0;
                            // for (int k = 0; k < unused.size(); k++)
                            // {
                            //     fit[k] = 1.0 / chosenCountLocal[unused.get(k)];
                            //     total += fit[k];
                            // }
                            double total = 0;

                            double fit[] = prob.setFitness(unused, chosenLocal);
                            for (int k = 0; k < unused.size(); k++)
                            {
                                total += fit[k];
                            }
                            if (total == 0) {
                                curNode = unused.get(PseudoRandom.nextInt(fit.length));
                            }
                            else {
                                curNode = unused.get(PseudoRandom.roulette_wheel(fit, total));    
                            }
//                            if (prob.isShelter(curNode)) {
//                                r.addShelter(curNode);                                    
//                            }
                            r.nodeList.add(0, curNode);
                            chosenLocal.add(curNode);
                            chosenCountLocal[curNode]++;
                            if (!prob.isShelter(curNode)) {
                                zoneNeedAttention.get(shelter)
                                    .remove(new Integer(prob.getZone(curNode)));
                            }
                        } else
                        {
                            // System.out.printf("unused is empty, current route length %d\n", r.size());
                            if (reverse_done && r.size() > minNode) {
                                // System.out.printf("route has crossed min node, breaking loop, current route length %d, expected length %d \n", r.size(), routeLength);
                                break;
                            }
                            r.reverseEnd();
                            reverse_done = true;
                            curNode = r.nodeList.get(0);
                        }
                    }
                    if (reverse_done && r.size() > minNode) {
                        // System.out.printf("route has crossed min node, breaking loop, current route length %d, expected length %d \n", r.size(), routeLength);
                        break;
                    }
                } while (r.size() <= routeLength / 2 || r.size() < minNode);
                routeSet.add(r);
                chosen = chosenLocal;
                chosenCount = chosenCountLocal;
                // System.out.println(routeSet);
                prob.route_destination_check(routeSet, "Before Repair call");
                // System.out.printf("Created %d route\n", count);
            }
            
//            if (!prob.isAllZoneCovered(chosen, zoneNeedAttention, routeSet))
//            {
//                feasible = repair(chosen, prob);
//            } else
//            {
                feasible = true;
            // }

        } while (!feasible);
        // System.out.println("Luckily, generating routeset is finished ... ");
        prob.route_destination_check(routeSet, "Generate Route Set");
    }

    public boolean repair(Set<Integer> chosen, TNDP prob)
    {
        Set<Integer> set1, set2, set3;
        int numOfVertices = prob.ins.getNumOfVertices();
        int maxNode = prob.ins.getMaxNode();
        ArrayList<Integer> absent = new ArrayList<>();
        absent = prob.uncoveredNodes(chosen);
        int[] rIndex = new int[size()];
        for (int i = 0; i < routeSet.size(); i++)
        {
            rIndex[i]=i;
        }
        //Collections.shuffle(rIndex, TripAsssignmentTest.rnd);
        PseudoRandom.shuffleArray(rIndex);
        int tobeAdded;
        for (int i = 0; i < rIndex.length; i++)
        {
            Route r = routeSet.get(rIndex[i]);
            if (r.size() == maxNode)
            {
                continue;
            }
            // int end = r.nodeList.get(r.nodeList.size());
            //ArrayList<Integer> eAdjList = TripAsssignmentTest.g.getNeighbours(end).toIntegerArrayList();

            // for (int j = 0; j < 2; j++)
            // {
                while (r.size() < maxNode)
                {
                    int terminalNode = r.nodeList.get(0 * (r.size() - 1));
                    ArrayList<Integer> tAdjList = prob.g.getNeighbours(terminalNode).toIntegerArrayList();
                    tAdjList.retainAll(absent);
                    set1 = new HashSet<Integer>(tAdjList);
                    set2 = new HashSet<Integer>(chosen);
                    if (!Collections.disjoint(set1, set2))
                    {
                        tAdjList.retainAll(absent);
                    }
                    else {
                        set3 = new HashSet<Integer>();
                        for (Integer s: r.shelterList) {
                            for (Integer z: zoneNeedAttention.get(s)) {
                                set1 = new HashSet<Integer>(tAdjList);
                                set2 = new HashSet<Integer>(prob.getAllStops(z));
                                if (!Collections.disjoint(set1, set2))
                                {
                                    set3 = Sets.union(set3, set2);
                                }
                                if (set3.size() > 0)
                                {
                                    break;
                                }
                            }
                            if (set3.size() > 0)
                            {
                                break;
                            }
                        }
                        tAdjList.retainAll(new ArrayList<Integer>(set3));
                    }
                    if (tAdjList.isEmpty())
                    {
                        break;
                    }
                    // if (j == 0)                        
                    // {
                        double total = 0;
                        double fit[] = prob.setFitness(tAdjList, chosen);
                        for (int k = 0; k < tAdjList.size(); k++)
                        {
                            total += fit[k];
                        }
                        tobeAdded = tAdjList.get(PseudoRandom.roulette_wheel(fit, total));
                        r.nodeList.add(0, tobeAdded);
                        for (Integer s: r.shelterList) {
                            zoneNeedAttention.get(s).remove(new Integer(prob.getZone(tobeAdded)));
                        }
                    // } else
                    // {
                    //     r.nodeList.add(tAdjList.get(0));
                    // }

                    absent.remove(new Integer(tobeAdded));
                    if (prob.isAllZoneCovered(chosen, zoneNeedAttention, routeSet))
                    {
                        return true;
                    }
                }
            // }
        }
        overallConstraintViolation = -1*absent.size();
        return false;
    }


    public void lengthCheck(TNDP prob)
    {
        for (Route r : routeSet)
        {
            if (r.size() < prob.ins.getMinNode() /*|| r.size() > prob.ins.getMaxNode()*/)
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
