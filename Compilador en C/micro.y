%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabla_simbolos.h" 

extern FILE *yyin;

//funciones y variables globales
int yylex();
void yyerror(const char* s);
extern int yylineno;

//instanciamos la tabla de simbolos
Simbolo *tabla_simbolos;
%}

%union{
    int intval; //para NUM
    char *strval; // para CADENA y ID
}

//tokens
%token <strval> INICIO FIN LEER ESCRIBIR CONST INT STRING
%token <strval> ID CADENA 
%token <intval> NUM
%token PUNTOYCOMA COMA ASIGNACION SUMA RESTA PARENIZQ PARENDER

//tipos de los no terminales
%type <strval> expresion expresionOCadena
%type <strval> termino

//axioma principal
%start programa


//precedencia operadores
%left SUMA RESTA

%%

//reglas gramaticales para el lengujae micro:

programa
    : INICIO listaSentencias FIN {
          printf("Programa finalizado correctamente.\n");
          destruir_tabla(); // Liberar recursos de la tabla de símbolos
      }
    ;

listaSentencias
    : listaSentencias sentencia
    | /* vacío */
    ;

sentencia
    : declaracion PUNTOYCOMA
    | asignacion PUNTOYCOMA
    | entradaSalida PUNTOYCOMA
    ;

declaracion
    : INT ID {
          if (!agregar_variable($2, TIPO_INT)) {
              yyerror("Error: Variable ya declarada.");
          } else {
              printf("Declaración de entero: %s\n", $2);
          }
      }
    | STRING ID {
          if (!agregar_variable($2, TIPO_STRING)) {
              yyerror("Error: Variable ya declarada.");
          } else {
              printf("Declaración de string: %s\n", $2);
          }
      }
    | CONST ID ASIGNACION expresion {
          if (!agregar_constante($2, TIPO_INT, $4)) {
              yyerror("Error: Constante ya declarada.");
          } else {
              printf("Constante %s asignada con valor %d\n", $2, atoi($4));
          }
      }
    ;

asignacion
    : ID ASIGNACION expresion {
        Simbolo *simboloDeAsignacion = buscar_simbolo($1);
        if(!simboloDeAsignacion){
            yyerror("Error: Variable no declarada.");
        } else{
            if(simboloDeAsignacion->tipo == TIPO_INT){
                if (!asignar_valor($1, $3)) {
                    yyerror("Error en la asignación.");
                } else {
                    printf("Asignación: %s := %d\n", $1, atoi($3));
                }
            }
            else{
                printf("Error: La variable no es de tipo int.\n");
            }
        }
    }
    | ID ASIGNACION CADENA {
        Simbolo *simboloDeAsignacion = buscar_simbolo($1);
        if(!simboloDeAsignacion){
            yyerror("Error: Variable no declarada.");
        } else{
            if(simboloDeAsignacion->tipo == TIPO_STRING){
                if (!asignar_valor($1, $3)) {
                    yyerror("Error en la asignación.");
                } else {
                    printf("Asignación: %s := %s\n", $1, $3);
                }
            }
            else{
                printf("Error: La variable no es de tipo string.\n");
            }
        }
    }
    ;

entradaSalida
    : LEER PARENIZQ listaIdentificadores PARENDER {
          printf("Leer variables.\n");
      }
    | ESCRIBIR PARENIZQ listaExpresiones PARENDER {
          printf("\nEscribir expresiones.\n");
      }
    ;

listaIdentificadores
    : ID {
          if (!buscar_simbolo($1)) {
              yyerror("Error: Variable no declarada.");
          } else {
              leer_identificador($1);
          }
      }
    | listaIdentificadores COMA ID {
          if (!buscar_simbolo($3)) {
              yyerror("Error: Variable no declarada.");
          } else {
              leer_identificador($3);
          }
      }
    ;

listaExpresiones
    : expresionOCadena {
          printf("%s", $1);
      }
    | listaExpresiones COMA expresionOCadena {
          printf("%s", $3);
      }
    ;

expresionOCadena
    : expresion 
    | CADENA {
        $$ = sacar_comillas_iniciales_y_finales($1);
    }
    ;

expresion
    : termino
    | expresion SUMA termino {
          int suma = atoi($1) + atoi($3);
          $$ = malloc(12);
          sprintf($$, "%d", suma);
      }
    | expresion RESTA termino {
          int resta = atoi($1) - atoi($3);
          $$ = malloc(12);
          sprintf($$, "%d", resta);
          
      }
    ;

termino
    : NUM {
          $$ = malloc(12);
          sprintf($$, "%d", $1);
      }
    | ID {
          Simbolo *simbolo = buscar_simbolo($1);
          if (!simbolo) {
              yyerror("Error: Variable no declarada.");
              $$ = strdup("0");
          } else if (simbolo->tipo != TIPO_INT) {
              yyerror("Error: Se esperaba un entero.");
              $$ = strdup("0");
          } else {
              $$ = malloc(12);
              sprintf($$, "%d", simbolo->valor.valor_entero); 
          }
      }
    | PARENIZQ expresion PARENDER {
          $$ = $2;
      }
    ;

%%

//C code:

int main(int argc, char **argv) {
    printf("Inicio de ejecución del programa en lenguaje MICRO\n");
    inicializar_tabla(); 

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Error: No se pudo abrir el archivo %s\n", argv[1]);
            return EXIT_FAILURE;
        }
        printf("Leyendo código desde el archivo: %s\n", argv[1]);
    } else {
        printf("Leyendo código desde entrada estándar...\n");
        yyin = stdin;
    }

    int resultado = yyparse();

    if (yyin != stdin) {
        fclose(yyin); 
    }

    return resultado;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s en línea %d\n", s, yylineno);
}
