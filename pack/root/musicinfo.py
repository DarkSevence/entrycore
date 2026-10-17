METIN2THEMA = "M2BG.mp3"
LAST_PLAY_FILE = "lastplay.inf"

loginMusic="login_window.mp3"
createMusic="characterselect.mp3"
selectMusic="characterselect.mp3"
fieldMusic=METIN2THEMA

def SaveLastPlayFieldMusic():
	global fieldMusic

	try:
		lastPlayFile=open(LAST_PLAY_FILE, "w")
	except IOError:
		return

	lastPlayFile.write(fieldMusic)


def LoadLastPlayFieldMusic():
	global fieldMusic

	try:
		lastPlayFile=open(LAST_PLAY_FILE, "r")
	except IOError:
		return

	fieldMusic=lastPlayFile.read()


