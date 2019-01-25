using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Phone : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Persona")]
        [Required(ErrorMessage = "*")]
        public Int32 IdPerson { get; set; }

        [Display(Name = "Tipo de teléfono")]
        [Required(ErrorMessage = "*")]
        public Int32 IdPhoneType { get; set; }

        [Display(Name = "Tipo de teléfono")]
        [DataType(DataType.PhoneNumber)]
        public String PhoneTypeDescription { get; set; }

        [Display(Name = "Número telefónico")]
        [Required(ErrorMessage = "*")]
        [MaxLength(15, ErrorMessage = "15 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Number { get; set; }
    }
}
