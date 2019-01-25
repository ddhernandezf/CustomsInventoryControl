using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class PasswordSiteReset : Log.Properties
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

        [Display(Name = "Confirmar password web")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Password)]
        public String SitePasswordConfirm { get; set; }
    }
}
