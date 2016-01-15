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
import jmetal.metaheuristics.thetadea.ThetaDEA;
import jmetal.operators.crossover.RouteSetCrossover;
import jmetal.operators.mutation.RouteSetAddDelMutation;
import jmetal.operators.selection.SelectionFactory;

/**
 *
 * @author MAN
 */
public class TestThetaDEA
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

        problem = new TNDP(4, new Mandl());
        algorithm = new ThetaDEA(problem);
        algorithm.setInputParameter("normalize", true);

        algorithm.setInputParameter("theta",5.0);
        algorithm.setInputParameter("div1", 3);
        algorithm.setInputParameter("div2", 2);

        algorithm.setInputParameter("maxGenerations", 1000);

        crossover = new RouteSetCrossover(null);
        mutation = new RouteSetAddDelMutation(null);
        // Add the operators to the algorithm
        algorithm.addOperator("crossover", crossover);
        algorithm.addOperator("mutation", mutation);
        //Bismillah
        SolutionSet population = algorithm.execute();

        population.printFeasibleFUN("ThetaDEA-FUN");
        population.printFeasibleVAR("ThetaDEA-VAR");
    }

}
