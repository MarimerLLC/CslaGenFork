﻿using System;
using System.ComponentModel;
using System.Globalization;
using CslaGenerator.Util;

namespace CslaGenerator.Design
{
    public class EnumDescriptionOrCaseConverter : EnumConverter
    {
        //http://www.codeproject.com/Articles/22717/Using-PropertyGrid

        private readonly Type _enumType;

        /// <summary>
        /// Initializes a new instance of the <see cref="EnumDescriptionOrCaseConverter"/> class.
        /// </summary>
        /// <param name="type">A <see cref="T:System.Type" /> that represents the type of enumeration to associate with this enumeration converter.</param>
        public EnumDescriptionOrCaseConverter(Type type)
            : base(type)
        {
            _enumType = type;
        }

        public override bool CanConvertTo(ITypeDescriptorContext context, Type destinationType)
        {
            return destinationType == typeof(string);
        }

        public override object ConvertTo(ITypeDescriptorContext context, CultureInfo culture, object value,
            Type destinationType)
        {
            if (value == null)
                return string.Empty;

            var valueType = value.GetType();
            if (valueType == typeof(string) && string.IsNullOrWhiteSpace((string) value))
                return string.Empty;

            var fi = _enumType.GetField(Enum.GetName(_enumType, value));
            var dna = (DescriptionAttribute) Attribute.GetCustomAttribute(fi, typeof(DescriptionAttribute));

            if (dna != null)
                return dna.Description;

            var description = value.ToString().AddSpaceBeforeUpperCase();
            if (!string.IsNullOrEmpty(description))
                return description;

            return value.ToString();
        }

        public override bool CanConvertFrom(ITypeDescriptorContext context, Type sourceType)
        {
            return sourceType == typeof(string);
        }

        public override object ConvertFrom(ITypeDescriptorContext context, CultureInfo culture, object value)
        {
            foreach (var fi in _enumType.GetFields())
            {
                var dna = (DescriptionAttribute) Attribute.GetCustomAttribute(fi, typeof(DescriptionAttribute));

                if ((dna != null) && ((string) value == dna.Description))
                    return Enum.Parse(_enumType, fi.Name);

                var description = fi.Name.AddSpaceBeforeUpperCase();
                if ((!string.IsNullOrEmpty(description)) && (string) value == description)
                    return Enum.Parse(_enumType, fi.Name);
            }

            return Enum.Parse(_enumType, (string) value);
        }
    }
}