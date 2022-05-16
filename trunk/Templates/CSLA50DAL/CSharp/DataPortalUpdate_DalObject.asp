<%
useInlineQuery = false;
lastCriteria = "";
if (CurrentUnit.GenerationParams.UseInlineQueries == UseInlineQueries.Always)
   useInlineQuery = true;
else if (CurrentUnit.GenerationParams.UseInlineQueries == UseInlineQueries.SpecifyByObject)
{
   foreach (string item in Info.GenerateInlineQueries)
   {
       if (item == "Update")
       {
           useInlineQuery = true;
           break;
       }
   }
}
if (Info.GenerateDataPortalUpdate)
{
    string strUpdateComment = string.Empty;
    string strUpdateCommentResult = string.Empty;
    string strUpdateResult = string.Empty;
    string strUpdateParams = string.Empty;
    bool hasUpdateTimestamp = false;
    bool updateIsFirst = true;

    if (usesDTO)
    {
        strUpdateResult = Info.ObjectName + "Dto";
        strUpdateParams = strUpdateResult + " " + FormatCamel(Info.ObjectName);
        lastCriteria = FormatCamel(Info.ObjectName);
        strUpdateComment = System.Environment.NewLine + new string(' ', 8) + "/// <param name=\"" + FormatCamel(Info.ObjectName) + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(Info.ObjectName) + " DTO.</param>";
        strUpdateCommentResult = System.Environment.NewLine + new string(' ', 8) + "/// <returns>The updated <see cref=\"" + strUpdateResult + "\"/>.</returns>";
    }
    else
    {
        foreach (ValueProperty prop in Info.GetAllValueProperties())
        {
            if (!prop.IsDatabaseBound)
                continue;

            if (prop.DbBindColumn.NativeType == "timestamp")
            {
                hasUpdateTimestamp = true;
                strUpdateCommentResult = System.Environment.NewLine + new string(' ', 8) + "/// <returns>The updated " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(prop.Name) + ".</returns>";
            }
            if (prop.DbBindColumn.ColumnOriginType != ColumnOriginType.None &&
                prop.DataAccess != ValueProperty.DataAccessBehaviour.ReadOnly &&
                (prop.DataAccess != ValueProperty.DataAccessBehaviour.CreateOnly ||
                (prop.PrimaryKey == ValueProperty.UserDefinedKeyBehaviour.DBProvidedPK ||
                prop.DataAccess == ValueProperty.DataAccessBehaviour.UpdateOnly)) ||
                prop.DbBindColumn.NativeType == "timestamp")
            {
                if (!updateIsFirst)
                {
                    strUpdateParams += ", ";
                    lastCriteria += ", ";
                }
                else
                    updateIsFirst = false;

                strUpdateComment += System.Environment.NewLine + new string(' ', 8) + "/// <param name=\"" + FormatCamel(prop.Name) + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(prop.Name) + ".</param>";
                strUpdateParams += string.Concat(GetDataTypeGeneric(prop, TemplateHelper.GetBackingFieldType(prop)), " ", FormatCamel(prop.Name));
                lastCriteria += FormatCamel(prop.Name);
            }
        }
        if (hasUpdateTimestamp)
            strUpdateResult = "byte[]";
        else
            strUpdateResult = "void";
    }
    if (isFirstMethod)
        isFirstMethod = false;
    else
        Response.Write(Environment.NewLine);

    if (useInlineQuery)
        InlineQueryList.Add(new AdvancedGenerator.InlineQuery(Info.UpdateProcedureName, strUpdateParams));
    %>
        /// <summary>
        /// Updates in the database all changes made to the <%= Info.ObjectName %> object.
        /// </summary><%= strUpdateComment %><%= strUpdateCommentResult %>
        public <%= strUpdateResult %> Update(<%= strUpdateParams %>)
        {
            <%= GetConnection(Info, false) %>
            {
                <%= GetCommand(Info, Info.UpdateProcedureName, useInlineQuery, lastCriteria) %>
                {
                    <%
    if (Info.CommandTimeout != string.Empty)
    {
        %>
                    cmd.CommandTimeout = <%= Info.CommandTimeout %>;
                    <%
    }
    %>
                    cmd.CommandType = CommandType.<%= useInlineQuery ? "Text" : "StoredProcedure" %>;
                    <%
    foreach (ValueProperty prop in Info.GetAllValueProperties())
    {
        if (prop.IsDatabaseBound &&
            //prop.DbBindColumn.ColumnOriginType != ColumnOriginType.None &&
            (prop.PrimaryKey != ValueProperty.UserDefinedKeyBehaviour.Default ||
            prop.DbBindColumn.NativeType == "timestamp" ||
            (prop.DataAccess != ValueProperty.DataAccessBehaviour.ReadOnly &&
            prop.DataAccess != ValueProperty.DataAccessBehaviour.CreateOnly)
			|| (prop.DataAccess == ValueProperty.DataAccessBehaviour.ReadOnly && 
				(prop.OutputParameter == ValueProperty.OutputParameterBehaviour.UpdateOnly 
				|| prop.OutputParameter == ValueProperty.OutputParameterBehaviour.InsertAndUpdate))))
        {
            TypeCodeEx propType = TemplateHelper.GetBackingFieldType(prop);
			string postfix = string.Empty;
			if (prop.OutputParameter == ValueProperty.OutputParameterBehaviour.UpdateOnly
					|| prop.OutputParameter == ValueProperty.OutputParameterBehaviour.InsertAndUpdate)
                    postfix = ".Direction = ParameterDirection.Output";
                else
                    postfix = ".DbType = DbType." + TemplateHelper.GetDbType(prop);
            
            if (AllowNull(prop) && propType == TypeCodeEx.Guid)
            {
                %>
                    cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %>.Equals(Guid.Empty) ? (object)DBNull.Value : <%= FormatCamel(prop.Name) %>).DbType = DbType.<%= TemplateHelper.GetDbType(prop) %>;
                    <%
            }
            else if (AllowNull(prop) && prop.PropertyType == TypeCodeEx.CustomType)
            {
                %>
                    // For nullable PropertyConvert, null is persisted if the backing field is zero
                    cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %> == 0 ? (object)DBNull.Value : <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %>).DbType = DbType.<%= TemplateHelper.GetDbType(prop) %>;
                    <%
            }
            else if (AllowNull(prop) && propType != TypeCodeEx.SmartDate)
            {
                %>
                    cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %> == null ? (object)DBNull.Value : <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %><%= TemplateHelper.IsNullableType(propType) ? ".Value" :"" %>).DbType = DbType.<%= TemplateHelper.GetDbType(prop) %>;
                    <%
            }
            else
            {
                %>
                    cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %><%= (propType == TypeCodeEx.SmartDate ? ".DBValue" : "") %>)<%= postfix %>;
                    <%
            }
            if (prop.DbBindColumn.NativeType == "timestamp")
            {
                %>
                    cmd.Parameters.Add("@New<%= prop.ParameterName %>", SqlDbType.Timestamp).Direction = ParameterDirection.Output;
                    <%
            }
        }
    }
    %>
					var args = new DalHookArgs(cmd)<%= usesDTO ? " { DtoArg = " + FormatCamel(Info.ObjectName) + " }" : "" %>;
					OnUpdatePre(args);
                    cmd.ExecuteNonQuery();
                    <%
	foreach (ValueProperty prop in Info.GetAllValueProperties())
    {
        if (prop.IsDatabaseBound &&
            (prop.OutputParameter == ValueProperty.OutputParameterBehaviour.UpdateOnly
			|| prop.OutputParameter == ValueProperty.OutputParameterBehaviour.InsertAndUpdate))
        {
            if (!String.IsNullOrEmpty(prop.OutputParameterFunction))
			{
			%>
                    <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %> = <%= prop.OutputParameterFunction.Replace("{val}", "cmd.Parameters[\"" + prop.ParameterName + "\"].Value") %>;
                    <%
			}
			else
			{
			%>
                    <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %> = (<%= GetLanguageVariableType(prop.DbBindColumn.DataType) %>)cmd.Parameters["@<%= prop.ParameterName %>"].Value;
                    <%
			}
        }
    }
					
    foreach (ValueProperty prop in Info.GetAllValueProperties())
    {
        if (!prop.IsDatabaseBound)
            continue;

        if (prop.DbBindColumn.NativeType == "timestamp")
        {
            //Response.Write(Environment.NewLine);
            %>
                    <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) + " = ": "return ") %>(byte[])cmd.Parameters["@New<%= prop.ParameterName %>"].Value;
                    <%
        }
    }
    %>
					args = new DalHookArgs(cmd)<%= usesDTO ? " { DtoArg = " + FormatCamel(Info.ObjectName) + " }" : "" %>;
					OnUpdatePost(args);
                }
            }
            <%
    if (usesDTO)
    {
        %>
            return <%= FormatCamel(Info.ObjectName) %>;
        <%
    }
    %>
        }
    <%
}
%>
