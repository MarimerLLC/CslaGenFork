<%
if (CurrentUnit.GenerationParams.GenerateSynchronous)
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
        /// Factory method. Deletes a <see cref="<%= Info.ObjectName %>"/> object, based on given parameters.
        /// </summary>
        /// <param name="crit">The delete criteria.</param>
        public static <%= Info.ObjectName %> Delete<%= Info.ObjectName %><%= c.GetOptions.FactorySuffix %>(<%= c.Name %> crit, <%= strPortalParam %>)
        {
            <%= strPortalVar %>
            portal.Delete(crit);
        }
        <%
            }
            %>

        /// <summary>
        /// Factory method. Deletes a <see cref="<%= Info.ObjectName %>"/> object, based on given parameters.
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
        <%= Info.ParentType == string.Empty ? "public" : "internal" %> static void Delete<%= Info.ObjectName %><%= c.DeleteOptions.FactorySuffix %>(<%= strDelParams %><%= String.IsNullOrEmpty(strDelParams) ? "" : ", " %><%= strPortalParam %>)
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
                %>portal.Delete(new <%= c.Name %>(<%= strDelCritParams %>));<%
				}
				else
                {
				%>portal.Delete(<%= strDelCritParams %>);<%
				}
            }
            else if (c.Properties.Count > 0)
            {
                %>portal.Delete(<%= SendSingleCriteria(c, strDelCritParams) %>);<%
            }
            else
            {
                %>portal.Delete(new <%= c.Name %>(<%= strDelCritParams %>));<%
            }
            %>
        }
<%
            if (isUndeletable == true)
            {
                %>

        /// <summary>
        /// Factory method. Undeletes a <see cref="<%= Info.ObjectName %>"/> object, based on given parameters.
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
        <%= Info.ParentType == string.Empty ? "public" : "internal" %> static <%= Info.ObjectName %> Undelete<%= Info.ObjectName %><%= c.DeleteOptions.FactorySuffix %>(<%= strDelParams %><%= String.IsNullOrEmpty(strDelParams) ? "" : ", " %><%= strPortalParam %>)
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
                    %>var obj = portal.Fetch(<%= strDelCritParams %>);<%
                }
                else if (c.Properties.Count > 0)
                {
                    %>var obj = portal.Fetch(<%= SendSingleCriteria(c, strDelCritParams) %>);<%
                }
            %>
            obj.<%= softDeleteProperty %> = true;
            return obj.Save();
        }
<%
            }
        }
    }
}
%>
