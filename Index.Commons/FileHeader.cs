using System;
using System.ComponentModel.DataAnnotations;


namespace Index.Commons
{
    public class FileHeader : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Cliente")]
        [Required(ErrorMessage = "*")]
        public Int32 IdCustomer { get; set; }
        
        [Display(Name = "Tipo Documento")]
        [Required(ErrorMessage = "*")]
        public Int32 IdFileInfoConfig { get; set; }

        [Display(Name = "")]
        public String FileInfoName { get; set; }

        [Display(Name = "")]
        public String Operation { get; set; }

        [Display(Name = "")]
        public Boolean LoadRawMaterial { get; set; }

        [Display(Name = "")]
        public Boolean IsSubstract { get; set; }

        [Display(Name = "")]
        public String IdDocument { get; set; }

        [Display(Name = "")]
        public DateTime? AuthorizationDate { get; set; }

        [Display(Name = "")]
        public DateTime? ExpantionDate { get; set; }

        [Display(Name = "")]
        public DateTime? ExpirationDate { get; set; }

        [Display(Name = "")]
        public DateTime? DocumentDate { get; set; }

        [Display(Name = "")]
        public DateTime? ArrivalDate { get; set; }

        [Display(Name = "")]
        public String StrAuthorizationDate { get; set; }

        [Display(Name = "")]
        public String StrExpantionDate { get; set; }

        [Display(Name = "")]
        public String StrExpirationDate { get; set; }

        [Display(Name = "")]
        public String StrDocumentDate { get; set; }

        [Display(Name = "")]
        public String StrArrivalDate { get; set; }

        [Display(Name = "")]
        public Decimal? ExchangeRate { get; set; }

        [Display(Name = "")]
        public Decimal? Insurance { get; set; }

        [Display(Name = "")]
        public Decimal? Cargo { get; set; }

        [Display(Name = "")]
        public Int32? IdCustom { get; set; }

        [Display(Name = "")]
        public String CustomName { get; set; }

        [Display(Name = "")]
        public Int32? IdCountry { get; set; }

        [Display(Name = "")]
        public String CountryName { get; set; }

        [Display(Name = "")]
        public Int32? IdWarranty { get; set; }

        [Display(Name = "")]
        public String WarrantyName { get; set; }

        [Display(Name = "")]
        public Int32? IdCellar { get; set; }

        [Display(Name = "")]
        public String CellarName { get; set; }

        [Display(Name = "")]
        public Int32? IdState { get; set; }

        [Display(Name = "")]
        public String StateName { get; set; }

        [Display(Name = "")]
        public Int32? IdCurrency { get; set; }

        [Display(Name = "")]
        public String CurrencyName { get; set; }

        [Display(Name = "")]
        public Int32? IdResolution { get; set; }

        [Display(Name = "")]
        public String ResolutionName { get; set; }

        [Display(Name = "")]
        public Int32? IdAccount { get; set; }

        [Display(Name = "")]
        public Decimal? CifTotal { get; set; }

        [Display(Name = "")]
        public Int32? LinesTotal { get; set; }

        public Boolean UseAttached { get; set; }

        [Display(Name = "")]
        public String AccounName { get; set; }

        [Display(Name = "")]
        public Boolean Reviewed { get; set; }

        public String Facturas { get; set; }
        
        public DateTime CreateDate { get; set; }

        public String StrCreateDate { get; set; }

        public DateTime? UpdateDate { get; set; }
        public Boolean? ConfigActive { get; set; }
    }
}
