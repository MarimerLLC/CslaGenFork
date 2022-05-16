<% System.Collections.Generic.List<string> hookList = GetHookList(Info);
if (hookList.Count > 0 && UseNoSilverlight())
{
    %>
        #region Dal Hooks
<%
    if (UseBoth() && !HasSilverlightLocalDataPortalCreate(Info))
    {
        %>

#if !SILVERLIGHT
<%
    }
    foreach (string hookName in hookList)
    {
    %>

        /// <summary>
        /// Occurs <%= FormatHookDocumentation(hookName) %>
        /// </summary>
        partial void On<%= hookName %>(DalHookArgs args);
        <%
        if (hookName == "Create" && HasSilverlightLocalDataPortalCreate(Info))
        {
            %>

#if !SILVERLIGHT
        <%
        }
    }
    if (UseBoth())
    {
        %>

#endif
<%
    }
%>

        #endregion

<%
}
%>
