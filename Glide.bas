B4A=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
Private Sub Class_Globals
	Private http As HttpJob
	Private w_,h_,radius_ As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	http.Initialize("download",Me)
End Sub

Public Sub Resize(Width As Int,Height As Int)
	w_ = Width
	h_ = Height
End Sub

Public Sub Corner(Radius As Int)
	radius_ = Radius
End Sub

Public Sub IntoImageview(Url As String,Img As B4XView)
	
	http.Download(Url)
	
	Wait For JobDone(Job As HttpJob)
	
		If Job.Success Then
			
			Dim temp As B4XBitmap
		
			temp	=	Job.GetBitmap
			
			If w_ > 0 And h_ > 0 Then
				temp	=	temp.Resize(w_,h_,True)
			End If
			
			If radius_ > 0 Then
				temp	=	CreateRoundRectBitmap(temp,radius_)
			End If
			
			Img.SetBitmap(temp)
			
	End If
		
End Sub

Private Sub CreateRoundRectBitmap (Input As B4XBitmap, Radius As Float) As B4XBitmap
	Dim xui As XUI
	Dim BorderColor As Int = Colors.Transparent
	Dim BorderWidth As Int = 4dip
	Dim c As B4XCanvas
	Dim xview As B4XView = xui.CreatePanel("")
	xview.SetLayoutAnimated(0, 0, 0, Input.Width, Input.Height)
	c.Initialize(xview)
	Dim path As B4XPath
	path.InitializeRoundedRect(c.TargetRect, Radius)
	c.ClipPath(path)
	c.DrawRect(c.TargetRect, BorderColor, True, BorderWidth) 'border
	c.RemoveClip
	Dim r As B4XRect
	r.Initialize(BorderWidth, BorderWidth, c.TargetRect.Width - BorderWidth, c.TargetRect.Height - BorderWidth)
	path.InitializeRoundedRect(r, Radius - 0.7 * BorderWidth)
	c.ClipPath(path)
	c.DrawBitmap(Input, r)
	c.RemoveClip
	c.Invalidate
	Dim res As B4XBitmap = c.CreateBitmap
	c.Release
	Return res
End Sub