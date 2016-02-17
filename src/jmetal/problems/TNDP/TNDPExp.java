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
public class TNDPExp extends Experiment
{

    @Override
    public synchronized void algorithmSettings(String problemName, int problemId, Algorithm[] algorithm) throws ClassNotFoundException
    {
        try
        {
            int numberOfAlgorithms = algorithmNameList_.length;

            HashMap[] parameters = new HashMap[numberOfAlgorithms];

            for (int i = 0; i < numberOfAlgorithms; i++)
            {
                parameters[i] = new HashMap();
            } // for

            if (!(paretoFrontFile_[problemIndex] == null) && !paretoFrontFile_[problemIndex].equals(""))
            {
                for (int i = 0; i < numberOfAlgorithms; i++)
                {
                    parameters[i].put("paretoFrontFile_", paretoFrontFile_[problemIndex]);
                }
            } // if

            algorithm[0] = new NSGAIII_Settings(problemName).configure(parameters[0]);

        } catch (IllegalArgumentException | IllegalAccessException | JMException ex)
        {
            Logger.getLogger(TNDPExp.class.getName()).log(Level.SEVERE, null, ex);
        }
    } // algorithmSettings

    public static void main(String[] args) throws JMException, IOException
    {
        TNDPExp exp = new TNDPExp();
        exp.experimentName_ = "ExpSmall";
        exp.algorithmNameList_ = new String[] //Can be extended
        {
            "NSGAIII"
        };
        exp.problemList_ = new String[] //Can be extended
        {
            "Small-3"
        };

        exp.paretoFrontFile_ = new String[1]; //must be set as length of problemList_ 
        exp.indicatorList_ = new String[0];

        int numberOfAlgorithms = exp.algorithmNameList_.length;

        exp.experimentBaseDirectory_ = "IO/" + exp.experimentName_;
        exp.paretoFrontDirectory_ = "";

        exp.algorithmSettings_ = new Settings[numberOfAlgorithms];

        exp.independentRuns_ = 20;

        exp.initExperiment();

        // Run the experiments
        int numberOfThreads;
        exp.runExperiment(numberOfThreads = 1);
        exp.generateQualityIndicators();
    }
}
