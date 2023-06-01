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
}
if (UseBoth())
{
    %>

#endif
<%
}
%>

        #endregion
