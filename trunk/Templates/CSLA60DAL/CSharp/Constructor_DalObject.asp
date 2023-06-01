<%
if (Info.PersistenceType == PersistenceType.DISqlConnection)
{
%>
        private <%= GetDalName(CurrentUnit) %>Db DalDb { get; set; }
        
        #region Constructor

        public <%= Info.ObjectName %>Dal(<%= GetDalName(CurrentUnit) %>Db dalDb)
        {
            DalDb = dalDb;
        }
        
        #endregion
<%
}
else
{
%>
        private readonly string _connectionString;
                
        #region Constructor

        public <%= Info.ObjectName %>Dal(IDalConfig<%= GetDalName(CurrentUnit) %> dalConfig)
        {
            _connectionString = dalConfig.ConnectionString;
        }

        #endregion
<%
}       
%>      