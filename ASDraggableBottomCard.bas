B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.8
@EndOfDesignText@

#If Documentation



#End If

#Event: Opened
#Event: Closed
#Event: Open
#Event: Close
#Event: VisibleBodyHeightChanged (height as double)

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	'Private mBase As B4XView 'ignore
	Private xui As XUI 'ignore
	Private mDarkPanel As B4XView
	
	Private downy As Float
	Private old_top As Float
	
	Private g_first_height,g_second_height As Float,g_width As Float
	Private g_orientation As Int
	
	Public g_show_duration As Int = 250
	Public g_hide_duration As Int = 700
	Private g_header_height As Float
	Private g_darkpanel_alpha As Int = 165
	
	Private expand_state As Int = 0
	
	Private disable_touch As Boolean = False
	
	'Views
	Private xpnl_card_base As B4XView
	Private xpnl_card_header As B4XView
	Private xpnl_card_body As B4XView
	
	#If B4I 
	Private tmp As GestureRecognizer
	#end if
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

'Base type must be Object
Public Sub Create (Parent As B4XView,first_height As Float,second_height As Float,header_height As Float,width As Float,orientation As Int)
	'mBase = Base
	g_first_height = first_height
	g_second_height = second_height
	g_width = width
	g_orientation = orientation
	g_header_height = header_height
	
	ini_views(Parent)

	#if B4A
	Base_Resize(Parent.Width,Parent.Height)
	Private r As Reflector
	r.Target = xpnl_card_base
	r.SetOnTouchListener("xpnl_card_header_Touch2")
	#Else IF B4I	
	tmp.Initialize("tmp",Me,xpnl_card_header)
	tmp.AddPanGesture(1,2)
	#End If
	Base_Resize(Parent.Width,Parent.Height)
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
  
  Dim tmp_left As Float = 0
	If g_orientation = Orientation_MIDDLE Then
		tmp_left = Width/2 - g_width/2
		Else If g_orientation = Orientation_RIGHT Then
			tmp_left = Width - g_width
	End If
  
	mDarkPanel.SetLayoutAnimated(0,0,0,Width,Height)
	xpnl_card_base.SetLayoutAnimated(0,tmp_left,Height + g_first_height,g_width,g_first_height)
	
	xpnl_card_header.SetLayoutAnimated(0,0,0,g_width,g_header_height)
	xpnl_card_body.SetLayoutAnimated(0,0,g_header_height,g_width,g_first_height - g_header_height)
	'VisibleBodyHeightChanged
	'xpnl_card_header.Color = xui.Color_Green
	'xpnl_card_body.Color = xui.Color_Blue
End Sub

Private Sub ini_views(Parent As B4XView)
	xpnl_card_base = xui.CreatePanel("xpnl_card_base")
	xpnl_card_header = xui.CreatePanel("xpnl_header")
	xpnl_card_body = xui.CreatePanel("")
	mDarkPanel = xui.CreatePanel("mDarkPanel")
	Parent.AddView(mDarkPanel,0,0,0,0)
	Parent.AddView(xpnl_card_base,0,0,0,0)
	xpnl_card_base.AddView(xpnl_card_header,0,0,0,0)
	xpnl_card_base.AddView(xpnl_card_body,0,0,0,0)
	'xpnl_card_base.Color = xui.Color_Red
	mDarkPanel.Color = xui.Color_ARGB(g_darkpanel_alpha,0,0,0)
	mDarkPanel.Visible = False
End Sub

Public Sub Show(ignore_event As Boolean)
	ShowIntern(ignore_event,False)
End Sub

Private Sub ShowIntern(ignore_event As Boolean,fromtouch As Boolean)
	'xpnl_card_base.Visible = True
		If xui.SubExists(mCallBack,mEventName & "_Open",0) Then
			CallSub(mCallBack,mEventName & "_Open")
		End If
	mDarkPanel.Enabled = True
	mDarkPanel.SetVisibleAnimated(g_show_duration,True)
	disable_touch = True
	If expand_state = 1 Then	
		xpnl_card_base.Height = g_second_height
		xpnl_card_base.SetLayoutAnimated(g_show_duration,xpnl_card_base.Left,mDarkPanel.Height - g_first_height,g_width,g_second_height)
		xpnl_card_body.Height = g_second_height - g_header_height
		Sleep(g_show_duration)
		xpnl_card_base.Height = g_first_height
		xpnl_card_body.Height = g_first_height - g_header_height
		VisibleBodyHeightChanged
	Else		
		xpnl_card_base.Height = g_second_height
		xpnl_card_base.SetLayoutAnimated(g_show_duration,xpnl_card_base.Left,mDarkPanel.Height - g_second_height,g_width,g_second_height)
		xpnl_card_body.Height = g_second_height - g_header_height
		If fromtouch = False Then Sleep(g_show_duration)
		VisibleBodyHeightChanged
	End If
	disable_touch = False
	expand_state = 1
	If ignore_event = False Then
		'Sleep(g_show_duration)
		If xui.SubExists(mCallBack,mEventName & "_Opened",0) Then
			CallSub(mCallBack,mEventName & "_Opened")
		End If
	Else
	End If
End Sub

Public Sub Hide	(ignore_event As Boolean)
	If xui.SubExists(mCallBack,mEventName & "_Close",0) Then
		CallSub(mCallBack,mEventName & "_Close")
	End If

	xpnl_card_base.SetLayoutAnimated(g_hide_duration,xpnl_card_base.Left,mDarkPanel.Height + g_first_height,g_width,xpnl_card_base.Height)
	'xpnl_card_base.SetVisibleAnimated(g_hide_duration,False)
	mDarkPanel.SetVisibleAnimated(g_hide_duration,False)
	expand_state = 0
	If ignore_event = False Then
		Sleep(g_hide_duration)
		xpnl_card_base.Height = g_first_height
		If xui.SubExists(mCallBack,mEventName & "_Closed",0) Then
			CallSub(mCallBack,mEventName & "_Closed")
		End If
	Else
		Sleep(g_hide_duration)
		xpnl_card_base.Height = g_first_height
	End If
End Sub

#If B4A

Private Sub xpnl_card_header_Touch2(ViewTag As Object, Action As Int, X As Float, y As Float, MotionEvent As Object) As Boolean
	Return HandleTouch(Action,y)
End Sub

#Else If B4I

Private Sub tmp_pan(state As Int, att As Pan_Attributes)
	Select state
		Case 1 'STATE_Begin
			HandleTouch(xpnl_card_base.TOUCH_ACTION_DOWN,att.y)
		Case 2 'STATE_Changed
			HandleTouch(xpnl_card_base.TOUCH_ACTION_MOVE,att.y)
		Case 3 'STATE_End
			HandleTouch(xpnl_card_base.TOUCH_ACTION_UP,att.y)
	End Select
End Sub

#End If

Private Sub HandleTouch(Action As Int,y As Float) As Boolean
	If disable_touch = True Then Return False
	If Action = xpnl_card_base.TOUCH_ACTION_DOWN Then
		downy  = y
	End If
	xpnl_card_body.Height = xpnl_card_base.Height - g_header_height
	VisibleBodyHeightChanged
	'xpnl_card_body.SetLayoutAnimated(0,0,xpnl_card_body.Top,xpnl_card_body.Width,(mBase.Height - (xpnl_card_base.Top + y - downy)) - xpnl_card_header.Height)
	If Action = xpnl_card_base.TOUCH_ACTION_DOWN Then
		'downy  = y
		old_top = xpnl_card_base.Top
		'Log("TOUCH_ACTION_DOWN: " & y)
	Else if Action = xpnl_card_base.TOUCH_ACTION_MOVE Then
			
		If (xpnl_card_base.Top + y - downy) > (mDarkPanel.Height - g_second_height) Then
			xpnl_card_base.Top = xpnl_card_base.Top + y - downy
				
			xpnl_card_base.SetLayoutAnimated(0,xpnl_card_base.Left,xpnl_card_base.Top,xpnl_card_base.Width,g_second_height)
			If xpnl_card_base.Top < (mDarkPanel.Height - g_first_height) Then
				expand_state = 2
			Else
				expand_state = 1
			End If
			
		End If
	Else if Action = xpnl_card_base.TOUCH_ACTION_UP Then
		If expand_state = 1 And old_top < xpnl_card_base.Top Then
			Hide(False)
		Else if expand_state = 2 And old_top < xpnl_card_base.Top Then
			expand_state = 1
			ShowIntern(True,True)
		Else
			ShowIntern(True,True)
		End If
	End If
	Return True
End Sub

Public Sub getCardBase As B4XView
	Return xpnl_card_base
End Sub

Public Sub ExpandFull	
	expand_state = 2
	ShowIntern(True,True)
End Sub

Public Sub ExpandHalf	
	expand_state = 1
	ShowIntern(True,False)
End Sub

Public Sub HeaderPanel As B4XView
	Return xpnl_card_header	
End Sub

Public Sub BodyPanel As B4XView
	Return xpnl_card_body
End Sub

Public Sub Orientation_LEFT As Int
	Return 0
End Sub

Public Sub Orientation_MIDDLE As Int
	Return 1
End Sub

Public Sub Orientation_RIGHT As Int
	Return 2
End Sub

Public Sub getIsOpen As Boolean
	If expand_state = 0 Then Return False Else Return True
End Sub

Public Sub getDarkPanelAlpha As Int
	Return g_darkpanel_alpha
End Sub

Public Sub setDarkPanelAlpha(alpha As Int)
	If alpha >= 0 And alpha <=255 Then
		g_darkpanel_alpha = alpha
	End If
End Sub

Private Sub VisibleBodyHeightChanged
	If xui.SubExists(mCallBack,mEventName & "_VisibleBodyHeightChanged",1) Then
		CallSub2(mCallBack,mEventName & "_VisibleBodyHeightChanged",xpnl_card_body.Height)
	End If
End Sub

Private Sub mDarkPanel_Click
	mDarkPanel.Enabled = False
	Hide(False)
End Sub
