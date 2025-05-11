# Uso de GenServer para la gestión de artículos

## Contexto y Declaración del Problema

El sistema debe manejar operaciones concurrentes sobre los artículos (crear, editar, eliminar, valorar), que pueden provenir de distintos clientes conectados a diferentes nodos. Es necesario gestionar el estado y las operaciones de manera segura, eficiente y distribuida.

¿Cómo podemos asegurar la consistencia y el control de concurrencia en las operaciones sobre artículos dentro de un entorno distribuido?

## Opciones Consideradas

* Manejo de estado mediante funciones puras (sin procesos)
* Uso exclusivo de base de datos para todas las operaciones (sin lógica intermedia)
* Uso de GenServer como gestor principal de operaciones sobre artículos

## Resultado de la Decisión

Opción elegida: **"Uso de GenServer como gestor principal de operaciones sobre artículos"**, porque permite encapsular tanto el estado como la lógica de negocio en procesos supervisables y escalables, distribuidos entre nodos.

### Consecuencias

* Bueno, porque ofrece aislamiento del estado y control de concurrencia nativo con procesos OTP.
* Bueno, porque permite razonamiento claro sobre el flujo de datos y facilita el debugging.
* Malo, porque puede convertirse en un cuello de botella si no se distribuye correctamente la carga.
* Malo, porque necesita mecanismos externos de persistencia para evitar pérdida de datos ante reinicios.
