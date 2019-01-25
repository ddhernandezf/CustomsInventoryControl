using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Supplier : Person
    {
        [ScaffoldColumn(false)]
        public Int32 IdPerson { get; set; }

        [Display(Name = "Observaciones")]
        [MaxLength(1000, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Observations { get; set; }

        [Display(Name = "Cliente Destino")]
        public Boolean IsDestinySupplier { get; set; }
    }
}
