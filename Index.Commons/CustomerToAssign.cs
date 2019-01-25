using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class CustomerToAssign : Customer
    {
        public Boolean IsAssigned { get; set; }
    }
}
