SELECT
    P.nombre AS platillo,
    P.costo_venta AS precio,
    C.nombre AS categoria,
    R.nombre AS restaurante
FROM PLATILLO P
INNER JOIN CATEGORIA C
    ON P.codigo_categoria = C.codigo
INNER JOIN RESTAURANTE R
    ON P.id_restaurante = R.id_restaurante
WHERE P.codigo_estado = 'AC';
