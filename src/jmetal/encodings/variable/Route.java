/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.encodings.variable;

import java.util.ArrayList;
import java.util.Collections;

/**
 *
 * @author MAN
 */
public class Route implements Comparable
{

    public ArrayList<Integer> nodeList = new ArrayList<>();
    //int id;
    public double frequency = 1;
    double revFreq = -1;
    double roundTripTime;
    int MLS;
    private double fleetSize;
    static double stationStandTime = 0;
    static int minFreq = 1;
    static int busCap = 50;
    static double diffThreshold = 0.01;
    boolean converged = false;
    private double waitingTime;
    private double length = -1;

    int revCount = 0;
    boolean addAtEnd = true;

    void reverseEnd()
    {
        addAtEnd = !addAtEnd;
        revCount++;
    }

    void addNode(int n)
    {
        if (addAtEnd)
        {
            nodeList.add(n);
        } else
        {
            nodeList.add(0, n);
        }

    }

    public boolean reviseFrequency(double MLSDemand, int MLS)
    {
        this.MLS = MLS;
        revFreq = Math.max(minFreq, MLSDemand / busCap);
        double diff = Math.abs((revFreq - frequency) / frequency);
        converged = !(diff > diffThreshold);
        frequency = revFreq;
        return converged;
    }

    static Route createRouteFromString(String route)
    {
        Route r = new Route();
        String[] nodes = route.split(" ");
        for (int i = 0; i < nodes.length - 1; i++)
        {
            r.nodeList.add(Integer.parseInt(nodes[i]));
        }
        return r;
    }
    static Route createRouteFromCommaSeparatedString(String route)
    {
        Route r = new Route();
        String[] nodes = route.split(",");
        for (int i = 0; i < nodes.length ; i++)
        {
            r.nodeList.add(Integer.parseInt(nodes[i].trim()));
        }
        return r;
    }

    public double calculateFleetSize()
    {
        if (revFreq == -1)
        {
            throw new Error("Attempt to calculate FleetSize before frequency calculaution");
        }
        fleetSize = Math.ceil(frequency * roundTripTime / 60.0);
        return fleetSize;
    }

    public double calculateRouteLength_RoundTrip_edgeOverlap(int[][] time, int[][] edgeUsage)
    {
        roundTripTime = 0;
        for (int i = 1; i < nodeList.size(); i++)
        {
            roundTripTime += time[nodeList.get(i)][nodeList.get(i - 1)];
            edgeUsage[nodeList.get(i)][nodeList.get(i - 1)] = ++edgeUsage[nodeList.get(i - 1)][nodeList.get(i)];
        }
        length = roundTripTime;
        roundTripTime += (nodeList.size() - 1) * stationStandTime;
        roundTripTime = 2 * roundTripTime;
        return length;
    }

    public double getLength()
    {
        if (length == -1)
        {
            throw new Error("Attempt to get route length before calculaution");
        }
        return length;

    }

    public double calculateWaitingTime()
    {
        if (revFreq == -1)
        {
            throw new Error("Attempt to calculate waiting time before frequency calculaution");
        }
        waitingTime = 60.0 / (2.0 * frequency);
        return waitingTime;
    }

    public int size()
    {
        return nodeList.size();
    }

    @Override
    public String toString()
    {
        int s = nodeList.get(0);
        int e = nodeList.get(nodeList.size() - 1);
        if (e < s)
        {
            ArrayList<Integer> copy = new ArrayList<>(nodeList);
            Collections.reverse(copy);
            return copy.toString();
        } else
        {
            return nodeList.toString();
        }
    }

    public Route deepCopy()
    {
        Route r = new Route();
        //r.nodeList =  (ArrayList<Integer>) nodeList.clone();
        for (Integer i : nodeList)
        {
            r.nodeList.add(i);
        }
        //r.id = id;
        r.revFreq = revFreq;
        r.roundTripTime = roundTripTime;
        r.MLS = MLS;
        r.fleetSize = fleetSize;
        r.waitingTime = waitingTime;
        r.frequency = frequency;
        r.converged = converged;
        r.length = length;
        r.revCount = revCount;
        r.addAtEnd = addAtEnd;
        return r;
    }

    @Override
    public int compareTo(Object o)
    {
        Route or = (Route) o;
        return or.nodeList.size() - nodeList.size();
    }

}
