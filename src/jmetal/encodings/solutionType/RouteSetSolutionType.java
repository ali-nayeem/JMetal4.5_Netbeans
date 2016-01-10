/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.encodings.solutionType;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import jmetal.core.Problem;
import jmetal.core.SolutionType;
import jmetal.core.Variable;
import jmetal.encodings.variable.Real;
import jmetal.encodings.variable.Route;
import jmetal.problems.TNDP.TNDP;
import jmetal.encodings.variable.RouteSet;
import jmetal.util.PseudoRandom;

/**
 *
 * @author MAN
 */
public class RouteSetSolutionType extends SolutionType
{

    private final TNDP prob = (TNDP)problem_;
    public RouteSetSolutionType(Problem problem)
    {
        super(problem);
    }

    @Override
    public Variable[] createVariables() throws ClassNotFoundException
    {
        Variable[] variables = new Variable[1];
        
        RouteSet rs = new RouteSet();
        rs.generateRouteSet(prob);
//        RouteSet rs = null;
//        try
//        {
//            rs = RouteSet.readFromFile(prob.ins.getRouteFile());
//        } catch (Exception ex)
//        {
//            Logger.getLogger(RouteSetSolutionType.class.getName()).log(Level.SEVERE, null, ex);
//        }
        
        variables[0] = rs;

        return variables;
    }

}
