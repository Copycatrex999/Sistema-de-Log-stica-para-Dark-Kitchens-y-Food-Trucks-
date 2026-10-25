SELECT
    DP.id_pedido,
    SUM(DP.cantidad) AS total_unidades,
    SUM(DP.cantidad * P.costo_venta) AS total_pedido
FROM DETALLE_PEDIDO DP
INNER JOIN PLATILLO P
    ON DP.id_platillo = P.id_platillo
GROUP BY DP.id_pedido;
