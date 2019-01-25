using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.IO;
using RestSharp;
using System.Net;
using System.Data;
using Index.Functionalities.General;

namespace Index.Functionalities.Reportes
{
    public class ExportList
    {
        private String ReportPath { get; set; }
        private String FilePath { get; set; }
        private String UserName { get; set; }
        private String CustomerName { get; set; }
        private String CustomerNameShow { get; set; }
        private String Url { get; set; }

        public ExportList(String reportpath, String filepath, String username, String customername, String url)
        {
            this.ReportPath = reportpath;
            this.FilePath = filepath;
            this.UserName = username;
            this.CustomerName = customername;
            this.CustomerNameShow = customername;
            this.Url = url;
        }

        public String Generate(Int32? IdCustomer, Int32? IdAccount, DateTime? StartDate, DateTime? EndDate, Boolean? GetTransmited)
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
            List<Commons.Reports.ExportList> data = new List<Commons.Reports.ExportList>();
            DateTime start = (DateTime)StartDate;
            DateTime end = (DateTime)EndDate;
            Api.Client apiClient = new Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Reporte/ListaExportacion", "IdCustomer=" + IdCustomer
                                                                    + "&IdAccount=" + IdAccount
                                                                    + "&StartDate=" + start.ToString("yyy-MM-dd")
                                                                    + "&EndDate=" + end.ToString("yyy-MM-dd")
                                                                    + "&GetTransmited=" + GetTransmited)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<Commons.Reports.ExportList>>();
            }
            DataSet ds = new DataSet();
            ds.Tables.Add(Data.ListToDataTable<Commons.Reports.ExportList>(data));
            ds.Tables[0].TableName = "ado";

            rpt.SetDataSource(ds);
            rpt.ParameterFields["Fecha_Inicial"].CurrentValues.Add(Data.CrParameterConvert(StartDate));
            rpt.ParameterFields["Fecha_Final"].CurrentValues.Add(Data.CrParameterConvert(EndDate));
            rpt.ParameterFields["Usuario"].CurrentValues.Add(Data.CrParameterConvert(UserName));
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
