        private readonly string _connectionString;
        
        #region Constructor

        public <%= Info.ObjectName %>Dal(IDalConfig<%= GetDalName(CurrentUnit) %> dalConfig)
        {
            _connectionString = dalConfig.ConnectionString;
        }
        
        #endregion
        
        