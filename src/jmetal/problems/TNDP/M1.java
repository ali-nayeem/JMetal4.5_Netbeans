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
public class M1 extends Instance
{
    M1()
    {
        numOfVertices = 70;
        dir = "IO/M1/";
        demandFile = "M1Demand.txt";
        timeFile = "M1Time.txt";
        RouteFile = "M1Route.txt";
        EdgeListFile = "M1Edgelist.txt";
        minNode = 10;
        maxNode = 30;
        name = "M1";
    }
}
