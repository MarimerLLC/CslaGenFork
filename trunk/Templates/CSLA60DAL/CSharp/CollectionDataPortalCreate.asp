<%
    bool dependentAllowNew3 = false;
    bool dependentAllowEdit3 = false;
    bool dependentAllowRemove3 = false;
    if (!TypeHelper.IsReadOnlyType(Info.ObjectType) && TypeHelper.IsCollectionType(Info.ObjectType))
    {
        if ((CurrentUnit.GenerationParams.GenerateAuthorization != AuthorizationLevel.None &&
            CurrentUnit.GenerationParams.GenerateAuthorization != AuthorizationLevel.PropertyLevel) &&
            ((itemInfo.NewRoles.Trim() != String.Empty) ||
            (itemInfo.UpdateRoles.Trim() != String.Empty) ||
            (itemInfo.DeleteRoles.Trim() != String.Empty)))
        {
            if (Info.AllowNew && itemInfo.NewRoles.Trim() != String.Empty)
                dependentAllowNew3 = true;
            if (Info.AllowEdit && itemInfo.UpdateRoles.Trim() != String.Empty)
                dependentAllowEdit3 = true;
            if (Info.AllowRemove && itemInfo.DeleteRoles.Trim() != String.Empty)
                dependentAllowRemove3 = true;
        }
    }

    string dataPortalCreate = string.Empty;
    if (isChildNotLazyLoaded)
        dataPortalCreate = "[CreateChild]";
    else
        dataPortalCreate = "[Create]";
%>

        <%= dataPortalCreate %>
        protected void Create()
        {
            var rlce = RaiseListChangedEvents;
            RaiseListChangedEvents = false;
            AllowNew = <%= dependentAllowNew3 ? Info + ".CanAddObject(ApplicationContext)" : Info.AllowNew.ToString().ToLower() %>;
            AllowEdit = <%= dependentAllowEdit3 ? Info + ".CanEditObject(ApplicationContext)" : Info.AllowEdit.ToString().ToLower() %>;
            AllowRemove = <%= dependentAllowRemove3 ? Info + ".CanDeleteObject(ApplicationContext)" : Info.AllowRemove.ToString().ToLower() %>;
            RaiseListChangedEvents = rlce;
        }
        