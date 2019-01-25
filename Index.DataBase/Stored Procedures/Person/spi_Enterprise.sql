CREATE PROCEDURE [dbo].[spi_Enterprise]
	@EnterpiseName	VARCHAR(150),
	@Nit			VARCHAR(15),
	@IdPerson		INT OUT,
	@UserName		VARCHAR(60)
AS
	CREATE TABLE [#Tmp_Person]
	(
		[Id] INT NOT NULL,
		[EnterpriseName] VARCHAR(400) NULL,
		[Nit] VARCHAR(15) NULL
	)

	INSERT INTO [#Tmp_Person]
	SELECT	Id,EnterpriseName,Nit
	  FROM	[Person]
	 WHERE	UPPER(EnterpriseName) = UPPER(@EnterpiseName)
	   AND	IsEnterprise = 1
	UNION
	SELECT	Id,EnterpriseName,Nit
	  FROM	[Person]
	 WHERE	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'))
	 AND	IsEnterprise = 1
	
	IF EXISTS (	SELECT	*
				  FROM	[Person]
				 WHERE	UPPER(ISNULL(Nit, '')) = UPPER(ISNULL(@Nit, ''))
				   AND	IsEnterprise = 1)
	BEGIN
		DECLARE @NitProp VARCHAR(300);
		SELECT	@NitProp = (EnterpriseName)
		  FROM	[#Tmp_Person]
		 WHERE	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'));

		RAISERROR (N'El nit %s pertence a la empresa %s',16,1, @Nit, @NitProp);

		SET @IdPerson = 0;
	END
	ELSE
		BEGIN
			IF EXISTS(	SELECT	Id,EnterpriseName,Nit
						  FROM	[#Tmp_Person]
						 WHERE	UPPER(EnterpriseName) = UPPER(@EnterpiseName))
				BEGIN
					DECLARE @Counter		INT,
							@NitProperty	VARCHAR(300);

					SELECT	@Counter = COUNT(*)
					  FROM	[#Tmp_Person]
					 WHERE	UPPER(EnterpriseName) = UPPER(@EnterpiseName)
					   AND	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'))

					IF(@Counter = 1)
						BEGIN
							SELECT	@IdPerson = Id
							  FROM	[#Tmp_Person]
							 WHERE	UPPER(EnterpriseName) = UPPER(@EnterpiseName)
							   AND	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'));

							SELECT  @IdPerson;
						END
					ELSE
						BEGIN
							IF(ISNULL(@Nit,'0') = '0')
							BEGIN
								SELECT	@IdPerson = Id
								  FROM	[#Tmp_Person]
								 WHERE	UPPER(EnterpriseName) = UPPER(@EnterpiseName)
							END
							ELSE
								BEGIN
									SELECT	@NitProperty = (EnterpriseName)
									  FROM	[#Tmp_Person]
									 WHERE	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'));

									 RAISERROR (N'El nit %s pertence a la empresa %s',16,1, @Nit, @NitProperty);

									 SET @IdPerson = 0;
								END
						END
				END
			ELSE
				BEGIN
					INSERT INTO [Person] (EnterpriseName, Nit, RegisterDate, RegisterUser, IsEnterprise)
					VALUES(@EnterpiseName, @Nit, GETDATE(), @UserName, 1);

					SET @IdPerson = SCOPE_IDENTITY();
					SELECT  @IdPerson;
				END
		END