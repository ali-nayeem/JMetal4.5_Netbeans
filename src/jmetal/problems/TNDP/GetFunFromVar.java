/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.logging.Level;
import java.util.logging.Logger;
import jmetal.core.Solution;
import jmetal.core.SolutionSet;
import jmetal.core.Variable;
import jmetal.encodings.solutionType.RouteSetSolutionType;
import jmetal.encodings.variable.Route;
import jmetal.encodings.variable.RouteSet;

/**
 *
 * @author MAN
 */
public class GetFunFromVar
{

    /**
     * @param args the command line arguments
     */
    static String varFile = "VAR.txt";  
    static Instance ins = new Mandl();
    public static void main(String[] args) throws Exception
    {
        // TODO code application logic here
        Variable[] variables = new Variable[1];
        RouteSet rs ;
        TNDP tndp = null;
        Solution sol;
        SolutionSet pop = new SolutionSet();
        FileReader fr = new FileReader(ins.dir + varFile);
        BufferedReader br = new BufferedReader(fr);
        while (true)
        {
            String line = br.readLine();
            if (line == null)
            {
                break;
            }
            rs = RouteSet.readFromString(line.trim());
            variables[0] = rs;
            System.out.println(variables[0]);
            if(tndp == null)
            {
                tndp = new TNDP(rs.size(), ins);
            }
            sol = new Solution(tndp, variables);
            tndp.evaluate(sol);
            tndp.evaluateConstraints(sol);
            pop.add(sol);
        }
        br.close();
        fr.close();
        
        pop.printFeasibleFUN(ins.dir + "FUN_for_"+varFile);
        
        
        
    }
    
}
