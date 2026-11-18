/*================================== TABLAS ==================================*/

----------------------------------- NIVEL 0 -----------------------------------

-- Tiempo (anual, trimestral, mensual)
CREATE TABLE JOIN_THE_FORCE.BI_tiempo(
    id_tiempo       INT IDENTITY(1,1) PRIMARY KEY,
    anio            INT,
    trimestre       INT,
    mes             INT
);

-- Local
CREATE TABLE JOIN_THE_FORCE.BI_local(
    id_local            INT IDENTITY (1,1) PRIMARY KEY,
    nro_local           INT,
    nombre              VARCHAR(255),
    localidad           VARCHAR(255),
    provincia           VARCHAR(255)
);

-- Rango Etario
CREATE TABLE JOIN_THE_FORCE.BI_rango_etario(
    id_rango_etario     INT IDENTITY (1,1) PRIMARY KEY,
    descripcion         VARCHAR(255),
    edad_min            INT,
    edad_max            INT
);

-- Tipo de Producto
CREATE TABLE JOIN_THE_FORCE.BI_tipo_producto(
    tipo_producto		VARCHAR(255) PRIMARY KEY CHECK (tipo_producto IN ('Bicicleta', 'Accesorio'))
);

-- Tipo de Ingreso de Reparación
CREATE TABLE JOIN_THE_FORCE.BI_tipo_ingreso_reparacion(
    tipo_ingreso_reparacion		VARCHAR(255) PRIMARY KEY CHECK (tipo_ingreso_reparacion IN ('Mano de Obra', 'Repuestos'))
);

-- Categoría de Repuesto
CREATE TABLE JOIN_THE_FORCE.BI_categoria_repuesto(
    categoria_repuesto      VARCHAR(255) PRIMARY KEY
);

-- Categoría de Bicicleta
CREATE TABLE JOIN_THE_FORCE.BI_categoria_bicicleta(
    categoria_bici     VARCHAR(255) PRIMARY KEY
);

----------------------------------- NIVEL 1 -----------------------------------

-- Hechos de Ventas
CREATE TABLE JOIN_THE_FORCE.BI_hecho_venta(
    id_rango_etario         INT,
    tipo_producto           VARCHAR(255),
    id_tiempo               INT,
    id_local                INT,
    subtotal                NUMERIC(38,2),
    cant_ventas             INT,

    CONSTRAINT PK_hecho_venta
        PRIMARY KEY(id_rango_etario, tipo_producto, id_tiempo, id_local),

    CONSTRAINT FK_hecho_venta_rango_etario
        FOREIGN KEY(id_rango_etario)
        REFERENCES JOIN_THE_FORCE.BI_rango_etario(id_rango_etario),

    CONSTRAINT FK_hecho_venta_tipo_producto
        FOREIGN KEY(tipo_producto)
        REFERENCES JOIN_THE_FORCE.BI_tipo_producto(tipo_producto),

    CONSTRAINT FK_hecho_venta_id_tiempo
        FOREIGN KEY(id_tiempo)
        REFERENCES JOIN_THE_FORCE.BI_tiempo(id_tiempo),

    CONSTRAINT FK_hecho_venta_id_local
        FOREIGN KEY(id_local)
        REFERENCES JOIN_THE_FORCE.BI_local(id_local)
);

-- Hechos de Alquileres
CREATE TABLE JOIN_THE_FORCE.BI_hecho_alquiler(
    id_tiempo               INT,
    id_local                INT,
    categoria_bici          VARCHAR(255),
    importe_total           NUMERIC(38,2),
    cant_horas              NUMERIC(38,2), -- NUMERIC(38,2) porque 1 hora y 40 minutos son 1,67 horas, con INT redondea para arriba o para abajo
    cant_alquileres         INT,

    CONSTRAINT PK_hecho_alquiler
        PRIMARY KEY(id_tiempo, id_local, categoria_bici),

    CONSTRAINT FK_hecho_alquiler_id_tiempo
        FOREIGN KEY(id_tiempo)
        REFERENCES JOIN_THE_FORCE.BI_tiempo(id_tiempo),

    CONSTRAINT FK_hecho_alquiler_id_local
        FOREIGN KEY(id_local)
        REFERENCES JOIN_THE_FORCE.BI_local(id_local),

    CONSTRAINT FK_hecho_alquiler_categoria_bici
        FOREIGN KEY(categoria_bici)
        REFERENCES JOIN_THE_FORCE.BI_categoria_bicicleta(categoria_bici)
);

-- Hechos de Reparacion
CREATE TABLE JOIN_THE_FORCE.BI_hecho_reparacion(
    id_tiempo                       INT,
    id_local                        INT,
    categoria_repuesto              VARCHAR(255),
    tipo_ingreso_reparacion         VARCHAR(255),
    subtotal                        NUMERIC(38,2),
    cant_horas                      NUMERIC(38,2),
    
    CONSTRAINT PK_hecho_reparacion
        PRIMARY KEY(id_tiempo, id_local, categoria_repuesto, tipo_ingreso_reparacion),

    CONSTRAINT FK_hecho_reparacion_categoria_repuesto
        FOREIGN KEY(categoria_repuesto)
        REFERENCES JOIN_THE_FORCE.BI_categoria_repuesto(categoria_repuesto),

    CONSTRAINT FK_hecho_reparacion_id_tiempo
        FOREIGN KEY(id_tiempo)
        REFERENCES JOIN_THE_FORCE.BI_tiempo(id_tiempo),

    CONSTRAINT FK_hecho_reparacion_id_local
        FOREIGN KEY(id_local)
        REFERENCES JOIN_THE_FORCE.BI_local(id_local),

    CONSTRAINT FK_hecho_reparacion_tipo_ingreso_reparacion
        FOREIGN KEY(tipo_ingreso_reparacion)
        REFERENCES JOIN_THE_FORCE.BI_tipo_ingreso_reparacion(tipo_ingreso_reparacion)
);

-- Hechos de Compras
CREATE TABLE JOIN_THE_FORCE.BI_hecho_compra(
    id_tiempo                        INT,
    id_local                         INT,
    tipo_producto                    VARCHAR(255),
    cantidad                         INT,
    precio_unidad                    NUMERIC(38,2),
    cant_compras                     INT,


    CONSTRAINT PK_BI_hecho_compra
    PRIMARY KEY (id_tiempo,id_local,tipo_producto),

    CONSTRAINT FK_BI_hecho_compra_id_tiempo
    FOREIGN KEY (id_tiempo)
    REFERENCES JOIN_THE_FORCE.BI_tiempo(id_tiempo),

    CONSTRAINT FK_BI_hecho_compra_id_local
    FOREIGN KEY (id_local)
    REFERENCES JOIN_THE_FORCE.BI_local(id_local),

    CONSTRAINT FK_BI_hecho_compra_tipo_producto
    FOREIGN KEY (tipo_producto)
    REFERENCES JOIN_THE_FORCE.BI_tipo_producto(tipo_producto)
     
);

/*================================== STORED PROCEDURES PARA LA MIGRACIÓN ==================================*/

-------------------------------------------------- NIVEL 0 --------------------------------------------------

-- BI_tiempo
GO
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_tiempo
AS
BEGIN
INSERT INTO JOIN_THE_FORCE.BI_tiempo(anio, trimestre, mes)
    SELECT DISTINCT YEAR(v.fecha_hora), DATEPART(QUARTER, v.fecha_hora), MONTH(v.fecha_hora)
    FROM JOIN_THE_FORCE.venta v
    
INSERT INTO JOIN_THE_FORCE.BI_tiempo(anio, trimestre, mes)
    SELECT DISTINCT YEAR(a.fecha_hora_inicio), DATEPART(QUARTER, a.fecha_hora_inicio), MONTH(a.fecha_hora_inicio)
    FROM JOIN_THE_FORCE.alquiler a

INSERT INTO JOIN_THE_FORCE.BI_tiempo(anio, trimestre, mes)
    SELECT DISTINCT YEAR(c.fecha_compra), DATEPART(QUARTER, c.fecha_compra), MONTH(c.fecha_compra)
    FROM JOIN_THE_FORCE.compra c

INSERT INTO JOIN_THE_FORCE.BI_tiempo(anio, trimestre, mes)
    SELECT DISTINCT YEAR(r.fecha_ingreso), DATEPART(QUARTER, r.fecha_ingreso), MONTH(r.fecha_ingreso)
    FROM JOIN_THE_FORCE.reparacion r 

END;
GO

-- BI_local
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_local
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_local(nro_local, nombre, localidad, provincia)       
    SELECT l.nro_local, l.nombre, ld.localidad, ld.provincia
    FROM JOIN_THE_FORCE.local l 
    JOIN JOIN_THE_FORCE.localidad ld
        ON l.nro_localidad = ld.nro_localidad
END;
GO

-- BI_rango_etario
GO
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_rango_etario
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_rango_etario(descripcion, edad_min, edad_max)
    VALUES ('Menores de 25 años inclusive', 0, 25);

    INSERT INTO JOIN_THE_FORCE.BI_rango_etario(descripcion, edad_min, edad_max)
    VALUES ('Entre 25 y 35 años inclusive', 26, 35);

    INSERT INTO JOIN_THE_FORCE.BI_rango_etario(descripcion, edad_min, edad_max)
    VALUES ('Entre 35 y 50 años inclusive', 36, 50);

    -- Revisar si el valor de edad_max deberia ser NULL o un numero arbitrariamente grande como 200
    INSERT INTO JOIN_THE_FORCE.BI_rango_etario(descripcion, edad_min, edad_max)
    VALUES ('Mayores de 50 años', 51, 1000);
END;
GO

-- BI_tipo_producto

CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_tipo_producto
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_tipo_producto(tipo_producto)
    VALUES ('Bicicleta');
    INSERT INTO JOIN_THE_FORCE.BI_tipo_producto(tipo_producto)
    VALUES ('Accesorio');
END;
GO

-- BI_tipo_ingreso_reparación
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_tipo_ingreso_reparacion
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_tipo_ingreso_reparacion(tipo_ingreso_reparacion)
    VALUES ('Mano de Obra');
    INSERT INTO JOIN_THE_FORCE.BI_tipo_ingreso_reparacion(tipo_ingreso_reparacion)
    VALUES ('Repuestos');
END;
GO

-- BI_categoria_repuesto
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_categoria_repuesto
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_categoria_repuesto(categoria_repuesto)
    SELECT categoria_repuesto
    FROM JOIN_THE_FORCE.categoria_repuesto
END;
GO

-- BI_categoria_bicicleta
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_categoria_bicicleta
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_categoria_bicicleta(categoria_bicicleta)
    SELECT categoria_bicicleta
    FROM JOIN_THE_FORCE.categoria_bicicleta
END;
GO

EXECUTE JOIN_THE_FORCE.crear_BI_tiempo;
EXECUTE JOIN_THE_FORCE.crear_BI_local;
EXECUTE JOIN_THE_FORCE.crear_BI_rango_etario;
EXECUTE JOIN_THE_FORCE.crear_BI_tipo_producto;
EXECUTE JOIN_THE_FORCE.crear_BI_tipo_ingreso_reparacion;
EXECUTE JOIN_THE_FORCE.crear_BI_categoria_repuesto;
EXECUTE JOIN_THE_FORCE.crear_BI_categoria_bicicleta;


-------------------------------------------------- NIVEL 1 --------------------------------------------------
-- BI_hecho_venta

CREATE PROCEDURE
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_hecho_venta(id_rango_etario, tipo_producto, id_tiempo, id_local, subtotal)
    SELECT (SELECT id_rango_etario FROM JOIN_THE_FORCE.BI_rango_etario re 
        WHERE DATEDIFF(YEAR, c.fecha_nacimiento, v.fecha_hora) BETWEEN re.edad_min AND re.edad_max)
    FROM JOIN_THE_FORCE.venta v 
        JOIN JOIN_THE_FORCE.cliente c ON (v.nro_cliente = c.nro_cliente)
END;
GO



/*============================================= VIEWS =============================================*/
/*
CREATE VIEW JOIN_THE_FORCE.V_fact_vent_mens_x_local
    (mes, local, facturacion_total)
    AS
    SELECT t.mes, l.nro_local, SUM(hv.subtotal)
    FROM JOIN_THE_FORCE.BI_hecho_venta hv 
        JOIN JOIN_THE_FORCE.BI_tiempo t ON (hv.id_tiempo = t.id_tiempo)
        JOIN JOIN_THE_FORCE.BI_local l ON (hv.id_local = l.id_local)
*/
