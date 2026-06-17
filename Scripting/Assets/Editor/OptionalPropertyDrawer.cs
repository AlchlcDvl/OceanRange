using UnityEditor;
using UnityEngine;
using OceanRange.Unity;

[CustomPropertyDrawer(typeof(Optional<>))]
public class OptionalPropertyDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        SerializedProperty hasValueProp = property.FindPropertyRelative("HasValue");
        SerializedProperty valueProp = property.FindPropertyRelative("Value");

        EditorGUI.BeginProperty(position, label, property);

        Rect toggleRect = new Rect(position.x, position.y, EditorGUIUtility.labelWidth, position.height);
        hasValueProp.boolValue = EditorGUI.ToggleLeft(toggleRect, label, hasValueProp.boolValue);

        Rect valueRect = new Rect(position.x + EditorGUIUtility.labelWidth, position.y, position.width - EditorGUIUtility.labelWidth, position.height);

        bool previousGUIState = GUI.enabled;

        GUI.enabled = hasValueProp.boolValue;
        EditorGUI.PropertyField(valueRect, valueProp, GUIContent.none);

        GUI.enabled = previousGUIState;

        EditorGUI.EndProperty();
    }
}