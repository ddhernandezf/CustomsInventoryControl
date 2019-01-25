CREATE PROCEDURE [dbo].[spu_CustomerAccountData]
	@IdCustomer INT,
	@IdAccount INT,
	@ResolutionRate  NVARCHAR(100),
	@RegimeRate  NVARCHAR(100),
	@ResolutionStartDate DATE,
	@ResolutionEndDate DATE,
	@FiscalPeriodStartDate  DATE,
	@FiscalPeriodEndDate  DATE
AS
	UPDATE	[CustomerAccount]
	   SET	ResolutionRate = @ResolutionRate,
			RegimeRate = @RegimeRate,
			ResolutionStartDate = @ResolutionStartDate,
			ResolutionEndDate = @ResolutionEndDate,
			FiscalPeriodStartDate = @FiscalPeriodStartDate,
			FiscalPeriodEndDate = @FiscalPeriodEndDate
	 WHERE	IdCustomer = @IdCustomer
	   AND	IdAccount = @IdAccount