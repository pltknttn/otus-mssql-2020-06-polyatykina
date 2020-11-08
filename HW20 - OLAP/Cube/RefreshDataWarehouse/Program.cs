using EntityFramework.Utilities;
using RefreshDataWarehouse.Data;
using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Security.Permissions;
using System.Text;
using System.Threading.Tasks;

namespace RefreshDataWarehouse
{
    class Program
    {
        static void Main(string[] args)
        {
            UpdateWH();
        }

        static DateTime GetLastUpdateDate(WHEntities db, string tableName)
        {
            var lastdate = db.LoadedDataInfo.FirstOrDefault(s => s.TableName == tableName)?.UpdateDate;
            return lastdate??DateTime.MinValue; 
        }

        static void SetLastUpdateDate(string tableName, bool successful, string error)
        {
            using (var db = new WHEntities())
            {
                var lu = db.LoadedDataInfo.FirstOrDefault(s => s.TableName == tableName);
                if (lu == null)
                {
                    lu = new LoadedDataInfo()
                    {
                        TableName = tableName,
                        LoadStart = DateTime.Now,
                        Successful = false
                    };
                    db.LoadedDataInfo.Add(lu);
                }
                if (successful) lu.UpdateDate = DateTime.Now;
                lu.Successful = successful;
                lu.ErrorMessage = error;

                db.SaveChanges();
            }
        }

        static bool UpdateSuppliers()
        {
            var tableName = "DimSupplier";
            
            using (WHEntities db = new WHEntities())
            {
                var startDate = GetLastUpdateDate(db, tableName);
                List<SupplierInfo> suppliers = null;

                using (WWIEntities sdb = new WWIEntities())
                {
                    suppliers = sdb.Suppliers.Where(x=>x.ValidFrom > startDate).Select( s =>
                            new SupplierInfo()
                            { 
                                SupplierID = s.SupplierID,
                                SupplierName = s.SupplierName,
                                ContactName = s.People2.FullName,
                                EmailAddress = s.People2.EmailAddress,
                                PostalCode = s.PostalPostalCode,
                                PostalAddressLine1 = s.PostalAddressLine1,
                                PostalAddressLine2 = s.PostalAddressLine2,
                                PhoneNumber = s.PhoneNumber,
                                FaxNumber = s.FaxNumber
                            }
                        ).ToList(); 
                }
                if (suppliers?.Any() == true)
                {
                    try
                    {
                        var supplierIds = suppliers.Select(x => x.SupplierID).ToArray();
                        var updateSuppliers = db.DimSupplier.Where(w => supplierIds.Contains(w.SupplierID)).ToList() ?? new List<DimSupplier>();
                        var insertSuppliers = new List<DimSupplier>();

                        foreach (var sup in suppliers)
                        {
                            var supplier = updateSuppliers?.FirstOrDefault(w => w.SupplierID == sup.SupplierID);
                            if (supplier == null)
                            {
                                supplier = new DimSupplier() { SupplierID = sup.SupplierID };
                                insertSuppliers.Add(supplier);
                            }
                            supplier.SupplierName = sup.SupplierName;
                            supplier.ContactName = sup.ContactName;
                            supplier.EmailAddress = sup.EmailAddress;
                            supplier.PostAddress = $"{sup.PostalCode}, {sup.PostalAddressLine1}, {sup.PostalAddressLine2}".TrimStart(',').TrimStart(' ').TrimStart(',').TrimStart(' ');
                            supplier.PhoneNumber = sup.PhoneNumber;
                            supplier.FaxNumber = sup.FaxNumber;
                        }

                        if (updateSuppliers?.Any() == true) EFBatchOperation.For(db, db.DimSupplier).UpdateAll(updateSuppliers,
                            x => x.ColumnsToUpdate(c=>c.SupplierName, c=>c.ContactName, c=>c.EmailAddress, c=>c.PostAddress, c=>c.PhoneNumber,c=>c.FaxNumber));
                        if (insertSuppliers?.Any() == true) EFBatchOperation.For(db, db.DimSupplier).InsertAll(insertSuppliers);

                        db.SaveChanges();

                        supplierIds = null;
                        updateSuppliers = null;
                        insertSuppliers = null;
                    }
                    catch(Exception ex)
                    {
                        SetLastUpdateDate(tableName, false, ex.InnerException?.Message ?? ex.Message);
                        Console.WriteLine(ex.InnerException?.Message ?? ex.Message);
                        return false;
                    }
                }
                SetLastUpdateDate(tableName, true, null);
                suppliers = null;
            }
            return true;
        }

        static bool UpdateCustomers()
        {
            var tableName = "DimCustomer";

            using (WHEntities db = new WHEntities())
            {
                var startDate = GetLastUpdateDate(db, tableName);
                List<CustomerInfo> customers = null;

                using (WWIEntities sdb = new WWIEntities())
                {
                    customers = sdb.Customers.Where(x => x.ValidFrom > startDate).Select(s =>
                             new CustomerInfo()
                             {
                                 CustomerID = s.CustomerID,
                                 CustomerName = s.CustomerName,
                                 ContactName = s.People2.FullName,
                                 EmailAddress = s.People2.EmailAddress,
                                 PostalCode = s.PostalPostalCode,
                                 PostalAddressLine1 = s.PostalAddressLine1,
                                 PostalAddressLine2 = s.PostalAddressLine2,
                                 PhoneNumber = s.PhoneNumber,
                                 FaxNumber = s.FaxNumber
                             }
                        ).ToList();
                }
                if (customers?.Any() == true)
                {
                    try
                    {
                        var customerIds = customers.Select(x => x.CustomerID).ToArray();
                        var updateCustomers = db.DimCustomer.Where(w => customerIds.Contains(w.CustomerID)).ToList() ?? new List<DimCustomer>();
                        var insertCustomers = new List<DimCustomer>();

                        foreach (var cust in customers)
                        {
                            var customer = updateCustomers?.FirstOrDefault(w => w.CustomerID == cust.CustomerID);
                            if (customer == null)
                            {
                                customer = new DimCustomer() { CustomerID = cust.CustomerID };
                                insertCustomers.Add(customer);
                            }
                            customer.CustomerName = cust.CustomerName;
                            customer.ContactName = cust.ContactName;
                            customer.EmailAddress = cust.EmailAddress;
                            customer.PostAddress = $"{cust.PostalCode}, {cust.PostalAddressLine1}, {cust.PostalAddressLine2}".TrimStart(',').TrimStart(' ').TrimStart(',').TrimStart(' ');
                            customer.PhoneNumber = cust.PhoneNumber;
                            customer.FaxNumber = cust.FaxNumber;
                        }

                        if (updateCustomers?.Any() == true) EFBatchOperation.For(db, db.DimCustomer).UpdateAll(updateCustomers, 
                            x => x.ColumnsToUpdate(c => c.CustomerName, c => c.ContactName, c => c.EmailAddress, c => c.PostAddress, c => c.PhoneNumber, c => c.FaxNumber));
                        if (insertCustomers?.Any() == true) EFBatchOperation.For(db, db.DimCustomer).InsertAll(insertCustomers);

                        db.SaveChanges();

                        customerIds = null;
                        updateCustomers = null;
                        insertCustomers = null;
                    }
                    catch (Exception ex)
                    {
                        SetLastUpdateDate(tableName, false, ex.InnerException?.Message ?? ex.Message);
                        Console.WriteLine(ex.InnerException?.Message ?? ex.Message);
                        return false;
                    }
                }
                SetLastUpdateDate(tableName, true, null);
                customers = null;
            }
            return true;
        }

        static bool UpdateProducts()
        {
            var tableName = "DimProductItem";

            using (WHEntities db = new WHEntities())
            {
                var startDate = GetLastUpdateDate(db, tableName);
                List<ProductInfo> products = null;

                using (WWIEntities sdb = new WWIEntities())
                {
                    products = sdb.StockItems.Where(x => x.ValidFrom > startDate).Select(s =>
                             new ProductInfo()
                             {
                                 ProductID = s.StockItemID,
                                 ProductName = s.StockItemName,
                                 ProductCode = s.Barcode,
                                 ProducerName = s.Brand,
                                 CategoryName = s.StockItemStockGroups.Max(g=>g.StockGroups.StockGroupName),
                                 RetailUnitPrice = s.UnitPrice,
                                 WeightPerUnit = s.TypicalWeightPerUnit,
                                 Color = s.Colors.ColorName,
                                 Size = s.Size
                             }
                        ).ToList();
                }
                if (products?.Any() == true)
                {
                    try
                    {
                        var productsIds = products.Select(x => x.ProductID).ToArray();
                        var updateProducts = db.DimProductItem.Where(w => productsIds.Contains(w.ProductID)).ToList() ?? new List<DimProductItem>();
                        var insertProducts = new List<DimProductItem>();

                        foreach (var prod in products)
                        {
                            var product = updateProducts?.FirstOrDefault(w => w.ProductID == prod.ProductID);
                            if (product == null)
                            {
                                product = new DimProductItem() { ProductID = prod.ProductID };
                                insertProducts.Add(product);
                            }
                            product.ProductName = prod.ProductName ?? "N/A";
                            product.ProductCode = prod.ProductCode ?? "N/A";
                            product.ProducerName = prod.ProducerName ?? "N/A";
                            product.CategoryName = prod.CategoryName ?? "N/A";
                            product.RetailUnitPrice = prod.RetailUnitPrice;
                            product.WeightPerUnit = prod.WeightPerUnit;
                            product.Color = prod.Color ?? "N/A";
                            product.Size = prod.Size ?? "N/A";
                        } 
                        if (updateProducts?.Any() == true) EFBatchOperation.For(db, db.DimProductItem).UpdateAll(updateProducts,
                            x => x.ColumnsToUpdate(
                                c => c.ProductName,
                                c => c.ProductCode,
                                c => c.ProducerName,
                                c => c.CategoryName,
                                c => c.RetailUnitPrice,
                                c => c.WeightPerUnit,
                                c => c.Color,
                                c => c.Size));
                        if (insertProducts?.Any() == true) EFBatchOperation.For(db, db.DimProductItem).InsertAll(insertProducts);

                        db.SaveChanges();

                        productsIds = null;
                        updateProducts = null;
                        insertProducts = null;
                    }
                    catch (Exception ex)
                    {
                        SetLastUpdateDate(tableName, false, ex.InnerException?.Message ?? ex.Message);
                        Console.WriteLine(ex.InnerException?.Message ?? ex.Message); 
                        return false;
                    }
                }
                SetLastUpdateDate(tableName, true, null);
                products = null;
            }
            return true;
        }

        static bool UpdateDates()
        {
            var tableName = "DimDate";

            using (WHEntities db = new WHEntities())
            {
                try
                {
                    var startDate = GetLastUpdateDate(db, tableName);
                    var dimMinDate = db.DimDate.Any() ? db.DimDate.Min(x => x.Date) : new DateTime(2000, 1, 1);
                    var dimMaxDate = db.DimDate.Any() ? db.DimDate.Max(x => x.Date) : DateTime.Now.Date;
                    
                    if (!db.DimDate.Any())
                    {
                        db.LoadDimDate(dimMinDate, dimMaxDate);
                    }

                    using (WWIEntities sdb = new WWIEntities())
                    {
                        var minDate = sdb.Invoices.Min(x => x.InvoiceDate);
                        if (dimMinDate > minDate && minDate > DateTime.MinValue)
                        {
                            db.LoadDimDate(minDate, dimMinDate);
                            dimMinDate = minDate;
                        }
                        var maxDate = sdb.Invoices.Max(x => x.InvoiceDate);
                        if (dimMaxDate < maxDate && dimMaxDate > DateTime.MinValue)
                        {
                            db.LoadDimDate(dimMaxDate, maxDate);
                            dimMaxDate = maxDate;
                        }
                    }

                    if (dimMaxDate < DateTime.Now.Date) db.LoadDimDate(dimMaxDate, DateTime.Now.Date);
                }
                catch (Exception ex)
                {
                    SetLastUpdateDate(tableName, false, ex.InnerException?.Message ?? ex.Message);
                    Console.WriteLine(ex.InnerException?.Message ?? ex.Message);
                    return false;
                } 
            }
            SetLastUpdateDate(tableName, true, null);
            return true;
        }

        static bool UpdateFactSales()
        {
            var tableName = "FactSale";

            using (WHEntities db = new WHEntities())
            {
                db.Database.CommandTimeout = 18000;
                 
                var startDate = GetLastUpdateDate(db, tableName);
                List<SaleInfo> sales = null;
                
                using (WWIEntities sdb = new WWIEntities())
                {
                    sdb.Database.CommandTimeout = 720; 

                    var editLines = sdb.InvoiceLines.Where(x => x.LastEditedWhen > startDate).GroupBy(x => x.Invoices.LastEditedWhen).Select(s => s.Key).ToList();
                    var lastEdit = editLines?.Any() == true ? editLines.Min(x => x) : DateTime.Now;
                    if (lastEdit < startDate && lastEdit > DateTime.Now) startDate = lastEdit;

                    sales = sdb.Invoices
                            .Where(x => x.LastEditedWhen > startDate)
                            .Join(sdb.InvoiceLines, i => i.InvoiceID, l => l.InvoiceID, (i, l) =>
                            new
                            {
                                InvoiceLineID = l.InvoiceLineID,
                                InvoiceID = i.InvoiceID,
                                InvoiceDate = i.InvoiceDate,
                                Quantity = l.Quantity,
                                UnitPrice = l.UnitPrice,
                                Amount = l.Quantity * l.UnitPrice,
                                TaxRate = l.TaxRate,
                                TaxAmount = l.TaxAmount,
                                ProductID = l.StockItemID,
                                SupplierID = l.StockItems.SupplierID,
                                CustomerID = i.CustomerID
                            })
                            .GroupBy(g => new { g.InvoiceID, g.ProductID })
                            .Select(s => new SaleInfo()
                            {
                                InvoiceID = s.Key.InvoiceID,
                                InvoiceDate = s.Max(x => x.InvoiceDate),
                                Quantity = s.Sum(x => x.Quantity),
                                UnitPrice = s.Average(x => x.UnitPrice),
                                Amount = s.Sum(x => x.Quantity * x.UnitPrice),
                                TaxRate = s.Max(x => x.TaxRate),
                                TaxAmount = s.Sum(x => x.TaxAmount),
                                ProductID = s.Key.ProductID,
                                SupplierID = s.Max(x => x.SupplierID),
                                CustomerID = s.Max(x => x.CustomerID)
                            })
                            .ToList();
                }
                if (sales?.Any() == true)
                {
                    try
                    {
                        var suppliers = new Dictionary<long, long>();
                        foreach (var supplier in sales.Select(x => x.SupplierID).Distinct())
                            suppliers.Add(supplier, db.DimSupplier.FirstOrDefault(x => x.SupplierID == supplier).SupplierKey);

                        var customers = new Dictionary<long, long>();
                        foreach (var customer in sales.Select(x => x.CustomerID).Distinct())
                            customers.Add(customer, db.DimCustomer.FirstOrDefault(x => x.CustomerID == customer).CustomerKey);

                        var products = new Dictionary<long, long>();
                        foreach (var product in sales.Select(x => x.ProductID).Distinct())
                            products.Add(product, db.DimProductItem.FirstOrDefault(x => x.ProductID == product).ProductKey);

                        var invoiceIds = sales.Select(x => x.InvoiceID).Distinct().ToList();
                        while(invoiceIds?.Any()==true)
                        {
                            var part = invoiceIds.Take(5000).ToArray();
                            EFBatchOperation.For(db, db.FactSale).Where(x => part.Contains(x.InvoiceID)).Delete();
                            invoiceIds.RemoveAll(i=> part.Contains(i));
                        }
                        
                        var insertSales = new List<FactSale>();

                        foreach (var sl in sales)
                        {                             
                            if (!suppliers.ContainsKey(sl.SupplierID) || !customers.ContainsKey(sl.CustomerID) || !products.ContainsKey(sl.ProductID))
                            {
                                continue;
                            }
                            var sale = new FactSale();
                            sale.InvoiceID = sl.InvoiceID;
                            sale.InvoiceNum = sl.InvoiceNum;
                            sale.SupplierKey = suppliers[sl.SupplierID];
                            sale.CustomerKey = customers[sl.CustomerID];
                            sale.ProductKey = products[sl.ProductID];
                            sale.InvoiceDate = sl.InvoiceDate;
                            sale.Quantity = sl.Quantity;
                            sale.UnitPrice = sl.UnitPrice ?? 0;
                            sale.Amount = sl.Amount ?? 0;
                            sale.TaxRate = sl.TaxRate;
                            sale.TaxAmount = sl.TaxAmount ?? 0;
                            insertSales.Add(sale);
                        }

                        if (insertSales?.Any() == true) EFBatchOperation.For(db, db.FactSale).InsertAll(insertSales);

                        db.SaveChanges();
                    }
                    catch (Exception ex)
                    {
                        SetLastUpdateDate(tableName, false, ex.InnerException?.Message ?? ex.Message);
                        Console.WriteLine(ex.InnerException?.Message ?? ex.Message);
                        return false;
                    }
                }
                SetLastUpdateDate(tableName, true, null);
            }
            return true;
        }

        static void UpdateWH()
        {
            if (UpdateSuppliers() && UpdateCustomers() && UpdateProducts() && UpdateDates())
                UpdateFactSales();
        }
    }
}
