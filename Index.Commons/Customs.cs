using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Customs : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "País")]
        [Required(ErrorMessage = "*")]
        public Int32 IdCountry { get; set; }

        [Display(Name = "País")]
        public String CountryName { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "*")]
        [MaxLength(250, ErrorMessage = "250 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Name { get; set; }

        [Display(Name = "Dirección")]
        [Required(ErrorMessage = "*")]
        [MaxLength(300, ErrorMessage = "300 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Address { get; set; }

        [Display(Name = "Código")]
        [Required(ErrorMessage = "*")]
        [MaxLength(10, ErrorMessage = "10 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Code { get; set; }
    }
}
