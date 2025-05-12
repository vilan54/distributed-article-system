# Arquitectura distribuida cliente-servidor

## Contexto y Declaración del Problema

El sistema debe ofrecer una plataforma para editar y consultar artículos estilo Wikipedia. Dado que se espera un crecimiento en el número de usuarios y operaciones concurrentes, una arquitectura monolítica o de un solo servidor no es escalable ni tolerante a fallos.

¿Cómo podemos diseñar una arquitectura que permita escalar horizontalmente, garantizar disponibilidad y soportar distribución?

## Opciones Consideradas

* Arquitectura monolítica
* Arquitectura cliente-servidor distribuida con nodos coordinados
* Microservicios independientes para cada operación (crear, leer, valorar, etc.)

## Resultado de la Decisión

Opción elegida: **"Arquitectura cliente-servidor distribuida con nodos coordinados"**, porque permite escalar la lógica de negocio horizontalmente mediante múltiples nodos Elixir (`KnowledgeServer`), manteniendo una separación clara entre cliente, servidor y base de datos.

### Consecuencias

* Bueno, porque habilita la escalabilidad y disponibilidad sin necesidad de romper la lógica en microservicios.
* Bueno, porque Elixir y OTP ofrecen primitivas para procesos distribuidos (`Node`, `GenServer`, `Registry`).
* Malo,*
