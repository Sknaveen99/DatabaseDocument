CREATE PROCEDURE Shipment_Tracking
    (
      @StartDT DATETIME = NULL
    , @EndDT DATETIME = NULL
    , @Consignment_No VARCHAR(30) = NULL
    , @ReferenceNo VARCHAR(30) = NULL
    , @CustID VARCHAR(20) = NULL
    , @Customer_Type CHAR(1) = NULL
    , @Status_Code VARCHAR(12) = NULL
    , @StatusType TINYINT = NULL    -- 0=NA, 1=Last in history, 2=In history
    , @MissingStatus VARCHAR(12) = NULL
    )
AS
    BEGIN
        SET NOCOUNT ON;
   
    -- Truncate time component from start date
        DECLARE @StartDate DATETIME = DATEADD(day, 0,
                                              DATEDIFF(day, 0, @StartDT))
        -- Truncate time component from end date and add 1
          , @EndDate DATETIME = DATEADD(day, 1, DATEDIFF(day, 0, @EndDT));
   
    -- If @EndDate is NULL, then use @StartDT + 1   
        SELECT @EndDate = ISNULL(@EndDate,
                                 DATEADD(day, 1, DATEDIFF(day, 0, @StartDT)))
              , @Consignment_No = NULLIF(@Consignment_No, '')
              , @ReferenceNo = NULLIF(@ReferenceNo, '')
              , @CustID = NULLIF(@CustID, '')
              , @Customer_Type = NULLIF(@Customer_Type, '')
              , @Status_Code = NULLIF(@Status_Code, '')
              , @MissingStatus = NULLIF(@MissingStatus, '')
        -- If @StatusType NOT IN (1, 2) then @Status_Code will be ignored
              , @StatusType = CASE WHEN NULLIF(@Status_Code, '') IS NULL
                                   THEN 0
                                   WHEN @StatusType IN ( 0, 1, 2 )
                                   THEN @StatusType
                                   ELSE 0
                              END;
    
        IF @debug = 1
            BEGIN  
                PRINT CONVERT(VARCHAR(20), @StartDate, 120);
                PRINT CONVERT(VARCHAR(20), @EndDate, 120);
            END
    
    END
