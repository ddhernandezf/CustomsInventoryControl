using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Enterprise : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "*")]
        [MaxLength(400, ErrorMessage = "400 caracteres máximos")]
        [DataType(DataType.Text)]
        public String EnterpriseName { get; set; }

        [Display(Name = "Nit")]
        [MaxLength(15, ErrorMessage = "15 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Nit { get; set; }
    }
}
