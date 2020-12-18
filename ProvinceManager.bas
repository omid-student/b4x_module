﻿B4A=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Private Sub Class_Globals
	Private sql_ As SQL
	Type Province_(Pid As Int,Title As String)
	Type City_(Pid As Int,ProvinceID As Int,Title As String)
	Type County_(Pid As Int,ProvinceID As Int,Title As String)
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
	If File.Exists(Configuration.Dir,"common_data.db") = False Then
		File.Copy(File.DirAssets,"common_data.db",Configuration.Dir,"common_data.db")
	End If
	
	sql_.Initialize(Configuration.Dir,"common_data.db",False)
	
End Sub

Public Sub GetProvinces As List
	
	Dim rs As ResultSet
	rs = sql_.ExecQuery("SELECT * FROM tbl_provinces")
	
	Dim ls As List
	ls.Initialize
	
	Do While rs.NextRow
		
		Dim t As Province_
		t.Initialize
		t.Pid	=	rs.GetInt("pid")
		t.Title	=	rs.GetString("title")
		
		ls.Add(t)
				
	Loop
	
	Return ls
	
End Sub

Public Sub GetCities(ProvinceID As Int) As List
	
	Dim rs As ResultSet
	rs = sql_.ExecQuery2("SELECT * FROM tbl_province_city WHERE province_id = ?",Array As String(ProvinceID))
	
	Dim ls As List
	ls.Initialize
	
	Do While rs.NextRow
		
		Dim t As City_
		t.Initialize
		t.Pid			=	rs.GetInt("pid")
		t.Title			=	rs.GetString("title")
		t.ProvinceID	=	rs.GetString("province_id")
		
		ls.Add(t)
				
	Loop
	
	Return ls
	
End Sub

Public Sub GetCounties(ProvinceID As Int) As List
	
	Dim rs As ResultSet
	rs = sql_.ExecQuery2("SELECT * FROM tbl_province_county WHERE province_id = ?",Array As String(ProvinceID))
	
	Dim ls As List
	ls.Initialize
	
	Do While rs.NextRow
		
		Dim t As County_
		t.Initialize
		t.Pid			=	rs.GetInt("pid")
		t.Title			=	rs.GetString("title")
		t.ProvinceID	=	rs.GetString("province_id")
		
		ls.Add(t)
				
	Loop
	
	Return ls
	
End Sub