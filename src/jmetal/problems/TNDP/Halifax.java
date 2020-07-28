/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

/**
 *
 * @author mahib
 */
public class Halifax  extends Instance{
    Halifax(){
        numOfVertices = 383;
        dir = "IO/Halifax/";
        demandFile = "HalifaxZoneDemand.txt";
        timeFile = "HalifaxTime.txt";
        RouteFile = "MandlPRoute.txt";
        EdgeListFile = "HalifaxEdgelist.txt";
        minNode = 10;
        maxNode = 40;
        name = "Halifax";
    }
}
