using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RestSharp;
using System.Net;

namespace Index.Functionalities.Api
{
    public class Client
    {
        private static String gStrUrlWs = null;

        public Client(String URL)
        {
            gStrUrlWs = URL;
        }

        public IRestResponse getJArray(string pStrWebService, string pStrContedido)
        {
            ServicePointManager.ServerCertificateValidationCallback += (sender, certificate, chain, errors) => true;
            RestClient cliente = new RestClient(gStrUrlWs);
            RestRequest request = new RestRequest(pStrWebService + "?" + pStrContedido, Method.GET);
            request.Timeout = 1500000;
            IRestResponse response = cliente.Execute(request);
            return response;
        }

        public IRestResponse postObject(string pstrWebService, Object pstrContenido)
        {
            ServicePointManager.ServerCertificateValidationCallback += (sender, certificate, chain, errors) => true;
            RestClient cliente = new RestClient(gStrUrlWs);
            RestRequest request = new RestRequest(pstrWebService, Method.POST);
            request.Timeout = 1500000;
            request.AddJsonBody(pstrContenido);
            IRestResponse response = cliente.Execute(request);

            return response;
        }

        public IRestResponse putObject(string pstrWebService, Object pstrContenido)
        {
            ServicePointManager.ServerCertificateValidationCallback += (sender, certificate, chain, errors) => true;
            RestClient cliente = new RestClient(gStrUrlWs);
            RestRequest request = new RestRequest(pstrWebService, Method.PUT);
            request.Timeout = 1500000;
            request.AddJsonBody(pstrContenido);
            IRestResponse response = cliente.Execute(request);

            return response;
        }

        public IRestResponse deleteObject(string pStrWebService, Object pstrContenido)
        {
            ServicePointManager.ServerCertificateValidationCallback += (sender, certificate, chain, errors) => true;
            RestClient cliente = new RestClient(gStrUrlWs);
            RestRequest request = new RestRequest(pStrWebService, Method.DELETE);
            request.Timeout = 1500000;
            request.AddJsonBody(pstrContenido);
            IRestResponse response = cliente.Execute(request);

            return response;
        }

        public IRestResponse postObjectReturn(string pStrWebService, string pStrContedido, Object pObjContenido)
        {
            ServicePointManager.ServerCertificateValidationCallback += (sender, certificate, chain, errors) => true;
            RestClient cliente = new RestClient(gStrUrlWs);
            RestRequest request = new RestRequest(pStrWebService + "?" + pStrContedido, Method.POST);
            request.Timeout = 1500000;
            request.AddJsonBody(pObjContenido);
            IRestResponse response = cliente.Execute(request);
            return response;
        }
    }
}
