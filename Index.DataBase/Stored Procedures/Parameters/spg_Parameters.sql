CREATE PROCEDURE [spg_Parameters]
AS
	SELECT	IVA, ExpirateDateMonts, DefaultCurrency, OpaFrecuencySeconds, OpaDelaySeconds, OpaServiceUrl, OpaServiceUser,
			OpaServicePassword, DaysToExpire, MailingUser, MailingPassword, MailingServer, MailingPort, MailingUseSsl, 
			MailingDisplayName, MailingIsHtml, OpaEmailBody, MailingCC, MailingCCO
	  FROM [Parameters]