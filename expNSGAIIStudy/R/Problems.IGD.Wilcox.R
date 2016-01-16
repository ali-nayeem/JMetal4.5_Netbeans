write("", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex",append=FALSE)
resultDirectory<-"expNSGAIIStudy/data"
latexHeader <- function() {
  write("\\documentclass{article}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\title{StandardStudy}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\usepackage{amssymb}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\author{A.J.Nebro}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\begin{document}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\maketitle", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\section{Tables}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
}

latexTableHeader <- function(problem, tabularString, latexTableFirstLine) {
  write("\\begin{table}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\caption{", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write(problem, "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write(".IGD.}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)

  write("\\label{Table:", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write(problem, "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write(".IGD.}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)

  write("\\centering", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\begin{scriptsize}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\begin{tabular}{", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write(tabularString, "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write(latexTableFirstLine, "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\hline ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
}

latexTableTail <- function() { 
  write("\\hline", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\end{tabular}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\end{scriptsize}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  write("\\end{table}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
}

latexTail <- function() { 
  write("\\end{document}", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
}

printTableLine <- function(indicator, algorithm1, algorithm2, i, j, problem) { 
  file1<-paste(resultDirectory, algorithm1, sep="/")
  file1<-paste(file1, problem, sep="/")
  file1<-paste(file1, indicator, sep="/")
  data1<-scan(file1)
  file2<-paste(resultDirectory, algorithm2, sep="/")
  file2<-paste(file2, problem, sep="/")
  file2<-paste(file2, indicator, sep="/")
  data2<-scan(file2)
  if (i == j) {
    write("-- ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  }
  else if (i < j) {
    if (wilcox.test(data1, data2)$p.value <= 0.05) {
      if (median(data1) <= median(data2)) {
        write("$\\blacktriangle$", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
      }
      else {
        write("$\\triangledown$", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE) 
      }
    }
    else {
      write("--", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE) 
    }
  }
  else {
    write(" ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
  }
}

### START OF SCRIPT 
# Constants
problemList <-c("ZDT1", "ZDT2", "ZDT3", "ZDT4", "DTLZ1", "WFG2") 
algorithmList <-c("NSGAIIa", "NSGAIIb", "NSGAIIc", "NSGAIId") 
tabularString <-c("lccc") 
latexTableFirstLine <-c("\\hline  & NSGAIIb & NSGAIIc & NSGAIId\\\\ ") 
indicator<-"IGD"

 # Step 1.  Writes the latex header
latexHeader()
# Step 2. Problem loop 
for (problem in problemList) {
  latexTableHeader(problem,  tabularString, latexTableFirstLine)

  indx = 0
  for (i in algorithmList) {
    if (i != "NSGAIId") {
      write(i , "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
      write(" & ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
      jndx = 0 
      for (j in algorithmList) {
        if (jndx != 0) {
          if (indx != jndx) {
            printTableLine(indicator, i, j, indx, jndx, problem)
          }
          else {
            write("  ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
          }
          if (j != "NSGAIId") {
            write(" & ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
          }
          else {
            write(" \\\\ ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
          }
        }
        jndx = jndx + 1
      }
      indx = indx + 1
    }
  }

  latexTableTail()
} # for problem

tabularString <-c("| l | p{0.15cm}  p{0.15cm}  p{0.15cm}  p{0.15cm}  p{0.15cm}  p{0.15cm}   | p{0.15cm}  p{0.15cm}  p{0.15cm}  p{0.15cm}  p{0.15cm}  p{0.15cm}   | p{0.15cm}  p{0.15cm}  p{0.15cm}  p{0.15cm}  p{0.15cm}  p{0.15cm}   | ") 

latexTableFirstLine <-c("\\hline \\multicolumn{1}{|c|}{} & \\multicolumn{6}{c|}{NSGAIIb} & \\multicolumn{6}{c|}{NSGAIIc} & \\multicolumn{6}{c|}{NSGAIId} \\\\") 

# Step 3. Problem loop 
latexTableHeader("ZDT1 ZDT2 ZDT3 ZDT4 DTLZ1 WFG2 ", tabularString, latexTableFirstLine)

indx = 0
for (i in algorithmList) {
  if (i != "NSGAIId") {
    write(i , "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
    write(" & ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)

    jndx = 0
    for (j in algorithmList) {
      for (problem in problemList) {
        if (jndx != 0) {
          if (i != j) {
            printTableLine(indicator, i, j, indx, jndx, problem)
          }
          else {
            write("  ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
          } 
          if (problem == "WFG2") {
            if (j == "NSGAIId") {
              write(" \\\\ ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
            } 
            else {
              write(" & ", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
            }
          }
     else {
    write("&", "expNSGAIIStudy/R/Problems.IGD.Wilcox.tex", append=TRUE)
     }
        }
      }
      jndx = jndx + 1
    }
    indx = indx + 1
  }
} # for algorithm

  latexTableTail()

#Step 3. Writes the end of latex file 
latexTail()

