using System;
using Csla;

namespace ParentLoad.DataAccess.ERCLevel
{
    /// <summary>
    /// DTO for B04_SubContinent type
    /// </summary>
    public partial class B04_SubContinentDto
    {
        /// <summary>
        /// Gets or sets the parent Continent ID.
        /// </summary>
        /// <value>The Continent ID.</value>
        public int Parent_Continent_ID { get; set; }

        /// <summary>
        /// Gets or sets the Sub Continent ID.
        /// </summary>
        /// <value>The Sub Continent ID.</value>
        public int SubContinent_ID { get; set; }

        /// <summary>
        /// Gets or sets the Sub Continent Name.
        /// </summary>
        /// <value>The Sub Continent Name.</value>
        public string SubContinent_Name { get; set; }
    }
}
