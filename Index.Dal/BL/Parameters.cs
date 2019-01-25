using System;
using System.Data.Entity.Core.Objects;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal
{
    public static class Parameters
    {
        public static Commons.Parameters Get()
        {
            Commons.Parameters obj = new Commons.Parameters();
            using (IndexEntities db = new IndexEntities())
            {
                spg_Parameters_Result result = db.spg_Parameters().FirstOrDefault();
                obj.IVA = result.IVA;
                obj.ExpirateDateMonts = result.ExpirateDateMonts;
                obj.DefaultCurrency = result.DefaultCurrency;
                obj.OpaFrecuencySeconds = result.OpaFrecuencySeconds;
                obj.OpaDelaySeconds = result.OpaDelaySeconds;
                obj.OpaServiceUrl = result.OpaServiceUrl;
                obj.OpaServiceUser = result.OpaServiceUser;
                obj.OpaServicePassword = result.OpaServicePassword;
                obj.DaysToExpire = result.DaysToExpire;
                obj.MailingUser = result.MailingUser;
                obj.MailingPassword = result.MailingPassword;
                obj.MailingServer = result.MailingServer;
                obj.MailingPort = result.MailingPort;
                obj.MailingUseSsl = result.MailingUseSsl;
                obj.MailingDisplayName = result.MailingDisplayName;
                obj.MailingIsHtml = result.MailingIsHtml;
                obj.OpaEmailBody = result.OpaEmailBody;
                obj.MailingCC = result.MailingCC;
                obj.MailingCCO = result.MailingCCO;
            }

            return obj;
        }
    }
}
