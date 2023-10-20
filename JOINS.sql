--JOINS
-- 1
-- Listado con las localidades, su ID, nombre y el nombre de la provincia a la que pertenece. 

SELECT l.IDLocalidad, l.Localidad, p.Provincia FROM Localidades l INNER JOIN Provincias p on l.IDProvincia=p.IDProvincia

-- 2..

-- Listado que informe el ID de la multa, el monto a abonar y los datos del agente que la realizó. Debe incluir los apellidos y nombres de los agentes. Así como también la fecha de nacimiento y la edad.

SELECT m.IdMulta, m.Monto, a.Apellidos, a.Nombres, a.FechaNacimiento, DATEDIFF(YEAR,0,GETDATE()- CAST(FechaNacimiento as datetime)) Edad FROM Multas m INNER JOIN Agentes a on m.IdAgente=a.IdAgente

-- 3
-- Listar todos los datos de todas las multas realizadas por agentes que a la fecha de hoy tengan más de 5 años de antigüedad.

SELECT * FROM Multas WHERE DATEDIFF(YEAR, 0, GETDATE() - CAST(FechaHora as datetime))>5

UPDATE Multas SET FechaHora='2017-02-22 09:10:00.000'
WHERE IdMulta=1 -- SE MODIFICA PARA PODER CORROBORAR LA CONSULTA

-- 4
-- Listar todos los datos de todas las multas cuyo importe de referencia supere los $15000.

SELECT * FROM Multas m INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion WHERE ti.ImporteReferencia>15000

-- 5
-- Listar los nombres y apellidos de los agentes, sin repetir, que hayan labrado multas en la provincia de Buenos Aires o en Cordoba.

SELECT distinct a.Apellidos, a.Nombres, * FROM Agentes a LEFT JOIN Multas m on a.IdAgente=m.IdAgente INNER JOIN Localidades loc on m.IDLocalidad=loc.IDLocalidad INNER JOIN Provincias pr on loc.IDProvincia=pr.IDProvincia WHERE Provincia='Buenos Aires'

-- 6
-- Listar los nombres y apellidos de los agentes, sin repetir, que hayan labrado multas del tipo "Exceso de velocidad".

SELECT distinct a.Nombres, a.Apellidos FROM Agentes a LEFT JOIN Multas m on a.IdAgente=m.IdAgente inner join TipoInfracciones ti on m.IdTipoInfraccion= ti.IdTipoInfraccion WHERE ti.Descripcion='Exceso de velocidad'

-- 7
-- Listar apellidos y nombres de los agentes que no hayan labrado multas.

SELECT a.Apellidos, a.Nombres, m.IdMulta from Agentes a LEFT JOIN Multas m on a.IdAgente=m.IdAgente WHERE m.IdMulta is NULL

-- 8
-- Por cada multa, lista el nombre de la localidad y provincia, el tipo de multa, los apellidos y nombres de los agentes y su legajo, el monto de la multa y la diferencia en pesos en relación al tipo de infracción cometida.

SELECT m.IdMulta, loc.Localidad, pr.Provincia, ti.Descripcion, a.Apellidos, a.Nombres, a.Legajo, m.Monto, (m.Monto - ti.ImporteReferencia) DiferenciaMonto FROM Multas m INNER JOIN Localidades loc on m.IDLocalidad=loc.IDLocalidad INNER JOIN Provincias pr on loc.IDProvincia=pr.IDProvincia INNER JOIN Agentes a on m.IdAgente=a.IdAgente INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion

-- 9
-- Listar las localidades en las que no se hayan registrado multas.

SELECT loc.Localidad, m.IdMulta FROM Localidades loc LEFT JOIN Multas m on loc.IDLocalidad=m.IDLocalidad WHERE m.IdMulta is NULL

-- 10
-- Listar los datos de las multas pagadas que se hayan labrado en la provincia de Buenos Aires.

SELECT * FROM Multas m LEFT JOIN Localidades loc on m.IDLocalidad= loc.IDLocalidad inner JOIN Provincias pr on loc.IDProvincia=pr.IDProvincia WHERE m.Pagada=0 and pr.Provincia='Buenos Aires'

-- 11
-- Listar el ID de la multa, la patente, el monto y el importe de referencia a partir del tipo de infracción cometida. También incluir una columna llamada TipoDeImporte a partir de las siguientes condiciones:
-- 'Punitorio' si el monto de la multa es mayor al importe de referencia
-- 'Leve' si el monto de la multa es menor al importe de referencia
-- 'Justo' si el monto de la multa es igual al importe de referencia

SELECT m.IdMulta, m.Patente, m.Monto, ti.ImporteReferencia,
case
when m.Monto>ti.ImporteReferencia then 'Punitorio'
when m.Monto<ti.ImporteReferencia then 'Leve'
when m.Monto=ti.ImporteReferencia then 'Justo'
end as TipoImporte 
FROM Multas m INNER JOIN TipoInfracciones ti on m.IdTipoInfraccion=ti.IdTipoInfraccion



--------------------------------------------------------------------------------------


-- Por cada producto listar la descripción del producto, el precio y el nombre de la categoría a la que pertenece.
SELECT
    p.Descripcion,
    p.Precio,
    c.Nombre
from Productos p
INNER join Categorias c on p.IDCategoria=c.ID

-- Listar las categorías de producto de las cuales no se registren productos.
SELECT
    c.Nombre as Categorias,
    p.IDCategoria
from Categorias c
left JOIN Productos p on c.ID=p.IDCategoria
where p.ID is NULL 

SELECT
    c.Nombre as Categorias,
    p.IDCategoria
from Productos p
RIGHT JOIN Categorias c on c.ID=p.IDCategoria
where p.ID is NULL 


-- Listar el nombre de la categoría de producto de aquel o aquellos productos que más tiempo lleven en construir.
SELECT top 3
    c.Nombre as Categorias,
    p.DiasConstruccion
from Categorias c
INNER JOIN Productos p on c.ID=p.IDCategoria
ORDER by p.DiasConstruccion desc

-- Listar apellidos y nombres y dirección de mail de aquellos clientes que no hayan registrado pedidos.

    select
        c.Apellidos,
        c.Nombres,
        c.Mail,
        p.ID
    from Clientes c
    LEFT join Pedidos p on c.ID=p.IDCliente
    where p.ID is null

-- Listar apellidos y nombres, mail, teléfono y celular de aquellos clientes que hayan realizado algún pedido cuyo costo supere $1000000
    SELECT 
        c.Apellidos,
        c.Nombres,
        c.Mail,
        c.Telefono, 
        c.Celular,
        p.Costo
    from Clientes  c
    INNER JOIN Pedidos p on c.ID=p.IDCliente
    WHERE p.Costo>1000000

-- Listar IDPedido, Costo, Fecha de solicitud y fecha de finalización, descripción del producto, costo y apellido y nombre del cliente.
--Sólo listar aquellos registros de pedidos que hayan sido pagados.
    SELECT
        p.ID,
        p.Costo,
        p.FechaSolicitud,
        p.FechaFinalizacion,
        pr.Descripcion,
        pr.Costo as CostoProducto,
        c.Apellidos,
        c.Nombres,
        p.Pagado
    from Pedidos p
    inner JOIN Productos pr on p.IDProducto=pr.ID
    INNER join Clientes c on p.IDCliente=c.ID
    where p.Pagado=1

-- Listar IDPedido, Fecha de solicitud, fecha de finalización, días de construcción del producto, días de construcción del pedido 
--(fecha de finalización - fecha de solicitud) y una columna llamada Tiempo de construcción con la siguiente información:
-- 'Con anterioridad' → Cuando la cantidad de días de construcción del pedido sea menor a los días de construcción del producto.
-- 'Exacto'' → Si la cantidad de días de construcción del pedido y el producto son iguales
-- 'Con demora' → Cuando la cantidad de días de construcción del pedido sea mayor a los días de construcción del producto.

SELECT 
    pe.ID,
    pe.FechaSolicitud,
    pe.FechaFinalizacion,
    pr.DiasConstruccion,
    DATEDIFF(DAY, pe.FechaSolicitud, pe.FechaFinalizacion) DiasContruccionPedido,
    case 
    when DiasConstruccion>pr.DiasConstruccion then 'Con anterioridad'
    when DiasConstruccion=pr.DiasConstruccion then 'Exacto'
    when DiasConstruccion<pr.DiasConstruccion then 'Con demora'
    end as TiempoConstruccion
FROM Pedidos pe
inner join Productos pr on pe.IDProducto=pr.ID


-- Listar por cada cliente el apellido y nombres y los nombres de las categorías de aquellos productos de los cuales hayan realizado pedidos.
--No deben figurar registros duplicados.

select distinct
C.Apellidos,
C.Nombres,
ca.Nombre
from Clientes c
inner join Pedidos ped on c.ID=ped.IDCliente
inner join Productos pe on ped.IDProducto=pe.ID
INNER JOIN Categorias ca on ca.ID=pe.IDCategoria


-- Listar apellidos y nombres de aquellos clientes que hayan realizado algún pedido cuya cantidad sea exactamente igual a la cantidad considerada
--mayorista del producto.
SELECT
    c.Apellidos,
    c.Nombres
    --pe.Cantidad,
    --pr.CantidadMayorista
from clientes c
inner join Pedidos pe on c.ID=pe.IDCliente
inner join Productos pr on pe.IDProducto=pr.ID
where pe.Cantidad=pr.CantidadMayorista
-- Listar por cada producto el nombre del producto, el nombre de la categoría, el precio de venta minorista, el precio de venta mayorista y
--el porcentaje de ahorro que se obtiene por la compra mayorista a valor mayorista en relación al valor minorista.

SELECT 
    pr.Descripcion,
    c.Nombre,
    pr.Precio,
    pr.PrecioVentaMayorista,
    pr.CantidadMayorista,
    100-((pr.PrecioVentaMayorista*100)/pr.Precio) as PorcentajeAhorro
from Productos pr
inner join Categorias c on pr.IDCategoria=c.ID