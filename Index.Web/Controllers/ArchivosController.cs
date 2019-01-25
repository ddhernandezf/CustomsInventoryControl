using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;

namespace Index.Web.Controllers
{
    public class ArchivosController : Controller
    {
        public FileResult Downloads(String UrlFile)
        {
            String filepath = Server.MapPath(UrlFile);
            String filename = Path.GetFileName(filepath);
            byte[] filebytes = System.IO.File.ReadAllBytes(filepath);

            return File(filebytes, System.Net.Mime.MediaTypeNames.Application.Octet, filename);
        }
    }
}