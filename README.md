# TP-Base-de-Datos

Consideraciones:
Quitamos las descripciones previamente agregadas en el DER para no agregar información que no se nos provee. (En estados y categorías)

Se agrega PK identity en localidad para evitar casos en los cuales hay distintas localidades con el mismo nombre pero distinta provincia.

El local actual del empleado lo tomamos como en el que tenga ventas, reparaciones y compras debido a que todos tienen alquileres en todos los locales.


De la BI:
Decidimos que para guardar las facturaciones:
    'BI_hecho_venta' tiene subtotal
    'BI_hecho_alquiler' tiene importe_total
    'BI_hecho_reparacion' tiene subtotal
    'BI_hecho_compra' tiene cantidad y precio_unidad para flexibilidad en las VIEWS

Decidimos que las fechas que vamos a considerar para los tiempos de los eventos son las de inicio

