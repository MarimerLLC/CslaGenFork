using System;
using System.Data;
using Csla;
using Csla.Data;
using SelfLoadRO.DataAccess;
using SelfLoadRO.DataAccess.ERLevel;

namespace SelfLoadRO.Business.ERLevel
{

    /// <summary>
    /// C02_Continent (read only object).<br/>
    /// This is a generated base class of <see cref="C02_Continent"/> business object.
    /// This class is a root object.
    /// </summary>
    /// <remarks>
    /// This class contains one child collection:<br/>
    /// - <see cref="C03_SubContinentObjects"/> of type <see cref="C03_SubContinentColl"/> (1:M relation to <see cref="C04_SubContinent"/>)
    /// </remarks>
    [Serializable]
    public partial class C02_Continent : ReadOnlyBase<C02_Continent>
    {

        #region Business Properties

        /// <summary>
        /// Maintains metadata about <see cref="Continent_ID"/> property.
        /// </summary>
        public static readonly PropertyInfo<int> Continent_IDProperty = RegisterProperty<int>(p => p.Continent_ID, "Continents ID", -1);
        /// <summary>
        /// Gets the Continents ID.
        /// </summary>
        /// <value>The Continents ID.</value>
        public int Continent_ID
        {
            get { return GetProperty(Continent_IDProperty); }
        }

        /// <summary>
        /// Maintains metadata about <see cref="Continent_Name"/> property.
        /// </summary>
        public static readonly PropertyInfo<string> Continent_NameProperty = RegisterProperty<string>(p => p.Continent_Name, "Continents Name");
        /// <summary>
        /// Gets the Continents Name.
        /// </summary>
        /// <value>The Continents Name.</value>
        public string Continent_Name
        {
            get { return GetProperty(Continent_NameProperty); }
        }

        /// <summary>
        /// Maintains metadata about child <see cref="C03_Continent_SingleObject"/> property.
        /// </summary>
        public static readonly PropertyInfo<C03_Continent_Child> C03_Continent_SingleObjectProperty = RegisterProperty<C03_Continent_Child>(p => p.C03_Continent_SingleObject, "C03 Continent Single Object");
        /// <summary>
        /// Gets the C03 Continent Single Object ("self load" child property).
        /// </summary>
        /// <value>The C03 Continent Single Object.</value>
        public C03_Continent_Child C03_Continent_SingleObject
        {
            get { return GetProperty(C03_Continent_SingleObjectProperty); }
            private set { LoadProperty(C03_Continent_SingleObjectProperty, value); }
        }

        /// <summary>
        /// Maintains metadata about child <see cref="C03_Continent_ASingleObject"/> property.
        /// </summary>
        public static readonly PropertyInfo<C03_Continent_ReChild> C03_Continent_ASingleObjectProperty = RegisterProperty<C03_Continent_ReChild>(p => p.C03_Continent_ASingleObject, "C03 Continent ASingle Object");
        /// <summary>
        /// Gets the C03 Continent ASingle Object ("self load" child property).
        /// </summary>
        /// <value>The C03 Continent ASingle Object.</value>
        public C03_Continent_ReChild C03_Continent_ASingleObject
        {
            get { return GetProperty(C03_Continent_ASingleObjectProperty); }
            private set { LoadProperty(C03_Continent_ASingleObjectProperty, value); }
        }

        /// <summary>
        /// Maintains metadata about child <see cref="C03_SubContinentObjects"/> property.
        /// </summary>
        public static readonly PropertyInfo<C03_SubContinentColl> C03_SubContinentObjectsProperty = RegisterProperty<C03_SubContinentColl>(p => p.C03_SubContinentObjects, "C03 SubContinent Objects");
        /// <summary>
        /// Gets the C03 Sub Continent Objects ("self load" child property).
        /// </summary>
        /// <value>The C03 Sub Continent Objects.</value>
        public C03_SubContinentColl C03_SubContinentObjects
        {
            get { return GetProperty(C03_SubContinentObjectsProperty); }
            private set { LoadProperty(C03_SubContinentObjectsProperty, value); }
        }

        #endregion

        #region Factory Methods

        /// <summary>
        /// Factory method. Loads a <see cref="C02_Continent"/> object, based on given parameters.
        /// </summary>
        /// <param name="continent_ID">The Continent_ID parameter of the C02_Continent to fetch.</param>
        /// <returns>A reference to the fetched <see cref="C02_Continent"/> object.</returns>
        public static C02_Continent GetC02_Continent(int continent_ID)
        {
            return DataPortal.Fetch<C02_Continent>(continent_ID);
        }

        #endregion

        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="C02_Continent"/> class.
        /// </summary>
        /// <remarks> Do not use to create a Csla object. Use factory methods instead.</remarks>
        [System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Never)]
        public C02_Continent()
        {
            // Use factory methods and do not use direct creation.
        }

        #endregion

        #region Data Access

        /// <summary>
        /// Loads a <see cref="C02_Continent"/> object from the database, based on given criteria.
        /// </summary>
        /// <param name="continent_ID">The Continent ID.</param>
        protected void DataPortal_Fetch(int continent_ID)
        {
            var args = new DataPortalHookArgs(continent_ID);
            OnFetchPre(args);
            using (var dalManager = DalFactorySelfLoadRO.GetManager())
            {
                var dal = dalManager.GetProvider<IC02_ContinentDal>();
                var data = dal.Fetch(continent_ID);
                Fetch(data);
            }
            OnFetchPost(args);
            FetchChildren();
            // check all object rules and property rules
            BusinessRules.CheckRules();
        }

        private void Fetch(IDataReader data)
        {
            using (var dr = new SafeDataReader(data))
            {
                if (dr.Read())
                {
                    Fetch(dr);
                }
            }
        }

        /// <summary>
        /// Loads a <see cref="C02_Continent"/> object from the given SafeDataReader.
        /// </summary>
        /// <param name="dr">The SafeDataReader to use.</param>
        private void Fetch(SafeDataReader dr)
        {
            // Value properties
            LoadProperty(Continent_IDProperty, dr.GetInt32("Continent_ID"));
            LoadProperty(Continent_NameProperty, dr.GetString("Continent_Name"));
            var args = new DataPortalHookArgs(dr);
            OnFetchRead(args);
        }

        /// <summary>
        /// Loads child objects.
        /// </summary>
        private void FetchChildren()
        {
            LoadProperty(C03_Continent_SingleObjectProperty, C03_Continent_Child.GetC03_Continent_Child(Continent_ID));
            LoadProperty(C03_Continent_ASingleObjectProperty, C03_Continent_ReChild.GetC03_Continent_ReChild(Continent_ID));
            LoadProperty(C03_SubContinentObjectsProperty, C03_SubContinentColl.GetC03_SubContinentColl(Continent_ID));
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

        /// <summary>
        /// Occurs after the low level fetch operation, before the data reader is destroyed.
        /// </summary>
        partial void OnFetchRead(DataPortalHookArgs args);

        #endregion

    }
}
