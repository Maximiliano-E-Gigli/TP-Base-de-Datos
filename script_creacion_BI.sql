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
    unidades_vendidas       INT,
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
    desvio_total_dias               NUMERIC(38,2),
    cant_reparaciones               INT,

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
    importe_total                    NUMERIC(38,2),
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
        (id_rango_etario, tipo_producto, id_tiempo, id_local, subtotal, unidades_vendidas, cant_ventas)
    SELECT 
        ventaConEdad.id_rango_etario,
        ventaConEdad.tipo_producto,
        bi_t.id_tiempo,
        bi_l.id_local,
        SUM(ventaConEdad.subtotal_producto),
        SUM (ventaConEdad.cant_producto),
        COUNT(DISTINCT ventaConEdad.nro_venta)
    FROM (
        -- Subconsulta para obtener las ventas con la edad del cliente
        SELECT ventaSinEdad.nro_venta,
               ventaSinEdad.fecha_hora,
               ventaSinEdad.nro_local,
               ventaSinEdad.subtotal_producto,
               ventaSinEdad.cant_producto,
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
                   dv.cant_producto,
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

EXECUTE JOIN_THE_FORCE.crear_BI_hecho_venta;

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
           SUM(DATEDIFF(MINUTE, a.fecha_hora_inicio,  COALESCE(a.fecha_hora_devolucion_real, a.fecha_hora_devolucion_pactada))) / 60.0,
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

EXECUTE JOIN_THE_FORCE.crear_BI_hecho_alquiler;

-- BI_hecho_compra
GO
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_hecho_compra
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_hecho_compra
        (id_tiempo, id_local, tipo_producto, cantidad, importe_total, cant_compras)
    SELECT bi_t.id_tiempo,
           bi_l.id_local,
           super_compra.tipo_producto,
           SUM(super_compra.cant_producto),
           SUM(super_compra.subtotal_producto),
           COUNT(DISTINCT super_compra.nro_compra)
    FROM (
        SELECT 
        c.nro_compra,
        c.fecha_compra,
        e.nro_local,
        CASE WHEN pb.cod_producto IS NOT NULL THEN 'Bicicleta'
                        WHEN pa.cod_producto IS NOT NULL THEN 'Accesorio'
                    END AS tipo_producto ,
        dc.cant_producto,
        dc.subtotal_producto
        FROM
        JOIN_THE_FORCE.compra c
        JOIN JOIN_THE_FORCE.empleado e ON (e.nro_empleado = c.nro_empleado) --Para conseguir nro_local
        JOIN JOIN_THE_FORCE.detalle_compra dc ON (c.nro_compra = dc.nro_compra)
        JOIN JOIN_THE_FORCE.producto p ON (dc.cod_producto = p.cod_producto)
        LEFT JOIN JOIN_THE_FORCE.producto_bicicleta pb ON pb.cod_producto = dc.cod_producto
        LEFT JOIN JOIN_THE_FORCE.producto_accesorio pa ON pa.cod_producto = dc.cod_producto   
    ) super_compra
        -- Ahora joins con cosas del BI
        JOIN JOIN_THE_FORCE.BI_local bi_l ON (bi_l.nro_local = super_compra.nro_local)
        JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (bi_t.anio = YEAR(super_compra.fecha_compra) AND bi_t.mes = MONTH(super_compra.fecha_compra))
    WHERE super_compra.tipo_producto IS NOT NULL
    GROUP BY bi_t.id_tiempo, bi_l.id_local, tipo_producto ;
END;
GO

EXECUTE JOIN_THE_FORCE.crear_BI_hecho_compra;

-- BI_hecho_reparacion 
GO
CREATE OR ALTER PROCEDURE JOIN_THE_FORCE.crear_BI_hecho_reparacion
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_hecho_reparacion (id_tiempo, id_local, desvio_total_dias, cant_reparaciones)
    SELECT bi_t.id_tiempo, 
           bi_l.id_local, 
           SUM(DATEDIFF(MINUTE, r.fecha_entrega_estimada,r.fecha_entrega_real)) / 1440.0,
           COUNT(DISTINCT r.nro_reparacion)
    FROM JOIN_THE_FORCE.reparacion r
    JOIN JOIN_THE_FORCE.empleado e ON e.nro_empleado = r.nro_empleado
    -- Ahora joins con cosas del BI
    JOIN JOIN_THE_FORCE.BI_local bi_l ON bi_l.nro_local = e.nro_local
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON bi_t.anio = YEAR(r.fecha_ingreso) AND bi_t.mes = MONTH(r.fecha_ingreso) AND bi_t.trimestre = DATEPART(QUARTER, r.fecha_ingreso)
    WHERE r.fecha_entrega_real IS NOT NULL
      AND r.fecha_entrega_estimada IS NOT NULL
    GROUP BY bi_t.id_tiempo, bi_l.id_local;
END;
GO

EXECUTE JOIN_THE_FORCE.crear_BI_hecho_reparacion;

-- BI_hecho_respuestos_usados
GO
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_hecho_repuestos_usados
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_hecho_repuestos_usados(id_tiempo, categoria_repuesto, cantidad)
    SELECT bi_t.id_tiempo,
           rep.categoria_repuesto,
           COUNT(DISTINCT r.nro_reparacion)
    FROM JOIN_THE_FORCE.reparacion r
        JOIN JOIN_THE_FORCE.detalle_reparacion dr ON (dr.nro_reparacion = r.nro_reparacion)
        JOIN JOIN_THE_FORCE.repuesto rep ON (rep.cod_repuesto = dr.cod_repuesto)
        -- Ahora joins con cosas del BI
        JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (bi_t.anio = YEAR(r.fecha_ingreso) AND bi_t.mes = MONTH(r.fecha_ingreso))
    GROUP BY bi_t.id_tiempo, rep.categoria_repuesto
END;
GO

EXECUTE JOIN_THE_FORCE.crear_BI_hecho_repuestos_usados;

-- BI_hecho_ingreso_reparacion
GO
CREATE PROCEDURE JOIN_THE_FORCE.crear_BI_hecho_ingreso_reparacion
AS
BEGIN
    INSERT INTO JOIN_THE_FORCE.BI_hecho_ingreso_reparacion(id_tiempo, id_local, tipo_ingreso_reparacion, subtotal)
    SELECT bi_t.id_tiempo,
           bi_l.id_local,
           bi_tr.tipo_ingreso_reparacion,
           SUM(CASE bi_tr.tipo_ingreso_reparacion
                WHEN 'Mano de Obra' THEN r.precio_mano_obra
                WHEN 'Repuestos'    THEN r.precio_repuestos
            END) AS ingreso_total       
    FROM JOIN_THE_FORCE.reparacion r
        JOIN JOIN_THE_FORCE.empleado e ON (e.nro_empleado = r.nro_empleado)
        -- Ahora joins con cosas del BI
        JOIN JOIN_THE_FORCE.BI_local bi_l ON (bi_l.nro_local = e.nro_local)
        JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (bi_t.anio = YEAR(r.fecha_ingreso) AND bi_t.mes = MONTH(r.fecha_ingreso))
        CROSS JOIN JOIN_THE_FORCE.BI_tipo_ingreso_reparacion bi_tr
    GROUP BY bi_t.id_tiempo, bi_l.id_local, bi_tr.tipo_ingreso_reparacion
END;
GO

EXECUTE JOIN_THE_FORCE.crear_BI_hecho_ingreso_reparacion

/*============================================= VIEWS =============================================*/

-- Vista 1: Facturacion total mensual en ventas de cada local.
GO
CREATE VIEW JOIN_THE_FORCE.V_facturacion_ventas_mensual_x_local
AS
SELECT bi_t.anio,
       bi_t.mes,
       bi_l.nro_local,
       bi_l.nombre AS local,
       SUM(hv.subtotal) AS facturacion_total
FROM JOIN_THE_FORCE.BI_hecho_venta hv 
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (hv.id_tiempo = bi_t.id_tiempo)
    JOIN JOIN_THE_FORCE.BI_local bi_l ON (hv.id_local = bi_l.id_local)
GROUP BY bi_t.anio, bi_t.mes, bi_l.nro_local, bi_l.nombre;

-- Vista 2: Ticket promedio ($) de venta mensual por tipo de producto (bicicletas o accesorios) y rango etario del cliente.
GO
CREATE VIEW JOIN_THE_FORCE.V_ticket_promedio_mensual_x_tipo_prod_x_rango_etario
AS
SELECT bi_t.anio,
       bi_t.mes,
       hv.tipo_producto,
       bi_re.descripcion AS rango_etario,
       CAST(SUM(hv.subtotal) / NULLIF(SUM(hv.cant_ventas),0) AS DECIMAL(38,2)) AS ticket_promedio
FROM JOIN_THE_FORCE.BI_hecho_venta hv
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (hv.id_tiempo = bi_t.id_tiempo)
    JOIN JOIN_THE_FORCE.BI_rango_etario bi_re ON (hv.id_rango_etario = bi_re.id_rango_etario)
GROUP BY bi_t.anio, bi_t.mes, hv.tipo_producto, bi_re.descripcion;

-- Vista 3: Porcentaje de ventas trimestrales según tipo de producto (bicicletas o accesorios) por local.
GO
CREATE VIEW JOIN_THE_FORCE.V_porcentaje_ventas_x_trimestre_x_tipo_producto_x_local
AS
SELECT
       bi_t.anio, 
       bi_t.trimestre,
       bi_l.nro_local,
       bi_l.nombre,
       tp.tipo_producto,
       CAST(SUM(hv.unidades_vendidas) * 100.0
            / NULLIF((SELECT SUM(hv2.unidades_vendidas)
                      FROM JOIN_THE_FORCE.BI_hecho_venta hv2
                          JOIN JOIN_THE_FORCE.BI_tiempo bi_t2 ON (bi_t2.id_tiempo = hv2.id_tiempo)
                      WHERE bi_t2.anio = bi_t.anio
                        AND bi_t2.trimestre = bi_t.trimestre
                        AND hv2.id_local = hv.id_local), 0)
            AS DECIMAL(38,2)) AS porcentaje

FROM JOIN_THE_FORCE.BI_hecho_venta hv
    JOIN JOIN_THE_FORCE.BI_local bi_l ON (hv.id_local = bi_l.id_local)
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (hv.id_tiempo = bi_t.id_tiempo)
    JOIN JOIN_THE_FORCE.BI_tipo_producto tp ON (hv.tipo_producto = tp.tipo_producto)
GROUP BY bi_t.anio, bi_t.trimestre, bi_l.nro_local, bi_l.nombre, tp.tipo_producto, hv.id_local

-- Vista 4: Promedio de cantidad de horas de alquiler de bicicletas, por local y mes.
GO
CREATE VIEW JOIN_THE_FORCE.V_promedio_cant_horas_alquiler (promedio, local, anio, mes)
AS
SELECT SUM(ha.cant_horas) / SUM(ha.cant_alquileres) promedio, 
       bi_l.nombre, 
       bi_t.anio, 
       bi_t.mes
FROM JOIN_THE_FORCE.BI_hecho_alquiler ha
    JOIN JOIN_THE_FORCE.BI_local bi_l ON (ha.id_local = bi_l.id_local)
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (ha.id_tiempo = bi_t.id_tiempo)
GROUP BY bi_l.id_local, bi_l.nombre, bi_t.mes, bi_t.anio;

-- Vista 5: Top 5 categorías de bicicleta más alquilados, por año.
GO
CREATE VIEW JOIN_THE_FORCE.V_top_5_categorias_bicicletas (bicicleta, anio, cantidad_alquileres)
AS
SELECT ha.categoria_bicicleta, 
       bi_t.anio, 
       SUM(ha.cant_alquileres)
FROM JOIN_THE_FORCE.BI_hecho_alquiler ha
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON ha.id_tiempo = bi_t.id_tiempo
WHERE ha.categoria_bicicleta IN ( SELECT TOP 5 ha2.categoria_bicicleta
                                    FROM JOIN_THE_FORCE.BI_hecho_alquiler ha2
                                        JOIN JOIN_THE_FORCE.BI_tiempo bi_t2  ON ha2.id_tiempo = bi_t2.id_tiempo
                                    WHERE bi_t2.anio = bi_t.anio
                                    GROUP BY ha2.categoria_bicicleta
                                    ORDER BY SUM(ha2.cant_alquileres) DESC, ha2.categoria_bicicleta)
GROUP BY ha.categoria_bicicleta, bi_t.anio;

-- Vista 6: Desvío promedio de reparaciones (en días), entre fecha de entrega estimada y real, por local y trimestre.
GO
CREATE VIEW JOIN_THE_FORCE.V_desvio_promedio_reparaciones (promedio_desvio_dias, local, anio, trimestre)
AS
SELECT SUM(hr.desvio_total_dias) / SUM(hr.cant_reparaciones), 
       bi_l.nombre, 
       bi_t.anio, 
       bi_t.trimestre
FROM JOIN_THE_FORCE.BI_hecho_reparacion hr
    JOIN JOIN_THE_FORCE.BI_local bi_l ON hr.id_local = bi_l.id_local
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON hr.id_tiempo = bi_t.id_tiempo
GROUP BY bi_l.id_local, bi_l.nombre, bi_t.anio, bi_t.trimestre;

-- Vista 7: Ranking de categoría de repuestos más utilizados por mes.
GO
CREATE VIEW JOIN_THE_FORCE.V_ranking_categoria_repuesto
AS
SELECT bi_t.anio,
       bi_t.mes,
       hru.categoria_repuesto,
       RANK() OVER (PARTITION BY bi_t.anio, bi_t.mes
                    ORDER BY SUM(hru.cantidad) DESC) puesto
FROM JOIN_THE_FORCE.BI_hecho_repuestos_usados hru
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (hru.id_tiempo = bi_t.id_tiempo)
GROUP BY bi_t.anio, bi_t.mes, hru.categoria_repuesto;

-- Vista 8: Porcentaje de facturación de reparaciones según el tipo de ingreso de reparación (mano de obra o repuestos) por trimestre.
GO
CREATE VIEW JOIN_THE_FORCE.V_porcentaje_facturacion_reparaciones
AS
SELECT hir.tipo_ingreso_reparacion,
       bi_t.anio,
       bi_t.trimestre,
       CAST(SUM(hir.subtotal) * 100.0
            / NULLIF((SELECT SUM(hir2.subtotal)
                      FROM JOIN_THE_FORCE.BI_hecho_ingreso_reparacion hir2
                          JOIN JOIN_THE_FORCE.BI_tiempo bi_t2 ON (bi_t2.id_tiempo = hir2.id_tiempo)
                      WHERE bi_t2.anio = bi_t.anio
                        AND bi_t2.trimestre = bi_t.trimestre), 0)
            AS DECIMAL(38,2)) AS porcentaje
FROM JOIN_THE_FORCE.BI_hecho_ingreso_reparacion hir
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (bi_t.id_tiempo = hir.id_tiempo)
GROUP BY hir.tipo_ingreso_reparacion, bi_t.anio, bi_t.trimestre;

-- Vista 9: Promedio de unidades compradas según el tipo de producto  por trimestre.
GO
CREATE VIEW JOIN_THE_FORCE.V_promedio_unidades_compradas_x_tipo_producto_x_trimestre (anio, trimestre, tipo_productopromedio, tipo_producto)
AS
SELECT 
    bi_t.anio,
    bi_t.trimestre,
    bi_tp.tipo_producto,
    SUM(hc.cantidad) / SUM(hc.cant_compras) promedio
FROM JOIN_THE_FORCE.BI_hecho_compra hc
    JOIN JOIN_THE_FORCE.BI_tipo_producto bi_tp ON (hc.tipo_producto = bi_tp.tipo_producto)
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (hc.id_tiempo = bi_t.id_tiempo)
GROUP BY bi_tp.tipo_producto, bi_t.trimestre, bi_t.anio;

-- Vista 10: Importe total de compras mensuales por local.
GO
CREATE VIEW JOIN_THE_FORCE.V_importe_total_compras_x_mes_x_local (anio, mes, nro_local, local, importe_total_local)
AS
SELECT
    bi_t.anio,
    bi_t.mes,
    bi_l.nro_local,
    bi_l.nombre as local,
    SUM(hc.importe_total) AS importe_total_local
FROM JOIN_THE_FORCE.BI_hecho_compra hc
    JOIN JOIN_THE_FORCE.BI_local bi_l ON (hc.id_local = bi_l.id_local)
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON (hc.id_tiempo = bi_t.id_tiempo)
GROUP BY bi_t.anio, bi_t.mes, bi_l.nro_local, bi_l.nombre
GO

-- Vista 11: Facturación mensual del negocio (ventas + alquileres + reparaciones) por local.
GO
CREATE VIEW JOIN_THE_FORCE.V_facturacion_mensual_total_x_local (anio, mes, nro_local, local, facturacion_total)
AS
SELECT 
    bi_t.anio,
    bi_t.mes,
    bi_l.nro_local,
    bi_l.nombre AS local,
    SUM(COALESCE(hv.subtotal, 0) + COALESCE(ha.importe_total, 0) + COALESCE(hir.subtotal, 0)) AS facturacion_total
FROM JOIN_THE_FORCE.BI_local bi_l
    JOIN JOIN_THE_FORCE.BI_tiempo bi_t ON 1=1
    JOIN JOIN_THE_FORCE.BI_hecho_venta hv ON bi_l.id_local = hv.id_local AND bi_t.id_tiempo = hv.id_tiempo
    JOIN JOIN_THE_FORCE.BI_hecho_alquiler ha ON bi_l.id_local = ha.id_local AND bi_t.id_tiempo = ha.id_tiempo
    JOIN JOIN_THE_FORCE.BI_hecho_ingreso_reparacion hir ON bi_l.id_local = hir.id_local AND bi_t.id_tiempo = hir.id_tiempo
GROUP BY bi_t.anio, bi_t.mes, bi_l.nro_local, bi_l.nombre;
GO

