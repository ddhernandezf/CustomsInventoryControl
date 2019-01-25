using System;
using System.Collections.Generic;

namespace Index.Commons.Transmition
{
    public class OpaQueue
    {
        public Int32 IdCustomer { get; set; }
        public Int32 IdAccount { get; set; }
        public Int32 IdPriority { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public String UserName { get; set; }
        public List<Commons.Transmition.OpaDetail> data { get; set; }
    }
}
