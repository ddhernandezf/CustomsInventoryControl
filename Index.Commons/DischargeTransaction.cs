using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Commons
{
    public class DischargeTransaction
    {
        [Display(Name = "Cliente")]
        public Int32 IdCustomer { get; set; }

        [Display(Name = "Cuenta")]
        public Int32 IdAccount { get; set; }

        [Display(Name = "Cuenta")]
        public String AccountName { get; set; }

        [Display(Name = "Detalle")]
        public Int32 IdFileDetail { get; set; }

        [Display(Name = "No. Docto")]
        public String IdDocument { get; set; }

        [Display(Name = "Documento")]
        public Int32 IdFileHeader { get; set; }

        [Display(Name = "Documento")]
        public String DocumentName { get; set; }

        [Display(Name = "Documento")]
        public String DisplayDocument { get; set; }

        [Display(Name = "Materia")]
        public Int32 IdItem { get; set; }

        [Display(Name = "Cantidad")]
        public Decimal Original { get; set; }

        [Display(Name = "Existencia")]
        public Decimal Stock { get; set; }

        [Display(Name = "Fecha")]
        public DateTime? TransactionDate { get; set; }

        [Display(Name = "Cantidad")]
        public Decimal? Quantity { get; set; }

        [Display(Name = "Merma")]
        public Decimal? Decrease { get; set; }

        [Display(Name = "CIF")]
        public Decimal? CIFcost { get; set; }

        [Display(Name = "FOB")]
        public Decimal? FOcost { get; set; }

        [Display(Name = "DAI")]
        public Decimal? CustomDuties { get; set; }

        [Display(Name = "IVA")]
        public Decimal? Iva { get; set; }

        [Display(Name = "Estado")]
        public Int32? IdState { get; set; }

        [Display(Name = "Estado")]
        public String StateName { get; set; }

        [Display(Name = "Expiró")]
        public Boolean IsExpired { get; set; }

        [Display(Name = "Línea")]
        public Int32 TransactionLine { get; set; }
    }
}
