/** Grammar from tour chapter augmented with actions */
grammar bc;

@header {
//package tools;
import java.util.*;
import java.lang.Math;
}

@parser::members {
    /** "memory" for our calculator; variable/value pairs go here */
    Map<String, Float> memory = new HashMap<String, Float>();
    Scanner reader = new Scanner(System.in);

    float eval(String left, int op, String right) {
        float l = memory.containsKey(left) ? memory.get(left) : Float.parseFloat(left);
        float r = memory.containsKey(right) ? memory.get(right) : Float.parseFloat(right);
        switch ( op ) {
            case MUL : return l * r;
            case DIV : return l / r;
            case ADD : return l + r;
            case SUB : return l - r;
        }
        return 0;
    }

    float getFloatValue(String f){
        return Float.parseFloat(f);
    }

    float solveFunction(String func, float val){
        switch(func){
            case "sqrt": return (float)Math.sqrt(val);
            case "s": return (float)Math.sin(val);
            case "c": return (float)Math.cos(val);
            case "l": return (float)Math.log(val);
            case "e": return (float)Math.exp(val);
        }
        return 0;
    }

    int evalBool(float left, String op, float right) {
        if(op.equals("&&")){
            if(left!=0 && right!=0) {return 1;}
        }
        else if (op.equals("||")){
            if(left!=0 || right!=0) {return 1;}
        }
        return 0;
    }
    int evalBool(int left, String op, int right) {
        if(op.equals("&&")){
            if(left!=0 && right!=0) {return 1;}
        }
        else if (op.equals("||")){
            if(left!=0 || right!=0) {return 1;}
        }
        return 0;
    }

    int negation(String op, float val){
        if(op.equals("!") && val==0){
            return 1;
        }
        return 0;
    }
    int negation(String op, int val){
        if(op.equals("!") && val==0){
            return 1;
        }
        return 0;
    }
}

prog: stat+;

stat:   e NEWLINE               {System.out.println($e.v);}
    |   boolexpr NEWLINE        {System.out.println($boolexpr.i);}
    |   function NEWLINE        {System.out.println($function.f);}
    |   ID '=' function NEWLINE {memory.put($ID.text, $function.f);}
    |   ID '=' e NEWLINE        {memory.put($ID.text, $e.v);}
    |   ID '=' boolexpr NEWLINE {memory.put($ID.text, (float)$boolexpr.i);}
    |   NEWLINE
    ;

function returns [float f]
    : 'read' '(' ')'            {$f = reader.nextFloat();}
    | ID '(' a=e ')'            {$f = solveFunction($ID.text, $a.v);}
    ;

boolexpr returns [int i]
    : x=boolexpr op=AND y=boolexpr   {$i = evalBool($x.i, $op.text, $y.i);}
    | a=e op=AND x=boolexpr          {$i = evalBool($a.v, $op.text, $x.i);}
    | x=boolexpr op=AND b=e          {$i = evalBool($x.i, $op.text, $b.v);}
    | a=e op=AND b=e                 {$i = evalBool($a.v, $op.text, $b.v);}
    | x=boolexpr op=OR y=boolexpr    {$i = evalBool($x.i, $op.text, $y.i);}
    | a=e op=OR x=boolexpr           {$i = evalBool($a.v, $op.text, $x.i);}
    | x=boolexpr op=OR b=e           {$i = evalBool($x.i, $op.text, $b.v);}
    | a=e op=OR b=e                  {$i = evalBool($a.v, $op.text, $b.v);}
    | op=NOT x=boolexpr              {$i = negation($op.text, $x.i);}
    | op=NOT a=e                     {$i = negation($op.text, $a.v);}
    | '(' boolexpr ')'               {$i = $boolexpr.i;}
    ;

e returns [float v]
    : a=e op=('*'|'/') b=e  {$v = eval($a.text, $op.type, $b.text);}
    | a=e op=('+'|'-') b=e  {$v = eval($a.text, $op.type, $b.text);}
    | FLOAT                 {$v = getFloatValue($FLOAT.text);}
    | ID
      {
      String id = $ID.text;
      $v = memory.containsKey(id) ? memory.get(id) : 0;
      }
    | '(' e ')'             {$v = $e.v;}
    ;




AND : '&&' ;	    //IPadded
OR : '||';			//IPadded
NOT : '!' ;			//IPadded

MUL : '*' ;
DIV : '/' ;
ADD : '+' ;
SUB : '-' ;

ID  :   [a-zA-Z]+ ;      // match identifiers
FLOAT
    :   INT+ '.' INT
    |   '.' INT+
    |   INT+
    ;
INT :   [0-9]+ ;         // match integers
NEWLINE:'\r'? '\n' ;     // return newlines to parser (is end-statement signal)
WS  :   [ \t]+ -> skip ; // toss out whitespace
COMMENT: '/*' .*? '*/' -> skip;
