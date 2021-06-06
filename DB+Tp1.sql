
-- Tienda de ropa negocioWebRopa
drop database if exists negocioWebRopa;
create database negocioWebRopa;
use negocioWebRopa;


drop table if exists detalles;
drop table if exists articulos;
drop table if exists facturas;
drop table if exists clientes;


create table clientes(
	id int auto_increment primary key,
	nombre varchar(20) not null,
	apellido varchar(20) not null,
	edad int,
	direccion varchar(50),
	email varchar(30),
	telefono varchar(25),
	tipoDocumento enum('DNI','LIBRETA_CIVICA','LIBRETA_ENROLAMIENTO','PASS'),
	numeroDocumento char(8)
);

alter table clientes 
	add constraint CK_clientes_edad
    check (edad>=18 and edad<=120); 

alter table clientes
	add constraint U_clientes_TipoNumero
	unique(tipoDocumento,numeroDocumento);

create table facturas(
	id int auto_increment primary key,
	letra enum('A','B','C'),
	numero int,
    fecha date,
	medioDePago enum('EFECTIVO','DEBITO','TARJETA'),
 	idCliente int not null
);

-- creamos la restriccion FK facturas idCliente
alter table facturas
	add constraint FK_facturas_idCliente
    foreign key(idCliente)
    references clientes(id);

alter table facturas
	add constraint CK_facturas_numero
    check (numero>0);

/*
alter table facturas
	add constraint CK_facturas_fecha
	check (fecha >= (current_date()-5) and fecha<= current_date());
*/

alter table facturas 
	add constraint U_facturas_LetraNumero
    unique(letra,numero);

create table articulos(
	id int auto_increment primary key,
	descripcion varchar(25) not null,
	tipo enum('CALZADO','ROPA'),
	color varchar(20),
	talle_num varchar(20),
	stock int,
    stockMin int,
    stockMax int,
    costo double,
    precio double,
	temporada enum('VERANO','OTOÑO','INVIERNO')
);

alter table articulos
	add constraint CK_articulos_stock
    check (stock>=0);

alter table articulos
	add constraint CK_articulos_stockMin
    check (stockMin>0);
    
alter table articulos
	add constraint CK_articulos_stockMax
    check (stockMax>=stockMin);
    
alter table articulos
	add constraint CK_articulos_costo
    check (costo>=0);

alter table articulos
	add constraint CK_articulos_precio
    check (precio>=costo);
 
create table detalles(
	id int auto_increment primary key,
	idArticulo int not null,
	idFactura int not null,
	precio double,
	cantidad int
);

alter table detalles
	add constraint U_detallesIdArtIdFact
    unique(idArticulo,idFactura);

alter table detalles
	add constraint U_detalles_precio
    check(precio>=0);   
   
alter table detalles
	add constraint U_detalles_cantidad
    check(cantidad>=0);
   
alter table detalles
	add constraint FK_detalles_Articulos
    foreign key(idArticulo)
   	references articulos(id);
   
alter table detalles
	add constraint FK_detalles_Facturas
    foreign key(idFactura)
   	references facturas(id); 
   

-- Import Insert

LOCK TABLES `articulos` WRITE;
/*!40000 ALTER TABLE `articulos` DISABLE KEYS */;
INSERT INTO `articulos` VALUES 
(1,'Remera','ROPA','negro','large',15,10,50,100,120,'VERANO'),
(2,'Remera Lisa Jersey ','ROPA','azul','large',8,5,50,300,450,'OTOÑO'),
(3,'Chomba Pique ','ROPA','rojo','small',9,5,50,400,600,'OTOÑO'),
(4,'Musculosa Deportiva','ROPA','blanco','XXL',6,2,20,300,450,'VERANO'),
(5,'Remera Lisa Jersey','ROPA','negro','large',6,5,50,300,450,'OTOÑO'),
(6,'Remera Lisa Jersey','ROPA','negro','small',7,5,50,300,450,'OTOÑO'),
(7,'Chomba Pique','ROPA','azul','small',6,5,50,400,600,'OTOÑO'),
(8,'Remera Lisa Jersey','ROPA','rosa','XXL',7,5,50,300,450,'OTOÑO'),
(9,'Remera Lisa Jersey','ROPA','verde','small',7,5,50,300,450,'OTOÑO'),
(10,'Remera','ROPA','rojo','1',5,20,40,10,12,'VERANO');
/*!40000 ALTER TABLE `articulos` ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES 
(1,'Fernando','Acme',34,'lima 222','intercrios@hotmail.com','23232312','DNI','12345678'),
(2,'Teofilo','GarciaLasca',43,'lima 222','lawlercarlospatricio@gmail.com','23232312','DNI','23567898'),
(3,'Coyote','Acme',34,'lima 222','c.rios@bue.edu.ar','23232312','DNI','12345679'),
(4,'Graciela','Meza',18,'lima 222','intercrios@hotmail.com','23232312','DNI','11111111'),
(5,'Juan ','Gomez',21,'medrano 165','gomez@gmail.com','33333333','DNI','88888888'),
(6,'Laura','Rojas',19,'medrano 165','rojas@gmail.com','77777777','DNI','77777777');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

insert into facturas (letra,numero,fecha,medioDePago,idCliente) values
('A',1,curdate(),'EFECTIVO',1);
insert into facturas (letra,numero,fecha,medioDePago,idCliente) values
('A',4,curdate(),'EFECTIVO',1);
insert into facturas (letra,numero,fecha,medioDePago,idCliente) values
('A',5,curdate(),'EFECTIVO',1);
insert into detalles (idArticulo,idFactura,precio,cantidad) values
(2,3,100,2);

insert into detalles (idArticulo,idFactura,precio,cantidad) values
(1,1,100,2),
(2,1,200,1);

 
-- ELiminamos el campo edad en clientes y agregamos el campo fenaci en clientes.

 alter table clientes drop edad;
 alter table clientes add fenaci date after apellido;

update clientes set fenaci='1980/06/02' where id=1;
update clientes set fenaci='1992/10/12' where id=2;
update clientes set fenaci='1999/03/03' where id=3;
update clientes set fenaci='1999/12/24' where id=4;
update clientes set fenaci='2002/06/02' where id=5;
update clientes set fenaci='2001/01/01' where id=6;



/*
	Trabajo 1
    
    Crear los siguientes store procedures para la base negocioWebRopa
    
    - Tabla articulos
		SP_Articulos_Insert_Min
        SP_Articulos_Insert_Full
        SP_Articulos_Delete
        SP_Articulos_Update
        SP_Articulos_All
        SP_Articulos_Reponer
        
	- Tabla facturas
		SP_Facturas_Insert
        SP_Facturas_Delete
        SP_Facturas_Update
		SP_Facturas_All
		SP_Facturas_AgregarDetalle
        
	- Tabla detalles
		SP_Detalles_Delete
		SP_Detalles_All

*/


-- **********************************
-- Procedures para la tabla articulos

    

drop procedure if exists SP_Articulos_Insert_Min;
drop procedure if exists SP_Articulos_Insert_Full;
drop procedure if exists SP_Articulos_Delete;
drop procedure if exists SP_Articulos_Update;
drop procedure if exists SP_Articulos_Reponer;


delimiter //
create procedure SP_Articulos_Insert_Min (in Pdescripcion varchar(25))
begin
	insert into articulos (descripcion) values (Pdescripcion);
end
// delimiter ;



delimiter //
create procedure SP_Articulos_Insert_Full (in 
    Pdescripcion varchar(25),
	Ptipo varchar(20),
	Pcolor varchar(20),
	Ptalle_num varchar(20),
	Pstock int,
    PstockMin int,
    PstockMax int,
    Pcosto double,
    Pprecio double,
	Ptemporada varchar(20))
begin
	insert into articulos 
		(descripcion,tipo,color,talle_num,stock,stockMin,stockMax,costo,precio,temporada)
        values 
       (Pdescripcion,Ptipo,Pcolor,Ptalle_num,Pstock,PstockMin,PstockMax,Pcosto,Pprecio,Ptemporada);
end
// delimiter ;

delimiter //
create procedure SP_Articulos_Delete (in Pid int)
begin
	delete from articulos where id=Pid;
end
// delimiter ;



delimiter //
create procedure SP_Articulos_Update (in 
	 
	Pdescripcion varchar(25),
	Ptipo varchar(20),
	Pcolor varchar(20),
	Ptalle_num varchar(20),
	Pstock int,
    PstockMin int,
    PstockMax int,
    Pcosto double,
    Pprecio double,
	Ptemporada varchar(20),
    Pid int)
begin
	update articulos set 
			descripcion=Pdescripcion,
			tipo=Ptipo,
			color=Pcolor,
			talle_num=Ptalle_num,
			stock=Pstock,
			stockMin=PstockMin,
			stockMax=PstockMax,
			costo=Pcosto,
			precio=Pprecio,
			temporada=Ptemporada
	where id=Pid;
end
// delimiter ;

delimiter //
create procedure SP_Articulos_All()
begin
	select id idArticulo, descripcion,tipo,color,talle_num,stock,stockMin,stockMax,costo,precio,temporada from articulos;
end
// delimiter ;


delimiter //
create procedure SP_Articulos_Reponer()
begin
	select id idArticulo, descripcion,tipo,color,talle_num,stock,stockMin,stockMax,costo,precio,temporada from articulos
    where stock<stockMin;
end
// delimiter ;


call SP_Articulos_Insert_Min('Buso');
call SP_Articulos_Insert_Full('Buso','Ropa','verde','small',5,15,30, 200,300,'OTOÑO');
call SP_Articulos_Delete(3);
call SP_Articulos_Update('Buso','Ropa','rojo','small',5,15,30, 200,300,'OTOÑO',12);
call SP_Articulos_All();
call SP_Articulos_Reponer();

select*from articulos;


-- **********************************
-- Procedures para la tabla facturas

drop procedure if exists SP_Facturas_Insert;
drop procedure if exists SP_Facrutas_Delete;
drop procedure if exists SP_Facturas_Update;
drop procedure if exists SP_Facturas_All;
drop procedure if exists SP_Facturas_AgregarDetalle;
select * from facturas;
		

delimiter //
create procedure SP_Facturas_Insert (in 
    Pletra char,
	Pnumero int,
    Pfecha date,
	PmedioDePago varchar(10),
 	PidCliente int)
begin
	insert into facturas
		(letra, numero, fecha, medioDePago, idCliente)
        values 
       (Pletra, Pnumero, Pfecha, PmedioDePago, PidCliente);
end
// delimiter ;

delimiter //
create procedure SP_Facrutas_Delete (in Pid int)
begin
	delete from facturas where id=Pid;
end
// delimiter ;


delimiter //
create procedure SP_Facturas_Update (in 
	Pid int, 
	Pletra char,
	Pnumero int,
    Pfecha date,
	PmedioDePago varchar(10),
 	PidCliente int)
begin
	update facturas set 
		letra=Pletra,
		numero=Pnumero,
		fecha=Pfecha,
		medioDePago=PmedioDePago,
		idCliente=PidCliente
	where id=Pid;
end
// delimiter ;

delimiter //
create procedure SP_Facturas_All()
begin
	select id idFacturas, letra, numero, fecha, medioDePago, idCliente from facturas;
end
// delimiter ;

delimiter //
create procedure SP_Facturas_AgregarDetalle(in
	    PidArticulo int,  
		PidFactura int, 
        Pprecio double, 
        Pcantidad int
        )
begin
    insert into detalles (idArticulo, idFactura, precio, cantidad) 
		   values (PidArticulo, PidFactura, Pprecio, Pcantidad);
end;

// delimiter ;

call SP_Facturas_Insert('A',2,curdate(),'EFECTIVO',2);
call SP_Facturas_Update(2,'A',4, curdate(),'DEBITO',1);
call SP_Facrutas_Delete(2);
call SP_Facturas_All();
call SP_Facturas_AgregarDetalle(1,3,200,3);
select*from facturas;

-- **********************************
-- Procedures para la tabla detalles



drop procedure if exists SP_Detalles_All_Factura;
drop procedure if exists SP_Detalles_Delete_Factura;
drop procedure if exists SP_Detalles_All;
			
        
delimiter //
create procedure SP_Detalles_All_Factura(in PidFactura int)
begin
	select idArticulo,precio,cantidad from detalles where idFactura = PidFactura;
end
// delimiter ;


delimiter //
create procedure SP_Detalles_Delete_Factura(in PidFactura int)
begin
	delete from detalles where idFactura = PidFactura;
end
// delimiter ;


delimiter //
create procedure SP_Detalles_All()
begin
	select * from detalles; 
end
// delimiter ;



call SP_Detalles_All_Factura(1);
call SP_Detalles_Delete_Factura(1);
call SP_Detalles_All();

select * from detalles;



   


