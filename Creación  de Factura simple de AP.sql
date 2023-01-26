DECLARE
   V_INVOICE_ID            AP_INVOICES_ALL.INVOICE_ID%TYPE;
   V_ORG_ID                AP_INVOICES_ALL.ORG_ID%TYPE;
   V_PAYMENT_METHOD_CODE   AP_INVOICES_ALL.PAYMENT_METHOD_CODE%TYPE;
   V_VENDOR_ID             PO_HEADERS_ALL.VENDOR_ID%TYPE;
   V_VENDOR_SITE_ID        PO_HEADERS_ALL.VENDOR_SITE_ID%TYPE;

   /*ERRORES*/
   V_ERROR_SEQ             VARCHAR2 (200);
   V_ERROR_MSG             VARCHAR2 (4000);
   G_INVALID_EX            EXCEPTION;

   /*SALIDA API*/
   V_REQUEST_ID            NUMBER;
   V_STATUS                VARCHAR2 (200);
   V_BOOLEAN               BOOLEAN;
   V_PHASE                 VARCHAR2 (200);
   V_DEV_PHASE             VARCHAR2 (200);
   V_DEV_STATUS            VARCHAR2 (200);
   V_MESSAGE               VARCHAR2 (200);

   /*ERRORES DE INTERFACE*/
   V_ERROR                 VARCHAR2 (200);
   V_FACTURA               VARCHAR2 (200);
   V_MENSAJE               VARCHAR2 (200);
BEGIN
   V_INVOICE_ID := AP_INVOICES_INTERFACE_S.NEXTVAL;
   V_ORG_ID := 1081;
   V_PAYMENT_METHOD_CODE := 'CHECK';
   V_VENDOR_ID := '315';
   V_VENDOR_SITE_ID := '642';

   BEGIN
      SELECT LOOKUP_CODE
        INTO V_PAYMENT_METHOD_CODE
        FROM AP_LOOKUP_CODES C
       WHERE C.LOOKUP_TYPE = 'PAYMENT METHOD'
         AND LOOKUP_CODE = V_PAYMENT_METHOD_CODE;
   EXCEPTION
      WHEN OTHERS THEN
         V_ERROR_SEQ := '01';
         V_ERROR_MSG := SQLERRM;
         RAISE G_INVALID_EX;
   END;

   BEGIN
      SELECT APS.VENDOR_ID, APSA.VENDOR_SITE_ID
        INTO V_VENDOR_ID, V_VENDOR_SITE_ID
        FROM AP_SUPPLIERS APS, AP_SUPPLIER_SITES_ALL APSA
       WHERE 1 = 1
         AND APS.VENDOR_ID = APSA.VENDOR_ID
         AND APS.VENDOR_ID = V_VENDOR_ID
         AND VENDOR_SITE_ID = V_VENDOR_SITE_ID;
   EXCEPTION
      WHEN OTHERS THEN
         V_ERROR_SEQ := '01';
         V_ERROR_MSG := SQLERRM;
         RAISE G_INVALID_EX;
   END;

   IF V_ERROR_SEQ IS NULL THEN
      BEGIN
         INSERT INTO AP_INVOICES_INTERFACE (INVOICE_ID,
                                            INVOICE_NUM,
                                            VENDOR_ID,
                                            VENDOR_SITE_ID,
                                            INVOICE_AMOUNT,
                                            INVOICE_CURRENCY_CODE,
                                            INVOICE_DATE,
                                            DESCRIPTION,
                                            SOURCE,
                                            ORG_ID,
                                            PAYMENT_METHOD_CODE)
              VALUES (
                        V_INVOICE_ID,
                        'XXBM-'
                        || V_INVOICE_ID,
                        V_VENDOR_ID,
                        V_VENDOR_SITE_ID,
                        25000,
                        'USD',
                        TO_DATE ('01-06-2016', 'DD-MM-YYYY'),
                        --TO_DATE (TO_CHAR (SYSDATE, 'DD-MM-YYYY'), 'DD-MM-YYYY'),
                        'Prueba de ingreso factura por Interface',
                        'MANUAL INVOICE ENTRY',
                        V_ORG_ID,
                        V_PAYMENT_METHOD_CODE);

         COMMIT;
      END;

      BEGIN
         INSERT INTO AP_INVOICE_LINES_INTERFACE (INVOICE_ID,
                                                 LINE_NUMBER,
                                                 LINE_TYPE_LOOKUP_CODE,
                                                 AMOUNT)
              VALUES (V_INVOICE_ID,
                      1,
                      'ITEM',
                      25000);

         COMMIT;
      END;

      /*******************************/
      BEGIN
         MO_GLOBAL.INIT ('SQLAP');
         FND_GLOBAL.APPS_INITIALIZE (USER_ID        => 1318,
                                     RESP_ID        => 50554,
                                     RESP_APPL_ID   => 200);

         /*Concurrent: Payables Open Interface Import*/
         V_REQUEST_ID :=
            FND_REQUEST.SUBMIT_REQUEST (APPLICATION   => 'SQLAP',
                                        PROGRAM       => 'APXIIMPT',
                                        DESCRIPTION   => '',
                                        START_TIME    => NULL,
                                        SUB_REQUEST   => FALSE,
                                        ARGUMENT1     => V_ORG_ID,
                                        ARGUMENT2     => 'MANUAL INVOICE ENTRY',
                                        ARGUMENT3     => NULL,
                                        ARGUMENT4     => NULL,
                                        ARGUMENT5     => NULL,
                                        ARGUMENT6     => NULL,
                                        ARGUMENT7     => NULL,
                                        ARGUMENT8     => 'N',
                                        ARGUMENT9     => 'Y');
         COMMIT;

         IF V_REQUEST_ID > 0 THEN
            V_BOOLEAN :=
               FND_CONCURRENT.WAIT_FOR_REQUEST (V_REQUEST_ID,
                                                5,
                                                0,
                                                V_PHASE,
                                                V_STATUS,
                                                V_DEV_PHASE,
                                                V_DEV_STATUS,
                                                V_MESSAGE);
         END IF;

         DBMS_OUTPUT.PUT_LINE ('********************************');
         IF (V_STATUS = 'Normal') THEN
            DBMS_OUTPUT.PUT_LINE ('Se ejecuto con exito el procesamiento de facturas con id de solicitud :' || V_REQUEST_ID);
         ELSE
            V_ERROR_SEQ := '02';
            V_ERROR_MSG := 'Error en el procesamiento de facturas con id de solicitud :' || V_REQUEST_ID;
            RAISE G_INVALID_EX;
         END IF;

         /**/
         BEGIN
            SELECT '1' AS ERROR, AII.INVOICE_NUM, ALC.DESCRIPTION
              INTO V_ERROR, V_FACTURA, V_MENSAJE
              FROM AP_INVOICES_INTERFACE AII,
                   AP_INVOICE_LINES_INTERFACE AILI,
                   AP_INTERFACE_REJECTIONS AIR,
                   AP_LOOKUP_CODES ALC
             WHERE 1 = 1
               AND AII.INVOICE_ID = AILI.INVOICE_ID
               AND AILI.INVOICE_ID = AIR.PARENT_ID
               AND AIR.REJECT_LOOKUP_CODE = ALC.LOOKUP_CODE
               AND ALC.LOOKUP_TYPE = 'REJECT CODE'
               AND AII.INVOICE_ID = V_INVOICE_ID;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               V_ERROR := NULL;
               V_FACTURA := NULL;
               V_MENSAJE := NULL;
         END;
         /**/
         
         IF V_ERROR IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE ('No se pudo crear la factura por el siguiente motivo: ' || V_MENSAJE);
         END IF;
         DBMS_OUTPUT.PUT_LINE ('********************************');
         
      END;
   /*******************************/

   END IF;
EXCEPTION
   WHEN G_INVALID_EX THEN
      DBMS_OUTPUT.PUT_LINE ('Codigo de Error: ' || V_ERROR_SEQ);
      DBMS_OUTPUT.PUT_LINE ('Error: ' || V_ERROR_MSG);
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE ('Error: ' || SQLERRM);
END;
