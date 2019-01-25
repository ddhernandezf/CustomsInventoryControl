CREATE PROCEDURE [dbo].[spg_CustomerAccountData]
	@IdCustomer	INT,
	@IdAccount	INT
AS
	IF(ISNULL(@IdCustomer, 0) = 0)
		BEGIN
			IF(ISNULL(@IdAccount, 0) = 0)
				BEGIN
					SELECT	IdCustomer, IdAccount, ResolutionRate, RegimeRate, ResolutionStartDate, ResolutionEndDate, 
							FiscalPeriodStartDate, FiscalPeriodEndDate
					  FROM	[CustomerAccount]
				END
			ELSE
				BEGIN
					SELECT	IdCustomer, IdAccount, ResolutionRate, RegimeRate, ResolutionStartDate, ResolutionEndDate, 
							FiscalPeriodStartDate, FiscalPeriodEndDate
					  FROM	[CustomerAccount]
					 WHERE	IdAccount = @IdAccount
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdAccount, 0) = 0)
				BEGIN
					SELECT	IdCustomer, IdAccount, ResolutionRate, RegimeRate, ResolutionStartDate, ResolutionEndDate, 
							FiscalPeriodStartDate, FiscalPeriodEndDate
					  FROM	[CustomerAccount]
					 WHERE	IdCustomer = @IdCustomer
				END
			ELSE
				BEGIN
					SELECT	IdCustomer, IdAccount, ResolutionRate, RegimeRate, ResolutionStartDate, ResolutionEndDate, 
							FiscalPeriodStartDate, FiscalPeriodEndDate
					  FROM	[CustomerAccount]
					 WHERE	IdCustomer = @IdCustomer
					   AND	IdAccount = @IdAccount
				END
		END