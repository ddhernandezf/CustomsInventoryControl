
CREATE PROCEDURE [dbo].[spg_Address]
	@IdPerson		INT,
	@IdAddressType	INT
AS
	IF(ISNULL(@IdPerson, 0) = 0)
		BEGIN
			IF(ISNULL(@IdAddressType, 0) = 0)
				BEGIN
					SELECT	a.Id, a.IdPerson, a.IdAddressType, a.[Address], atp.[Description] [AddressTypeDesc]
					  FROM	[Address] a INNER JOIN AddressType atp ON a.IdAddressType = atp.Id
				END
			ELSE
				BEGIN
					SELECT	a.Id, a.IdPerson, a.IdAddressType, a.[Address], atp.[Description] [AddressTypeDesc]
					  FROM	[Address] a INNER JOIN AddressType atp ON a.IdAddressType = atp.Id
					 WHERE	a.IdAddressType = @IdAddressType
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IdAddressType, 0) = 0)
				BEGIN
					SELECT	a.Id, a.IdPerson, a.IdAddressType, a.[Address], atp.[Description] [AddressTypeDesc]
					  FROM	[Address] a INNER JOIN AddressType atp ON a.IdAddressType = atp.Id
					 WHERE	a.IdPerson = @IdPerson
				END
			ELSE
				BEGIN
					SELECT	a.Id, a.IdPerson, a.IdAddressType, a.[Address], atp.[Description] [AddressTypeDesc]
					  FROM	[Address] a INNER JOIN AddressType atp ON a.IdAddressType = atp.Id
					 WHERE	a.IdPerson = @IdPerson
					   AND	a.IdAddressType = @IdAddressType
				END
		END

