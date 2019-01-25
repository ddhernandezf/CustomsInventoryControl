using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Freeze
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Materia Prima")]
        public String ItemName { get; set; }

        [Display(Name = "Linea")]
        public Int32? TransactionLine { get; set; }

        [Display(Name = "Cantidad Original")]
        public Decimal Quantity { get; set; }

        [Display(Name = "Existencia")]
        public Decimal Stock { get; set; }

        [Display(Name = "Congelado")]
        public Decimal Discharge { get; set; }

        [Display(Name = "Total")]
        public Decimal Balance { get; set; }
        public Boolean IsFrozen { get; set; }
    }
}
