using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class UnitMeasurement : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Name { get; set; }

        [Display(Name = "Descripción")]
        [MaxLength(1000, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Description { get; set; }

        [Display(Name = "Símbolo")]
        [Required(ErrorMessage = "*")]
        [MaxLength(4, ErrorMessage = "4 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Symbol { get; set; }
    }
}
