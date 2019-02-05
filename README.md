# COP4020_Project1
Current working calculator located in the tools.zip<br/>
Save the zip file to a direcory and run it with the following commands
  >cd tools<br/>
  >antlr4 -no-listener Expr.g4<br/>
  >javac -d . *.java<br/>
  >java tools.Calc<br/>
  
Those files are from the ANTLR4 Book and i just changed the Expr.g4 file to perform more operations. 
You can view the original Expr.g4 in the book by clicking on the file name in chp 10 at the following site:
  >https://media.pragprog.com/titles/tpantlr2/listener.pdf
  
  
5 Feb 2019:
  To use test cases with grammar:
  1. Save bc.g4 and test cases to some directory
  2. Open terminal and run the following commands
  >cd directoryWithFiles</br>
  >antlr4 -no-listener bc.g4</br>
  >javac -d . *.java</br>
  >grun bc prog test4.bc</br>
  3. This should output the results of the commands saved in test4.bc (replace with other test files to test output)
