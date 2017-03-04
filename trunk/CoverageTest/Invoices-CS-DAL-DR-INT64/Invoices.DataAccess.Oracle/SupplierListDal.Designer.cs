using System;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using Csla;
using Csla.Data;
using Invoices.DataAccess;

namespace Invoices.DataAccess.Oracle
{
    /// <summary>
    /// DAL SQL Server implementation of <see cref="ISupplierListDal"/>
    /// </summary>
    public partial class SupplierListDal : ISupplierListDal
    {

        #region DAL methods

        /// <summary>
        /// Loads a SupplierList collection from the database.
        /// </summary>
        /// <returns>A data reader to the SupplierList.</returns>
        public IDataReader Fetch()
        {
            using (var ctx = ConnectionManager<OracleConnection>.GetManager("Invoices"))
            {
                GetQueryGetSupplierList();
                using (var cmd = new OracleCommand(getSupplierListInlineQuery, ctx.Connection))
                {
                    cmd.CommandType = CommandType.Text;
                    return cmd.ExecuteReader();
                }
            }
        }

        /// <summary>
        /// Loads a SupplierList collection from the database.
        /// </summary>
        /// <param name="name">The Name.</param>
        /// <returns>A data reader to the SupplierList.</returns>
        public IDataReader Fetch(string name)
        {
            using (var ctx = ConnectionManager<OracleConnection>.GetManager("Invoices"))
            {
                GetQueryGetSupplierListByName(name);
                using (var cmd = new OracleCommand(getSupplierListByNameInlineQuery, ctx.Connection))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.Add("@Name", name).DbType = DbType.String;
                    return cmd.ExecuteReader();
                }
            }
        }

        #endregion

        #region Inline queries fields and partial methods

        [NotUndoable, NonSerialized]
        private string getSupplierListInlineQuery;

        [NotUndoable, NonSerialized]
        private string getSupplierListByNameInlineQuery;

        partial void GetQueryGetSupplierList();

        partial void GetQueryGetSupplierListByName(string name);

        #endregion

    }
}
