//Creación de la tabla departamentos 

CREATE TABLE Departamentos (
    id_departamento NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    descripcion VARCHAR2(200)
);

//Creación de la tabla para control de empleados

CREATE TABLE Empleados (
    id_empleado NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    apellidos VARCHAR2(100),
    fecha_nacimiento DATE,
    provincia VARCHAR2(100),
    canton VARCHAR2(100),
    distrito VARCHAR2(100),
    direccion VARCHAR2(200),
    telefono VARCHAR2(20),
    email VARCHAR2(100),
    fecha_contratacion DATE,
    salario NUMBER(10,2),
    cargo VARCHAR2(100),
    id_departamento NUMBER,
    id_supervisor NUMBER,
    CONSTRAINT fk_supervisor FOREIGN KEY (id_supervisor) REFERENCES Empleados(id_empleado),
    CONSTRAINT fk_departamento FOREIGN KEY (id_departamento) REFERENCES Departamentos(id_departamento)
);

//Creación de la tabla del historial laboral del empleado

CREATE TABLE Historial_laboral (
    id_historial NUMBER PRIMARY KEY,
    id_empleado NUMBER,
    empresa VARCHAR2(100),
    cargo VARCHAR2(100),
    caracteristicas_empleo VARCHAR(500),
    CONSTRAINT fk_historial_empleado FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);


// Creación de la tabla para el control de nóminas y beneficios

CREATE TABLE Nomina (
    id_nomina NUMBER PRIMARY KEY,
    id_empleado NUMBER,
    fecha_pago DATE,
    salario NUMBER(10,2),
    bonificaciones NUMBER(10,2),
    deducciones NUMBER(10,2),
    beneficios_adicionales NUMBER(10,2),
    CONSTRAINT fk_nomina_empleado FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

//Creación de la tabla para el control de Evaluación y Desempeño de los empleados

CREATE TABLE Evaluacion (
    id_evaluacion NUMBER PRIMARY KEY,
    id_empleado NUMBER,
    fecha_evaluacion DATE,
    resultado_evaluacion VARCHAR2(200),
    CONSTRAINT fk_desempeno_empleado FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado)
);

//Creación de la tabla para el manejo de las capacitaciones y desarrollo profesional

CREATE TABLE Capacitacion (
    id_capacitacion NUMBER PRIMARY KEY,
    nombre_curso VARCHAR2(100),
    fecha_inicio DATE,
    fecha_fin DATE,
    descripcion VARCHAR2(200)
);

//Creación de la tabla de registro de capacitaciones

CREATE TABLE Registro_Capacitacion (
    id_empleado NUMBER,
    id_capacitacion NUMBER,
    nota_final NUMBER(5,2),
    PRIMARY KEY (id_empleado, id_capacitacion),
    CONSTRAINT fk_empleado_capacitacion_empleado FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
    CONSTRAINT fk_empleado_capacitacion_capacitacion FOREIGN KEY (id_capacitacion) REFERENCES Capacitacion(id_capacitacion)
);

//Creación de la tabla para las vacantes disponibles

CREATE TABLE Vacantes (
    id_vacante NUMBER PRIMARY KEY,
    titulo VARCHAR2(100),
    descripcion VARCHAR2(200),
    fecha_publicacion_vacante DATE,
    fecha_cierre_vacante DATE
);

//Tabla para auditar los cambios en laas tablas

CREATE TABLE Auditoria(
    id_auditoria NUMBER PRIMARY KEY,
    fecha DATE,
    tipo VARCHAR2(50),
    descripcion VARCHAR2(500),
    persona VARCHAR2(60)
);


/*
Procedimientos almacenados para facilitar la inserción de datos
y evitar la inyección SQL
*/

CREATE OR REPLACE PROCEDURE InsertarEmpleado(
    nombre IN VARCHAR2,
    apellidos IN VARCHAR2,
    fecha_nacimiento IN DATE,
    provincia IN VARCHAR2,
    canton IN VARCHAR2,
    distrito IN VARCHAR2,
    direccion IN VARCHAR2,
    telefono IN VARCHAR2,
    email IN VARCHAR2,
    fecha_contratacion IN DATE,
    salario IN NUMBER,
    cargo IN VARCHAR2,
    id_departamento IN NUMBER,
    id_supervisor IN NUMBER DEFAULT NULL
)
IS
BEGIN
    INSERT INTO Empleados(
        id_empleado,
        nombre,
        apellidos,
        fecha_nacimiento,
        provincia,
        canton,
        distrito,
        direccion,
        telefono,
        email,
        fecha_contratacion,
        salario,
        cargo,
        id_departamento,
        id_supervisor
    ) VALUES(
        Empleados_seq.NEXTVAL,
        nombre,
        apellidos,
        fecha_nacimiento,
        provincia,
        canton,
        distrito,
        direccion,
        telefono,
        email,
        fecha_contratacion,
        salario,
        cargo,
        id_departamento,
        id_supervisor
    );
    COMMIT;
END InsertarEmpleado;
/


CREATE OR REPLACE PROCEDURE InsertarCapacitacion (
    p_id_capacitacion IN NUMBER,
    p_nombre_curso IN VARCHAR2,
    p_fecha_inicio IN DATE,
    p_fecha_fin IN DATE,
    p_descripcion IN VARCHAR2
)
IS
BEGIN
    INSERT INTO Capacitacion (id_capacitacion, nombre_curso, fecha_inicio, fecha_fin, descripcion)
    VALUES (p_id_capacitacion, p_nombre_curso, p_fecha_inicio, p_fecha_fin, p_descripcion);
    
    COMMIT;
END InsertarCapacitacion;
/


//Autoincremental el valor del id en las tablas
CREATE SEQUENCE Empleados_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE Auditoria_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;


//Inserción en la tabla de empleados por medio del procedimiento almacenado
BEGIN
    InsertarEmpleado(
        'Esteban',
        'Navarro',
        TO_DATE('2003-07-22', 'YYYY-MM-DD'),
        'Puntarenas',
        'Coto Brus',
        'San Vito',
        'Barrio Tres Rios',
        '83322654',
        'esteban.navarro@gmail.com',
        TO_DATE('2023-05-10', 'YYYY-MM-DD'),
        800000,
        'Empleado',
        1, -- ID del departamento
        NULL -- ID del supervisor (opcional)
    );
END;
/

//Trigger para llevar el control de los registros nuevos ingresados
CREATE OR REPLACE TRIGGER insercion_empleado
BEFORE INSERT ON Empleados
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria(id_auditoria, fecha, tipo, descripcion, persona) VALUES
    (Auditoria_seq.NEXTVAL, SYSDATE, 'Nuevo', 'Se contrato un nuevo empleado: ' || :NEW.nombre, NULL);
END;
/

//Vistas para facilitar acceso a la información

CREATE VIEW empleados_informatica AS 
SELECT COUNT(*) AS Total_Empleados FROM Empleados WHERE id_departamento = 1;

CREATE VIEW empleados_departamento AS
SELECT e.nombre AS nombre_empleado, e.salario, d.nombre AS nombre_departamento
FROM empleados e
JOIN departamentos d ON e.id_departamento = d.id_departamento;



ALTER TABLE nombre_tabla ENABLE CONSTRAINT nombre_restriccion;

select * from empleados_departamento;
