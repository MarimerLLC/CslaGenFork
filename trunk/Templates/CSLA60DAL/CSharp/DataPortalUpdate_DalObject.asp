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
            <%
            bool needsIndent = true;
            %>
            <%= GetConnection(Info, false) %>
            {
            <%= AddIndent(needsIndent)%><%= GetCommand(Info, Info.UpdateProcedureName, useInlineQuery, lastCriteria) %>
            <%= AddIndent(needsIndent)%>{
                    <%
    if (Info.CommandTimeout != string.Empty)
    {
        %>
                <%= AddIndent(needsIndent)%>cmd.CommandTimeout = <%= Info.CommandTimeout %>;
                    <%
    }
    %>
                <%= AddIndent(needsIndent)%>cmd.CommandType = CommandType.<%= useInlineQuery ? "Text" : "StoredProcedure" %>;
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
            {
                postfix = ".Direction = ParameterDirection.Output";
            %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.Add("@<%= prop.ParameterName %>", SqlDbType.<%= propType.GetSqlDbType() %><%= (propType == TypeCodeEx.String ? ", " + prop.ParameterSize : "") %>)<%= postfix %>;
            <%    
            }
            else
            {
              postfix = ".DbType = DbType." + TemplateHelper.GetDbType(prop);
            
              if (AllowNull(prop) && propType == TypeCodeEx.Guid)
              {
                  %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %>.Equals(Guid.Empty) ? (object)DBNull.Value : <%= FormatCamel(prop.Name) %>).DbType = DbType.<%= TemplateHelper.GetDbType(prop) %>;
                      <%
              }
              else if (AllowNull(prop) && prop.PropertyType == TypeCodeEx.CustomType)
              {
                  %>
                <%= AddIndent(needsIndent)%>// For nullable PropertyConvert, null is persisted if the backing field is zero
                <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %> == 0 ? (object)DBNull.Value : <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %>).DbType = DbType.<%= TemplateHelper.GetDbType(prop) %>;
                      <%
              }
              else if (AllowNull(prop) && propType != TypeCodeEx.SmartDate)
              {
                  %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %> == null ? (object)DBNull.Value : <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %><%= TemplateHelper.IsNullableType(propType) ? ".Value" :"" %>).DbType = DbType.<%= TemplateHelper.GetDbType(prop) %>;
                      <%
              }
              else
              {
                  %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %><%= (propType == TypeCodeEx.SmartDate ? ".DBValue" : "") %>)<%= postfix %>;
                      <%
              }
              if (prop.DbBindColumn.NativeType == "timestamp")
              {
                  %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.Add("@New<%= prop.ParameterName %>", SqlDbType.Timestamp).Direction = ParameterDirection.Output;
                      <%
              }
            }
        }
    }
    %>
				<%= AddIndent(needsIndent)%>var args = new DalHookArgs(cmd)<%= usesDTO ? " { DtoArg = " + FormatCamel(Info.ObjectName) + " }" : "" %>;
				<%= AddIndent(needsIndent)%>OnUpdatePre(args);
                <%= AddIndent(needsIndent)%>cmd.ExecuteNonQuery();
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
                <%= AddIndent(needsIndent)%><%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %> = <%= prop.OutputParameterFunction.Replace("{val}", "cmd.Parameters[\"@" + prop.ParameterName + "\"].Value") %>;
                    <%
			}
			else
			{
			%>
                <%= AddIndent(needsIndent)%><%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) : FormatCamel(prop.Name)) %> = (<%= GetLanguageVariableType(prop.DbBindColumn.DataType) %>)cmd.Parameters["@<%= prop.ParameterName %>"].Value;
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
                <%= AddIndent(needsIndent)%><%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) + " = ": "return ") %>(byte[])cmd.Parameters["@New<%= prop.ParameterName %>"].Value;
                    <%
        }
    }
    %>
				<%= AddIndent(needsIndent)%>args = new DalHookArgs(cmd)<%= usesDTO ? " { DtoArg = " + FormatCamel(Info.ObjectName) + " }" : "" %>;
				<%= AddIndent(needsIndent)%>OnUpdatePost(args);
            <%= AddIndent(needsIndent)%>}
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
