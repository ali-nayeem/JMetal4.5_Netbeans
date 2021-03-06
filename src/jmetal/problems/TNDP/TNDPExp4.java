/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import java.io.IOException;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import jmetal.core.Algorithm;
import jmetal.experiments.Experiment;
import jmetal.experiments.Settings;
import jmetal.util.JMException;

/**
 *
 * @author MAN
 */
public class TNDPExp4 extends Experiment
{

    private static final double[] crossoverProbabilityList =
    {
         0.6, 1.0
    };
    private static final int[] tSizeList =
    {
        0, 10, 20, 40, 60, 80, 100
    };
    private static final String[] selectionList = new String[]
    {
        "RetativeTournamentSelection"
    };
    private static final String[] mutationList = new String[]
    {
         "RouteSetCombinedGuidedMutation", "RouteSetCombinedRandomMutation", "RouteSetAddDelRand", "RouteSetAddDelTELRand", "RouteSetAddDelTEORand"
    };
    private static String[] algoNameList = new String[crossoverProbabilityList.length * selectionList.length * mutationList.length * tSizeList.length];
    private static HashMap[] parameterList = new HashMap[crossoverProbabilityList.length * selectionList.length * mutationList.length * tSizeList.length];

    @Override
    public synchronized void algorithmSettings(String problemName, int problemId, Algorithm[] algorithm) throws ClassNotFoundException
    {
        try
        {
            int numberOfAlgorithms = algorithmNameList_.length;

//            HashMap[] parameters = new HashMap[numberOfAlgorithms];
//
//            for (int i = 0; i < numberOfAlgorithms; i++)
//            {
//                parameters[i] = new HashMap();
//            } // for
            if (!(paretoFrontFile_[problemIndex] == null) && !paretoFrontFile_[problemIndex].equals(""))
            {
                for (int i = 0; i < numberOfAlgorithms; i++)
                {
                    parameterList[i].put("paretoFrontFile_", paretoFrontFile_[problemIndex]);
                }
            } // if
            for (int i = 0; i < numberOfAlgorithms; i++)
            {
                algorithm[i] = new NSGAIII_Settings(problemName).configure(parameterList[i]);
            }

        } catch (IllegalArgumentException | IllegalAccessException | JMException ex)
        {
            Logger.getLogger(TNDPExp4.class.getName()).log(Level.SEVERE, null, ex);
        }
    } // algorithmSettings

    public static void main(String[] args) throws JMException, IOException
    {
        TNDPExp4 exp = new TNDPExp4();
        exp.experimentName_ = "ExpMandl4on13-4-16";
        int index = 0;
        for (int i = 0; i < mutationList.length; i++)
        {
            for (int j = 0; j < selectionList.length; j++)
            {
                for (int k = 0; k < crossoverProbabilityList.length; k++)
                {
                    for (int l = 0; l < tSizeList.length; l++)
                    {
                        algoNameList[index] = mutationList[i] + "-" + selectionList[j] + "-" + crossoverProbabilityList[k]+"-"+ tSizeList[l];
                        parameterList[index] = new HashMap();
                        parameterList[index].put("mutationName_", mutationList[i]);
                        parameterList[index].put("SelectionName_", selectionList[j]);
                        parameterList[index].put("crossoverProbability_", crossoverProbabilityList[k]);
                        parameterList[index].put("tSize_",tSizeList[l]);
                        index++;
                    }

                }
            }
        }
        exp.algorithmNameList_ = algoNameList; //Can be extended

        exp.problemList_ = new String[] //Can be extended
        {
            "Mandl-4"
        };

        exp.paretoFrontFile_ = new String[]{"front.pf"}; //must be set as length of problemList_ 
        exp.indicatorList_ = new String[]{"HV"};
      

        int numberOfAlgorithms = exp.algorithmNameList_.length;

        exp.experimentBaseDirectory_ = "IO/" + exp.experimentName_;
        exp.paretoFrontDirectory_ = "IO/ExtractFront";

        exp.algorithmSettings_ = new Settings[numberOfAlgorithms];

        exp.independentRuns_ = 20;

        exp.initExperiment();

        // Run the experiments
        int numberOfThreads;
        //exp.runExperiment(numberOfThreads = 3);
        exp.generateQualityIndicators();
        exp.generateLatexTables();
    }
}
