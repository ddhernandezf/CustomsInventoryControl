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
    
    public partial class spg_FileInfoConfig_Result
    {
        public int IdFileInfoConfig { get; set; }
        public int IdFileInfo { get; set; }
        public string FileInfoName { get; set; }
        public int IdFileType { get; set; }
        public string FileTypeName { get; set; }
        public int IdAccount { get; set; }
        public string AccountName { get; set; }
        public bool UseAttached { get; set; }
        public bool IsSubstract { get; set; }
        public bool LoadRawMaterial { get; set; }
        public bool Transmissible { get; set; }
        public bool UseExpired { get; set; }
        public string DropDownListName { get; set; }
        public bool Active { get; set; }
    }
}