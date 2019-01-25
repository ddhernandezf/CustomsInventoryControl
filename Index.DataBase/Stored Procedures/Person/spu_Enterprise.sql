CREATE PROCEDURE [dbo].[spu_Enterprise]
	@Id				INT,
	@EnterpriseName	VARCHAR(400),
	@Nit			VARCHAR(15),
	@RegisterUser	VARCHAR(60)
AS
	DECLARE	@First			VARCHAR(150),
			@Last			VARCHAR(150),
			@NitProperty	VARCHAR(300);

	CREATE TABLE [#Tmp_Person]
	(
		[Id] INT NOT NULL,
		[EnterpriseName] VARCHAR(400) NULL,
		[Nit] VARCHAR(15) NULL
	)

	IF(ISNULL(@Nit,'0') = '0')
		BEGIN
			UPDATE	[Person]
			   SET	EnterpriseName = @EnterpriseName,
					Nit = @Nit, 
					RegisterDate = GETDATE(),
					RegisterUser = @RegisterUser
			 WHERE	Id = @Id
		END
	ELSE
		BEGIN
			INSERT INTO [#Tmp_Person](Id, EnterpriseName, Nit)
			SELECT	Id, EnterpriseName, Nit
			  FROM	[Person]
			 WHERE	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'))
			 AND	IsEnterprise = 1

			IF EXISTS(	SELECT	*
						  FROM	Person
						 WHERE	UPPER(Nit) = UPPER(@Nit)
						   AND	UPPER(EnterpriseName) <> UPPER(@EnterpriseName)
						   AND	IsEnterprise = 1
						   AND	UPPER(Nit) <> 'C/F'
						   AND	Id <> @Id
						   )
				BEGIN
					SELECT	@NitProperty = (EnterpriseName)
					  FROM	[#Tmp_Person]
					 WHERE	UPPER(ISNULL(Nit,'0')) = UPPER(ISNULL(@Nit,'0'));
					
					RAISERROR (N'El nit %s pertence a la empresa %s',16,1, @Nit, @NitProperty);
				END
			ELSE
				BEGIN
					UPDATE	[Person]
					   SET	EnterpriseName = @EnterpriseName, 
							Nit = @Nit, 
							RegisterDate = GETDATE(),
							RegisterUser = @RegisterUser
					 WHERE	Id = @Id
				END
		END
