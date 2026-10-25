SELECT
    I.id_insumo,
    I.nombre AS insumo,
    I.stock_actual,
    U.nombre AS unidad_medida,
    I.costo_inventario
FROM INSUMO I
INNER JOIN UNIDAD_MEDIDA U
    ON I.codigo_unidad_medida = U.codigo
WHERE I.stock_actual < 50
ORDER BY I.stock_actual ASC;
