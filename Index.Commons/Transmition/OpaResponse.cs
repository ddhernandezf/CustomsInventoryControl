using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Commons.Transmition
{
    public class OpaResponse
    {
        public Int32 IdOpaDetail { get; set; }
        public Int32 TransactionNumber { get; set; }
        public String ErrorType { get; set; }
        public String ErrorMessage { get; set; }
        public Decimal Cif { get; set; }
        public Decimal CustomDuties { get; set; }
        public Decimal Iva { get; set; }
        public String NationalizationMulct { get; set; }
        public Decimal NationalizationMulctAmmount { get; set; }
        public String ExtemporaneusMulct { get; set; }
        public Decimal ExtemporaneusMulctAmmount { get; set; }
        public DateTime ResponseDate { get; set; }
    }
}
