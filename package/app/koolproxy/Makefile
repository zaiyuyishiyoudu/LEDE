#
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=koolproxy
PKG_VERSION:=3.8.4
PKG_RELEASE:=1
PKG_MAINTAINER:=panda-mute <wxuzju@gmail.com>
PKG_LICENSE:=GPLv3

include $(INCLUDE_DIR)/package.mk

define Package/koolproxy
   SECTION:=net
   CATEGORY:=Network
   DEPENDS:= \
     +openssl-util \
     +ipset \
     +dnsmasq-full \
     +@BUSYBOX_CONFIG_DIFF \
     +iptables-mod-nat-extra \
     +wget
   TITLE:=Koolproxy is a proxy software that can recognize Adblock rules
   MAINTAINER:=Florian Eckert <fe@dev.tdt.de>
   PKGARCH:=all
endef

define Package/koolproxy/description
	This package contains LuCI configuration pages for koolproxy.
endef

define Build/Compile
endef

define Package/koolproxy/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	( . /etc/uci-defaults/luci-koolproxy ) && rm -f /etc/uci-defaults/luci-koolproxy
	rm -f /tmp/luci-indexcache
fi
exit 0
endef

define Package/koolproxy/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/adblocklist
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/usr/share/koolproxy
	$(INSTALL_DIR) $(1)/usr/share/koolproxy/data
	$(INSTALL_DIR) $(1)/usr/share/koolproxy/data/rules/

	$(INSTALL_BIN) ./files/etc/uci-defaults/luci-koolproxy $(1)/etc/uci-defaults/luci-koolproxy
	$(INSTALL_BIN) ./files/etc/init.d/* $(1)/etc/init.d/
	$(INSTALL_DATA) ./files/etc/config/* $(1)/etc/config/
	$(INSTALL_DATA) ./files/etc/adblocklist/* $(1)/etc/adblocklist/
	$(INSTALL_DATA) ./files/lib/upgrade/keep.d/koolproxy $(1)/lib/upgrade/keep.d/
	$(INSTALL_BIN) ./files/usr/sbin/* $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/usr/share/koolproxy/data/gen_ca.sh $(1)/usr/share/koolproxy/data/
	$(INSTALL_DATA) ./files/usr/share/koolproxy/data/openssl.cnf $(1)/usr/share/koolproxy/data/
	$(INSTALL_DATA) ./files/usr/share/koolproxy/data/user.txt $(1)/usr/share/koolproxy/data/
	$(INSTALL_DATA) ./files/usr/share/koolproxy/data/source.list $(1)/usr/share/koolproxy/data/
	$(INSTALL_DATA) ./files/usr/share/koolproxy/data/rules/* $(1)/usr/share/koolproxy/data/rules/
	$(INSTALL_BIN) ./files/usr/share/koolproxy/camanagement $(1)/usr/share/koolproxy/camanagement
	$(INSTALL_BIN) ./files/usr/share/koolproxy/kpupdate $(1)/usr/share/koolproxy/kpupdate
	$(INSTALL_DATA) ./files/usr/share/koolproxy/koolproxy_ipset.conf $(1)/usr/share/koolproxy/koolproxy_ipset.conf
	$(INSTALL_DATA) ./files/usr/share/koolproxy/dnsmasq.adblock $(1)/usr/share/koolproxy/dnsmasq.adblock
ifeq ($(ARCH),mipsel)
	$(INSTALL_BIN) ./files/bin/mipsel $(1)/usr/share/koolproxy/koolproxy
endif
ifeq ($(ARCH),mips)
	$(INSTALL_BIN) ./files/bin/mips $(1)/usr/share/koolproxy/koolproxy
endif
ifeq ($(ARCH),i386)
	$(INSTALL_BIN) ./files/bin/i386 $(1)/usr/share/koolproxy/koolproxy
endif
ifeq ($(ARCH),x86_64)
	$(INSTALL_BIN) ./files/bin/x86_64 $(1)/usr/share/koolproxy/koolproxy
endif
ifeq ($(ARCH),arm)
	$(INSTALL_BIN) ./files/bin/arm $(1)/usr/share/koolproxy/koolproxy
endif
endef

$(eval $(call BuildPackage,koolproxy))
