using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Commons
{
    public class Adjustment: Log.Properties
    {
        public Int32 IdFileItemDischarge { get; set; }
        public Int32 IdFileDetailStock { get; set; }
        public Int32 IdFileDetailSubstract { get; set; }
        public Int32 IdState { get; set; }
        public String StateName { get; set; }
        public Int32 IdItem { get; set; }

        [Display(Name = "Cantidad")]
        public Decimal Quantity { get; set; }

        [Display(Name = "Merma")]
        public Decimal Decrease { get; set; }

        public DateTime RegisterDate { get; set; }
    }
}
