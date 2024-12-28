#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H

#include <stdbool.h>

// Constante para longitud máxima de cadenas
#define TAMANO_MAXIMO_CADENA 255

// Tipos de datos soportados (solo tenemos tipos de datos enteros y string)
typedef enum {
    TIPO_INT,
    TIPO_STRING
} TipoDato;

// Nodo de la tabla de simbolos
typedef struct Simbolo {
    char *nombre;       // Name id (Nombre del identificador)
    TipoDato tipo;      // Tipo de dato   
    union {
        int valor_entero;
        char valor_string[255];    // lo podriamos cambiar a punteror dinámico?
    } valor;
    bool es_constante;  // para saber si es una constante
    struct Simbolo *siguiente;
} Simbolo;

//symbols table functions
void inicializar_tabla();                                                // Inicializa la tabla de símbolos. Debe llamarse antes de usar otras funciones.
void destruir_tabla();                                                   // Libera todos los recursos asociados a la tabla de símbolos.
bool agregar_variable(const char *nombre, TipoDato tipo);                // Agrega una nueva variable a la tabla de símbolos. Devuelve false si ya existe.
bool agregar_constante(const char *nombre, TipoDato tipo, void *valor);  // Agrega una constante a la tabla de símbolos con un valor inicial. Devuelve false si ya existe.
Simbolo *buscar_simbolo(const char *nombre);                             // Busca un símbolo en la tabla por su nombre. Devuelve NULL si no se encuentra.
bool asignar_valor(const char *nombre, void *valor);                     // Asigna un valor a una variable existente. Devuelve false si no existe o es constante.
void leer_identificador(const char* nombre);                             // Permite leer el valor de una variable desde la entrada estándar.

// funcion auxiliar
char *sacar_comillas_iniciales_y_finales(char *str);

// Funciones Opcionales que podriamos utilizar:
//void imprimir_tabla(); // Función opcional para depuración
//bool eliminar_simbolo(const char *nombre); // Función opcional para eliminar un símbolo

#endif
