
module("luci.controller.adbyby", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/adbyby") then
		return
	end
	
	entry({"admin", "services", "adkplock"},
	alias("admin", "services", "adkplock", "adbyby"),
	_("Advertising prevent"), 10)

	entry({"admin", "services", "adkplock", "adbyby"},
		cbi("adkplock/adbyby"),
	_("adbyby"), 5).leaf = true

	entry({"admin","services","adkplock","status"},call("act_status")).leaf=true
end

function act_status()
  local e={}
  e.running=luci.sys.call("pgrep adbyby >/dev/null")==0
  luci.http.prepare_content("application/json")
  luci.http.write_json(e)
end
