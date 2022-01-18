DECLARE
    val_nom_corto_concurrentes NVARCHAR2(5000) := '';
    val_tipo_lenguaje          NUMBER := 1;
    
    --
    val_com_descarga_ccp       NVARCHAR2(5000);
    val_com_descarga_rgr       NVARCHAR2(5000);
    
    --
    concurrent_program_name    NVARCHAR2(5000);
    application_short_name     NVARCHAR2(5000);
    contador                   NUMBER;
    
    --
    CURSOR inf_row IS
    ( SELECT DISTINCT
        concp.concurrent_program_name,
        fa.application_short_name
    FROM
        fnd_responsibility_vl      resp,
        fnd_request_group_units    respgu,
        fnd_concurrent_programs_vl concp,
        fnd_application            fa
    WHERE
            1 = 1
        AND respgu.request_group_id = resp.request_group_id
        AND respgu.application_id = resp.application_id
        AND respgu.request_unit_id = concp.concurrent_program_id
        AND fa.application_id = resp.application_id
        AND fa.application_short_name <> 'FND'
        AND concp.concurrent_program_name IN ( val_nom_corto_concurrentes )
    );

BEGIN
    
    --
    IF upper(val_tipo_lenguaje) = 1 THEN
        EXECUTE IMMEDIATE 'ALTER SESSION SET nls_language = "LATIN AMERICAN SPANISH"';
    ELSIF upper(val_tipo_lenguaje) = 2 THEN
        EXECUTE IMMEDIATE 'ALTER SESSION SET nls_language = "AMERICAN"';
    END IF;

    --
    FOR v_inf_row IN inf_row LOOP
        dbms_output.put_line('#CREACION CARPETA');
        dbms_output.put_line('mkdir ' || v_inf_row.concurrent_program_name);
        dbms_output.put_line('cd ' || v_inf_row.concurrent_program_name);
        dbms_output.put_line('');
        dbms_output.put_line('#COMANDOS DE DESCARGA CCP');
        dbms_output.put_line('$FND_TOP/bin/FNDLOAD apps/km1test O Y DOWNLOAD $FND_TOP/patch/115/import/afcpprog.lct ' || v_inf_row.concurrent_program_name || '_CCP.ldt PROGRAM APPLICATION_SHORT_NAME="' || v_inf_row.application_short_name || '" CONCURRENT_PROGRAM_NAME="'
                             || v_inf_row.concurrent_program_name || '"');
        --
        dbms_output.put_line('');
        dbms_output.put_line('#COMANDOS DE DESCARGA RG');
        contador := 0;
        FOR v_inf_row2 IN (
            SELECT DISTINCT
                concp.concurrent_program_name,
                respg.request_group_name,
                fa.application_short_name
            FROM
                fnd_responsibility_vl      resp,
                fnd_request_groups         respg,
                fnd_request_group_units    respgu,
                fnd_concurrent_programs_vl concp,
                fnd_application            fa
            WHERE
                    1 = 1
                AND respg.application_id = resp.application_id
                AND respg.request_group_id = resp.request_group_id
                AND respgu.request_group_id = resp.request_group_id
                AND respgu.application_id = resp.application_id
                AND respgu.request_unit_id = concp.concurrent_program_id
                AND fa.application_id = resp.application_id
                AND fa.application_short_name <> 'FND'
                AND concp.concurrent_program_name = v_inf_row.concurrent_program_name
        ) LOOP
            contador := contador + 1;
            dbms_output.put_line('$FND_TOP/bin/FNDLOAD apps/km1test 0 Y DOWNLOAD $FND_TOP/patch/115/import/afcpreqg.lct ' || v_inf_row2.concurrent_program_name || contador || '_RG.ldt REQUEST_GROUP REQUEST_GROUP_NAME="' || v_inf_row2.request_group_name
                                 || '" APPLICATION_SHORT_NAME="' || v_inf_row2.application_short_name || '" UNIT_NAME="' || v_inf_row2.concurrent_program_name
                                 || '"');

        END LOOP;
        
        --
        dbms_output.put_line('');
        dbms_output.put_line('#COMANDOS DE DESCARGA XML');
        dbms_output.put_line('$FND_TOP/bin/FNDLOAD apps/km1test O Y DOWNLOAD $XDO_TOP/patch/115/import/xdotmpl.lct ' || v_inf_row.concurrent_program_name || '_DD.ldt XDO_DS_DEFINITIONS APPLICATION_SHORT_NAME="' || v_inf_row.application_short_name || '" DATA_SOURCE_CODE="'
                             || v_inf_row.concurrent_program_name || '" TMPL_APP_SHORT_NAME="' || v_inf_row.application_short_name || '" TEMPLATE_CODE="'
                             || v_inf_row.concurrent_program_name || '"');
        --
        dbms_output.put_line('');
        dbms_output.put_line('-----------------------------------------------------------------------------');
        dbms_output.put_line('');
        --
        dbms_output.put_line('');
        dbms_output.put_line('#COMANDOS DE CARGA CCP');
        dbms_output.put_line('$FND_TOP/bin/FNDLOAD apps/km1test 0 Y UPLOAD $FND_TOP/patch/115/import/afcpprog.lct ' || v_inf_row.concurrent_program_name || '_CCP.ldt - WARNING=YES UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE');
        --
        dbms_output.put_line('');
        dbms_output.put_line('#COMANDOS DE CARGA RG');
        contador := 0;
        
        --
        FOR v_inf_row2 IN (
            SELECT DISTINCT
                concp.concurrent_program_name,
                respg.request_group_name,
                fa.application_short_name
            FROM
                fnd_responsibility_vl      resp,
                fnd_request_groups         respg,
                fnd_request_group_units    respgu,
                fnd_concurrent_programs_vl concp,
                fnd_application            fa
            WHERE
                    1 = 1
                AND respg.application_id = resp.application_id
                AND respg.request_group_id = resp.request_group_id
                AND respgu.request_group_id = resp.request_group_id
                AND respgu.application_id = resp.application_id
                AND respgu.request_unit_id = concp.concurrent_program_id
                AND fa.application_id = resp.application_id
                AND fa.application_short_name <> 'FND'
                AND concp.concurrent_program_name = v_inf_row.concurrent_program_name
        ) LOOP
            contador := contador + 1;
            dbms_output.put_line('$FND_TOP/bin/FNDLOAD apps/km1test 0 Y UPLOAD $FND_TOP/patch/115/import/afcpreqg.lct ' || v_inf_row2.concurrent_program_name || contador || '_RG.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE');
        END LOOP;
        
        --
        dbms_output.put_line('');
        dbms_output.put_line('#COMANDOS DE CARGA XML');
        dbms_output.put_line('$FND_TOP/bin/FNDLOAD apps/km1test 0 Y UPLOAD $XDO_TOP/patch/115/import/xdotmpl.lct ' || v_inf_row.concurrent_program_name || '_DD.ldt UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE');
        dbms_output.put_line('');
        dbms_output.put_line('-----------------------------------------------------------------------------');
        dbms_output.put_line('');
        dbms_output.put_line('');
        dbms_output.put_line('');
        dbms_output.put_line('');
        dbms_output.put_line('');
        dbms_output.put_line('');
    END LOOP;

END;
