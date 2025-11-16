extends AudioStreamPlayer

var fadeTime = 2
var targetVolume = 0.0

func _ready():
	volume_db = 0
	
func playMusic(path: String, doFadeIn:bool = false, fadeOutPrev: bool = false):
	stream = load(path)
	if not stream:
		push_error("MusicManager: Failed to load " + path)
		return
	
	if playing:
		stopMusic(fadeOutPrev)
		

	play()
	if doFadeIn:
		fadeIn()
	
func stopMusic(doFadeOut: bool = false):
	if doFadeOut:
		fadeOut()
		await get_tree().create_timer(fadeTime).timeout
	stop()

func fadeIn():
	var tween = create_tween()
	tween.tween_property(self, "volume_db", targetVolume, fadeTime)
	
func fadeOut():
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, fadeTime)
	
func playSFX(path: String):
	var sfx = load(path)

	var p = AudioStreamPlayer.new()
	p.bus = "SFX"
	p.stream = sfx
	add_child(p)
	p.play()

	p.finished.connect(p.queue_free) # auto-clean when done
