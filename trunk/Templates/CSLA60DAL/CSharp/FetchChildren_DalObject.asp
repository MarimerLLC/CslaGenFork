<%
CslaObjectInfo currentInfo = Info;
CslaObjectInfo childParentInfo;
CslaObjectInfo childGrandParentInfo;
if (isCollection)
    currentInfo = itemInfo;
int childAncestorLoaderLevel = 0;
bool childAncestorIsCollection = false;
bool childIsItem = false;
bool handleAsCollection = false;
%>
<%
if (Info.DataSetLoadingScheme)
{
%>
        private void FetchChildren(<%= Info.ItemType %>Dto dto, DataRow dr)
        {
            <%
            
    foreach (var childProp in currentInfo.GetCollectionChildProperties())
    {
        if (childProp.LoadingScheme == LoadingScheme.ParentLoad)
        {    
            var childInfo = FindChildInfo(Info, childProp.TypeName);
            var childItemInfo = FindChildInfo(childInfo, childInfo.ItemType);
            %>
            var childRows = dr.GetChildRows("<%= Info.ItemType %><%= childInfo.ItemType %>");
            foreach (DataRow row in childRows)
            {
                var <%= FormatCamel(childInfo.ItemType) %> = new <%= childInfo.ItemType %>Dto();
                <%
            foreach (ValueProperty prop in childItemInfo.GetAllValueProperties())
            {
                if (prop.IsDatabaseBound &&
                    prop.DbBindColumn.ColumnOriginType != ColumnOriginType.None &&
                    prop.DataAccess != ValueProperty.DataAccessBehaviour.WriteOnly)
                {
                    try
                    {
                    %>
                if (!dr.IsNull("<%= prop.ParameterName %>"))
                    <%= FormatCamel(childInfo.ItemType) %>.<%= FormatProperty(prop) %> = <%= GetDataRowStatement(prop) %>;
                    <%
                    }
                    catch (Exception ex)
                    {
                        Errors.Append(ex.Message + Environment.NewLine);
                    }
                }
            }
            %>
                dto.<%= FormatPascal(childProp.Name) %>.Add(<%= FormatCamel(childInfo.ItemType) %>);
            }
            <%
        }
    }
    %>
        }
<%
}
else
{
%>
        private void FetchChildren(SafeDataReader dr)
        {
            <%
foreach (ChildProperty childProp in currentInfo.GetAllChildProperties())
{
    if (childProp.LoadingScheme == LoadingScheme.ParentLoad)
    {
        CslaObjectInfo _child = FindChildInfo(currentInfo, childProp.TypeName);
        if (_child != null)
        {
            childAncestorLoaderLevel = AncestorLoaderLevel(_child, out childAncestorIsCollection);
            handleAsCollection = TypeHelper.IsCollectionType(_child.ObjectType) ||
                (childAncestorLoaderLevel > 0 && childAncestorIsCollection) ||
                (childAncestorLoaderLevel > 1 && !childAncestorIsCollection);
            %>
            dr.NextResult();
<%
            if (handleAsCollection)
            {
                %>
            while (dr.Read())
            {
                <%= FormatFieldName(_child.ObjectName) %>.Add(Fetch<%= TypeHelper.IsCollectionType(_child.ObjectType) ? _child.ItemType : _child.ObjectName %>(dr));
            }
            <%
            }
            else
            {
                %>
            if (dr.Read())
                Fetch<%= _child.ObjectName %>(dr);
            <%
            }
        }
    }
}

handleAsCollection = true;
foreach (ChildProperty childProp in GetParentLoadAllGrandChildPropertiesInHierarchy(currentInfo, true))
{
    if (childProp.LoadingScheme == LoadingScheme.ParentLoad)
    {
        CslaObjectInfo _child = FindChildInfo(currentInfo, childProp.TypeName);
        if (_child != null)
        {
            %>
            dr.NextResult();
<%
            if (handleAsCollection)
            {
                %>
            while (dr.Read())
            {
                <%= FormatFieldName(_child.ObjectName) %>.Add(Fetch<%= TypeHelper.IsCollectionType(_child.ObjectType) ? _child.ItemType : _child.ObjectName %>(dr));
            }
            <%
            }
            else
            {
                %>
            if (dr.Read())
                Fetch<%= _child.ObjectName %>(dr);
            <%
            }
        }
    }
}
        %>
        }
<%

foreach (ChildProperty childProp in currentInfo.GetAllChildProperties())
{
    if (childProp.LoadingScheme == LoadingScheme.ParentLoad)
    {
        CslaObjectInfo _child = FindChildInfo(currentInfo, childProp.TypeName);
        if (TypeHelper.IsCollectionType(_child.ObjectType))
            _child = FindChildInfo(_child, _child.ItemType);
        if (_child != null)
        {
            childAncestorLoaderLevel = AncestorLoaderLevel(_child, out childAncestorIsCollection);
            // parent loading field
            bool useFieldForParentLoading2 = (((childAncestorLoaderLevel > 2 && !childAncestorIsCollection) ||
                (childAncestorLoaderLevel > 1 && childAncestorIsCollection)) && _child.ParentProperties.Count > 0);
            handleAsCollection = TypeHelper.IsCollectionType(_child.ObjectType) ||
                (childAncestorLoaderLevel > 0 && childAncestorIsCollection) ||
                (childAncestorLoaderLevel > 1 && !childAncestorIsCollection);
            %>

        private <%= handleAsCollection ? _child.ObjectName + "Dto" : "void" %> Fetch<%= _child.ObjectName %>(SafeDataReader dr)
        {
            <%
            if (handleAsCollection)
            {
                %>
            var <%= FormatCamel(_child.ObjectName) %> = new <%= _child.ObjectName %>Dto();
            <%
            }
            %>
            // Value properties
            <%
            foreach (ValueProperty prop in _child.GetAllValueProperties())
            {
                if (prop.IsDatabaseBound &&
                    prop.DbBindColumn.ColumnOriginType != ColumnOriginType.None &&
                    prop.DataAccess != ValueProperty.DataAccessBehaviour.WriteOnly)
                {
                    try
                    {
                        %>
            <%= handleAsCollection ? FormatCamel(_child.ObjectName) : FormatFieldName(_child.ObjectName) %>.<%= FormatProperty(prop) %> = <%= GetDataReaderStatement(prop) %>;
            <%
                    }
                    catch (Exception ex)
                    {
                        Errors.Append(ex.Message + Environment.NewLine);
                    }
                }
            }

            if (useFieldForParentLoading2)
            {
                childParentInfo = Info.Parent.CslaObjects.Find(_child.ParentType);
                childGrandParentInfo = Info.Parent.CslaObjects.Find(childParentInfo.ParentType);
                childIsItem = TypeHelper.IsCollectionType(childParentInfo.ObjectType);
                %>
            // parent properties
            <%
                foreach (Property prop in _child.ParentProperties)
                {
                    %>
            <%= handleAsCollection ? FormatCamel(_child.ObjectName) : FormatFieldName(_child.ObjectName) %>.Parent_<%= FormatPascal(prop.Name) %> = dr.<%= GetReaderMethod(prop.PropertyType) %>("<%= GetFKColumn(_child, (childIsItem ? childGrandParentInfo : childParentInfo), prop) %>");
            <%
                }
            }
            if (handleAsCollection)
            {
                %>

            return <%= FormatCamel(_child.ObjectName) %>;
            <%
            }
            %>
        }
<%
        }
    }
}

foreach (ChildProperty childProp in GetParentLoadAllGrandChildPropertiesInHierarchy(currentInfo, true))
{
    if (childProp.LoadingScheme == LoadingScheme.ParentLoad)
    {
        CslaObjectInfo _child = FindChildInfo(currentInfo, childProp.TypeName);
        if (TypeHelper.IsCollectionType(_child.ObjectType))
            _child = FindChildInfo(_child, _child.ItemType);
        if (_child != null)
        {
            childAncestorLoaderLevel = AncestorLoaderLevel(_child, out childAncestorIsCollection);
            // parent loading field
            bool useFieldForParentLoading2 = (((childAncestorLoaderLevel > 2 && !childAncestorIsCollection) ||
                (childAncestorLoaderLevel > 1 && childAncestorIsCollection)) && _child.ParentProperties.Count > 0);
            handleAsCollection = TypeHelper.IsCollectionType(_child.ObjectType) ||
                (childAncestorLoaderLevel > 0 && childAncestorIsCollection) ||
                (childAncestorLoaderLevel > 1 && !childAncestorIsCollection);
            %>

        private <%= handleAsCollection ? _child.ObjectName + "Dto" : "void" %> Fetch<%= _child.ObjectName %>(SafeDataReader dr)
        {
            <%
            if (handleAsCollection)
            {
                %>
            var <%= FormatCamel(_child.ObjectName) %> = new <%= _child.ObjectName %>Dto();
            <%
            }
            %>
            // Value properties
            <%
            foreach (ValueProperty prop in _child.GetAllValueProperties())
            {
                if (prop.IsDatabaseBound &&
                    prop.DbBindColumn.ColumnOriginType != ColumnOriginType.None &&
                    prop.DataAccess != ValueProperty.DataAccessBehaviour.WriteOnly)
                {
                    try
                    {
                        %>
            <%= handleAsCollection ? FormatCamel(_child.ObjectName) : FormatFieldName(_child.ObjectName) %>.<%= FormatProperty(prop) %> = <%= GetDataReaderStatement(prop) %>;
            <%
                    }
                    catch (Exception ex)
                    {
                        Errors.Append(ex.Message + Environment.NewLine);
                    }
                }
            }

            if (useFieldForParentLoading2)
            {
                childParentInfo = Info.Parent.CslaObjects.Find(_child.ParentType);
                childGrandParentInfo = Info.Parent.CslaObjects.Find(childParentInfo.ParentType);
                childIsItem = TypeHelper.IsCollectionType(childParentInfo.ObjectType);
                %>
            // parent properties
            <%
                foreach (Property prop in _child.ParentProperties)
                {
                    %>
            <%= handleAsCollection ? FormatCamel(_child.ObjectName) : FormatFieldName(_child.ObjectName) %>.Parent_<%= FormatPascal(prop.Name) %> = dr.<%= GetReaderMethod(prop.PropertyType) %>("<%= GetFKColumn(_child, (childIsItem ? childGrandParentInfo : childParentInfo), prop) %>");
            <%
                }
            }
            if (handleAsCollection)
            {
                %>

            return <%= FormatCamel(_child.ObjectName) %>;
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
