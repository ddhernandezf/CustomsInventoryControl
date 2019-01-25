using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Index.Functionalities.General;
using System.Collections.Generic;
using System.IO;

namespace Index.Testing.Functionalities
{
    [TestClass]
    public class EmailTester
    {

        [TestMethod]
        public void MailingPorComas()
        {
            Email mail = new Email("opatestermail@gmail.com", "prueba123$$", "smtp.gmail.com", 587, true, "Index Aduana App", false);
            mail.BuildMessage("gabriel.rangel@rymtech.com.gt", null, "ddhernandezf@gmail.com, sk8ertuxgt@gmail.com", "correo de prueba", "Correo con copia oculta separado por comas");
            Assert.IsTrue(mail.Send());
        }

        [TestMethod]
        public void SingleMailSender()
        {
            Email mail = new Email("opatestermail@gmail.com", "prueba123$$", "smtp.gmail.com", 587, true, "Index Aduana App", false);
            mail.BuildMessage("ddhernandezf@gmail.com", null, null, "correo de prueba", "prueba de envio a una sola dirección");
            Assert.IsTrue(mail.Send());
        }

        [TestMethod]
        public void MultipleMailSender()
        {
            List<String> emails = new List<String>();
            emails.Add("ddhernandezf@gmail.com");
            emails.Add("sk8ertuxgt@gmail.com");
            emails.Add("gabriel.rangel@rymtech.com.gt");

            Email mail = new Email("opatestermail@gmail.com", "prueba123$$", "smtp.gmail.com", 587, true, "Index Aduana App", false);
            mail.BuildMessage(emails, null, null, "correo de prueba", "prueba de envio a una sola dirección");
            Assert.IsTrue(mail.Send());
        }

        [TestMethod]
        public void MultipleCCMailSender()
        {
            List<String> emails = new List<String>();
            List<String> cc = new List<String>();

            emails.Add("ddhernandezf@gmail.com");
            cc.Add("sk8ertuxgt@gmail.com");
            cc.Add("gabriel.rangel@rymtech.com.gt");

            Email mail = new Email("opatestermail@gmail.com", "prueba123$$", "smtp.gmail.com", 587, true, "Index Aduana App", false);
            mail.BuildMessage(emails, cc, null, "correo de prueba", "prueba de envio a multiples direcciones utilizando el CC");
            Assert.IsTrue(mail.Send());
        }

        [TestMethod]
        public void MultipleCcoMailSender()
        {
            List<String> emails = new List<String>();
            List<String> cc = new List<String>();
            List<String> cco = new List<String>();

            emails.Add("ddhernandezf@gmail.com");
            cc.Add("sk8ertuxgt@gmail.com");
            cco.Add("gabriel.rangel@rymtech.com.gt");
            cco.Add("douglas.hernandez@rymtech.com.gt");

            Email mail = new Email("opatestermail@gmail.com", "prueba123$$", "smtp.gmail.com", 587, true, "Index Aduana App", false);
            mail.BuildMessage(emails, cc, null, "correo de prueba", "prueba de envio a multiples direcciones utilizando el CCo. Se agrega el nombre de la app");
            Assert.IsTrue(mail.Send());
        }

        [TestMethod]
        public void SendEmailHTML()
        {
            Commons.Parameters param = Dal.Parameters.Get();
            List<Dal.spg_TransmitionResult_Result> detail = new List<Dal.spg_TransmitionResult_Result>();
            detail.Add(new Dal.spg_TransmitionResult_Result() {
                IdState = 4,
                StateName = "Cola",
                Message = "[NIT invalido]",
                ExportInfo = "DUA (Exportación) 0001 Línea 1",
                ImportInfo = "DUA (Importación) 0001 Línea 1",
                Quantity = 10,
                CIF = 10,
                FOB = 10,
                DAI = 10,
                IVA = 10
            });
            String detailMessage = "";

            detail.ForEach(x => {
                detailMessage = detailMessage + "<tr>";

                detailMessage = detailMessage + "<td style='border: solid;font-size: 15px;border-width: 0.5px;border-spacing : 0;padding: 5px 10px;'>" + x.StateName + "</td>" +
                                                "<td style='border: solid;font-size: 15px;border-width: 0.5px;border-spacing : 0;padding: 5px 10px;color: red;font-size: 10px;border-color: black;'>" + x.Message + "</td>" +
                                                "<td style='border: solid;font-size: 15px;border-width: 0.5px;border-spacing : 0;padding: 5px 10px;'>" + x.ExportInfo + "</td>" +
                                                "<td style='border: solid;font-size: 15px;border-width: 0.5px;border-spacing : 0;padding: 5px 10px;'>" + x.ImportInfo + "</td>" +
                                                "<td style='border: solid;font-size: 15px;border-width: 0.5px;border-spacing : 0;padding: 5px 10px;text-align: center;'>" + x.Quantity + "</td>" +
                                                "<td style='border: solid;font-size: 15px;border-width: 0.5px;border-spacing : 0;padding: 5px 10px;text-align: center;'>Q " + x.CIF + "</td>" +
                                                "<td style='border: solid;font-size: 15px;border-width: 0.5px;border-spacing : 0;padding: 5px 10px;text-align: center;'>Q " + x.FOB + "</td>" +
                                                "<td style='border: solid;font-size: 15px;border-width: 0.5px;border-spacing : 0;padding: 5px 10px;text-align: center;'>Q " + x.DAI + "000000</td>" +
                                                "<td style='border: solid;font-size: 15px;border-width: 0.5px;border-spacing : 0;padding: 5px 10px;text-align: center;'>Q " + x.IVA + "</td>";

                detailMessage = detailMessage + "</tr>";
            });

            String result = File.ReadAllText(param.OpaEmailBody);
            //String result = File.ReadAllText(param.OpaEmailBody.Replace("\r", "").Replace("\n", "").Replace("\t", ""));


            result = result.Replace("@Priority", "Alta")
                .Replace("@StartDate", "01/01/2017").Replace("@EndDate", "20/01/2017")
                .Replace("@Customer", "Cliente de prueba").Replace("@Account", "Cuenta de prueba")
                .Replace("@data", detailMessage);

            List<String> emails = new List<String>();
            List<String> cc = new List<String>();

            emails.Add("ddhernandezf@gmail.com");
            cc.Add(param.MailingCC);
            cc.Add(param.MailingCCO);

            Email mail = new Email(param.MailingUser, param.MailingPassword, param.MailingServer, param.MailingPort, param.MailingUseSsl, param.MailingDisplayName, param.MailingIsHtml);
            mail.BuildMessage(emails, cc, null, "Notificación de proceso", result);
            Assert.IsTrue(mail.Send());
        }

        [TestMethod]
        public void RymTechSingleMail()
        {
            Email mail = new Email("index.controladuanas@rymtech.com.gt", "XwHT^]o~GzzG", "mail.rymtech.com.gt", 25, false, "Index Aduana App", false);
            mail.BuildMessage("ddhernandezf@gmail.com,gabriel.rangel@rymtech.com.gt", null, null, "correo de prueba", "prueba de envio a una sola dirección");
            Assert.IsTrue(mail.Send());
        }
    }
}
