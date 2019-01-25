using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Commons
{
    public class CustomerAssigned : Log.Properties
    {
        public Int32 IdCutomerType { get; set; }
        public Int32 IdPerson { get; set; }
        public String Name { get; set; }
        public Boolean Assigned { get; set; }
    }
}
