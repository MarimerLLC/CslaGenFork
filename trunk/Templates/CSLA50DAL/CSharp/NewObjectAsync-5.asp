<%
if (CurrentUnit.GenerationParams.GenerateAsynchronous)
{
    int createCriteriaCount = 0;
    foreach (Criteria c in Info.CriteriaObjects)
    {
        if (c.CreateOptions.Factory)
            createCriteriaCount ++;
    }
    if (createCriteriaCount == 0 &&
        (Info.IsEditableRootCollection() ||
        Info.IsDynamicEditableRootCollection() ||
        Info.IsEditableChildCollection()))
    {
        %>

        /// <summary>
        /// Factory method. Asynchronously creates a new <see cref="<%= Info.ObjectName %>"/> collection.
        /// </summary>
        /// <returns>A reference to the created <see cref="<%= Info.ObjectName %>"/> collection.</returns>
        <%= Info.ParentType == string.Empty ? "public" : "internal" %> async static Task<<%= Info.ObjectName %>> New<%= Info.ObjectName %>Async()
        {
            return await DataPortal.Create<%= isChildNotLazyLoaded ? "Child" : "" %>Async<<%= Info.ObjectName %>>();
        }
        <%
    }
    else
    {
        foreach (Criteria c in Info.CriteriaObjects)
        {
            if (c.CreateOptions.Factory)
            {
                var runLocal = c.CreateOptions.RunLocal;
                string strNewParams = string.Empty;
                string strNewCritParams = string.Empty;
                string strNewComment = string.Empty;
                for (int i = 0; i < c.Properties.Count; i++)
                {
                    if (i > 0)
                    {
                        strNewParams += ", ";
                        strNewCritParams += ", ";
                    }
                    strNewParams += string.Concat(GetDataTypeGeneric(c.Properties[i], c.Properties[i].PropertyType), " ", FormatCamel(c.Properties[i].Name));
                    strNewCritParams += FormatCamel(c.Properties[i].Name);
                    strNewComment += "/// <param name=\"" + FormatCamel(c.Properties[i].Name) + "\">The " + FormatProperty(c.Properties[i].Name) + " of the " + Info.ObjectName + " to create.</param>" + System.Environment.NewLine + new string(' ', 8);
                }
                if (!isChild && !c.NestedClass && c.Properties.Count > 1 && Info.IsNotEditableSwitchable())
                {
                    %>

        /// <summary>
        /// Factory method. Asynchronously creates a new <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %>, based on given parameters.
        /// </summary>
        /// <param name="crit">The create criteria.</param>
        /// <returns>A reference to the created <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %>.</returns>
        public async static Task<<%= Info.ObjectName %>> New<%= Info.ObjectName %><%= c.CreateOptions.FactorySuffix %>Async(<%= c.Name %> crit)
        {
            return await DataPortal.CreateAsync<<%= Info.ObjectName %>>(crit);
        }
        <%
                }
                %>

        /// <summary>
        /// Factory method. Asynchronously creates a new <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %><%= c.Properties.Count > 0 ? ", based on given parameters" : "" %>.
        /// </summary>
        <%= strNewComment %>/// <returns>A reference to the created <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %>.</returns>
        <%= Info.ParentType == string.Empty ? "public" : "internal" %> async static Task<<%= Info.ObjectName %>> New<%= Info.ObjectName %><%= c.CreateOptions.FactorySuffix %>Async(<%= strNewParams %>)
        {
            <%
                if (Info.IsEditableSwitchable())
                {
                    if (strNewCritParams.Length > 0)
                    {
                        strNewCritParams = "false, " + strNewCritParams;
                    }
                    else
                    {
                        strNewCritParams = "false" ;
                    }
                }
                if (c.Properties.Count > 1)
                {
                    %>
            return await DataPortal.Create<%= (isChildNotLazyLoaded && runLocal) ? "Child" : "" %>Async<<%= Info.ObjectName %>>(new <%= c.Name %>(<%= strNewCritParams %>));
                <%
                }
                else if (c.Properties.Count > 0)
                {
                    %>
            return await DataPortal.Create<%= (isChildNotLazyLoaded && runLocal) ? "Child" : "" %>Async<<%= Info.ObjectName %>>(<%= SendSingleCriteria(c, strNewCritParams) %>);
                    <%
                }
                else
                {
                    %>
            return await DataPortal.Create<%= (isChildNotLazyLoaded && runLocal) ? "Child" : "" %>Async<<%= Info.ObjectName %>>();
                    <%
                }
                %>
        }
        <%
            }
        }
    }
}
%>
