import os
import sys
import app


def Restart(localeName):
	codePages = {"pl": 1250, "en": 1252}
	if localeName not in codePages:
		raise ValueError("Unsupported locale")
	previous = None
	try:
		with open("locale.cfg", "rb") as config:
			previous = config.read()
	except IOError:
		pass
	reportPort = 10012
	if previous:
		try:
			reportPort = int(previous.split()[0])
		except (ValueError, IndexError):
			pass
	try:
		with open("locale.cfg", "wb") as config:
			config.write("%d %d %s\n" % (reportPort, codePages[localeName], localeName))
		os.spawnv(os.P_NOWAIT, sys.executable, ['"%s"' % sys.executable])
	except (IOError, OSError):
		if previous is not None:
			with open("locale.cfg", "wb") as config:
				config.write(previous)
		elif os.path.exists("locale.cfg"):
			os.remove("locale.cfg")
		raise
	app.Exit()
