/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import java.util.HashMap;
import jmetal.qualityIndicator.util.MetricsUtil;
import jmetal.util.NonDominatedSolutionList;

/**
 *
 * @author MAN
 */
public class GetMutWiseFront
{

    /**
     * @param args the command line arguments
     */
    static String algo = "ThetaDEA";
    static String problemList_ = "M1-15";
    static int independentRuns_ = 15;
    //*****************************************************************
    private static final double[] crossoverProbabilityList =
    {
        0.0, 0.2, 0.4, 0.6, 0.8, 1.0
    }; //0.0, 0.2, 0.4, 0.5, 0.6, 0.8, 
    private static final String[] mutationList = new String[]
    {
        "RouteSetAddDelRand", "RouteSetAddDelTELRand", "RouteSetAddDelTEORand", "RouteSetCombinedRandomMutation", "RouteSetCombinedGuidedMutation"
    }; //"RouteSetAddDelMutation","RouteSetAddDelTELRand","RouteSetAddDelTEORand"

    public static void main(String[] args)
    {
        // TODO code application logic here
        String selectionList = "RandomSelection";
        if (algo.equalsIgnoreCase("SPEA2"))
        {
            selectionList = "BinaryTournament";
        }

        String experimentBaseDirectory_ = "Experiment/" + algo + "_20-6-16";
        String paretoFrontDirectory_ = "Experiment/RF_20-6-16";

        for (int i = 0; i < mutationList.length; i++)
        {
            String[] algorithmNameList_ = new String[crossoverProbabilityList.length];
            int index = 0;

            for (int k = 0; k < crossoverProbabilityList.length; k++)
            {
                algorithmNameList_[index] = mutationList[i] + "-" + selectionList + "-" + crossoverProbabilityList[k];
//                    parameterList[index] = new HashMap();
//                    parameterList[index].put("mutationName_", mutationList[i]);
//                    parameterList[index].put("SelectionName_",selectionList[j]);
//                    parameterList[index].put("crossoverProbability_",crossoverProbabilityList[k]);
                index++;
            }

            String frontPath_ = "Experiment/MutWiseFront/" + problemList_ + "_" + algo + "_" + mutationList[i] + ".txt";
            MetricsUtil metricsUtils = new MetricsUtil();
            NonDominatedSolutionList solutionSet = new NonDominatedSolutionList();
            for (String anAlgorithmNameList_ : algorithmNameList_)
            {

                String problemDirectory = experimentBaseDirectory_ + "/data/" + anAlgorithmNameList_
                        + "/" + problemList_;

                for (int numRun = 0; numRun < independentRuns_; numRun++)
                {

                    String outputParetoFrontFilePath;
                    outputParetoFrontFilePath = problemDirectory + "/FUN." + numRun;
                    String solutionFrontFile = outputParetoFrontFilePath;

                    metricsUtils.readNonDominatedSolutionSet(solutionFrontFile, solutionSet);
                } // for
            } // for
            solutionSet.printObjectivesToFile(frontPath_);
        }

    }
}
