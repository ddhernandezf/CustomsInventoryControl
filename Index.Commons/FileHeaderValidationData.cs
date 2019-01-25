using System;
using System.ComponentModel.DataAnnotations;


namespace Index.Commons
{
    public class FileHeaderValidationData
    {
        public Boolean HasAttached { get; set; }
        public Boolean HasDetail { get; set; }
        public Int32 IdState { get; set; }
        public String StateName { get; set; }
    }
}
