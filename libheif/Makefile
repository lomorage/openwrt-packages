#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libheif
PKG_VERSION:=1.12.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/strukturag/libheif/releases/download/v$(PKG_VERSION)
PKG_HASH:=e1ac2abb354fdc8ccdca71363ebad7503ad731c84022cf460837f0839e171718

PKG_MAINTAINER:=Jeromy Fu <fuji246@gmail.com>
PKG_LICENSE:=LGPL-3-or-later
PKG_LICENSE_FILES:=COPYING
#PKG_CPE_ID:=cpe:/a:libheif:libheif

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/libheif
  $(call Package/libheif/Default)
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=HEIF and AVIF file format decoder and encoder
  URL:=https://github.com/strukturag/libheif
  DEPENDS:=+libde265 +libstdcpp +libjpeg +libpng $(INTL_DEPENDS)
endef

CONFIGURE_ARGS += \
	--disable-go \

#TARGET_CXXFLAGS += -fno-rtti

define Build/InstallDev
	$(INSTALL_DIR) $(1)/opt/include/libheif
	$(CP) $(PKG_INSTALL_DIR)/opt/include/libheif/* $(1)/opt/include/libheif

	$(INSTALL_DIR) $(1)/opt/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/* $(1)/opt/lib/

	$(INSTALL_DIR) $(1)/opt/lib/pkgconfig/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/* $(1)/opt/lib/pkgconfig/
endef

define Package/libheif/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(CP) $(PKG_INSTALL_DIR)/opt/bin/* $(1)/opt/bin/

	$(INSTALL_DIR) $(1)/opt/include/libheif
	$(CP) $(PKG_INSTALL_DIR)/opt/include/libheif/* $(1)/opt/include/libheif

	$(INSTALL_DIR) $(1)/opt/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/* $(1)/opt/lib/

	$(INSTALL_DIR) $(1)/opt/lib/pkgconfig/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/* $(1)/opt/lib/pkgconfig/
endef

$(eval $(call BuildPackage,libheif))
