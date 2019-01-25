CREATE PROCEDURE [dbo].[spg_Email]
	@IdPerson		INT,
	@IdEmailType	INT
AS
	IF(ISNULL(@IdPerson, 0) = 0)
		BEGIN
			IF(ISNULL(@IdEmailType, 0) = 0)
				BEGIN
					SELECT	p.Id, p.IdPerson, p.IdEmailType, p.Email, pt.Description [PhoneTypeDesc]
					  FROM	Email p INNER JOIN EmailType pt ON p.IdEmailType = pt.Id
				END
			ELSE
				BEGIN
					SELECT	p.Id, p.IdPerson, p.IdEmailType, p.Email, pt.Description [PhoneTypeDesc]
					  FROM	Email p INNER JOIN EmailType pt ON p.IdEmailType = pt.Id
					 WHERE	p.IdEmailType = @IdEmailType
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdEmailType, 0) = 0)
				BEGIN
					SELECT	p.Id, p.IdPerson, p.IdEmailType, p.Email, pt.Description [PhoneTypeDesc]
					  FROM	Email p INNER JOIN EmailType pt ON p.IdEmailType = pt.Id
					 WHERE	p.IdPerson = @IdPerson
				END
			ELSE
				BEGIN
					SELECT	p.Id, p.IdPerson, p.IdEmailType, p.Email, pt.Description [PhoneTypeDesc]
					  FROM	Email p INNER JOIN EmailType pt ON p.IdEmailType = pt.Id
					 WHERE	p.IdPerson = @IdPerson
					   AND	p.IdEmailType = @IdEmailType
				END
		END

