B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.8
@EndOfDesignText@
Private Sub Class_Globals
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Sub LabelName As String
	
	#if b4a
	Return Application.LabelName
	#else
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleDisplayName"))
	Return name
	#End If
	
End Sub

Sub VersionCode As String
	
	#if b4a
	Return Application.VersionCode
	#else
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleShortVersionString"))
	Dim temp As String
	temp = name
	Return temp.Replace(".","")
	#End If
	
End Sub

Sub VersionName As String
	
	#if b4a
	Return Application.VersionName
	#else
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleShortVersionString"))
	Return name
	#End If
	
End Sub