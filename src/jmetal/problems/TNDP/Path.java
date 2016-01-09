/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import java.util.ArrayList;

/**
 *
 * @author MAN
 */
public class Path
{

    public ArrayList<Segment> segList = new ArrayList<>();
    int source, destination;
    double totalInVehicleTime = 0;
    static double timeDiffThreshold = 0.1;

    public int getNumOfSegment()
    {
        if(segList.isEmpty())
        {
            throw new Error("Asking number of segments of an empty path");
        }
        return segList.size();
    }
    public boolean needTransfer()
    {
        return ( getNumOfSegment() > 1 );
    }
    public void setTotalInVehicleTime(double totalInVehicleTime)
    {
        this.totalInVehicleTime = totalInVehicleTime;
    }

    public Path(int source, int destination)
    {
        this.source = source;
        this.destination = destination;
    }

    void addSegment(int r, int s, int e)
    {
        segList.add(new Segment(r, s, e));
    }

    int getRouteOfSeg(int i)
    {
        return segList.get(i).routeId;
    }

    String getRouteAndEndOfSeg(int i)
    {
        return "" + segList.get(i).routeId + segList.get(i).endNode;
    }

    void setName(String s)
    {
        name = s;
        //System.out.println(s);
    }

    public class Segment
    {

        int routeId;
        int startNode;
        int endNode;

        public Segment(int routeId, int startNode, int endNode)
        {
            this.routeId = routeId;
            this.startNode = startNode;
            this.endNode = endNode;
        }

    }
    double demandPerc;
    private String name = "";

    @Override
    public String toString()
    {
        return name;
    }
}
