using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Customer : Enterprise
    {
        [Display(Name = "Representante legal")]
        [MaxLength(300, ErrorMessage = "300 caracteres máximos")]
        [DataType(DataType.Text)]
        public String LegalRepresentative { get; set; }

        [Display(Name = "Código de empresa")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String PersonCode { get; set; }

        [Display(Name = "Código importador")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String ImporterCode { get; set; }

        [Display(Name = "Código exportador")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String ExporterCode { get; set; }

        [Display(Name = "Fecha vencimiento fianza")]
        public DateTime? BondEndDate { get; set; }

        public String strBondEndDate { get; set; }

        [Display(Name = "Observaciones")]
        [MaxLength(1000, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Observations { get; set; }
    }
}
