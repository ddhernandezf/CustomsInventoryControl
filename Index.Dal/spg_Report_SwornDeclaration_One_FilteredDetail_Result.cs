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
    
    public partial class spg_Report_SwornDeclaration_One_FilteredDetail_Result
    {
        public int IdFileDetail { get; set; }
        public int IdFileHeader { get; set; }
        public int IdState { get; set; }
        public string StateName { get; set; }
        public Nullable<int> TransactionLine { get; set; }
        public int IdItem { get; set; }
        public string ItemName { get; set; }
        public Nullable<decimal> ItemQuantity { get; set; }
        public Nullable<decimal> CIFCotQuetzal { get; set; }
        public Nullable<decimal> FOCostQuetzal { get; set; }
        public Nullable<decimal> CIFCotDollar { get; set; }
        public Nullable<decimal> FOCostDollar { get; set; }
        public Nullable<decimal> CustomDuties { get; set; }
        public Nullable<decimal> Iva { get; set; }
        public Nullable<decimal> TaxableBase { get; set; }
        public Nullable<decimal> TaxRate { get; set; }
        public Nullable<decimal> NetWeight { get; set; }
        public Nullable<decimal> GrossWeight { get; set; }
        public string AccountingItem { get; set; }
        public string DisplayItemName { get; set; }
        public string DisplayAccountingItem { get; set; }
    }
}
