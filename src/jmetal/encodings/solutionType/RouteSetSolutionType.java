/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.encodings.solutionType;

import jmetal.core.Problem;
import jmetal.core.SolutionType;
import jmetal.core.Variable;

/**
 *
 * @author MAN
 */
public class RouteSetSolutionType extends SolutionType
{

    public RouteSetSolutionType(Problem problem)
    {
        super(problem);
    }

    @Override
    public Variable[] createVariables() throws ClassNotFoundException
    {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
