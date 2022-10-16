%{
/************************************
xsj
expr1.y
YACC file
Date: 2022/10/14
************************************/
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
int isdigit(int x);
extern int yyparse();
FILE* yyin;
YYSTYPE yylval;
void yyerror(const char* s);
%}

%token NUMBER
%token ADD
%token SUB
%token MUL
%token DIV
%token open
%token close
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines  :  lines expr '\n'{printf("%f\n",$2);}
       |  lines '\n'
       |
       ;
       
expr  :  expr ADD expr{$$=$1+$3;}
      |  expr SUB expr{$$=$1-$3;}
      |  expr MUL expr{$$=$1*$3;}
      |  expr DIV expr{$$=$1/$3;}
      |  open expr close {$$=$2;}
      |  SUB expr %prec UMINUS {$$=-$2;}
      |  NUMBER {$$=$1;}
      ;
/*      
NUMBER  :  '0'  {$$=0.0;}
        |  '1'  {$$=1.0;}
        |  '2'  {$$=2.0;}
        |  '3'  {$$=3.0;}
        |  '4'  {$$=4.0;}
        |  '5'  {$$=5.0;}
        |  '6'  {$$=6.0;}
        |  '7'  {$$=7.0;}
        |  '8'  {$$=8.0;}
        |  '9'  {$$=9.0;}
        ;
*/        
%%

//progarms section

int yylex()
{
  //place your token retrieving code here
  int t;
  while(1){
    t=getchar();
    if(t==' '||t=='\t'||t=='\n'){
      //do nothing 
    }else if(isdigit(t)){
      yylval=0;
      while(isdigit(t)){
        yylval=yylval*10+t-'0';
        t=getchar();
      }
      ungetc(t,stdin);
      return NUMBER;
    }
    else if(t=='+')
      return ADD;
    else if(t=='-')
      return SUB;
    else if(t=='*')
      return MUL;
    else if(t=='/')
      return DIV;
    else if(t=='(')
      return open;
    else if(t==')')
      return close;
    else{
      return t;
    }
  }
}

int isdigit(int x){
  if(x=='0'||x=='1'||x=='2'||x=='3'||x=='4'||x=='5'||x=='6'||x=='7'||x=='8'||x=='9')
  return 1;
  else 
  return 0;
}

int main(void)
{
  yyin=stdin;
  do{
    yyparse();
  }while(!feof(yyin));
  return 0;
}
void yyerror(const char* s){
  fprintf(stderr,"Parse error: %s\n",s);
  exit(1);
}
      
