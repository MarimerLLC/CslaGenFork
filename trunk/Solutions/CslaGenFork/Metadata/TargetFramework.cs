using System.ComponentModel;
using CslaGenerator.Design;

namespace CslaGenerator.Metadata
{
    [TypeConverter(typeof(EnumDescriptionOrCaseConverter))]
    public enum TargetFramework
    {
        [Description("CSLA 4.0")]
        CSLA40,
        [Description("CSLA 4.0 DAL")]
        CSLA40DAL,
        [Description("CSLA 4.5")]
        CSLA45,
        [Description("CSLA 4.5 DAL")]
        CSLA45DAL,
        [Description("CSLA 5.0")]
        CSLA50,
        [Description("CSLA 5.0 DAL")]
        CSLA50DAL,
        [Description("CSLA 6.0")]
        CSLA60,
        [Description("CSLA 6.0 DAL")]
        CSLA60DAL
    }
}