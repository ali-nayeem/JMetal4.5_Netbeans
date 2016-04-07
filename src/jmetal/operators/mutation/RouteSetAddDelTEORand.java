/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.operators.mutation;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import jmetal.core.Operator;
import jmetal.core.Problem;
import jmetal.core.Solution;
import jmetal.encodings.solutionType.RouteSetSolutionType;
import jmetal.problems.TNDP.TNDP;
import jmetal.util.JMException;
import jmetal.util.PseudoRandom;

/**
 *
 * @author MAN
 */
public class RouteSetAddDelTEORand extends Mutation
{

    //private static final List VALID_TYPES = Arrays.asList(RouteSetSolutionType.class);

    RouteSetAddlMutation Add = new RouteSetAddlMutation(null);
    RouteSetDelMutation Del = new RouteSetDelMutation(null);
    RouteSetTELMutation TEL = new RouteSetTELMutation(null);
    RouteSetTEOMutation TEO = new RouteSetTEOMutation(null);
    //RouteSetXchangelMutation Xchange = new RouteSetXchangelMutation(null);
    Operator [] ListOfMut ;

    public RouteSetAddDelTEORand(HashMap<String, Object> parameters )
    {
        super(parameters);
        ListOfMut = new Operator[]{Add, Del, TEO};
        
    }

    @Override
    public Object execute(Object object) throws JMException
    {
        Solution solution = (Solution) object;
        
        int selectedMutIndex = PseudoRandom.nextInt(ListOfMut.length);
        
        ListOfMut[selectedMutIndex].execute(solution);
        return solution;
    }

}
