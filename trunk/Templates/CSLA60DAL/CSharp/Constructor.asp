<%
if (Info.GenerateConstructor)
{
    %>
        #region Constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="<%= Info.GenericNameXml %>"/> class.
        /// </summary>
        /// <remarks> Do not use to create a <%= Info.IsUnitOfWork() ? "Unit of Work" : "Csla object" %>. Use factory methods instead.</remarks>
<%
    if (UseBoth())
    {
        %>
#if SILVERLIGHT
<%
    }
    if (UseSilverlight())
    {
        %>
        [System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Never)]
        public <%= Info.ObjectName %>()
<%
    }
    if (UseBoth()) // check there is a fetch
    {
        %>
#else
<%
    }
    if (UseNoSilverlight())
    {
        string ctorVisibility = GetConstructorVisibility(Info);

        if (ctorVisibility == "public")
        {
            %>
        [System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Never)]
<%
        }
        %>
        <%= ctorVisibility %> <%= Info.ObjectName %>()
<%
    }
    if (UseBoth())
    {
        %>
#endif
<%
    }
    %>
        {
            // Use factory methods and do not use direct creation.
            <%
    if (Info.SupportUpdateProperties || hasFactoryCache || hasDataPortalCache)
    {
        %>
            Saved += On<%= Info.ObjectName %>Saved;
            <%
    }
    if (Info.SupportUpdateProperties && (hasFactoryCache || hasDataPortalCache))
    {
        %>
            <%= Info.ObjectName %>Saved += <%= Info.ObjectName %>SavedHandler;
<%
    }
    if (Info.IsReadOnlyCollection())
    {
        if (Info.UpdaterType != string.Empty)
        {
            CslaObjectInfo childInfo4 = FindChildInfo(Info, Info.ItemType);
            if (childInfo4.UpdateValueProperties.Count > 0)
            {
                %>
            <%= Info.UpdaterType %>Saved.Register(this);
            <%
            }
        }
    }
    if (Info.IsEditableChild() ||
        Info.IsEditableChildCollection())
    {
        %>

            // show the framework that this is a child object
            MarkAsChild();
            <%
    }
    foreach (ChildProperty prop in Info.GetMyChildProperties())
    {
        CslaObjectInfo _child = FindChildInfo(Info, prop.TypeName);
        if (_child == null)
        {
            Warnings.Append("TypeName '" + prop.TypeName + "' doesn't exist in this project." + Environment.NewLine);
        }
    }
    %>
        }

        #endregion
<%
}
%>
