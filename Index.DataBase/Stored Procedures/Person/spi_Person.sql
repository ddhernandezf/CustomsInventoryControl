CREATE PROCEDURE [dbo].[spi_Person]
	@FirstName	VARCHAR(150),
	@LastName	VARCHAR(150),
	@Nit		VARCHAR(15),
	@IdPerson	INT OUT,
	@UserName	VARCHAR(60)
AS
	CREATE TABLE [#Tmp_Person]
	(
		[Id] INT NOT NULL,
		[FirstName] VARCHAR(150) NOT NULL,
		[LastName] VARCHAR(150) NULL,
		[Nit] VARCHAR(15) NULL
	)

	INSERT INTO [#Tmp_Person]
	SELECT	Id,FirstName,LastName,Nit
	  FROM	[Person]
	 WHERE	UPPER(FirstName) = UPPER(@FirstName)
	   AND	UPPER(LastName) = UPPER(@LastName)
	   AND	IsEnterprise = 0
	UNION
	SELECT	Id,FirstName,LastName,Nit
	  FROM	[Person]
	 WHERE	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'))
	   AND	IsEnterprise = 0
	
	IF EXISTS(	SELECT	Id,FirstName,LastName,Nit
				  FROM	[#Tmp_Person]
				 WHERE	UPPER(FirstName) = UPPER(@FirstName)
				   AND	UPPER(LastName) = UPPER(@LastName))
		BEGIN
			DECLARE @Counter		INT,
					@NitProperty	VARCHAR(300);

			SELECT	@Counter = COUNT(*)
			  FROM	[#Tmp_Person]
			 WHERE	UPPER(FirstName) = UPPER(@FirstName)
			   AND	UPPER(LastName) = UPPER(@LastName)
			   AND	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'))

			IF(@Counter = 1)
				BEGIN
					SELECT	@IdPerson = Id
					  FROM	[#Tmp_Person]
					 WHERE	UPPER(FirstName) = UPPER(@FirstName)
					   AND	UPPER(LastName) = UPPER(@LastName)
					   AND	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'));

					SELECT  @IdPerson;
				END
			ELSE
				BEGIN
					IF(ISNULL(@Nit,'0') = '0')
					BEGIN
						SELECT	@IdPerson = Id
						  FROM	[#Tmp_Person]
						 WHERE	UPPER(FirstName) = UPPER(@FirstName)
						   AND	UPPER(LastName) = UPPER(@LastName)
					END
					ELSE
						BEGIN
							SELECT	@NitProperty = (FirstName + ' ' + LastName)
							  FROM	[#Tmp_Person]
							 WHERE	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'));

							 RAISERROR (N'El nit %s pertence a la persona %s',16,1, @Nit, @NitProperty);

							 SET @IdPerson = 0;
						END
				END
		END
	ELSE
		BEGIN
			INSERT INTO [Person] (FirstName, LastName, Nit, RegisterDate, RegisterUser, IsEnterprise, EnterpriseName)
			VALUES(@FirstName, @LastName, @Nit, GETDATE(), @UserName, 0, null);

			SET @IdPerson = SCOPE_IDENTITY();
			SELECT  @IdPerson;
		END