#
# Copyright (C) 2011-2021 Entware
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# The newer version has different dependency tracking

include $(TOPDIR)/rules.mk

PKG_NAME:=lomo-web
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/lomorage/lomo-web.git
PKG_SOURCE_VERSION=0a9d97038f4bb26f1845395b853ccde32f4dc386

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

ifeq ($(BUILD_VARIANT),nohf)
GOARM=GOARM=5
endif

define Package/lomo-web/Default
	$(call Package/gopackage/Default)
	SECTION:=multimedia
	CATEGORY:=Multimedia
	TITLE:=Lomorage web client 
	URL:=https://github.com/lomorage
	#DEPENDS:=+libstdcpp +libltdl +glib2 +vips $(INTL_DEPENDS)
endef

define Package/lomo-web
	$(call Package/lomo-web/Default)
	VARIANT:=hf
endef

define Package/lomo-web_nohf
	$(call Package/lomo-web/Default)
	VARIANT:=nohf
	#DEPENDS:=@(TARGET_armv7_2_6||TARGET_armv7_3_2)
endef

define Package/lomo-web/description
 Lomorage web client 
endef

Package/lomo-web_nohf/description=$(Package/lomo-web/description)

TARGET_LDFLAGS += -lintl

define Build/Compile
        (\
                echo $(PKG_BUILD_DIR); \
                cd $(PKG_BUILD_DIR); \
		rice embed-go; \
		GO111MODULE=auto GOOS=linux GOARCH=$(GOARCH) $(GOARM) GOMIPS=softfloat $(GOROOT)/bin/go build -o lomo-web; \
        )
endef

define Package/lomo-web/postinst
#!/bin/sh
# check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
        echo "start lomow service"
        /opt/etc/init.d/lomow start
fi
exit 0
endef

define Package/lomo-web/prerm
#!/bin/sh
# check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
        echo "stop lomow service"
        /opt/etc/init.d/lomow stop
fi
exit 0
endef

define Package/lomo-web/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lomo-web $(1)/opt/bin
	$(INSTALL_DIR) $(1)/opt/etc/init.d
	$(INSTALL_BIN) ./files/lomow $(1)/opt/etc/init.d
endef

Package/lomo-web_nohf/install=$(Package/lomo-web/install)

$(eval $(call BuildPackage,lomo-web))
$(eval $(call BuildPackage,lomo-web_nohf))

