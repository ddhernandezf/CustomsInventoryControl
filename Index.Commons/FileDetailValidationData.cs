using System;
using System.ComponentModel.DataAnnotations;


namespace Index.Commons
{
    public class FileDetailValidationData
    {
        public Boolean HasMove { get; set; }
        public Int32 IdState { get; set; }
        public String StateName { get; set; }
    }
}
