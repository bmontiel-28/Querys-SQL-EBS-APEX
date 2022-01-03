DECLARE
   -- Change the following two parameters
    var_templatecode VARCHAR2(100) := 'XXSAF_PRUEBA_EDD';            -- Template Code
    elimina_data_def BOOLEAN := true;
   -- delete the associated Data Def.
BEGIN
    FOR rs IN (
        SELECT
            t1.application_short_name template_app_name,
            t1.data_source_code,
            t2.application_short_name def_app_name
        FROM
            xdo_templates_b      t1,
            xdo_ds_definitions_b t2
        WHERE
                t1.template_code = var_templatecode
            AND t1.data_source_code = t2.data_source_code
    ) LOOP
        xdo_templates_pkg.delete_row(rs.template_app_name, var_templatecode);
        DELETE FROM xdo_lobs
        WHERE
                lob_code = var_templatecode
            AND application_short_name = rs.template_app_name
            AND lob_type IN ( 'TEMPLATE_SOURCE', 'TEMPLATE' );

        DELETE FROM xdo_config_values
        WHERE
                application_short_name = rs.template_app_name
            AND template_code = var_templatecode
            AND data_source_code = rs.data_source_code
            AND config_level = 50;

        dbms_output.put_line('Template ' || var_templatecode || ' deleted.');
        COMMIT;
        IF elimina_data_def THEN
            xdo_ds_definitions_pkg.delete_row(rs.def_app_name, rs.data_source_code);
            DELETE FROM xdo_lobs
            WHERE
                    lob_code = rs.data_source_code
                AND application_short_name = rs.def_app_name
                AND lob_type IN ( 'XML_SCHEMA', 'DATA_TEMPLATE', 'XML_SAMPLE', 'BURSTING_FILE' );

            DELETE FROM xdo_config_values
            WHERE
                    application_short_name = rs.def_app_name
                AND data_source_code = rs.data_source_code
                AND config_level = 30;

            dbms_output.put_line('Data Defintion ' || rs.data_source_code || ' deleted.');
            COMMIT;
        END IF;

    END LOOP;

    dbms_output.put_line('Issue a COMMIT to make the changes or ROLLBACK to revert.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Unable to delete XML Publisher Template ' || var_templatecode);
        dbms_output.put_line(substr(sqlerrm, 1, 200));
END;