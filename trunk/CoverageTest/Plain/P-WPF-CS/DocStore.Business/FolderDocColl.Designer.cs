//  This file was generated by CSLA Object Generator - CslaGenFork v4.5
//
// Filename:    FolderDocColl
// ObjectType:  FolderDocColl
// CSLAType:    EditableChildCollection

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
    /// Collection of documents archived in this folder (editable child list).<br/>
    /// This is a generated base class of <see cref="FolderDocColl"/> business object.
    /// </summary>
    /// <remarks>
    /// This class is child of <see cref="Folder"/> editable root object.<br/>
    /// The items of the collection are <see cref="FolderDoc"/> objects.
    /// </remarks>
    [Serializable]
    public partial class FolderDocColl : BusinessListBase<FolderDocColl, FolderDoc>
    {

        #region Collection Business Methods

        /// <summary>
        /// Adds a new <see cref="FolderDoc"/> item to the collection.
        /// </summary>
        /// <param name="item">The item to add.</param>
        /// <exception cref="System.Security.SecurityException">if the user isn't authorized to add items to the collection.</exception>
        /// <exception cref="ArgumentException">if the item already exists in the collection.</exception>
        public new void Add(FolderDoc item)
        {
            if (!CanAddObject())
                throw new System.Security.SecurityException("User not authorized to create a FolderDoc.");

            if (Contains(item.DocID))
                throw new ArgumentException("FolderDoc already exists.");

            base.Add(item);
        }

        /// <summary>
        /// Removes a <see cref="FolderDoc"/> item from the collection.
        /// </summary>
        /// <param name="item">The item to remove.</param>
        /// <returns><c>true</c> if the item was removed from the collection, otherwise <c>false</c>.</returns>
        /// <exception cref="System.Security.SecurityException">if the user isn't authorized to remove items from the collection.</exception>
        public new bool Remove(FolderDoc item)
        {
            if (!CanDeleteObject())
                throw new System.Security.SecurityException("User not authorized to remove a FolderDoc.");

            return base.Remove(item);
        }

        /// <summary>
        /// Adds a new <see cref="FolderDoc"/> item to the collection.
        /// </summary>
        /// <param name="docID">The DocID of the object to be added.</param>
        /// <returns>The new FolderDoc item added to the collection.</returns>
        public FolderDoc Add(int docID)
        {
            var item = FolderDoc.NewFolderDoc(docID);
            Add(item);
            return item;
        }

        /// <summary>
        /// Asynchronously adds a new <see cref="FolderDoc"/> item to the collection.
        /// </summary>
        /// <param name="docID">The DocID of the object to be added.</param>
        public void BeginAdd(int docID)
        {
            FolderDoc folderDoc = null;
            FolderDoc.NewFolderDoc(docID, (o, e) =>
                {
                    if (e.Error != null)
                        throw e.Error;
                    else
                        folderDoc = e.Object;
                });
            Add(folderDoc);
        }

        /// <summary>
        /// Removes a <see cref="FolderDoc"/> item from the collection.
        /// </summary>
        /// <param name="docID">The DocID of the item to be removed.</param>
        public void Remove(int docID)
        {
            foreach (var folderDoc in this)
            {
                if (folderDoc.DocID == docID)
                {
                    Remove(folderDoc);
                    break;
                }
            }
        }

        /// <summary>
        /// Determines whether a <see cref="FolderDoc"/> item is in the collection.
        /// </summary>
        /// <param name="docID">The DocID of the item to search for.</param>
        /// <returns><c>true</c> if the FolderDoc is a collection item; otherwise, <c>false</c>.</returns>
        public bool Contains(int docID)
        {
            foreach (var folderDoc in this)
            {
                if (folderDoc.DocID == docID)
                {
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Determines whether a <see cref="FolderDoc"/> item is in the collection's DeletedList.
        /// </summary>
        /// <param name="docID">The DocID of the item to search for.</param>
        /// <returns><c>true</c> if the FolderDoc is a deleted collection item; otherwise, <c>false</c>.</returns>
        public bool ContainsDeleted(int docID)
        {
            foreach (var folderDoc in DeletedList)
            {
                if (folderDoc.DocID == docID)
                {
                    return true;
                }
            }
            return false;
        }

        #endregion

        #region Find Methods

        /// <summary>
        /// Finds a <see cref="FolderDoc"/> item of the <see cref="FolderDocColl"/> collection, based on a given DocID.
        /// </summary>
        /// <param name="docID">The DocID.</param>
        /// <returns>A <see cref="FolderDoc"/> object.</returns>
        public FolderDoc FindFolderDocByDocID(int docID)
        {
            for (var i = 0; i < this.Count; i++)
            {
                if (this[i].DocID.Equals(docID))
                {
                    return this[i];
                }
            }

            return null;
        }

        #endregion

        #region Factory Methods

        /// <summary>
        /// Factory method. Creates a new <see cref="FolderDocColl"/> collection.
        /// </summary>
        /// <returns>A reference to the created <see cref="FolderDocColl"/> collection.</returns>
        internal static FolderDocColl NewFolderDocColl()
        {
            return DataPortal.Create<FolderDocColl>();
        }

        /// <summary>
        /// Factory method. Loads a <see cref="FolderDocColl"/> collection, based on given parameters.
        /// </summary>
        /// <param name="folderID">The FolderID parameter of the FolderDocColl to fetch.</param>
        /// <returns>A reference to the fetched <see cref="FolderDocColl"/> collection.</returns>
        internal static FolderDocColl GetFolderDocColl(int folderID)
        {
            return DataPortal.Fetch<FolderDocColl>(folderID);
        }

        /// <summary>
        /// Factory method. Asynchronously creates a new <see cref="FolderDocColl"/> collection.
        /// </summary>
        /// <param name="callback">The completion callback method.</param>
        internal static void NewFolderDocColl(EventHandler<DataPortalResult<FolderDocColl>> callback)
        {
            DataPortal.BeginCreate<FolderDocColl>(callback);
        }

        /// <summary>
        /// Factory method. Asynchronously loads a <see cref="FolderDocColl"/> collection, based on given parameters.
        /// </summary>
        /// <param name="folderID">The FolderID parameter of the FolderDocColl to fetch.</param>
        /// <param name="callback">The completion callback method.</param>
        internal static void GetFolderDocColl(int folderID, EventHandler<DataPortalResult<FolderDocColl>> callback)
        {
            DataPortal.BeginFetch<FolderDocColl>(folderID, callback);
        }

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="FolderDocColl"/> class.
        /// </summary>
        /// <remarks> Do not use to create a Csla object. Use factory methods instead.</remarks>
        [System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Never)]
        public FolderDocColl()
        {
            // Use factory methods and do not use direct creation.

            // show the framework that this is a child object
            MarkAsChild();

            var rlce = RaiseListChangedEvents;
            RaiseListChangedEvents = false;
            AllowNew = FolderDocColl.CanAddObject();
            AllowEdit = FolderDocColl.CanEditObject();
            AllowRemove = FolderDocColl.CanDeleteObject();
            RaiseListChangedEvents = rlce;
        }

        #endregion

        #region Object Authorization

        /// <summary>
        /// Adds the object authorization rules.
        /// </summary>
        protected static void AddObjectAuthorizationRules()
        {
            BusinessRules.AddRule(typeof (FolderDocColl), new IsInRole(AuthorizationActions.CreateObject, "Archivist"));
            BusinessRules.AddRule(typeof (FolderDocColl), new IsInRole(AuthorizationActions.GetObject, "User"));
            BusinessRules.AddRule(typeof (FolderDocColl), new IsInRole(AuthorizationActions.EditObject, "Author"));
            BusinessRules.AddRule(typeof (FolderDocColl), new IsInRole(AuthorizationActions.DeleteObject, "Admin", "Manager"));

            AddObjectAuthorizationRulesExtend();
        }

        /// <summary>
        /// Allows the set up of custom object authorization rules.
        /// </summary>
        static partial void AddObjectAuthorizationRulesExtend();

        /// <summary>
        /// Checks if the current user can create a new FolderDocColl object.
        /// </summary>
        /// <returns><c>true</c> if the user can create a new object; otherwise, <c>false</c>.</returns>
        public static bool CanAddObject()
        {
            return BusinessRules.HasPermission(Csla.Rules.AuthorizationActions.CreateObject, typeof(FolderDocColl));
        }

        /// <summary>
        /// Checks if the current user can retrieve FolderDocColl's properties.
        /// </summary>
        /// <returns><c>true</c> if the user can read the object; otherwise, <c>false</c>.</returns>
        public static bool CanGetObject()
        {
            return BusinessRules.HasPermission(Csla.Rules.AuthorizationActions.GetObject, typeof(FolderDocColl));
        }

        /// <summary>
        /// Checks if the current user can change FolderDocColl's properties.
        /// </summary>
        /// <returns><c>true</c> if the user can update the object; otherwise, <c>false</c>.</returns>
        public static bool CanEditObject()
        {
            return BusinessRules.HasPermission(Csla.Rules.AuthorizationActions.EditObject, typeof(FolderDocColl));
        }

        /// <summary>
        /// Checks if the current user can delete a FolderDocColl object.
        /// </summary>
        /// <returns><c>true</c> if the user can delete the object; otherwise, <c>false</c>.</returns>
        public static bool CanDeleteObject()
        {
            return BusinessRules.HasPermission(Csla.Rules.AuthorizationActions.DeleteObject, typeof(FolderDocColl));
        }

        #endregion

        #region Data Access

        /// <summary>
        /// Loads a <see cref="FolderDocColl"/> collection from the database, based on given criteria.
        /// </summary>
        /// <param name="folderID">The Folder ID.</param>
        protected void DataPortal_Fetch(int folderID)
        {
            using (var ctx = ConnectionManager<SqlConnection>.GetManager(Database.DocStoreConnection, false))
            {
                using (var cmd = new SqlCommand("GetFolderDocColl", ctx.Connection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@FolderID", folderID).DbType = DbType.Int32;
                    var args = new DataPortalHookArgs(cmd, folderID);
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
        /// Loads all <see cref="FolderDocColl"/> collection items from the given SafeDataReader.
        /// </summary>
        /// <param name="dr">The SafeDataReader to use.</param>
        private void Fetch(SafeDataReader dr)
        {
            var rlce = RaiseListChangedEvents;
            RaiseListChangedEvents = false;
            while (dr.Read())
            {
                Add(FolderDoc.GetFolderDoc(dr));
            }
            RaiseListChangedEvents = rlce;
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
