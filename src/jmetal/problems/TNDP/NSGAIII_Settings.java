/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import java.util.HashMap;
import jmetal.core.Algorithm;
import jmetal.core.Operator;
import jmetal.experiments.Settings;
import jmetal.metaheuristics.nsgaIII.NSGAIII;
import jmetal.operators.crossover.RouteSetCrossover;
import jmetal.operators.mutation.RouteSetAddDelMutation;
import jmetal.operators.selection.SelectionFactory;
import jmetal.problems.ProblemFactory;
import jmetal.util.JMException;

/**
 *
 * @author MAN
 */
public class NSGAIII_Settings extends Settings
{

    public int populationSize_;
    public int maxGenerations_;
    public double mutationProbability_;
    public Double addProbability_ ;
    public int div1_;
    public int div2_;

    public NSGAIII_Settings(String ins)
    {
        super(ins);

        //return c.newInstance();
        try
        {
            String[] probName = ins.split("-");
            Class instance = Class.forName("jmetal.problems.TNDP."+probName[0]);
            problem_ = new TNDP(Integer.parseInt(probName[1]),(Instance) instance.newInstance());
        } catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        // Default experiments.settings
        maxGenerations_ = 700;
        mutationProbability_ = 1.0;
        addProbability_ = 0.5;
        div1_ = 3;
        div2_ = 2;
    } // NSGAII_Settings

    @Override
    public Algorithm configure() throws JMException
    {
        Algorithm algorithm; // The algorithm to use
        Operator crossover; // Crossover operator
        Operator mutation; // Mutation operator
        Operator selection;

        algorithm = new NSGAIII(problem_);
        algorithm.setInputParameter("normalize", true);

        algorithm.setInputParameter("div1", div1_);
        algorithm.setInputParameter("div2", div2_);

        algorithm.setInputParameter("maxGenerations", maxGenerations_);

        crossover = new RouteSetCrossover(null);
        
        HashMap parameters = new HashMap();
        parameters.put("probability", mutationProbability_);
        parameters.put("addProbability", addProbability_);
        mutation = new RouteSetAddDelMutation(parameters);
        
        selection = SelectionFactory.getSelectionOperator("RandomSelection", null);
        // Add the operators to the algorithm
        algorithm.addOperator("crossover", crossover);
        algorithm.addOperator("mutation", mutation);
        algorithm.addOperator("selection", selection);

        return algorithm;
    }

}
