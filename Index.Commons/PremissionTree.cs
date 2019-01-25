using System;
using System.Collections.Generic;

namespace Index.Commons
{
    public class PremissionTree : Log.Properties
    {
        public Int32 Id { get; set; }
        public Int32? IdParent { get; set; }
        public String Name { get; set; }
        public Boolean Assigned { get; set; }
        public String Image { get; set; }
        public List<PremissionTree> HasChildren { get; set;}
    }
}
