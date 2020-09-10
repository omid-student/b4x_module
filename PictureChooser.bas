B4A=true
Group=Libraries
ModulesStructureVersion=1
Type=Class
Version=9.8
@EndOfDesignText@
#Event: Result(Bitmap As Bitmap)
#Event: Result2(Dir As String,Filename As String)

#if b4i
Private Sub Class_Globals
	Private media As Camera
	Private event As String
	Private Module1 As Object
	Private nome As NativeObject
	Private is_crop As Boolean
	Private Nav As NavigationController
	Private p2 As Page
	Private Page1 As Page
	Private current_bitmap As Bitmap
	Private IsScale As Boolean
	Private IsCircular As Boolean
	Private sWidth,sHeight,RatioWidth,RatioHeight As Int
	Public CropTitle As String = "بریدن تصویر"
	Public ButtonCancelTitle As String = "بیخیال"
	Public ButtonDoneTitle As String = "تایید"
	Private filename_ As String
	Private CurrentDirCrop,CurrentFilenameCrop As String
	Private Chooser_Title As String : Chooser_Title	=	"انتخاب تصویر"
	Private quality2 As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
'Min version is 10
'add below plist
'#PlistExtra:<key>NSPhotoLibraryUsageDescription</key><string>Select a photo.</string>
'#PlistExtra:<key>NSCameraUsageDescription</key><string>Taking a photo.</string>
'#PlistExtra:<key>NSMicrophoneUsageDescription</key><string>Record video.</string>
'

Public Sub Initialize(Parent As Panel,Module As Object,EventResult As String) As PictureChooser
	
	Nav		= Main.NavControl
	event	= EventResult
	Module1	= Module
	
	nome.Initialize("")
	filename_	=	"temp.jpg"
	
	Return Me
	
End Sub

Public Sub SetPage(Page As Page) As PictureChooser
	p2	=	Page
	Return Me
End Sub

Public Sub SetFilename(Filename As String) As PictureChooser
	filename_	=	Filename
	Return Me
End Sub

Public Sub SetFont(Font_ As Font) As PictureChooser
	Return Me
End Sub

Public Sub setChooserTitle(Value As String)
	Chooser_Title	=	Value
End Sub

Public Sub setRotateTitle(Value As String)
	
End Sub

Public Sub setSaveTitle(Value As String)
	
End Sub

Public Sub setCancelTitle(Value As String)

End Sub

Public Sub getVisible As Boolean
	Return True
End Sub

Public Sub setQualityCameraPicture(Value As Int)
	quality2	=	Value
End Sub

Public Sub setCropTitle(Value As String)

End Sub

'if set False,user cannot crop picture with custome shape
Sub setScaleCrop(Value As Boolean)
	IsScale	=	Value
End Sub

Public Sub ChooseFromGallery
	media.Initialize("camera",p2)
	media.SelectFromPhotoLibrary(p2.RootPanel,media.TYPE_IMAGE)
End Sub

'Output picture is JPG
Public Sub ChooseFromCamera
	media.Initialize("camera",p2)
	media.TakePicture
End Sub

'Crop picture after select from gallery or camera
'please add layout for crop picture
Public Sub setCrop(Value As Boolean)
	is_crop	=	Value
End Sub

Public Sub setResizedOutput(Width As Int,Height As Int)
	sWidth	=	Width
	sHeight	=	Height
End Sub

Public Sub SetAspectRatio(Width As Int,Height As Int) As PictureChooser
	RatioWidth	=	Width
	RatioHeight	=	Height
	Return Me
End Sub

Sub setIsCircular(Value As Boolean)
	IsCircular	=	Value
End Sub

Public Sub ChooseVideo
	media.TakeVideo
End Sub

Public Sub getFilename As String
	Return filename_
End Sub

Public Sub Hide
	
End Sub

Private Sub camera_Complete (Success As Boolean, Image As Bitmap, VideoPath As String)

	If Success Then
		
		If VideoPath = "" Then
			
			If is_crop = True Then
				CropBitmap(Image)
				Return
			End If

			If sWidth > 0 And sHeight > 0 Then
				If Image.Width > sWidth Or Image.Height > sHeight Then
					Image	=	Image.Resize(sWidth,sHeight,True)
				End If
			End If
			
			If SubExists(Module1,event & "_result2",2) Then
				SaveBitmap(Image,File.DirLibrary,filename_)
				CallSubDelayed3(Module1,event & "_Result2",File.DirLibrary,filename_)
			Else
				CallSubDelayed2(Module1,event & "_result",Image)
			End If
		Else
			If SubExists(Module1,event & "_result2",2) Then
				CallSubDelayed3(Module1,event & "_Result2",VideoPath,"")
			End If
		End If
	
	Else
		
	End If
	
End Sub

#region Bitmap feature
Public Sub RotateBitmap(Original As Bitmap, Degree As Float) As Bitmap
	Return RotateImageByDegrees(Original,Degree)
End Sub

Public Sub ResizeBitmap(Original As Bitmap, Width As Int, Height As Int) As Bitmap
	
	Dim scale As Int
	scale	=	Min(Width / Original.Width,Width / Original.Height)
	
	Dim img As ImageView
	img.Initialize("")
	img.Width = Original.Width * scale
	img.Height = Original.Height * scale
	Dim cvs As Canvas
	cvs.Initialize(img)
	cvs.DrawBitmap(Original, cvs.TargetRect)
	Dim res As Bitmap = cvs.CreateBitmap
	cvs.Release
	Return res

End Sub

Public Sub ResizePicture(Dir As String, Filename As String, OutputFilename As String,Width As Int,Height As Int)
	
	Dim bt As Bitmap
	bt	=	LoadBitmap(Dir,Filename)
	
	SaveBitmap(ResizeBitmap(bt,Width,Height),Dir,OutputFilename)
	
End Sub

'save picture with jpeg format
Public Sub SaveBitmap(Bitmap As Bitmap,Dir As String,Filename As String)
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = Bitmap
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,100,"JPEG")
	out.Close
End Sub

'save picture with png format
Public Sub SaveBitmap2(Bitmap As Bitmap,Dir As String,Filename As String)
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = Bitmap
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,100,"JPEG")
	out.Close
End Sub

Public Sub RoundBitmap(Bitmap As Bitmap) As Bitmap
	Return RoundBitmap3(Bitmap,Bitmap.Width/2)
End Sub

Public Sub RoundBitmap2(Bitmap As Bitmap,Corner As Int) As Bitmap
	Return RoundBitmap3(Bitmap,Corner)
End Sub

Private Sub RotateImageByDegrees(original As Bitmap, degree As Float) As Bitmap
	original= nome.RunMethod("imageRotatedByDegrees::", Array(original,degree))
	Return original
End Sub

#IgnoreWarnings: 12
Private Sub RotateImageByRadians(original As Bitmap, radians As Float) As Bitmap
	original= nome.RunMethod("imageRotatedByRadians::", Array(original,radians))
	Return original
End Sub

Private Sub RoundBitmap3(Bitmap As Bitmap,Corner As Int) As Bitmap
	
	Dim img As ImageView
	img.Initialize("")
	p2.RootPanel.AddView(img,-Bitmap.Width,0,Bitmap.Width,Bitmap.Height)
	img.Bitmap = Bitmap
	img.SetBorder(0,Colors.Transparent,Corner)
	
	Dim img2 As ImageView
	img2.Initialize("")
	p2.RootPanel.AddView(img2,-Bitmap.Width,-Bitmap.Height,Bitmap.Width,Bitmap.Height)
	
	Dim cvs As Canvas
	cvs.Initialize(img)
	Dim dest As Rect
	dest.Initialize(0, 0, img.Width, img.Height)
	cvs.DrawView(img2, dest)
	cvs.Refresh
	
	Dim output As Bitmap
	output = cvs.CreateBitmap
	
	img.RemoveViewFromParent
	img2.RemoveViewFromParent
	
	Return output
	
End Sub
#end region

Public Sub CropBitmap(bitmap1 As Bitmap)
	
	Page1.Initialize("page1")
	Page1.Title = "Crop"
	Page1.RootPanel.Color = Colors.White
	Nav.ShowPage(Page1)

	current_bitmap = bitmap1
	
End Sub

Private Sub page1_Resize(Width As Int,Height As Int)

	Dim objImage As Bitmap
	objImage	=	current_bitmap
   
	Dim objCrop As iCropView
	objCrop.DebugMode = True
	objCrop.Initialize("objCrop")
	objCrop.LicenseEmail = "omid_student@yahoo.com"
	objCrop.LicenseKey = "qJBy5L83rH4hqNC7bm0axxlrH70ogqsGyhkCIQubmM4="
	
	If IsScale Then
		objCrop.HideAspectButton = True
		objCrop.LockAspectRatio = True
		objCrop.IsSquare = True
	Else
		objCrop.IsSquare = False
		objCrop.LockAspectRatio = False
		objCrop.HideAspectButton = False
	End If
	
	If IsCircular Then
		objCrop.IsCircular	=	True
	End If

	If RatioWidth > 0 Then
		objCrop.RatioH	=	Height
		objCrop.RatioV	=	Width	
	End If
	
	objCrop.ButtonCancel = ButtonCancelTitle
	objCrop.ButtonDone = ButtonDoneTitle
	objCrop.Title = CropTitle
	objCrop.ToolbarOnTop = False
	objCrop.Start(Page1, objImage)
	
End Sub

Private Sub objCrop_onDone(ImageCropped As Bitmap)
	
	Nav.RemoveCurrentPage2(False)

	If sWidth > 0 And sHeight > 0 Then
		If ImageCropped.Width > sWidth Or ImageCropped.Height > sHeight Then
			ImageCropped	=	ImageCropped.Resize(sWidth,sHeight,True)
		End If
	End If
	
	If SubExists(Module1,event & "_result2",2) Then
		SaveBitmap(ImageCropped,File.DirLibrary,"temp.jpg")
		CallSubDelayed3(Module1,event & "_Result2",File.DirLibrary,"temp.jpg")
	Else
		CallSubDelayed2(Module1,event & "_result",ImageCropped)
	End If
	
End Sub

Private Sub objCrop_onCancel()
	
	current_bitmap = Null
	File.Delete(File.DirLibrary,"temp.jpg")
	Nav.RemoveCurrentPage2(False)

End Sub
#end if

#if b4a

'Libraries: JpegUtil,CropImageView,XUI,SQL,RunTimePermission,StringUtil,JavaObject,Reflcation
Private Sub Class_Globals
	Private ion As Object
	Private imageFolder As String
	Private IsFrontCamera As Boolean
	Private tempImageFile As String
	Private chooser As ContentChooser
	Private modue As Object
	Private evt As String
	Private sDir,sFilename As String
	Private is_crop As Boolean
	Private p2 As Panel
	Private CV As CropImageView
	Private btnrotate As Button
	Private b As Button
	Private quality2 As Int : quality2 = 60
	Private cancel As Button
	Private Chooser_Title As String : Chooser_Title	=	"انتخاب تصویر"
	Private CurrentUserBitmap As Bitmap
	Private rp As RuntimePermissions
	Private CurrentDirCrop,CurrentFilenameCrop As String
	Private AspectRatioWidth,AspectRatioHeight As Int
	Private IsScale As Boolean
	Private pnlImage As Panel
	Private img As ImageView
	Private btnsave As Button
	Private filename_ As String
	Private jo As JavaObject
End Sub

'Note: You have to declare varible in Process_Globals
'Add resouce for cropimageview

'Add below code to manifest
'<code>
'AddApplicationText(
'<activity
'    android:name="com.yalantis.ucrop.UCropActivity"
'    android:screenOrientation="portrait"
'    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>)
'
'AddApplicationText(
'  <provider
'  android:name="android.support.v4.content.FileProvider"
'  android:authorities="$PACKAGE$.provider"
'  android:exported="false"
'  android:grantUriPermissions="true">
'  <meta-data
'  android:name="android.support.FILE_PROVIDER_PATHS"
'  android:resource="@xml/provider_paths"/>
'  </provider>
')
'CreateResource(xml, provider_paths,
'   <external-files-path name="name" path="cache" />
')
'
'AddManifestText(
'<uses-permission
'android:name="android.permission.WRITE_EXTERNAL_STORAGE"
'android:maxSdkVersion="18" />
')
'</code>
Public Sub Initialize(Parent As Panel,Module As Object,EventResult As String) As PictureChooser
	
	modue	= Module
	evt		= EventResult
	
	chooser.Initialize("cc")
	
	filename_	=	"temp.jpg"
	
	tempImageFile	=	filename_
	imageFolder 	= 	rp.GetSafeDirDefaultExternal("cache")
	
	If Parent = Null Then Return
	If Parent.IsInitialized = False Then Return
	
	p2.Initialize("p2Panel")
	p2.Visible = False
	p2.Color = Colors.RGB(30, 30, 30)
	Parent.AddView(p2,0,0,Parent.Width,Parent.Height)
	p2.Elevation	=	5dip
	
	CV.Initialize("SCV")
	p2.AddView(CV,0,0,p2.Width,p2.Height)
	
	b.Initialize("btncrop")
	b.Text		= "بریدن"
	b.TextColor = Colors.White
	b.TextSize	= 11
	b.Color		= Colors.RGB(51, 51, 55)
	p2.AddView(b,0,p2.Height - 40dip,p2.Width/3,40dip)
	
	btnrotate.Initialize("btnrotate")
	btnrotate.Text = "چرخاندن"
	btnrotate.TextColor = Colors.White
	btnrotate.TextSize = 11
	btnrotate.Color = Colors.RGB(51, 51, 55)
	p2.AddView(btnrotate,b.Width,Parent.Height - 40dip,Parent.Width/3,40dip)
	
	cancel.Initialize("btncancel")
	cancel.Text = "بیخیال"
	cancel.TextSize = 11
	cancel.TextColor = Colors.White
	cancel.Color = Colors.RGB(51, 51, 55)
	p2.AddView(cancel,p2.Width - (p2.Width/3),p2.Height - 40dip,p2.Width/3,40dip)
	
	pnlImage.Initialize("pnlimage")
	pnlImage.Visible	=	False
	pnlImage.Color		=	Colors.Black
	Parent.AddView(pnlImage,0,0,Parent.Width,Parent.Height)
	pnlImage.Elevation	=	5dip
	
	img.Initialize("pnlimage")
	pnlImage.AddView(img,0,0,pnlImage.Width,pnlImage.Height-40dip)
	
	btnsave.Initialize("btnsave")
	btnsave.Text		= "ذخیره"
	btnsave.TextColor 	= Colors.White
	btnsave.TextSize	= 11
	btnsave.Color		= Colors.RGB(51, 51, 55)
	pnlImage.AddView(btnsave,0,img.Height,pnlImage.Width/2,40dip)
	
	Dim btncropDo As Button
	btncropDo.Initialize("btncropDo")
	btncropDo.Text		= "بریدن"
	btncropDo.TextColor = Colors.White
	btncropDo.TextSize	= 11
	btncropDo.Color		= Colors.RGB(51, 51, 55)
	pnlImage.AddView(btncropDo,btnsave.Width,img.Height,pnlImage.Width/2,40dip)
	
	Return Me
	
End Sub

#IgnoreWarnings: 19
Private Sub btncropDo_Click
	
	pnlImage.Visible	=	False
	p2.Visible			=	True
	
	p2.BringToFront
	
	Try
		CV.ImageBitmap		=	LoadBitmapResize(sDir,sFilename,150%x,150%y,True)
		CurrentUserBitmap	=	LoadBitmapResize(sDir,sFilename,150%x,150%y,True)
	Catch
				
	End Try
	
End Sub

Private Sub btnsave_Click
	
	Dim temp As Bitmap
	temp = FixOrientation(sDir, sFilename)
	
	If AspectRatioWidth > 0 Then
		temp	=	temp.Resize(AspectRatioWidth,AspectRatioHeight,True)
		SaveBitmap(temp,sDir,sFilename,100)
	End If
	
	pnlImage.Visible	=	False
	p2.Visible			=	False
	
	If SubExists(modue,evt & "_result2") Then
		CallSubDelayed3(modue,evt & "_Result2",sDir, sFilename)
	Else
		CallSubDelayed2(modue,evt & "_result",temp)
	End If
	
End Sub

Private Sub p2Panel_Click
	
End Sub

Public Sub Close
	btncancel_Click
End Sub

Public Sub SetFilename(filename As String) As PictureChooser
	filename_	=	filename
	tempImageFile	=	filename_
	Return Me
End Sub

Public Sub SetFont(Font As Typeface) As PictureChooser
	btnrotate.Typeface	=	Font
	btnsave.Typeface	=	Font
	cancel.Typeface		=	Font
	b.Typeface			=	Font
	Return Me
End Sub

Public Sub setChooserTitle(Value As String)
	Chooser_Title	=	Value
End Sub

Public Sub setRotateTitle(Value As String)
	btnrotate.Text	=	Value
End Sub

Public Sub setSaveTitle(Value As String)
	btnsave.Text	=	Value
End Sub

Public Sub setCancelTitle(Value As String)
	cancel.Text	=	Value
End Sub

Public Sub getVisible As Boolean
	If p2.IsInitialized = False Then Return False
	If p2.Visible Or pnlImage.Visible Then Return True
	Return False
End Sub

'between 1 to 100
Public Sub setQualityCameraPicture(Value As Int)
	quality2	=	Value
End Sub

Public Sub setCropTitle(Value As String)
	b.Text	=	Value
End Sub

'if set False,user cannot crop picture with custome shape
Sub setScaleCrop(Value As Boolean)
	CV.FixedAspectRatio	=	Value
	IsScale	=	Value
End Sub

'Crop picture after select from gallery or camera
Public Sub setCrop(Value As Boolean)
	is_crop	=	Value
End Sub

Private Sub btnmodeCamera_Click
	IsFrontCamera	=	Not(IsFrontCamera)
End Sub

Public Sub CheckPermissionCamera As Boolean
	
	Dim r As RuntimePermissions
	Return r.Check(r.PERMISSION_CAMERA)
		
End Sub

#IgnoreWarnings:2,12
Public Sub RequestPermissionCamera As Boolean
	
	Dim r As RuntimePermissions
	r.CheckAndRequest(r.PERMISSION_CAMERA)
		
End Sub

Public Sub SetAspectRatio(Width As Int,Height As Int) As PictureChooser
	CV.setAspectRatio(Width,Height)
	CV.FixedAspectRatio = True
	AspectRatioWidth	=	Width
	AspectRatioHeight	=	Height
	Return Me
End Sub

Private Sub btntake_Click
	
End Sub

Private Sub btnrotate_Click
	CurrentUserBitmap	=	RotateBitmap(CurrentUserBitmap,90)
	CV.ImageBitmap		=	CurrentUserBitmap
End Sub

Private Sub gpu_PictureTaken (Data() As Byte)
	
	Dim ou As OutputStream
	ou = File.OpenOutput(File.DirInternal,filename_,False)
	ou.WriteBytes(Data,0,Data.Length)
	ou.Close
	
	Dim b2 As Bitmap
	b2.InitializeResize(File.DirInternal,filename_,150%x,150%y,True)
	
	If IsFrontCamera = False Then
		b2	=	RotateBitmap(b2,90)
	Else
		b2	=	RotateBitmap(b2,270)
	End If
	
	If is_crop Then

		p2.Visible = True
	
		CurrentUserBitmap	=	b2
		CV.ImageBitmap		=	b2
		
		Return
		
	End If
		
	If SubExists(modue,evt & "_result2") Then
		CallSubDelayed3(modue,evt & "_Result2",File.DirInternal,filename_)
	Else
		CallSubDelayed2(modue,evt & "_result",LoadBitmap(File.DirInternal,filename_))
	End If
	
End Sub

Public Sub ChooseFromGallery
	chooser.Show("image/*",Chooser_Title)
End Sub

Public Sub ChooseFromCamera
	
	Dim ru As RuntimePermissions
	ru.CheckAndRequest(ru.PERMISSION_CAMERA)
	Wait For Activity_PermissionResult (Permission As String, Result As Boolean)
		If Result Then
			Dim i As Intent
			i.Initialize("android.media.action.IMAGE_CAPTURE", "")
			File.Delete(imageFolder, tempImageFile)
			Dim p As Phone
			Dim u As Object
			If p.SdkVersion < 24 Then
				Dim uri As Uri
				uri.Parse("file://" & File.Combine(imageFolder, tempImageFile))
				u = uri
			Else
				u = CreateFileProviderUri(imageFolder, tempImageFile)
			End If
			i.PutExtra("output", u) 'the image will be saved to this path
			Try
				StartActivityForResult(i,"ion")
			Catch
				ToastMessageShow("Camera is not available.", True)
				Log(LastException)
			End Try
		End If
	
End Sub

Public Sub Hide
	pnlImage.Visible	=	False
	p2.Visible			=	False	
End Sub

Private Sub ion_Event (MethodName As String, Args() As Object) As Object
	
	If Args = Null Then Return Null
	If Args.Length = 0 Then Return Null
	
	If Args.Length = 0 Then Return Null
	
	If Args(0) = -1 Then
		Try
			Dim in As Intent = Args(1)
			If File.Exists(imageFolder, tempImageFile) Then

			Else If in.HasExtra("data") Then 'try to get thumbnail instead

			End If
		Catch
			Return Null
		End Try
		
		If File.Exists(imageFolder,tempImageFile) = False Then Return Null
		
		sDir		=	imageFolder
		sFilename	=	tempImageFile
		
		If is_crop Then
			btncropDo_Click
			Return Null
		End If
		
		img.Bitmap	=	LoadBitmapResize(imageFolder,tempImageFile,img.Width,img.Height,True)
		pnlImage.Visible	=	True
		
	End If
	
	Return Null
	
End Sub

Public Sub Crop2(Dir As String, Filename As String)
	
	CurrentDirCrop		=	Dir
	CurrentFilenameCrop	=	Filename
	
	Dim p As Phone
	Dim u As Object
	If p.SdkVersion < 24 Then
		Dim uri As Uri
		uri.Parse("file://" & File.Combine(Dir, Filename))
		u = uri
	Else
		u = CreateFileProviderUri(Dir, Filename)
	End If
	
	Dim i As Intent
	i.Initialize("com.android.camera.action.CROP",u)
	i.SetType("image/*")
	i.PutExtra("crop", "true")
	
	If IsScale Then
		i.PutExtra("aspectX", 1)
		i.PutExtra("aspectY", 1)
	Else
		i.PutExtra("aspectX", AspectRatioWidth)
		i.PutExtra("aspectY", AspectRatioHeight)
	End If
	
	If IsScale Then
		i.PutExtra("scale", "true")
	Else
		i.PutExtra("scale", "false")
	End If
	
	i.PutExtra("outputX", AspectRatioWidth)
	i.PutExtra("outputY", AspectRatioHeight)
	i.PutExtra("output", u)
	StartActivityForResult(i,"crop")
	
End Sub

Private Sub crop_Event (MethodName As String, Args() As Object) As Object
	
	If Args = Null Then Return Null
	If Args.Length = 0 Then Return Null
	
	If Args(0) = -1 Then
		If SubExists(modue,evt & "_Result2") Then
			CallSub3(modue,evt & "_Result2",CurrentDirCrop, CurrentFilenameCrop)
					
		Else
			CallSubDelayed2(modue,evt & "_result",FixOrientation(CurrentDirCrop, CurrentFilenameCrop))
					
		End If
	End If
	
	Return Null
	
End Sub

Private Sub CreateFileProviderUri (Dir As String, FileName As String) As Object
	Dim FileProvider As JavaObject
	Dim context As JavaObject
	context.InitializeContext
	FileProvider.InitializeStatic("android.support.v4.content.FileProvider")
	Dim f As JavaObject
	f.InitializeNewInstance("java.io.File", Array(Dir, FileName))
	Return FileProvider.RunMethod("getUriForFile", Array(context, Application.PackageName & ".provider", f))
End Sub

Private Sub StartActivityForResult(i As Intent,Event As String)
	Dim jo As JavaObject = GetBA
	ion = jo.CreateEvent("anywheresoftware.b4a.IOnActivityResult", Event, Null)
	jo.RunMethod("startActivityForResult", Array As Object(ion, i))
End Sub

Private Sub GetBA As Object
	jo.InitializeContext
	Return jo.GetField("processBA")
End Sub

Private Sub cc_Result (Success As Boolean, Dir As String, FileName As String)
	
	If Success Then
		
		Try
			File.Copy(Dir,FileName,File.DirInternal,GetFilenameOfPath(FileName))
		Catch
			ToastMessageShow("selected file is invalid,try again...",False)
			Return
		End Try
		
		sDir		=	File.DirInternal
		sFilename	=	GetFilenameOfPath(FileName)
		
		If is_crop Then
			btncropDo_Click
			Return
		End If
		
		img.Bitmap	=	LoadBitmapResize(File.DirInternal,sFilename,img.Width,img.Height,True)
		
		pnlImage.Visible	=	True
		
	End If
	
End Sub

Private Sub btncrop_Click
	
	p2.Visible	=	False
	
	Dim temp As Bitmap
	temp	=	CV.CroppedImage
	
	If AspectRatioWidth > 0 Then
		temp	=	temp.Resize(AspectRatioWidth,AspectRatioHeight,True)
		SaveBitmap(temp,sDir,sFilename,100)
	End If
	
	SaveBitmap(temp,File.DirInternal,tempImageFile,quality2)
	
	If SubExists(modue,evt & "_Result2") Then
		CallSub3(modue,evt & "_Result2",File.DirInternal, tempImageFile)
					
	Else
		CallSubDelayed2(modue,evt & "_result",FixOrientation(File.DirInternal, tempImageFile))
					
	End If
	
End Sub

Private Sub SCV_onCropError
	Log("onCropError")
End Sub

Private Sub btncancel_Click
	
	p2.Visible = False
	
	If SubExists(modue,evt & "_error") Then
		CallSubDelayed(modue,evt & "_error")
	End If
	
End Sub

'Get picture's dir
Public Sub getDir As String
	Return sDir
End Sub

'Get picture's filename
Public Sub getFilename As String
	Return filename_
End Sub

Public Sub RotateBitmap(Original As Bitmap, Degree As Float) As Bitmap
	Return Original.Rotate(Degree)
End Sub

Public Sub ResizeBitmap(Original As Bitmap, Width As Int, Height As Int) As Bitmap
	Dim new As Bitmap
	new.InitializeMutable(Width, Height)
	Dim c As Canvas
	c.Initialize2(new)
	Dim destRect As Rect
	destRect.Initialize(0, 0, Width, Height)
	c.DrawBitmap(Original, Null, destRect)
	Return new
End Sub

Public Sub ResizePicture(Dir As String, Filename As String, OutputFilename As String,Width As Int,Height As Int)
	Dim new,Original As Bitmap
	Original = LoadBitmap(Dir,Filename)
	new.InitializeMutable(Width, Height)
	Dim c As Canvas
	c.Initialize2(new)
	Dim destRect As Rect
	destRect.Initialize(0, 0, Width, Height)
	c.DrawBitmap(Original, Null, destRect)
	SaveBitmap(new,Dir,OutputFilename,70)
End Sub

'save picture with jpeg format
Public Sub SaveBitmap(Bitmap As Bitmap,Dir As String,Filename As String,Quality As Int)
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = Bitmap
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,Quality,"JPEG")
	out.Close
End Sub

'quality is between 1 and 100
'format is JPEG,PNG
Public Sub SaveBitmap3(Bitmap As Bitmap,Dir As String,Filename As String,Format As String,quality As Int)
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = Bitmap
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,quality,Format.ToUpperCase)
	out.Close
End Sub

'save picture with png format
Public Sub SaveBitmap2(Bitmap As Bitmap,Dir As String,Filename As String)
	Dim b1 As Bitmap
	Dim out As OutputStream
	b1 = Bitmap
	out = File.OpenOutput(Dir,Filename,False)
	b1.WriteToStream(out,100,"PNG")
	out.Close
End Sub

Public Sub RoundBitmap(Input As Bitmap,Size As Int) As Bitmap
	
	Dim xui As XUI
	
	If Input.Width <> Input.Height Then
		'if the image is not square then we crop it to be a square.
		Dim l As Int = Min(Input.Width, Input.Height)
		Input = Input.Crop(Input.Width / 2 - l / 2, Input.Height / 2 - l / 2, l, l)
	End If
	Dim c As B4XCanvas
	Dim xview As B4XView = xui.CreatePanel("")
	xview.SetLayoutAnimated(0, 0, 0, Size, Size)
	c.Initialize(xview)
	Dim path As B4XPath
	path.InitializeOval(c.TargetRect)
	c.ClipPath(path)
	c.DrawBitmap(Input.Resize(Size, Size, False), c.TargetRect)
	c.RemoveClip
	c.DrawCircle(c.TargetRect.CenterX, c.TargetRect.CenterY, c.TargetRect.Width / 2 - 2dip, xui.Color_White, False, 5dip) 'comment this line to remove the border
	c.Invalidate
	Dim res As B4XBitmap = c.CreateBitmap
	c.Release
	Return res
	
End Sub

Private Sub CreateBitmap As Canvas
	Dim bmp As Bitmap
	bmp.InitializeMutable(200dip, 200dip)
	Dim cvs As Canvas
	cvs.Initialize2(bmp)
	Dim r As Rect
	r.Initialize(0, 0, bmp.Width, bmp.Height)
	cvs.DrawRect(r, Colors.Transparent, True, 0)
	Dim p As Path
	p.Initialize(0, 0)
	Dim jo As JavaObject = p
	Dim x = 100dip, y = 100dip, radius = 100dip As Float
	jo.RunMethod("addCircle", Array As Object(x, y, radius, "CW"))
	cvs.ClipPath(p)
	Return cvs
End Sub

Private Sub DrawRoundBitmap (cvs As Canvas, bmp As Bitmap)
	Dim r As Rect
	r.Initialize(0, 0, cvs.Bitmap.Width, cvs.Bitmap.Height)
	cvs.DrawBitmap(bmp, Null, r)
End Sub

Private Sub FixOrientation(Dir As String,Filename As String) As Bitmap
	
	Dim temp As Bitmap
	Dim degree As Float
	
	Dim exif As ExifData
	exif.Initialize(Dir,Filename)

	Select exif.getAttribute(exif.TAG_ORIENTATION)
		Case exif.ORIENTATION_ROTATE_180
			degree = 180
			
		Case exif.ORIENTATION_ROTATE_270
			degree = 270
			
		Case exif.ORIENTATION_ROTATE_90
			degree = 90
				
	End Select
	
	temp = LoadBitmap(Dir,Filename)
	
	If degree <> 0 Then
		temp = RotateBitmap(temp,degree)
	End If
	
	Return temp
	
End Sub

Private Sub GetPathFromContentResult(UriString As String) As String
	If UriString.StartsWith("/") Then Return UriString 'If the user used a file manager to choose the image
	Dim Cursor1 As Cursor
	Dim Uri1 As Uri
	Dim Proj() As String = Array As String("_data")
	Dim cr As ContentResolver
	cr.Initialize("")
	If UriString.StartsWith("content://com.android.providers.media.documents") Then
		Dim i As Int = UriString.IndexOf("%3A")
		Dim id As String = UriString.SubString(i + 3)
		Uri1.Parse("content://media/external/images/media")
		Cursor1 = cr.Query(Uri1, Proj, "_id = ?", Array As String(id), "")
	Else
		Uri1.Parse(UriString)
		Cursor1 = cr.Query(Uri1, Proj, "", Null, "")
	End If
	Cursor1.Position = 0
	Dim res As String
	res = Cursor1.GetString("_data")
	Cursor1.Close
	Return res
End Sub

Private Sub GetFilenameOfPath(fullpath As String) As String 
	Try
		Dim su As StringUtils
		fullpath	=	su.DecodeUrl(fullpath,"UTF8")
		
		Dim index As Int
		index = fullpath.LastIndexOf("/")
		Dim rs As String
		rs = fullpath.SubString(index + 1)
		Return rs
	Catch
		
	End Try
End Sub
#End If