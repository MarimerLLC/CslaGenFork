<%
if (CurrentUnit.GenerationParams.GenerateAsynchronous)
{
    foreach (Criteria c in Info.CriteriaObjects)
    {
        if (c.DeleteOptions.Factory)
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

            if (!isChild && !c.NestedClass && c.Properties.Count > 1 && c.CriteriaClassMode != CriteriaMode.MultiplePrimatives && Info.IsNotEditableSwitchable())
            {
                %>

        /// <summary>
        /// Factory method. Asynchronously deletes a <see cref="<%= Info.ObjectName %>"/> object, based on given parameters.
        /// </summary>
        /// <param name="crit">The delete criteria.</param>
        public async static Task<<%= Info.ObjectName %>> Delete<%= Info.ObjectName %><%= c.GetOptions.FactorySuffix %>Async(<%= c.Name %> crit, <%= strPortalParam %>)
        {
            <%= strPortalVar %>
            await portal.DeleteAsync(crit);
        }
        <%
            }
            %>

        /// <summary>
        /// Factory method. Asynchronously deletes a <see cref="<%= Info.ObjectName %>"/> object, based on given parameters.
        /// </summary>
<%
            string strDelParams = string.Empty;
            string strDelCritParams = string.Empty;
			bool firstParam = true;
            for (int i = 0; i < c.Properties.Count; i++)
            {
				if (string.IsNullOrEmpty(c.Properties[i].ParameterValue))
                {
                %>
        /// <param name="<%= FormatCamel(c.Properties[i].Name) %>">The <%= FormatProperty(c.Properties[i].Name) %> of the <%= Info.ObjectName %> to delete.</param>
        <%
					if (firstParam)
					{
						firstParam = false;
					}
					else
					{
						strDelParams += ", ";
						strDelCritParams += ", ";
					}
					strDelParams += string.Concat(GetDataTypeGeneric(c.Properties[i], c.Properties[i].PropertyType), " ", FormatCamel(c.Properties[i].Name));
					strDelCritParams += FormatCamel(c.Properties[i].Name);
				}
				else
				{
					if (!isCriteriaClassNeeded)
					{
						if (firstParam)
						{
							firstParam = false;
						}
						else
						{
							strDelCritParams += ", ";
						}
						strDelCritParams += c.Properties[i].ParameterValue;
					}
						
				}
            }
            %>
        <%= Info.ParentType == string.Empty ? "public" : "internal" %> async static Task Delete<%= Info.ObjectName %><%= c.DeleteOptions.FactorySuffix %>Async(<%= strDelParams %><%= String.IsNullOrEmpty(strDelParams) ? "" : ", " %><%= strPortalParam %>)
        {
            <%= strPortalVar %>
            <%
            if (Info.IsEditableSwitchable())
            {
                if (!strDelCritParams.Equals(String.Empty))
                {
                    strDelCritParams = ", " + strDelCritParams;
                }
                strDelCritParams = "false" + strDelCritParams;
            }
            if (c.Properties.Count > 1)
            {
				if (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives)
                {
                %>await portal.DeleteAsync(new <%= c.Name %>(<%= strDelCritParams %>));<%
				}
				else
                {
				%>await portal.DeleteAsync(<%= strDelCritParams %>);<%
				}
            }
            else if (c.Properties.Count > 0)
            {
                %>await portal.DeleteAsync(<%= SendSingleCriteria(c, strDelCritParams) %>);<%
            }
            else
            {
                %>await portal.DeleteAsync(new <%= c.Name %>(<%= strDelCritParams %>));<%
            }
            %>
        }
<%
            if (isUndeletable == true)
            {
                %>

        /// <summary>
        /// Factory method. Asynchronoushly undeletes a <see cref="<%= Info.ObjectName %>"/> object, based on given parameters.
        /// </summary>
<%
                strDelParams = string.Empty;
                strDelCritParams = string.Empty;
                for (int i = 0; i < c.Properties.Count; i++)
                {
                    %>
        /// <param name="<%= FormatCamel(c.Properties[i].Name) %>">The <%= FormatProperty(c.Properties[i].Name) %> of the <%= Info.ObjectName %> to undelete.</param>
        <%
                    if (i > 0)
                    {
                        strDelParams += ", ";
                        strDelCritParams += ", ";
                    }
                    strDelParams += string.Concat(GetDataTypeGeneric(c.Properties[i], c.Properties[i].PropertyType), " ", FormatCamel(c.Properties[i].Name));
                    strDelCritParams += FormatCamel(c.Properties[i].Name);
                }
                %>
        /// <returns>A reference to the undeleted <see cref="<%= Info.ObjectName %>"/> object.</returns>
        <%= Info.ParentType == string.Empty ? "public" : "internal" %> async static Task<<%= Info.ObjectName %>> Undelete<%= Info.ObjectName %><%= c.DeleteOptions.FactorySuffix %>Async(<%= strDelParams %><%= String.IsNullOrEmpty(strDelParams) ? "" : ", " %><%= strPortalParam %>)
        {
            <%= strPortalVar %>
            <%
                if (Info.IsEditableSwitchable())
                {
                    if (!strDelCritParams.Equals(String.Empty))
                    {
                        strDelCritParams = ", " + strDelCritParams;
                    }
                    strDelCritParams = "false" + strDelCritParams;
                }
                if (c.Properties.Count > 1)
                {
                    %>var obj = await portal.FetchAsync(<%= strDelCritParams %>);<%
                }
                else if (c.Properties.Count > 0)
                {
                    %>var obj = await portal.FetchAsync(<%= SendSingleCriteria(c, strDelCritParams) %>);<%
                }
            %>
            obj.<%= softDeleteProperty %> = true;
            return obj.SaveAsync();
        }
<%
            }
        }
    }
}
%>
