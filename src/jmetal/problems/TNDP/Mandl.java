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
public class Mandl extends Instance
{

    Mandl()
    {
        numOfVertices = 15;
        dir = "IO/Mandl/";
        demandFile = "MandlDemand.txt";
        timeFile = "MandlTime.txt";
        RouteFile = "MandlPRoute.txt";
        EdgeListFile = "MandlEdgelist.txt";
        minNode = 2;
        maxNode = 10;
    }
    
}
