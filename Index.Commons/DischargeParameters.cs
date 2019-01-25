using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class DischargeParameters
    {
        [Display(Name = "Detalle")]
        public Int32 IdFileDetail { get; set; }

        [Display(Name = "Línea")]
        public Int32? TransactionLine { get; set; }

        [Display(Name = "Configuración")]
        public Int32 IdFileInfoConfig { get; set; }

        [Display(Name = "Cabecera")]
        public Int32 IdFileHeader { get; set; }
        
        [Display(Name = "Documento")]
        public String IdDocument { get; set; }

        [Display(Name = "Documento")]
        public String DocumentName { get; set; }

        [Display(Name = "Cliente")]
        public Int32 IdCustomer { get; set; }

        [Display(Name = "Cliente")]
        public String CustomerName { get; set; }

        [Display(Name = "Partida")]
        public String AccountingItem { get; set; }

        [Display(Name = "Materia")]
        public Int32 IdItem { get; set; }

        [Display(Name = "Código materia")]
        public String Code { get; set; }

        [Display(Name = "Materia")]
        public String ItemName { get; set; }

        [Display(Name = "Cuenta")]
        public Int32 IdAccount { get; set; }

        [Display(Name = "Cuenta")]
        public String AccountName { get; set; }

        [Display(Name = "Formula")]
        public Boolean? UseFormula { get; set; }

        [Display(Name = "Resta")]
        public Boolean IsSubstract { get; set; }

        [Display(Name = "Carga Materia")]
        public Boolean LoadRawMaterial { get; set; }
    }
}
