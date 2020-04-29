extends Node2D

signal begin_game

var going_to_game = false

var splash_screens
var splash_screen_index = 0

var current_splash_screen : SplashScreen

func _ready():
	splash_screens = $SplashScreens.get_children()
	play_current_splash_screen()

func play_current_splash_screen():
	if splash_screen_index >= splash_screens.size():
		emit_signal("begin_game")
		return
	current_splash_screen = splash_screens[splash_screen_index]
	current_splash_screen.begin()
	current_splash_screen.connect("finished", self, "_on_splash_screen_finished")

func play_next_splash_screen():
	splash_screen_index += 1
	play_current_splash_screen()
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !current_splash_screen.is_fading_out:
			current_splash_screen.fade_out()

func _on_splash_screen_finished():
	play_next_splash_screen()
