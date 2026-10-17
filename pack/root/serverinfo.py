import localeInfo
def BuildServerList(orderList):
	retMarkAddrDict = {}
	retAuthAddrDict = {}
	retRegion0 = {}

	ridx = 1
	for region, auth, mark, channels in orderList:
		cidx = 1
		channelDict = {}
		for channel in channels:
			key = ridx * 10 + cidx
			channel['key'] = key
			channelDict[cidx] = channel
			cidx += 1

		region['channel'] = channelDict

		retRegion0[ridx] = region
		retAuthAddrDict[ridx] = auth
		retMarkAddrDict[ridx*10] = mark
		ridx += 1

	return retRegion0, retAuthAddrDict, retMarkAddrDict
if localeInfo.IsEUROPE():
	STATE_NONE = '...'

	STATE_DICT = {
		0 : "....",
		1 : "NORM",
		2 : "BUSY",
		3 : "FULL"
	}

	CHANNELS = [
		{'name':'CH1','ip':'ADRES_IP','tcp_port':29000,'udp_port':29000,'state':STATE_NONE,},
		{'name':'CH2','ip':'ADRES_IP','tcp_port':29100,'udp_port':29100,'state':STATE_NONE,},
		{'name':'CH3','ip':'ADRES_IP','tcp_port':29200,'udp_port':29200,'state':STATE_NONE,},
		{'name':'CH4','ip':'ADRES_IP','tcp_port':29300,'udp_port':29300,'state':STATE_NONE,},
	]

	MARK = { 'ip' : 'ADRES_IP', 'tcp_port' : 29000, 'mark' : '120.tga', 'symbol_path' : '120', }
	AUTH = {'ip':'ADRES_IP','port':11004, }
	NAME = { 'name' : 'EntryCore 2026'}

	REGION0_ORDER_LIST = [
		(NAME, AUTH, MARK, CHANNELS),
	]
	NEW_REGION0, NEW_REGION0_AUTH_SERVER_DICT, NEW_MARKADDR_DICT = BuildServerList(REGION0_ORDER_LIST)
	# RESULT
	NEW_REGION_NAME_DICT = {0 : 'POLAND',}
	NEW_REGION_AUTH_SERVER_DICT = {0 : NEW_REGION0_AUTH_SERVER_DICT,}
	NEW_REGION_DICT = {0 : NEW_REGION0,}

	MARKADDR_DICT = NEW_MARKADDR_DICT
	REGION_DICT = NEW_REGION_DICT
	REGION_NAME_DICT = NEW_REGION_NAME_DICT
	REGION_AUTH_SERVER_DICT = NEW_REGION_AUTH_SERVER_DICT

	TESTADDR = { 'ip' : 'ADRES_IP', 'tcp_port' : 29000, 'udp_port' : 29000, }
