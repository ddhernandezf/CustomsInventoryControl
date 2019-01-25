using System;
using System.ComponentModel.DataAnnotations;

namespace Index.Commons
{
    public class Item : Log.Properties
    {
        [ScaffoldColumn(false)]
        public Int32 Id { get; set; }

        [Display(Name = "Nombre")]
        [Required(ErrorMessage = "*")]
        public Int32 IdCustomer { get; set; }

        [Display(Name = "Cuenta")]
        [Required(ErrorMessage = "*")]
        public Int32 IdAccount { get; set; }

        [Display(Name = "Resolución")]
        public Int32? IdResolucion { get; set; }

        [Display(Name = "Partida")]
        public Int32? IdAccountingItem { get; set; }

        [Display(Name = "Unidad Medida")]
        [Required(ErrorMessage = "*")]
        public Int32 IdUnitMeasurement { get; set; }

        [Display(Name = "Código")]
        [MaxLength(1000, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        [Required(ErrorMessage = "*")]
        public String Code { get; set; }

        [Display(Name = "Código de barras")]
        [MaxLength(100, ErrorMessage = "100 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Barcode { get; set; }

        [Display(Name = "Nombre")]
        [MaxLength(200, ErrorMessage = "200 caracteres máximos")]
        [DataType(DataType.Text)]
        [Required(ErrorMessage = "*")]
        public String Name { get; set; }

        [Display(Name = "Nombre")]
        public String DisplayProductName { get; set; }

        [Display(Name = "Descripción")]
        [MaxLength(1000, ErrorMessage = "1000 caracteres máximos")]
        [DataType(DataType.Text)]
        public String Description { get; set; }

        [Display(Name = "Es Producto")]
        [DataType(DataType.Text)]
        [Required(ErrorMessage = "*")]
        public Boolean IsProduct { get; set; }

        [Display(Name = "Unidad Medida")]
        public String UnitMeasurementName { get; set; }

        [Display(Name = "Símbolo")]
        public String UnitMeasurementSymbol { get; set; }

        [Display(Name = "Inciso Arancelario")]
        public String AccountingItem { get; set; }

        [Display(Name = "Inciso Arancelario")]
        public String AccountingItemName { get; set; }

        [Display(Name = "Inciso Arancelario")]
        public String DisplayAccountingItemName { get; set; }

        [Display(Name = "Inciso Arancelario Padre")]
        public String AccountingItemParent { get; set; }

        [Display(Name = "Inciso Arancelario Padre")]
        public String AccountingItemParentName { get; set; }

        [Display(Name = "Formula")]
        public Boolean? HasFormula { get; set; }

        [Display(Name = "Activo")]
        [Required(ErrorMessage = "*")]
        public Boolean Active { get; set; }
    }
}
