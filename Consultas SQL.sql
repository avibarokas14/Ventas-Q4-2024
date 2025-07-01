-- Crear Nueva Base de Datos y Usar

CREATE DATABASE whirlpool;
USE whirlpool;


-- Crear Nueva Tabla 'maestro'

CREATE TABLE Maestro (
    SKU VARCHAR(10) NOT NULL PRIMARY KEY,   
    Categoria TEXT                            
);


-- Crear Nueva Tabla 'Facturacion'

CREATE TABLE Facturacion (
    Fecha_carga_pedido DATE NOT NULL,
    Fecha_facturacion DATE NOT NULL,
    Fecha_entrega_producto DATE NOT NULL,
    Codigo_producto INT NOT NULL,
    SKU VARCHAR(10) NOT NULL,
    Descripcion TEXT,
    Unidades_pedidas INT NOT NULL,
    Unidades_facturadas INT NOT NULL,
    Unidades_entregadas INT NOT NULL,
    Precio_unitario DECIMAL(15, 2) NOT NULL
);


-- Cargar Datos en Las Tablas

LOAD DATA local INFILE "D:\\Data\\MySQL\\Maestro_Ficticio - Maestro.csv"
INTO TABLE Maestro
FIELDS TERMINATED BY ',' 
IGNORE 1 lines;


LOAD DATA local INFILE "D:\\Career\\Whirlpool\\Facturacion_Store123.csv"
INTO TABLE Facturacion
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;



-- Crear Set de Datos Procesados

CREATE TABLE Facturacion_Q4 AS
WITH Facturacion_Q4 AS (
    SELECT 
        f.Fecha_facturacion,
        f.SKU,
        m.Categoria,
        f.Unidades_facturadas,
        f.Precio_unitario,
        f.Unidades_facturadas * f.Precio_unitario AS Monto_facturado
    FROM Facturacion f
    JOIN maestro m ON f.SKU = m.SKU
    WHERE f.Fecha_facturacion BETWEEN '2024-10-01' AND '2024-12-31'
)
SELECT *
FROM Facturacion_Q4
ORDER BY Fecha_facturacion;



-- Consulta y Agrupaciones

SELECT 
    Categoria,
    SUM(Unidades_facturadas) AS Unidades_Vendidas,
    SUM(Unidades_facturadas * Precio_unitario) AS Monto_Facturado,
    COUNT(DISTINCT SKU) / (SELECT COUNT(*) FROM maestro) AS Ratio_SKUs_Comercializados
FROM Facturacion_Q4
WHERE MONTH(Fecha_facturacion) = 12  
GROUP BY Categoria
ORDER BY Categoria ASC;