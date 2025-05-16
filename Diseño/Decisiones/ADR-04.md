# ADR 004: Persistencia de la cola de moderación con base de datos

## Contexto y Declaración del Problema

En el sistema los artículos pasan por una revisión antes de ser publicados. Inicialmente se planteó implementar una cola en memoria para gestionar los artículos pendientes de moderación. Sin embargo, asi como esto era muy rápido, implicaba mantener un estado interno en un proceso separado (como un GenServer), lo que podía llevar a pérdida de datos en caso de reinicio o despliegue del sistema.
## Opciones Consideradas

- Cola en memoria usando GenServer  
- Persistencia en base de datos usando Ecto  
- Uso de un sistema de colas externo (ej. RabbitMQ, Redis)

## Resultado de la Decisión

**Opción elegida:** _Persistencia en base de datos usando Ecto_, porque permite mantener el orden FIFO directamente mediante una consulta a los artículos con estado `:pending_review`, sin necesidad de almacenar ni sincronizar estado en memoria. Es la solución más simple, robusta y alineada con la arquitectura existente.

## Consecuencias

**Bueno, porque:**
- Se evita la pérdida de estado tras reinicios o despliegues.
- No requiere mantener procesos adicionales.
- Aprovecha las capacidades del sistema de persistencia ya disponible (PostgreSQL + Ecto).

**Malo, porque:**
- Cada operación de obtención de la cola implica una consulta a la base de datos (aunque optimizable).

