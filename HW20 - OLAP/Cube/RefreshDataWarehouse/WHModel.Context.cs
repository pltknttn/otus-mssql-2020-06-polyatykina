﻿//------------------------------------------------------------------------------
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
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class WHEntities : DbContext
    {
        public WHEntities()
            : base("name=WHEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<DimCustomer> DimCustomer { get; set; }
        public virtual DbSet<DimProductItem> DimProductItem { get; set; }
        public virtual DbSet<DimSupplier> DimSupplier { get; set; }
        public virtual DbSet<FactSale> FactSale { get; set; }
        public virtual DbSet<LoadedDataInfo> LoadedDataInfo { get; set; }
        public virtual DbSet<DimDate> DimDate { get; set; }
    
        public virtual int LoadDimDate(Nullable<System.DateTime> p_date_from, Nullable<System.DateTime> p_date_to)
        {
            var p_date_fromParameter = p_date_from.HasValue ?
                new ObjectParameter("p_date_from", p_date_from) :
                new ObjectParameter("p_date_from", typeof(System.DateTime));
    
            var p_date_toParameter = p_date_to.HasValue ?
                new ObjectParameter("p_date_to", p_date_to) :
                new ObjectParameter("p_date_to", typeof(System.DateTime));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("LoadDimDate", p_date_fromParameter, p_date_toParameter);
        }
    }
}