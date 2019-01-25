using System;

namespace Index.Commons.Reports
{
    public class ExportList
    {
        public Int32 Id_Cabecera_Exportacion { get; set; }
        public String Poliza_Exportacion { get; set; }
        public Int32 Id_Cliente { get; set; }
        public DateTime? Fecha_Documento { get; set; }
        public String Numero_Factura { get; set; }
        public DateTime? Fecha_Factura { get; set; }
        public DateTime? Fecha_Sistema { get; set; }
        public String Nombre_Pais { get; set; }
        public Int32 Id_Detalle_Exportacion { get; set; }
        public Decimal? Cantidad { get; set; }
        public Decimal? Costo_Cif_Quetzales { get; set; }
        public Decimal? Costo_Fob_Quetzales { get; set; }
        public Int32? Linea_Exportacion { get; set; }
        public Int32 Id_Producto { get; set; }
        public String Des_Producto { get; set; }
        public String Codigo { get; set; }
        public String Partida_Producto { get; set; }
        public String Nombre_Cliente { get; set; }
        public String Nit { get; set; }
        public String Direccion { get; set; }
        public String Telefono { get; set; }
        public String Des_Documento { get; set; }
    }
}
