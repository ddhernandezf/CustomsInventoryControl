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
    
    public partial class spg_CustomerAccountData_Result
    {
        public int IdCustomer { get; set; }
        public int IdAccount { get; set; }
        public string ResolutionRate { get; set; }
        public string RegimeRate { get; set; }
        public Nullable<System.DateTime> ResolutionStartDate { get; set; }
        public Nullable<System.DateTime> ResolutionEndDate { get; set; }
        public Nullable<System.DateTime> FiscalPeriodStartDate { get; set; }
        public Nullable<System.DateTime> FiscalPeriodEndDate { get; set; }
    }
}