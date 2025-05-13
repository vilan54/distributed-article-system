#  1. Documentación de la Aplicación

## 1.1 Requisitos Funcionales

El sistema permite a los usuarios interactuar con artículos académicos o de divulgación. Las funcionalidades incluyen:

-  Consultar artículos publicados.
-  Publicar un nuevo artículo (requiere revisión).
-  Modificar artículos previamente enviados (requiere nueva revisión).
-  Valorar artículos publicados.
-  Filtrar artículos por etiquetas (tags).
-  Los administradores podrán aprobar, rechazar o pedir cambios en las publicaciones.

---

## 1.2 Requisitos No Funcionales

- **Alta disponibilidad**:  
  El sistema debe seguir funcionando ante fallos puntuales, evitando downtime.

- **Escalabilidad**:  
  La arquitectura debe soportar crecimiento horizontal y distribución de carga.

- **Seguridad**:  
  Control de acceso: solo los administradores pueden validar publicaciones.

- **Testabilidad**:  
  El diseño debe facilitar los tests unitarios, de integración y exploratorios.

- **Rendimiento aceptable**:  
  Tiempo de respuesta inferior a 500 ms en situaciones normales de uso.


---

## 1.3 Casos de Uso

### Caso de uso: Consultar artículo
- **Actor principal**: Usuario anónimo o registrado
- **Descripción**: Consulta artículos y aplica filtros
- **Flujo principal**:
  1. Accede al listado de artículos.
  2. Aplica filtros por tags si lo desea.
  3. Selecciona un artículo y visualiza su contenido.
  4. Si está registrado, puede dejar una valoración del artículo.

---

### Caso de uso: Publicar artículo
- **Actor principal**: Usuario registrado
- **Descripción**: Publica un nuevo artículo para su revisión
- **Flujo principal**:
  1. Redacta y envía el artículo.
  2. El sistema lo marca como “pendiente”.
  3. Un administrador revisa y decide.

---

### Caso de uso: Modificar artículo
- **Actor principal**: Usuario registrado
- **Descripción**: Modifica uno de sus artículos enviados
- **Flujo principal**:
  1. Edita su artículo.
  2. El sistema lo vuelve a marcar como “pendiente”.
  3. Se requiere nueva revisión y aprobación.

---

# 2. Diseño de la aplicación

## 2.1 Diagramas C4

### Diagrama de Contexto
![Diagrama de contexto](Contexto.png)

---

### Diagrama de Contenedor
![Diagrama de contenedores](Contenedor.png)

---

### Diagrama de Componentes
![Diagrama de componentes](Componentes.png)

---

## 2.2 Decisiones de diseño

[Decisión 01](Decisiones/ADR-01.md)

[Decisión 02](Decisiones/ADR-02.md)

[Decisión 03](Decisiones/ADR-03.md)


# 3. Instrucciones

( Instrucciones para compilar, desplegar, utilizar, ejecutar los tests, ... )

# 4. Tests

( Tipos de tests )

( Escenarios cubiertos por las pruebas )

( Escenarios no cubiertos por las pruebas )
