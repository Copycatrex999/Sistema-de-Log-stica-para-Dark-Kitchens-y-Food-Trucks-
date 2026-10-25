SELECT
    P.id_pedido,
    PL.nombre AS plataforma,
    E.nombre AS estado,
    P.hora_solicitud
FROM PEDIDO P
INNER JOIN PLATAFORMA PL
    ON P.codigo_plataforma = PL.codigo
INNER JOIN ESTADO E
    ON P.codigo_estado = E.codigo;
