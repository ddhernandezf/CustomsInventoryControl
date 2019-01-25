using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class UserLogin: Log.Properties
    {
        [Display(Name = "Usuario")]
        [Required(ErrorMessage = "*")]
        [DataType(DataType.Text)]
        public String Username { get; set; }

        [Display(Name = "Password")]
        [Required(ErrorMessage = "*")]
        [DataType(DataType.Password)]
        public String Password { get; set; }
    }
}
