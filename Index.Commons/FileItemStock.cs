using System;

namespace Index.Commons
{
    public class FileItemStock : Log.Properties
    {
        public Int32 IdFileDetail { get; set; }

        public Int32 IdFileHeader { get; set; }

        public Int32 IdState { get; set; }
        
        public Int32 TransactionLine { get; set; }
        
        public Int32 IdItem { get; set; }

        public Decimal OriginalQuantity { get; set; }
        public Decimal Stock { get; set; }
    }
}
