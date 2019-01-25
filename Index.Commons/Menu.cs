using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Commons
{
    public class Menu : Log.Properties
    {
        public Int32 Id { get; set; }
        public String Name { get; set; }
        public String Description { get; set; }
        public String Area { get; set; }
        public String Controller { get; set; }
        public String Action { get; set; }
        public String Parameters { get; set; }
        public Int32 IdParent { get; set; }
        public String Image { get; set; }
        public Boolean ShowMenu { get; set; }
        public Int32 Order { get; set; }
        public Boolean HasCredentials { get; set; }
    }
}
