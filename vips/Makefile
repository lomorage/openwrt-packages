#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=vips
PKG_VERSION:=8.11.4
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/libvips/libvips/releases/download/v$(PKG_VERSION)
PKG_HASH:=5043f38828a0ff9f2275f9252f69e14f701ef11f55786cda8aa6ce2c4fbed2f7

PKG_MAINTAINER:=W. Michael Petullo <mike@flyn.org>
PKG_LICENSE:=LGPL-2.1-or-later
PKG_LICENSE_FILES:=COPYING
PKG_CPE_ID:=cpe:/a:vips:vips

PKG_FIXUP:=autoreconf
PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/vips
  $(call Package/vips/Default)
  SECTION:=multimedia
  CATEGORY:=Multimedia
  TITLE:=An image manipulation library
  URL:=https://libvips.github.io/libvips/
  DEPENDS:=+glib2 +libexif +libexpat +libjpeg +libpng +giflib +libheif +libde265 +libwebp +libtiff +libxml2 +libstdcpp +lcms +orc +libimagequant +imagemagick $(INTL_DEPENDS)
endef

CONFIGURE_ARGS += \
	--disable-debug \
	--disable-gtk-doc-html \
	--without-cfitsio \
	--without-gsf \
	--without-matio \
	--without-nifti \
	--without-OpenEXR \
	--without-openslide \
	--without-pangoft2 \
	--without-pdfium \
	--without-poppler \
	--without-rsvg \
	--without-x \
	--with-analyze \
	--with-radiance \
	--with-giflib \
	--with-jpeg \
	--with-libexif \
	--with-png \
	--with-heif \
	--with-libwebp \
	--with-tiff \
	--with-ppm \
	--with-imagequant \
	--with-lcms \
	--without-fftw \
	--with-orc \
	--with-zlib \

TARGET_CXXFLAGS += -fno-rtti

define Build/InstallDev
	$(INSTALL_DIR) $(1)/opt/include/vips
	$(CP) $(PKG_INSTALL_DIR)/opt/include/vips/* $(1)/opt/include/vips

	$(INSTALL_DIR) $(1)/opt/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/libvips.{a,so}* $(1)/opt/lib/

	$(INSTALL_DIR) $(1)/opt/lib/pkgconfig/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/vips.pc $(1)/opt/lib/pkgconfig/vips.pc
endef

define Package/vips/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(CP) $(PKG_INSTALL_DIR)/opt/bin/* $(1)/opt/bin/

	$(INSTALL_DIR) $(1)/opt/include/vips
	$(CP) $(PKG_INSTALL_DIR)/opt/include/vips/* $(1)/opt/include/vips

	$(INSTALL_DIR) $(1)/opt/lib/
	$(CP) $(PKG_INSTALL_DIR)/opt/lib/* $(1)/opt/lib/

	$(INSTALL_DIR) $(1)/opt/lib/pkgconfig/
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/opt/lib/pkgconfig/* $(1)/opt/lib/pkgconfig/
endef

$(eval $(call BuildPackage,vips))
