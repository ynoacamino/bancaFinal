-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-01-2024 a las 01:41:00
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bancafinal`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `dni` varchar(8) NOT NULL,
  `nombres` varchar(40) NOT NULL,
  `paterno` varchar(30) NOT NULL,
  `materno` varchar(30) NOT NULL,
  `nacimiento` date NOT NULL,
  `creado` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id`, `dni`, `nombres`, `paterno`, `materno`, `nacimiento`, `creado`, `estado`) VALUES
(1, '54587912', 'Christian Raul', 'Mestas', 'Zegarra', '2006-04-17', '2024-01-16 22:48:26', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuentas`
--

CREATE TABLE `cuentas` (
  `id` int(11) NOT NULL,
  `creado` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `tarjeta_id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cuentas`
--

INSERT INTO `cuentas` (`id`, `creado`, `estado`, `tarjeta_id`, `cliente_id`) VALUES
(1, '2024-01-16 22:48:55', 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos`
--

CREATE TABLE `movimientos` (
  `id` int(11) NOT NULL,
  `tarjeta_id` int(11) NOT NULL,
  `cuenta_id` int(11) NOT NULL,
  `monto` float NOT NULL,
  `tipo` tinyint(4) NOT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `operarios`
--

CREATE TABLE `operarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `clave` varchar(30) NOT NULL,
  `creado` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarjetas`
--

CREATE TABLE `tarjetas` (
  `id` int(11) NOT NULL,
  `numero` varchar(16) NOT NULL,
  `clave` varchar(30) NOT NULL,
  `creado` timestamp NOT NULL DEFAULT current_timestamp(),
  `vencimiento` datetime NOT NULL,
  `sellado` tinyint(1) NOT NULL DEFAULT 1,
  `estado` tinyint(1) NOT NULL DEFAULT 1,
  `moneda` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tarjetas`
--

INSERT INTO `tarjetas` (`id`, `numero`, `clave`, `creado`, `vencimiento`, `sellado`, `estado`, `moneda`) VALUES
(1, '6451243451642121', '123456789', '2024-01-16 22:46:48', '2024-01-16 23:46:29', 1, 1, 's');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dni` (`dni`);

--
-- Indices de la tabla `cuentas`
--
ALTER TABLE `cuentas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cliente_id` (`cliente_id`) USING BTREE,
  ADD UNIQUE KEY `tarjeta_id` (`tarjeta_id`);

--
-- Indices de la tabla `movimientos`
--
ALTER TABLE `movimientos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tarjeta_id` (`tarjeta_id`,`cuenta_id`) USING BTREE,
  ADD KEY `cuenta_id` (`cuenta_id`) USING BTREE;

--
-- Indices de la tabla `operarios`
--
ALTER TABLE `operarios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tarjetas`
--
ALTER TABLE `tarjetas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero` (`numero`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `cuentas`
--
ALTER TABLE `cuentas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `movimientos`
--
ALTER TABLE `movimientos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `operarios`
--
ALTER TABLE `operarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tarjetas`
--
ALTER TABLE `tarjetas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cuentas`
--
ALTER TABLE `cuentas`
  ADD CONSTRAINT `cuentas_ibfk_1` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cuentas_ibfk_2` FOREIGN KEY (`tarjeta_id`) REFERENCES `tarjetas` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `movimientos`
--
ALTER TABLE `movimientos`
  ADD CONSTRAINT `movimientos_ibfk_1` FOREIGN KEY (`tarjeta_id`) REFERENCES `tarjetas` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `movimientos_ibfk_2` FOREIGN KEY (`cuenta_id`) REFERENCES `cuentas` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- usuarios
CREATE USER 'query'@'%' IDENTIFIED BY 'YR4AFJUC3nyRmasY';
GRANT SELECT ON query.* TO 'query'@'%'
GRANT INSERT ON query.* TO 'query'@'%'