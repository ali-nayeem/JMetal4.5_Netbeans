/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.operators.mutation;

import grph.Grph;
import grph.in_memory.InMemoryGrph;
import java.util.ArrayList;
import java.util.Arrays;
import jmetal.operators.mutation.RouteSetAddDelMutation;
import jmetal.operators.mutation.RouteSetDelMutation;
import jmetal.operators.mutation.RouteSetTELMutation;
import jmetal.operators.mutation.RouteSetTEOMutation;
import jmetal.operators.mutation.RouteSetXchangelMutation;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import jmetal.core.Operator;
import jmetal.core.Problem;
import jmetal.core.Solution;
import jmetal.encodings.solutionType.RouteSetSolutionType;
import jmetal.encodings.variable.Route;
import jmetal.encodings.variable.RouteSet;
import jmetal.problems.TNDP.TNDP;
import jmetal.util.Configuration;
import jmetal.util.JMException;
import jmetal.util.PseudoRandom;

/**
 *
 * @author MAN
 */
public class RouteSetGuidedMutation extends Mutation
{

    private static final List VALID_TYPES = Arrays.asList(RouteSetSolutionType.class);

    RouteSetAddlMutation Add = new RouteSetAddlMutation(null);
    RouteSetDelMutation Del = new RouteSetDelMutation(null);
    RouteSetTELMutation TEL = new RouteSetTELMutation(null);
    RouteSetTEOMutation TEO = new RouteSetTEOMutation(null);
    RouteSetXchangelMutation Xchange = new RouteSetXchangelMutation(null);
    Operator [][] ObjWiseMut ;

    public RouteSetGuidedMutation(HashMap<String, Object> parameters, Problem prob )
    {
        super(parameters);
        ObjWiseMut = new Operator[prob.getNumberOfObjectives()+1][];
        ObjWiseMut[TNDP.OBJECTIVES.IVTT] = new Operator[]{TEL, Xchange};
        ObjWiseMut[TNDP.OBJECTIVES.TP] = new Operator[]{Add, Xchange};
        ObjWiseMut[TNDP.OBJECTIVES.UP] = new Operator[]{Add, Xchange};
        ObjWiseMut[TNDP.OBJECTIVES.RL] = new Operator[]{TEL, Del};
        ObjWiseMut[TNDP.OBJECTIVES.DO] = new Operator[]{TEO, Del};
        ObjWiseMut[TNDP.OBJECTIVES.WT] = new Operator[]{Add, Del, TEL, TEO, Xchange};
        ObjWiseMut[TNDP.OBJECTIVES.FS] = new Operator[]{Add, Del, TEL, TEO, Xchange};
        ObjWiseMut[ObjWiseMut.length-1] = new Operator[]{Add, Del, TEL, TEO, Xchange};
        
    }

    @Override
    public Object execute(Object object) throws JMException
    {
        Solution solution = (Solution) object;
      
        double[] normObj = new double[solution.getNumberOfObjectives()];
        double total = 0;
        for (int i = 0; i < normObj.length; i++)
        {
            normObj[i] = solution.getNormalizedObjective(i);
            total += solution.getNormalizedObjective(i);
        }
        
        int selectedObj;
        if(total == 0)
        {
            selectedObj = ObjWiseMut.length-1;
        }
        else
        {
            selectedObj = PseudoRandom.roulette_wheel(normObj, total);
        }
        int selectedMutIndex = PseudoRandom.nextInt(ObjWiseMut[selectedObj].length);
        
        ObjWiseMut[selectedObj][selectedMutIndex].execute(solution);
        return solution;
    }

}
