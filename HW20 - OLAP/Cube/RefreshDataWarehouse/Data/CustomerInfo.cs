using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RefreshDataWarehouse.Data
{
    public class CustomerInfo
    { 
        public long CustomerID { get; set; }
        public string CustomerName { get; set; }
        public string ContactName { get; set; }
        public string EmailAddress { get; set; }
        public string PostalAddressLine1 { get; set; }
        public string PostalAddressLine2 { get; set; }
        public string PostalCode { get; set; }
        public string PhoneNumber { get; set; }
        public string FaxNumber { get; set; }
    }
}
