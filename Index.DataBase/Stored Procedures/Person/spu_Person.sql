CREATE PROCEDURE [dbo].[spu_Person]
	@Id				INT,
	@FirstName		VARCHAR(150),
	@LastName		VARCHAR(150),
	@Nit			VARCHAR(15),
	@RegisterUser	VARCHAR(60)
AS
	DECLARE	@First			VARCHAR(150),
			@Last			VARCHAR(150),
			@NitProperty	VARCHAR(300);

	CREATE TABLE [#Tmp_Person]
	(
		[Id] INT NOT NULL,
		[FirstName] VARCHAR(150) NOT NULL,
		[LastName] VARCHAR(150) NULL,
		[Nit] VARCHAR(15) NULL
	)

	IF(ISNULL(@Nit,'0') = '0')
		BEGIN
			UPDATE	[Person]
			   SET	FirstName = @FirstName, 
					LastName = @LastName,
					Nit = @Nit, 
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id
		END
	ELSE
		BEGIN
			INSERT INTO [#Tmp_Person](Id, FirstName, LastName, Nit)
			SELECT	Id, FirstName, LastName, Nit
			  FROM	[Person]
			 WHERE	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'))
			   AND	IsEnterprise = 0

			IF EXISTS(	SELECT	*
						  FROM	Person
						 WHERE	UPPER(Nit) = UPPER(@Nit)
						   AND	UPPER(FirstName) <> UPPER(@FirstName)
						   AND	UPPER(LastName) <> UPPER(@LastName)
						   AND	IsEnterprise = 0
						   )
				BEGIN
					SELECT	@NitProperty = (FirstName + ' ' + LastName)
					  FROM	[#Tmp_Person]
					 WHERE	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'));
					
					RAISERROR (N'El nit %s pertence a la persona %s',16,1, @Nit, @NitProperty);
				END
			ELSE
				BEGIN
					UPDATE	[Person]
					   SET	FirstName = @FirstName, 
							LastName = @LastName,
							Nit = @Nit, 
							RegisterDate = GETDATE(),
							RegisterUser = @RegisterUser
					 WHERE	Id = @Id
				END
		END
