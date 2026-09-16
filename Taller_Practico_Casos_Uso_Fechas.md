# Taller práctico: Consultas de fechas, DateTime e Intervalos a partir de casos de uso

**Estudiante:** Camilo García
**Fecha:** 15 de septiembre de 2026
**Archivo de entrega:** `taller_fechas_casos_uso.sql`

## Objetivo

Analizar situaciones funcionales y traducirlas a consultas PostgreSQL usando principalmente:

`DATE`, `TIMESTAMP`, `TIMESTAMPTZ`, `INTERVAL`, `CURRENT_DATE`, `CURRENT_TIMESTAMP`, `EXTRACT`, `DATE_TRUNC`, `AGE`, `TO_CHAR` y `AT TIME ZONE`.

## Escenario

Una empresa administra reservas de espacios de trabajo y salas de reunión.

### Crear la tabla

```sql
CREATE TABLE reservas (
    id SERIAL PRIMARY KEY,
    cliente VARCHAR(100) NOT NULL,
    sala VARCHAR(80) NOT NULL,
    fecha_reserva DATE NOT NULL,
    fecha_hora_inicio TIMESTAMPTZ NOT NULL,
    fecha_hora_fin TIMESTAMPTZ NOT NULL,
    fecha_creacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(30) NOT NULL
);
```

### Datos de prueba

```sql
INSERT INTO reservas
(cliente, sala, fecha_reserva, fecha_hora_inicio, fecha_hora_fin, estado)
VALUES
('Ana Torres', 'Sala A', '2026-09-15',
 '2026-09-15 08:00:00-05',
 '2026-09-15 10:00:00-05',
 'CONFIRMADA'),

('Carlos Pérez', 'Sala B', '2026-09-16',
 '2026-09-16 14:30:00-05',
 '2026-09-16 16:00:00-05',
 'CONFIRMADA'),

('Laura Gómez', 'Sala A', '2026-09-20',
 '2026-09-20 09:00:00-05',
 '2026-09-20 12:30:00-05',
 'PENDIENTE'),

('Miguel Rojas', 'Sala C', '2026-09-10',
 '2026-09-10 13:00:00-05',
 '2026-09-10 15:00:00-05',
 'FINALIZADA'),

('Diana Ruiz', 'Sala B', '2026-09-25',
 '2026-09-25 07:30:00-05',
 '2026-09-25 11:00:00-05',
 'CONFIRMADA'),

('Andrés López', 'Sala A', '2026-10-02',
 '2026-10-02 15:00:00-05',
 '2026-10-02 18:30:00-05',
 'PENDIENTE');
```

---

# Parte 1. Consultas básicas de fecha

### Caso de uso 1 — Reservas posteriores al 16 de septiembre de 2026

```sql
-- =====================================================
-- Caso de uso 1
-- Reservas posteriores al 16 de septiembre de 2026
-- =====================================================

-- Se filtra directamente comparando fecha_reserva con la fecha límite
SELECT
    id,
    cliente,
    sala,
    fecha_reserva
FROM reservas
WHERE fecha_reserva > '2026-09-16';
```

### Caso de uso 2 — Reservas entre el 15 y el 25 de septiembre de 2026 (ambas fechas incluidas)

```sql
-- =====================================================
-- Caso de uso 2
-- Reservas entre dos fechas (rango inclusivo)
-- =====================================================

-- BETWEEN incluye ambos límites del rango
SELECT *
FROM reservas
WHERE fecha_reserva BETWEEN '2026-09-15' AND '2026-09-25';
```

### Caso de uso 3 — Reservas del día actual

```sql
-- =====================================================
-- Caso de uso 3
-- Reservas correspondientes al día actual
-- =====================================================

-- Se usa CURRENT_DATE en lugar de escribir la fecha manualmente
SELECT *
FROM reservas
WHERE fecha_reserva = CURRENT_DATE;
```

---

# Parte 2. Fecha y hora

### Caso de uso 4 — Reservas que todavía no han iniciado

```sql
-- =====================================================
-- Caso de uso 4
-- Reservas que aún no han iniciado
-- =====================================================

-- Se compara fecha_hora_inicio contra el instante actual
SELECT *
FROM reservas
WHERE fecha_hora_inicio > CURRENT_TIMESTAMP;
```

### Caso de uso 5 — Reservas que ya finalizaron

```sql
-- =====================================================
-- Caso de uso 5
-- Reservas ya finalizadas
-- =====================================================

-- fecha_hora_fin menor al momento actual indica que ya terminó
SELECT
    cliente,
    sala,
    fecha_hora_inicio,
    fecha_hora_fin
FROM reservas
WHERE fecha_hora_fin < CURRENT_TIMESTAMP;
```

### Caso de uso 6 — Reservas activas en este momento

```sql
-- =====================================================
-- Caso de uso 6
-- Reservas activas actualmente
-- =====================================================

-- Está activa si ya inició y todavía no ha finalizado
SELECT *
FROM reservas
WHERE fecha_hora_inicio <= CURRENT_TIMESTAMP
  AND fecha_hora_fin >= CURRENT_TIMESTAMP;
```

---

# Parte 3. Intervalos

### Caso de uso 7 — Duración de cada reserva

```sql
-- =====================================================
-- Caso de uso 7
-- Duración de cada reserva
-- =====================================================

-- La resta entre dos timestamptz produce un INTERVAL
SELECT
    cliente,
    sala,
    fecha_hora_fin - fecha_hora_inicio AS duracion
FROM reservas;
```

### Caso de uso 8 — Reservas largas (más de 2 horas)

```sql
-- =====================================================
-- Caso de uso 8
-- Reservas con duración mayor a 2 horas
-- =====================================================

SELECT *
FROM reservas
WHERE fecha_hora_fin - fecha_hora_inicio > INTERVAL '2 hours';
```

### Caso de uso 9 — Reservas confirmadas con 30 minutos adicionales (sin modificar la tabla)

```sql
-- =====================================================
-- Caso de uso 9
-- Simulación de 30 minutos extra para reservas confirmadas
-- =====================================================

-- Solo se calcula, no se actualiza la tabla
SELECT
    cliente,
    fecha_hora_fin,
    fecha_hora_fin + INTERVAL '30 minutes' AS nueva_fecha_hora_fin
FROM reservas
WHERE estado = 'CONFIRMADA';
```

### Caso de uso 10 — Fecha límite de cancelación gratuita (24 horas antes)

```sql
-- =====================================================
-- Caso de uso 10
-- Fecha límite de cancelación gratuita
-- =====================================================

SELECT
    cliente,
    fecha_hora_inicio,
    fecha_hora_inicio - INTERVAL '24 hours' AS fecha_limite_cancelacion
FROM reservas;
```

---

# Parte 4. Extracción de componentes

### Caso de uso 11 — Hora de inicio de cada reserva

```sql
-- =====================================================
-- Caso de uso 11
-- Hora del día en que inicia cada reserva
-- =====================================================

SELECT
    cliente,
    EXTRACT(HOUR FROM fecha_hora_inicio) AS hora_inicio
FROM reservas;
```

### Caso de uso 12 — Año, mes, día y hora de cada reserva

```sql
-- =====================================================
-- Caso de uso 12
-- Componentes año, mes, día, hora de fecha_hora_inicio
-- =====================================================

SELECT
    cliente,
    EXTRACT(YEAR FROM fecha_hora_inicio) AS anio,
    EXTRACT(MONTH FROM fecha_hora_inicio) AS mes,
    EXTRACT(DAY FROM fecha_hora_inicio) AS dia,
    EXTRACT(HOUR FROM fecha_hora_inicio) AS hora
FROM reservas;
```

### Caso de uso 13 — Cantidad de reservas por mes

```sql
-- =====================================================
-- Caso de uso 13
-- Cantidad de reservas agrupadas por año y mes
-- =====================================================

SELECT
    EXTRACT(YEAR FROM fecha_reserva) AS anio,
    EXTRACT(MONTH FROM fecha_reserva) AS mes,
    COUNT(*) AS cantidad_reservas
FROM reservas
GROUP BY
    EXTRACT(YEAR FROM fecha_reserva),
    EXTRACT(MONTH FROM fecha_reserva)
ORDER BY anio, mes;
```

---

# Parte 5. Consultas por períodos

### Caso de uso 14 — Reservas del mes actual

```sql
-- =====================================================
-- Caso de uso 14
-- Reservas pertenecientes al mes actual (dinámico)
-- =====================================================

SELECT *
FROM reservas
WHERE DATE_TRUNC('month', fecha_reserva) = DATE_TRUNC('month', CURRENT_DATE);
```

### Caso de uso 15 — Reservas creadas durante el año actual

```sql
-- =====================================================
-- Caso de uso 15
-- Reservas creadas en el año actual
-- =====================================================

SELECT *
FROM reservas
WHERE DATE_TRUNC('year', fecha_creacion) = DATE_TRUNC('year', CURRENT_DATE);
```

### Caso de uso 16 — Reservas de la semana actual

```sql
-- =====================================================
-- Caso de uso 16
-- Reservas correspondientes a la semana actual
-- =====================================================

-- DATE_TRUNC('week', ...) lleva la fecha al lunes de esa semana
SELECT *
FROM reservas
WHERE DATE_TRUNC('week', fecha_reserva) = DATE_TRUNC('week', CURRENT_DATE);
```

---

# Parte 6. Formato de fechas

### Caso de uso 17 — Formato DD/MM/YYYY HH24:MI

```sql
-- =====================================================
-- Caso de uso 17
-- Fecha y hora de inicio formateada para reporte
-- =====================================================

SELECT
    cliente,
    TO_CHAR(fecha_hora_inicio, 'DD/MM/YYYY HH24:MI') AS fecha_hora_formateada
FROM reservas;
```

### Caso de uso 18 — Reporte combinado "Cliente | Sala | Fecha"

```sql
-- =====================================================
-- Caso de uso 18
-- Reporte combinando columnas con fecha formateada
-- =====================================================

SELECT
    cliente || ' | ' || sala || ' | ' ||
    TO_CHAR(fecha_hora_inicio, 'DD/MM/YYYY HH24:MI') AS reporte
FROM reservas;
```

---

# Parte 7. Zonas horarias

### Caso de uso 19 — Hora en Colombia y en Madrid

```sql
-- =====================================================
-- Caso de uso 19
-- Conversión de hora entre Colombia y España
-- =====================================================

SELECT
    cliente,
    fecha_hora_inicio AT TIME ZONE 'America/Bogota' AS hora_colombia,
    fecha_hora_inicio AT TIME ZONE 'Europe/Madrid' AS hora_madrid
FROM reservas;
```

### Caso de uso 20 — Fechas de inicio en UTC

```sql
-- =====================================================
-- Caso de uso 20
-- fecha_hora_inicio expresada en UTC
-- =====================================================

SELECT
    cliente,
    fecha_hora_inicio AT TIME ZONE 'UTC' AS fecha_hora_inicio_utc
FROM reservas;
```

---

# Parte 8. Cálculos con fechas

### Caso de uso 21 — Días faltantes para cada reserva

```sql
-- =====================================================
-- Caso de uso 21
-- Días que faltan para cada reserva (puede ser negativo)
-- =====================================================

SELECT
    cliente,
    fecha_reserva,
    fecha_reserva - CURRENT_DATE AS dias_faltantes
FROM reservas;
```

### Caso de uso 22 — Reservas creadas con al menos 5 días de anticipación

```sql
-- =====================================================
-- Caso de uso 22
-- Reservas creadas con 5 o más días de anticipación
-- =====================================================

-- Se convierte fecha_creacion a DATE para compararla con fecha_reserva
SELECT *
FROM reservas
WHERE fecha_reserva - fecha_creacion::date >= 5;
```

### Caso de uso 23 — Reservas de último minuto (menos de 24 horas de anticipación)

```sql
-- =====================================================
-- Caso de uso 23
-- Reservas de último minuto (< 24 horas de anticipación)
-- =====================================================

SELECT *
FROM reservas
WHERE fecha_hora_inicio - fecha_creacion < INTERVAL '24 hours';
```

---

# Parte 9. AGE

### Caso de uso 24 — Tiempo de anticipación entre creación e inicio

```sql
-- =====================================================
-- Caso de uso 24
-- Tiempo transcurrido entre la creación y el inicio de la reserva
-- =====================================================

SELECT
    cliente,
    AGE(fecha_hora_inicio, fecha_creacion) AS tiempo_anticipacion
FROM reservas;
```

---

# Parte 10. Consultas combinadas

### Caso de uso 25 — Confirmadas, más de 2 horas y posteriores a hoy

```sql
-- =====================================================
-- Caso de uso 25
-- Reservas confirmadas, mayores a 2 horas y futuras
-- =====================================================

SELECT *
FROM reservas
WHERE estado = 'CONFIRMADA'
  AND fecha_hora_fin - fecha_hora_inicio > INTERVAL '2 hours'
  AND fecha_reserva > CURRENT_DATE;
```

### Caso de uso 26 — Reservas futuras de la Sala A ordenadas

```sql
-- =====================================================
-- Caso de uso 26
-- Reservas futuras de Sala A, de la más próxima a la más lejana
-- =====================================================

SELECT *
FROM reservas
WHERE sala = 'Sala A'
  AND fecha_hora_inicio > CURRENT_TIMESTAMP
ORDER BY fecha_hora_inicio ASC;
```

### Caso de uso 27 — Reserva futura más cercana

```sql
-- =====================================================
-- Caso de uso 27
-- Reserva futura más próxima (un solo registro)
-- =====================================================

SELECT *
FROM reservas
WHERE fecha_hora_inicio > CURRENT_TIMESTAMP
ORDER BY fecha_hora_inicio ASC
LIMIT 1;
```

### Caso de uso 28 — Reserva futura más lejana

```sql
-- =====================================================
-- Caso de uso 28
-- Reserva futura más lejana
-- =====================================================

SELECT *
FROM reservas
WHERE fecha_hora_inicio > CURRENT_TIMESTAMP
ORDER BY fecha_hora_inicio DESC
LIMIT 1;
```

---

# Parte 11. Agregaciones

### Caso de uso 29 — Duración promedio de las reservas

```sql
-- =====================================================
-- Caso de uso 29
-- Duración promedio de todas las reservas
-- =====================================================

SELECT AVG(fecha_hora_fin - fecha_hora_inicio) AS duracion_promedio
FROM reservas;
```

### Caso de uso 30 — Duración total de todas las reservas

```sql
-- =====================================================
-- Caso de uso 30
-- Suma de la duración de todas las reservas
-- =====================================================

SELECT SUM(fecha_hora_fin - fecha_hora_inicio) AS duracion_total
FROM reservas;
```

### Caso de uso 31 — Cantidad de reservas por día

```sql
-- =====================================================
-- Caso de uso 31
-- Cantidad de reservas agrupadas por fecha
-- =====================================================

SELECT
    fecha_reserva AS fecha,
    COUNT(*) AS cantidad_reservas
FROM reservas
GROUP BY fecha_reserva
ORDER BY fecha_reserva;
```

### Caso de uso 32 — Cantidad de reservas por sala en septiembre de 2026

```sql
-- =====================================================
-- Caso de uso 32
-- Cantidad de reservas por sala durante septiembre 2026
-- =====================================================

SELECT
    sala,
    COUNT(*) AS cantidad_reservas
FROM reservas
WHERE fecha_reserva >= '2026-09-01'
  AND fecha_reserva < '2026-10-01'
GROUP BY sala
ORDER BY sala;
```

---

# Parte 12. Reto de actualización

### Caso de uso 33 — Reservas futuras de Sala A comienzan una hora más tarde

```sql
-- =====================================================
-- Caso de uso 33
-- SELECT previo: reservas futuras de Sala A a modificar
-- =====================================================

SELECT *
FROM reservas
WHERE sala = 'Sala A'
  AND fecha_hora_inicio > CURRENT_TIMESTAMP;

-- =====================================================
-- Caso de uso 33
-- UPDATE: se retrasa una hora el inicio de esas reservas
-- =====================================================

UPDATE reservas
SET fecha_hora_inicio = fecha_hora_inicio + INTERVAL '1 hour'
WHERE sala = 'Sala A'
  AND fecha_hora_inicio > CURRENT_TIMESTAMP;
```

### Caso de uso 34 — Reservas pendientes extienden 30 minutos su fin

```sql
-- =====================================================
-- Caso de uso 34
-- SELECT previo: reservas pendientes a modificar
-- =====================================================

SELECT *
FROM reservas
WHERE estado = 'PENDIENTE';

-- =====================================================
-- Caso de uso 34
-- UPDATE: se extiende 30 minutos la hora de fin
-- =====================================================

UPDATE reservas
SET fecha_hora_fin = fecha_hora_fin + INTERVAL '30 minutes'
WHERE estado = 'PENDIENTE';
```

### Caso de uso 35 — Marcar como FINALIZADA las reservas ya terminadas

```sql
-- =====================================================
-- Caso de uso 35
-- SELECT previo: reservas cuya fecha_hora_fin ya pasó
-- =====================================================

SELECT *
FROM reservas
WHERE fecha_hora_fin < CURRENT_TIMESTAMP
  AND estado <> 'FINALIZADA';

-- =====================================================
-- Caso de uso 35
-- UPDATE: se marcan como FINALIZADA
-- =====================================================

UPDATE reservas
SET estado = 'FINALIZADA'
WHERE fecha_hora_fin < CURRENT_TIMESTAMP
  AND estado <> 'FINALIZADA';
```

---

# Parte 13. Reto integrador

### Reservas prioritarias: confirmadas, más de 3 horas, inician dentro de los próximos 15 días

```sql
-- =====================================================
-- Reto integrador
-- Reservas prioritarias: CONFIRMADA + duración > 3h
-- + inician en los próximos 15 días
-- =====================================================

SELECT
    id,
    cliente,
    sala,
    fecha_hora_inicio,
    fecha_hora_fin,
    fecha_hora_fin - fecha_hora_inicio AS duracion
FROM reservas
WHERE estado = 'CONFIRMADA'
  AND fecha_hora_fin - fecha_hora_inicio > INTERVAL '3 hours'
  AND fecha_hora_inicio BETWEEN CURRENT_TIMESTAMP
                             AND CURRENT_TIMESTAMP + INTERVAL '15 days';
```

---

# Parte 14. Caso de uso avanzado

### Reporte gerencial completo

```sql
-- =====================================================
-- Caso de uso avanzado
-- Reporte gerencial: fecha formateada, hora, duración,
-- días para la reserva y estado
-- =====================================================

SELECT
    cliente,
    sala,
    TO_CHAR(fecha_hora_inicio, 'DD/MM/YYYY') AS fecha_formateada,
    TO_CHAR(fecha_hora_inicio, 'HH24:MI') AS hora_inicio,
    fecha_hora_fin - fecha_hora_inicio AS duracion,
    fecha_reserva - CURRENT_DATE AS dias_para_reserva,
    estado
FROM reservas
ORDER BY fecha_hora_inicio ASC;
```

---

# Reglas del taller

- No se modifican los datos iniciales salvo en los casos que explícitamente piden `UPDATE` (33, 34 y 35).
- Antes de cada `UPDATE` se ejecuta primero el `SELECT` equivalente para verificar los registros afectados.
- No se escribe la fecha actual manualmente cuando el caso pide información relativa al momento de ejecución (se usan `CURRENT_DATE`, `CURRENT_TIMESTAMP`, `DATE_TRUNC`, etc.).

---

# Entrega

Archivo a entregar: `taller_fechas_casos_uso.sql`, con cada solución precedida de un bloque de comentario que identifica el caso de uso y explica brevemente la lógica utilizada, siguiendo la estructura:

```sql
-- =====================================================
-- Caso de uso 1
-- Reservas posteriores al 16 de septiembre de 2026
-- =====================================================

SELECT ...;
```

## Criterios de evaluación

| Criterio                                 | Peso |
| ----------------------------------------- | ---- |
| Interpretación correcta del caso de uso  | 25%  |
| Uso adecuado de tipos de fecha/hora      | 20%  |
| Uso correcto de funciones e intervalos   | 20%  |
| Construcción correcta de condiciones     | 15%  |
| Calidad y legibilidad de SQL             | 10%  |
| Comentarios y explicación de la solución | 10%  |

---

## Evidencia — Captura de resultados

*(Agregar aquí las capturas de pantalla de la ejecución en psql/pgAdmin de la creación de la tabla `reservas`, la inserción de datos, y la salida de los 35 casos de uso resueltos.)*
