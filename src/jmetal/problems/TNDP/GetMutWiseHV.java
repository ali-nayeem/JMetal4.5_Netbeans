/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import jmetal.qualityIndicator.Hypervolume;
import jmetal.qualityIndicator.util.MetricsUtil;
import jmetal.util.NonDominatedSolutionList;

/**
 *
 * @author MAN
 */
public class GetMutWiseHV
{

    /**
     * @param args the command line arguments
     */
    static String algo = "SPEA2";
    static String problemList_ = "Mandl-4";
    static int independentRuns_ = 20;
    //*****************************************************************
//    private static final double[] crossoverProbabilityList =
//    {
//        0.0, 0.2, 0.4, 0.6, 0.8, 1.0
//    };
    private static final String[] mutationList = new String[]
    {
        "RouteSetAddDelRand", "RouteSetAddDelTELRand", "RouteSetAddDelTEORand", "RouteSetCombinedRandomMutation", "RouteSetCombinedGuidedMutation"
    };

    public static void main(String[] args) throws IOException
    {
        // TODO code application logic here
       String HVFileName = "Experiment/MutWiseStat/"+problemList_ + "_" + algo + "_HV.txt";
       FileWriter os = new FileWriter(HVFileName);

        //String experimentBaseDirectory_ = "Experiment/" + algo + "_20-6-16";
        String paretoFrontDirectory_ = "Experiment/RF_20-6-16";
        Hypervolume indicators = new Hypervolume();
        double[][] trueFront =  indicators.utils_.readFront(paretoFrontDirectory_+ "/" + problemList_ + ".pf");

        for (int i = 0; i < mutationList.length; i++)
        {

            String solutionFrontFile = "Experiment/MutWiseFront/" + problemList_ + "_" + algo + "_" + mutationList[i] + ".txt";

            
            double[][] solutionFront = indicators.utils_.readFront(solutionFrontFile);
                //
            double value = indicators.hypervolume(solutionFront, trueFront, trueFront[0].length);
            os.write(mutationList[i] + " " + value + "\n");

        }
        os.close();

    }
}
