using System;
using System.Collections.Generic;
using System.Linq;
using Index.Commons.Reports;

namespace Index.Dal.REPORTS
{
    public static class FormulaReport
    {
        public static List<Commons.Reports.FormulaReport> Get(Int32 IdCustomer, Int32 IdAccount, Int32? IdMainItem)
        {
            List<Commons.Reports.FormulaReport> obj = new List<Commons.Reports.FormulaReport>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Report_Formula_Result> result = db.spg_Report_Formula(IdCustomer, IdAccount, IdMainItem).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Reports.FormulaReport()
                    {
                        Id_Formula = x.Id_Formula,
                        Id_Producto = x.Id_Producto,
                        Id_Materia_Prima = x.Id_Materia_Prima,
                        Cantidad = x.Cantidad,
                        Cantidad_Merma = x.Cantidad_Merma,
                        Des_Producto = x.Des_Producto,
                        Codigo_Producto = x.Codigo_Producto,
                        Partida_Producto = x.Partida_Producto,
                        Des_Materia = x.Des_Materia,
                        Codigo_Materia = x.Codigo_Materia,
                        Partida_Materia = x.Partida_Materia,
                        Nombre_Cliente = x.Nombre_Cliente,
                        Nit_Cliente = x.Nit_Cliente,
                        Direccion = x.Direccion,
                        Telefono = x.Telefono,
                        Codigo_Cliente = x.Codigo_Cliente,
                        Des_Unidad_Producto = x.Des_Unidad_Producto,
                        Des_Unidad_Materia = x.Des_Unidad_Materia
                    });
                });
            }

            return obj;
        }
    }
}
