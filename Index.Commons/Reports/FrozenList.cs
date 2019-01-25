using System;

namespace Index.Commons.Reports
{
    public class FrozenList
    {
        public Int32? Id_Cabecera_Importacion { get; set; }
        public String Poliza_Importacion { get; set; }
        public DateTime? Fecha_Autorizacion { get; set; }
        public DateTime? Fecha_Vencimiento { get; set; }
        public Decimal? Tipo_Cambio { get; set; }
        public String Id_Aduana { get; set; }
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
        public String Des_Unidad_Medida { get; set; }
        public String Des_Resolucion { get; set; }
        public Boolean? IsFrozen { get; set; }
        public Decimal? FrozenQuantity { get; set; }
        public Decimal? CIF_Frozen { get; set; }
        public Decimal? CIFD_Frozen { get; set; }
        public Decimal? FOB_Frozen { get; set; }
        public Decimal? FOBD_Frozen { get; set; }
        public Decimal? IVA_Frozen { get; set; }
        public Decimal? DAI_Frozen { get; set; }
    }
}
