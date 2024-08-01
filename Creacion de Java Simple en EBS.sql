--Crear Clase JAVA en BD
CREATE OR REPLACE AND RESOLVE JAVA SOURCE NAMED APPS."XXITG_PRUEBA_HOLA"
   AS public class XXITG_PRUEBA_HOLA {
    public static String sayHello(){
        return "Hello World";
    }
}


--llamar el metodo
CREATE OR REPLACE FUNCTION XXITG_PRUEBA_HOLA_F
   RETURN VARCHAR2
AS
   LANGUAGE JAVA
   NAME 'XXITG_PRUEBA_HOLA.sayHello() return java.lang.String';


--Invocar al JAVA
BEGIN
   DBMS_OUTPUT.PUT_LINE ('The value of the string is '
                         || XXITG_PRUEBA_HOLA_F ());
END;
