#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ufraw
PKG_VERSION:=0.22
PKG_RELEASE:=$(AUTORELEASE)

#PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
#PKG_SOURCE_URL:=https://managedway.dl.sourceforge.net/project/ufraw/ufraw/$(PKG_NAME)-$(PKG_VERSION)
#PKG_HASH:=f7abd28ce587db2a74b4c54149bd8a2523a7ddc09bedf4f923246ff0ae09a25e

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/sergiomb2/ufraw
PKG_SOURCE_VERSION=684af0548ed76fd97635687fa90a754a7a04a017

PKG_MAINTAINER:=Jeromy Fu <fuji246@gmail.com>
PKG_LICENSE:=GPL-2
PKG_LICENSE_FILES:=COPYING

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/ufraw
  $(call Package/ufraw/Default)
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=A utility to read and manipulate raw images from digital cameras
  URL:=https://sourceforge.net/projects/ufraw/
  DEPENDS:=+glib2 +libjpeg-turbo +lcms +libpng +libstdcpp +libtiff +zlib $(INTL_DEPENDS)
endef

#CONFIGURE_ARGS += \
#	--disable-go \

#TARGET_CXXFLAGS += -fno-rtti

define Package/ufraw/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(CP) $(PKG_INSTALL_DIR)/opt/bin/* $(1)/opt/bin/
endef

$(eval $(call BuildPackage,ufraw))
