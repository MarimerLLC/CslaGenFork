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
bool isFirstCDPFDO = true;
foreach (Criteria c in Info.CriteriaObjects)
{
    lastCriteria = "";
    if (c.GetOptions.DataPortal)
    {
        if (isFirstCDPFDO)
            isFirstCDPFDO = false;
        else
            Response.Write(Environment.NewLine);

        if (usesDTO)
        {
            %>
        /// <summary>
        /// Loads a <%= Info.ObjectName %> collection from the database.
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
            if (c.Properties.Count > 1)
            {
                lastCriteria = ReceiveMultipleCriteriaTypeless(c, true);
                if (useInlineQuery)
                    InlineQueryList.Add(new AdvancedGenerator.InlineQuery(c.GetOptions.ProcedureName, ReceiveMultipleCriteria(c, true)));
                %>
        /// <returns>A list of <see cref="<%= Info.ItemType %>Dto"/>.</returns>
        public List<<%= Info.ItemType %>Dto> Fetch<%= c.GetOptions.FactorySuffix %>(<%= ReceiveMultipleCriteria(c) %>)
        <%
            }
            else if (c.Properties.Count > 0)
            {
                lastCriteria = ReceiveSingleCriteriaTypeless(c, "crit", true);
                if (useInlineQuery)
                    InlineQueryList.Add(new AdvancedGenerator.InlineQuery(c.GetOptions.ProcedureName, ReceiveSingleCriteria(c, "crit", true)));
                %>
        /// <returns>A list of <see cref="<%= Info.ItemType %>Dto"/>.</returns>
        public List<<%= Info.ItemType %>Dto> Fetch<%= c.GetOptions.FactorySuffix %>(<%= ReceiveSingleCriteria(c, "crit") %>)
        <%
            }
            else
            {
                lastCriteria = "";
                if (useInlineQuery)
                    InlineQueryList.Add(new AdvancedGenerator.InlineQuery(c.GetOptions.ProcedureName, ""));
                %>
        /// <returns>A list of <see cref="<%= Info.ItemType %>Dto"/>.</returns>
        public List<<%= Info.ItemType %>Dto> Fetch<%= c.GetOptions.FactorySuffix %>()
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
        /// Loads a <%= Info.ObjectName %> collection from the database.
        /// </summary>
        <%= strGetComment %>/// <returns>A data reader to the <%= Info.ObjectName %>.</returns>
        public IDataReader Fetch<%= c.GetOptions.FactorySuffix %>(<%= strGetCritParams %>)
        <%
        }
        %>
        {
            <%
            bool needsIndent = true;
            %>
            <%= GetConnection(Info, true) %>
            {
            <%= AddIndent(needsIndent)%><%= GetCommand(Info, c.GetOptions.ProcedureName, useInlineQuery, lastCriteria) %>
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
            foreach (CriteriaProperty p in c.Properties)
            {
                if (!usesDTO)
                {
                    %>
                    <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= p.ParameterName %>", <%= GetParameterSet(Info, p, false, true) %><%= (p.PropertyType == TypeCodeEx.SmartDate ? ".DBValue" : "") %>).DbType = DbType.<%= TemplateHelper.GetDbType(p) %>;
                    <%
                }
                else
                {
                    if (c.Properties.Count > 1)
                    {
                        %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= p.ParameterName %>", <%= GetParameterSet(p, false, false, false) %><%= (p.PropertyType == TypeCodeEx.SmartDate ? ".DBValue" : "") %>).DbType = DbType.<%= TemplateHelper.GetDbType(p) %>;
                    <%
                    }
                    else
                    {
                        %>
                <%= AddIndent(needsIndent)%>cmd.Parameters.<%= AddParameterMethod %>("@<%= p.ParameterName %>", <%= AssignSingleCriteria(c, "crit") %><%= (p.PropertyType == TypeCodeEx.SmartDate ? ".DBValue" : "") %>).DbType = DbType.<%= TemplateHelper.GetDbType(p) %>;
                    <%
                    }
                }
            }
            if (!Info.DataSetLoadingScheme)
            {
                if (usesDTO)
                {
                    %>
                <%= AddIndent(needsIndent)%>var dr = cmd.ExecuteReader();
                <%= AddIndent(needsIndent)%>return LoadCollection(dr);
                        <%
                }
                else
                {
                    %>
                <%= AddIndent(needsIndent)%>return cmd.ExecuteReader();
                        <%
                }
            }
            else
            {
                %>
                <%= AddIndent(needsIndent)%>return LoadCollection(cmd);
                <%
            }
            %>
            <%= AddIndent(needsIndent)%>}
            }
        }
        <%
    }
}

if (usesDTO)
{
    if (!Info.DataSetLoadingScheme)
    {
    %>

        private List<<%= Info.ItemType %>Dto> LoadCollection(IDataReader data)
        {
            var <%= FormatCamel(Info.ObjectName) %> = new List<<%= Info.ItemType %>Dto>();
            using (var dr = new SafeDataReader(data))
            {
                while (dr.Read())
                {
                    <%= FormatCamel(Info.ObjectName) %>.Add(Fetch(dr));
                }
                <%
    if (ParentLoadsChildren(itemInfo))
    {
        %>
                if (<%= FormatCamel(Info.ObjectName) %>.Count > 0)
                    FetchChildren(dr);
                <%
    }
    %>
            }
            return <%= FormatCamel(Info.ObjectName) %>;
        }
    <%
    }
    else
    {
        %>
        private List<<%= Info.ItemType %>Dto> LoadCollection(<%= CommandMethod %> cmd)
        {
            DataSet ds = new DataSet();
            using (var da = new SqlDataAdapter(cmd))
            {
                da.Fill(ds);
            }
            CreateRelations(ds);
            return Fetch(ds.Tables[0].Rows);
        }
    
<!-- #include file="CreateRelations.asp" -->
    <%
    }
    %>

<!-- #include file="FetchItem_DalObject.asp" -->
<%
    if (ParentLoadsChildren(itemInfo))
    {
        %>
<!-- #include file="FetchChildren_DalObject.asp" -->
<%
    }
}
%>
