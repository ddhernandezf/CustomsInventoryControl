//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Index.Dal
{
    using System;
    
    public partial class spg_Parameters_Result
    {
        public decimal IVA { get; set; }
        public int ExpirateDateMonts { get; set; }
        public Nullable<int> DefaultCurrency { get; set; }
        public int OpaFrecuencySeconds { get; set; }
        public int OpaDelaySeconds { get; set; }
        public string OpaServiceUrl { get; set; }
        public string OpaServiceUser { get; set; }
        public string OpaServicePassword { get; set; }
        public int DaysToExpire { get; set; }
        public string MailingUser { get; set; }
        public string MailingPassword { get; set; }
        public string MailingServer { get; set; }
        public int MailingPort { get; set; }
        public bool MailingUseSsl { get; set; }
        public string MailingDisplayName { get; set; }
        public bool MailingIsHtml { get; set; }
        public string OpaEmailBody { get; set; }
        public string MailingCC { get; set; }
        public string MailingCCO { get; set; }
    }
}