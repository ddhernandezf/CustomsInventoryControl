//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Index.Dal
{
    using System;
    
    public partial class spg_MenuByUser_Result
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Area { get; set; }
        public string Controller { get; set; }
        public string Action { get; set; }
        public string Parameters { get; set; }
        public int IdParent { get; set; }
        public string Image { get; set; }
        public bool ShowMenu { get; set; }
        public int Order { get; set; }
        public bool HasCredentials { get; set; }
    }
}
