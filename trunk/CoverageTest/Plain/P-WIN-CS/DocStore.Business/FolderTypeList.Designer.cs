//  This file was generated by CSLA Object Generator - CslaGenFork v4.5
//
// Filename:    FolderTypeList
// ObjectType:  FolderTypeList
// CSLAType:    ReadOnlyCollection

using System;
using System.Data;
using System.Data.SqlClient;
using Csla;
using Csla.Data;
using DocStore.Business.Util;
using Csla.Rules;
using Csla.Rules.CommonRules;

namespace DocStore.Business
{

    /// <summary>
    /// Collection of folder type's basic information (read only list).<br/>
    /// This is a generated base class of <see cref="FolderTypeList"/> business object.
    /// This class is a root collection.
    /// </summary>
    /// <remarks>
    /// The items of the collection are <see cref="FolderTypeInfo"/> objects.
    /// </remarks>
    [Serializable]
    public partial class FolderTypeList : ReadOnlyBindingListBase<FolderTypeList, FolderTypeInfo>
    {

        #region Collection Business Methods

        /// <summary>
        /// Determines whether a <see cref="FolderTypeInfo"/> item is in the collection.
        /// </summary>
        /// <param name="folderTypeID">The FolderTypeID of the item to search for.</param>
        /// <returns><c>true</c> if the FolderTypeInfo is a collection item; otherwise, <c>false</c>.</returns>
        public bool Contains(int folderTypeID)
        {
            foreach (var folderTypeInfo in this)
            {
                if (folderTypeInfo.FolderTypeID == folderTypeID)
                {
                    return true;
                }
            }
            return false;
        }

        #endregion

        #region Find Methods

        /// <summary>
        /// Finds a <see cref="FolderTypeInfo"/> item of the <see cref="FolderTypeList"/> collection, based on a given FolderTypeID.
        /// </summary>
        /// <param name="folderTypeID">The FolderTypeID.</param>
        /// <returns>A <see cref="FolderTypeInfo"/> object.</returns>
        public FolderTypeInfo FindFolderTypeInfoByFolderTypeID(int folderTypeID)
        {
            for (var i = 0; i < this.Count; i++)
            {
                if (this[i].FolderTypeID.Equals(folderTypeID))
                {
                    return this[i];
                }
            }

            return null;
        }

        #endregion

        #region Private Fields

        private static FolderTypeList _list;

        #endregion

        #region Cache Management Methods

        /// <summary>
        /// Clears the in-memory FolderTypeList cache so it is reloaded on the next request.
        /// </summary>
        public static void InvalidateCache()
        {
            _list = null;
        }

        /// <summary>
        /// Used by async loaders to load the cache.
        /// </summary>
        /// <param name="list">The list to cache.</param>
        internal static void SetCache(FolderTypeList list)
        {
            _list = list;
        }

        internal static bool IsCached
        {
            get { return _list != null; }
        }

        #endregion

        #region Factory Methods

        /// <summary>
        /// Factory method. Loads a <see cref="FolderTypeList"/> collection.
        /// </summary>
        /// <returns>A reference to the fetched <see cref="FolderTypeList"/> collection.</returns>
        public static FolderTypeList GetFolderTypeList()
        {
            if (_list == null)
                _list = DataPortal.Fetch<FolderTypeList>();

            return _list;
        }

        /// <summary>
        /// Factory method. Loads a <see cref="FolderTypeList"/> collection, based on given parameters.
        /// </summary>
        /// <param name="folderTypeName">The FolderTypeName parameter of the FolderTypeList to fetch.</param>
        /// <returns>A reference to the fetched <see cref="FolderTypeList"/> collection.</returns>
        public static FolderTypeList GetFolderTypeList(string folderTypeName)
        {
            return DataPortal.Fetch<FolderTypeList>(folderTypeName);
        }

        /// <summary>
        /// Factory method. Asynchronously loads a <see cref="FolderTypeList"/> collection.
        /// </summary>
        /// <param name="callback">The completion callback method.</param>
        public static void GetFolderTypeList(EventHandler<DataPortalResult<FolderTypeList>> callback)
        {
            if (_list == null)
                DataPortal.BeginFetch<FolderTypeList>((o, e) =>
                    {
                        _list = e.Object;
                        callback(o, e);
                    });
            else
                callback(null, new DataPortalResult<FolderTypeList>(_list, null, null));
        }

        /// <summary>
        /// Factory method. Asynchronously loads a <see cref="FolderTypeList"/> collection, based on given parameters.
        /// </summary>
        /// <param name="folderTypeName">The FolderTypeName parameter of the FolderTypeList to fetch.</param>
        /// <param name="callback">The completion callback method.</param>
        public static void GetFolderTypeList(string folderTypeName, EventHandler<DataPortalResult<FolderTypeList>> callback)
        {
            DataPortal.BeginFetch<FolderTypeList>(folderTypeName, callback);
        }

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="FolderTypeList"/> class.
        /// </summary>
        /// <remarks> Do not use to create a Csla object. Use factory methods instead.</remarks>
        [System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Never)]
        public FolderTypeList()
        {
            // Use factory methods and do not use direct creation.

            var rlce = RaiseListChangedEvents;
            RaiseListChangedEvents = false;
            AllowNew = false;
            AllowEdit = false;
            AllowRemove = false;
            RaiseListChangedEvents = rlce;
        }

        #endregion

        #region Object Authorization

        /// <summary>
        /// Adds the object authorization rules.
        /// </summary>
        protected static void AddObjectAuthorizationRules()
        {
            BusinessRules.AddRule(typeof (FolderTypeList), new IsInRole(AuthorizationActions.GetObject, "User"));

            AddObjectAuthorizationRulesExtend();
        }

        /// <summary>
        /// Allows the set up of custom object authorization rules.
        /// </summary>
        static partial void AddObjectAuthorizationRulesExtend();

        /// <summary>
        /// Checks if the current user can retrieve FolderTypeList's properties.
        /// </summary>
        /// <returns><c>true</c> if the user can read the object; otherwise, <c>false</c>.</returns>
        public static bool CanGetObject()
        {
            return BusinessRules.HasPermission(Csla.Rules.AuthorizationActions.GetObject, typeof(FolderTypeList));
        }

        #endregion

        #region Data Access

        /// <summary>
        /// Loads a <see cref="FolderTypeList"/> collection from the database or from the cache.
        /// </summary>
        protected void DataPortal_Fetch()
        {
            if (IsCached)
            {
                LoadCachedList();
                return;
            }

            using (var ctx = ConnectionManager<SqlConnection>.GetManager(Database.DocStoreConnection, false))
            {
                using (var cmd = new SqlCommand("GetFolderTypeList", ctx.Connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    var args = new DataPortalHookArgs(cmd);
                    OnFetchPre(args);
                    LoadCollection(cmd);
                    OnFetchPost(args);
                }
            }
            _list = this;
        }

        private void LoadCachedList()
        {
            IsReadOnly = false;
            var rlce = RaiseListChangedEvents;
            RaiseListChangedEvents = false;
            AddRange(_list);
            RaiseListChangedEvents = rlce;
            IsReadOnly = true;
        }

        /// <summary>
        /// Loads a <see cref="FolderTypeList"/> collection from the database, based on given criteria.
        /// </summary>
        /// <param name="folderTypeName">The Folder Type Name.</param>
        protected void DataPortal_Fetch(string folderTypeName)
        {
            using (var ctx = ConnectionManager<SqlConnection>.GetManager(Database.DocStoreConnection, false))
            {
                using (var cmd = new SqlCommand("GetFolderTypeList", ctx.Connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@FolderTypeName", folderTypeName).DbType = DbType.String;
                    var args = new DataPortalHookArgs(cmd, folderTypeName);
                    OnFetchPre(args);
                    LoadCollection(cmd);
                    OnFetchPost(args);
                }
            }
        }

        private void LoadCollection(SqlCommand cmd)
        {
            using (var dr = new SafeDataReader(cmd.ExecuteReader()))
            {
                Fetch(dr);
            }
        }

        /// <summary>
        /// Loads all <see cref="FolderTypeList"/> collection items from the given SafeDataReader.
        /// </summary>
        /// <param name="dr">The SafeDataReader to use.</param>
        private void Fetch(SafeDataReader dr)
        {
            IsReadOnly = false;
            var rlce = RaiseListChangedEvents;
            RaiseListChangedEvents = false;
            while (dr.Read())
            {
                Add(FolderTypeInfo.GetFolderTypeInfo(dr));
            }
            RaiseListChangedEvents = rlce;
            IsReadOnly = true;
        }

        #endregion

        #region DataPortal Hooks

        /// <summary>
        /// Occurs after setting query parameters and before the fetch operation.
        /// </summary>
        partial void OnFetchPre(DataPortalHookArgs args);

        /// <summary>
        /// Occurs after the fetch operation (object or collection is fully loaded and set up).
        /// </summary>
        partial void OnFetchPost(DataPortalHookArgs args);

        #endregion

    }
}
