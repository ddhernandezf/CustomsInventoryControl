using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Dal.TRANSMITION
{
    public static class Detail
    {
        public static List<Commons.Transmition.OpaDetail> GetData(Int32 IdCustomer ,Int32 IdAccount, Boolean UseRegisterDate, DateTime StartDate, DateTime EndDate)
        {
            List<Commons.Transmition.OpaDetail> obj = new List<Commons.Transmition.OpaDetail>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_TransmitionData_Result> result = db.spg_TransmitionData(IdCustomer, IdAccount, UseRegisterDate, StartDate, EndDate).ToList();
                result.ForEach(x => {
                    Index.Commons.FileItemDischargeValidateResponse valresult =  FileItemDischarge.IsValidate(x.IdFileItemDischarge);
                    obj.Add(new Commons.Transmition.OpaDetail()
                    {
                        IdFileItemDischarge = x.IdFileItemDischarge,
                        IdFileHeaderSubstract = x.IdFileHeaderSubstract,
                        IdFileDetailSubstract = x.IdFileDetailSubstract,
                        IdDocumentSubstract = x.IdDocumentSubstract,
                        TransactionLineSubstract = x.TransactionLineSubstract,
                        QuantitySubstract = x.QuantitySubstract,
                        CifSubstract = x.CifSubstract,
                        FobSubstract = x.FobSubstract,
                        CustomDutiesSubstract = x.CustomDutiesSubstract,
                        IvaSubstract = x.IvaSubstract,
                        IdFileHeaderStock = x.IdFileHeaderStock,
                        IdFileDetailStock = x.IdFileDetailStock,
                        IdDocumentStock = x.IdDocumentStock,
                        TransactionLineStock = x.TransactionLineStock,
                        DocumentNameStock = x.DocumentNameStock,
                        DocumentNameSubstract = x.DocumentNameSubstract,
                        AuthorizationDate = x.AuthorizationDate,
                        RegisterDate = x.RegisterDate,
                        Assigned = false,
                        IsValid = valresult.IsValid,
                        Message = valresult.ErrorMsg
                    });
                });
            }

            return obj;
        }

        public static List<Commons.Transmition.OpaDetail> GetDataByIds(String FileItemDischargeIds)
        {
            List<Commons.Transmition.OpaDetail> obj = new List<Commons.Transmition.OpaDetail>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_TransmitionDataByIds_Result> result = db.spg_TransmitionDataByIds(FileItemDischargeIds).ToList();
                result.ForEach(x => {
                    Index.Commons.FileItemDischargeValidateResponse valresult = FileItemDischarge.IsValidate(x.IdFileItemDischarge);
                    obj.Add(new Commons.Transmition.OpaDetail()
                    {
                        IdFileItemDischarge = x.IdFileItemDischarge,
                        IdFileHeaderSubstract = x.IdFileHeaderSubstract,
                        IdFileDetailSubstract = x.IdFileDetailSubstract,
                        IdDocumentSubstract = x.IdDocumentSubstract,
                        TransactionLineSubstract = x.TransactionLineSubstract,
                        QuantitySubstract = x.QuantitySubstract,
                        CifSubstract = x.CifSubstract,
                        FobSubstract = x.FobSubstract,
                        CustomDutiesSubstract = x.CustomDutiesSubstract,
                        IvaSubstract = x.IvaSubstract,
                        IdFileHeaderStock = x.IdFileHeaderStock,
                        IdFileDetailStock = x.IdFileDetailStock,
                        IdDocumentStock = x.IdDocumentStock,
                        TransactionLineStock = x.TransactionLineStock,
                        DocumentNameStock = x.DocumentNameStock,
                        DocumentNameSubstract = x.DocumentNameSubstract,
                        AuthorizationDate = x.AuthorizationDate,
                        RegisterDate = x.RegisterDate,
                        Assigned = false,
                        IsValid = valresult.IsValid,
                        Message = valresult.ErrorMsg
                    });
                });
            }

            return obj;
        }

        public static List<Commons.Transmition.OpaHeader> GetOpaHeader(Int32? IdCustomer, Int32? IdAccount, Int32? IdOpaHeader, Int32? IdState, String UserName)
        {
            List<Commons.Transmition.OpaHeader> obj = new List<Commons.Transmition.OpaHeader>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_OpaHeader_Result> result = db.spg_OpaHeader(IdCustomer, IdAccount, IdOpaHeader, IdState, UserName).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Transmition.OpaHeader()
                    {
                        Id = x.IdOpaHeader,
                        UserName = x.UserName,
                        IdCustomer = x.IdCustomer,
                        CustomerName = x.CustomerName,
                        IdAccount = x.IdAccount,
                        IdPriority = x.IdPriority,
                        PriorityName = x.PriorityName,
                        IdState = x.IdState,
                        StateName = x.StateName,
                        StartDateHeader = x.StartDateHeader,
                        EndDateHeader = x.EndDateHeader,
                        EnterpriseCode = x.EnterpriseCode,
                        Nit = x.Nit,
                        ImporterCode = x.ImporterCode,
                        ExporterCode = x.ExporterCode, 
                        StartDate = x.StartDate,
                        EndDate = x.EndDate,
                        RegisterUser = x.RegisterUser,
                        RegisterDate = x.RegisterDate,
                        Transmited = x.Transmited,
                        TransmitedLable = x.TransmitedLabel
                    });
                });
            }

            return obj;
        }

        public static List<Commons.Transmition.OpaDetail> GetOpaDetail(Int32 IdOpaHeader)
        {
            List<Commons.Transmition.OpaDetail> obj = new List<Commons.Transmition.OpaDetail>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_OpaDetail_Result> result = db.spg_OpaDetail(IdOpaHeader).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Transmition.OpaDetail()
                    {
                        Id = x.IdOpaDetail,
                        IdOpaHeader = x.IdOpaHeader,
                        IdState = x.IdState,
                        StateName = x.StateName,
                        IdFileItemDischarge = x.IdFileItemDischarge,
                        IdFileHeaderSubstract = x.IdFileHeaderSubstract,
                        IdFileDetailSubstract = x.IdFileDetailSubstract,
                        IdDocumentSubstract = x.IdDocumentSubstract,
                        TransactionLineSubstract = x.TransactionLineSubstract,
                        QuantitySubstract = x.QuantitySubstract,
                        CifSubstract = x.CifSubstract,
                        FobSubstract = x.FobSubstract,
                        CustomDutiesSubstract = x.CustomDutiesSubstract,
                        IvaSubstract = x.IvaSubstract,
                        IdFileHeaderStock = x.IdFileHeaderStock,
                        IdFileDetailStock = x.IdFileDetailStock,
                        IdDocumentStock = x.IdDocumentStock,
                        TransactionLineStock = x.TransactionLineStock,
                        DocumentNameStock = x.DocumentNameStock,
                        DocumentNameSubstract = x.DocumentNameSubstract,
                        StartDate = x.StartDate,
                        EndDate = x.EndDate,
                        Errors = (x.Error == null) ? 0 : (Int32)x.Error
                    });
                });
            }

            return obj;
        }

        public static List<Commons.Transmition.OpaMessageDetail> GetMessageDetail(Int32 IdOpaDetail)
        {
            List<Commons.Transmition.OpaMessageDetail> obj = new List<Commons.Transmition.OpaMessageDetail>();
            using (IndexEntities db = new IndexEntities())
            {
                List<spg_DetailResponse_Result> result = db.spg_DetailResponse(IdOpaDetail).ToList();
                result.ForEach(x => {
                    obj.Add(new Commons.Transmition.OpaMessageDetail()
                    {
                        ErrorType = x.ErrorType,
                        Message = x.ErrorMessage,
                        ResponseDate = (DateTime)x.ResponseDate
                    });
                });
            }

            return obj;
        }

        public static Boolean SaveToQueue(Int32 IdCustomer, Int32 IdAccount, Int32 IdPriority, DateTime StartDate, DateTime EndDate, String UserName, List<Commons.Transmition.OpaDetail> data)
        {
            using (IndexEntities db = new IndexEntities())
            {
                ObjectParameter IdOpaHeader = new ObjectParameter("IdOpaHeader", typeof(Int32));

                db.spi_OpaHeader(IdCustomer, IdAccount, IdPriority, StartDate, EndDate, UserName, IdOpaHeader);
                foreach (Commons.Transmition.OpaDetail item in data)
                {
                    db.spi_OpaDetail((Int32?)IdOpaHeader.Value, item.IdFileItemDischarge, item.IdFileHeaderSubstract, item.IdFileDetailSubstract,
                        item.IdDocumentSubstract, item.TransactionLineSubstract, item.QuantitySubstract, item.CifSubstract, item.FobSubstract,
                        item.CustomDutiesSubstract, item.IvaSubstract, item.IdFileHeaderStock, item.IdFileDetailStock, item.IdDocumentStock,
                        item.TransactionLineStock);
                }
            }

            return true;
        }

        public static Boolean Delete(Commons.Transmition.OpaHeader model)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_OpaDetail(model.Id);
            }

            return true;
        }

        public static Boolean DeleteItem(Int32 IdOpaDetail)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_OpaDetailItem(IdOpaDetail);
            }

            return true;
        }

        public static Boolean DeleteWithErrors(Int32 IdOpaHeader)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spd_ErrorOpaDetail(IdOpaHeader);
            }

            return true;
        }

        public static Boolean QueueToLog(Int32 IdOpaHeader)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spo_QueueToLog(IdOpaHeader);
            }

            return true;
        }

        public static Boolean ReproccessItem(Int32 IdOpaDetail)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_TransmitionQueueAgain(IdOpaDetail);
            }

            return true;
        }

        public static Boolean ReproccessBatch(Int32 IdOpaHeader)
        {
            using (IndexEntities db = new IndexEntities())
            {
                db.spu_TransmitionBatchAgain(IdOpaHeader);
            }

            return true;
        }

        public static Commons.Transmition.EmailResponse ValidateEmail(String UserName)
        {
            Commons.Transmition.EmailResponse obj = new Commons.Transmition.EmailResponse();
            using (IndexEntities db = new IndexEntities())
            {
                spg_TransmitionGetUserEmail_Result result = db.spg_TransmitionGetUserEmail(UserName).FirstOrDefault();
                obj.Email = result.Email;
                obj.HasPremission = (Boolean)result.HasPremission;
            }

            return obj;
        }
    }
}
