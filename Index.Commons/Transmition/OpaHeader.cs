using System;

namespace Index.Commons.Transmition
{
    public class OpaHeader
    {
        public Int32 Id { get; set; }
        public String UserName { get; set; }
        public Int32? IdCustomer { get; set; }
        public String CustomerName { get; set; }
        public Int32? IdAccount { get; set; }
        public Int32? IdPriority { get; set; }
        public String PriorityName { get; set; }
        public Int32 IdState { get; set; }
        public String StateName { get; set; }
        public DateTime? StartDateHeader { get; set; }
        public DateTime? EndDateHeader { get; set; }
        public String EnterpriseCode { get; set; }
        public String Nit { get; set; }
        public String ImporterCode { get; set; }
        public String ExporterCode { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public String RegisterUser { get; set; }
        public DateTime? RegisterDate { get; set; }
        public Int32? Transmited { get; set; }
        public String TransmitedLable { get; set; }
    }
}
