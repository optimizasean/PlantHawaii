-----------------------------------------------------------------------------
CREATE FUNCTION FUNCTION_SPECIES_TABLE()
RETURNS TABLE
AS
RETURN (
    SELECT
        *
    FROM SPECIES
);
GO
-----------------------------------------------------------------------------
CREATE FUNCTION FUNCTION_SPECIES_ENTRY(@SELECTED_NAME VARCHAR(MAX))
RETURNS TABLE
AS
RETURN (
    SELECT
        SPECIES.ID AS SP_ID,
        SPECIES.SPECIES_NAME AS SP_NAME,
        SPECIES.SUBSPECIES_NAME AS SUB_NAME,
        SPECIES.[DESCRIPTION] AS SP_DESCRIP,
        SPECIES.STORY AS SP_STORY,
        GENUS.[NAME] AS G_NAME,
        [ORDER].[NAME] AS O_NAME,
        COMMON_NAME.[NAME] AS C_NAME,
        HAWAIIAN_NAME.[NAME] AS H_NAME,
        NATIVE_STATUS.STATUS AS N_STAT,
        INVASIVE_STATUS.STATUS AS I_STAT,
        FEDERAL_STATUS.STATUS AS F_STAT,
        FEDERAL_STATUS.[CODE] AS F_CODE
    FROM SPECIES
        LEFT JOIN GENUS ON SPECIES.GENUS_ID = GENUS.ID
        LEFT JOIN [ORDER] ON GENUS.ORDER_ID = [ORDER].ID
        LEFT JOIN COMMON_NAME ON SPECIES.COMMON_NAME_ID = COMMON_NAME.ID
        LEFT JOIN HAWAIIAN_NAME ON SPECIES.HAWAIIAN_NAME_ID = HAWAIIAN_NAME.ID
        LEFT JOIN NATIVE_STATUS ON SPECIES.NATIVE_STATUS_ID = NATIVE_STATUS.ID
        LEFT JOIN INVASIVE_STATUS ON SPECIES.INVASIVE_STATUS_ID = INVASIVE_STATUS.ID
        LEFT JOIN FEDERAL_STATUS ON SPECIES.FEDERAL_STATUS_ID = FEDERAL_STATUS.ID
    WHERE SPECIES.SPECIES_NAME = @SELECTED_NAME
);
GO
-----------------------------------------------------------------------------
CREATE FUNCTION FUNCTION_RANDOM_PLANT()
RETURNS @RANDOM_PLANT TABLE (
    [SPECIES ID] INT NOT NULL PRIMARY KEY,
    [SPECIES NAME] VARCHAR(MAX),
    [SUBSPECIES NAME] VARCHAR(MAX),
    [DESCRIPTION] TEXT,
    STORY TEXT,
    GENUS VARCHAR(MAX),
    [ORDER] VARCHAR(MAX),
    [COMMON NAME] VARCHAR(MAX),
    [HAWAIIAN NAME] VARCHAR(MAX),
    [NATIVE STATUS] CHAR(10),
    [INVASIVE STATUS] CHAR(12),
    [FEDERAL STATUS] CHAR(21),
    [FEDERAL CODE] CHAR(2)
)
AS
BEGIN
    DECLARE @TEMP AS INT;
    DECLARE @SMALLEST AS INT;
        SET @SMALLEST = 1;
    DECLARE @LARGEST AS INT;
        SET @TEMP = (SELECT COUNT(*) FROM SPECIES);
        SET @LARGEST = (SELECT CONVERT(INT, @TEMP) AS INT);

    DECLARE @RANDOM_ID AS INT;
        SET @TEMP =  (SELECT [dbo].FUNCTION_RANDOM_BETWEEN(@SMALLEST, @LARGEST));
        SET @RANDOM_ID = (SELECT CONVERT(INT, @TEMP) AS INT);
    

    WITH SELECTED_PLANT(SPECIESID, SPECIESNAME, SUBSPECIESNAME, SPECIESDESCRIPTION,
        SPECIESSTORY, SPECIESGENUS, SPECIESORDER, COMMONNAME, HAWAIIANNAME, NATIVESTATUS,
        INVASIVESTATUS, FEDERALSTATUS, FEDERALCODE)
    AS (
        SELECT
            SPECIES.ID AS ID,
            SPECIES.SPECIES_NAME AS SP_NAME,
            SPECIES.SUBSPECIES_NAME AS SUB_NAME,
            SPECIES.[DESCRIPTION] AS SP_DESCRIP,
            SPECIES.STORY AS SP_STORY,
            GENUS.[NAME] AS G_NAME,
            [ORDER].[NAME] AS O_NAME,
            COMMON_NAME.[NAME] AS C_NAME,
            HAWAIIAN_NAME.[NAME] AS H_NAME,
            NATIVE_STATUS.STATUS AS N_STAT,
            INVASIVE_STATUS.STATUS AS I_STAT,
            FEDERAL_STATUS.STATUS AS F_STAT,
            FEDERAL_STATUS.[CODE] AS F_CODE
        FROM SPECIES
            LEFT JOIN GENUS ON SPECIES.GENUS_ID = GENUS.ID
            LEFT JOIN [ORDER] ON GENUS.ORDER_ID = [ORDER].ID
            LEFT JOIN COMMON_NAME ON SPECIES.COMMON_NAME_ID = COMMON_NAME.ID
            LEFT JOIN HAWAIIAN_NAME ON SPECIES.HAWAIIAN_NAME_ID = HAWAIIAN_NAME.ID
            LEFT JOIN NATIVE_STATUS ON SPECIES.NATIVE_STATUS_ID = NATIVE_STATUS.ID
            LEFT JOIN INVASIVE_STATUS ON SPECIES.INVASIVE_STATUS_ID = INVASIVE_STATUS.ID
            LEFT JOIN FEDERAL_STATUS ON SPECIES.FEDERAL_STATUS_ID = FEDERAL_STATUS.ID
        WHERE SPECIES.ID = @RANDOM_ID
    )
    INSERT @RANDOM_PLANT  
        SELECT SPECIESID, SPECIESNAME, SUBSPECIESNAME, SPECIESDESCRIPTION,
            SPECIESSTORY, SPECIESGENUS, SPECIESORDER, COMMONNAME, HAWAIIANNAME, NATIVESTATUS,
            INVASIVESTATUS, FEDERALSTATUS, FEDERALCODE
        FROM SELECTED_PLANT;
    RETURN;
END;
GO
-----------------------------------------------------------------------------
