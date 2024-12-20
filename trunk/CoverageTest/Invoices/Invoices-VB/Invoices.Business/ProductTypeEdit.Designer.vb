Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports Csla
Imports Csla.Data

Namespace Invoices.Business

    ''' <summary>
    ''' ProductTypeEdit (editable root object).<br/>
    ''' This is a generated base class of <see cref="ProductTypeEdit"/> business object.
    ''' </summary>
    <Serializable>
    Public Partial Class ProductTypeEdit
        Inherits BusinessBase(Of ProductTypeEdit)

        #Region " Static Fields "

            Private Shared _lastId As Integer

        #End Region

        #Region " Business Properties "

        ''' <summary>
        ''' Maintains metadata about <see cref="ProductTypeId"/> property.
        ''' </summary>
        <NotUndoable>
        Public Shared ReadOnly ProductTypeIdProperty As PropertyInfo(Of Integer) = RegisterProperty(Of Integer)(Function(p) p.ProductTypeId, "Product Type Id")
        ''' <summary>
        ''' Gets the Product Type Id.
        ''' </summary>
        ''' <value>The Product Type Id.</value>
        Public ReadOnly Property ProductTypeId As Integer
            Get
                Return GetProperty(ProductTypeIdProperty)
            End Get
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="Name"/> property.
        ''' </summary>
        Public Shared ReadOnly NameProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.Name, "Name")
        ''' <summary>
        ''' Gets or sets the Name.
        ''' </summary>
        ''' <value>The Name.</value>
        Public Property Name As String
            Get
                Return GetProperty(NameProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(NameProperty, value)
            End Set
        End Property

        #End Region

        #Region " Factory Methods "

        ''' <summary>
        ''' Factory method. Creates a new <see cref="ProductTypeEdit"/> object.
        ''' </summary>
        ''' <returns>A reference to the created <see cref="ProductTypeEdit"/> object.</returns>
        Public Shared Function NewProductTypeEdit() As ProductTypeEdit
            Return DataPortal.Create(Of ProductTypeEdit)()
        End Function

        ''' <summary>
        ''' Factory method. Loads a <see cref="ProductTypeEdit"/> object, based on given parameters.
        ''' </summary>
        ''' <param name="productTypeId">The ProductTypeId parameter of the ProductTypeEdit to fetch.</param>
        ''' <returns>A reference to the fetched <see cref="ProductTypeEdit"/> object.</returns>
        Public Shared Function GetProductTypeEdit(productTypeId As Integer) As ProductTypeEdit
            Return DataPortal.Fetch(Of ProductTypeEdit)(productTypeId)
        End Function

        ''' <summary>
        ''' Factory method. Deletes a <see cref="ProductTypeEdit"/> object, based on given parameters.
        ''' </summary>
        ''' <param name="productTypeId">The ProductTypeId of the ProductTypeEdit to delete.</param>
        Public Shared Sub DeleteProductTypeEdit(productTypeId As Integer)
            DataPortal.Delete(Of ProductTypeEdit)(productTypeId)
        End Sub

        ''' <summary>
        ''' Factory method. Asynchronously creates a new <see cref="ProductTypeEdit"/> object.
        ''' </summary>
        ''' <param name="callback">The completion callback method.</param>
        Public Shared Sub NewProductTypeEdit(callback As EventHandler(Of DataPortalResult(Of ProductTypeEdit)))
            DataPortal.BeginCreate(Of ProductTypeEdit)(callback)
        End Sub

        ''' <summary>
        ''' Factory method. Asynchronously loads a <see cref="ProductTypeEdit"/> object, based on given parameters.
        ''' </summary>
        ''' <param name="productTypeId">The ProductTypeId parameter of the ProductTypeEdit to fetch.</param>
        ''' <param name="callback">The completion callback method.</param>
        Public Shared Sub GetProductTypeEdit(productTypeId As Integer, ByVal callback As EventHandler(Of DataPortalResult(Of ProductTypeEdit)))
            DataPortal.BeginFetch(Of ProductTypeEdit)(productTypeId, callback)
        End Sub

        ''' <summary>
        ''' Factory method. Asynchronously deletes a <see cref="ProductTypeEdit"/> object, based on given parameters.
        ''' </summary>
        ''' <param name="productTypeId">The ProductTypeId of the ProductTypeEdit to delete.</param>
        ''' <param name="callback">The completion callback method.</param>
        Public Shared Sub DeleteProductTypeEdit(productTypeId As Integer, callback As EventHandler(Of DataPortalResult(Of ProductTypeEdit)))
            DataPortal.BeginDelete(Of ProductTypeEdit)(productTypeId, callback)
        End Sub

        #End Region

        #Region " Constructor "

        ''' <summary>
        ''' Initializes a new instance of the <see cref="ProductTypeEdit"/> class.
        ''' </summary>
        ''' <remarks> Do not use to create a Csla object. Use factory methods instead.</remarks>
        <System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Never)>
        Public Sub New()
            ' Use factory methods and do not use direct creation.
            AddHandler Saved, AddressOf OnProductTypeEditSaved
        End Sub

        #End Region

        #Region " Data Access "

        ''' <summary>
        ''' Loads default values for the <see cref="ProductTypeEdit"/> object properties.
        ''' </summary>
        <RunLocal>
        Protected Overrides Sub DataPortal_Create()
            LoadProperty(ProductTypeIdProperty, System.Threading.Interlocked.Decrement(_lastId))
            Dim args As New DataPortalHookArgs()
            OnCreate(args)
            MyBase.DataPortal_Create()
        End Sub

        ''' <summary>
        ''' Loads a <see cref="ProductTypeEdit"/> object from the database, based on given criteria.
        ''' </summary>
        ''' <param name="productTypeId">The Product Type Id.</param>
        Protected Sub DataPortal_Fetch(productTypeId As Integer)
            Using ctx = ConnectionManager(Of SqlConnection).GetManager("Invoices")
                Using cmd = New SqlCommand("dbo.GetProductTypeEdit", ctx.Connection)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ProductTypeId", productTypeId).DbType = DbType.Int32
                    Dim args As New DataPortalHookArgs(cmd, productTypeId)
                    OnFetchPre(args)
                    Fetch(cmd)
                    OnFetchPost(args)
                End Using
            End Using
            ' check all object rules and property rules
            BusinessRules.CheckRules()
        End Sub

        Private Sub Fetch(cmd As SqlCommand)
            Using dr As New SafeDataReader(cmd.ExecuteReader())
                If dr.Read() Then
                    Fetch(dr)
                End If
            End Using
        End Sub

        ''' <summary>
        ''' Loads a <see cref="ProductTypeEdit"/> object from the given SafeDataReader.
        ''' </summary>
        ''' <param name="dr">The SafeDataReader to use.</param>
        Private Sub Fetch(dr As SafeDataReader)
            ' Value properties
            LoadProperty(ProductTypeIdProperty, dr.GetInt32("ProductTypeId"))
            LoadProperty(NameProperty, dr.GetString("Name"))
            Dim args As New DataPortalHookArgs(dr)
            OnFetchRead(args)
        End Sub

        ''' <summary>
        ''' Inserts a new <see cref="ProductTypeEdit"/> object in the database.
        ''' </summary>
        <Transactional(TransactionalTypes.TransactionScope)>
        Protected Overrides Sub DataPortal_Insert()
            Using ctx = ConnectionManager(Of SqlConnection).GetManager("Invoices")
                Using cmd = New SqlCommand("dbo.AddProductTypeEdit", ctx.Connection)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ProductTypeId", ReadProperty(ProductTypeIdProperty)).Direction = ParameterDirection.Output
                    cmd.Parameters.AddWithValue("@Name", ReadProperty(NameProperty)).DbType = DbType.String
                    Dim args As New DataPortalHookArgs(cmd)
                    OnInsertPre(args)
                    cmd.ExecuteNonQuery()
                    OnInsertPost(args)
                    LoadProperty(ProductTypeIdProperty, DirectCast(cmd.Parameters("@ProductTypeId").Value, Integer))
                End Using
            End Using
        End Sub

        ''' <summary>
        ''' Updates in the database all changes made to the <see cref="ProductTypeEdit"/> object.
        ''' </summary>
        <Transactional(TransactionalTypes.TransactionScope)>
        Protected Overrides Sub DataPortal_Update()
            Using ctx = ConnectionManager(Of SqlConnection).GetManager("Invoices")
                Using cmd = New SqlCommand("dbo.UpdateProductTypeEdit", ctx.Connection)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ProductTypeId", ReadProperty(ProductTypeIdProperty)).DbType = DbType.Int32
                    cmd.Parameters.AddWithValue("@Name", ReadProperty(NameProperty)).DbType = DbType.String
                    Dim args As New DataPortalHookArgs(cmd)
                    OnUpdatePre(args)
                    cmd.ExecuteNonQuery()
                    OnUpdatePost(args)
                End Using
            End Using
        End Sub

        ''' <summary>
        ''' Self deletes the <see cref="ProductTypeEdit"/> object.
        ''' </summary>
        Protected Overrides Sub DataPortal_DeleteSelf()
            DataPortal_Delete(ProductTypeId)
        End Sub

        ''' <summary>
        ''' Deletes the <see cref="ProductTypeEdit"/> object from database.
        ''' </summary>
        ''' <param name="productTypeId">The delete criteria.</param>
        <Transactional(TransactionalTypes.TransactionScope)>
        Protected Sub DataPortal_Delete(productTypeId As Integer)
            Using ctx = ConnectionManager(Of SqlConnection).GetManager("Invoices")
                Using cmd = New SqlCommand("dbo.DeleteProductTypeEdit", ctx.Connection)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@ProductTypeId", productTypeId).DbType = DbType.Int32
                    Dim args As New DataPortalHookArgs(cmd, productTypeId)
                    OnDeletePre(args)
                    cmd.ExecuteNonQuery()
                    OnDeletePost(args)
                End Using
            End Using
        End Sub

        #End Region

        #Region " Saved Event "

        'TODO: edit "ProductTypeEdit.vb", uncomment the "OnDeserialized" method and add the following line:
        'TODO:     AddHandler Saved, AddressOf OnProductTypeEditSaved

        Private Sub OnProductTypeEditSaved(sender As Object, e As Csla.Core.SavedEventArgs)
                RaiseEvent ProductTypeEditSaved(sender, e)
        End Sub

        ''' <summary> Use this event to signal a <see cref="ProductTypeEdit"/> object was saved.</summary>
        Public Shared Event ProductTypeEditSaved As EventHandler(Of Csla.Core.SavedEventArgs)

        #End Region

        #Region " DataPortal Hooks "

        ''' <summary>
        ''' Occurs after setting all defaults for object creation.
        ''' </summary>
        Partial Private Sub OnCreate(args As DataPortalHookArgs)
        End Sub

        ''' <summary>
        ''' Occurs in DataPortal_Delete, after setting query parameters and before the delete operation.
        ''' </summary>
        Partial Private Sub OnDeletePre(args As DataPortalHookArgs)
        End Sub

        ''' <summary>
        ''' Occurs in DataPortal_Delete, after the delete operation, before Commit().
        ''' </summary>
        Partial Private Sub OnDeletePost(args As DataPortalHookArgs)
        End Sub

        ''' <summary>
        ''' Occurs after setting query parameters and before the fetch operation.
        ''' </summary>
        Partial Private Sub OnFetchPre(args As DataPortalHookArgs)
        End Sub

        ''' <summary>
        ''' Occurs after the fetch operation (object or collection is fully loaded and set up).
        ''' </summary>
        Partial Private Sub OnFetchPost(args As DataPortalHookArgs)
        End Sub

        ''' <summary>
        ''' Occurs after the low level fetch operation, before the data reader is destroyed.
        ''' </summary>
        Partial Private Sub OnFetchRead(args As DataPortalHookArgs)
        End Sub

        ''' <summary>
        ''' Occurs after setting query parameters and before the update operation.
        ''' </summary>
        Partial Private Sub OnUpdatePre(args As DataPortalHookArgs)
        End Sub

        ''' <summary>
        ''' Occurs in DataPortal_Insert, after the update operation, before setting back row identifiers (RowVersion) and Commit().
        ''' </summary>
        Partial Private Sub OnUpdatePost(args As DataPortalHookArgs)
        End Sub

        ''' <summary>
        ''' Occurs in DataPortal_Insert, after setting query parameters and before the insert operation.
        ''' </summary>
        Partial Private Sub OnInsertPre(args As DataPortalHookArgs)
        End Sub

        ''' <summary>
        ''' Occurs in DataPortal_Insert, after the insert operation, before setting back row identifiers (ID and RowVersion) and Commit().
        ''' </summary>
        Partial Private Sub OnInsertPost(args As DataPortalHookArgs)
        End Sub

        #End Region

    End Class

End Namespace
