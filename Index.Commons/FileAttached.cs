
using System;
using System.ComponentModel.DataAnnotations;


namespace Index.Commons
{
    public class FileAttached : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Cabecera")]
        public Int32 IdFileHeader { get; set; }
        
        [Display(Name = "Cliente/Proveedor")]
        public Int32? IdSupplier { get; set; }

        [Display(Name = "")]
        public String SupplierName { get; set; }

        [Display(Name = "Descripción")]
        public String Description { get; set; }

        [Display(Name = "Número")]
        public String AttachedNumber { get; set; }

        [Display(Name = "Fecha")]
        public DateTime? AttachedDate { get; set; }
    }
}
