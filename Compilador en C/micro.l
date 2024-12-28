%{
#include "micro.tab.h"      // Cabecera generada por Bison que contiene los tokens y declaraciones compartidas 
#include <string.h>         // Biblioteca para manejo de cadenas (strdup, etc.)
#include <stdlib.h>         // Biblioteca para conversión de tipos (atoi, etc.)
extern int yylineno;
%}
&option yylineno

// Expresiones regulares para identificadores, constantes y palabras reservadas
digito      [0-9]
letra       [a-zA-Z]
id          ({letra})({letra}|{digito})*
constante   {digito}({digito})*

%%

// Palabras reservadas del lenguaje MICRO
"inicio"    { return INICIO; }      // Marca el inicio del programa
"fin"       { return FIN; }         // Marca el fin del programa
"escribir"  { return ESCRIBIR; }
"leer"	    { return LEER; }
"const"     { return CONST; }
"int"       { return INT; }
"string"    { return STRING; }
";"         { return PUNTOYCOMA; }
","         { return COMA; }
":="        { return ASIGNACION; }
"+"         { return SUMA; }
"-"         { return RESTA; }
"("         { return PARENIZQ; }
")"         { return PARENDER; }

// Cada palabra reservada devuelve un token específico, que será procesado por el parser en Bison.

// Reconocimiento de cadenas literales entre comillas dobles
// Validacion de longitud de cadenas literales
\"[^\"]*\" {
    if (strlen(yytext) - 2 > 255) { // Restar 2 para excluir las comillas
        fprintf(stderr, "Error: Cadena excede el límite de 255 caracteres en línea %d.\n", yylineno);
        exit(EXIT_FAILURE);
    }
    yylval.strval = strdup(yytext);
    return CADENA;
}

// Almacena el valor de la cadena en yylval.strval, que sera usado por el parser
// strdup --> duplica el contenido de la cadena para evitar problemas con la memoria 

{id}        { yylval.strval = strdup(yytext); return ID; }      // Identificadores válidos

{constante}    { yylval.intval = atoi(yytext); return NUM; }    // Numeros constantes

[ \t\n]+     ;  // Ignorar espacios en blanco y nuevas líneas
.           { fprintf(stderr, "Error: Token desconocido: '%s' en linea %d\n", yytext, yylineno); exit(EXIT_FAILURE) }    // Manejo más robusto, abortar el análisis si se encuentra un error crítico.

%%

int yywrap() {
    return 1;   // Indica fin de entrada
}
