<%
if (Info.GenerateDataPortalDelete)
{
    foreach (Criteria c in Info.CriteriaObjects)
    {
        if (c.DeleteOptions.DataPortal)
        {
            string strSelfDeleteCritParams = string.Empty;
            string strDeleteCritParams = string.Empty;
            string strDeleteInvokeParams = string.Empty;
            string strDeleteComment = string.Empty;
            bool deleteIsFirst = true;
            int propCount = 0;

            if (usesDTO)
            {
                foreach (CriteriaProperty p in c.Properties)
                {
                    if (!deleteIsFirst)
                    {
                        strSelfDeleteCritParams += ", ";
                        strDeleteCritParams += ", ";
                        strDeleteInvokeParams += ", ";
                        if (propCount > 0 && (c.Properties.Count <= 1 || c.CriteriaClassMode != CriteriaMode.MultiplePrimatives))
                          strDeleteComment += System.Environment.NewLine + new string(' ', 8);
                    }
                    else
                        deleteIsFirst = false;

                    strSelfDeleteCritParams += FormatGeneralParameter(Info, p, false, false, true);
                    strDeleteCritParams += p.Name;
                    strDeleteInvokeParams += FormatCamel(p.Name);
                    if (c.Properties.Count > 1 && c.CriteriaClassMode == CriteriaMode.MultiplePrimatives)
                    {
                      if (propCount > 0)
                        strDeleteComment += System.Environment.NewLine + new string(' ', 8);
                      strDeleteComment += "/// <param name=\"" + p.Name + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(p.Name) + ".</param>";
                    }
                    propCount++;
                }
                if (c.Properties.Count <= 1 || c.CriteriaClassMode != CriteriaMode.MultiplePrimatives)
                  strDeleteComment += "/// <param name=\"" + (c.Properties.Count > 1 ? "crit" : HookSingleCriteria(c, "crit")) + "\">The delete criteria.</param>";

                if (Info.IsEditableSwitchable())
                {
                    strSelfDeleteCritParams = "false, " + strSelfDeleteCritParams;
                    strDeleteCritParams = "false, " + strDeleteCritParams;
                }
                if ((c.Properties.Count > 1 && c.CriteriaClassMode != CriteriaMode.MultiplePrimatives) || (Info.IsEditableSwitchable() && c.Properties.Count == 1))
                {
                    strSelfDeleteCritParams = "new " + c.Name + "(" + strSelfDeleteCritParams + ")";
                    strDeleteCritParams = "new " + c.Name + "(" + strDeleteCritParams + ")";
                    strDeleteInvokeParams = SendMultipleCriteria(c, "crit");
                }
				else if (c.Properties.Count > 1 && c.CriteriaClassMode == CriteriaMode.MultiplePrimatives) 
                {
                    strDeleteInvokeParams = SendMultipleCriteria(c, "crit", (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives));
                }
                else if (c.Properties.Count > 0)
                {
                    strSelfDeleteCritParams = SendSingleCriteria(c, strSelfDeleteCritParams);
                    strDeleteCritParams = SendSingleCriteria(c, strDeleteCritParams);
                }
            }
            else
            {
                foreach (CriteriaProperty p in c.Properties)
                {
                    if (!deleteIsFirst)
                    {
                        strSelfDeleteCritParams += ", ";
                        strDeleteCritParams += ", ";
                        strDeleteInvokeParams += ", ";
                        strDeleteComment += System.Environment.NewLine + new string(' ', 8);
                    }
                    else
                        deleteIsFirst = false;

                    strSelfDeleteCritParams += FormatGeneralParameter(Info, p, false, false, true);
                    strDeleteCritParams += string.Concat(GetDataTypeGeneric(p, p.PropertyType), " ", FormatCamel(p.Name));
                    strDeleteInvokeParams += FormatCamel(p.Name);
                    strDeleteComment += "/// <param name=\"" + FormatCamel(p.Name) + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(p.Name) + ".</param>";
                }
            }
            %>
<% 
  if (Info.GenerateDataPortalDeleteSelf)
  {
%>
        /// <summary>
        /// Self deletes the <see cref="<%= Info.ObjectName %>"/> object.
        /// </summary>
        [DeleteSelf]
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
            %>protected void DeleteSelf([Inject] I<%= Info.ObjectName %>Dal dal)
        {
            using (BypassPropertyChecks)
            {
                Delete(<%= strSelfDeleteCritParams %>, dal);
            }
        }
        <%
  }
            deleteIsFirst = true;

            if (usesDTO)
            {
                %>

        /// <summary>
        /// Deletes the <see cref="<%= Info.ObjectName %>"/> object from database.
        /// </summary>
        <%= strDeleteComment %>
        [Delete]
        <%
                if (Info.TransactionType == TransactionType.EnterpriseServices)
                {
                    %>[Transactional(TransactionalTypes.EnterpriseServices)]
        <%
                }
                else if (Info.TransactionType == TransactionType.TransactionScope)
                {
                    %>[Transactional(TransactionalTypes.TransactionScope)]
        <%
                }
                if (c.DeleteOptions.RunLocal)
                {
                    %>[RunLocal]
        <%
                }
                if (c.Properties.Count > 1)
                {
					if (c.CriteriaClassMode != CriteriaMode.MultiplePrimatives)
					{
                    %>private void Delete(<%= c.Name %> crit, [Inject] I<%= Info.ObjectName %>Dal dal)<%
					}
					else
					{
					%>private void Delete(<%= ReceiveMultipleCriteria(c) %>, [Inject] I<%= Info.ObjectName %>Dal dal)<%
					}
                }
                else
                {
                    %>private void Delete(<%= ReceiveSingleCriteria(c, "crit") %>, [Inject] I<%= Info.ObjectName %>Dal dal)<%
                }
            }
            else
            {
                %>
        /// <summary>
        /// Deletes the <see cref="<%= Info.ObjectName %>"/> object from database.
        /// </summary>
        <%= strDeleteComment %>
        [Delete]
        <%
                if (Info.TransactionType == TransactionType.EnterpriseServices)
                {
                    %>[Transactional(TransactionalTypes.EnterpriseServices)]
        <%
                }
                else if (Info.TransactionType == TransactionType.TransactionScope)
                {
                    %>[Transactional(TransactionalTypes.TransactionScope)]
        <%
                }
                if (c.DeleteOptions.RunLocal)
                {
                    %>[RunLocal]
        <%
                }
                %>private void Delete(<%= strDeleteCritParams %>, [Inject] I<%= Info.ObjectName %>Dal dal))<%
            }
            %>
        {
            <%
            if (TemplateHelper.UseSimpleAuditTrail(Info))
            {
                %>// audit the object, just in case soft delete is used on this object
            SimpleAuditTrail();
            <%
            }
            %>var args = new DataPortalHookArgs();
                <%
            if (Info.GetMyChildReadWriteProperties().Count > 0)
            {
                string ucpSpacer = string.Empty;
                %>
<!-- #include file="UpdateChildProperties.asp" -->
                <%
            }
            %>
            OnDeletePre(args);
            dal.Delete(<%= strDeleteInvokeParams %>);
            OnDeletePost(args);
        }
            <%
        }
    }
}
%>
