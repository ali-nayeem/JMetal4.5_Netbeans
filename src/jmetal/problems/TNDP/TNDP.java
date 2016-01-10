/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import jmetal.core.Problem;
import jmetal.core.Solution;
import jmetal.util.JMException;
import grph.Grph;
import grph.in_memory.InMemoryGrph;
import grph.io.EdgeListReader;
import grph.properties.NumericalProperty;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
import jmetal.core.Variable;
import jmetal.encodings.solutionType.RouteSetSolutionType;
import jmetal.encodings.variable.Route;
import jmetal.encodings.variable.RouteSet;

/**
 *
 * @author MAN
 */
public class TNDP extends Problem
{

    private int numOfRoutes;
    private int[][] demand;
    private int[][] time;
    private double totalDemand;
    public Grph g;
    private NumericalProperty EdgeWeight;
    public Instance ins;

    public TNDP(int _numOfRoutes, Instance _ins) throws Exception
    {
        g = new InMemoryGrph();
        numOfRoutes = _numOfRoutes;
        ins = _ins;
        numberOfVariables_ = 1;
        numberOfObjectives_ = 7;
        numberOfConstraints_ = 2;
        problemName_ = ins.getName();
        demand = new int[ins.getNumOfVertices()][ins.getNumOfVertices()];
        time = new int[ins.getNumOfVertices()][ins.getNumOfVertices()];
        solutionType_ = new RouteSetSolutionType(this);
        readFromFile(ins.getTimeFile(), time);
        totalDemand = readFromFile(ins.getDemandFile(), demand);
        InputStream fml = new FileInputStream(ins.getEdgeListFile());
        EdgeWeight = new NumericalProperty(null, 8, 0);
        EdgeListReader.alterGraph(g, fml, false, false, null);
    }

    public class OBJECTIVES
    {

        public static final int IVTT = 0, WT = 1, TP = 2, UP = 3, FS = 4, RL = 5, DO = 6;
    }

    @Override
    public void evaluate(Solution solution) throws JMException
    {
        Variable[] var = solution.getDecisionVariables();
        RouteSet rs = (RouteSet) var[0];
        int Vertices = ins.getNumOfVertices();
        double[][] routeDemand = new double[rs.size()][];
        ArrayList[][] allPath = new ArrayList[Vertices][Vertices];
        HashMap[][] allPathClass = new HashMap[Vertices][Vertices];
        HashMap[][] allPathGroup = new HashMap[Vertices][Vertices];
        int[][] edgeUsage = new int[Vertices][Vertices];

        double totalRL = 0;
        for (int k = 0; k < rs.size(); k++)
        {
            routeDemand[k] = new double[rs.getRoute(k).size()];
            totalRL += rs.getRoute(k).calculateRouteLength_RoundTrip_edgeOverlap(time, edgeUsage);
        }
        solution.setObjective(OBJECTIVES.RL, totalRL);
        solution.setObjective(OBJECTIVES.DO, calculateObjectiveDO(edgeUsage, rs));
        for (int i = 0; i < Vertices; i++)
        {
            for (int j = i + 1; j < Vertices; j++)
            {

                ArrayList<Path> paths = generateAllPath(i, j, rs);
                HashMap<Integer, ArrayList<Path>> pathClass = new HashMap<>();
                HashMap<String, ArrayList<Path>> pathGroup = new HashMap<>();
                if (paths.isEmpty()) //unsatisfied
                {
                    paths = null;
                    pathClass = null;
                    pathGroup = null;
                    rs.d[2] += demand[i][j];
                } else
                {
                    screenPath(paths, rs);
                    classifyPaths(paths, pathClass, pathGroup);
                    rs.d[paths.get(0).getNumOfSegment() - 1] += demand[i][j]; //d0 => 1 segement, d1=> 2 segment
                }
                allPath[i][j] = paths;
                allPathClass[i][j] = pathClass;
                allPathGroup[i][j] = pathGroup;

            }
        }
        do
        {
            for (int k = 0; k < rs.size(); k++)
            {
                Arrays.fill(routeDemand[k], 0);
            }
            for (int i = 0; i < Vertices; i++)
            {
                for (int j = i + 1; j < Vertices; j++)
                {
                    if (allPath[i][j] != null)
                    {
                        splitDemand(allPath[i][j], allPathClass[i][j], allPathGroup[i][j], rs);
                        assignDemand(allPath[i][j], demand[i][j], rs, routeDemand);

                    }

                }
            }
        } while (!findMLS(rs, routeDemand));
        rs.d[0] = rs.d[0] / totalDemand; //direct
        rs.d[1] = rs.d[1] / totalDemand; // 1-transfer
        rs.d[2] = rs.d[2] / totalDemand; // unsatisfied
        solution.setObjective(OBJECTIVES.TP, rs.d[1]);
        solution.setObjective(OBJECTIVES.UP, rs.d[2]);
        double totalFS = 0;
        for (int k = 0; k < rs.size(); k++)
        {
            totalFS += rs.getRoute(k).calculateFleetSize();
        }
        solution.setObjective(OBJECTIVES.FS, totalFS);
        solution.setObjective(OBJECTIVES.IVTT, calculateObjectiveIVTT(allPath));
        solution.setObjective(OBJECTIVES.WT, calculateObjectiveWT(allPath, rs));
    }

    private ArrayList<Path> generateAllPath(int s, int d, RouteSet rs)
    {
        ArrayList<Path> paths = new ArrayList<>();
        ArrayList<Set<Integer>> routeNodeSet = new ArrayList<>();
        Set<Integer> routesHavingS = new HashSet<>();
        Set<Integer> routesHavingD = new HashSet<>();
        for (int i = 0; i < rs.size(); i++)
        {
            routeNodeSet.add(new HashSet<Integer>(rs.getRouteArrayList(i)));
            if (routeNodeSet.get(i).contains(s))
            {
                routesHavingS.add(i);
            }
            if (routeNodeSet.get(i).contains(d))
            {
                routesHavingD.add(i);
            }
        }

        Set<Integer> commonRoutes = intersect(routesHavingS, routesHavingD);
        if (commonRoutes.size() > 0)
        {
            for (int i : commonRoutes)
            {
                Path p = new Path(s, d);
                p.addSegment(i, s, d);
                paths.add(p);
                p.setName("Path from " + s + " to " + d + ": " + "(R" + i + "," + s + "," + d + ")");
            }
        } else
        {
            for (int ro : routesHavingS)
            {
                for (int rd : routesHavingD)
                {
                    Set<Integer> commonNodes = intersect(routeNodeSet.get(ro), routeNodeSet.get(rd));
                    if (commonNodes.size() > 0)
                    {
                        for (int i : commonNodes)
                        {
                            Path p = new Path(s, d);
                            p.addSegment(ro, s, i);
                            p.addSegment(rd, i, d);
                            paths.add(p);
                            p.setName("Path from " + s + " to " + d + ": " + "(R" + ro + "," + s + "," + i + ")" + "(R" + rd + "," + i + "," + d + ")");
                            break;
                        }
                    }
                }
            }
        }

        return paths;
    }

    private static void classifyPaths(ArrayList<Path> paths, HashMap<Integer, ArrayList<Path>> pathClass, HashMap<String, ArrayList<Path>> pathGroup)
    {

        boolean transfer = paths.get(0).needTransfer();
        for (Path p : paths)
        {
            if (pathClass.containsKey(p.getRouteOfSeg(0)))
            {
                ArrayList<Path> pList = pathClass.get(p.getRouteOfSeg(0));
                pList.add(p);
            } else
            {
                ArrayList<Path> pList = new ArrayList<>();
                pList.add(p);
                pathClass.put(p.getRouteOfSeg(0), pList);
            }
            if (transfer)
            {
                String groupKey = p.getRouteAndEndOfSeg(0);
                if (pathGroup.containsKey(groupKey))
                {
                    ArrayList<Path> pList = pathGroup.get(groupKey);
                    pList.add(p);
                } else
                {
                    ArrayList<Path> pList = new ArrayList<>();
                    pList.add(p);
                    pathGroup.put(groupKey, pList);
                }
            }
        }
    }

    private void screenPath(ArrayList<Path> paths, RouteSet rs)
    {
        double minTime = Double.MAX_VALUE;
        for (Path p : paths)
        {
            double totalTime = 0;

            for (Path.Segment seg : p.segList)
            {
                Route r = rs.getRoute(seg.routeId);
                int si = r.nodeList.indexOf(seg.startNode);
                int ei = r.nodeList.indexOf(seg.endNode);
                if (si > ei)
                {
                    int t = si;
                    si = ei;
                    ei = t;
                }
                for (si++; si <= ei; si++)
                {
                    totalTime += time[r.nodeList.get(si)][r.nodeList.get(si - 1)];
                }
            }
            p.setTotalInVehicleTime(totalTime);
            if (minTime > totalTime)
            {
                minTime = totalTime;
            }
        }
        for (int i = 0; i < paths.size(); i++)
        {
            Path p = paths.get(i);
            //double diff = (p.totalInVehicleTime - minTime) / minTime; 
            boolean reject = (p.totalInVehicleTime > minTime * (1 + Path.timeDiffThreshold));
            if (reject)
            {
                paths.remove(i);
            }
        }
    }

    private void splitDemand(ArrayList<Path> paths, HashMap<Integer, ArrayList<Path>> pathClass, HashMap<String, ArrayList<Path>> pathGroup, RouteSet rs)
    {
        boolean transfer = paths.get(0).needTransfer();;
        double sumFrequency = 0;
        for (int routeId : pathClass.keySet())
        {
            sumFrequency += rs.getRoute(routeId).frequency;
        }
        for (int routeId : pathClass.keySet())
        {
            double routeFreq = rs.getRoute(routeId).frequency;
            int totalPath = pathClass.get(routeId).size();
            for (Path p : pathClass.get(routeId))
            {
                p.demandPerc = 1.0 * routeFreq / (sumFrequency * totalPath);
            }
        }
        if (transfer)
        {
            for (Map.Entry<String, ArrayList<Path>> entry : pathGroup.entrySet())
            {
                ArrayList<Path> pList = entry.getValue();
                double sumFreq = 0;
                double sumDemand = 0;
                for (Path p : pList)
                {
                    sumDemand += p.demandPerc;
                    sumFreq += rs.getRoute(p.getRouteOfSeg(1)).frequency;
                }
                for (Path p : pList)
                {
                    double routeFreq = rs.getRoute(p.getRouteOfSeg(1)).frequency;
                    p.demandPerc = 1.0 * sumDemand * routeFreq / sumFreq;
                }
            }
        }

    }

    private static void assignDemand(ArrayList<Path> paths, int demand, RouteSet rs, double routeDemand[][])
    {
        for (Path p : paths)
        {
            double allocatedDem = demand * p.demandPerc;
            for (Path.Segment seg : p.segList)
            {
                Route r = rs.getRoute(seg.routeId);
                int si = r.nodeList.indexOf(seg.startNode);
                int ei = r.nodeList.indexOf(seg.endNode);
                if (si > ei)
                {
                    int t = si;
                    si = ei;
                    ei = t;
                }
                for (si++; si <= ei; si++)
                {
                    routeDemand[seg.routeId][si] += allocatedDem;
                }
            }
        }
    }

    private static boolean findMLS(RouteSet rs, double[][] routeDemand)
    {
        boolean converged = true;
        for (int i = 0; i < rs.size(); i++)
        {
            double MLSDemand = routeDemand[i][1];
            int MLS = 1;
            for (int j = 2; j < routeDemand[i].length; j++)
            {
                if (routeDemand[i][j] > MLSDemand)
                {
                    MLS = j;
                    MLSDemand = routeDemand[i][j];
                }

            }
            converged = converged && rs.getRoute(i).reviseFrequency(MLSDemand, MLS);

        }
        return converged;
    }

    public Set<Integer> intersect(Set<Integer> set1, Set<Integer> set2)
    {
        Set<Integer> a;
        Set<Integer> b;
        Set<Integer> res = new HashSet<Integer>();
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

    private double calculateObjectiveIVTT(ArrayList<Path>[][] allPath)
    {
        double total = 0;
        int vertices = ins.getNumOfVertices();
        for (int i = 0; i < vertices; i++)
        {
            for (int j = i + 1; j < vertices; j++)
            {
                if (allPath[i][j] != null)
                {
                    for (Path p : allPath[i][j])
                    {
                        total += p.demandPerc * demand[i][j] * p.totalInVehicleTime;
                    }

                }

            }
        }
        return total;
    }

    private double calculateObjectiveWT(ArrayList[][] allPath, RouteSet rs)
    {
        double totalWT = 0;
        int vertices = ins.getNumOfVertices();
        for (int i = 0; i < vertices; i++)
        {
            for (int j = i + 1; j < vertices; j++)
            {
                if (allPath[i][j] != null)
                {
                    for (Path p : (ArrayList<Path>) allPath[i][j]) //for each path
                    {
                        double pathWT = 0;
                        for (int k = 0; k < p.segList.size(); k++)
                        {
                            Route r = rs.getRoute(p.getRouteOfSeg(k));
                            pathWT += r.calculateWaitingTime();
                        }
                        totalWT += p.demandPerc * demand[i][j] * pathWT;
                    }

                }

            }
        }
        return totalWT;
    }

    private double calculateObjectiveDO(int[][] edgeUsage, RouteSet rs)
    {
        double totalDO = 0;
        for (Route r : rs.routeSet)
        {
            double routeDO = 0;
            for (int i = 1; i < r.nodeList.size(); i++)
            {
                int v0 = r.nodeList.get(i), v1 = r.nodeList.get(i - 1);
                if (edgeUsage[v0][v1] > 1)
                {
                    routeDO += time[v0][v1];
                }
            }
            totalDO += routeDO / r.getLength();
        }

        return totalDO;
    }

    @Override
    public void evaluateConstraints(Solution solution) throws JMException
    {
        RouteSet rs = (RouteSet) (solution.getDecisionVariables())[0];
        rs.lengthCheck((TNDP) solution.getProblem());
        rs.ConnectednessCheck((TNDP) solution.getProblem());
        if (rs.getOverallConstraintViolation() != 0)
        {
            solution.setOverallConstraintViolation(rs.getOverallConstraintViolation());
        }
    }

    public int getNumberOfRoutes()
    {
        return numOfRoutes;
    }

    public int getDemand(int i, int j)
    {
        return demand[i][j];
    }

    public int getTime(int i, int j)
    {
        return time[i][j];
    }

    private double readFromFile(String fileName, int[][] data) throws Exception
    {

        double sum = 0;
        Scanner sc = new Scanner(new FileInputStream(fileName));

        for (int i = 0; i < data.length; i++)
        {
            for (int j = 0; j < data.length; j++)
            {
                String s = sc.next();
                if (s.equals("-"))
                {
                    data[i][j] = Integer.MAX_VALUE;
                } else
                {
                    data[i][j] = Integer.parseInt(s);
                    sum += data[i][j];
                }
            }
        }

        sc.close();
        return sum / 2;
    }

}
