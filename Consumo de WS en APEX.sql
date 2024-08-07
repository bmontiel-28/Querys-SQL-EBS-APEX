--Ejemplo Basico de POST en Oracle Apex
DECLARE
   --Variable para almacenar la respuesta de la peticion
   L_RESPONSE   CLOB;
   
   --Se crea el cuerpo de la solicitud, este puede ser asi o json dependiendo del Content-Type
   L_BODY       VARCHAR2 (4000) := 'grant_type=client_credentials';
   
   --Creamos una variable para pasar el JSON de la respuesta
   l_object   json_object_t; 
BEGIN
   --Se usa el CLIENT_ID y CLIENT_SECRET de esta manera CLIENT_ID:CLIENT_SECRET
   APEX_WEB_SERVICE.G_REQUEST_HEADERS (1).NAME  := 'Authorization';
   APEX_WEB_SERVICE.G_REQUEST_HEADERS (1).VALUE := 'Basic N3RVRFZhMkR6ZE1EZFdVRXNFLV81Zy4uOkxCUGdieE9EdW9ucnQwcTNyb0lRZ0EuLg==';
   
   --Se establece el tipo de contenido que se pasara en el cuerpo de la solicitud
   APEX_WEB_SERVICE.G_REQUEST_HEADERS (2).NAME  := 'Content-Type';
   APEX_WEB_SERVICE.G_REQUEST_HEADERS (2).VALUE := 'application/x-www-form-urlencoded';
   
   --Realizacion de la peticion este caso un POST
   L_RESPONSE :=
      APEX_WEB_SERVICE.MAKE_REST_REQUEST (P_URL           => 'https://g769581ae49c68d-adertdw.adb.us-sanjose-1.oraclecloudapps.com/ords/itg_vls_ords/oauth/token'
                                         ,P_HTTP_METHOD   => 'POST'
                                         ,P_BODY          => L_BODY);
   -- Mostrar la respuesta obtenida
   --DBMS_OUTPUT.PUT_LINE (L_RESPONSE);
   
   --Pasamos la respuesta a la variable para darle estructura JSON
   l_object := json_object_t.parse (L_RESPONSE);
   
   -- Mostrar el nodo del token
   DBMS_OUTPUT.PUT_LINE (l_object.get_string ('access_token'));
   
END;
