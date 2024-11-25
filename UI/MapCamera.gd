extends Camera2D
var zoomTarget : Vector2

@export var zoomSpeed : float = 8

var dragStartMousePos = Vector2.ZERO #where was the mouse when we started dragging
var dragStartCameraPos = Vector2.ZERO #where was the camera when we started dragging
var isDragging : bool = false #are we dragging?
var CameraSpeedAdjustment : float = 1
var ScreenSize = get_viewport_rect().size
@export var CameraUpLimit : int = -500
@export var CameraDownLimit : int = 1550
@export var CameraRightLimit : int = 2500
@export var CameraLeftLimit : int = -500

# Called when the node enters the scene tree for the first time.
func _ready():
	zoomTarget = zoom
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Zoom(delta) #Zoom in and out with scrollwheel
	SimplePan(delta) #WASD and the camera moves
	ClickAndDrag() #Clicking on the screen and dragging your way across the screen with middle mouse button
	
	
func Zoom(delta): #Note: zoom is already associated with camera, so no need to define it
	if Input.is_action_just_pressed("CameraZoomIn"):
		zoomTarget *= 1.1
	if Input.is_action_just_pressed("CameraZoomOut"):
		zoomTarget *= 0.9
	if Input.is_action_just_pressed("ZoomReset"):
		zoomTarget = Vector2(1,1)
		
	#slerp format: Vector2 slerp(to: Vector2, weight: float) const. Returns the result of spherical linear interpolation between this vector and to, by amount weight
	
	zoom = zoom.slerp(zoomTarget, zoomSpeed * delta) #lower weight helps smooth the interpolation, multiplying by delta normalizes it between computers
	
	
func SimplePan(delta):
	var moveAmount = Vector2.ZERO
	if Input.is_action_pressed("CameraMoveUp") and global_position.y >= CameraUpLimit:
		moveAmount.y -= 1 
	if Input.is_action_pressed("CameraMoveDown") and global_position.y <= CameraDownLimit:
		moveAmount.y += 1 
	if Input.is_action_pressed("CameraMoveRight") and global_position.x <= CameraRightLimit:
		moveAmount.x += 1 
	if Input.is_action_pressed("CameraMoveLeft") and global_position.x >= CameraLeftLimit:
		moveAmount.x -= 1 
	
	moveAmount = moveAmount.normalized() 
	position += moveAmount * CameraSpeedAdjustment * delta * 1000 * (1/ zoom.x) #1/zoom slows it down based on how zoomed in we are. Multiplies according to how zoomed we are, resulting in slower pan at closer zoom.

func ClickAndDrag():
	if !isDragging and Input.is_action_just_pressed("CameraPan"):
		dragStartMousePos = get_viewport().get_mouse_position()
		dragStartCameraPos = position
		isDragging = true
	if isDragging and Input.is_action_just_released("CameraPan"):
		isDragging = false

	if isDragging :
		var moveVector = get_viewport().get_mouse_position() - dragStartMousePos #Move vector looks at where we are, and subtracting where we started from
		position = dragStartCameraPos - moveVector * (1/zoom.x)
