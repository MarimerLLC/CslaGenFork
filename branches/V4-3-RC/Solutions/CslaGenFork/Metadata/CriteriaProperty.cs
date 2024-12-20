using System.ComponentModel;
using System.Drawing.Design;
using System.Xml.Serialization;
using CslaGenerator.Attributes;
using CslaGenerator.Design;

namespace CslaGenerator.Metadata
{
    public class CriteriaProperty : Property, IBoundProperty
    {
        private DbBindColumn _dbBindColumn = new DbBindColumn();
        private string _parameterValue = string.Empty;
        private string _unitOfWorkFactoryParameter = string.Empty;

        public CriteriaProperty()
        {
            base.ReadOnly = true;
        }

        public CriteriaProperty(Property p)
            : base(p)
        {
        }

        public CriteriaProperty(string name, TypeCodeEx type, string parameterName)
            : base(name, type, parameterName)
        {
        }

        public CriteriaProperty(string name, TypeCodeEx type)
            : base(name, type)
        {
        }

        [Category("00. Database")]
        [Editor(typeof(DbBindColumnEditor), typeof(UITypeEditor))]
        [TypeConverter(typeof(DbBindColumnConverter))]
        [Description("The database column this property is bound to.")]
        [UserFriendlyName("DB Bind Column")]
        public DbBindColumn DbBindColumn
        {
            get { return _dbBindColumn; }
            set
            {
                _dbBindColumn = value;
                ResetProperties(value);
            }
        }

        [Category("01. Definition")]
        [Description("The property name.")]
        public override string Name
        {
            get { return base.Name; }
            set { base.Name = PropertyHelper.Tidy(value); }
        }

        [Category("01. Definition")]
        [Description("The property Type.")]
        [UserFriendlyName("Property Type")]
        public override TypeCodeEx PropertyType
        {
            get { return base.PropertyType; }
            set { base.PropertyType = value; }
        }

        [Category("01. Definition")]
        [Description("Whether this property can be changed by other classes.")]
        public override bool ReadOnly
        {
            get { return base.ReadOnly; }
            set { base.ReadOnly = value; }
        }

        [Category("01. Definition")]
        [Description("Whether this property can have a null value. The following types can't be null: \"ByteArray \", \"DBNull \", \"Object\" and \"Empty\".")]
        public override bool Nullable
        {
            get { return base.Nullable; }
            set { base.Nullable = value; }
        }

        [Category("01. Definition")]
        [Description("The fixed parameter value is used as filter criteria.")]
        [UserFriendlyName("Parameter Value")]
        public string ParameterValue
        {
            get { return _parameterValue; }
            set { _parameterValue = PropertyHelper.TidyAllowSpaces(value); }
        }

        [Browsable(false)]
        [XmlIgnore]
        public string UnitOfWorkFactoryParameter
        {
            get { return _unitOfWorkFactoryParameter; }
            set { _unitOfWorkFactoryParameter = value; }
        }

        internal static CriteriaProperty Clone(CriteriaProperty masterCritProp)
        {
            var newCritProp = new CriteriaProperty();
            newCritProp.DbBindColumn = (DbBindColumn)masterCritProp.DbBindColumn.Clone();
            ((Property)newCritProp).Clone(masterCritProp);
            newCritProp.ParameterValue = masterCritProp.ParameterValue;
            return newCritProp;
        }
    }
}