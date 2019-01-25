using System;
using System.Collections.Generic;
using System.Linq;

namespace Index.Dal.REPORTS
{
    public static class ExportList
    {
        public static List<Commons.Reports.ExportList> Get(Int32 IdCustomer, Int32 IdAccount, DateTime StartDate, DateTime EndDate, Boolean? GetTransmited)
        {
            List<Commons.Reports.ExportList> obj = new List<Commons.Reports.ExportList>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Report_ExportList_Result> result = db.spg_Report_ExportList(IdCustomer, IdAccount, StartDate, EndDate, GetTransmited).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Reports.ExportList()
                    {
                        Id_Cabecera_Exportacion = x.Id_Cabecera_Exportacion,
                        Poliza_Exportacion = x.Poliza_Exportacion,
                        Id_Cliente = x.Id_Cliente,
                        Fecha_Documento = x.Fecha_Documento,
                        Numero_Factura = x.Numero_Factura,
                        Fecha_Factura = x.Fecha_Factura,
                        Fecha_Sistema = x.Fecha_Sistema,
                        Nombre_Pais = x.Nombre_Pais,
                        Id_Detalle_Exportacion = x.Id_Detalle_Exportacion,
                        Cantidad = x.Cantidad,
                        Costo_Cif_Quetzales  = x.Costo_Cif_Quetzales,
                        Costo_Fob_Quetzales = x.Costo_Fob_Quetzales,
                        Linea_Exportacion = x.Linea_Exportacion,
                        Id_Producto = x.Id_Producto,
                        Des_Producto = x.Des_Producto,
                        Codigo = x.Codigo,
                        Partida_Producto = x.Partida_Producto,
                        Nombre_Cliente = x.Nombre_Cliente,
                        Nit = x.Nit,
                        Direccion = x.Direccion,
                        Telefono = x.Telefono,
                        Des_Documento = x.Des_Documento
                    });
                });
            }

            return obj;
        }
    }
}
