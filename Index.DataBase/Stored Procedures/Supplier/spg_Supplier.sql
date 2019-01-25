CREATE PROCEDURE [dbo].[spg_Supplier]
	@IdPerson	INT,
	@IsDestinySupplier	BIT
AS
	IF(ISNULL(@IdPerson,0) = 0)
		BEGIN
			IF(@IsDestinySupplier IS NULL)
				BEGIN
					SELECT	s.IdPerson, p.FirstName, p.LastName, p.Nit, s.Observations, s.IsDestinySupplier
					  FROM	[Supplier] s INNER JOIN [Person] p ON p.Id = s.IdPerson
				END
			ELSE
				BEGIN
					SELECT	s.IdPerson, p.FirstName, p.LastName, p.Nit, s.Observations, s.IsDestinySupplier
					  FROM	[Supplier] s INNER JOIN [Person] p ON p.Id = s.IdPerson
					 WHERE	s.IsDestinySupplier = @IsDestinySupplier
				END
		END
	ELSE
		BEGIN
			IF(ISNULL(@IsDestinySupplier,0) = 0)
				BEGIN
					SELECT	s.IdPerson, p.FirstName, p.LastName, p.Nit, s.Observations
					  FROM	[Supplier] s INNER JOIN [Person] p ON p.Id = s.IdPerson
					 WHERE	s.IdPerson = @IdPerson
				END
			ELSE
				BEGIN
					SELECT	s.IdPerson, p.FirstName, p.LastName, p.Nit, s.Observations
					  FROM	[Supplier] s INNER JOIN [Person] p ON p.Id = s.IdPerson
					 WHERE	s.IdPerson = @IdPerson
					   AND	s.IsDestinySupplier = @IsDestinySupplier
				END
		END
