<%
if (Info.GenerateDataPortalUpdate)
{
    bool propUpdatePropertyInfo = false;
    string strUpdateParams = string.Empty;
    string strUpdateDto = string.Empty;
    string strUpdateResult = string.Empty;
    string strUpdateResultTS = string.Empty;
	string strUpdateResultOP = string.Empty;
    bool updateIsFirst = true;

    foreach (ValueProperty prop in Info.GetAllValueProperties())
    {
        if (!prop.IsDatabaseBound)
            continue;

        if (prop.DbBindColumn.NativeType == "timestamp")
        {
            if ((prop.DeclarationMode == PropertyDeclaration.Managed && !prop.ReadOnly) ||
                prop.DeclarationMode == PropertyDeclaration.AutoProperty)
            {
                if (usesDTO)
                {
                    strUpdateResultTS = FormatPascal(prop.Name) + " = resultDto." + FormatPascal(prop.Name) +";";
                }
                else
                {
                    strUpdateResult = FormatPascal(prop.Name) + " = ";
                }
            }
            else if ((prop.DeclarationMode == PropertyDeclaration.Managed && prop.ReadOnly) ||
                prop.DeclarationMode == PropertyDeclaration.ManagedWithTypeConversion ||
                prop.DeclarationMode == PropertyDeclaration.ManagedWithTypeConversion)
            {
                if (usesDTO)
                {
                    strUpdateResultTS = "LoadProperty(" + FormatPropertyInfoName(prop.Name) + ", resultDto." + FormatPascal(prop.Name) +");";
                }
                else
                {
                    propUpdatePropertyInfo = true;
                    strUpdateResult = "LoadProperty(" + FormatPropertyInfoName(prop.Name) + ", ";
                }
            }
            else //Unmanaged, ClassicProperty, ClassicPropertyWithTypeConversion
            {
                if (usesDTO)
                {
                    strUpdateResultTS = FormatFieldName(prop.Name) + " = resultDto." + FormatPascal(prop.Name) +";";
                }
                else
                {
                    strUpdateResult = FormatFieldName(prop.Name) + " = ";
                }
            }
        }
        if (//prop.DbBindColumn.ColumnOriginType != ColumnOriginType.None &&
            prop.DataAccess != ValueProperty.DataAccessBehaviour.ReadOnly &&
            (prop.DataAccess != ValueProperty.DataAccessBehaviour.CreateOnly ||
            (prop.PrimaryKey == ValueProperty.UserDefinedKeyBehaviour.DBProvidedPK ||
            prop.DataAccess == ValueProperty.DataAccessBehaviour.UpdateOnly)) ||
            prop.DbBindColumn.NativeType == "timestamp")
        {
            if (usesDTO)
            {
                strUpdateDto += Environment.NewLine + new string(' ', 16) + "dto." + FormatPascal(prop.Name) + " = ";
            }
            else
            {
                if (!updateIsFirst)
                    strUpdateParams += ",";
                else
                    updateIsFirst = false;

                strUpdateParams += Environment.NewLine + new string(' ', 24);
            }

            if (prop.DeclarationMode == PropertyDeclaration.ManagedWithTypeConversion ||
                prop.DeclarationMode == PropertyDeclaration.UnmanagedWithTypeConversion)
            {
                if (usesDTO)
                {
                    strUpdateDto += GetFieldReaderStatement(prop) + ";";
                }
                else
                    strUpdateParams += GetFieldReaderStatement(prop);
            }
            else if (prop.DeclarationMode == PropertyDeclaration.Managed ||
                prop.DeclarationMode == PropertyDeclaration.AutoProperty)
            {
                if (usesDTO)
                {
                    strUpdateDto += FormatPascal(prop.Name) + ";";
                }
                else
                    strUpdateParams += FormatPascal(prop.Name);
            }
            else //Unmanaged, ClassicProperty, ClassicPropertyWithTypeConversion
            {
                if (usesDTO)
                {
                    strUpdateDto += FormatFieldName(prop.Name) + ";";
                }
                else
                    strUpdateParams += FormatFieldName(prop.Name);
            }
        }
		if (prop.DataAccess == ValueProperty.DataAccessBehaviour.ReadOnly &&
            prop.DbBindColumn.NativeType != "timestamp")
        {
			if (prop.OutputParameter == ValueProperty.OutputParameterBehaviour.UpdateOnly
				|| prop.OutputParameter == ValueProperty.OutputParameterBehaviour.InsertAndUpdate)
            {
                strUpdateResultOP += Environment.NewLine + new string(' ', 16);
                if (prop.DeclarationMode == PropertyDeclaration.ManagedWithTypeConversion ||
                    prop.DeclarationMode == PropertyDeclaration.UnmanagedWithTypeConversion ||
                    prop.ReadOnly)
                {
                    strUpdateResultOP += "LoadProperty(" + FormatPropertyInfoName(prop.Name) + ", ";
                    if (usesDTO)
                    {
                        strUpdateResultOP += "resultDto." + FormatPascal(prop.Name) +");";
                    }
                    else
                    {
                        strUpdateResultOP += FormatCamel(prop.Name) +");";
                    }
                }
                else if (prop.DeclarationMode == PropertyDeclaration.Managed ||
                    prop.DeclarationMode == PropertyDeclaration.AutoProperty)
                {
                    strUpdateResultOP += FormatPascal(prop.Name) + " = ";
                    if (usesDTO)
                    {
                        strUpdateResultOP += "resultDto." + FormatPascal(prop.Name) +";";
                    }
                    else
                    {
                        strUpdateResultOP += FormatCamel(prop.Name) +";";
                    }
                }
                else //Unmanaged, ClassicProperty, ClassicPropertyWithTypeConversion
                {
                    strUpdateResultOP += FormatFieldName(prop.Name) + " = ";
                    if (usesDTO)
                    {
                        strUpdateResultOP += "resultDto." + FormatPascal(prop.Name) +";";
                    }
                    else
                    {
                        strUpdateResultOP += FormatCamel(prop.Name) +";";
                    }
                }
            }
		}
    }
    if (usesDTO)
    {
        strUpdateResult += "var resultDto = ";
        strUpdateParams += "dto";
        if (strUpdateResultTS != string.Empty)
            strUpdateResultTS = Environment.NewLine + new string(' ', 16) + strUpdateResultTS;
    }
    else
        strUpdateParams += Environment.NewLine + new string(' ', 24);
    %>

        /// <summary>
        /// Updates in the database all changes made to the <see cref="<%= Info.ObjectName %>"/> object.
        /// </summary>
        [Update]
        <%
    if (Info.TransactionType == TransactionType.EnterpriseServices)
    {
        %>[Transactional(TransactionalTypes.EnterpriseServices)]
        <%
    }
    else if (Info.TransactionType == TransactionType.TransactionScope || Info.TransactionType == TransactionType.TransactionScope)
    {
        %>[Transactional(TransactionalTypes.TransactionScope)]
        <%
    }
    if (Info.InsertUpdateRunLocal)
    {
        %>[RunLocal]
        <%
    }
        %>protected void Update([Inject] I<%= Info.ObjectName %>Dal dal)
        {
            <%
    if (TemplateHelper.UseSimpleAuditTrail(Info))
    {
        %>SimpleAuditTrail();
            <%
    }%>using (BypassPropertyChecks)
            {    
    <%if (usesDTO)
    {
        %>
                var dto = new <%= Info.ObjectName %>Dto();<%= strUpdateDto %>
            <%
    }
    %>
                var args = new DataPortalHookArgs(<%= usesDTO ? "dto" : "" %>);
                OnUpdatePre(args);
                <%= strUpdateResult %>dal.Update(<%= strUpdateParams %>)<%= propUpdatePropertyInfo ? ")" : "" %>;<%= strUpdateResultTS %><%= strUpdateResultOP %>
                <%
                if (usesDTO)
                {
                    %>
                args = new DataPortalHookArgs(resultDto);
                <%
                }
                %>
                OnUpdatePost(args);
            }
                <%
    if (Info.GetMyChildReadWriteProperties().Count > 0)
    {
        string ucpSpacer = new string(' ', 4);
        %>
<!-- #include file="UpdateChildProperties.asp" -->
                <%
    }
    %>
        }
    <%
}
%>
