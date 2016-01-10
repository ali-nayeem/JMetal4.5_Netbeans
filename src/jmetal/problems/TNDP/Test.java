/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import jmetal.core.Solution;
import jmetal.core.Variable;
import jmetal.encodings.variable.RouteSet;
import jmetal.operators.crossover.RouteSetCrossover;

/**
 *
 * @author MAN
 */
public class Test
{

    public static void main(String[] args) throws Exception
    {
        TNDP small = new TNDP(3, new Mandl());
        for (int i = 0; i < 1; i++)
        {
            Solution p1 = new Solution(small);
            Variable[] var = p1.getDecisionVariables();
            RouteSet rs = (RouteSet) var[0];
            System.out.println(rs);
            rs.lengthCheck(small);
            rs.ConnectednessCheck(small);
            small.evaluate(p1);
            System.out.println(p1);

            Solution p2 = new Solution(small);
            var = p2.getDecisionVariables();
            rs = (RouteSet) var[0];
            System.out.println(rs);
            rs.lengthCheck(small);
            rs.ConnectednessCheck(small);
            small.evaluate(p2);
            System.out.println(p2);

            RouteSetCrossover c = new RouteSetCrossover(null);
            Solution p[] =
            {
                p1, p2
            };
            Solution[] offSpring = (Solution[]) c.execute(p);
            small.evaluate(offSpring[0]);
            small.evaluateConstraints(offSpring[0]);
            System.out.println(offSpring[0].getDecisionVariables()[0]);
            small.evaluate(offSpring[1]);
            small.evaluateConstraints(offSpring[1]);
            System.out.println(offSpring[1].getDecisionVariables()[0]);
        }
    }
}
