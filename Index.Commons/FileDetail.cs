using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class FileDetail : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Cabecera")]
        public Int32 IdFileHeader { get; set; }

        [Display(Name = "Estado")]
        public Int32 IdState { get; set; }

        [Display(Name = "Estado")]
        public String StateName { get; set; }

        [Display(Name = "Materia")]
        [Required(ErrorMessage = "*")]
        public Int32 IdItem { get; set; }

        public Int32 IdItemUpdate { get; set; }

        [Display(Name = "Materia")]
        public String ItemName { get; set; }

        [Display(Name = "No. Registro")]
        public Int32? TransactionLine { get; set; }

        [Display(Name = "Cantidad")]
        public Decimal? Quantity { get; set; }

        [Display(Name = "CIF Q")]
        public Decimal? CIFQ { get; set; }

        [Display(Name = "FO Q")]
        public Decimal? FOQ { get; set; }

        [Display(Name = "CIF $")]
        public Decimal? CIFD { get; set; }

        [Display(Name = "FO $")]
        public Decimal? FOD { get; set; }

        [Display(Name = "IVA")]
        public Decimal? IVA { get; set; }

        [Display(Name = "Base Imponible")]
        public Decimal? TaxableBase { get; set; }

        [Display(Name = "Tasa Impositiva")]
        public Decimal? TaxRate { get; set; }

        [Display(Name = "Tasa Impositiva")]
        public Decimal? NetWeight { get; set; }

        [Display(Name = "Tasa Impositiva")]
        public Decimal? GrossWeight { get; set; }

        [Display(Name = "DAI")]
        public Decimal? CustomDuties { get; set; }

        public String DisplayItemName { get; set; }
        public String AccountingItem { get; set; }
        public String DisplayAccountingItem { get; set; }
        public Boolean IsFrozen { get; set; }
    }
}
