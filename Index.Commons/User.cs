using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class User : Person
    {
        [ScaffoldColumn(false)]
        [Display(Name = "Nombre de usuario")]
        [Required(ErrorMessage = "*")]
        [MaxLength(60, ErrorMessage = "60 caracteres máximos")]
        public String UserName { get; set; }

        [Display(Name = "Password web")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Password)]
        public String SitePassword { get; set; }

        [Display(Name = "Password Móviles")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Password)]
        public String MobilePassword { get; set; }

        [Display(Name = "Cambia password")]
        [Required(ErrorMessage = "*")]
        public Boolean PasswordReset { get; set; }

        [Display(Name = "Ingresa web")]
        [Required(ErrorMessage = "*")]
        public Boolean OAuthSite { get; set; }

        [Display(Name = "Ingresa móviles")]
        [Required(ErrorMessage = "*")]
        public Boolean OAuthMobile { get; set; }

        [Display(Name = "Activo")]
        [Required(ErrorMessage = "*")]
        public Boolean Active { get; set; }

        [Display(Name = "Roles")]
        public List<UserByRole> Roles { get; set; }
    }
}
