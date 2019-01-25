﻿using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Newtonsoft.Json.Linq;
using RestSharp;
using System;
using System.IO;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Index.Functionalities.General;
using System.Web.UI;

namespace Index.Functionalities.Reportes
{
    public class SwornDeclarationOne
    {
        private String ReportPath { get; set; }
        private String FilePath { get; set; }
        private String UserName { get; set; }
        private String CustomerName { get; set; }
        private String CustomerNameShow { get; set; }
        private String Url { get; set; }

        public SwornDeclarationOne(String reportpath, String filepath, String username, String customername, String url)
        {
            this.ReportPath = reportpath;
            this.FilePath = filepath;
            this.UserName = username;
            this.CustomerName = customername;
            this.CustomerNameShow = customername;
            this.Url = url;
        }

        public String Generate(Int32? IdCustomer, Int32? IdAccount, DateTime? StartDate, DateTime? EndDate, String CustomerAddress, 
                                String CustomerPhone, String CustomerCode, String CustomerNit, String CustomerLegalRepresentative, String ResolutionRate, DateTime? ResolutionDate,
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

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Reporte/DeclaracionJuradaUno", "IdCustomer=" + IdCustomer
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
            rpt.ParameterFields["@CustName"].CurrentValues.Add(Data.CrParameterConvert(CustomerNameShow));
            rpt.ParameterFields["@CustAddress"].CurrentValues.Add(Data.CrParameterConvert(CustomerAddress));
            rpt.ParameterFields["@CustPhone"].CurrentValues.Add(Data.CrParameterConvert(CustomerPhone));
            rpt.ParameterFields["@CustCode"].CurrentValues.Add(Data.CrParameterConvert(CustomerCode));
            rpt.ParameterFields["@CustNit"].CurrentValues.Add(Data.CrParameterConvert(CustomerNit));
            rpt.ParameterFields["@CustLegalRep"].CurrentValues.Add(Data.CrParameterConvert(CustomerLegalRepresentative));
            rpt.ParameterFields["@ResolutionRate"].CurrentValues.Add(Data.CrParameterConvert(ResolutionRate));
            rpt.ParameterFields["@ResolutionDate"].CurrentValues.Add(Data.CrParameterConvert(ResolutionDate));
            rpt.ParameterFields["@ExpirationDate"].CurrentValues.Add(Data.CrParameterConvert(ExpirationDate));
            rpt.ParameterFields["@EndDate"].CurrentValues.Add(Data.CrParameterConvert(EndDate));
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