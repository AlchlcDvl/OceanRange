using UnityEditor;
using UnityEngine;
using OceanRange.Unity;

public class OptionalDataDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        EditorGUI.BeginProperty(position, label, property);

        // Draw the label first (reserves space for it)
        position = EditorGUI.PrefixLabel(position, GUIUtility.GetControlID(FocusType.Passive), label);

        var hasValueProp = property.FindPropertyRelative("HasValue");
        var valueProp = property.FindPropertyRelative("Value");

        // Split rect into two parts
        var toggleRect = new Rect(position.x, position.y, 20, position.height);
        var fieldRect = new Rect(position.x + 25, position.y, position.width - 20, position.height);

        hasValueProp.boolValue = EditorGUI.Toggle(toggleRect, hasValueProp.boolValue);

        if (hasValueProp.boolValue)
            EditorGUI.PropertyField(fieldRect, valueProp, GUIContent.none);
        else
            EditorGUI.LabelField(fieldRect, "null");

        EditorGUI.EndProperty();
    }
}

[CustomPropertyDrawer(typeof(OptionalInt))]
public class OptionalIntDrawer : OptionalDataDrawer {}

[CustomPropertyDrawer(typeof(OptionalColor))]
public class OptionalColorDrawer : OptionalDataDrawer {}

[CustomPropertyDrawer(typeof(OptionalFloat))]
public class OptionalFloatDrawer : OptionalDataDrawer {}

[CustomPropertyDrawer(typeof(OptionalDouble))]
public class OptionalDoubleDrawer : OptionalDataDrawer {}