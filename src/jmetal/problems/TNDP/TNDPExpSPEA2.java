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
public class TNDPExpSPEA2 extends Experiment
{

    private static final double[] crossoverProbabilityList = {0.0};//, 0.2, 0.4, 0.6, 0.8, 1.0}; //0.0, 0.2, 0.4, 0.5, 0.6, 0.8, 
    private static final String[] selectionList = new String[]{"BinaryTournament"}; //, "RetativeTournamentSelection"
    private static final String[] mutationList = new String[]{ "RouteSetAddDelRand"};//,"RouteSetAddDelTELRand","RouteSetAddDelTEORand", "RouteSetCombinedRandomMutation", "RouteSetCombinedGuidedMutation"}; //"RouteSetAddDelMutation","RouteSetAddDelTELRand","RouteSetAddDelTEORand"
    private static String[] algoNameList = new String[crossoverProbabilityList.length*selectionList.length*mutationList.length];
    private static HashMap[] parameterList = new HashMap[crossoverProbabilityList.length*selectionList.length*mutationList.length];
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
                algorithm[i] = new SPEA2_Settings(problemName).configure(parameterList[i]);
            }
            
        } catch (IllegalArgumentException | IllegalAccessException | JMException ex)
        {
            Logger.getLogger(TNDPExpSPEA2.class.getName()).log(Level.SEVERE, null, ex);
        }
    } // algorithmSettings

    public static void main(String[] args) throws JMException, IOException
    {
        TNDPExpSPEA2 exp = new TNDPExpSPEA2();
        exp.experimentName_ = "SPEA2_26-3-18";
        int index = 0;
        for (int i = 0; i < mutationList.length; i++)
        {
            for (int j = 0; j < selectionList.length; j++)
            {
                for (int k = 0; k < crossoverProbabilityList.length; k++)
                {
                    algoNameList[index] = mutationList[i] + "-" + selectionList[j] + "-" + crossoverProbabilityList[k];
                    parameterList[index] = new HashMap();
                    parameterList[index].put("mutationName_", mutationList[i]);
                    parameterList[index].put("SelectionName_",selectionList[j]);
                    parameterList[index].put("crossoverProbability_",crossoverProbabilityList[k]);
                    index++;
                }
            }
        }
        exp.algorithmNameList_ = algoNameList; //Can be extended
        
        exp.problemList_ = new String[] //Can be extended
        {
            "M1-15"
        };

        exp.paretoFrontFile_ = new String[]{"M1-15.pf"}; //must be set as length of problemList_   String[]{"front.pf"}
        exp.indicatorList_ = new String[]{"HV"}; //String[]{"HV"}

        int numberOfAlgorithms = exp.algorithmNameList_.length;

        exp.experimentBaseDirectory_ = "Experiment/" + exp.experimentName_;
        exp.paretoFrontDirectory_ = "Experiment/RF_20-6-16"; //Experiment/RF_20-6-16

        exp.algorithmSettings_ = new Settings[numberOfAlgorithms];

        exp.independentRuns_ = 15;

        exp.initExperiment();

        // Run the experiments
        int numberOfThreads;
        //exp.runExperiment(numberOfThreads = 1);
        exp.generateQualityIndicators();
        exp.generateLatexTables() ;
    }
}