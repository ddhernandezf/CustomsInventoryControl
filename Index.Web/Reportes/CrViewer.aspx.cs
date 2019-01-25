using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using CrystalDecisions.Web;
using System.Configuration;
using System.Data;
using System.Data.Linq;
using RestSharp;
using System.Threading.Tasks;
using System.Net;
using Newtonsoft.Json.Linq;
using Index.Commons.Reports;
using System.ComponentModel;
using Index.Functionalities.General;

namespace Index.Web.Reportes
{
    public partial class CrViewer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ReportDocument rpt = new ReportDocument();
            String rptPath = Server.MapPath("~\\CRfiles");

            rpt.Load(rptPath + @"\DeclaracionJurada1.rpt");
            //rpt.FileName = rptPath + @"\DeclaracionJurada1.rpt";

            if (!IsPostBack)
            {
                DataSet data = getDataSwornDeclaration();
                Session["data"] = data;
            }

            rpt.SetDataSource((DataSet)Session["data"]);
            rpt.ParameterFields["@CustName"].CurrentValues.Add(Data.CrParameterConvert("NESTLE"));
            rpt.ParameterFields["@CustAddress"].CurrentValues.Add(Data.CrParameterConvert("DIRECCION"));
            rpt.ParameterFields["@CustPhone"].CurrentValues.Add(Data.CrParameterConvert("TELEFONO"));
            rpt.ParameterFields["@CustCode"].CurrentValues.Add(Data.CrParameterConvert("399"));
            rpt.ParameterFields["@CustNit"].CurrentValues.Add(Data.CrParameterConvert("1-9"));
            rpt.ParameterFields["@CustLegalRep"].CurrentValues.Add(Data.CrParameterConvert("Representantelegal"));
            rpt.ParameterFields["@ResolutionRate"].CurrentValues.Add(Data.CrParameterConvert("2020"));
            rpt.ParameterFields["@ResolutionDate"].CurrentValues.Add(Data.CrParameterConvert(DateTime.Now));
            rpt.ParameterFields["@ExpirationDate"].CurrentValues.Add(Data.CrParameterConvert(DateTime.Now));
            rpt.ParameterFields["@EndDate"].CurrentValues.Add(Data.CrParameterConvert(DateTime.Now));
            rpt.ParameterFields["@IsFrozen"].CurrentValues.Add(Data.CrParameterConvert(false));

            CrystalReportViewer1.ReportSource = rpt;
            //CrystalReportViewer1.ParameterFieldInfo["@CustName"].CurrentValues.Add(pCustomerName);
            //CrystalReportViewer1.ParameterFieldInfo["@CustAddress"].CurrentValues.Add(pCustomerAddress);
            //CrystalReportViewer1.ParameterFieldInfo["@CustPhone"].CurrentValues.Add(pCustomerPhone);
            //CrystalReportViewer1.ParameterFieldInfo["@CustCode"].CurrentValues.Add(pCustomerCode);
            //CrystalReportViewer1.ParameterFieldInfo["@CustNit"].CurrentValues.Add(pCustomerNit);
            //CrystalReportViewer1.ParameterFieldInfo["@ResolutionRate"].CurrentValues.Add(pResolutionRate);
            //CrystalReportViewer1.ParameterFieldInfo["@ResolutionDate"].CurrentValues.Add(pResolutionDate);
            //CrystalReportViewer1.ParameterFieldInfo["@ExpirationDate"].CurrentValues.Add(pExpirationDate);
            //CrystalReportViewer1.ParameterFieldInfo["@EndDate"].CurrentValues.Add(pEndDate);

            //CrystalReportViewer1.ParameterFieldInfo["@CustName"].CurrentValues.Add(Data.CrParameterConvert("NESTLE"));
            //CrystalReportViewer1.ParameterFieldInfo["@CustAddress"].CurrentValues.Add(Data.CrParameterConvert("DIRECCION"));
            //CrystalReportViewer1.ParameterFieldInfo["@CustPhone"].CurrentValues.Add(Data.CrParameterConvert("TELEFONO"));
            //CrystalReportViewer1.ParameterFieldInfo["@CustCode"].CurrentValues.Add(Data.CrParameterConvert("399"));
            //CrystalReportViewer1.ParameterFieldInfo["@CustNit"].CurrentValues.Add(Data.CrParameterConvert("1-9"));
            //CrystalReportViewer1.ParameterFieldInfo["@CustLegalRep"].CurrentValues.Add(Data.CrParameterConvert("Representantelegal"));
            //CrystalReportViewer1.ParameterFieldInfo["@ResolutionRate"].CurrentValues.Add(Data.CrParameterConvert("2020"));
            //CrystalReportViewer1.ParameterFieldInfo["@ResolutionDate"].CurrentValues.Add(Data.CrParameterConvert(DateTime.Now));
            //CrystalReportViewer1.ParameterFieldInfo["@ExpirationDate"].CurrentValues.Add(Data.CrParameterConvert(DateTime.Now));
            //CrystalReportViewer1.ParameterFieldInfo["@EndDate"].CurrentValues.Add(Data.CrParameterConvert(DateTime.Now));
            //CrystalReportViewer1.ParameterFieldInfo["@IsFrozen"].CurrentValues.Add(Data.CrParameterConvert(false));

            CrystalReportViewer1.RefreshReport();
            CrystalReportViewer1.ReuseParameterValuesOnRefresh = true;
            CrystalReportViewer1.Zoom(80);
            CrystalReportViewer1.DataBind();
        }

        private DataSet getDataSwornDeclaration()
        {
            List<SwornDeclarationOne> data = new List<SwornDeclarationOne>();
            Functionalities.Api.Client apiClient = new Functionalities.Api.Client(System.Configuration.ConfigurationManager.AppSettings["URLAPI"]);

            IRestResponse WSR = Task.Run(() => apiClient.getJArray("Reporte/DeclaracionJuradaUno", "IdCustomer=21"
                                                                    + "&IdAccount=1"
                                                                    + "&StartDate=2017-06-01"
                                                                    + "&EndDate=2017-06-21"
                                                                    + "&GetTransmited="
                                                                    + "&FileHeaderList="
                                                                    + "&FileDetailList="
                                                                    + "&UseFreeze=false")).Result;
            if (WSR.StatusCode == HttpStatusCode.OK)
            {
                data = JArray.Parse(WSR.Content).ToObject<List<SwornDeclarationOne>>();
            }
            DataSet ds = new DataSet();
            ds.Tables.Add(ConvertToDataTable<SwornDeclarationOne>(data));
            ds.Tables[0].TableName = "ado";

            return ds;
        }

        public DataTable ConvertToDataTable<T>(IList<T> data)
        {
            PropertyDescriptorCollection properties =
               TypeDescriptor.GetProperties(typeof(T));
            DataTable table = new DataTable();
            foreach (PropertyDescriptor prop in properties)
                table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
            foreach (T item in data)
            {
                DataRow row = table.NewRow();
                foreach (PropertyDescriptor prop in properties)
                    row[prop.Name] = prop.GetValue(item) ?? DBNull.Value;
                table.Rows.Add(row);
            }
            return table;

        }
    }
}