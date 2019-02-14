module("luci.controller.terminal", package.seeall)

function index()
	if not (luci.sys.call("pidof ttyd > /dev/null") == 0) then
		return
	end
	
	entry({"admin", "system", "terminal"}, template("terminal"), _("Terminal"), 10).leaf = true
	entry({"admin","system","ttydstatus"},call("ttyd_status")).leaf=true

end

function ttyd_status()
  local e={}
  e.running=luci.sys.call("pgrep ttyd >/dev/null")==0
  luci.http.prepare_content("application/json")
  luci.http.write_json(e)
end
