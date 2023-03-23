DECLARE
   L_RESPONSE   CLOB;
   L_BODY       VARCHAR2 (4000) := 'grant_type=client_credentials';
BEGIN
   APEX_WEB_SERVICE.G_REQUEST_HEADERS (1).NAME  := 'Authorization';
   APEX_WEB_SERVICE.G_REQUEST_HEADERS (1).VALUE := 'Basic N3RVRFZhMkR6ZE1EZFdVRXNFLV81Zy4uOkxCUGdieE9EdW9ucnQwcTNyb0lRZ0EuLg==';
   APEX_WEB_SERVICE.G_REQUEST_HEADERS (2).NAME  := 'Content-Type';
   APEX_WEB_SERVICE.G_REQUEST_HEADERS (2).VALUE := 'application/x-www-form-urlencoded';

   L_RESPONSE :=
      APEX_WEB_SERVICE.MAKE_REST_REQUEST (p_url           => 'https://g769581ae49c68d-adertdw.adb.us-sanjose-1.oraclecloudapps.com/ords/itg_vls_ords/oauth/token'
                                         ,p_http_method   => 'POST'
                                         ,p_body          => L_BODY);
   -- procesar la respuesta
   DBMS_OUTPUT.PUT_LINE (L_RESPONSE);
END;