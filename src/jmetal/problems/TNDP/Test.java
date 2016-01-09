/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import jmetal.core.Solution;
import jmetal.core.Variable;
import jmetal.encodings.variable.RouteSet;

/**
 *
 * @author MAN
 */
public class Test
{

    public static void main(String[] args) throws Exception
    {
        TNDP small = new TNDP(4, new Mandl());
        for (int i = 0; i < 1; i++)
        {
            Solution newSolution = new Solution(small);
            Variable[] var  = newSolution.getDecisionVariables();
            RouteSet rs = (RouteSet)var[0];
            System.out.println(rs);
            rs.lengthCheck(small);
            rs.ConnectednessCheck(small);
            small.evaluate(newSolution);
        }
    }
}
