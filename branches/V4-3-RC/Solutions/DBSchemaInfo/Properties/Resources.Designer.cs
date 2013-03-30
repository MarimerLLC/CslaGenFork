﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.225
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DBSchemaInfo.Properties {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    internal class Resources {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal Resources() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("DBSchemaInfo.Properties.Resources", typeof(Resources).Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to SELECT A.*, CASE WHEN B.COLUMN_NAME IS NULL THEN 0 ELSE 1 END AS IS_PRIMARY_KEY
        ///		, COLUMNPROPERTY(object_id(QUOTENAME(A.TABLE_SCHEMA) + &apos;.&apos; + QUOTENAME(A.TABLE_NAME)), A.COLUMN_NAME, &apos;isIdentity&apos;) AS IS_IDENTITY
        ///	FROM INFORMATION_SCHEMA.COLUMNS A
        ///	LEFT OUTER JOIN (
        ///	SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
        ///	WHERE CONSTRAINT_NAME IN (
        ///		SELECT CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
        ///		WHERE CONSTRAINT_TYPE = &apos;PRIMARY KEY&apos;)
        ///	) B
        ///	ON A.TABLE_CATALOG = B.TABLE_CATALOG
        ///	AND  [rest of string was truncated]&quot;;.
        /// </summary>
        internal static string SqlServerGetColumn {
            get {
                return ResourceManager.GetString("SqlServerGetColumn", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to select PARAMETER_NAME, SPECIFIC_CATALOG, SPECIFIC_SCHEMA, SPECIFIC_NAME, ORDINAL_POSITION, PARAMETER_MODE, DATA_TYPE,
        ///CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE, DATETIME_PRECISION
        ///from information_schema.PARAMETERS.
        /// </summary>
        internal static string SqlServerGetParameters {
            get {
                return ResourceManager.GetString("SqlServerGetParameters", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to SELECT
        ///sp.name AS [SPECIFIC_NAME],
        ///db_name() AS [SPECIFIC_CATALOG],
        ///ssp.name AS [SPECIFIC_SCHEMA],
        ///&apos;PROCEDURE&apos; AS ROUTINE_TYPE
        ///FROM
        ///dbo.sysobjects AS sp
        ///INNER JOIN sysusers AS ssp ON ssp.uid = sp.uid
        ///WHERE
        ///(sp.xtype = N&apos;P&apos; OR sp.xtype = N&apos;RF&apos;)and(CAST(
        ///                CASE WHEN (OBJECTPROPERTY(sp.id, N&apos;IsMSShipped&apos;)=1) THEN 1 WHEN 1 = OBJECTPROPERTY(sp.id, N&apos;IsSystemTable&apos;) THEN 1 ELSE 0 
        ///END
        ///             AS bit)=0)
        ///ORDER BY
        ///[SPECIFIC_SCHEMA] ASC,[SPECIFIC_Name] ASC.
        /// </summary>
        internal static string SqlServerGetProcedures2000 {
            get {
                return ResourceManager.GetString("SqlServerGetProcedures2000", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to SELECT
        ///	sp.name AS [SPECIFIC_NAME],
        ///	db_name()  AS [SPECIFIC_CATALOG],
        ///	SCHEMA_NAME(sp.schema_id) AS [SPECIFIC_SCHEMA],
        ///	&apos;PROCEDURE&apos; AS ROUTINE_TYPE
        ///	FROM
        ///	sys.all_objects AS sp
        ///	LEFT OUTER JOIN sys.sql_modules AS smsp ON smsp.object_id = sp.object_id
        ///	LEFT OUTER JOIN sys.system_sql_modules AS ssmsp ON ssmsp.object_id = sp.object_id
        ///	WHERE
        ///	(sp.type = N&apos;P&apos; OR sp.type = N&apos;RF&apos; OR sp.type=&apos;PC&apos;)and(CAST(
        ///	 case 
        ///	    when sp.is_ms_shipped = 1 then 1
        ///	    when (
        ///	        select 
        ///	            major [rest of string was truncated]&quot;;.
        /// </summary>
        internal static string SqlServerGetProcedures2005 {
            get {
                return ResourceManager.GetString("SqlServerGetProcedures2005", resourceCulture);
            }
        }
    }
}
