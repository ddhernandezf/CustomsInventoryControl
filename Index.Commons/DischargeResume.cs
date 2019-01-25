using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Commons
{
    public class DischargeResume
    {
        public Int32 Id { get; set; }
        public Int32 IdFileHeader { get; set; }
        public Int32 IdFileDetailSubstract { get; set; }
        public Int32 IdFileDetailStock { get; set; }
        public Int32 IdState { get; set; }
        public Int32 IdItem { get; set; }

        [Display(Name = "Línea")]
        public Int32 TransactionLine { get; set; }

        [Display(Name = "Documento")]
        public String DocumentName { get; set; }

        [Display(Name = "Cantidad")]
        public Decimal InventoryQuantity { get; set; }

        [Display(Name = "Existencia")]
        public Decimal Stock { get; set; }

        [Display(Name = "Descargo")]
        public Decimal Quantity { get; set; }

        [Display(Name = "Merma")]
        public Decimal Decrease { get; set; }

        [Display(Name = "Materia")]
        public String ItemName { get; set; }

        [Display(Name = "Inciso Arancelario")]
        public String AccountingItem { get; set; }

        [Display(Name = "CIF")]
        public Decimal Cif { get; set; }

        [Display(Name = "DAI")]
        public Decimal Dai { get; set; }

        [Display(Name = "IVA")]
        public Decimal Iva { get; set; }

        [Display(Name = "Estado")]
        public String StateName { get; set; }

        [Display(Name = "Fecha")]
        public DateTime? TransactionDate { get; set; }
    }
}
