/* cifrao.y - Analisador Sintático PURO para CifrãoLang (com nomes de regras em inglês) */
%{
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);
extern int yylineno;
int errorc = 0;

/* Struct da tabela de símbolos (sem alteração) */
typedef struct {
    char *nome;
    int token;
} Simbolo;

Simbolo tsimbolos[100];
int simbolo_qtd = 0;

/* Funções da tabela de símbolos (sem alteração) */
void simbolo_novo(char *nome, int token);
bool simbolo_existe(char *nome);
void debug();
%}

%define parse.error verbose

%union {
    char *texto;
}

/* Tokens (sem alteração) */
%token VAR PRINT IF ELSE WHILE
%token TOKEN_QUANTIA NUMERO_PURO
%token <texto> IDENTIFICADOR
%token OP_IGUAL OP_DIFERENTE


%start program

%%


program:
    statement_list {
        if (errorc == 0) {
            printf("\nPrograma reconhecido sintaticamente com sucesso!\n");
            debug();
        } else {
            printf("\n%d erro(s) de sintaxe encontrado(s).\n", errorc);
        }
    }
    ;


statement_list:

    | statement_list statement
    ;

/* MUDANÇA: 'sentencia' para 'statement' */
statement:
    declaration
    | assignment
    | print_stmt
    | conditional_stmt  /* <-- NOVO */
    | loop_stmt         /* <-- NOVO */
    ;

/* MUDANÇA: 'declaracao' para 'declaration' */
declaration:
    VAR IDENTIFICADOR ';' {
        if (!simbolo_existe($2)) {
            simbolo_novo($2, IDENTIFICADOR);
        }
    }
    ;

/* MUDANÇA: 'atribuicao' para 'assignment' */
assignment:
    IDENTIFICADOR '=' expression ';'
    ;

/* MUDANÇA: 'impressao' para 'print_stmt' (print statement) */
print_stmt:
    PRINT expression ';'
    ;

expression:
  term
    | expression '+' term
    | expression '-' term
    ;

conditional_stmt:
    IF '(' logical_expression ')' '{' statement_list '}'
    | IF '(' logical_expression ')' '{' statement_list '}' ELSE '{' statement_list '}'
    ;

loop_stmt:
    WHILE '(' logical_expression ')' '{' statement_list '}'
    ;

logical_expression:
    expression '>' expression
    | expression '<' expression
    | expression OP_IGUAL expression
    | expression OP_DIFERENTE expression
    ;

/* Nível 2: Multiplicação e Divisão */
term:
    factor
    | term '*' factor
    | term '/' factor
    ;

/* Nível 3: Literais, Variáveis e Parênteses (maior precedência) */
factor:
    TOKEN_QUANTIA
    | NUMERO_PURO
    | IDENTIFICADOR
    | '(' expression ')'
    ;


%%

/* --- Seção de Código C --- */
/* (Esta parte permanece a mesma) */

void yyerror(const char *s) {
    errorc++;
    fprintf(stderr, "Erro de sintaxe na linha %d: %s\n", yylineno, s);
}

void simbolo_novo(char *nome, int token){
    tsimbolos[simbolo_qtd].nome = nome;
    tsimbolos[simbolo_qtd].token = token;
    simbolo_qtd++;
}

bool simbolo_existe(char *nome){
    for(int i = 0; i < simbolo_qtd; i++){
        if(strcmp(tsimbolos[i].nome, nome) == 0)
            return true;
    }
    return false;
}

void debug(){
    printf("Símbolos (variáveis) encontrados no código:\n");
    for(int i = 0; i < simbolo_qtd; i++){
        printf("\t- %s\n", tsimbolos[i].nome);
    }
}

int main() {
    yyparse();
    return 0;
}