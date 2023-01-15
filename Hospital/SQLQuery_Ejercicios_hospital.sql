---CONSULTAS DE SELECCION
--2. Mostrar el apellido, oficio, salario, salario anual, 
--con las dos extras () para aquellos empleados con comisión mayor de 100.000.
select * from Emp
select e.Apellido,e.Oficio,e.Salario, e.Salario*14 as anual from Emp e where e.Comision > 100000


--3. Idéntico del anterior, pero para aquellos empleados que su salario anual con extras supere los 2200000
select e.Apellido,e.Oficio,e.Salario, e.Salario*14 as anual from Emp e where e.Salario*14 >220000

--4. Idéntico del anterior, pero para aquellos empleados que sumen entre salario anual con extras y comisión los 3 millones.
select e.Apellido,e.Oficio,e.Salario, e.Salario*14 as anual from Emp e where e.Salario*14+e.Salario >3000000

--5. Mostrar todos los datos de empleados ordenados por departamento 
--y dentro de este por oficio para tener una visión jerárquica.
select * from Emp e order by e.Dept_No, e.Oficio

--6. Mostrar todas las salas para el hospital 45.
select * from Sala where Hospital_Cod=45

--7. Mostrar todos los enfermos nacidos antes de 1970.
select * from Enfermo where Fecha_Nac < ('1970-1-1')		 --year (Fecha_Nac)<1970 MAL

--8. Igual que el anterior, para los nacidos antes de 1970 ordenados por número de inscripción descendente
select * from Enfermo where Fecha_Nac < ('1970-1-1') ORDER BY Inscripcion DESC

--9. Listar todos los datos de la plantilla del hospital del turno de mañana
select * from Plantilla where T like 'M'
--10. Idem del turno de noche.
SELECT * FROM Plantilla where T='N'

--11. Visualizar los empleados de la plantilla del turno de mañana que tengan un salario entre 200000 y 225000.
select * from Plantilla where T='M' AND Salario between 200000 and 225000
--12. Visualizar los empleados de la tabla emp que no se dieron de alta entre el 01/01/80 y el 12/12/82

select * from  Emp where not Fecha_Alt between '1980/01/01' and '1981-12-12'

--13. Mostrar los nombres de los departamentos situados en Madrid o en Barcelona.
select * from Dept
select d.DNombre from Dept d where d.Loc LIKE  'BARCELONA' OR D.Loc='MADRID'
select d.DNombre from Dept d where d.Loc = 'BARCELONA' OR D.Loc='MADRID'
--14. Mostrar aquellos empleados con fecha de alta posterior al 1 de Julio de 1985.
SELECT * FROM Emp where Fecha_Alt> '1985-7-1'

--15. Lo mismo que en el ejercicio 14 pero con salario entre 150000 y 400000.
SELECT * FROM Emp where Fecha_Alt> '1985-7-1' and Salario between 150000 and 400000
--16. Igual que en el ejercicio 15, pero también incluimos aquellos que no siendo analista pertenecen al departamento 20.
SELECT * FROM Emp where Fecha_Alt> '1985-7-1' and Salario between 150000 and 400000 OR (Oficio <> 'ANALISTA' AND Dept_No = 20) 
--17. Mostrar aquellos empleados cuyo apellido termine en ‘Z’ ordenados por departamento, 
--y dentro de este por antigüedad.
SELECT * FROM Emp E WHERE E.Apellido LIKE '%Z' ORDER BY Dept_No, Fecha_Alt Asc
--18. De los empleados del ejercicio 17 quitar aquellos que superen los 200000 mensuales.
SELECT * FROM Emp E WHERE e.Salario >200000 and E.Apellido LIKE '%Z' ORDER BY Dept_No, Fecha_Alt Asc 


--19. Mostrar todos los empleados cuyo oficio no sea analista.
select * from Emp where Oficio <> 'ANALISTA'
--20. Igual que el ejercicio 19, pero mostrándolos de forma que se aprecien las diferencias de salario dentro de cada oficio.
select * from Emp where Oficio <> 'ANALISTA'
ORDER BY Oficio , salario desc
--21. Del ejercicio 20, nos quedamos solo con aquellos cuyo número de empleado no este entre 7600 y 7900.
select * from Emp where Oficio <> 'ANALISTA' and Emp_No not between 7600 and 7900
ORDER BY Oficio , salario desc

--22. Mostrar los distintos oficios de los empleados.
select distinct e.Oficio from Emp e
--23. Mostrar los distintos nombres de sala.
select distinct s.Nombre from Sala s
--24. Mostrar que personal “No Interino” existe en cada sala de cada hospital, ordenado por hospital y sala.
select * from Sala
select * from Plantilla where Funcion <>'INTERINO' ORDER BY Hospital_Cod, Sala_Cod ASC

--25. Justificar el resultado de la siguiente consulta SELECT APELLIDO DISTINCT DEPT_NO FROM EMP
--Indicar que ocurre y modificarla para que todo vaya bien.
SELECT DISTINCT APELLIDO, DEPT_NO FROM EMP
--26. Seleccionar los distintos valores del sexo que tienen los enfermos.
select distinct e.S from Enfermo e

--27. Indicar los distintos turnos de la plantilla del hospital, ordenados por turno y por apellido.
select distinct p.T as turno, p.Apellido as apellido from Plantilla p order by p.T, p.Apellido asc

--28. Seleccionar las distintas especialidades que ejercen los médicos, ordenados por especialidad y apellido.
select distinct d.Especialidad, d.Apellido from Doctor d order by d.Especialidad, d.Apellido


---STORE PROCEDURE
--1) Sacar todos los empleados que se dieron de alta entre una determinada fecha inicial 
--y fecha final y que pertenecen a un determinado departamento.


go
alter PROCEDURE obtener_empleados_por_fecha_y_departamento
(@fecha_inicial DATEtime, 
@fecha_final DATEtime, 
@departamento int
)
as
BEGIN
    -- Seleccionar todos los empleados que cumplan con los criterios especificados
    SELECT * FROM emp
    WHERE fecha_alt BETWEEN @fecha_inicial AND @fecha_final
    AND Dept_No= @departamento;
END
--Prueba
EXEC obtener_empleados_por_fecha_y_departamento '01/01/1965','01/01/1985',20		



--2) Crear procedimiento que inserte un empleado. 
go
ALTER PROCEDURE insertar_empleado
(@EMP_NO INT,
@Apellido VARCHAR (50),
@Oficio VARCHAR (50), 
@Dir INT,
@Fecha_Alt SMALLDATETIME,
@Salario NUMERIC(9,2),
@Comision NUMERIC(9,2) ,
@Dept_No INT
)
as
BEGIN

INSERT INTO emp (EMP_NO,Apellido, Oficio, Dir, Fecha_Alt,Salario,Comision,Dept_No)
VALUES (@EMP_NO, @Apellido, @Oficio, @Dir, @Fecha_Alt,@Salario,@Comision,@Dept_No)

END
--Prueba
EXEC insertar_empleado 7895,'SUAREZ','EMPLEADO',0,'26/05/2015',16000,0,20

SELECT * FROM EMP

--3) Crear un procedimiento que recupere el nombre, número y número de personas a partir del número de departamento.

go
CREATE PROCEDURE NUMEMP_DEPT
(@numero_departamento SMALLINT)
AS
begin

 select  
   d.DNombre,
   count (e.Dept_No) as 'Numero de Personas',
   e.Dept_No
   from Emp e
			inner join Dept d on d.Dept_No=e.Dept_No
			 where e.Dept_No= @numero_departamento
			group by e.Dept_No, d.DNombre
  
 
   
END
--Prueba
exec NUMEMP_DEPT 20
select * from Dept 
select * from Emp where Dept_No=10


--4) Crear un procedimiento igual que el anterior, 
--pero que recupere también las personas que trabajan en dicho departamento, pasándole como parámetro el nombre.
go
CREATE PROCEDURE PERSONADEPT
(
@nombredepto VARCHAR(30))
AS
begin

 select  
   d.Dept_No,
   d.DNombre,
   e.Apellido,
   count (e.Dept_No) as 'Numero total de Personas'
    from Emp e
			inner join Dept d on d.Dept_No=e.Dept_No
			 where d.DNombre= @nombredepto
			group by d.Dept_No,d.DNombre, e.Apellido 
  
 
   
END
--Prueba
EXEC PERSONADEPT 'CONTABILIDAD'

select * from Emp where Dept_No=10
--5) Crear procedimiento para devolver salario, oficio y comisión, pasándole el apellido.
select * from Plantilla
select * from Dept
select * from Emp
go
create procedure Oficio_Por_APELLIDO (
@Apellido varchar (50)
)
as 
begin
		select 
		e.Salario,
		e.Oficio,
		e.Comision
		from Emp e
		where e.Apellido=@Apellido
			   		 	  
end
--Prueba
exec Oficio_Por_APELLIDO 'Rey'
--6) Igual que el anterior, pero si no le pasamos ningún valor, mostrará los datos de todos los empleados
--que empiezan con letra A.
go
ALTER procedure Oficio_Por_APELLIDO (
@Apellido varchar (50)='a%'
)
as 
begin
		select
		e.Apellido,
		e.Salario,
		e.Oficio,
		e.Comision
		from Emp e
		where e.Apellido like @Apellido
		
end
--Prueba
exec Oficio_Por_APELLIDO 
----------
--6 BIS) Igual que el anterior, pero si no le pasamos ningún valor, mostrará los datos de todos los empleados


go
CREATE PROCEDURE OFICIOSALARIO
@PAPELLIDO NVARCHAR(20) ='%' AS
SELECT OFICIO, SALARIO, COMISION FROM EMP WHERE APELLIDO LIKE @PAPELLIDO

--Prueba
EXEC OFICIOSALARIO 
drop procedure OFICIOSALARIO

--7) Crear un procedimiento para mostrar el salario, oficio, apellido
--y nombre del departamento de todos los empleados que contengan en su apellido el valor
--que le pasemos como parámetro.

GO
CREATE PROCEDURE MOSTRAR_SALARIO (
@apellido varchar (50)
)
AS
BEGIN
		select 
		e.Salario,
		e.Oficio,
		e.Apellido,
		d.DNombre as 'Nombre departamento'
		from Emp e
		inner join Dept d on d.Dept_No=e.Dept_No
		where e.Apellido like '%'+@apellido+'%'

END
--Prueba
exec MOSTRAR_SALARIO 'r'

--7 bis mostrar el apellido, salario,oficio y nombre del departamento de todos los empleados aunque No tengan departamento debo mostrar un mensaje no tiene departamento

CREATE PROCEDURE EMPLEADOS_DEPT
AS
SELECT Apellido, Salario, Oficio, ISNULL(D.DNombre, 'No tiene departamento') AS Nombre_Dept
FROM EMP AS E
LEFT JOIN DEPT AS D
ON E.DEPT_NO = D.DEPT_NO


--8. Obtener todos los empleados que se dieron de alta antes del año 2018 y que
--pertenecen a un determinado departamento.
select * from Plantilla
select * from Dept
select * from Emp
--solucion
go
delete procedure EmpXdept_antes_2018
(
@Depto int
)

as
begin
	select 
	e.Apellido
	from Emp e
	where e.Dept_No=@Depto
	--inner join Dept d on d.Dept_No=e.Dept_No
	--where d.DNombre=@Depto


end 
--Prueba
exec emEmpXdept_antes_2018 20


--Otra opcion de 1981
alter procedure empleados
as
SELECT Emp.Apellido, Emp.Fecha_Alt, Dept.Loc
FROM Emp INNER JOIN
Dept ON Emp.Dept_No = Dept.Dept_No
where Fecha_Alt like '%1981%'

--Prueba
exec empleados

---9. Crear un procedimiento almacenado que permita insertar un nuevo
--departamento.
select * from Dept
go
create procedure Nuevo_Depto
(@Dept_No int, 
@DNombre varchar (50),
@Loc varchar(50)
)
as
begin
		insert into Dept (Dept_No,DNombre,Loc)
		values (@Dept_No,@DNombre,@Loc)
end

--OPCION 2
go
create procedure Nuevo_Depto
(@Dept_No int, 
@DNombre varchar (50),
@Loc varchar(50)
)
as
begin
		insert into Dept values (@Dept_No,@DNombre,@Loc)
end

--solucion
exec Nuevo_Depto 50,'SEGURIDAD','BUENOS AIRES'
--ELIMINANDO FILA AGREGADA
DELETE FROM Dept WHERE Dept_No=50


--10. Crear un procedimiento que recupere el promedio de antiguedad de las personas por
--cada departamento.
select * from Emp
-- primero obtengo la edad de cada empleado y su promedio agrupando por departamento
select d.DNombre as Departamento, avg(DATEDIFF(year,e.Fecha_Alt,getdate())) as 'Promedio antiguedad' from Emp e 
inner join   Dept d on d.Dept_No= e.Dept_No
group by d.DNombre
---luego creo el procedimiento
go
create procedure Prom_Emp_Antigue
as
begin
select d.DNombre as Departamento, avg(DATEDIFF(year,e.Fecha_Alt,getdate())) as 'Promedio antiguedad' from Emp e 
inner join   Dept d on d.Dept_No= e.Dept_No
group by d.DNombre

end 
---prueba
exec Prom_Emp_Antigue
--11. Crear un procedimiento para devolver el apellido, oficio y salario, pasándole
--como parámetro el número del empleado.
select * from Emp

-- solucion
go
create procedure Datos_Emple_Xnum
(@Emp_No int
)
as
begin
	select e.Apellido,e.Oficio, e.Salario from Emp e 
	where e.Emp_No=@Emp_No

end

--prueba
exec Datos_Emple_Xnum 7119

--12. Crear un procedimiento almacenado para dar de baja a un empleado
---pasándole como parámetro su apellido
go
create procedure Eliminar_Emp
(@Apellido varchar (50)
)
as
begin
	delete from Emp where Apellido= @Apellido

end

--prueba
select * from Emp
exec Eliminar_Emp MUÑOZ
INSERT INTO Emp values (7934,	'MUÑOZ',	'EMPLEADO',	7782,1982/06/23 ,	169000.00,	0.00,	10)
