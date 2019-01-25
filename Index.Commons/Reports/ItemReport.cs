using System;

namespace Index.Commons.Reports
{
    public class ItemReport
    {
        public Int32 IdCustomer { get; set; }
        public Int32 IdAccount { get; set; }
        public Int32 IdItem { get; set; }
        public String ItemName { get; set; }
        public String ItemDescription { get; set; }
        public String ItemCode { get; set; }
        public String ItemBarCode { get; set; }
        public String AccountingItem { get; set; }
        public String UM_Name { get; set; }
        public Boolean? IsProduct { get; set; }
        public Boolean? Formula { get; set; }
        public String CustomerName { get; set; }
        public String ImporterCode { get; set; }
        public String Nit { get; set; }
        public String PersonCode { get; set; }
        public String Address { get; set; }
        public String PhoneNumber { get; set; }
    }
}
