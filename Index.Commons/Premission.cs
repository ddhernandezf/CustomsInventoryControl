using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Premission : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Name { get; set; }

        [Display(Name = "Descripción")]
        [MaxLength(1000, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Description { get; set; }

        [Display(Name = "Área")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Area { get; set; }

        [Display(Name = "Controlador")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Controller { get; set; }

        [Display(Name = "Acción")]
        [Required(ErrorMessage = "*")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Action { get; set; }

        [Display(Name = "Parámetros")]
        [MaxLength(1000, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Parameters { get; set; }

        [Display(Name = "Permiso padre")]
        public Int32 IdParent { get; set; }

        [Display(Name = "Id Rol")]
        public Int32 IdRole { get; set; }

        [Display(Name = "Rol")]
        public String RoleName { get; set; }
    }
}
