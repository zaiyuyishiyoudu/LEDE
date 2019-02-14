module("luci.controller.koolproxy",package.seeall)
function index()
	if not nixio.fs.access("/etc/config/koolproxy")then
		return
	end
	entry({"admin","services","adkplock","koolproxy"},
	cbi("adkplock/global"),
	_("KoolProxy"), 10).leaf = true

	entry({"admin","services","adkplock","rss_rule"},cbi("adkplock/rss_rule"), nil).leaf=true
	entry({"admin","services","adkplock","kpstatus"},call("kp_status")).leaf=true
end

function kp_status()
  local e={}
  e.running=luci.sys.call("pidof koolproxy >/dev/null")==0
  luci.http.prepare_content("application/json")
  luci.http.write_json(e)
end

