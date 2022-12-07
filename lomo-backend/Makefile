#
# Copyright (C) 2011-2021 Entware
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# The newer version has different dependency tracking

include $(TOPDIR)/rules.mk

PKG_NAME:=lomo-backend
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@bitbucket.org:lomoware/lomo-backend.git
PKG_SOURCE_VERSION=c6ff0f7ef711b899d04257166ab90559428c948d
SHORT_VERSION:=$${PKG_SOURCE_VERSION:0:12}

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

ifeq ($(BUILD_VARIANT),nohf)
GOARM=GOARM=5
endif

define Package/lomo-backend/Default
	$(call Package/gopackage/Default)
	SECTION:=multimedia
	CATEGORY:=Multimedia
	TITLE:=Lomorage backend service
	URL:=https://github.com/lomorage
	DEPENDS:=+libstdcpp +libltdl +glib2 +vips $(INTL_DEPENDS)
endef

define Package/lomo-backend
	$(call Package/lomo-backend/Default)
	VARIANT:=hf
endef

define Package/lomo-backend_nohf
	$(call Package/lomo-backend/Default)
	VARIANT:=nohf
	#DEPENDS:=@(TARGET_armv7_2_6||TARGET_armv7_3_2)
endef

define Package/lomo-backend/description
 Lomorage self hosted photo cloud
endef

Package/lomo-backend_nohf/description=$(Package/lomo-backend/description)

TARGET_LDFLAGS += -lintl

define Build/Compile
        (\
                echo $(PKG_BUILD_DIR); \
                cd $(PKG_BUILD_DIR); \
		cd handler; \
		rice embed-go; \
		cd ../cmd/lomod; \
		GO111MODULE=auto CGO_LDFLAGS="$(TARGET_LDFLAGS)" CGO_CFLAGS_ALLOW="-Xpreprocessor" CGO_ENABLED=1 GOOS=linux GOARCH=$(GOARCH) $(GOARM) CC=$(TARGET_CC) CXX=$(TARGET_CXX) GOMIPS=softfloat $(GOROOT)/bin/go build -mod=vendor -ldflags "-s -w -v -X bitbucket.org/lomoware/lomo-backend/common/release.Version=$(SHORT_VERSION) -extldflags \"$(TARGET_LDFLAGS)\"" -tags "sqlite_trace trace"; \
        )
endef

define Package/lomo-backend/postinst
#!/bin/sh
# check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
        echo "start lomod service"
        /etc/init.d/lomod enable
        /etc/init.d/lomod start
fi
exit 0
endef

define Package/lomo-backend/prerm
#!/bin/sh
# check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
        echo "stop lomod service"
        /etc/init.d/lomod stop
        /etc/init.d/lomod disable
fi
exit 0
endef

define Package/lomo-backend/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/cmd/lomod/lomod $(1)/opt/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/lomod $(1)/etc/init.d
endef

Package/lomo-backend_nohf/install=$(Package/lomo-backend/install)

$(eval $(call BuildPackage,lomo-backend))
$(eval $(call BuildPackage,lomo-backend_nohf))

