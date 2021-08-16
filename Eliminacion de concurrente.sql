DECLARE
    l_prog_short_name VARCHAR2(240);
    l_exec_short_name VARCHAR2(240);
    l_appl_full_name  VARCHAR2(240) := 'General Ledger';
    l_appl_short_name VARCHAR2(240);
    l_del_prog_flag   VARCHAR2(1) := 'Y';
    l_del_exec_flag   VARCHAR2(1) := 'Y';
BEGIN
    l_prog_short_name := 'XXGLORAIMPORT';
    l_exec_short_name := 'XXGLORAIMPORT';
    l_appl_short_name := 'SQLGL';
    IF
        fnd_program.program_exists(l_prog_short_name, l_appl_short_name)
        AND fnd_program.executable_exists(l_exec_short_name, l_appl_short_name)
    THEN
        IF l_del_prog_flag = 'Y' THEN
            fnd_program.delete_program(l_prog_short_name, l_appl_full_name);
                       -- Borrar el Programa Concurrente
            dbms_output.put_line('Borrando el Programa Concurrente ' || l_prog_short_name);
        END IF;

        IF l_del_exec_flag = 'Y' THEN
            fnd_program.delete_executable(l_exec_short_name, l_appl_full_name);
            dbms_output.put_line('Borrando el Executable ' || l_exec_short_name);
        END IF;

        COMMIT;
        dbms_output.put_line('Programa concurrente ' || l_prog_short_name || ' eliminado exitosamente');
        dbms_output.put_line('Executable ' || l_exec_short_name || ' eliminado exitosamente');
    ELSE
        dbms_output.put_line('El programa ' || l_prog_short_name || ' o Ejecutable ' || l_exec_short_name || ' no existen');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error al eliminar: ' || sqlerrm);
END;