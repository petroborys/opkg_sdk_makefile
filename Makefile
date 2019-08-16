include $(TOPDIR)/rules.mk

# Name, version and release number
# The name and version of your package are used to define the variable to point to the build directory of your package: $(PKG_BUILD_DIR)
PKG_NAME:=toolsense_owrt
PKG_VERSION:=1.0
PKG_RELEASE:=3

# Source settings (i.e. where to find the source codes)
# This is a custom variable, used below
SOURCE_DIR:=/home/vagrant/buildbot/toolsense_owrt/
PKG_BUILD_DEPENDS:=libmosquitto

include $(INCLUDE_DIR)/package.mk

# Package definition; instructs on how and where our package will appear in the overall configuration menu ('make menuconfig')
define Package/toolsense_owrt
	SECTION:=examples
	DEPENDS:=+libmosquitto
	CATEGORY:=Examples
	TITLE:=OpenWrt vs MQTT!
endef

# Package description; a more verbose description on what our package does
define Package/toolsense_owrt/description
	A simple "MQTT!" -application.
endef

# Package preparation instructions; create the build directory and copy the source code. 
# The last command is necessary to ensure our preparation instructions remain compatible with the patching system.
define Build/Prepare
		mkdir -p $(PKG_BUILD_DIR)
		cp $(SOURCE_DIR)/* $(PKG_BUILD_DIR)
		$(Build/Patch)
endef

# Package build instructions; invoke the target-specific compiler to first compile the source file, and then to link the file into the final executable
define Build/Compile
		$(TARGET_CC) $(TARGET_CFLAGS) -o $(PKG_BUILD_DIR)/toolsense_owrt.o -c $(PKG_BUILD_DIR)/toolsense_owrt.c
		$(TARGET_CC) $(TARGET_CFLAGS) -o $(PKG_BUILD_DIR)/functions.o -c $(PKG_BUILD_DIR)/functions.c
		$(TARGET_CC) $(TARGET_LDFLAGS) -o $(PKG_BUILD_DIR)/$1 $(PKG_BUILD_DIR)/toolsense_owrt.o $(PKG_BUILD_DIR)/functions.o -lmosquitto
endef

# Package install instructions; create a directory inside the package to hold our executable, and then copy the executable we built previously into the folder
define Package/toolsense_owrt/install
		$(INSTALL_DIR) $(1)/usr/bin
		$(INSTALL_BIN) $(PKG_BUILD_DIR)/toolsense_owrt $(1)/usr/bin
endef

# This command is always the last, it uses the definitions and variables we give above in order to get the job done
$(eval $(call BuildPackage,toolsense_owrt,+libmosquitto))
