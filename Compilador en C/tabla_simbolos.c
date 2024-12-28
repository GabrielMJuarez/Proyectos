#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabla_simbolos.h"

//tabla de simbolos pointer
static Simbolo *tabla_simbolos = NULL;

void inicializar_tabla() {
    tabla_simbolos = NULL;
}

void destruir_tabla() {
    Simbolo *actual = tabla_simbolos;
    while (actual) {
        Simbolo *siguiente = actual->siguiente;
        free(actual->nombre);
        if (actual->tipo == TIPO_STRING && actual->valor.valor_string) {
            free(actual->valor.valor_string);
        }
        free(actual);
        actual = siguiente;
    }
}

//agrego variable a la tabla
bool agregar_variable(const char *nombre, TipoDato tipo) {
    if (buscar_simbolo(nombre)) {
        printf("Error: La variable '%s' ya está declarada.\n", nombre);
        return false;
    }

    Simbolo *nuevo = malloc(sizeof(Simbolo));
    nuevo->nombre = strdup(nombre);
    nuevo->tipo = tipo;
    nuevo->es_constante = false;
    nuevo->siguiente = tabla_simbolos;
    tabla_simbolos = nuevo;

    return true;
}

//agrego constante a la tabla
bool agregar_constante(const char* nombre, TipoDato tipo, void *valor) {
    if (buscar_simbolo(nombre)) {
        printf("Error: La constante '%s' ya está declarada.\n", nombre);
        return false;
    }

    Simbolo *nuevo = malloc(sizeof(Simbolo));
    nuevo->nombre = strdup(nombre);
    nuevo->tipo = tipo;
    nuevo->es_constante = true;
    if (tipo == TIPO_INT) {
        simbolo->valor.valor_entero = atoi(valor);
    } else if (tipo == TIPO_STRING) {
        strncpy(nuevo->valor.valor_string, (char*)valor, sizeof(nuevo->valor.valor_string) - 1);
        nuevo->valor.valor_string[sizeof(nuevo->valor.valor_string) - 1] = '\0';
    }
    nuevo->siguiente = tabla_simbolos;
    tabla_simbolos = nuevo;

    return true;
}

//buscar simbolo en la tabla
Simbolo *buscar_simbolo(const char *nombre) {
    Simbolo *actual = tabla_simbolos;
    while (actual) {
        if (strcmp(actual->nombre, nombre) == 0) {
            return actual;
        }
        actual = actual->siguiente;
    }
    return NULL;
}

//asigno valor a una variable de la tabla
bool asignar_valor(const char *nombre, void *valor) {
    Simbolo *simbolo = buscar_simbolo(nombre);
    if (!simbolo) {
        printf("Error: La variable '%s' no está declarada.\n", nombre);
        return false;
    }
    if (simbolo->es_constante) {
        printf("Error: No se puede asignar un valor a la constante '%s'.\n", nombre);
        return false;
    }
    if (simbolo->tipo == TIPO_INT) {
        simbolo->valor.valor_entero = atoi(valor);
    } else if (simbolo->tipo == TIPO_STRING) {
        //if (simbolo->valor.valor_string) {
        //    free(simbolo->valor.valor_string);
        //}
        strncpy(simbolo->valor.valor_string, (char*)valor, sizeof(simbolo->valor.valor_string) - 1);
        simbolo->valor.valor_string[sizeof(simbolo->valor.valor_string) - 1] = '\0';
    }
    return true;
}

void leer_identificador(const char* nombre){
    Simbolo *simbolo = buscar_simbolo(nombre);
    if (simbolo->es_constante) {
        printf("Error: No se puede cambiar el valor a la constante '%s'.\n", nombre);
    } else {
        if (simbolo->tipo == TIPO_INT){
            int valorInt;
            printf("Ingrese el valor int que quiere asignarle a %s: \n", nombre);
            scanf("%d", &valorInt);
            simbolo->valor.valor_entero = valorInt;
        }
        if (simbolo->tipo == TIPO_STRING){
            char *valorStr;
            printf("Ingrese el valor string que quiere asignarle a %s: \n", nombre);
            scanf("%s", valorStr);
            strncpy(simbolo->valor.valor_string, (char*)valorStr, sizeof(simbolo->valor.valor_string) - 1);
            simbolo->valor.valor_string[sizeof(simbolo->valor.valor_string) - 1] = '\0';
        }
    }
}

char *sacar_comillas_iniciales_y_finales(char *str){
    int len = strlen(str);
    if(len >1 && str[0] == '"' && str[len -1] == '"'){
        str[len - 1] = '\0';
        memmove(str, str +1, len -1);
        return str;
    }
    return str;
}
