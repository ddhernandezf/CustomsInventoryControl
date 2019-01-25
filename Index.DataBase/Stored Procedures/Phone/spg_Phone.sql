CREATE PROCEDURE [dbo].[spg_Phone]
	@IdPerson		INT,
	@IdPhoneType	INT
AS
	IF(ISNULL(@IdPerson, 0) = 0)
		BEGIN
			IF(ISNULL(@IdPhoneType, 0) = 0)
				BEGIN
					SELECT	p.Id, p.IdPerson, p.IdPhoneType, p.Number, pt.Description [PhoneTypeDesc]
					  FROM	Phone p INNER JOIN PhoneType pt ON p.IdPhoneType = pt.Id
				END
			ELSE
				BEGIN
					SELECT	p.Id, p.IdPerson, p.IdPhoneType, p.Number, pt.Description [PhoneTypeDesc]
					  FROM	Phone p INNER JOIN PhoneType pt ON p.IdPhoneType = pt.Id
					 WHERE	p.IdPhoneType = @IdPhoneType
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdPhoneType, 0) = 0)
				BEGIN
					SELECT	p.Id, p.IdPerson, p.IdPhoneType, p.Number, pt.Description [PhoneTypeDesc]
					  FROM	Phone p INNER JOIN PhoneType pt ON p.IdPhoneType = pt.Id
					 WHERE	p.IdPerson = @IdPerson
				END
			ELSE
				BEGIN
					SELECT	p.Id, p.IdPerson, p.IdPhoneType, p.Number, pt.Description [PhoneTypeDesc]
					  FROM	Phone p INNER JOIN PhoneType pt ON p.IdPhoneType = pt.Id
					 WHERE	p.IdPerson = @IdPerson
					   AND	p.IdPhoneType = @IdPhoneType
				END
		END

