using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class EmailType : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "*")]
        [MaxLength(50, ErrorMessage = "50 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Description { get; set; }
    }
}
