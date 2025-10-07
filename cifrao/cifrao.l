/* cifrao.l - Analisador Léxico PURO para CifrãoLang (Foco em Sintaxe) */
%{
#include "cifrao.tab.h"
#include <string.h>
%}

%option yylineno

%%

"var"               { return VAR; }
"print"             { return PRINT; }
"if"                { return IF; }
"else"              { return ELSE; }
"while"             { return WHILE; }
"//".*              {}

[0-9]+(\.[0-9]+)?(BRL|USD|EUR) { return TOKEN_QUANTIA; }
[0-9]+(\.[0-9]+)?  { return NUMERO_PURO; }


[a-zA-Z_][a-zA-Z0-9_]* {
                        yylval.texto = strdup(yytext);
                        return IDENTIFICADOR;
                    }


"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"="             { return '='; }
"("             { return '('; }
")"             { return ')'; }
"{"             { return '{'; }
"}"             { return '}'; }
";"             { return ';'; }
">"             { return '>'; }
"<"             { return '<'; }
"=="            { return OP_IGUAL; }
"!="            { return OP_DIFERENTE; }

[ \t\n\r]+      { /* Ignora espaços, etc. */ }
.               { printf("Erro léxico: Caractere inválido '%s'\n", yytext); }

%%

int yywrap(void) {
    return 1;
}