using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Commons.Transmition
{
    public class OpaDetail
    {
        public Int32 Id { get; set; }
        public Int32 IdOpaHeader { get; set; }
        public Int32 IdState { get; set; }
        public String StateName { get; set; }
        public Int32 IdFileItemDischarge { get; set; }
        public Int32 IdFileHeaderSubstract { get; set; }
        public Int32 IdFileDetailSubstract { get; set; }
        public String IdDocumentSubstract { get; set; }
        public Int32? TransactionLineSubstract { get; set; }
        public String DocumentNameSubstract { get; set; }
        public Decimal? QuantitySubstract { get; set; }
        public Decimal CifSubstract { get; set; }
        public Decimal? FobSubstract { get; set; }
        public Decimal? CustomDutiesSubstract { get; set; }
        public Decimal IvaSubstract { get; set; }
        public Int32 IdFileHeaderStock { get; set; }
        public Int32 IdFileDetailStock { get; set; }
        public String IdDocumentStock { get; set; }
        public Int32? TransactionLineStock { get; set; }
        public String DocumentNameStock { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public Boolean Assigned { get; set; }
        public DateTime? AuthorizationDate { get; set; }
        public DateTime? RegisterDate { get; set; }
        public Boolean? IsValid { get; set; }
        public String Message { get; set; }
        public Int32 Errors { get; set; }
    }
}
