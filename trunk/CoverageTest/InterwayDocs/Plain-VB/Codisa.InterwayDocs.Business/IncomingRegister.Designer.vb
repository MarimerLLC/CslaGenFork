Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports Csla
Imports Csla.Data
Imports Codisa.InterwayDocs.Business.Properties
Imports Codisa.InterwayDocs.Rules
Imports Csla.Rules

Namespace Codisa.InterwayDocs.Business

    ''' <summary>
    ''' IncomingRegister (editable root object).<br/>
    ''' This is a generated base class of <see cref="IncomingRegister"/> business object.
    ''' </summary>
    <Serializable>
    Public Partial Class IncomingRegister
        Inherits EditOnDemandBase(Of IncomingRegister)
        Implements IHaveAudit

        #Region " Static Fields "

            Private Shared _lastId As Integer

        #End Region

        #Region " Business Properties "

        ''' <summary>
        ''' Maintains metadata about <see cref="RegisterId"/> property.
        ''' </summary>
        <NotUndoable>
        Public Shared ReadOnly RegisterIdProperty As PropertyInfo(Of Integer) = RegisterProperty(Of Integer)(Function(p) p.RegisterId, "Register Id")
        ''' <summary>
        ''' Gets the Register Id.
        ''' </summary>
        ''' <value>The Register Id.</value>
        Public ReadOnly Property RegisterId As Integer
            Get
                Return GetProperty(RegisterIdProperty)
            End Get
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="RegisterDate"/> property.
        ''' </summary>
        Public Shared ReadOnly RegisterDateProperty As PropertyInfo(Of SmartDate) = RegisterProperty(Of SmartDate)(Function(p) p.RegisterDate, "Data de registo")
        ''' <summary>
        ''' Gets or sets the Data de registo.
        ''' </summary>
        ''' <value>The Data de registo.</value>
        Public Property RegisterDate As String
            Get
                Return GetPropertyConvert(Of SmartDate, String)(RegisterDateProperty)
            End Get
            Set(ByVal value As String)
                SetPropertyConvert(Of SmartDate, String)(RegisterDateProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="DocumentType"/> property.
        ''' </summary>
        Public Shared ReadOnly DocumentTypeProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.DocumentType, "Tipo")
        ''' <summary>
        ''' Gets or sets the Tipo.
        ''' </summary>
        ''' <value>The Tipo.</value>
        Public Property DocumentType As String
            Get
                Return GetProperty(DocumentTypeProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(DocumentTypeProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="DocumentReference"/> property.
        ''' </summary>
        Public Shared ReadOnly DocumentReferenceProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.DocumentReference, "Número")
        ''' <summary>
        ''' Gets or sets the Número.
        ''' </summary>
        ''' <value>The Número.</value>
        Public Property DocumentReference As String
            Get
                Return GetProperty(DocumentReferenceProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(DocumentReferenceProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="DocumentEntity"/> property.
        ''' </summary>
        Public Shared ReadOnly DocumentEntityProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.DocumentEntity, "Entidade")
        ''' <summary>
        ''' Gets or sets the Entidade.
        ''' </summary>
        ''' <value>The Entidade.</value>
        Public Property DocumentEntity As String
            Get
                Return GetProperty(DocumentEntityProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(DocumentEntityProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="DocumentDept"/> property.
        ''' </summary>
        Public Shared ReadOnly DocumentDeptProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.DocumentDept, "Departamento")
        ''' <summary>
        ''' Gets or sets the Departamento.
        ''' </summary>
        ''' <value>The Departamento.</value>
        Public Property DocumentDept As String
            Get
                Return GetProperty(DocumentDeptProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(DocumentDeptProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="DocumentClass"/> property.
        ''' </summary>
        Public Shared ReadOnly DocumentClassProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.DocumentClass, "Classificação")
        ''' <summary>
        ''' Gets or sets the Classificação.
        ''' </summary>
        ''' <value>The Classificação.</value>
        Public Property DocumentClass As String
            Get
                Return GetProperty(DocumentClassProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(DocumentClassProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="DocumentDate"/> property.
        ''' </summary>
        Public Shared ReadOnly DocumentDateProperty As PropertyInfo(Of SmartDate) = RegisterProperty(Of SmartDate)(Function(p) p.DocumentDate, "Data do documento")
        ''' <summary>
        ''' Gets or sets the Data do documento.
        ''' </summary>
        ''' <value>The Data do documento.</value>
        Public Property DocumentDate As String
            Get
                Return GetPropertyConvert(Of SmartDate, String)(DocumentDateProperty)
            End Get
            Set(ByVal value As String)
                SetPropertyConvert(Of SmartDate, String)(DocumentDateProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="Subject"/> property.
        ''' </summary>
        Public Shared ReadOnly SubjectProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.Subject, "Assunto")
        ''' <summary>
        ''' Gets or sets the Assunto.
        ''' </summary>
        ''' <value>The Assunto.</value>
        Public Property Subject As String
            Get
                Return GetProperty(SubjectProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(SubjectProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="SenderName"/> property.
        ''' </summary>
        Public Shared ReadOnly SenderNameProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.SenderName, "Proveniência")
        ''' <summary>
        ''' Gets or sets the Proveniência.
        ''' </summary>
        ''' <value>The Proveniência.</value>
        Public Property SenderName As String
            Get
                Return GetProperty(SenderNameProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(SenderNameProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="ReceptionDate"/> property.
        ''' </summary>
        Public Shared ReadOnly ReceptionDateProperty As PropertyInfo(Of SmartDate) = RegisterProperty(Of SmartDate)(Function(p) p.ReceptionDate, "Data de recepção")
        ''' <summary>
        ''' Gets or sets the Data de recepção.
        ''' </summary>
        ''' <value>The Data de recepção.</value>
        Public Property ReceptionDate As String
            Get
                Return GetPropertyConvert(Of SmartDate, String)(ReceptionDateProperty)
            End Get
            Set(ByVal value As String)
                SetPropertyConvert(Of SmartDate, String)(ReceptionDateProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="RoutedTo"/> property.
        ''' </summary>
        Public Shared ReadOnly RoutedToProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.RoutedTo, "Encaminhamento")
        ''' <summary>
        ''' Gets or sets the Encaminhamento.
        ''' </summary>
        ''' <value>The Encaminhamento.</value>
        Public Property RoutedTo As String
            Get
                Return GetProperty(RoutedToProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(RoutedToProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="Notes"/> property.
        ''' </summary>
        Public Shared ReadOnly NotesProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.Notes, "Observações")
        ''' <summary>
        ''' Gets or sets the Observações.
        ''' </summary>
        ''' <value>The Observações.</value>
        Public Property Notes As String
            Get
                Return GetProperty(NotesProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(NotesProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="ArchiveLocation"/> property.
        ''' </summary>
        Public Shared ReadOnly ArchiveLocationProperty As PropertyInfo(Of String) = RegisterProperty(Of String)(Function(p) p.ArchiveLocation, "Localização")
        ''' <summary>
        ''' Gets or sets the Localização.
        ''' </summary>
        ''' <value>The Localização.</value>
        Public Property ArchiveLocation As String
            Get
                Return GetProperty(ArchiveLocationProperty)
            End Get
            Set(ByVal value As String)
                SetProperty(ArchiveLocationProperty, value)
            End Set
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="CreateDate"/> property.
        ''' </summary>
        Public Shared ReadOnly CreateDateProperty As PropertyInfo(Of SmartDate) = RegisterProperty(Of SmartDate)(Function(p) p.CreateDate, "Create Date")
        ''' <summary>
        ''' Gets the Create Date.
        ''' </summary>
        ''' <value>The Create Date.</value>
        Public ReadOnly Property CreateDate As SmartDate
            Get
                Return GetProperty(CreateDateProperty)
            End Get
        End Property

        ''' <summary>
        ''' Maintains metadata about <see cref="ChangeDate"/> property.
        ''' </summary>
        Public Shared ReadOnly ChangeDateProperty As PropertyInfo(Of SmartDate) = RegisterProperty(Of SmartDate)(Function(p) p.ChangeDate, "Change Date")
        ''' <summary>
        ''' Gets the Change Date.
        ''' </summary>
        ''' <value>The Change Date.</value>
        Public ReadOnly Property ChangeDate As SmartDate
            Get
                Return GetProperty(ChangeDateProperty)
            End Get
        End Property

        #End Region

        #Region " Factory Methods "

        ''' <summary>
        ''' Factory method. Creates a new <see cref="IncomingRegister"/> object.
        ''' </summary>
        ''' <returns>A reference to the created <see cref="IncomingRegister"/> object.</returns>
        Public Shared Function NewIncomingRegister() As IncomingRegister
            Return DataPortal.Create(Of IncomingRegister)()
        End Function

        ''' <summary>
        ''' Factory method. Loads a <see cref="IncomingRegister"/> object, based on given parameters.
        ''' </summary>
        ''' <param name="registerId">The RegisterId parameter of the IncomingRegister to fetch.</param>
        ''' <returns>A reference to the fetched <see cref="IncomingRegister"/> object.</returns>
        Public Shared Function GetIncomingRegister(registerId As Integer) As IncomingRegister
            Return DataPortal.Fetch(Of IncomingRegister)(registerId)
        End Function

        #End Region

        #Region " Constructor "

        ''' <summary>
        ''' Initializes a new instance of the <see cref="IncomingRegister"/> class.
        ''' </summary>
        ''' <remarks> Do not use to create a Csla object. Use factory methods instead.</remarks>
        <System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Never)>
        Public Sub New()
            ' Use factory methods and do not use direct creation.
        End Sub

        #End Region

        #Region " Business Rules and Property Authorization "

        ''' <summary>
        ''' Override this method in your business class to be notified when you need to set up shared business rules.
        ''' </summary>
        ''' <remarks>
        ''' This method is automatically called by CSLA.NET when your object should associate
        ''' per-type validation rules with its properties.
        ''' </remarks>
        Protected Overrides Sub AddBusinessRules()
            MyBase.AddBusinessRules()

            ' Property Business Rules

            ' RegisterDate
            BusinessRules.AddRule(New DateNotInFuture(RegisterDateProperty) With { .MessageDelegate = () => Resources.DateNotInFuture, .Priority = 1 })
            ' DocumentType
            BusinessRules.AddRule(New CollapseWhiteSpace(DocumentTypeProperty) With { .Priority = 1 })
            ' DocumentReference
            BusinessRules.AddRule(New CollapseWhiteSpace(DocumentReferenceProperty) With { .Priority = 1 })
            ' DocumentEntity
            BusinessRules.AddRule(New CollapseWhiteSpace(DocumentEntityProperty) With { .Priority = 1 })
            ' DocumentDept
            BusinessRules.AddRule(New CollapseWhiteSpace(DocumentDeptProperty) With { .Priority = 1 })
            ' DocumentClass
            BusinessRules.AddRule(New ClassificationFormat(DocumentClassProperty) With { .Priority = 1 })
            ' DocumentDate
            BusinessRules.AddRule(New DateNotInFuture(DocumentDateProperty) With { .MessageDelegate = () => Resources.DateNotInFuture, .Priority = 1 })
            ' Subject
            BusinessRules.AddRule(New CollapseSpace(SubjectProperty) With { .Priority = 1 })
            ' SenderName
            BusinessRules.AddRule(New CollapseWhiteSpace(SenderNameProperty) With { .Priority = 1 })
            ' ReceptionDate
            BusinessRules.AddRule(New DateNotInFuture(ReceptionDateProperty) With { .MessageDelegate = () => Resources.DateNotInFuture, .Priority = 1 })
            ' RoutedTo
            BusinessRules.AddRule(New CollapseWhiteSpace(RoutedToProperty) With { .Priority = 1 })
            ' Notes
            BusinessRules.AddRule(New CollapseSpace(NotesProperty))
            ' ArchiveLocation
            BusinessRules.AddRule(New CollapseWhiteSpace(ArchiveLocationProperty))

            AddBusinessRulesExtend()
        End Sub

        ''' <summary>
        ''' Allows the set up of custom shared business rules.
        ''' </summary>
        Partial Private Sub AddBusinessRulesExtend()
        End Sub

        #End Region

        #Region " Data Access "

        ''' <summary>
        ''' Loads default values for the <see cref="IncomingRegister"/> object properties.
        ''' </summary>
        <RunLocal>
        Protected Overrides Sub DataPortal_Create()
            LoadProperty(RegisterIdProperty, System.Threading.Interlocked.Decrement(_lastId))
            LoadProperty(RegisterDateProperty, new SmartDate(DateTime.Today))
            LoadProperty(DocumentTypeProperty, string.Empty)
            LoadProperty(DocumentReferenceProperty, string.Empty)
            LoadProperty(DocumentEntityProperty, string.Empty)
            LoadProperty(DocumentDeptProperty, string.Empty)
            LoadProperty(DocumentClassProperty, string.Empty)
            LoadProperty(SubjectProperty, string.Empty)
            LoadProperty(SenderNameProperty, string.Empty)
            LoadProperty(RoutedToProperty, string.Empty)
            LoadProperty(NotesProperty, string.Empty)
            LoadProperty(ArchiveLocationProperty, string.Empty)
            LoadProperty(CreateDateProperty, new SmartDate(DateTime.Now))
            LoadProperty(ChangeDateProperty, ReadProperty(CreateDateProperty))
            Dim args As New DataPortalHookArgs()
            OnCreate(args)
            MyBase.DataPortal_Create()
        End Sub

        ''' <summary>
        ''' Loads a <see cref="IncomingRegister"/> object from the database, based on given criteria.
        ''' </summary>
        ''' <param name="registerId">The Register Id.</param>
        Protected Sub DataPortal_Fetch(registerId As Integer)
            Using ctx = ConnectionManager(Of SqlConnection).GetManager(Database.InterwayDocsConnection, False)
                Using cmd = New SqlCommand("dbo.GetIncomingRegister", ctx.Connection)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@RegisterId", registerId).DbType = DbType.Int32
                    Dim args As New DataPortalHookArgs(cmd, registerId)
                    OnFetchPre(args)
                    Fetch(cmd)
                    OnFetchPost(args)
                End Using
            End Using
        End Sub

        Private Sub Fetch(cmd As SqlCommand)
            Using dr As New SafeDataReader(cmd.ExecuteReader())
                If dr.Read() Then
                    Fetch(dr)
                End If
            End Using
        End Sub

        ''' <summary>
        ''' Loads a <see cref="IncomingRegister"/> object from the given SafeDataReader.
        ''' </summary>
        ''' <param name="dr">The SafeDataReader to use.</param>
        Private Sub Fetch(dr As SafeDataReader)
            ' Value properties
            LoadProperty(RegisterIdProperty, dr.GetInt32("RegisterId"))
            LoadProperty(RegisterDateProperty, dr.GetSmartDate("RegisterDate", True))
            LoadProperty(DocumentTypeProperty, dr.GetString("DocumentType"))
            LoadProperty(DocumentReferenceProperty, dr.GetString("DocumentReference"))
            LoadProperty(DocumentEntityProperty, dr.GetString("DocumentEntity"))
            LoadProperty(DocumentDeptProperty, dr.GetString("DocumentDept"))
            LoadProperty(DocumentClassProperty, dr.GetString("DocumentClass"))
            LoadProperty(DocumentDateProperty, dr.GetSmartDate("DocumentDate", True))
            LoadProperty(SubjectProperty, dr.GetString("Subject"))
            LoadProperty(SenderNameProperty, dr.GetString("SenderName"))
            LoadProperty(ReceptionDateProperty, dr.GetSmartDate("ReceptionDate", True))
            LoadProperty(RoutedToProperty, dr.GetString("RoutedTo"))
            LoadProperty(NotesProperty, dr.GetString("Notes"))
            LoadProperty(ArchiveLocationProperty, dr.GetString("ArchiveLocation"))
            LoadProperty(CreateDateProperty, dr.GetSmartDate("CreateDate", True))
            LoadProperty(ChangeDateProperty, dr.GetSmartDate("ChangeDate", True))
            Dim args As New DataPortalHookArgs(dr)
            OnFetchRead(args)
        End Sub

        ''' <summary>
        ''' Inserts a new <see cref="IncomingRegister"/> object in the database.
        ''' </summary>
        Protected Overrides Sub DataPortal_Insert()
            SimpleAuditTrail()
            Using ctx = TransactionManager(Of SqlConnection, SqlTransaction).GetManager(Database.InterwayDocsConnection, False)
                Using cmd = New SqlCommand("dbo.AddIncomingRegister", ctx.Connection)
                    cmd.Transaction = ctx.Transaction
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@RegisterId", ReadProperty(RegisterIdProperty)).Direction = ParameterDirection.Output
                    cmd.Parameters.AddWithValue("@RegisterDate", ReadProperty(RegisterDateProperty).DBValue).DbType = DbType.Date
                    cmd.Parameters.AddWithValue("@DocumentType", ReadProperty(DocumentTypeProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@DocumentReference", ReadProperty(DocumentReferenceProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@DocumentEntity", ReadProperty(DocumentEntityProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@DocumentDept", ReadProperty(DocumentDeptProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@DocumentClass", ReadProperty(DocumentClassProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@DocumentDate", ReadProperty(DocumentDateProperty).DBValue).DbType = DbType.Date
                    cmd.Parameters.AddWithValue("@Subject", ReadProperty(SubjectProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@SenderName", ReadProperty(SenderNameProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@ReceptionDate", ReadProperty(ReceptionDateProperty).DBValue).DbType = DbType.Date
                    cmd.Parameters.AddWithValue("@RoutedTo", ReadProperty(RoutedToProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@Notes", ReadProperty(NotesProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@ArchiveLocation", ReadProperty(ArchiveLocationProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@CreateDate", ReadProperty(CreateDateProperty).DBValue).DbType = DbType.DateTime2
                    cmd.Parameters.AddWithValue("@ChangeDate", ReadProperty(ChangeDateProperty).DBValue).DbType = DbType.DateTime2
                    Dim args As New DataPortalHookArgs(cmd)
                    OnInsertPre(args)
                    cmd.ExecuteNonQuery()
                    OnInsertPost(args)
                    LoadProperty(RegisterIdProperty, DirectCast(cmd.Parameters("@RegisterId").Value, Integer))
                End Using
                ctx.Commit()
            End Using
        End Sub

        ''' <summary>
        ''' Updates in the database all changes made to the <see cref="IncomingRegister"/> object.
        ''' </summary>
        Protected Overrides Sub DataPortal_Update()
            SimpleAuditTrail()
            Using ctx = TransactionManager(Of SqlConnection, SqlTransaction).GetManager(Database.InterwayDocsConnection, False)
                Using cmd = New SqlCommand("dbo.UpdateIncomingRegister", ctx.Connection)
                    cmd.Transaction = ctx.Transaction
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@RegisterId", ReadProperty(RegisterIdProperty)).DbType = DbType.Int32
                    cmd.Parameters.AddWithValue("@RegisterDate", ReadProperty(RegisterDateProperty).DBValue).DbType = DbType.Date
                    cmd.Parameters.AddWithValue("@DocumentType", ReadProperty(DocumentTypeProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@DocumentReference", ReadProperty(DocumentReferenceProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@DocumentEntity", ReadProperty(DocumentEntityProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@DocumentDept", ReadProperty(DocumentDeptProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@DocumentClass", ReadProperty(DocumentClassProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@DocumentDate", ReadProperty(DocumentDateProperty).DBValue).DbType = DbType.Date
                    cmd.Parameters.AddWithValue("@Subject", ReadProperty(SubjectProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@SenderName", ReadProperty(SenderNameProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@ReceptionDate", ReadProperty(ReceptionDateProperty).DBValue).DbType = DbType.Date
                    cmd.Parameters.AddWithValue("@RoutedTo", ReadProperty(RoutedToProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@Notes", ReadProperty(NotesProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@ArchiveLocation", ReadProperty(ArchiveLocationProperty)).DbType = DbType.String
                    cmd.Parameters.AddWithValue("@ChangeDate", ReadProperty(ChangeDateProperty).DBValue).DbType = DbType.DateTime2
                    Dim args As New DataPortalHookArgs(cmd)
                    OnUpdatePre(args)
                    cmd.ExecuteNonQuery()
                    OnUpdatePost(args)
                End Using
                ctx.Commit()
            End Using
        End Sub

        Private Sub SimpleAuditTrail()
            LoadProperty(ChangeDateProperty, Date.Now)
            If IsNew Then
                LoadProperty(CreateDateProperty, ReadProperty(ChangeDateProperty))
            End If
        End Sub

        #End Region

        #Region " DataPortal Hooks "

        ''' <summary>
        ''' Occurs after setting all defaults for object creation.
        ''' </summary>
        Partial Private Sub OnCreate(args As DataPortalHookArgs)
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
