B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=9.8
@EndOfDesignText@
Private Sub Process_Globals

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

Sub DeviceID As String
	
	#if b4a
	Dim id2 As String
	Dim p As Phone
	id2	=	p.GetSettings("android_id")
	Return id2
	#else
	Dim ph As Phone
	Dim name As String
	
	If ph.KeyChainGet("imei") = "" Then
	' get device unique identifier
		Dim device As NativeObject
		device = device.Initialize("UIDevice").RunMethod("currentDevice", Null)
		name = device.GetField("identifierForVendor").AsString
		ph.KeyChainPut("imei",name)
	Else
		name	=	ph.KeyChainGet("imei")
	End If
	
	Return name
	#End If

End Sub

Sub PackageName As String
	
	#if b4a
	Return Application.PackageName
	#else
	Dim no As NativeObject
	no = no.Initialize("NSBundle").RunMethod("mainBundle", Null)
	Dim name As Object = no.RunMethod("objectForInfoDictionaryKey:", Array("CFBundleIdentifier"))
	Return name
	#End If
	
End Sub