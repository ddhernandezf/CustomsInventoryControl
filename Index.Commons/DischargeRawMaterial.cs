using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class DischargeRawMaterial
    {
        [Display(Name = "Detalle")]
        public Int32? IdFileDetail { get; set; }

        [Display(Name = "Formula")]
        public Int32? IdFormula { get; set; }

        [Display(Name = "Materia padre")]
        public Int32? IdParentItem { get; set; }

        [Display(Name = "Materia")]
        public Int32? IdItem { get; set; }

        [Display(Name = "Partida")]
        public String AccountingItem { get; set; }

        [Display(Name = "Partida")]
        public String DisplayAccountingItem { get; set; }

        [Display(Name = "Materia")]
        public String ItemName { get; set; }

        [Display(Name = "Materia")]
        public String DisplayItemName { get; set; }

        [Display(Name = "Cantidad")]
        public Decimal? Quantity { get; set; }

        [Display(Name = "Merma")]
        public Decimal? Decrease { get; set; }

        [Display(Name = "Cantidad Actual")]
        public Decimal? CurrentQuantity { get; set; }

        [Display(Name = "Merma Actual")]
        public Decimal? CurrentDecrease { get; set; }

        [Display(Name = "Etiqueta Cantidad")]
        public String QuantityLabel { get; set; }

        [Display(Name = "Etiqueta Merma")]
        public String DecreaseLabel { get; set; }

        public Boolean? UseFormula { get; set; }
    }
}
