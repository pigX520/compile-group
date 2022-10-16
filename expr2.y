%{
/*******************************
xsj
expr2.y
YACC file
Date: 2022/10/14
******************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
char idstr[50];
char numstr[50];
char under='_';
int yylex();
extern int yyparse();
FILE* yyin;
YYSTYPE yylval;
void yyerror(const char* s);
%}

%token NUMBER
%token ID
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

lines  :  lines expr ';'{printf("%s\n",$2);}
       |  lines ';'
       |
       ;
       
expr  :  expr ADD expr{$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"+ ");}
      |  expr SUB expr{$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"- ");}
      |  expr MUL expr{$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"* ");}
      |  expr DIV expr{$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$,$3);strcat($$,"/ ");}
      |  open expr close {$$=(char *)malloc(50*sizeof(char));strcpy($$,$2);strcat($$," ");}
      |  SUB expr %prec UMINUS {$$=(char *)malloc(50*sizeof(char));strcpy($$,"-");strcat($$,$2);strcat($$," ");}
      |  NUMBER {$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$," ");}
      |  ID  {$$=(char *)malloc(50*sizeof(char));strcpy($$,$1);strcat($$," ");}
      ;
     
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
    }else if((t>='0'&&t<='9')){
      int ti=0;
      while((t>='0'&&t<='9')){
        numstr[ti]=t;
        t=getchar();
        ti++;
      }
      numstr[ti]='\0';
      yylval=numstr;
      ungetc(t,stdin);
      return NUMBER;
    }
    else if((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t==under)){
      int ti=0;
      while((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t==under)||(t>='0'&&t<='9')){
        idstr[ti]=t;
        ti++;
        t=getchar();
      }
      idstr[ti]='\0';
      yylval=idstr;
      ungetc(t,stdin);
      return ID;
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
      
