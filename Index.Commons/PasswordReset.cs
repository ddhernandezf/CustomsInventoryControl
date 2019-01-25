using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class PasswordReset : Log.Properties
    {
        [ScaffoldColumn(false)]
        [Required(ErrorMessage = "*")]
        [MaxLength(60, ErrorMessage = "60 caracteres máximos")]
        public String UserName { get; set; }

        [Display(Name = "Password web")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Password)]
        public String SitePassword { get; set; }

        [Display(Name = "Confirmar password Web")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Password)]
        public String SitePasswordConfirm { get; set; }

        [Display(Name = "Password móvil")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Password)]
        public String MobilePassword { get; set; }

        [Display(Name = "Confirmar password móvil")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Password)]
        public String MobilePasswordConfirm { get; set; }
    }
}
