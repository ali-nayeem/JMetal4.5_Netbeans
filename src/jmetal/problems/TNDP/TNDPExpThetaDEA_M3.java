/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package jmetal.problems.TNDP;

import java.io.IOException;
import java.util.HashMap;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;
import jmetal.core.Algorithm;
import jmetal.experiments.Experiment;
import jmetal.experiments.Settings;
import jmetal.util.Configuration;
import jmetal.util.JMException;

/**
 *
 * @author MAN
 */
public class TNDPExpThetaDEA_M3 extends Experiment
{

    private static final double[] crossoverProbabilityList = {0.9}; //0.0, 0.2, 0.4, 0.5, 0.6, 0.8,  0.0, 0.2, 0.4, 0.6, 0.8, 1.0 
    private static final double[] addProbabilityList = {0.1, 0.3, 0.5, 0.7, 0.9};
    private static final String[] selectionList = new String[]{"RandomSelection"}; //, "RetativeTournamentSelection"
    private static final String[] mutationList = new String[]{ "RouteSetAddDelMutation"}; //"RouteSetAddDelMutation","RouteSetAddDelTELRand","RouteSetAddDelTEORand"
    private static String[] algoNameList = new String[crossoverProbabilityList.length*selectionList.length*mutationList.length*addProbabilityList.length];
    private static HashMap[] parameterList = new HashMap[crossoverProbabilityList.length*selectionList.length*mutationList.length*addProbabilityList.length];
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
                algorithm[i] = new ThetaDEA_Settings_M3(problemName).configure(parameterList[i]);
            }
            
        } catch (IllegalArgumentException | IllegalAccessException | JMException ex)
        {
            Logger.getLogger(TNDPExpThetaDEA_M3.class.getName()).log(Level.SEVERE, null, ex);
        }
    } // algorithmSettings

    public static void main(String[] args) throws JMException, IOException
    {
        TNDPExpThetaDEA_M3 exp = new TNDPExpThetaDEA_M3();
        exp.experimentName_ = "ThetaDEA_M3_15_8_18";
        int index = 0;
        for (int i = 0; i < mutationList.length; i++)
        {
            for (int j = 0; j < selectionList.length; j++)
            {
                for (int k = 0; k < crossoverProbabilityList.length; k++)
                {
                    for (int l = 0; l < addProbabilityList.length; l++)
                    {
                        algoNameList[index] =  "addProb-" + addProbabilityList[l];
                        parameterList[index] = new HashMap();
                        parameterList[index].put("mutationName_", mutationList[i]);
                        parameterList[index].put("SelectionName_",selectionList[j]);
                        parameterList[index].put("crossoverProbability_",crossoverProbabilityList[k]);
                        parameterList[index].put("addProbability_",addProbabilityList[l]);
                        index++;
                    }
                    
                }
            }
        }
        exp.algorithmNameList_ = algoNameList; //Can be extended
        
        exp.problemList_ = new String[] //Can be extended
        {
            "M3-60"
        };

        exp.paretoFrontFile_ = new String[]{"M3-60.pf"}; //must be set as length of problemList_   String[]{"front.pf"}
        exp.indicatorList_ = new String[]{"HV"}; //String[]{"HV"}

        int numberOfAlgorithms = exp.algorithmNameList_.length;

        exp.experimentBaseDirectory_ = "Experiment/" + exp.experimentName_;
        exp.paretoFrontDirectory_ = ""; //Experiment/ThetaDEA_M3_15_8_18/referenceFronts

        exp.algorithmSettings_ = new Settings[numberOfAlgorithms];

        exp.independentRuns_ = 10;

        exp.initExperiment();
        FileHandler fileHandler = new FileHandler(exp.experimentBaseDirectory_+"/M3.log");
        Configuration.logger_.addHandler(fileHandler);
        SimpleFormatter formatter = new SimpleFormatter();  
        fileHandler.setFormatter(formatter); 
        // Run the experiments
        int numberOfThreads;
        exp.runExperiment(numberOfThreads = 10);
        exp.generateQualityIndicators();
        exp.generateLatexTables() ;
    }
}