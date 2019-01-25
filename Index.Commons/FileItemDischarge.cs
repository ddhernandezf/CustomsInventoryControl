
using System;
using System.ComponentModel.DataAnnotations;


namespace Index.Commons
{
    public class FileItemDischarge : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Detalle Rebaja")]
        [Required(ErrorMessage = "*")]
        public Int32 IdFileDetailSubstract { get; set; }

        public Int32 IdAccount { get; set; }

        [Display(Name = "Detalle Movimiento")]
        [Required(ErrorMessage = "*")]
        public Int32 IdFileDetailStock { get; set; }

        [Display(Name = "Estado")]
        [Required(ErrorMessage = "*")]
        public Int32 IdState { get; set; }

        public String StateName { get; set; }

        [Display(Name = "Cantidad")]
        [Required(ErrorMessage = "*")]
        public Decimal Quantity { get; set; }

        [Display(Name = "Merma")]
        [Required(ErrorMessage = "*")]
        public Decimal Decrease { get; set; }

        [Display(Name = "CIF")]
        [Required(ErrorMessage = "*")]
        public Decimal CIF { get; set; }

        [Display(Name = "FO")]
        [Required(ErrorMessage = "*")]
        public Decimal FO { get; set; }

        [Display(Name = "DAI")]
        public Decimal CustomDuties { get; set; }

        [Display(Name = "IVA")]
        public Decimal IVA { get; set; }

        public Boolean UseFormula { get; set; }

        public Boolean IsAdjustment { get; set; }
    }
}
