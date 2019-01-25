using System;

namespace Index.Commons
{
    public class Parameters
    {
        public Decimal IVA { get; set; }
        public Int32 ExpirateDateMonts { get; set; }
        public Int32? DefaultCurrency { get; set; }
        public Int32 OpaFrecuencySeconds { get; set; }
        public Int32 OpaDelaySeconds { get; set; }
        public String OpaServiceUrl { get; set; }
        public String OpaServiceUser { get; set; }
        public String OpaServicePassword { get; set; }
        public Int32 DaysToExpire { get; set; }
        public String MailingUser { get; set; }
        public String MailingPassword { get; set; }
        public String MailingServer { get; set; }
        public Int32 MailingPort { get; set; }
        public Boolean MailingUseSsl { get; set; }
        public String MailingDisplayName { get; set; } 
        public Boolean MailingIsHtml { get; set; }
        public String OpaEmailBody { get; set; }
        public String MailingCC { get; set; }
        public String MailingCCO { get; set; }

    }
}
