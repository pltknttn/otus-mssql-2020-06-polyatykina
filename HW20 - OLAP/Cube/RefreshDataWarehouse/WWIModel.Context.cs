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
    
    public partial class WWIEntities : DbContext
    {
        public WWIEntities()
            : base("name=WWIEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<People> People { get; set; }
        public virtual DbSet<SupplierCategories> SupplierCategories { get; set; }
        public virtual DbSet<Suppliers> Suppliers { get; set; }
        public virtual DbSet<CustomerCategories> CustomerCategories { get; set; }
        public virtual DbSet<Customers> Customers { get; set; }
        public virtual DbSet<InvoiceLines> InvoiceLines { get; set; }
        public virtual DbSet<Invoices> Invoices { get; set; }
        public virtual DbSet<Colors> Colors { get; set; }
        public virtual DbSet<StockItems> StockItems { get; set; }
        public virtual DbSet<StockGroups> StockGroups { get; set; }
        public virtual DbSet<StockItemStockGroups> StockItemStockGroups { get; set; }
    }
}