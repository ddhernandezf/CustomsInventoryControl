using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Cellar : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

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
    }
}
