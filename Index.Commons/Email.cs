using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Email : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Persona")]
        [Required(ErrorMessage = "*")]
        public Int32 IdPerson { get; set; }

        [Display(Name = "Tipo de email")]
        [Required(ErrorMessage = "*")]
        public Int32 IdEmailType { get; set; }

        [Display(Name = "Tipo de email")]
        [DataType(DataType.EmailAddress)]
        public String EmailTypeDescription { get; set; }

        [Display(Name = "Email")]
        [Required(ErrorMessage = "*")]
        [MaxLength(300, ErrorMessage = "300 caracteres máximos")]
        [DataType(DataType.EmailAddress)]
        [RegularExpression(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$",ErrorMessage = "Formato incorrecto")]
        public String EmailAddress { get; set; }
    }
}
