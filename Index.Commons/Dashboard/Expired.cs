using System;

namespace Index.Commons.Dashboard
{
    public class Expired
    {
        public Int32 Total { get; set; }
        public Decimal InTimeQuantity { get; set; }
        public Decimal ToExpireQuantity { get; set; }
        public Decimal ExpiredQuantity { get; set; }
        public Decimal InTimePercent { get; set; }
        public Decimal ToExpirePercent { get; set; }
        public Decimal ExpiredPercent { get; set; }
    }
}
