//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RefreshDataWarehouse
{
    using System;
    using System.Collections.Generic;
    
    public partial class DimCustomer
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DimCustomer()
        {
            this.FactSale = new HashSet<FactSale>();
        }
    
        public long CustomerKey { get; set; }
        public long CustomerID { get; set; }
        public string CustomerName { get; set; }
        public string ContactName { get; set; }
        public string EmailAddress { get; set; }
        public string PostAddress { get; set; }
        public string PhoneNumber { get; set; }
        public string FaxNumber { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FactSale> FactSale { get; set; }
    }
}
