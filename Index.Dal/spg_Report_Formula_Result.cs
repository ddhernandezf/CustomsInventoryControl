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
    
    public partial class spg_Report_Formula_Result
    {
        public int Id_Formula { get; set; }
        public int Id_Producto { get; set; }
        public int Id_Materia_Prima { get; set; }
        public decimal Cantidad { get; set; }
        public decimal Cantidad_Merma { get; set; }
        public string Des_Producto { get; set; }
        public string Codigo_Producto { get; set; }
        public string Partida_Producto { get; set; }
        public string Des_Materia { get; set; }
        public string Codigo_Materia { get; set; }
        public string Partida_Materia { get; set; }
        public string Nombre_Cliente { get; set; }
        public string Nit_Cliente { get; set; }
        public string Direccion { get; set; }
        public string Telefono { get; set; }
        public string Codigo_Cliente { get; set; }
        public string Des_Unidad_Producto { get; set; }
        public string Des_Unidad_Materia { get; set; }
    }
}
