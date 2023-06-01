        #region Data Access
<%
if (UseBoth())
{
    %>

#if !SILVERLIGHT
<%
}
if (UseNoSilverlight())
{
    %>
<!-- #include file="CollectionDataPortalCreate.asp" -->
<!-- #include file="CollectionDataPortalFetch.asp" -->
<%
    if (Info.GenerateDataPortalUpdate)
    {
%>

        /// <summary>
        /// Updates in the database all changes made to the <see cref="<%= Info.ObjectName %>"/> object.
        /// </summary>
        [Update]
        <%
        if (Info.TransactionType == TransactionType.EnterpriseServices)
        {
            %>[Transactional(TransactionalTypes.EnterpriseServices)]
        <%
        }
        else if (Info.TransactionType == TransactionType.TransactionScope)
        {
            %>[Transactional(TransactionalTypes.TransactionScope)]
        <%
        }
        if (Info.InsertUpdateRunLocal)
        {
            %>[RunLocal]
        <%
        }
        %>protected void DataPortal_Update()
        {
            base.Child_Update();
        }
<%
    }
}
if (UseNoSilverlight() && CurrentUnit.GenerationParams.SilverlightUsingServices)
{
    %>

#else
<%
}
if (CurrentUnit.GenerationParams.TargetIsCsla40)
{
    %>
<!-- #include file="DataPortalFetchServices.asp" -->
<!-- #include file="DataPortalUpdateServices.asp" -->
<%
}
else
{
    %>
<!-- #include file="DataPortalFetchServices-45.asp" -->
<!-- #include file="DataPortalUpdateServices-45.asp" -->
<%
}
if (UseBoth())
{
    %>

#endif
<%
}
%>

        #endregion
