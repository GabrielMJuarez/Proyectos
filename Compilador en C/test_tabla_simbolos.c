#include <stdio.h>
#include "tabla_simbolos.h"

// 1. Prueba de agregar una nueva variable y asegurarme de que se agrego corretamente
void test_agregar_variable() {
    bool resultado = agregar_variable("var1", TIPO_INT);
    printf("Test agregar variable (var1): %s\n", resultado ? "Exitoso" : "Fallido");

    Simbolo *simbolo = buscar_simbolo("var1");
    if (simbolo) {
        printf("Variable encontrada: %s, Tipo: %d\n", simbolo->nombre, simbolo->tipo);
    } else {
        printf("Error: Variable no encontrada\n");
    }
}

// 2. Prueba de agregar variable duplicada ("con el mismo nombre") y que muestre el mensaje de error
void test_agregar_variable_duplicada() {
    agregar_variable("var2", TIPO_INT);
    bool resultado = agregar_variable("var2", TIPO_INT);
    printf("Test agregar variable duplicada (var2): %s\n", resultado ? "Exitoso" : "Fallido");
}

// 3. Prueba de agregar una constante y luego intentar modificar su valor. La constante NO debe modificarse.
void test_agregar_constante() {
    int valor = 42;
    agregar_constante("const1", TIPO_INT, &valor);

    Simbolo *simbolo = buscar_simbolo("const1");
    if (simbolo) {
        printf("Constante encontrada: %s, Valor: %d\n", simbolo->nombre, simbolo->valor.valor_entero);
    } else {
        printf("Error: Constante no encontrada\n");
    }

    // Intentar modificar la constante
    int nuevo_valor = 100;
    bool resultado = asignar_valor("const1", &nuevo_valor);
    printf("Intento de modificar constante: %s\n", resultado ? "Exitoso" : "Fallido");
}

// 4. Prueba de asignar un valor a una variable que ha sido agregada previamente.
void test_asignar_valor_variable() {
    agregar_variable("var3", TIPO_INT);

    int valor = 99;
    bool resultado = asignar_valor("var3", &valor);
    printf("Test asignar valor a variable (var3): %s\n", resultado ? "Exitoso" : "Fallido");

    Simbolo *simbolo = buscar_simbolo("var3");
    if (simbolo) {
        printf("Variable '%s' ahora tiene el valor: %d\n", simbolo->nombre, simbolo->valor.valor_entero);
    }
}

// 5. Prueba de intentar asignar un valor a una variable que no existe en la tabla y el sistema maneje correctamente este error.
void test_asignar_valor_variable_no_declarada() {
    int valor = 100;
    bool resultado = asignar_valor("var_no_existente", &valor);
    printf("Test asignar valor a variable no declarada: %s\n", resultado ? "Exitoso" : "Fallido");
}

// Implementar otras funciones de prueba...

// -- PROGRAMA PRINCIPAL --

int main() {
    test_agregar_variable();
    test_agregar_variable_duplicada();
    test_agregar_constante();
    test_asignar_valor_variable();
    test_asignar_valor_variable_no_declarada();
    // Llamar a otras funciones de prueba...
    destruir_tabla();  // Destruir la tabla después de las pruebas
    return 0;
}
