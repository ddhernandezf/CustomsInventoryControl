using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Field : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Tabla")]
        public Int32 IdTable { get; set; }

        [Display(Name = "Tabla")]
        public String TableName { get; set; }

        [Display(Name = "Nombre Campo")]
        public String FieldName { get; set; }

        [Display(Name = "Objeto Html")]
        public String HtmlObject { get; set; }

        [Display(Name = "Nombre Base de datos")]
        public String DataBaseName { get; set; }

        [Display(Name = "Requerido i.")]
        public Boolean IsRequeriedInternal { get; set; }

        [Display(Name = "Documento")]
        [Required(ErrorMessage = "*")]
        public Int32 IdFileInfoConfig { get; set; }
        public Int32 IdMaster { get; set; }

        [Display(Name = "Etiqueta")]
        [Required(ErrorMessage = "*")]
        public String Label { get; set; }

        [Display(Name = "Visible")]
        [Required(ErrorMessage = "*")]
        public Boolean IsUsed { get; set; }

        [Display(Name = "Requerido")]
        [Required(ErrorMessage = "*")]
        public Boolean IsRequeried { get; set; }
    }
}
