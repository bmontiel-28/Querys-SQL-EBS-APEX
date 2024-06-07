SELECT
    FU.USER_NAME
   ,FRT.RESPONSIBILITY_NAME
   ,FURG.START_DATE
   ,FURG.END_DATE
   ,FR.RESPONSIBILITY_KEY
   ,FA.APPLICATION_SHORT_NAME
FROM
    FND_USER_RESP_GROUPS_DIRECT   FURG
   ,APPLSYS.FND_USER              FU
   ,APPLSYS.FND_RESPONSIBILITY_TL FRT
   ,APPLSYS.FND_RESPONSIBILITY    FR
   ,APPLSYS.FND_APPLICATION_TL    FAT
   ,APPLSYS.FND_APPLICATION       FA
WHERE
        FURG.USER_ID = FU.USER_ID
    AND FURG.RESPONSIBILITY_ID = FRT.RESPONSIBILITY_ID
    AND FR.RESPONSIBILITY_ID = FRT.RESPONSIBILITY_ID
    AND FA.APPLICATION_ID = FAT.APPLICATION_ID
    AND FR.APPLICATION_ID = FAT.APPLICATION_ID
    AND FRT.LANGUAGE = 'US'
    AND UPPER(FU.USER_NAME)= UPPER('')
GROUP BY
    FU.USER_NAME
   ,FRT.RESPONSIBILITY_NAME
   ,FURG.START_DATE
   ,FURG.END_DATE
   ,FR.RESPONSIBILITY_KEY
   ,FA.APPLICATION_SHORT_NAME
ORDER BY
    FRT.RESPONSIBILITY_NAME;
