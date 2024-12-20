<%
useInlineQuery = false;
if (CurrentUnit.GenerationParams.UseInlineQueries == UseInlineQueries.Always)
   useInlineQuery = true;
else if (CurrentUnit.GenerationParams.UseInlineQueries == UseInlineQueries.SpecifyByObject)
{
   foreach (string item in Info.GenerateInlineQueries)
   {
       if (item == "Read")
       {
           useInlineQuery = true;
           break;
       }
   }
}
bool isFirstMethod = true;
bool isFirstDPFDO = true;
foreach (Criteria c in Info.CriteriaObjects)
{
    lastCriteria = "";
    if (c.GetOptions.DataPortal)
    {
        if (isFirstDPFDO)
            isFirstDPFDO = false;
        else
            Response.Write(Environment.NewLine);

        if (usesDTO)
        {
            %>
        /// <summary>
        /// Loads a <%= Info.ObjectName %> object from the database.
        /// </summary>
        <%
            if (c.Properties.Count > 1)
            {
                foreach (Property prop in c.Properties)
                {
                    string param = FormatCamel(prop.Name);
                    %>
        /// <param name="<%= param %>">The <%= param %> parameter of the <%= Info.ObjectName %> to fetch.</param>
        <%
                }
            }
            else if (c.Properties.Count > 0)
            {
                %>
        /// <param name="<%= c.Properties.Count > 1 ? "crit" : HookSingleCriteria(c, "crit") %>">The fetch criteria.</param>
        <%
            }
            %>
        /// <returns>A <%= (isItem ? "list of " : "") %><%= (isItem ? Info.ItemType : Info.ObjectName) %>Dto<%= (isItem ? "" : " object") %>.</returns>
        <%
            if (c.Properties.Count > 1)
            {
                lastCriteria = ReceiveMultipleCriteriaTypeless(c, true);
                if (useInlineQuery)
                    InlineQueryList.Add(new AdvancedGenerator.InlineQuery(c.GetOptions.ProcedureName, ReceiveMultipleCriteria(c, true)));
                %>
        public <%= (isItem ? "List<" + Info.ItemType + "Dto>" : Info.ObjectName + "Dto") %> Fetch(<%= ReceiveMultipleCriteria(c) %>)
        <%
            }
            else if (c.Properties.Count > 0)
            {
                lastCriteria = ReceiveSingleCriteriaTypeless(c, "crit", true);
                if (useInlineQuery)
                    InlineQueryList.Add(new AdvancedGenerator.InlineQuery(c.GetOptions.ProcedureName, ReceiveSingleCriteria(c, "crit", true)));
                %>
        public <%= (isItem ? "List<" + Info.ItemType + "Dto>" : Info.ObjectName + "Dto") %> Fetch(<%= ReceiveSingleCriteria(c, "crit") %>)
        <%
            }
            else
            {
                lastCriteria = "";
                if (useInlineQuery)
                    InlineQueryList.Add(new AdvancedGenerator.InlineQuery(c.GetOptions.ProcedureName, ""));
                %>
        public <%= (isItem ? "List<" + Info.ItemType + "Dto>" : Info.ObjectName + "Dto") %> Fetch()
        <%
            }
        }
        else
        {
            string strGetCritParams = string.Empty;
            string lastCriteriaTyped = string.Empty;
            string strGetComment = string.Empty;
            bool getIsFirst = true;

            for (int i = 0; i < c.Properties.Count; i++)
            {
                if (!getIsFirst)
                {
                    strGetCritParams += ", ";
                    lastCriteriaTyped += ", ";
                    lastCriteria += ", ";
                }
                else
                    getIsFirst = false;

                strGetComment += "/// <param name=\"" + FormatCamel(c.Properties[i].Name) + "\">The " + CslaGenerator.Metadata.PropertyHelper.SplitOnCaps(c.Properties[i].Name) + ".</param>" + System.Environment.NewLine + new string(' ', 8);
                strGetCritParams += string.Concat(GetDataTypeGeneric(c.Properties[i], c.Properties[i].PropertyType), " ", FormatCamel(c.Properties[i].Name));
                lastCriteriaTyped += string.Concat(AddRefOrOut(c.Properties[i]) + GetDataTypeGeneric(c.Properties[i], c.Properties[i].PropertyType), " ", FormatCamel(c.Properties[i].Name));
                lastCriteria += AddRefOrOut(c.Properties[i]) + FormatCamel(c.Properties[i].Name);
            }

            if (useInlineQuery)
                InlineQueryList.Add(new AdvancedGenerator.InlineQuery(c.GetOptions.ProcedureName, lastCriteriaTyped));
            %>
        /// <summary>
        /// Loads a <%= Info.ObjectName %> object from the database.
        /// </summary>
        <%= strGetComment %>/// <returns>A data reader to the <%= Info.ObjectName %>.</returns>
        public IDataReader Fetch(<%= strGetCritParams %>)
        <%
        }
        %>
        {
            <%= GetConnection(Info, true) %>
            {
                <%= GetCommand(Info, c.GetOptions.ProcedureName, useInlineQuery, lastCriteria) %>
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
    foreach (CriteriaProperty p in c.Properties)
    {
        if (!usesDTO)
        {
            %>
                    cmd.Parameters.<%= AddParameterMethod %>("@<%= p.ParameterName %>", <%= GetParameterSet(Info, p, false, true) %><%= (p.PropertyType == TypeCodeEx.SmartDate ? ".DBValue" : "") %>).DbType = DbType.<%= TemplateHelper.GetDbType(p) %>;
                    <%
        }
        else
        {
            if (c.Properties.Count > 1)
            {
                %>
                    cmd.Parameters.<%= AddParameterMethod %>("@<%= p.ParameterName %>", <%= GetParameterSet(p, false, false, false) %><%= (p.PropertyType == TypeCodeEx.SmartDate ? ".DBValue" : "") %>).DbType = DbType.<%= TemplateHelper.GetDbType(p) %>;
                    <%
            }
            else
            {
                %>
                    cmd.Parameters.<%= AddParameterMethod %>("@<%= p.ParameterName %>", <%= AssignSingleCriteria(c, "crit") %><%= (p.PropertyType == TypeCodeEx.SmartDate ? ".DBValue" : "") %>).DbType = DbType.<%= TemplateHelper.GetDbType(p) %>;
                    <%
            }
        }
    }
    if (usesDTO)
    {
        %>
                    var dr = cmd.ExecuteReader();
                    return <%= isCollection ? "LoadCollection(dr)" : "Fetch(dr)" %>;
                    <%
    }
    else
    {
        %>
                    return cmd.ExecuteReader();
                    <%
    }
    %>
                }
            }
        }
        <%
    }
}
if (usesDTO)
{
    if (ancestorLoaderLevel == 0 || IsChildSelfLoaded(Info))
    {
    %>

<!-- #include file="Fetch_DalObject.asp" -->
<%
        if (ParentLoadsChildren(Info))
        {
            %>
<!-- #include file="FetchChildren_DalObject.asp" -->
<%
        }
    }
}
isFirstMethod = isFirstDPFDO;
%>
