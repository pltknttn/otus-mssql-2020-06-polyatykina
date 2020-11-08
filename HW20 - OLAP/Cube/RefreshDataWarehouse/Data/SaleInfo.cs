using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RefreshDataWarehouse.Data
{
    public class SaleInfo
    {  
        public long CustomerID { get; set; } 
        public long SupplierID { get; set; } 
        public long ProductID { get; set; }
        public long InvoiceID { get; set; }
        public string InvoiceNum => InvoiceID.ToString();
        public System.DateTime InvoiceDate { get; set; }
        public int Quantity { get; set; }
        public decimal? UnitPrice { get; set; }
        public decimal? Amount { get; set; }
        public decimal TaxRate { get; set; }
        public decimal? TaxAmount { get; set; } 
    }
}
