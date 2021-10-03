#
# Copyright (C) 2011-2021 Entware
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# The newer version has different dependency tracking

include $(TOPDIR)/rules.mk

PKG_NAME:=lomo-backend
#PKG_VERSION:=
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@bitbucket.org:lomoware/lomo-backend.git
PKG_SOURCE_VERSION=7f56dc2cd6c0e21c92f59ac0f442fbf73e7ebfb6

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/golang.mk

ifeq ($(BUILD_VARIANT),nohf)
GOARM=GOARM=5
endif

define Package/lomo-backend/Default
	$(call Package/gopackage/Default)
	TITLE:=Lomorage backend service
	URL:=https://github.com/lomorage
endef

define Package/lomo-backend
	$(call Package/lomo-backend/Default)
	VARIANT:=hf
endef

define Package/lomo-backend_nohf
	$(call Package/lomo-backend/Default)
	VARIANT:=nohf
	DEPENDS:=@(TARGET_armv7_2_6||TARGET_armv7_3_2)
endef

define Package/lomo-backend/description
 Lomorage self hosted photo cloud
endef

Package/lomo-backend_nohf/description=$(Package/lomo-backend/description)

define Build/Compile
        (\
                cd $(PKG_BUILD_DIR); \
		cd cmd/lomod; \
		CGO_CFLAGS_ALLOW="-Xpreprocessor" CGO_ENABLED=1 GOOS=linux GOARCH=$(GOARCH) $(GOARM) GOPATH=$(PKG_BUILD_DIR) $(GOROOT)/bin/go build -mod=vendor -ldflags "-s -w -X bitbucket.org/lomoware/lomo-backend/common/release.Version=$$(git rev-parse --short=12 HEAD)" -tags "sqlite_trace trace"; \
		cp lomod $(PKG_BUILD_DIR)/bin; \
		chmod -R +w $(PKG_BUILD_DIR)/pkg; \
        )
endef


define Package/lomo-backend/install
	$(INSTALL_DIR) $(1)/opt/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/lomod $(1)/opt/bin
endef

Package/lomo-backend_nohf/install=$(Package/lomo-backend/install)

$(eval $(call BuildPackage,lomo-backend))
$(eval $(call BuildPackage,lomo-backend_nohf))
