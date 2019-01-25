using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Resolution : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Cliente")]
        [Required(ErrorMessage = "*")]
        public Int32 IdCustomer { get; set; }

        [Display(Name = "Cuenta")]
        [Required(ErrorMessage = "*")]
        public Int32 IdAccount { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Name { get; set; }

        [Display(Name = "Descripción")]
        [MaxLength(1000, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Description { get; set; }

        [Display(Name = "Fecha calificación")]
        [Required(ErrorMessage = "*")]
        public DateTime RateDate { get; set; }
    }
}
