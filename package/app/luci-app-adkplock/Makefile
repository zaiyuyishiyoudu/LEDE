# Copyright (C) 2016 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for adkplock
LUCI_DEPENDS:=+adbyby +koolproxy +wget +ipset +coreutils +coreutils-nohup +dnsmasq-full
LUCI_PKGARCH:=all
PKG_NAME:=luci-app-adkplock
PKG_VERSION:=2.0
PKG_RELEASE:=40

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

