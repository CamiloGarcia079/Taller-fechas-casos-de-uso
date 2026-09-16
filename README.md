# Paquete de Entrega — Taller PostgreSQL: Consultas de fechas, DateTime e Intervalos a partir de casos de uso

**Estudiante:** Camilo García

---

## Estructura del proyecto

```text
taller-fechas-casos-uso/
├── README.md                          # Esta guía
├── docs/
│   └── TALLER_POSTGRESQL_COMPLETO.md  # Documento Typora: enunciado, casos de uso y evidencia
├── sql/
│   ├── 01_schema.sql                  # Solo el CREATE TABLE
│   ├── 02_data.sql                    # Solo los INSERT de datos de prueba
│   ├── 01_schema_and_data.sql         # Schema + datos combinados
│   ├── 02_consultas_taller.sql        # Los 35 casos de uso resueltos
│   └── taller_fechas_casos_uso.sql    # Script completo consolidado (archivo de entrega)
├── docker/
│   ├── docker-compose.yml             # Servicios PostgreSQL 16 + pgAdmin 4
│   ├── .env                           # Variables de conexión
│   └── init/
│       └── 01_schema_and_data.sql     # Se ejecuta automáticamente al levantar el contenedor
└── img/                                # Aquí van tus capturas de pantalla (1.png ... 35.png, etc.)
```

---

## Dónde van tus capturas

Guarda cada captura en la carpeta `img/` con este naming (igual al de los comentarios `-- Caso de uso N` dentro del SQL), para que sea fácil identificarlas:

- `1.png` a `32.png` → casos de consulta 1 al 32
- `33v1.png` y `33v2.png` → caso 33 (SELECT previo y UPDATE ejecutado)
- `34.png` y `35.png` → casos 34 y 35 (UPDATE)
- `retoIntegrador.png` → reto integrador
- `consultaAvanzada.png` → caso de uso avanzado (reporte gerencial)

Luego, dentro de `docs/TALLER_POSTGRESQL_COMPLETO.md`, en la sección "Evidencia" al final, enlaza cada imagen así (en Typora puedes simplemente arrastrarlas):

```markdown
![Caso 1](../img/1.png)
```

---

## Cómo ejecutar — Opción A: PostgreSQL instalado en Windows (sin Docker)

```powershell
psql -U postgres
```

Dentro de psql:

```sql
CREATE DATABASE taller_fechas;
\c taller_fechas
```

Sal con `\q` y, desde la terminal (parado en la carpeta del proyecto), carga schema + datos:

```powershell
psql -U postgres -d taller_fechas -f sql/01_schema_and_data.sql
```

Corre las 35 consultas:

```powershell
psql -U postgres -d taller_fechas -f sql/02_consultas_taller.sql
```

---

## Cómo ejecutar — Opción B: con Docker (si tienes virtualización activada)

```bash
cd docker
docker compose up -d
```

Conéctate al contenedor:

```bash
docker exec -it postgres_db_entrega psql -U postgres -d taller_fechas
```

El schema y los datos se cargan automáticamente al levantar el contenedor (desde `docker/init/`).

---

## Archivo de entrega

`sql/taller_fechas_casos_uso.sql` contiene todo unido (schema + datos + los 35 casos), tal como lo pide el taller para que el profesor lo copie y pegue directamente.
