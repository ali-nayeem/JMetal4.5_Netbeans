/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

/**
 *
 * @author MAN
 */
public abstract class Instance
{

    protected int numOfVertices;
    protected String dir;
    protected String demandFile;
    protected String timeFile;
    protected String RouteFile;
    protected String EdgeListFile;

    public int getNumOfVertices()
    {
        return numOfVertices;
    }

    public String getDir()
    {
        return dir;
    }

    public String getDemandFile()
    {
        return dir + demandFile;
    }

    public String getTimeFile()
    {
        return dir + timeFile;
    }

    public String getRouteFile()
    {
        return dir + RouteFile;
    }

    public String getEdgeListFile()
    {
        return dir + EdgeListFile;
    }
}
