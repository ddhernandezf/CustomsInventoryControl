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
    
    public partial class spg_DischargeRawMaterial_Result
    {
        public Nullable<int> IdFileDetail { get; set; }
        public int IdFormula { get; set; }
        public int IdParentItem { get; set; }
        public int IdItem { get; set; }
        public string AccountingItem { get; set; }
        public string ItemName { get; set; }
        public Nullable<decimal> Quantity { get; set; }
        public Nullable<decimal> Decrease { get; set; }
        public Nullable<bool> UseFormula { get; set; }
        public Nullable<decimal> CurrentQuantity { get; set; }
        public Nullable<decimal> CurrentDecrease { get; set; }
        public string DisplayItemName { get; set; }
        public string DisplayAccountingItem { get; set; }
    }
}
