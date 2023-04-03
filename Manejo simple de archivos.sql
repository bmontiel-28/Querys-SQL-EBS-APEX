--Creacion de archivo
DECLARE
    VA_ARCHIVO_DEF UTL_FILE.FILE_TYPE;
    NOMBRE_ARCHIVO NVARCHAR2(100) := 'Prueba.txt';
BEGIN
    VA_ARCHIVO_DEF := UTL_FILE.FOPEN('BRAYMON_HOME_DIRECTORY',NOMBRE_ARCHIVO,'W');
    IF UTL_FILE.IS_OPEN(VA_ARCHIVO_DEF) THEN
        DBMS_OUTPUT.PUT_LINE('Archivo creado satisfactoriamente: ' || NOMBRE_ARCHIVO);
    ELSE
        DBMS_OUTPUT.PUT_LINE('EL archivo no se pudo crear: ' || NOMBRE_ARCHIVO);
    END IF;

    UTL_FILE.PUT_LINE(VA_ARCHIVO_DEF,'Hola Mundo');
    UTL_FILE.FFLUSH(VA_ARCHIVO_DEF);
    UTL_FILE.FCLOSE(VA_ARCHIVO_DEF);
END;


--Lectura de archivo
DECLARE
    VA_ARCHIVO_DEF UTL_FILE.FILE_TYPE;
    V_FILE_TEXT    VARCHAR2(32767);
    NOMBRE_ARCHIVO NVARCHAR2(100) := 'CPdescarga.txt';
BEGIN
    -- Abrir el archivo para lectura
    VA_ARCHIVO_DEF := UTL_FILE.FOPEN('XXBM_FILES_DIRECTORY',NOMBRE_ARCHIVO,'R');

    -- Leer el contenido del archivo línea por línea
    LOOP
        BEGIN
            UTL_FILE.GET_LINE(VA_ARCHIVO_DEF,V_FILE_TEXT);
            --Convierte la linea en formato UTF-8 para respetar acentos y caracteres
            DBMS_OUTPUT.PUT_LINE(CONVERT(V_FILE_TEXT,'UTF8','WE8MSWIN1252'));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT;
        END;
    END LOOP;

  -- Cerrar el archivo
    UTL_FILE.FCLOSE(VA_ARCHIVO_DEF);
END;
