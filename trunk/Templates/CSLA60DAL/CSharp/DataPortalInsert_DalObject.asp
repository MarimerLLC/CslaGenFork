<%
useInlineQuery = false;
lastCriteria = "";
if (CurrentUnit.GenerationParams.UseInlineQueries == UseInlineQueries.Always)
   useInlineQuery = true;
else if (CurrentUnit.GenerationParams.UseInlineQueries == UseInlineQueries.SpecifyByObject)
{
   foreach (string item in Info.GenerateInlineQueries)
   {
       if (item == "Create")
       {
           useInlineQuery = true;
           break;
       }
   }
}
if (Info.GenerateDataPortalInsert)
{
    string strInsertPK = string.Empty;
    string strInsertComment = string.Empty;
    string strInsertCommentResult = string.Empty;
    string strInsertResult = string.Empty;
    string strInsertParams = string.Empty;
    string strInsertParamsOutLess = string.Empty;
    bool hasInsertTimestamp = false;
    bool insertIsFirst = true;

    if (usesDTO)
    {
        strInsertResult = Info.ObjectName + "Dto";
        strInsertParams = strInsertResult + " " + FormatCamel(Info.ObjectName);
        strInsertParamsOutLess = strInsertResult + " " + FormatCamel(Info.ObjectName);
        lastCriteria = FormatCamel(Info.ObjectName);
        strInsertComment = System.Environment.NewLine + new string(' ', 8) + "/// <param name=\"" + FormatCamel(Info.ObjectName) + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(Info.ObjectName) + " DTO.</param>";
        strInsertCommentResult = System.Environment.NewLine + new string(' ', 8) + "/// <returns>The new <see cref=\"" + strInsertResult + "\"/>.</returns>";
    }
    else
    {
        foreach (ValueProperty prop in Info.GetAllValueProperties())
        {
            if (!prop.IsDatabaseBound)
                continue;

            if (prop.PrimaryKey == ValueProperty.UserDefinedKeyBehaviour.DBProvidedPK)
                strInsertPK += FormatCamel(prop.Name) + " = -1;" + Environment.NewLine + new string(' ', 12);

            if (prop.DbBindColumn.NativeType == "timestamp")
            {
                hasInsertTimestamp = true;
                strInsertCommentResult = System.Environment.NewLine + new string(' ', 8) + "/// <returns>The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(prop.Name) + " of the new " + Info.ObjectName + ".</returns>";
            }
            if (//prop.DbBindColumn.ColumnOriginType != ColumnOriginType.None &&
                prop.DataAccess != ValueProperty.DataAccessBehaviour.ReadOnly &&
                prop.DbBindColumn.NativeType != "timestamp" &&
                (prop.DataAccess != ValueProperty.DataAccessBehaviour.UpdateOnly || prop.DbBindColumn.NativeType == "timestamp"))
            {
                if (!insertIsFirst)
                {
                    strInsertParams += ", ";
                    strInsertParamsOutLess += ", ";
                    lastCriteria += ", ";
                }
                else
                    insertIsFirst = false;

                strInsertComment += System.Environment.NewLine + new string(' ', 8) + "/// <param name=\"" + FormatCamel(prop.Name) + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(prop.Name) + ".</param>";
                if (prop.PrimaryKey == ValueProperty.UserDefinedKeyBehaviour.DBProvidedPK)
                    strInsertParams += "out ";

                strInsertParams += string.Concat(GetDataTypeGeneric(prop, TemplateHelper.GetBackingFieldType(prop)), " ", FormatCamel(prop.Name));
                strInsertParamsOutLess += string.Concat(GetDataTypeGeneric(prop, TemplateHelper.GetBackingFieldType(prop)), " ", FormatCamel(prop.Name));
                lastCriteria += FormatCamel(prop.Name);
            }
        }
        if (hasInsertTimestamp)
            strInsertResult = "byte[]";
        else
            strInsertResult = "void";
    }
    if (isFirstMethod)
        isFirstMethod = false;
    else
        Response.Write(Environment.NewLine);

    if (useInlineQuery)
        InlineQueryList.Add(new AdvancedGenerator.InlineQuery(Info.InsertProcedureName, strInsertParamsOutLess));
    %>
        /// <summary>
        /// Inserts a new <%= Info.ObjectName %> object in the database.
        /// </summary><%= strInsertComment %><%= strInsertCommentResult %>
        public <%= strInsertResult %> Insert(<%= strInsertParams %>)
        {
            <%
            if (!string.IsNullOrEmpty(strInsertPK))
            {
            %>
            <%= strInsertPK %>
            <%
            }
            bool needsIndent = true;
            %>
            <%= GetConnection(Info, false) %>
            {
            <%= AddIndent(needsIndent)%><%= GetCommand(Info, Info.InsertProcedureName, useInlineQuery, lastCriteria) %>
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
            (prop.DataAccess != ValueProperty.DataAccessBehaviour.ReadOnly &&
            prop.DataAccess != ValueProperty.DataAccessBehaviour.UpdateOnly)
			|| (prop.DataAccess == ValueProperty.DataAccessBehaviour.ReadOnly && 
				(prop.OutputParameter == ValueProperty.OutputParameterBehaviour.InsertOnly 
				|| prop.OutputParameter == ValueProperty.OutputParameterBehaviour.InsertAndUpdate))))
        {
            if (prop.DbBindColumn.NativeType == "timestamp")
            {
                %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.Add("@New<%= prop.ParameterName %>", SqlDbType.Timestamp).Direction = ParameterDirection.Output;
                    <%
            }
            else
            {
                TypeCodeEx propType = TemplateHelper.GetBackingFieldType(prop);
                string postfix = string.Empty;
                if (prop.PrimaryKey == ValueProperty.UserDefinedKeyBehaviour.DBProvidedPK
					|| prop.OutputParameter == ValueProperty.OutputParameterBehaviour.InsertOnly
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

                if (prop.DeclarationMode == PropertyDeclaration.Managed || prop.DeclarationMode == PropertyDeclaration.ManagedWithTypeConversion)
                {
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
                }
                else
                {
                    if (AllowNull(prop) && propType == TypeCodeEx.Guid)
                    {
                        %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= GetParameterSet(Info, prop) %>.Equals(Guid.Empty) ? (object)DBNull.Value : <%= GetFieldReaderStatement(prop) %>).DbType = DbType.<%= TemplateHelper.GetDbType(prop) %>;
                    <%
                    }
                    else if (AllowNull(prop) && prop.PropertyType == TypeCodeEx.CustomType)
                    {
                        %>
                <%= AddIndent(needsIndent)%>// For nullable PropertyConvert, null is persisted if the backing field is zero
                <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= GetParameterSet(Info, prop) %> == 0 ? (object)DBNull.Value : <%= GetFieldReaderStatement(prop) %>).DbType = DbType.<%= TemplateHelper.GetDbType(prop) %>;
                    <%
                    }
                    else if (AllowNull(prop) && propType != TypeCodeEx.SmartDate)
                    {
                        %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= GetParameterSet(Info, prop) %> == null ? (object)DBNull.Value : <%= GetFieldReaderStatement(prop) %><%= TemplateHelper.IsNullableType(propType) ? ".Value" :"" %>).DbType = DbType.<%= TemplateHelper.GetDbType(prop) %>;
                    <%
                    }
                    else
                    {
                        %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= prop.ParameterName %>", <%= GetParameterSet(Info, prop) %><%= (propType == TypeCodeEx.SmartDate ? ".DBValue" : "") %>)<%= postfix %>;
                    <%
                    }
                }
               } 
            }
        }
    }
    %>
				<%= AddIndent(needsIndent)%>var args = new DalHookArgs(cmd)<%= usesDTO ? " { DtoArg = " + FormatCamel(Info.ObjectName) + " }" : "" %>;
				<%= AddIndent(needsIndent)%>OnInsertPre(args);
                <%= AddIndent(needsIndent)%>cmd.ExecuteNonQuery();
                    <%
    foreach (ValueProperty prop in Info.GetAllValueProperties())
    {
        if ((prop.IsDatabaseBound &&
            //prop.DbBindColumn.ColumnOriginType != ColumnOriginType.None &&
            //(prop.DbBindColumn.IsPrimaryKey &&
            prop.PrimaryKey == ValueProperty.UserDefinedKeyBehaviour.DBProvidedPK)
			|| prop.OutputParameter == ValueProperty.OutputParameterBehaviour.InsertOnly
			|| prop.OutputParameter == ValueProperty.OutputParameterBehaviour.InsertAndUpdate)
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
        if (prop.IsDatabaseBound &&
            //prop.DbBindColumn.ColumnOriginType != ColumnOriginType.None &&
            prop.DbBindColumn.NativeType == "timestamp")
        {
            %>
                <%= AddIndent(needsIndent)%><%= (usesDTO ? FormatCamel(Info.ObjectName) + "." + FormatPascal(prop.Name) + " = ": "return ") %>(byte[])cmd.Parameters["@New<%= prop.ParameterName %>"].Value;
                    <%
        }
    }
    %>
				<%= AddIndent(needsIndent)%>args = new DalHookArgs(cmd)<%= usesDTO ? " { DtoArg = " + FormatCamel(Info.ObjectName) + " }" : "" %>;
				<%= AddIndent(needsIndent)%>OnInsertPost(args);
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
