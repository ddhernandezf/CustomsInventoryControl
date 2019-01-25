﻿using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using RestSharp;
using System.Net;
using System.Data;
using Index.Functionalities.General;

namespace Index.Functionalities.Reportes
{
    public class ItemReport
    {
        private String ReportPath { get; set; }
        private String FilePath { get; set; }
        private String UserName { get; set; }
        private String CustomerName { get; set; }
        private String CustomerNameShow { get; set; }
        private String Url { get; set; }

        public ItemReport(String reportpath, String filepath, String username, String customername, String url)
        {
            this.ReportPath = reportpath;
            this.FilePath = filepath;
            this.UserName = username;
            this.CustomerName = customername;
            this.CustomerNameShow = customername;
            this.Url = url;
        }

        public String Generate(Int32? IdCustomer, Int32? IdAccount, Boolean? Product)
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
            List<Commons.Reports.ItemReport> data = new List<Commons.Reports.ItemReport>();
            Api.Client apiClient = new Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Reporte/ListaItem", "IdCustomer=" + IdCustomer
                                                                    + "&IdAccount=" + IdAccount
                                                                    + "&Product=" + Product)).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<Commons.Reports.ItemReport>>();
            }
            DataSet ds = new DataSet();
            ds.Tables.Add(Data.ListToDataTable<Commons.Reports.ItemReport>(data));
            ds.Tables[0].TableName = "Comando";

            rpt.SetDataSource(ds);
            rpt.ParameterFields["Fecha_Inicial"].CurrentValues.Add(Data.CrParameterConvert(DateTime.Now));
            rpt.ParameterFields["Fecha_Final"].CurrentValues.Add(Data.CrParameterConvert(DateTime.Now));
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
