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
