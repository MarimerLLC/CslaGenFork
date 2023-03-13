<%
if (CurrentUnit.GenerationParams.GenerateSynchronous)
{
    if (!Info.UseCustomLoading)
    {
        foreach (Criteria c in Info.CriteriaObjects)
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

            if (Info.IsUnitOfWork() && Info.IsCreatorGetter && c.Properties.Count == 0)
                continue;
            if (c.GetOptions.Factory)
            {
                if (!isChild && !c.NestedClass && c.Properties.Count > 1 && c.CriteriaClassMode != CriteriaMode.MultiplePrimatives && Info.IsNotEditableSwitchable())
                {
                    %>

        /// <summary>
        /// Factory method. Loads a <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %>, based on given parameters.
        /// </summary>
        /// <param name="crit">The fetch criteria.</param>
        /// <returns>A reference to the fetched <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %>.</returns>
        public static <%= Info.ObjectName %> Get<%= Info.ObjectName %><%= c.GetOptions.FactorySuffix %>(<%= c.Name %> crit, <%= strPortalParam %>)
        {
            <%= strPortalVar %>
            return portal.Fetch(crit);
        }
        <%
                }
                %>

        /// <summary>
        /// Factory method. Loads a <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %><%= c.Properties.Count > 0 ? ", based on given parameters" : "" %>.
        /// </summary>
        <%
                string strGetParams = string.Empty;
                string strGetCritParams = string.Empty;
                bool firstParam = true;
                for (int i = 0; i < c.Properties.Count; i++)
                {
                    if (string.IsNullOrEmpty(c.Properties[i].ParameterValue))
                    {
                        %>
        /// <param name="<%= FormatCamel(c.Properties[i].Name) %>">The <%= FormatProperty(c.Properties[i].Name) %> parameter of the <%= Info.ObjectName %> to fetch.</param>
        <%
                        if (firstParam)
                        {
                            firstParam = false;
                        }
                        else
                        {
                            strGetParams += ", ";
                            strGetCritParams += ", ";
                        }
                        strGetParams += string.Concat(GetDataTypeGeneric(c.Properties[i], c.Properties[i].PropertyType), " ", FormatCamel(c.Properties[i].Name));
                        strGetCritParams += FormatCamel(c.Properties[i].Name);
                    }
                    else
                    {
                        if (!isCriteriaClassNeeded || c.CriteriaClassMode == CriteriaMode.MultiplePrimatives)
						{
							if (firstParam)
							{
								firstParam = false;
							}
							else
							{
								strGetCritParams += ", ";
							}
							strGetCritParams += c.Properties[i].ParameterValue;
						}
                            
                    }
                }
            %>
        /// <returns>A reference to the fetched <see cref="<%= Info.ObjectName %>"/> <%= TypeHelper.IsCollectionType(Info.ObjectType) ? "collection" : "object" %>.</returns>
        <%= Info.ParentType == string.Empty ? "public" : "internal" %> static <%= Info.ObjectName %> Get<%= Info.ObjectName %><%= c.GetOptions.FactorySuffix %>(<%= strGetParams %><%= String.IsNullOrEmpty(strGetParams) ? "" : ", " %><%= strPortalParam %>)
        {
            <%= strPortalVar %>
            <%
                if (Info.IsEditableSwitchable())
                {
                    strGetCritParams = "false, " + strGetCritParams;
                }
                if (c.Properties.Count > 1 || (Info.IsEditableSwitchable() && c.Properties.Count == 1))
                {
                    if (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives)
                    {%>
            return portal.Fetch<%= isChildNotLazyLoaded ? "Child" : "" %>(new <%= c.Name %>(<%= strGetCritParams %>));
            <%
                    }
                    else
                    {%>
            return portal.Fetch<%= isChildNotLazyLoaded ? "Child" : "" %>(<%= strGetCritParams %>);
            <%
                    }      
                }
                else if (c.Properties.Count > 0)
                {
                    %>
            return portal.Fetch<%= isChildNotLazyLoaded ? "Child" : "" %>(<%= SendSingleCriteria(c, strGetCritParams) %>);
            <%
                }
                else
                {
                    if (Info.SimpleCacheOptions != SimpleCacheResults.None)
                    {
                        %>
            if (_list == null)
                _list = portal.Fetch<%= isChildNotLazyLoaded ? "Child" : "" %>();

            return _list;
            <%
                    }
                    else
                    {
                        %>
            return portal.Fetch<%= isChildNotLazyLoaded ? "Child" : "" %>();
        <%
                    }
                }
                %>
        }
<%
            }
        }
    }
}
%>
