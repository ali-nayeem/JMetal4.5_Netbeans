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
public class M3 extends Instance
{
    M3()
    {
        numOfVertices = 127;
        dir = "IO/M3/";
        demandFile = "M3Demand.txt";
        timeFile = "M3Time.txt";
        RouteFile = "M3Route.txt";
        EdgeListFile = "M3Edgelist.txt";
        minNode = 12;
        maxNode = 25;
        name = "M3";
    }
}
