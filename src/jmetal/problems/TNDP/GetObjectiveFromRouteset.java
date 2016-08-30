/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import java.util.logging.Level;
import java.util.logging.Logger;
import jmetal.core.Solution;
import jmetal.core.Variable;
import jmetal.encodings.solutionType.RouteSetSolutionType;
import jmetal.encodings.variable.RouteSet;

/**
 *
 * @author MAN
 */
public class GetObjectiveFromRouteset
{

    /**
     * @param args the command line arguments
     */
    static String routeSetFile = "Test.txt";
    static Instance ins = new Mandl();

    public static void main(String[] args) throws Exception
    {
        // TODO code application logic here
        Variable[] variables = new Variable[1];
        RouteSet rs = RouteSet.readFromFile(ins.dir + routeSetFile);;
        //System.out.println(rs);
        variables[0] = rs;
        TNDP tndp = new TNDP(rs.size(), ins);
        Solution p1 = new Solution(tndp, variables);
        //p1.setDecisionVariables(variables);
        System.out.println(variables[0]);
        tndp.evaluate(p1);
        tndp.evaluateConstraints(p1);
        System.out.println(p1);

    }

}
