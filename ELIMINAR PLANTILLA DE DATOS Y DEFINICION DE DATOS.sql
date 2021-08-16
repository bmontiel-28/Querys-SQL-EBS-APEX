alter session set nls_language = 'LATIN AMERICAN SPANISH';

BEGIN
    dbms_output.put_line('Inicio de Api');
    dbms_output.put_line('************************************************');
	--primero este
    xdo_ds_definitions_pkg.delete_row('SQLAP', 'XXSAF_REP_CONCILIACION_APGL_XML');---Data definitions
	dbms_output.put_line('************************************************');
    
    
	--este despues
    xdo_templates_pkg.delete_row('SQLAP', 'XXSAF_REP_CONCILIACION_APGL_XML'); -- Module Short Name & Concurrent Program Short Name
    dbms_output.put_line('************************************************');
    dbms_output.put_line('Fin Api');
    --
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error en Bloque Anonimo:');
        dbms_output.put_line('Error: ' || sqlerrm);
END;