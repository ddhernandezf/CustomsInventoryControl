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
    
    public partial class spg_QueueItems_Result
    {
        public int IdOpaHeader { get; set; }
        public int IdOpaDetail { get; set; }
        public string Nit { get; set; }
        public string IdDocumentStock { get; set; }
        public int TransactionLineStock { get; set; }
        public decimal QuantitySubstract { get; set; }
        public string IdDocumentSubstract { get; set; }
        public int TransactionLineSubstract { get; set; }
        public int IdState { get; set; }
        public decimal CifSubstract { get; set; }
        public decimal CustomDutiesSubstract { get; set; }
        public decimal IvaSubstract { get; set; }
    }
}
