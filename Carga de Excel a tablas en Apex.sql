 /* PROCESO PARA CARGA DE ARCHIVO EXCEL A UNA COLECCION */
BEGIN
   IF APEX_COLLECTION.COLLECTION_EXISTS ('CSVDATAUPLOAD') THEN
      APEX_COLLECTION.TRUNCATE_COLLECTION ('CSVDATAUPLOAD');
   END IF;

   IF NOT APEX_COLLECTION.COLLECTION_EXISTS ('CSVDATAUPLOAD') THEN
      APEX_COLLECTION.CREATE_COLLECTION ('CSVDATAUPLOAD');
   END IF;

   FOR R1
      IN (SELECT *
            FROM APEX_APPLICATION_TEMP_FILES F
                ,TABLE (APEX_DATA_PARSER.PARSE (P_CONTENT           => F.BLOB_CONTENT
                                               ,P_ADD_HEADERS_ROW   => 'Y'
                                               ,P_FILE_NAME         => F.FILENAME)) P
           WHERE F.NAME = :P2_UPLOAD) LOOP
      APEX_COLLECTION.ADD_MEMBER (
                                 P_COLLECTION_NAME   => 'CSVDATAUPLOAD'
                                  ,P_C001 => NVL (REPLACE (R1.COL001,'-',''),0)
                                  ,P_C002 => NVL (REPLACE (R1.COL002,'-',''),0)
                                  ,P_C003 => NVL (REPLACE (R1.COL003,'-',''),0)
                                  ,P_C004 => NVL (REPLACE (R1.COL004,'-',''),0)
                                  ,P_C005 => NVL (REPLACE (R1.COL005,'-',''),0)
                                  ,P_C006 => NVL (REPLACE (R1.COL006,'-',''),0)
                                  ,P_C007 => NVL (REPLACE (R1.COL007,'-',''),0)
                                  ,P_C008 => NVL (REPLACE (R1.COL008,'-',''),0)
                                  ,P_C009 => NVL (REPLACE (R1.COL009,'-',''),0)
                                  ,P_C010 => NVL (REPLACE (R1.COL010,'-',''),0)
                                  ,P_C011 => NVL (REPLACE (R1.COL011,'-',''),0)
                                  ,P_C012 => NVL (REPLACE (R1.COL012,'-',''),0)
                                  ,P_C013 => NVL (REPLACE (R1.COL013,'-',''),0)
                                 );
   END LOOP;
END;



/* PROCESO PARA INSERTAR LOS DATOS DE LA COLECCION A UNA TABLA */
DECLARE
    CURSOR C2 IS
    SELECT
        C001
       ,C002
       ,C003
       ,C004
       ,C005
       ,C006
       ,C007
       ,C008
       ,C009
       ,C010
       ,C011
       ,C012
       ,C013
    FROM
        APEX_COLLECTIONS
    WHERE
        COLLECTION_NAME = 'CSVDATAUPLOAD';

BEGIN
    FOR I IN C2 LOOP
        INSERT INTO XXITG_EXCEL_DATA (
            C001
            ,C002
            ,C003
            ,C004
            ,C005
            ,C006
            ,C007
            ,C008
            ,C009
            ,C010
            ,C011
            ,C012
            ,C013
        ) VALUES (
			I.C001
           ,I.C002
           ,I.C003
           ,I.C004
           ,I.C005
           ,I.C006
           ,I.C007
           ,I.C008
           ,I.C009
           ,I.C010
           ,I.C011
           ,I.C012
           ,I.C013
        );

    END LOOP;
END;



/* PROCESO PARA LIMPIAR LA COLECCION */
IF APEX_COLLECTION.COLLECTION_EXISTS('CSVDATAUPLOAD') THEN
    APEX_COLLECTION.TRUNCATE_COLLECTION('CSVDATAUPLOAD');
END IF;



/* PROCESO PARA VISUALIZAR EL CONTENIDO DE LA COLECCION Y MOSTRARLO EN UN ITERACTIVE REPORT */
SELECT
    SEQ_ID
   ,C001
   ,C002
   ,C003
   ,C004
   ,C005
   ,C006
   ,C007
   ,C008
   ,C009
   ,C010
   ,C011
   ,C012
   ,C013
FROM
    APEX_COLLECTIONS
WHERE
        COLLECTION_NAME = 'CSVDATAUPLOAD'
    AND SEQ_ID != 1;



/* TABLA DONDE SE ALMACENA LA INFORMACION */
  CREATE TABLE "XXITG_EXCEL_DATA" 
   (	"C001" VARCHAR2(100), 
	"C002" VARCHAR2(100), 
	"C003" VARCHAR2(100), 
	"C004" VARCHAR2(100), 
	"C005" VARCHAR2(100), 
	"C006" VARCHAR2(100), 
	"C007" VARCHAR2(100), 
	"C008" VARCHAR2(100), 
	"C009" VARCHAR2(100), 
	"C010" VARCHAR2(100), 
	"C011" VARCHAR2(100), 
	"C012" VARCHAR2(100), 
	"C013" VARCHAR2(100)
   ) ;