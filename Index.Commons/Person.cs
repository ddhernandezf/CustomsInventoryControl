using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Person : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Nombres")]
        [Required(ErrorMessage = "*")]
        [MaxLength(150, ErrorMessage = "150 caracteres máximos")]
        [DataType(DataType.Text)]
        public String FirstName { get; set; }

        [Display(Name = "Apellidos")]
        [MaxLength(150, ErrorMessage = "150 caracteres máximos")]
        [DataType(DataType.Text)]
        public String LastName { get; set; }

        [Display(Name = "Nit")]
        [MaxLength(15, ErrorMessage = "15 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Nit { get; set; }

        [Display(Name = "Nombre completo")]
        public String CompleteName { get; set; }
    }
}
