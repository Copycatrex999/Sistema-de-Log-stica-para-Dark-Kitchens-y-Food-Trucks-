-- ==============================================
-- SCRIPT DDL: CREACIÓN DE ESTRUCTURA
-- Base de Datos: bd_cocina_virtual_v2
-- ==============================================

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS `bd_cocina_virtual_v2`;
CREATE SCHEMA IF NOT EXISTS `bd_cocina_virtual_v2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `bd_cocina_virtual_v2`;

-- -----------------------------------------------------
-- 1. Catálogos Base
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `estado` (
  `codigo` CHAR(2) NOT NULL,
  `nombre` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `plataforma` (
  `codigo` CHAR(2) NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `categoria` (
  `codigo` CHAR(2) NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `unidad_medida` (
  `codigo` CHAR(2) NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- 2. Entidades Principales
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `direccion` (
  `id_direccion` INT NOT NULL,
  `calle` VARCHAR(100) NULL,
  `num_exterior` VARCHAR(10) NULL,
  `num_interior` VARCHAR(10) NULL,
  `colonia` VARCHAR(50) NULL,
  `codigo_postal` CHAR(5) NULL,
  PRIMARY KEY (`id_direccion`)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `restaurante` (
  `id_restaurante` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `codigo_estado` CHAR(2) NOT NULL DEFAULT 'AC',
  PRIMARY KEY (`id_restaurante`),
  INDEX `fk_restaurante_estado_idx` (`codigo_estado` ASC),
  CONSTRAINT `fk_restaurante_estado`
    FOREIGN KEY (`codigo_estado`)
    REFERENCES `estado` (`codigo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS `sucursal` (
  `id_sucursal` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `restaurante_id_restaurante` INT NOT NULL,
  `direccion_id_direccion` INT NOT NULL,
  PRIMARY KEY (`id_sucursal`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC),
  INDEX `fk_sucursal_restaurante_idx` (`restaurante_id_restaurante` ASC),
  INDEX `fk_sucursal_direccion_idx` (`direccion_id_direccion` ASC),
  CONSTRAINT `fk_sucursal_restaurante`
    FOREIGN KEY (`restaurante_id_restaurante`)
    REFERENCES `restaurante` (`id_restaurante`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sucursal_direccion`
    FOREIGN KEY (`direccion_id_direccion`)
    REFERENCES `direccion` (`id_direccion`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS `repartidor` (
  `id_repartidor` BIGINT NOT NULL AUTO_INCREMENT,
  `nombre_completo` VARCHAR(150) NOT NULL,
  `telefono` CHAR(10) NOT NULL,
  `codigo_estado` CHAR(2) NOT NULL DEFAULT 'AC',
  PRIMARY KEY (`id_repartidor`),
  INDEX `fk_repartidor_estado_idx` (`codigo_estado` ASC),
  CONSTRAINT `fk_repartidor_estado`
    FOREIGN KEY (`codigo_estado`)
    REFERENCES `estado` (`codigo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1;

-- -----------------------------------------------------
-- 3. Productos, Insumos y Recetas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `platillo` (
  `id_platillo` INT NOT NULL AUTO_INCREMENT,
  `id_restaurante` INT NOT NULL,
  `nombre` VARCHAR(150) NOT NULL,
  `costo_venta` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `codigo_categoria` CHAR(2) NOT NULL,
  `codigo_estado` CHAR(2) NOT NULL DEFAULT 'AC',
  PRIMARY KEY (`id_platillo`),
  INDEX `fk_platillo_restaurante_idx` (`id_restaurante` ASC),
  INDEX `fk_platillo_categoria_idx` (`codigo_categoria` ASC),
  INDEX `fk_platillo_estado_idx` (`codigo_estado` ASC),
  CONSTRAINT `fk_platillo_restaurante`
    FOREIGN KEY (`id_restaurante`)
    REFERENCES `restaurante` (`id_restaurante`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_platillo_categoria`
    FOREIGN KEY (`codigo_categoria`)
    REFERENCES `categoria` (`codigo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_platillo_estado`
    FOREIGN KEY (`codigo_estado`)
    REFERENCES `estado` (`codigo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS `insumo` (
  `id_insumo` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `codigo_unidad_medida` CHAR(2) NOT NULL,
  `costo_individual` DECIMAL(10,2) NULL,
  PRIMARY KEY (`id_insumo`),
  INDEX `fk_insumo_unidad_idx` (`codigo_unidad_medida` ASC),
  CONSTRAINT `fk_insumo_unidad`
    FOREIGN KEY (`codigo_unidad_medida`)
    REFERENCES `unidad_medida` (`codigo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS `receta` (
  `id_platillo` INT NOT NULL,
  `id_insumo` INT NOT NULL,
  `cantidad_requerida` DECIMAL(10,3) NOT NULL,
  PRIMARY KEY (`id_platillo`, `id_insumo`),
  INDEX `fk_receta_insumo_idx` (`id_insumo` ASC),
  CONSTRAINT `fk_receta_platillo`
    FOREIGN KEY (`id_platillo`)
    REFERENCES `platillo` (`id_platillo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_receta_insumo`
    FOREIGN KEY (`id_insumo`)
    REFERENCES `insumo` (`id_insumo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sucursal_insumo_detalle` (
  `id_sucursal_insumo` INT NOT NULL AUTO_INCREMENT,
  `sucursal_id_sucursal` INT NOT NULL,
  `insumo_id_insumo` INT NOT NULL,
  `cantidad_actual` DECIMAL(10,2) NOT NULL,
  `estado_codigo` CHAR(2) NOT NULL DEFAULT 'AC',
  PRIMARY KEY (`id_sucursal_insumo`),
  UNIQUE INDEX `uq_sucursal_insumo` (`sucursal_id_sucursal` ASC, `insumo_id_insumo` ASC),
  INDEX `fk_sid_insumo_idx` (`insumo_id_insumo` ASC),
  INDEX `fk_sid_estado_idx` (`estado_codigo` ASC),
  CONSTRAINT `fk_sid_sucursal`
    FOREIGN KEY (`sucursal_id_sucursal`)
    REFERENCES `sucursal` (`id_sucursal`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sid_insumo`
    FOREIGN KEY (`insumo_id_insumo`)
    REFERENCES `insumo` (`id_insumo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sid_estado`
    FOREIGN KEY (`estado_codigo`)
    REFERENCES `estado` (`codigo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1;

-- -----------------------------------------------------
-- 4. Pedidos y Trazabilidad Operativa
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pedido` (
  `id_pedido` BIGINT NOT NULL AUTO_INCREMENT,
  `codigo_plataforma` CHAR(2) NOT NULL,
  `codigo_estado` CHAR(2) NOT NULL DEFAULT 'PE',
  `hora_solicitud` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `hora_aceptado` DATETIME NULL,
  `hora_entrega` DATETIME NULL,
  `sucursal_id_sucursal` INT NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_pedido_plataforma_idx` (`codigo_plataforma` ASC),
  INDEX `fk_pedido_estado_idx` (`codigo_estado` ASC),
  INDEX `fk_pedido_sucursal_idx` (`sucursal_id_sucursal` ASC),
  CONSTRAINT `fk_pedido_plataforma`
    FOREIGN KEY (`codigo_plataforma`)
    REFERENCES `plataforma` (`codigo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_estado`
    FOREIGN KEY (`codigo_estado`)
    REFERENCES `estado` (`codigo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pedido_sucursal`
    FOREIGN KEY (`sucursal_id_sucursal`)
    REFERENCES `sucursal` (`id_sucursal`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1001;

CREATE TABLE IF NOT EXISTS `detalle_pedido` (
  `id_pedido` BIGINT NOT NULL,
  `id_platillo` INT NOT NULL,
  `cantidad` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_pedido`, `id_platillo`),
  INDEX `fk_dp_platillo_idx` (`id_platillo` ASC),
  CONSTRAINT `fk_dp_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `pedido` (`id_pedido`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_dp_platillo`
    FOREIGN KEY (`id_platillo`)
    REFERENCES `platillo` (`id_platillo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `asignacion_repartidor` (
  `folio` INT NOT NULL AUTO_INCREMENT,
  `id_repartidor` BIGINT NOT NULL,
  `id_pedido` BIGINT NOT NULL,
  `hora_salida` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`folio`),
  UNIQUE INDEX `id_pedido_UNIQUE` (`id_pedido` ASC),
  INDEX `fk_ar_repartidor_idx` (`id_repartidor` ASC),
  CONSTRAINT `fk_ar_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `pedido` (`id_pedido`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ar_repartidor`
    FOREIGN KEY (`id_repartidor`)
    REFERENCES `repartidor` (`id_repartidor`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 1;

CREATE TABLE IF NOT EXISTS `detalle_pedido_insumo` (
  `id_pedido` BIGINT NOT NULL,
  `id_platillo` INT NOT NULL,
  `id_insumo` INT NOT NULL,
  `cantidad_consumida` DECIMAL(10,3) NOT NULL,
  `sucursal_insumo_detalle_cantidad` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id_pedido`, `id_platillo`, `id_insumo`),
  INDEX `fk_dpi_platillo_idx` (`id_platillo` ASC),
  INDEX `fk_dpi_insumo_idx` (`id_insumo` ASC),
  CONSTRAINT `fk_dpi_pedido`
    FOREIGN KEY (`id_pedido`)
    REFERENCES `pedido` (`id_pedido`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_dpi_platillo`
    FOREIGN KEY (`id_platillo`)
    REFERENCES `platillo` (`id_platillo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_dpi_insumo`
    FOREIGN KEY (`id_insumo`)
    REFERENCES `insumo` (`id_insumo`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;