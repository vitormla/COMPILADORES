%{

#include <stdio.h>

%}

%option yylineno

%%

[ \t\r\n]       { printf("espaço\n"); }

"print"         { printf("print\n"); }
"+"             { printf("+\n"); }
"-"             { printf("-\n"); }
"*"             { printf("*\n"); }
"/"             { printf("/\n"); }
"("             { printf("(\n"); }
")"             { printf(")\n"); }
";"             { printf(";\n"); }
"="             { printf("=\n"); }

[0-9]+          { printf("<TOK_INT, %d>\n", atoi(yytext));}
[0-9]+\.[0-9]+  { printf("<TOK_FLT, %f>\n", atof(yytext));}
[a-zA-Z_]+[0-9]* { printf(<TOK_IDENT, %s\n>, yytext)}

.               { printf("Caractere não presente no alfabeto %c\n", yytext ); } 


%%
