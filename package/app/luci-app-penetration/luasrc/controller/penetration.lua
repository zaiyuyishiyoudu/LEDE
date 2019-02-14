module("luci.controller.frp", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/frp") then
		return
	end

	end
	entry({"admin","services","penetration","frp"},
	cbi("frp/frp"),
	_("Frp Setting"), 5).leaf = true

	entry({"admin","services","penetration","zerotier"},
	cbi("zerotier"),
	_("ZeroTier"), 10).leaf = true

	entry({"admin","services","penetration","config"},cbi("frp/config")).leaf=true
	entry({"admin","services","penetration","status"},call("status")).leaf=true
	entry({"admin","services","penetration","zstatus"},call("act_status")).leaf=true
end
function status()
local e={}
e.running=luci.sys.call("pidof frpc > /dev/null")==0
luci.http.prepare_content("application/json")
luci.http.write_json(e)
end

function act_status()
local e={}
  e.running=luci.sys.call("pgrep /usr/bin/zerotier-one >/dev/null")==0
  luci.http.prepare_content("application/json")
  luci.http.write_json(e)
end
