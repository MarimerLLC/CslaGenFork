<%
if (!Info.UseCustomLoading && !Info.DataSetLoadingScheme)
{
    foreach (Criteria c in Info.CriteriaObjects)
    {
        if (c.GetOptions.DataPortal)
        {
            string strGetInvokeParams = string.Empty;
            string strGetComment = string.Empty;
            bool getIsFirst = true;

            if (usesDTO)
            {
                if (c.Properties.Count == 1)
                    strGetComment = "/// <param name=\"" + FormatCamel(c.Properties[0].Name) + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(c.Properties[0].Name) + ".</param>";
                if (c.Properties.Count > 1)
                    strGetInvokeParams = SendMultipleCriteria(c, "crit", (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives));
            }
            else
            {
                foreach (CriteriaProperty p in c.Properties)
                {
                    if (!getIsFirst)
                    {
                        strGetInvokeParams += ", ";
                    }
                    else
                        getIsFirst = false;

                    strGetInvokeParams += "crit." + FormatPascal(p.Name);
                }
            }
            if (c.Properties.Count > 1)
            {
                if (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives)
                {
                    strGetComment = "/// <param name=\"crit\">The fetch criteria.</param>";
                }
                else
                {
                    foreach (CriteriaProperty p in c.Properties)
                    {
                        if (!getIsFirst)
                        {
                            strGetComment += System.Environment.NewLine + new string(' ', 8);
                        }
                        else
                            getIsFirst = false;
                        strGetComment += "/// <param name=\"" + FormatCamel(p.Name) + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(p.Name) + ".</param>";
                    }
                }
            }
            else if (c.Properties.Count == 1)
            {
                strGetInvokeParams = FormatCamel(c.Properties[0].Name);
                strGetComment = "/// <param name=\"" + FormatCamel(c.Properties[0].Name) + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(c.Properties[0].Name) + ".</param>";
            }
            %>

        /// <summary>
        /// Loads a <see cref="<%= Info.ObjectName %>"/> object from the database<%= c.Properties.Count > 0 ? ", based on given criteria" : "" %>.
        /// </summary>
        <%
            if (c.Properties.Count > 0)
            {
        %><%= strGetComment %>
        <%
            }
            string dataPortalFetch = string.Empty;
            if (isChildNotLazyLoaded)
                dataPortalFetch = "[FetchChild]";
            else
                dataPortalFetch = "[Fetch]";
        %>
        <%= dataPortalFetch %>
        <%
        if (c.GetOptions.RunLocal)
        {
            %>[RunLocal]
    <%
        }
        if (c.Properties.Count > 1)
        {
            if (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives)
            {
    %>protected void Fetch(<%= c.Name %> crit, [Inject] I<%= Info.ObjectName %>Dal dal)<%
            }
            else
            {
    %>protected void Fetch(<%= ReceiveMultipleCriteria(c) %>, [Inject] I<%= Info.ObjectName %>Dal dal)<%
            }
        }
        else if (c.Properties.Count > 0)
        {
    %>protected void Fetch(<%= ReceiveSingleCriteria(c, "crit") %>, [Inject] I<%= Info.ObjectName %>Dal dal)<%
        }
        else
        {
    %>protected void Fetch([Inject] I<%= Info.ObjectName %>Dal dal)<%
        }
        %>
        {
            <%
            if (Info.IsEditableSwitchable())
            {
                %>
            if (crit.IsChild)
                MarkAsChild();
            <%
            }
            string hookArgs = string.Empty;
            if (c.Properties.Count > 1)
            {
                if (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives)
                {
                    hookArgs = "crit";
                }
                else
                {
                    hookArgs = HookMultipleCriteria(c);
                }
            }
            else if (c.Properties.Count > 0)
            {
                hookArgs = HookSingleCriteria(c, "crit");
            }
            %>
            var args = new DataPortalHookArgs(<%= hookArgs %>);
            OnFetchPre(args);
            var data = dal.Fetch(<%= strGetInvokeParams %>);
            Fetch(data);
                <%
            if (ParentLoadsChildren(Info) && usesDTO)
            {
                %>
            FetchChildren(dal);
            <%
            }
                %>
            OnFetchPost(args);
            <%
            if (SelfLoadsChildren(Info))
            {
                %>
            FetchChildren();
        <%
            }
            if (Info.CheckRulesOnFetch && !Info.EditOnDemand && !TypeHelper.IsCollectionType(Info.ObjectType))
            {
                %>
            // check all object rules and property rules
            BusinessRules.CheckRules();
            <%
            }
            %>
        }
        <%
        }
    }
    if (Info.HasGetCriteria && !usesDTO)
    {
        %>

        private void Fetch(IDataReader data)
        {
            using (var dr = new SafeDataReader(data))
            {
                if (dr.Read())
                {
                    Fetch(dr);
                    <%
        if (ParentLoadsChildren(Info))
        {
            %>
                    FetchChildren(dr);
                    <%
        }
        %>
                }
            }
        }
        <%
    }
    %>
<!-- #include file="InternalDataPortalFetch.asp" -->
<%
}
%>
