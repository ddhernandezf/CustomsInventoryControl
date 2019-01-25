using System;
using System.Collections.Generic;
using System.Linq;
using Index.Commons.Reports;

namespace Index.Dal.REPORTS
{
    public static class FrozenList
    {
        public static List<Commons.Reports.FrozenList> Get(Int32 IdCustomer, Int32 IdAccount, DateTime? StartDate, DateTime? EndDate)
        {
            List<Commons.Reports.FrozenList> obj = new List<Commons.Reports.FrozenList>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Report_FrozenList_Result> result = db.spg_Report_FrozenList(IdCustomer, IdAccount, StartDate, EndDate).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Reports.FrozenList()
                    {
                        Id_Cabecera_Importacion = x.Id_Cabecera_Importacion,
                        Poliza_Importacion = x.Poliza_Importacion,
                        Fecha_Autorizacion = x.Fecha_Autorizacion,
                        Fecha_Vencimiento = x.Fecha_Vencimiento,
                        Tipo_Cambio = x.Tipo_Cambio,
                        Id_Aduana = x.Id_Aduana,
                        Fecha_Sistema = x.Fecha_Sistema,
                        Seguro = x.Seguro,
                        Flete = x.Flete,
                        Numero_Factura = x.Numero_Factura,
                        Numero_Resolucion = x.Numero_Resolucion,
                        Des_Garantia = x.Des_Garantia,
                        Des_Aduana = x.Des_Aduana,
                        Des_Pais = x.Des_Pais,
                        Id_Detalle_Importacion = x.Id_Detalle_Importacion,
                        Linea_Importacion = x.Linea_Importacion,
                        Cantidad = x.Cantidad,
                        Costo_Cif_Quetzales = x.Costo_Cif_Quetzales,
                        Costo_Fob_Quetzales = x.Costo_Fob_Quetzales,
                        Derechos_Suspenso = x.Derechos_Suspenso,
                        Iva_Suspenso = x.Iva_Suspenso,
                        Id_Cliente = x.Id_Cliente,
                        Nombre_Cliente = x.Nombre_Cliente,
                        Nit_Cliente = x.Nit_Cliente,
                        Direccion_Cliente = x.Direccion_Cliente,
                        Telefono_Cliente = x.Telefono_Cliente,
                        Codigo_Cliente = x.Codigo_Cliente,
                        Codigo_Importador_Exportador = x.Codigo_Importador_Exportador,
                        Resolucion_Calificacion = x.Resolucion_Calificacion,
                        Fecha_Resolucion = x.Fecha_Resolucion,
                        C_Vencimiento = x.C_Vencimiento,
                        Nombre_Proveedor = x.Nombre_Proveedor,
                        Nit_Proveedor = x.Nit_Proveedor,
                        Direccion_Proveedor = x.Direccion_Proveedor,
                        Telefono_Proveedor = x.Telefono_Proveedor,
                        Des_Materia_Prima = x.Des_Materia_Prima,
                        Codigo_Materia_Prima = x.Codigo_Materia_Prima,
                        Partida_Materia = x.Partida_Materia,
                        Des_Unidad_Medida = x.Des_Unidad_Medida,
                        Des_Resolucion = x.Des_Resolucion,
                        IsFrozen = x.IsFrozen,
                        FrozenQuantity = x.FrozenQuantity,
                        CIF_Frozen = x.Cif_Frozen,
                        CIFD_Frozen = x.CifD_Frozen,
                        FOB_Frozen = x.Fob_Frozen,
                        FOBD_Frozen = x.FobD_Frozen,
                        IVA_Frozen = x.Iva_Frozen,
                        DAI_Frozen = x.DAI_Frozen,
                    });
                });
            }

            return obj;
        }
    }
}
