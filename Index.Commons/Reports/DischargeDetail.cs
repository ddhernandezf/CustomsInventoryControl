
using System;

namespace Index.Commons.Reports
{
    public class DischargeDetail
    {
        public Int32? Id_Cabecera_Importacion { get; set; }
        public String Poliza_Importacion { get; set; }
        public DateTime? Fecha_Autorizacion { get; set; }
        public DateTime? Fecha_Vencimiento { get; set; }
        public Decimal? Tipo_Cambio { get; set; }
        public String Aduana_Importacion { get; set; }
        public DateTime? Fecha_Sistema { get; set; }
        public Decimal? Seguro { get; set; }
        public Decimal? Flete { get; set; }
        public String Numero_Factura { get; set; }
        public Int32? Numero_Resolucion { get; set; }
        public String Des_Garantia { get; set; }
        public String Des_Aduana { get; set; }
        public String Des_Pais { get; set; }
        public Int32? Id_Detalle_Importacion { get; set; }
        public Int32? Linea_Importacion { get; set; }
        public Decimal? Cantidad { get; set; }
        public Decimal? Costo_Cif_Quetzales { get; set; }
        public Decimal? Costo_Fob_Quetzales { get; set; }
        public Decimal? Derechos_Suspenso { get; set; }
        public Decimal? Iva_Suspenso { get; set; }
        public Int32? Id_Cliente { get; set; }
        public String Nombre_Cliente { get; set; }
        public String Nit_Cliente { get; set; }
        public String Direccion_Cliente { get; set; }
        public String Telefono_Cliente { get; set; }
        public String Codigo_Cliente { get; set; }
        public String Codigo_Importador_Exportador { get; set; }
        public String Resolucion_Calificacion { get; set; }
        public DateTime? Fecha_Resolucion { get; set; }
        public DateTime? C_Vencimiento { get; set; }
        public String Nombre_Proveedor { get; set; }
        public String Nit_Proveedor { get; set; }
        public String Direccion_Proveedor { get; set; }
        public String Telefono_Proveedor { get; set; }
        public String Des_Materia_Prima { get; set; }
        public String Codigo_Materia_Prima { get; set; }
        public String Partida_Materia { get; set; }
        public String Des_UM_Materia { get; set; }
        public String Des_Resolucion { get; set; }
        public Decimal? Cantidad_Formula { get; set; }
        public Decimal? Cantidad_Merma_Formula { get; set; }
        public Decimal? Costo_Cif_Formula { get; set; }
        public Decimal? Costo_Fob_Formula { get; set; }
        public Decimal? Suspenso_Formula { get; set; }
        public Decimal? Iva_Formula { get; set; }
        public DateTime? Fecha_Formula { get; set; }
        public Int32? Id_Detalle_Exportacion { get; set; }
        public Int32? Linea_Exportacion { get; set; }
        public Decimal? Cantidad_Exp { get; set; }
        public Decimal? Cif_Exp { get; set; }
        public Decimal? Suspenso_Exp { get; set; }
        public Decimal? IVA_Exp { get; set; }
        public String Poliza_Exportacion { get; set; }
        public Int32? Tipo_Documento { get; set; }
        public DateTime? Fecha_Documento { get; set; }
        public String Factura_Exp { get; set; }
        public String Aduana_Exportacion { get; set; }
        public String Des_Producto { get; set; }
        public String Codigo_Producto { get; set; }
        public String Partida_Producto { get; set; }
        public String Des_UM_Producto { get; set; }
        public Decimal? Cantidad_A { get; set; }
        public Decimal? Costo_Cif_A { get; set; }
        public Decimal? Suspenso_A { get; set; }
        public Decimal? IVA_A { get; set; }
        public Decimal? Cantidad_Transmitido { get; set; }
        public Decimal? CIF_Transmitido { get; set; }
        public Decimal? Suspenso_Iva_Transmitido { get; set; }
        public Decimal? Numero_Transmision { get; set; }
    }
}
