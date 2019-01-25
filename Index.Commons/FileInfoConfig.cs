using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class FileInfoConfig : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Documento")]
        [Required(ErrorMessage = "*")]
        public Int32 IdFileInfo { get; set; }

        [Display(Name = "Documento")]
        public String FileInfoName { get; set; }

        [Display(Name = "Tipo Documento")]
        [Required(ErrorMessage = "*")]
        public Int32 IdFileInfoType { get; set; }

        [Display(Name = "Tipo Documento")]
        public String FileInfoTypeName { get; set; }

        [Display(Name = "Cuenta")]
        [Required(ErrorMessage = "*")]
        public Int32 IdAccount { get; set; }

        [Display(Name = "Cuenta")]
        public String AccountName { get; set; }

        [Display(Name = "Adjuntos")]
        [Required(ErrorMessage = "*")]
        public Boolean UseAttached { get; set; }

        [Display(Name = "Suma")]
        [Required(ErrorMessage = "*")]
        public Boolean Addition { get; set; }

        [Display(Name = "Resta")]
        [Required(ErrorMessage = "*")]
        public Boolean Substraction { get; set; }

        [Display(Name = "Materia Prima")]
        [Required(ErrorMessage = "*")]
        public Boolean UseRawMaterial { get; set; }

        [Display(Name = "Transmisible")]
        [Required(ErrorMessage = "*")]
        public Boolean Transmissible { get; set; }

        [Display(Name = "Expiración")]
        [Required(ErrorMessage = "*")]
        public Boolean UseExpired { get; set; }

        [Display(Name = "Documento")]
        public String DropDownName { get; set; }

        [Display(Name = "Activo")]
        [Required(ErrorMessage = "*")]
        public Boolean Active { get; set; }
    }
}
