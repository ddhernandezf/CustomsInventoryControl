using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class CustomerAccount : Log.Properties
    {
        [Display(Name = "Id persona")]
        [Required(ErrorMessage = "*")]
        public Int32 IdCustomer { get; set; }

        [Display(Name = "Cuenta")]
        [Required(ErrorMessage = "*")]
        public Int32 IdAccount { get; set; }
    }
}
