using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace Index.Commons
{
    public class CustomerDischarged : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Cliente")]
        [Required(ErrorMessage = "*")]
        public Int32 IdCustomer { get; set; }

        [Display(Name = "Ubicación documento")]
        [Required(ErrorMessage = "*")]
        [MaxLength(2000, ErrorMessage = "2000 caracteres máximos")]
        [DataType(DataType.ImageUrl)]
        public String FilePath { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "*")]
        [MaxLength(300, ErrorMessage = "300 caracteres máximos")]
        [DataType(DataType.Text)]
        public String DcoumentName { get; set; }

        [Display(Name = "Descripción")]
        [MaxLength(100, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        public String DcoumentDescription { get; set; }
    }
}
