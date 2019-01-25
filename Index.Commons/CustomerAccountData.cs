using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Index.Commons
{
    public class CustomerAccountData : Log.Properties
    {
        [Required(ErrorMessage ="*")]
        public Int32 IdCustomer { get; set; }

        [Required(ErrorMessage = "*")]
        public Int32 IdAccount { get; set; }

        [Display(Name = "Calificación resolución")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String ResolutionRate { get; set; }

        [Display(Name = "Calificación régimen")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String RegimeRate { get; set; }

        [Display(Name = "Fecha inicio")]
        public DateTime? ResolutionStartDate { get; set; }

        [Display(Name = "Fecha fin")]
        public DateTime? ResolutionEndDate { get; set; }

        [Display(Name = "Fecha inicio")]
        public DateTime? FiscalPeriodStartDate { get; set; }

        [Display(Name = "Fecha fin")]
        public DateTime? FiscalPeriodEndDate { get; set; }
    }
}
