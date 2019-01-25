using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Address : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Persona")]
        [Required(ErrorMessage = "*")]
        public Int32 IdPerson { get; set; }

        [Display(Name = "Tipo de dirección")]
        [Required(ErrorMessage = "*")]
        public Int32 IdAddressType { get; set; }

        [Display(Name = "Tipo de dirección")]
        [DataType(DataType.PhoneNumber)]
        public String AddressTypeDescription { get; set; }

        [Display(Name = "Dirección")]
        [Required(ErrorMessage = "*")]
        [MaxLength(250, ErrorMessage = "250 caracteres máximos")]
        [DataType(DataType.Text)]
        public String AddressValue { get; set; }
    }
}
