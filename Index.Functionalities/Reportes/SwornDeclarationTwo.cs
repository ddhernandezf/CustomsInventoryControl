using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Index.Functionalities.General;
using Newtonsoft.Json.Linq;
using RestSharp;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Index.Functionalities.Reportes
{
    public class SwornDeclarationTwo
    {
        private String ReportPath { get; set; }
        private String FilePath { get; set; }
        private String UserName { get; set; }
        private String CustomerName { get; set; }
        private String CustomerNameShow { get; set; }
        private String Url { get; set; }

        public SwornDeclarationTwo(String reportpath, String filepath, String username, String customername, String url)
        {
            this.ReportPath = reportpath;
            this.FilePath = filepath;
            this.UserName = username;
            this.CustomerName = customername;
            this.CustomerNameShow = customername;
            this.Url = url;
        }

        public String Generate(Int32? IdCustomer, Int32? IdAccount, DateTime? StartDate, DateTime? EndDate, String CustomerAddress,
                                String CustomerPhone, String CustomerCode, String CustomerNit, String ResolutionRate, DateTime? ResolutionDate,
                                DateTime? ExpirationDate, Boolean? GetTransmited, String FileHeaderList, String FileDetailList, Boolean UseFreeze)
        {
            UserName = UserName.Replace(" ", "").Replace(".", "");
            CustomerName = CustomerName.Replace(" ", "").Replace(".", "");

            ReportDocument rpt = new ReportDocument();
            rpt.Load(this.ReportPath);
            rpt.FileName = this.ReportPath;
            CustomerName = CustomerName.Replace(@"\", "")
                                    .Replace(@"/", "")
                                    .Replace(@":", "")
                                    .Replace(@"*", "")
                                    .Replace(@"?", "")
                                    .Replace("\"", "")
                                    .Replace(@"<", "")
                                    .Replace(@">", "")
                                    .Replace(@"&", "")
                                    .Replace(@"=", "");
            this.FilePath = this.FilePath + @"\" + UserName + @"\" + CustomerName;
            this.Url = this.Url + @"/" + UserName + @"/" + CustomerName;
            if (!Directory.Exists(this.FilePath))
            {
                Directory.CreateDirectory(this.FilePath);
            }
            foreach (FileInfo file in new DirectoryInfo(this.FilePath).GetFiles())
            {
                file.Delete();
            }

            String FileNameNoPath = DateTime.Now.ToString("ddMMyyhhmmss");
            String FileName = this.FilePath + @"\" + FileNameNoPath;
            List<Commons.Reports.SwornDeclarationOne> data = new List<Commons.Reports.SwornDeclarationOne>();
            DateTime start = (DateTime)StartDate;
            DateTime end = (DateTime)EndDate;
            Api.Client apiClient = new Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Reporte/DeclaracionJuradaGerencial", "IdCustomer=" + IdCustomer
                                                                    + "&IdAccount=" + IdAccount
                                                                    + "&StartDate=" + start.ToString("yyy-MM-dd")
                                                                    + "&EndDate=" + end.ToString("yyy-MM-dd")
                                                                    + "&GetTransmited=" + GetTransmited
                                                                    + "&FileHeaderList=" + FileHeaderList
                                                                    + "&FileDetailList=" + FileDetailList
                                                                    + "&UseFreeze=" + UseFreeze)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<Commons.Reports.SwornDeclarationOne>>();
            }
            DataSet ds = new DataSet();
            ds.Tables.Add(Data.ListToDataTable<Commons.Reports.SwornDeclarationOne>(data));
            ds.Tables[0].TableName = "ado";

            rpt.SetDataSource(ds);
            rpt.ParameterFields["Fecha_Inicial"].CurrentValues.Add(Data.CrParameterConvert(EndDate));
            rpt.ParameterFields["Fecha_Final"].CurrentValues.Add(Data.CrParameterConvert(EndDate));
            rpt.ParameterFields["Usuario"].CurrentValues.Add(Data.CrParameterConvert(CustomerName));
            rpt.ParameterFields["Nombre_Cliente"].CurrentValues.Add(Data.CrParameterConvert(CustomerNameShow));
            rpt.ParameterFields["Direccion_Cliente"].CurrentValues.Add(Data.CrParameterConvert(CustomerAddress));
            rpt.ParameterFields["Telefono_Cliente"].CurrentValues.Add(Data.CrParameterConvert(CustomerPhone));
            rpt.ParameterFields["Codigo_Importador_Exportador"].CurrentValues.Add(Data.CrParameterConvert(CustomerCode));
            rpt.ParameterFields["Nit_Cliente"].CurrentValues.Add(Data.CrParameterConvert(CustomerNit));
            rpt.ParameterFields["Resolucion_Calificacion"].CurrentValues.Add(Data.CrParameterConvert(ResolutionRate));
            rpt.ParameterFields["Fecha_Resolucion"].CurrentValues.Add(Data.CrParameterConvert(ResolutionDate));
            rpt.ParameterFields["Fecha_Vencimiento"].CurrentValues.Add(Data.CrParameterConvert(ExpirationDate));
            rpt.ParameterFields["@IsFrozen"].CurrentValues.Add(Data.CrParameterConvert(UseFreeze));

            rpt.ExportToDisk(ExportFormatType.PortableDocFormat, FileName + ".pdf");
            //rpt.ExportToDisk(ExportFormatType.Excel, FileName + ".xls");

            ExportOptions exOpt = new ExportOptions();
            ExcelFormatOptions xlsOpt = new ExcelFormatOptions();
            DiskFileDestinationOptions diskOpt = new DiskFileDestinationOptions();

            exOpt = rpt.ExportOptions;
            xlsOpt.ExcelUseConstantColumnWidth = false;
            xlsOpt.ExcelTabHasColumnHeadings = true;
            exOpt.ExportFormatType = ExportFormatType.Excel;
            exOpt.FormatOptions = xlsOpt;
            exOpt.ExportDestinationType = ExportDestinationType.DiskFile;
            diskOpt.DiskFileName = FileName + ".xls";
            exOpt.DestinationOptions = diskOpt;
            rpt.ExportOptions.FormatOptions = xlsOpt;
            rpt.Export();

            rpt.Close();
            rpt.Dispose();

            return this.Url + @"/" + FileNameNoPath;
        }

    }
}
