using UnityEditor;
using UnityEngine;

[CustomPropertyDrawer(typeof(OptionalInt))]
[CustomPropertyDrawer(typeof(OptionalColor))]
[CustomPropertyDrawer(typeof(OptionalFloat))]
[CustomPropertyDrawer(typeof(OptionalDouble))]
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