using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Country : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "*")]
        [MaxLength(200, ErrorMessage = "200 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Name { get; set; }

        [Display(Name = "Padre")]
        public Int32 IdParent { get; set; }
    }
}
