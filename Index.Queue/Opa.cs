using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Index.Dal;
using Index.Queue.OpaService;
using Index.Commons.Transmition;
using System.Threading;
using System.IO;
using System.Configuration;

namespace Index.Queue
{
    public static class Opa
    {
        public static Boolean IsProccessExists()
        {
            using (IndexEntities db = new IndexEntities())
            {
                Boolean result = (Boolean)db.spg_Execute().FirstOrDefault();
                return result;
            }
        }

        public static spg_Queue_Result GetDocumentToProccess()
        {
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_Queue_Result> result = db.spg_Queue().ToList();

                return result.FirstOrDefault();
            }
        }

        public static Boolean SetDocumentToProccess(spg_Queue_Result model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_BatchToProccess(model.IdOpaHeader);
                return true;
            }
        }

        public static List<spg_QueueItems_Result> GetDocumentItems(Int32 IdOpaHeader)
        {
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_QueueItems_Result> result = db.spg_QueueItems(IdOpaHeader).ToList();

                return result;
            }
        }

        public static List<spg_States_Result> GetStates()
        {
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_States_Result> result = db.spg_States().ToList();

                return result;
            }
        }

        public static Boolean SetItemStateChange(spg_QueueItems_Result model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_ItemChangeState(model.IdOpaDetail, model.IdState);
                return true;
            }
        }

        public static Boolean SetDocumentStateChange(spg_Queue_Result model, Int32 IdState)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_DocumentChangeState(model.IdOpaHeader, IdState);
                return true;
            }
        }

        public static Boolean ItemStartEnd(spg_QueueItems_Result model, Boolean IsStart)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_ItemStartEndProccessTime(model.IdOpaDetail, IsStart);
                return true;
            }
        }

        public static Boolean DocumentStartEnd(spg_Queue_Result model, Boolean IsStart)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_DocumentStartEndProccessTime(model.IdOpaHeader, IsStart);
                return true;
            }
        }

        public static Boolean SetResponse(OpaResponse model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spo_OpaResponse(model.IdOpaDetail, model.TransactionNumber, model.ErrorType, model.ErrorMessage, model.Cif,
                    model.CustomDuties, model.Iva, model.NationalizationMulct, model.NationalizationMulctAmmount, model.ExtemporaneusMulct,
                    model.ExtemporaneusMulctAmmount, model.ResponseDate);
                return true;
            }
        }

        public static Boolean SendNotification(spg_Queue_Result document)
        {
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_TransmitionResult_Result> detail = db.spg_TransmitionResult(document.IdOpaHeader).ToList();
                String email = db.spg_TransmitionGetUserEmail(document.UserName).First().Email;
                spg_UserProccess_Result header = db.spg_UserProccess(document.IdOpaHeader).FirstOrDefault();

                Commons.Parameters param = Dal.Parameters.Get();
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
                DateTime startdate = (document.StartDate == null) ? DateTime.Now : (DateTime)document.StartDate;
                DateTime enddate = (document.EndDate == null) ? DateTime.Now : (DateTime)document.EndDate;

                String HtmlMessage = File.ReadAllText(param.OpaEmailBody);
                HtmlMessage = HtmlMessage.Replace("@Priority", document.PriorityName)
                    .Replace("@StartDate", startdate.ToString("dd/MM/yyyy"))
                    .Replace("@EndDate", enddate.ToString("dd/MM/yyyy"))
                    .Replace("@Customer", header.CustomerName).Replace("@Account", header.AccountName)
                    .Replace("@data", detailMessage);


                Functionalities.General.Email mail = new Functionalities.General.Email(param.MailingUser, param.MailingPassword, param.MailingServer, param.MailingPort, param.MailingUseSsl, param.MailingDisplayName, param.MailingIsHtml);
                mail.BuildMessage(email, param.MailingCC, param.MailingCCO, "Notificación de transmisión OPA", HtmlMessage);
                mail.Send();

                return true;
            }
        }

        public static void Proccess(OpaExternal svc, ref Boolean BlockProccess, Int32 DelayValue, spg_Queue_Result document)
        {
            List<spg_QueueItems_Result> items = Opa.GetDocumentItems(document.IdOpaHeader);
            List<spg_States_Result> states = Opa.GetStates();

            Int32 IdStateTransmited = states.Where(y => y.Name == "Transmitido").FirstOrDefault().Id;
            Int32 IdStateQueue = states.Where(y => y.Name == "Cola").FirstOrDefault().Id;
            Int32 IdStateProccess = states.Where(y => y.Name == "Procesando").FirstOrDefault().Id;
            Int32 IdStateError = states.Where(y => y.Name == "Error Transmisión").FirstOrDefault().Id;

            Int32 TotalItems = items.Count;
            Int32 TotalTransmited = items.Where(x => x.IdState == IdStateTransmited).ToList().Count;
            Int32 TotalQueue = items.Where(x => x.IdState == IdStateQueue).ToList().Count;
            Int32 TotalError = items.Where(x => x.IdState == IdStateError).ToList().Count;
            Int32 ItemCounter = 0;

            BlockProccess = true;
            Console.WriteLine(DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss") + " " + items.Count + " registros a procesar.");

            if (TotalItems == TotalTransmited)
            {
                Opa.SetDocumentStateChange(document, IdStateTransmited);
                BlockProccess = false;
            }
            else if (TotalItems == TotalError)
            {
                Opa.SetDocumentStateChange(document, IdStateError);
                BlockProccess = false;
            }
            else
            {
                Opa.DocumentStartEnd(document, true);
                items.ForEach(x =>
                {
                    ItemCounter = ItemCounter + 1;
                    if (x.IdState == IdStateProccess)
                    {
                        clsRespuestaDescargo result = new clsRespuestaDescargo();
                        OpaResponse response = new OpaResponse();
                        Opa.ItemStartEnd(x, true);

                        try
                        {
                            result = svc.Validate(x.Nit, x.IdDocumentStock, x.TransactionLineStock, (double)x.QuantitySubstract, x.IdDocumentSubstract, x.TransactionLineSubstract);

                            if (result.sCodRespuesta == "1")
                            {
                                result = svc.Transmit(x.Nit, x.IdDocumentStock, x.TransactionLineStock, (double)x.QuantitySubstract, x.IdDocumentSubstract, x.TransactionLineSubstract);
                            }

                            response = new OpaResponse()
                            {
                                Cif = (Decimal)result.dCifQ,
                                CustomDuties = (Decimal)result.dDaiQ,
                                ErrorMessage = result.sMensajeError,
                                ErrorType = result.sCodRespuesta,
                                ExtemporaneusMulct = result.sRazonMultaExt,
                                ExtemporaneusMulctAmmount = (Decimal)result.dMontoMultaExt,
                                IdOpaDetail = x.IdOpaDetail,
                                Iva = (Decimal)result.dIvaQ,
                                NationalizationMulct = result.sRazonMultaNac,
                                NationalizationMulctAmmount = (Decimal)result.dMontoMultaNac,
                                TransactionNumber = Convert.ToInt32(result.lOperacion),
                                ResponseDate = DateTime.Now
                            };

                            String logMsg = null;
                            if (Convert.ToBoolean(ConfigurationManager.AppSettings["AlwaysTrue"].ToString()))
                            {
                                x.IdState = IdStateTransmited;
                                logMsg = " transmitido";

                                response.Cif = x.CifSubstract;
                                response.CustomDuties = x.CustomDutiesSubstract;
                                response.ErrorMessage = "Transmisión exitosa.";
                                response.ErrorType = "1";
                                response.ExtemporaneusMulct = result.sRazonMultaExt;
                                response.ExtemporaneusMulctAmmount = (Decimal)result.dMontoMultaExt;
                                response.IdOpaDetail = x.IdOpaDetail;
                                response.Iva = x.IvaSubstract;
                                response.NationalizationMulct = result.sRazonMultaNac;
                                response.NationalizationMulctAmmount = (Decimal)result.dMontoMultaNac;
                                response.TransactionNumber = x.TransactionLineSubstract;
                                response.ResponseDate = DateTime.Now;
                            }
                            else
                            {
                                x.IdState = (response.ErrorType == "1") ? IdStateTransmited : IdStateError;
                                logMsg = (response.ErrorType == "1") ? " transmitido" : " con error";
                            }
                            Console.WriteLine(DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss") + " Registro de detalle número " + x.IdOpaDetail + logMsg);
                            Opa.SetItemStateChange(x);
                            Opa.SetResponse(response);
                            Opa.ItemStartEnd(x, false);
                        }
                        catch (Exception ex)
                        {
                            String errorMsg = (ex.InnerException == null) ? ex.Message : ex.InnerException.Message;
                            response = new OpaResponse()
                            {
                                Cif = x.CifSubstract,
                                CustomDuties = x.CustomDutiesSubstract,
                                ErrorMessage = errorMsg,
                                ErrorType = "0",
                                ExtemporaneusMulct = result.sRazonMultaExt,
                                ExtemporaneusMulctAmmount = (Decimal)result.dMontoMultaExt,
                                IdOpaDetail = x.IdOpaDetail,
                                Iva = x.IvaSubstract,
                                NationalizationMulct = result.sRazonMultaNac,
                                NationalizationMulctAmmount = (Decimal)result.dMontoMultaNac,
                                TransactionNumber = 0,
                                ResponseDate = DateTime.Now
                            };

                            if (Convert.ToBoolean(ConfigurationManager.AppSettings["AlwaysTrue"].ToString()))
                            {
                                x.IdState = IdStateTransmited;
                                response.Cif = x.CifSubstract;
                                response.CustomDuties = x.CustomDutiesSubstract;
                                response.ErrorMessage = "Transmisión exitosa.";
                                response.ErrorType = "1";
                                response.ExtemporaneusMulct = result.sRazonMultaExt;
                                response.ExtemporaneusMulctAmmount = (Decimal)result.dMontoMultaExt;
                                response.IdOpaDetail = x.IdOpaDetail;
                                response.Iva = x.IvaSubstract;
                                response.NationalizationMulct = result.sRazonMultaNac;
                                response.NationalizationMulctAmmount = (Decimal)result.dMontoMultaNac;
                                response.TransactionNumber = 999;
                                response.ResponseDate = DateTime.Now;
                                Console.WriteLine(DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss") + " Registro de detalle número " + x.IdOpaDetail + " transmitido.");
                            }
                            else
                            {
                                x.IdState = IdStateError;
                                Console.WriteLine(DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss") + " Registro de detalle número " + x.IdOpaDetail + " con error.");
                            }
                            Opa.SetItemStateChange(x);
                            Opa.SetResponse(response);
                            Opa.ItemStartEnd(x, false);
                        }
                        
                        Thread.Sleep(DelayValue);
                    }
                });

                if (ItemCounter == TotalItems)
                {
                    items = Opa.GetDocumentItems(document.IdOpaHeader);
                    TotalItems = items.Count;
                    TotalTransmited = items.Where(x => x.IdState == IdStateTransmited).ToList().Count;
                    TotalQueue = items.Where(x => x.IdState == IdStateQueue).ToList().Count;
                    TotalError = items.Where(x => x.IdState == IdStateError).ToList().Count;

                    if (TotalItems == TotalTransmited)
                    {
                        Opa.SetDocumentStateChange(document, IdStateTransmited);
                    }
                    else if (TotalItems == TotalError)
                    {
                        Opa.SetDocumentStateChange(document, IdStateError);
                    }
                    else
                    {
                        Opa.SetDocumentStateChange(document, IdStateError);
                    }
                }

                try
                {
                    Opa.DocumentStartEnd(document, false);
                    Opa.SendNotification(document);
                    BlockProccess = false;
                }
                catch (Exception)
                {
                    BlockProccess = false;
                }
            }
        }
    }
}
