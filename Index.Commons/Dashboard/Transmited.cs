using System;

namespace Index.Commons.Dashboard
{
    public class Transmited
    {
        public Int32 Total { get; set; }
        public Decimal SavedQuantity { get; set; }
        public Decimal QueueQuantity { get; set; }
        public Decimal TransmitedQuantity { get; set; }
        public Decimal SavedPercent { get; set; }
        public Decimal QueuePercent { get; set; }
        public Decimal TransmitedPercent { get; set; }
    }
}
