using System;

namespace Index.Commons.Reports
{
    public class FormulaReport
    {
        public Int32? Id_Formula { get; set; }
        public Int32? Id_Producto { get; set; }
        public Int32? Id_Materia_Prima { get; set; }
        public Decimal? Cantidad { get; set; }
        public Decimal? Cantidad_Merma { get; set; }
        public String Des_Producto { get; set; }
        public String Codigo_Producto { get; set; }
        public String Partida_Producto { get; set; }
        public String Des_Materia { get; set; }
        public String Codigo_Materia { get; set; }
        public String Partida_Materia { get; set; }
        public String Nombre_Cliente { get; set; }
        public String Nit_Cliente { get; set; }
        public String Direccion { get; set; }
        public String Telefono { get; set; }
        public String Codigo_Cliente { get; set; }
        public String Des_Unidad_Producto { get; set; }
        public String Des_Unidad_Materia { get; set; }
    }
}
