--Ejemplo de cursor implícito:
DECLARE
  emp_name VARCHAR2(50);
BEGIN
  -- El cursor implícito se crea automáticamente al ejecutar la consulta SQL
  SELECT employee_name INTO emp_name FROM employees WHERE employee_id = 100;
  DBMS_OUTPUT.PUT_LINE('El nombre del empleado es: ' || emp_name);
END;



--Ejemplo de cursor explícito:
DECLARE
  -- Declarar el cursor explícito
  CURSOR c_emp IS SELECT employee_name FROM employees WHERE department_id = 10;
  emp_name VARCHAR2(50);
BEGIN
  -- Abrir el cursor explícito y recuperar los datos en un bucle
  OPEN c_emp;
  LOOP
    FETCH c_emp INTO emp_name;
    EXIT WHEN c_emp%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es: ' || emp_name);
  END LOOP;
  -- Cerrar el cursor explícito
  CLOSE c_emp;
END;



--Ejemplo de cómo reemplazar el bucle LOOP por un bucle FOR:
DECLARE
  -- Declarar el cursor explícito
  CURSOR c_emp IS SELECT employee_name FROM employees WHERE department_id = 10;
BEGIN
  -- Utilizar un bucle FOR para iterar sobre los datos del cursor
  FOR emp_rec IN c_emp LOOP
    DBMS_OUTPUT.PUT_LINE('El nombre del empleado es: ' || emp_rec.employee_name);
  END LOOP;
END;
