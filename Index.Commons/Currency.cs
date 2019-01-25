using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Currency : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "País")]
        [Required(ErrorMessage = "*")]
        [UIHint("GridForeignKey")]
        public Int32 IdCountry { get; set; }

        [Display(Name = "País")]
        public String CountryName { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Name { get; set; }

        [Display(Name = "Descripción")]
        [Required(ErrorMessage = "*")]
        [MaxLength(1000, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Description { get; set; }

        [Display(Name = "Símbolo")]
        [Required(ErrorMessage = "*")]
        [MaxLength(4, ErrorMessage = "4 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Symbol { get; set; }

        [Display(Name = "Tasa de cambio")]
        [Required(ErrorMessage = "*")]
        public Decimal ExchangeRate { get; set; }
    }
}
