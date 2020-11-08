using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RefreshDataWarehouse.Data
{
    public class ProductInfo
    { 
        public long ProductID { get; set; }
        public string ProductName { get; set; }
        public string ProductCode { get; set; }
        public string ProducerName { get; set; }
        public string CategoryName { get; set; }
        public decimal RetailUnitPrice { get; set; }
        public decimal WeightPerUnit { get; set; }
        public string Color { get; set; }
        public string Size { get; set; }
    }
}
