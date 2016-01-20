/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import jmetal.core.Algorithm;
import jmetal.core.Operator;
import jmetal.core.Problem;
import jmetal.core.SolutionSet;
import jmetal.metaheuristics.nsgaIII.NSGAIII;
import jmetal.operators.crossover.RouteSetCrossover;
import jmetal.operators.mutation.RouteSetAddDelMutation;
import jmetal.operators.selection.SelectionFactory;

/**
 *
 * @author MAN
 */
public class TestNSGAIII
{

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception
    {
        // TODO code application logic here
        Problem problem; // The problem to solve
        Algorithm algorithm; // The algorithm to use
        Operator crossover; // Crossover operator
        Operator mutation; // Mutation operator
        Operator selection;

        problem = new TNDP(12, new M0());
        algorithm = new NSGAIII(problem);
        algorithm.setInputParameter("normalize", true);

        algorithm.setInputParameter("div1", 3);
        algorithm.setInputParameter("div2", 2);

        algorithm.setInputParameter("maxGenerations", 50);

        crossover = new RouteSetCrossover(null);
        mutation = new RouteSetAddDelMutation(null);
        selection = SelectionFactory.getSelectionOperator("RandomSelection", null);
        // Add the operators to the algorithm
        algorithm.addOperator("crossover", crossover);
        algorithm.addOperator("mutation", mutation);
        algorithm.addOperator("selection", selection);
        //Bismillah
        SolutionSet population = algorithm.execute();

        population.printFeasibleFUN("TNDP-FUN");
        population.printFeasibleVAR("TNDP-VAR");
    }

}
