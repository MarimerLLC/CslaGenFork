<%
foreach (Criteria c in Info.CriteriaObjects)
{
    if (c.CreateOptions.DataPortal)
    {
        string dataPortalCreate = string.Empty;
        string strGetComment = string.Empty;
        bool getIsFirst = true;
        if (isChildNotLazyLoaded && c.CreateOptions.RunLocal)
            dataPortalCreate = "[CreateChild]";
        else
            dataPortalCreate = "[Create]";
        %>

        /// <summary>
        /// Loads default values for the <see cref="<%= Info.ObjectName %>"/> object properties<%= c.Properties.Count > 0 ? ", based on given criteria" : "" %>.
        /// </summary>
        <%
        if (c.Properties.Count > 1)
        {
            if (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives)
            {
                strGetComment = "/// <param name=\"crit\">The create criteria.</param>";
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
            strGetComment = "/// <param name=\"" + FormatCamel(c.Properties[0].Name) + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(c.Properties[0].Name) + ".</param>";
        }
            %><%= strGetComment %>
        <%= dataPortalCreate %>
        <%
        if (c.CreateOptions.RunLocal)
        {
            %>
        [RunLocal]
        <%
        }
        if (c.Properties.Count > 1)
        {
            if (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives)
            {
            %>protected void Create(<%= c.Name %> crit)<%
            }
            else
            {
            %>protected void Create(<%= ReceiveMultipleCriteria(c) %>)<%
            }
        }
        else if (c.Properties.Count > 0)
        {
            %>protected void Create(<%= ReceiveSingleCriteria(c, "crit") %>)<%
        }
        else
        {
            %>protected void Create()<%
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
        foreach (ValueProperty prop in Info.ValueProperties)
        {
            if (prop.DefaultValue != String.Empty)
            {
                if (prop.DefaultValue.ToUpper() == "_lastId".ToUpper() &&
                    prop.PrimaryKey == ValueProperty.UserDefinedKeyBehaviour.DBProvidedPK &&
                    (prop.PropertyType == TypeCodeEx.Int16 ||
                    prop.PropertyType == TypeCodeEx.Int32 ||
                    prop.PropertyType == TypeCodeEx.Int64))
                {
                    %>
            <%= GetFieldLoaderStatement(prop, "System.Threading.Interlocked.Decrement(ref " + prop.DefaultValue.Trim() + ")") %>;
            <%
                }
                else
                {
                    %>
            <%= GetFieldLoaderStatement(Info, prop, prop.DefaultValue) %>;
            <%
                }
            }
            else if (prop.Nullable && prop.PropertyType == TypeCodeEx.String)
            {
                %>
            <%= GetFieldLoaderStatement(Info, prop, "null") %>;
            <%
            }
        }
        ValuePropertyCollection valProps = Info.GetAllValueProperties();
        foreach (CriteriaProperty p in c.Properties)
        {
            if (valProps.Contains(p.Name))
            {
                ValueProperty prop = valProps.Find(p.Name);
                if (c.Properties.Count > 1)
                {
                    %>
            <%= GetFieldLoaderStatement(prop, (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives ? "crit." + FormatProperty(p.Name) : FormatCamel(p.Name))) %>;
            <%
                }
                else
                {
                    %>
            <%= GetFieldLoaderStatement(prop, AssignSingleCriteria(c, "crit")) %>;
            <%
                }
            }
        }
        foreach (ChildProperty childProp in Info.GetAllChildProperties())
        {
            CslaObjectInfo _child = FindChildInfo(Info, childProp.TypeName);
            if (_child != null)
            {
                if (TypeHelper.IsEditableType(_child.ObjectType) &&
                    (childProp.LoadingScheme == LoadingScheme.ParentLoad || !childProp.LazyLoad))
                {
                    %>
            <%= GetNewChildLoadStatement(childProp, true) %>;
            <%
                }
            }
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
            OnCreate(args);
        }
    <%
    }
}
%>
