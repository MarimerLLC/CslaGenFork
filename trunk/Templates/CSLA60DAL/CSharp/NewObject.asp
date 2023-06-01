<%
if (CurrentUnit.GenerationParams.GenerateSynchronous)
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
        /// Factory method. Creates a new <see cref="<%= Info.ObjectName %>"/> collection.
        /// </summary>
        /// <returns>A reference to the created <see cref="<%= Info.ObjectName %>"/> collection.</returns>
        <%= Info.ParentType == string.Empty ? "public" : "internal" %> static <%= Info.ObjectName %> New<%= Info.ObjectName %>(I<%= isChildNotLazyLoaded ? "Child" : "" %>DataPortalFactory factory)
        {
            return factory.GetPortal<<%= Info.ObjectName %>>().Create<%= isChildNotLazyLoaded ? "Child" : "" %>();
        }
        <%
    }
    else
    {
        foreach (Criteria c in Info.CriteriaObjects)
        {
            if (c.CreateOptions.Factory)
            {
                string strPortalParam = string.Empty;
                string strPortalVar = string.Empty;
                if (c.DataPortalGenerationParameter == CriteriaDataPortalGenerationParameter.ApplicationContext)
                {
                    strPortalParam = "ApplicationContext appContext";
                    strPortalVar = string.Format("var portal = appContext.GetRequiredService<I{0}DataPortal<{1}>>();", isChildNotLazyLoaded ? "Child" : "", Info.ObjectName);
                }
                else if (c.DataPortalGenerationParameter == CriteriaDataPortalGenerationParameter.DataPortalFactory)
                {
                    strPortalParam = string.Format("I{0}DataPortalFactory factory", isChildNotLazyLoaded ? "Child" : "");
                    strPortalVar = string.Format("var portal = factory.GetPortal<{0}>();", Info.ObjectName);
                }
                else
                {
                    strPortalParam = string.Format("I{0}DataPortal<{1}> portal", isChildNotLazyLoaded ? "Child" : "", Info.ObjectName);
                }

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
                if (!isChild && !c.NestedClass && c.Properties.Count > 1 && c.CriteriaClassMode != CriteriaMode.MultiplePrimatives && Info.IsNotEditableSwitchable())
                {
                    %>

        /// <summary>
        /// Factory method. Creates a new <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %>, based on given parameters.
        /// </summary>
        /// <param name="crit">The create criteria.</param>
        /// <returns>A reference to the created <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %>.</returns>
        public static <%= Info.ObjectName %> New<%= Info.ObjectName %><%= c.CreateOptions.FactorySuffix %>(<%= c.Name %> crit, <%= strPortalParam %>)
        {
            <%= strPortalVar %>
            return portal.Create(crit);
        }
        <%
                }
                %>

        /// <summary>
        /// Factory method. Creates a new <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %><%= c.Properties.Count > 0 ? ", based on given parameters" : "" %>.
        /// </summary>
        <%= strNewComment %>/// <returns>A reference to the created <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %>.</returns>
        <%= Info.ParentType == string.Empty ? "public" : "internal" %> static <%= Info.ObjectName %> New<%= Info.ObjectName %><%= c.CreateOptions.FactorySuffix %>(<%= strNewParams %><%= String.IsNullOrEmpty(strNewParams) ? "" : ", " %><%= strPortalParam %>)
        {
            <%= strPortalVar %>
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
                    if (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives)
                    {%>
            return portal.Create<%= (isChildNotLazyLoaded && runLocal) ? "Child" : "" %>(new <%= c.Name %>(<%= strNewCritParams %>));
                <%
                    }
                    else
                    {%>
            return portal.Create<%= (isChildNotLazyLoaded && runLocal) ? "Child" : "" %>(<%= strNewCritParams %>);
            <%
                    }
                }
                else if (c.Properties.Count > 0)
                {
                    %>
            return portal.Create<%= (isChildNotLazyLoaded && runLocal) ? "Child" : "" %>(<%= SendSingleCriteria(c, strNewCritParams) %>);
                    <%
                }
                else
                {
                    %>
            return portal.Create<%= (isChildNotLazyLoaded && runLocal) ? "Child" : "" %>();
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
