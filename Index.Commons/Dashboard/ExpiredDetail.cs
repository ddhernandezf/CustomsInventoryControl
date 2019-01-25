using System;

namespace Index.Commons.Dashboard
{
    public class ExpiredDetail
    {
        public Int32 IdFileHeader { get; set; }
        public String Document { get; set; }
        public Int32 IdState { get; set; }
        public String StateName { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public Int32 Days { get; set; }
        public String Label { get; set; }
    }
}
