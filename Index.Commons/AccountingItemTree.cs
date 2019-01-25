using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class AccountingItemTree : AccountingItem
    {
        public Boolean Assigned { get; set; }
        public List<AccountingItemTree> HasChildren { get; set; }
    }
}
