using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Formula : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Producto")]
        [Required(ErrorMessage = "*")]
        public Int32 IdMainItem { get; set; }

        [Display(Name = "Producto")]
        public String MainItem { get; set; }

        [Display(Name = "Materia Prima")]
        [Required(ErrorMessage = "*")]
        public Int32 IdDetailItem { get; set; }

        [Display(Name = "Materia Prima")]
        public String DetailItem { get; set; }

        [Display(Name = "Materia Prima")]
        public String DisplayDetailItem { get; set; }

        [Display(Name = "Inciso Arancelario")]
        public String DetailAccountingItem { get; set; }

        [Display(Name = "Inciso Arancelario")]
        public String DisplayDetailAccountingItem { get; set; }

        [Display(Name = "Cantidad")]
        [Required(ErrorMessage = "*")]
        public Decimal Quantity { get; set; }

        [Display(Name = "Merma")]
        [Required(ErrorMessage = "*")]
        public Decimal Decrease { get; set; }

        [Display(Name = "Cliente")]
        public Int32 IdCustomer { get; set; }

        [Display(Name = "Activo")]
        [Required(ErrorMessage = "*")]
        public Boolean Active { get; set; }
    }
}
