using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons.FileMasterDisplay
{
    public class Field : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32? Id { get; set; }

        [Display(Name = "Documento")]
        [Required(ErrorMessage = "*")]
        public Int32? IdFileInfoConfig { get; set; }

        [Display(Name = "Campo")]
        [Required(ErrorMessage = "*")]
        public Int32? IdField { get; set; }

        [Display(Name = "Nombre")]
        public String Name { get; set; }

        [Display(Name = "Nombre Interno")]
        public String DatabaseName { get; set; }

        [Display(Name = "Etiqueta")]
        [Required(ErrorMessage = "*")]
        public String Label { get; set; }

        [Display(Name = "Activo")]
        [Required(ErrorMessage = "*")]
        public Boolean? IsUsed { get; set; }

        [Display(Name = "Requerido")]
        [Required(ErrorMessage = "*")]
        public Boolean? IsRequeried { get; set; }
    }
}
