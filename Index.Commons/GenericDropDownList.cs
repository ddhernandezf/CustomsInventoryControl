using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Commons
{
    public class GenericDropDownList
    {
        public Int32? Id { get; set; }
        public Int32? IdParent { get; set; }
        public String Name { get; set; }
        public String ParentName { get; set; }
    }
}
