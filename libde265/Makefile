#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libde265
PKG_VERSION:=1.0.8
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/strukturag/libde265/releases/download/v$(PKG_VERSION)
PKG_HASH:=24c791dd334fa521762320ff54f0febfd3c09fc978880a8c5fbc40a88f21d905

PKG_MAINTAINER:=Jeromy Fu <fuji246@gmail.com>
PKG_LICENSE:=LGPL-3-or-later
PKG_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/libde265
  $(call Package/libde265/Default)
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=h.265 video codec
  URL:=https://github.com/strukturag/libde265
  DEPENDS:=libstdcpp $(INTL_DEPENDS)
endef

CONFIGURE_ARGS += \
        --disable-sherlock265 \

define Build/InstallDev
	$(INSTALL_DIR) $(1)/opt/include/libde265
	$(CP) $(PKG_INSTALL_DIR)/opt/include/libde265/* $(1)/opt/include/libde265

	$(INSTALL_DIR) $(1)/opt/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/* $(1)/opt/lib/

	$(INSTALL_DIR) $(1)/opt/lib/pkgconfig/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/* $(1)/opt/lib/pkgconfig/
endef

define Package/libde265/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(CP) $(PKG_INSTALL_DIR)/opt/bin/* $(1)/opt/bin/

	$(INSTALL_DIR) $(1)/opt/include/libde265
	$(CP) $(PKG_INSTALL_DIR)/opt/include/libde265/* $(1)/opt/include/libde265

	$(INSTALL_DIR) $(1)/opt/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/* $(1)/opt/lib/

	$(INSTALL_DIR) $(1)/opt/lib/pkgconfig/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/* $(1)/opt/lib/pkgconfig/
endef

$(eval $(call BuildPackage,libde265))
