#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=orc
PKG_VERSION:=0.4.29
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/GStreamer/orc/archive/refs/tags/
PKG_HASH:=1fdb0db4e357aafa20613699e24837cd1dc5eb01a65ab5a57d79042cb3133061

PKG_MAINTAINER:=Jeromy Fu <fuji246@gmail.com>
PKG_LICENSE:=
PKG_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/orc
  $(call Package/orc/Default)
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=The Library of Optimized Inner Loops
  URL:=https://github.com/GStreamer/orc
  DEPENDS:=$(INTL_DEPENDS)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/opt/include/orc-0.4
	$(CP) $(PKG_INSTALL_DIR)/opt/include/orc-0.4/* $(1)/opt/include/orc-0.4

	$(INSTALL_DIR) $(1)/opt/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/* $(1)/opt/lib/

	$(INSTALL_DIR) $(1)/opt/lib/pkgconfig/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/* $(1)/opt/lib/pkgconfig/
endef

define Package/orc/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(CP) $(PKG_INSTALL_DIR)/opt/bin/* $(1)/opt/bin/

	$(INSTALL_DIR) $(1)/opt/include/orc-0.4
	$(CP) $(PKG_INSTALL_DIR)/opt/include/orc-0.4/* $(1)/opt/include/orc-0.4

	$(INSTALL_DIR) $(1)/opt/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/* $(1)/opt/lib/

	$(INSTALL_DIR) $(1)/opt/lib/pkgconfig/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/* $(1)/opt/lib/pkgconfig/
endef

$(eval $(call BuildPackage,orc))
