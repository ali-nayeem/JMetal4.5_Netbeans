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
public class RouteSetCombinedGuidedMutation extends Mutation
{

    //private static final List VALID_TYPES = Arrays.asList(RouteSetSolutionType.class);

    RouteSetAddlMutation Add = new RouteSetAddlMutation(null);
    RouteSetDelMutation Del = new RouteSetDelMutation(null);
    RouteSetTELMutation TEL = new RouteSetTELMutation(null);
    RouteSetTEOMutation TEO = new RouteSetTEOMutation(null);
    //RouteSetXchangelMutation Xchange = new RouteSetXchangelMutation(null);
    Operator [][] ObjWiseMut ;

    public RouteSetCombinedGuidedMutation(HashMap<String, Object> parameters, Problem prob )
    {
        super(parameters);
        ObjWiseMut = new Operator[prob.getNumberOfObjectives()+1][];
        ObjWiseMut[TNDP.OBJECTIVES.IVTT] = new Operator[]{TEL};
        // ObjWiseMut[TNDP.OBJECTIVES.TP] = new Operator[]{Add};
        // ObjWiseMut[TNDP.OBJECTIVES.UP] = new Operator[]{Add};
        ObjWiseMut[TNDP.OBJECTIVES.RL] = new Operator[]{TEL, Del};
        // ObjWiseMut[TNDP.OBJECTIVES.DO] = new Operator[]{TEO, Del};
        ObjWiseMut[TNDP.OBJECTIVES.WT] = new Operator[]{Add, Del};
        // ObjWiseMut[TNDP.OBJECTIVES.FS] = new Operator[]{Add, Del};
        ObjWiseMut[ObjWiseMut.length-1] = new Operator[]{Add, Del};
        
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
