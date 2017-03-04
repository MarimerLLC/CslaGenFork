using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using Csla;
using Csla.Data;
using Invoices.DataAccess;

namespace Invoices.DataAccess.Oracle
{
    /// <summary>
    /// DAL SQL Server implementation of <see cref="ISupplierProductItemDal"/>
    /// </summary>
    public partial class SupplierProductItemDal : ISupplierProductItemDal
    {

        #region DAL methods

        /// <summary>
        /// Inserts a new SupplierProductItem object in the database.
        /// </summary>
        /// <param name="supplierId">The parent Supplier Id.</param>
        /// <param name="productSupplierId">The Product Supplier Id.</param>
        /// <param name="productId">The Product Id.</param>
        public void Insert(int supplierId, out int productSupplierId, Guid productId)
        {
            productSupplierId = -1;
            using (var ctx = ConnectionManager<OracleConnection>.GetManager("Invoices"))
            {
                using (var cmd = new OracleCommand("dbo.AddSupplierProductItem", ctx.Connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@SupplierId", supplierId).DbType = DbType.Int32;
                    cmd.Parameters.Add("@ProductSupplierId", productSupplierId).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@ProductId", productId).DbType = DbType.Guid;
                    cmd.ExecuteNonQuery();
                    productSupplierId = (int)cmd.Parameters["@ProductSupplierId"].Value;
                }
            }
        }

        /// <summary>
        /// Updates in the database all changes made to the SupplierProductItem object.
        /// </summary>
        /// <param name="productSupplierId">The Product Supplier Id.</param>
        /// <param name="productId">The Product Id.</param>
        public void Update(int productSupplierId, Guid productId)
        {
            using (var ctx = ConnectionManager<OracleConnection>.GetManager("Invoices"))
            {
                using (var cmd = new OracleCommand("dbo.UpdateSupplierProductItem", ctx.Connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ProductSupplierId", productSupplierId).DbType = DbType.Int32;
                    cmd.Parameters.Add("@ProductId", productId).DbType = DbType.Guid;
                    var rowsAffected = cmd.ExecuteNonQuery();
                    if (rowsAffected == 0)
                        throw new DataNotFoundException("SupplierProductItem");
                }
            }
        }

        /// <summary>
        /// Deletes the SupplierProductItem object from database.
        /// </summary>
        /// <param name="productSupplierId">The Product Supplier Id.</param>
        public void Delete(int productSupplierId)
        {
            using (var ctx = ConnectionManager<OracleConnection>.GetManager("Invoices"))
            {
                using (var cmd = new OracleCommand("dbo.DeleteSupplierProductItem", ctx.Connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ProductSupplierId", productSupplierId).DbType = DbType.Int32;
                    cmd.ExecuteNonQuery();
                }
            }
        }

        #endregion

    }
}
