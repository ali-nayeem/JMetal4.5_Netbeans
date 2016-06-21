#!/bin/bash
echo -n > front
for i in *.rf ; do cat $i >> front ; done
cd /home/ali_nayeem/NetBeansProjects/JMetal4.5_Netbeans/src
java jmetal.util.ExtractParetoFront /home/ali_nayeem/NetBeansProjects/JMetal4.5_Netbeans/IO/ExtractFront/front 7
