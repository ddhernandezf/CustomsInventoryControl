using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Index.Queue.OpaService;

namespace Index.Queue
{
    public class OpaExternal
    {
        private String UserName { get; set; }
        private String Password { get; set; }
        private String ServiceUrl { get; set; }

        public OpaExternal(String username, String password, String serviceurl)
        {
            this.UserName = username;
            this.Password = password;
            this.ServiceUrl = serviceurl;
        }

        public clsRespuestaDescargo Validate(String Nit, String ImportDocumentNumber, Int32 LineImportDocument, Double Quantity, String ExportDocumentNumber,
                            Int32 LineExportDocument)
        {
            //WSOPASoapClient opaservice = new WSOPASoapClient("WSOPASoap");
            WSOPASoapClient opaservice = new WSOPASoapClient();

            ImportDocumentNumber = ImportDocumentNumber.Replace("-", "");
            ExportDocumentNumber = ExportDocumentNumber.Replace("-", "");
            Nit = Nit.Replace("-", "");

            opaservice.Endpoint.Address = new System.ServiceModel.EndpointAddress(new Uri(this.ServiceUrl));
            clsRespuestaDescargo result = opaservice.wmValidarDescargo(this.UserName, this.Password, Nit, ImportDocumentNumber, LineImportDocument, Quantity,
                                        ExportDocumentNumber, LineExportDocument);

            return result;
        }

        public clsRespuestaDescargo Transmit(String Nit, String ImportDocumentNumber, Int32 LineImportDocument, Double Quantity, String ExportDocumentNumber,
                            Int32 LineExportDocument)
        {
            ImportDocumentNumber = ImportDocumentNumber.Replace("-", "");
            ExportDocumentNumber = ExportDocumentNumber.Replace("-", "");
            Nit = Nit.Replace("-", "");

            WSOPASoapClient opaservice = new WSOPASoapClient();
            opaservice.Endpoint.Address = new System.ServiceModel.EndpointAddress(new Uri(this.ServiceUrl));
            clsRespuestaDescargo result = opaservice.wmEnviarDescargo(this.UserName, this.Password, Nit, ImportDocumentNumber, LineImportDocument, Quantity,
                                        ExportDocumentNumber, LineExportDocument);

            return result;
        }
    }
}
