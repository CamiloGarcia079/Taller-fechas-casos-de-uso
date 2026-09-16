# Taller práctico: Consultas de fechas, DateTime e Intervalos a partir de casos de uso

**Estudiante:** Camilo García
**Base de datos:** PostgreSQL

## Contenido del repositorio

```
taller-fechas-casos-uso/
├── README.md
├── Taller_Practico_Casos_Uso_Fechas.md     <- Documento Typora (taller completo)
└── sql/
    ├── 01_schema.sql                        <- Creación de la tabla
    ├── 02_data.sql                          <- Datos de prueba (INSERT)
    ├── 03_queries.sql                       <- Los 35 casos de uso resueltos
    └── taller_fechas_casos_uso.sql          <- Archivo de entrega (todo unido)
```

## Cómo usarlo

### 1. Conéctate a tu base de datos

```bash
psql -U postgres -d postgres
```

(ajusta usuario/base según tu instalación)

### 2. Crea una base de datos para el taller (opcional pero recomendado)

```sql
CREATE DATABASE taller_fechas;
\c taller_fechas
```

### 3. Carga el schema y los datos de prueba

Desde la terminal del sistema (no desde dentro de psql), estando en la carpeta del proyecto:

```bash
psql -U postgres -d taller_fechas -f sql/01_schema.sql
psql -U postgres -d taller_fechas -f sql/02_data.sql
```

Esto crea la tabla `reservas` y la llena con los 6 registros de prueba automáticamente, sin necesidad de copiar y pegar.

### 4. Ejecuta las consultas de los 35 casos de uso

```bash
psql -U postgres -d taller_fechas -f sql/03_queries.sql
```

Esto correrá los 35 casos uno por uno e irá mostrando cada resultado en la terminal, identificado por su comentario `-- Caso de uso N`. Ideal para ir tomando las capturas de pantalla por bloques.

### 5. Archivo de entrega

`sql/taller_fechas_casos_uso.sql` contiene el schema + datos + los 35 casos en un solo archivo, tal como lo pide el taller para entregar al profesor. Se puede correr completo con:

```bash
psql -U postgres -d taller_fechas -f sql/taller_fechas_casos_uso.sql
```

### 6. Documento del taller

`Taller_Practico_Casos_Uso_Fechas.md` es el documento en formato Typora con el enunciado, el objetivo, cada caso de uso explicado, el código correspondiente, y el espacio para pegar las capturas de evidencia al final.
