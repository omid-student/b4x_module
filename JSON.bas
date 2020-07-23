B4A=true
Group=Libraries
ModulesStructureVersion=1
Type=StaticCode
Version=9.8
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Private Sub Process_Globals

End Sub

Sub Json2Map(Json1 As String) As Map
	
	Try
		Dim js As JSONParser
		js.Initialize(Json1)
		Return js.NextObject
	Catch
		Return Null
	End Try
	
End Sub

Sub Map2Json(Map1 As Map) As String
	Dim Js As JSONGenerator
	Js.Initialize(Map1)
	Return Js.ToString
End Sub

Sub Json2List(Json1 As String) As List
	
	Try
		Dim js As JSONParser
		js.Initialize(Json1)
		Return js.NextArray
	Catch
		Return Null
	End Try
	
End Sub

Sub List2Json(List2 As List) As String
	Dim Js As JSONGenerator
	Js.Initialize2(List2)
	Return Js.ToString
End Sub

Public Sub IsJson(Str As String) As Boolean
	
	Dim js As JSONParser
	js.Initialize(Str)
	
	Try
		js.NextObject
		Return True
	Catch
		Try
			Dim js As JSONParser
			js.Initialize(Str)
			js.NextArray
			Return True
		Catch
			Return False
		End Try
	End Try
	
End Sub