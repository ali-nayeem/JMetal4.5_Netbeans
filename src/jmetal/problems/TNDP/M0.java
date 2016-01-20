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
public class M0 extends Instance
{

    M0()
    {
        numOfVertices = 30;
        dir = "IO/M0/";
        demandFile = "M0Demand.txt";
        timeFile = "M0Time.txt";
        RouteFile = "M0Route.txt";
        EdgeListFile = "M0Edgelist.txt";
        minNode = 2;
        maxNode = 15;
        name = "M0";
    }

}
