extends Node2D

class Line:
	var Start
	var End
	var LineColor
	var Time
	
	func _init(_Start, _End, _LineColor, _Time):
		self.Start = _Start
		self.End = _End
		self.LineColor = _LineColor
		self.Time = _Time

class Text:
	var Position
	var Content
	var TextColor
	var Time
	
	func _init(_Position, _Content, _TextColor, _Time):
		self.Position = _Position
		self.Content = _Content
		self.TextColor = _TextColor
		self.Time = _Time

var Lines = []
var Texts = []
var RemovedSomething = false

func _process(delta):
	for i in range(len(Lines)):
		Lines[i].Time -= delta
	for i in range(len(Texts)):
		Texts[i].Time -= delta
	
	if(len(Lines) > 0 || len(Texts) > 0 || RemovedSomething):
		update() #Calls _draw
		RemovedSomething = false

func _draw():
	var Cam = get_viewport().get_camera()
	if Cam == null:
		return

	for i in range(len(Lines)):
		var ScreenPointStart = Cam.unproject_position(Lines[i].Start)
		var ScreenPointEnd = Cam.unproject_position(Lines[i].End)
		
		#Dont draw line if either start or end is considered behind the camera
		#this causes the line to not be drawn sometimes but avoids a bug where the
		#line is drawn incorrectly
		if(Cam.is_position_behind(Lines[i].Start) ||
			Cam.is_position_behind(Lines[i].End)):
			continue
		
		draw_line(ScreenPointStart, ScreenPointEnd, Lines[i].LineColor)
	
	for t in Texts:
		var ScreenPosition = Cam.unproject_position(t.Position)
		
		#Dont draw line if either start or end is considered behind the camera
		#this causes the line to not be drawn sometimes but avoids a bug where the
		#line is drawn incorrectly
		if(Cam.is_position_behind(t.Position)):
			continue
		
		var label = Label.new()
		draw_string(label.get_font(""), ScreenPosition, t.Content, t.TextColor)
		label.free()
	
	#Remove lines that have timed out
	var i = Lines.size() - 1
	while (i >= 0):
		if(Lines[i].Time < 0.0):
			Lines.remove(i)
			RemovedSomething = true
		i -= 1
	
	i = Texts.size() - 1
	while (i >= 0):
		if(Texts[i].Time < 0.0):
			Texts.remove(i)
			RemovedSomething = true
		i -= 1

func DrawLine(Start, End, LineColor, Time = 0.0):
	Lines.append(Line.new(Start, End, LineColor, Time))

func DrawRay(Start, Ray, LineColor, Time = 0.0):
	Lines.append(Line.new(Start, Start + Ray, LineColor, Time))

func DrawCube(Center, HalfExtents, LineColor, Time = 0.0):
	#Start at the 'top left'
	var LinePointStart = Center
	LinePointStart.x -= HalfExtents
	LinePointStart.y += HalfExtents
	LinePointStart.z -= HalfExtents
	
	#Draw top square
	var LinePointEnd = LinePointStart + Vector3(0, 0, HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, Time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, Time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(0, 0, -HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, Time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(-HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, Time);
	
	#Draw bottom square
	LinePointStart = LinePointEnd + Vector3(0, -HalfExtents * 2.0, 0)
	LinePointEnd = LinePointStart + Vector3(0, 0, HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, Time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, Time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(0, 0, -HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, Time);
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(-HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, Time);
	
	#Draw vertical lines
	LinePointStart = LinePointEnd
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, Time)
	LinePointStart += Vector3(0, 0, HalfExtents * 2.0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, Time)
	LinePointStart += Vector3(HalfExtents * 2.0, 0, 0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, Time)
	LinePointStart += Vector3(0, 0, -HalfExtents * 2.0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, Time)

func DrawText(Position, Content, TextColor, Time = 0.0):
	Texts.append(Text.new(Position, Content, TextColor, Time))
