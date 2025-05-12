# Crear usuario y base de datos en PostgreSQL para el sistema

## Contexto y Declaración del Problema

Se requiere crear un usuario y una base de datos en PostgreSQL para poder gestionar el almacenamiento persistente de datos en el sistema de gestión de usuarios y artículos. Esto incluye la creación de un usuario de base de datos con privilegios adecuados y la configuración de la base de datos.

## Opciones Consideradas

* **Opción 1**: Crear un usuario con privilegios básicos y una base de datos independiente.
* **Opción 2**: Crear un usuario con privilegios de superusuario y usar una base de datos común.
* **Opción 3**: Crear un usuario con privilegios elevados para facilitar el mantenimiento y gestión de la base de datos.

## Decisión Tomada

Opción elegida: **"Opción 2: Crear un usuario con privilegios de superusuario y usar una base de datos común."**, porque facilita la gestión de la base de datos y permite ejecutar todas las operaciones necesarias para el desarrollo y mantenimiento del sistema sin restricciones adicionales.

### Consecuencias

* **Positiva**: El usuario tiene acceso total para crear y administrar las tablas y otros objetos necesarios dentro de la base de datos.
* **Positiva**: Al ser un superusuario, se facilita la administración de la base de datos sin necesidad de modificar permisos en cada operación.
* **Negativa**: Puede ser un riesgo de seguridad si no se controla adecuadamente el acceso a este usuario.

---

## Pasos de Implementación

1. **Crear un usuario y base de datos en PostgreSQL**

```bash
# Iniciar sesión como el superusuario de PostgreSQL
sudo -u postgres psql

# Crear el usuario con contraseña
CREATE USER asuser WITH PASSWORD 'as';

# Asignar privilegios de superusuario
ALTER USER asuser WITH SUPERUSER;

# Crear la base de datos
CREATE DATABASE asuser;
```

2. **Arrancar la base de datos y tablas**

```bash
# Crear la base de datos según la configuración de Ecto
mix ecto.create

# Realizar las migraciones
mix ecto.migrate
```