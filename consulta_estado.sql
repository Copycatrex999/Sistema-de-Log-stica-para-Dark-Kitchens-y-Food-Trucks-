-- =====================================================
-- Consulta 1: Resumen y Estado Detallado de Pedidos
-- Muestra el detalle del pedido, plataforma, restaurante, 
-- platillos ordenados, cantidades e importe total por ítem.
-- =====================================================
USE `bd_cocina_virtual_norm`;

SELECT 
    p.id_pedido,
    plat.nombre AS plataforma,
    e.nombre AS estado_pedido,
    p.hora_solicitud,
    r.nombre AS restaurante,
    pl.nombre AS platillo,
    dp.cantidad,
    pl.costo_venta AS precio_unitario,
    (dp.cantidad * pl.costo_venta) AS subtotal
FROM PEDIDO p
INNER JOIN PLATAFORMA plat ON p.codigo_plataforma = plat.codigo
INNER JOIN ESTADO e ON p.codigo_estado = e.codigo
INNER JOIN DETALLE_PEDIDO dp ON p.id_pedido = dp.id_pedido
INNER JOIN PLATILLO pl ON dp.id_platillo = pl.id_platillo
INNER JOIN RESTAURANTE r ON pl.id_restaurante = r.id_restaurante
ORDER BY p.id_pedido DESC, pl.nombre ASC;