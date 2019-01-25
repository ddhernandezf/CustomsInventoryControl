using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class AccountingItem:Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }
        
        [Display(Name = "Resolución")]
        public Int32 IdResolution { get; set; }

        [Display(Name = "Resolución")]
        public String ResolutionName { get; set; }

        [Display(Name = "Partida")]
        [Required(ErrorMessage = "*")]
        [MaxLength(45, ErrorMessage = "45 caracteres máximos")]
        [DataType(DataType.Text)]
        public String AccountingItem_ { get; set; }

        [Display(Name = "Descripción")]
        [MaxLength(1000, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Description { get; set; }

        [Display(Name = "Padre")]
        [MaxLength(45, ErrorMessage = "45 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Parent { get; set; }

        [Display(Name = "Padre")]
        public Int32? IdParent { get; set; }

        [Display(Name = "Padre")]
        public String ParentDescription { get; set; }

        [Display(Name = "Nivel")]
        [Required(ErrorMessage = "*")]
        public Int32 Level { get; set; }

        [Display(Name = "DAI")]
        public Decimal? CustomDuties { get; set; }

        public Boolean Usable { get; set; }
        public String AccountingItemDisplay { get; set; }
        public String ParentAccountingItem { get; set; }
        public String ParentAccountingItemDisplay { get; set; }
    }
}
