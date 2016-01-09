/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.encodings.variable;

import java.util.ArrayList;

/**
 *
 * @author MAN
 */
public class Route
{

    public ArrayList<Integer> nodeList = new ArrayList<>();
    //int id;
    double frequency = 1;
    double revFreq;
    double roundTripTime;
    int MLS;
    double fleetSize;
    static double stationStandTime = 0;
    static int minFreq = 1;
    static int busCap = 50;
    static double diffThreshold = 0.01;
    boolean converged = false;
    
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

    boolean reviseFrequency(double MLSDemand, int MLS)
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

    void calculateFleetSize()
    {
        fleetSize = Math.ceil(frequency * roundTripTime / 60.0);
    }

//    void calculateRoundTripTime()
//    {
//        roundTripTime = 0;
//        for (int i = 1; i < nodeList.size(); i++)
//        {
//            roundTripTime += TripAsssignmentTest.time[nodeList.get(i)][nodeList.get(i - 1)];
//        }
//        roundTripTime += (nodeList.size() - 1) * stationStandTime;
//        roundTripTime = 2 * roundTripTime;
//    }

    int size()
    {
        return nodeList.size();
    }

    @Override
    public String toString()
    {
        return nodeList.toString();
    }

    Route deepCopy()
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
        return r;
    }

    
}
