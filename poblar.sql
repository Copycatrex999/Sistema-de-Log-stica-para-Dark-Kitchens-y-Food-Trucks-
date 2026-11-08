-- ==============================================
-- SCRIPT DML: POBLACIÓN DE DATOS
-- ==============================================

USE `bd_cocina_virtual_v2`;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Catálogos
INSERT INTO `estado` (`codigo`, `nombre`) VALUES
('AC', 'Activo'),
('IN', 'Inactivo'),
('PE', 'Pendiente'),
('PR', 'En Preparación'),
('EN', 'Entregado'),
('CA', 'Cancelado');

INSERT INTO `plataforma` (`codigo`, `nombre`) VALUES
('UD', 'Uber Eats'),
('DP', 'Rappi'),
('DD', 'DoorDash'),
('PH', 'PedidosYa');

INSERT INTO `categoria` (`codigo`, `nombre`) VALUES
('TA', 'Tacos'),
('PI', 'Pizza'),
('HA', 'Hamburguesas'),
('BE', 'Bebidas'),
('PO', 'Postres');

INSERT INTO `unidad_medida` (`codigo`, `nombre`) VALUES
('KG', 'Kilogramos'),
('GR', 'Gramos'),
('LT', 'Litros'),
('ML', 'Mililitros'),
('PZ', 'Piezas');

-- 2. Negocio e Infraestructura
INSERT INTO `restaurante` (`id_restaurante`, `nombre`, `codigo_estado`) VALUES
(1, 'Tacos Don Pepe', 'AC'),
(2, 'Pizzas Bella Napoli', 'AC'),
(3, 'Hamburguesas El Gordo', 'AC');

INSERT INTO `direccion` (`id_direccion`, `calle`, `num_exterior`, `num_interior`, `colonia`, `codigo_postal`) VALUES
(101, 'Av. Reforma', '150', NULL, 'Centro', '06000'),
(102, 'Calle 10', '520', NULL, 'Del Valle', '03100'),
(103, 'Blvd. Kukulcan', '12', 'Int 4', 'Zona Hotelera', '77500');

INSERT INTO `sucursal` (`id_sucursal`, `nombre`, `restaurante_id_restaurante`, `direccion_id_direccion`) VALUES
(1, 'Sucursal Centro', 1, 101),
(2, 'Sucursal Del Valle', 1, 102),
(3, 'Sucursal Cancún', 3, 103);

INSERT INTO `repartidor` (`id_repartidor`, `nombre_completo`, `telefono`, `codigo_estado`) VALUES
(1, 'Juan Pérez Hernández', '5512345678', 'AC'),
(2, 'María López García', '5598765432', 'AC'),
(3, 'Carlos Ruiz Díaz', '5567890123', 'IN');

INSERT INTO `insumo` (`id_insumo`, `nombre`, `codigo_unidad_medida`, `costo_individual`) VALUES
(1, 'Tortilla Maíz', 'KG', 15.50),
(2, 'Carne Pastor', 'KG', 120.00),
(3, 'Salsa Roja', 'LT', 45.00),
(4, 'Cebolla Blanca', 'KG', 22.00),
(5, 'Harina de Trigo', 'KG', 20.00),
(6, 'Queso Mozzarella', 'KG', 160.00);

-- 3. Productos y Recetas
INSERT INTO `platillo` (`id_platillo`, `id_restaurante`, `nombre`, `costo_venta`, `codigo_categoria`, `codigo_estado`) VALUES
(1, 1, 'Tacos al Pastor (5 pzas)', 65.00, 'TA', 'AC'),
(2, 1, 'Gringa de Pastor', 45.00, 'TA', 'AC'),
(3, 2, 'Pizza Grande Pepperoni', 190.00, 'PI', 'AC');

INSERT INTO `receta` (`id_platillo`, `id_insumo`, `cantidad_requerida`) VALUES
(1, 1, 0.150), -- 150g tortilla
(1, 2, 0.250), -- 250g carne pastor
(1, 3, 0.050), -- 50ml salsa
(1, 4, 0.030), -- 30g cebolla
(2, 1, 0.050), -- tortilla gringa
(2, 2, 0.200), -- carne gringa
(3, 5, 0.400), -- harina pizza
(3, 6, 0.200); -- queso pizza

-- 4. Operación (Inventario, Pedidos y Asignaciones)
INSERT INTO `sucursal_insumo_detalle` (`id_sucursal_insumo`, `sucursal_id_sucursal`, `insumo_id_insumo`, `cantidad_actual`, `estado_codigo`) VALUES
(1, 1, 1, 50.00, 'AC'),
(2, 1, 2, 30.00, 'AC'),
(3, 1, 3, 10.00, 'AC');

INSERT INTO `pedido` (`id_pedido`, `codigo_plataforma`, `codigo_estado`, `hora_solicitud`, `hora_aceptado`, `hora_entrega`, `sucursal_id_sucursal`) VALUES
(1001, 'UD', 'EN', NOW() - INTERVAL 1 HOUR, NOW() - INTERVAL 55 MINUTE, NOW() - INTERVAL 20 MINUTE, 1),
(1002, 'DP', 'EN', NOW() - INTERVAL 45 MINUTE, NOW() - INTERVAL 40 MINUTE, NOW() - INTERVAL 5 MINUTE, 1),
(1003, 'UD', 'PE', NOW() - INTERVAL 5 MINUTE, NULL, NULL, 1);

INSERT INTO `detalle_pedido` (`id_pedido`, `id_platillo`, `cantidad`) VALUES
(1001, 1, 2), -- Pedido 1001: 2 órdenes de Tacos
(1001, 2, 1), -- Pedido 1001: 1 Gringa
(1002, 1, 1), -- Pedido 1002: 1 orden de Tacos
(1003, 1, 1); -- Pedido 1003: 1 orden de Tacos (consistente con el menú de la sucursal 1)

INSERT INTO `asignacion_repartidor` (`id_repartidor`, `id_pedido`, `hora_salida`) VALUES
(1, 1001, NOW() - INTERVAL 25 MINUTE),
(2, 1002, NOW() - INTERVAL 10 MINUTE);

-- 5. Consumo de Insumos por Pedido
INSERT INTO `detalle_pedido_insumo` (`id_pedido`, `id_platillo`, `id_insumo`, `cantidad_consumida`, `sucursal_insumo_detalle_cantidad`) VALUES
(1001, 1, 1, 0.300, 50.00), -- 2 órdenes * 0.150kg tortilla
(1001, 1, 2, 0.500, 30.00), -- 2 órdenes * 0.250kg carne pastor
(1001, 2, 2, 0.200, 30.00); -- 1 gringa * 0.200kg carne pastor

SET FOREIGN_KEY_CHECKS = 1;