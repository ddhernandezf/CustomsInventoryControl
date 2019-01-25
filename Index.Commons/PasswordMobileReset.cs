using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class PasswordMobileReset : Log.Properties
    {
        [ScaffoldColumn(false)]
        [Required(ErrorMessage = "*")]
        [MaxLength(60, ErrorMessage = "60 caracteres máximos")]
        public String UserName { get; set; }

        [Display(Name = "Password Moviles")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Password)]
        public String MobilePassword { get; set; }

        [Display(Name = "Confirmar password Moviles")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Password)]
        public String MobilePasswordConfirm { get; set; }
    }
}
