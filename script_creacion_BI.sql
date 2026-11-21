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
    categoria_bicicleta      VARCHAR(255) PRIMARY KEY
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

-- Hechos de Aquileres
CREATE TABLE JOIN_THE_FORCE.BI_hecho_alquiler(
    id_tiempo               INT,
    id_local                INT,
    categoria_bicicleta     VARCHAR(255),
    importe_total           NUMERIC(38,2),
    cant_horas              NUMERIC(38,2),
    cant_alquileres         INT,

    CONSTRAINT PK_hecho_alquiler
        PRIMARY KEY(id_tiempo, id_local, categoria_bicicleta),

    CONSTRAINT FK_hecho_alquiler_id_tiempo
        FOREIGN KEY(id_tiempo)
        REFERENCES JOIN_THE_FORCE.BI_tiempo(id_tiempo),

    CONSTRAINT FK_hecho_alquiler_id_local
        FOREIGN KEY(id_local)
        REFERENCES JOIN_THE_FORCE.BI_local(id_local),

    CONSTRAINT FK_hecho_alquiler_categoria_bici
        FOREIGN KEY(categoria_bicicleta)
        REFERENCES JOIN_THE_FORCE.BI_categoria_bicicleta(categoria_bicicleta)
);

-- Hechos de Reparaciones
CREATE TABLE JOIN_THE_FORCE.BI_hecho_reparacion(
    id_tiempo                       INT,
    id_local                        INT,
    cant_horas                      NUMERIC(38,2),
    
    CONSTRAINT PK_hecho_reparacion
        PRIMARY KEY(id_tiempo, id_local),

    CONSTRAINT FK_hecho_reparacion_id_tiempo
        FOREIGN KEY(id_tiempo)
        REFERENCES JOIN_THE_FORCE.BI_tiempo(id_tiempo),

    CONSTRAINT FK_hecho_reparacion_id_local
        FOREIGN KEY(id_local)
        REFERENCES JOIN_THE_FORCE.BI_local(id_local)
);

-- Hechos de Compras
CREATE TABLE JOIN_THE_FORCE.BI_hecho_compra(
    id_tiempo                        INT,
    id_local                         INT,
    tipo_producto                    VARCHAR(255),
    cantidad                         INT,
    precio_unidad                    NUMERIC(38,2),

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

-- Hechos de Repuestos Usados
CREATE TABLE JOIN_THE_FORCE.BI_hecho_repuestos_usados(
    id_tiempo               INT,
    categoria_repuesto      VARCHAR(255),
    cantidad                INT,

    CONSTRAINT PK_BI_hecho_repuesto_usado
        PRIMARY KEY (id_tiempo, categoria_repuesto),

    CONSTRAINT FK_BI_hecho_repuesto_usado_id_tiempo
        FOREIGN KEY (id_tiempo)
        REFERENCES JOIN_THE_FORCE.BI_tiempo(id_tiempo),

    CONSTRAINT FK_BI_hecho_repuesto_usado_categoria_repuesto
        FOREIGN KEY (categoria_repuesto)
        REFERENCES JOIN_THE_FORCE.BI_categoria_repuesto(categoria_repuesto)
);  

-- Hechos de Ingresos de Reparación
CREATE TABLE JOIN_THE_FORCE.BI_hecho_ingreso_reparacion(
    id_tiempo                   INT,
    id_local                    INT,
    tipo_ingreso_reparacion     VARCHAR(255),
    subtotal                    NUMERIC(38,2),

    CONSTRAINT PK_BI_hecho_ingreso_reparacion
        PRIMARY KEY (id_tiempo, id_local, tipo_ingreso_reparacion),

    CONSTRAINT FK_BI_hecho_ingreso_reparacion_id_tiempo
        FOREIGN KEY (id_tiempo)
        REFERENCES JOIN_THE_FORCE.BI_tiempo(id_tiempo),

    CONSTRAINT FK_BI_hecho_ingreso_reparacion_id_local
        FOREIGN KEY (id_local)
        REFERENCES JOIN_THE_FORCE.BI_local(id_local),

    CONSTRAINT FK_BI_hecho_ingreso_reparacion_tipo_ingreso_reparacion
        FOREIGN KEY (tipo_ingreso_reparacion)
        REFERENCES JOIN_THE_FORCE.BI_tipo_ingreso_reparacion(tipo_ingreso_reparacion)

);

/*================================== STORED PROCEDURES PARA LA MIGRACIÓN ==================================*/

-------------------------------------------------- NIVEL 0 --------------------------------------------------

-- BI_tiempo
GO
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_tiempo
AS
BEGIN
INSERT INTO JOIN_THE_FORCE.BI_tiempo(anio, trimestre, mes)
    (SELECT DISTINCT YEAR(v.fecha_hora), DATEPART(QUARTER, v.fecha_hora), MONTH(v.fecha_hora)
    FROM JOIN_THE_FORCE.venta v) 
    UNION 
    (SELECT DISTINCT YEAR(a.fecha_hora_inicio), DATEPART(QUARTER, a.fecha_hora_inicio), MONTH(a.fecha_hora_inicio)
    FROM JOIN_THE_FORCE.alquiler a)
    UNION
    (SELECT DISTINCT YEAR(c.fecha_compra), DATEPART(QUARTER, c.fecha_compra), MONTH(c.fecha_compra)
    FROM JOIN_THE_FORCE.compra c)
    UNION
    (SELECT DISTINCT YEAR(r.fecha_ingreso), DATEPART(QUARTER, r.fecha_ingreso), MONTH(r.fecha_ingreso)
    FROM JOIN_THE_FORCE.reparacion r )

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
    SELECT categoria_bici
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
GO
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_hecho_venta
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_hecho_venta
        (id_rango_etario, tipo_producto, id_tiempo, id_local, subtotal, cant_ventas)
    SELECT 
        ventaConEdad.id_rango_etario,
        ventaConEdad.tipo_producto,
        bi_t.id_tiempo,
        bi_l.id_local,
        SUM(ventaConEdad.subtotal_producto),
        COUNT(DISTINCT ventaConEdad.nro_venta)
        
    FROM (
        -- Subconsulta para obtener las ventas con la edad del cliente
        SELECT ventaSinEdad.nro_venta,
               ventaSinEdad.fecha_hora,
               ventaSinEdad.nro_local,
               ventaSinEdad.subtotal_producto,
               ventaSinEdad.tipo_producto,
               (SELECT bi_re.id_rango_etario
                FROM JOIN_THE_FORCE.BI_rango_etario bi_re
                WHERE (DATEDIFF(YEAR, ventaSinEdad.fecha_nacimiento, ventaSinEdad.fecha_hora)
                       - CASE WHEN DATEADD(YEAR,
                                           DATEDIFF(YEAR, ventaSinEdad.fecha_nacimiento, ventaSinEdad.fecha_hora),
                                           ventaSinEdad.fecha_nacimiento) > ventaSinEdad.fecha_hora
                              THEN 1 ELSE 0 END)
                      BETWEEN bi_re.edad_min AND bi_re.edad_max
                ) AS id_rango_etario    
        FROM (
            -- Subconsulta para obtener las ventas sin la edad del cliente
            SELECT v.nro_venta,
                   v.fecha_hora,
                   c.fecha_nacimiento,
                   e.nro_local,
                   dv.subtotal_producto,
                   CASE WHEN pb.cod_producto IS NOT NULL THEN 'Bicicleta'
                        WHEN pa.cod_producto IS NOT NULL THEN 'Accesorio'
                    END AS tipo_producto     
            FROM JOIN_THE_FORCE.venta v 
                JOIN JOIN_THE_FORCE.cliente c ON (v.nro_cliente = c.nro_cliente)
                JOIN JOIN_THE_FORCE.detalle_venta dv ON (dv.nro_venta = v.nro_venta)
                JOIN JOIN_THE_FORCE.empleado e ON (v.nro_empleado = e.nro_empleado)
                LEFT JOIN JOIN_THE_FORCE.producto_bicicleta pb ON pb.cod_producto = dv.cod_producto
                LEFT JOIN JOIN_THE_FORCE.producto_accesorio pa ON pa.cod_producto = dv.cod_producto              
        ) ventaSinEdad
    ) ventaConEdad 
        JOIN JOIN_THE_FORCE.BI_local bi_l ON (bi_l.nro_local = ventaConEdad.nro_local)
        JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (bi_t.anio = YEAR(ventaConEdad.fecha_hora) AND bi_t.mes = MONTH(ventaConEdad.fecha_hora))
        WHERE ventaConEdad.tipo_producto IS NOT NULL 
            AND ventaConEdad.id_rango_etario IS NOT NULL
        GROUP BY ventaConEdad.id_rango_etario, ventaConEdad.tipo_producto, bi_t.id_tiempo, bi_l.id_local;
END;
GO

EXECUTE JOIN_THE_FORCE.crear_BI_hecho_venta

 ----------- AVISO: NO ANDA BIEN, ESTAMOS EN PROCESO ---------------------
-- BI_hecho_alquiler
GO
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_hecho_alquiler
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_hecho_alquiler (id_tiempo, id_local, categoria_bicicleta, importe_total, cant_horas, cant_alquileres)
    SELECT bi_t.id_tiempo,
           bi_l.id_local,
           m.categoria_bici,
           SUM(a.importe_total),
           DATEDIFF(HOUR, a.fecha_hora_inicio, COALESCE(a.fecha_hora_devolucion_real, a.fecha_hora_devolucion_pactada)),
           COUNT(DISTINCT a.nro_alquiler)
           
    FROM JOIN_THE_FORCE.alquiler a 
        
        JOIN JOIN_THE_FORCE.empleado e ON (e.nro_empleado = a.nro_empleado) --Para conseguir nro_local
        JOIN JOIN_THE_FORCE.bicicleta_alquiler ba ON (ba.nro_serie_bici_alquiler = a.nro_serie_bici_alquiler) -- Para conseguir modelo de la bicicleta
        JOIN JOIN_THE_FORCE.modelo m ON (m.modelo = ba.modelo) -- Para conseguir categoria de la bicicleta
        -- Ahora los joins son con cosas del BI
        JOIN JOIN_THE_FORCE.BI_local bi_l ON (bi_l.nro_local = e.nro_local)
        JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (bi_t.anio = YEAR(a.fecha_hora_inicio) AND bi_t.mes = MONTH(a.fecha_hora_inicio))
    GROUP BY bi_t.id_tiempo, bi_l.id_local, m.categoria_bici
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