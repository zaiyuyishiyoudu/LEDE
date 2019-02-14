
require("luci.sys")

module("luci.controller.wifidogx", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/wifidogx") then
		return
	end

	entry({"admin", "services", "wifidogx"}, cbi("wifidogx"), _("网络认证"), 40).index = true
	entry({"admin", "services", "wifidogx", "getClientList"}, call("getClientList"))
end

function getClientList()
	local RespDate = {}
	local RespCode = 0
	local HostName, IPAddr, MacAddr, Download, Upload, LoginTime
	
	local WdctlCMD = "wdctlx status | grep -e '^ ' | sed -r 's/^ +//' 2>/dev/null"

	local Version = luci.util.exec("wdctlx status | grep Version | cut -d ' ' -f 2")

	local Internet = luci.util.exec("wdctlx status | grep Internet | cut -d ' ' -f 3")

	local Auth = luci.util.exec("wdctlx status | grep Auth | cut -d ' ' -f 4")

	local client = luci.util.exec("wdctlx status | grep Auth | cut -d ' ' -f 1-1")

	local active = luci.util.exec("wdctlx status | grep Auth | cut -d ' ' -f 4-1")

	local Invalid = luci.util.exec("wdctlx status | grep unconnected | cut -d ' ' -f 0-1")

	local ip = luci.util.exec("wdctlx status | grep Host | cut -d ' ' -f 5")
	
	local UpTime = luci.util.exec("wdctlx status | grep Uptime | cut -d ' ' -f 2-6")
	if UpTime == "" then
		RespCode = 1
	else		
		local function initDate()
			HostName = "unknow"
			IPAddr = "" 
			MacAddr = "" 
			Download = 0 
			Upload = 0
			LoginTime = "0"
		end
		
		local ClientList = {}
		for _, Line in pairs(luci.util.execl(WdctlCMD)) do	
			if Line:match('^(IP:)') == "IP:" then
				IPAddr, MacAddr = Line:match('^IP: (%S+) MAC: (%S+)')
			elseif Line:match('^(First Login:)') == "First Login:" then
				LoginTime = Line:match('^First Login: (%d+)')
			elseif Line:match('^(Name:)') == "Name:" then
				HostName = Line:match('^Name: (%S+)')		
			elseif Line:match('^(Downloaded:)') == "Downloaded:" then
				Download = Line:match('^Downloaded: (%d+)')		
			elseif Line:match('^(Uploaded:)') == "Uploaded:" then
				Upload = Line:match('^Uploaded: (%d+)')
				
				table.insert(ClientList, {
						['hostname'] = HostName,
						['ipaddr'] = IPAddr,
						['macaddr'] = MacAddr,
						['download'] = Download,
						['upload'] = Upload,
						['logintime'] = os.difftime(os.time(), tonumber(LoginTime) or 0),
					})
					
				initDate()
			end
		end
		
		RespDate["clients"] = ClientList
		RespDate["version"]	= Version
		RespDate["internet"]	= Internet
		RespDate["auth"]	= Auth
		RespDate["client"]	= client
		RespDate["active"]	= active
		RespDate["Invalid"]	= invalid
		RespDate["ip"]	= ip
		RespDate["uptime"]	= UpTime
	end
	
	RespDate["code"] = RespCode
	luci.http.prepare_content("application/json")
	luci.http.write_json(RespDate)
end
