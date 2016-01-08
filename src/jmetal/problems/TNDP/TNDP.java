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
import java.util.Scanner;
import jmetal.encodings.solutionType.RouteSetSolutionType;

/**
 *
 * @author MAN
 */
public class TNDP extends Problem
{

    private int numOfRoutes;
    private int[][] demand ;
    private int[][] time ;
    private double totalDemand;
    private Grph g;
    private NumericalProperty EdgeWeight;
    private Instance ins;

    public TNDP(int _numOfRoutes, Instance _ins) throws Exception
    {
        g = new InMemoryGrph();
        numOfRoutes = _numOfRoutes;
        ins = _ins;
        numberOfVariables_ = 1;
        numberOfObjectives_ = 7;
        numberOfConstraints_ = 0;
        problemName_ = "Small";
        demand = new int[ins.getNumOfVertices()][ins.getNumOfVertices()];
        time = new int[ins.getNumOfVertices()][ins.getNumOfVertices()];
        solutionType_ = new RouteSetSolutionType(this);
        readFromFile(ins.getTimeFile(), time);
        totalDemand = readFromFile(ins.getDemandFile(), demand);
        InputStream fml = new FileInputStream(ins.getEdgeListFile());
        EdgeWeight = new NumericalProperty(null, 8, 0);
        EdgeListReader.alterGraph(g, fml, false, false, null);
    }

    @Override
    public void evaluate(Solution solution) throws JMException
    {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
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
