using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Commons.Transmition
{
    public class OpaMessageDetail
    {
        public DateTime ResponseDate { get; set; }
        public String Message { get; set; }
        public String ErrorType { get; set; }
    }
}
