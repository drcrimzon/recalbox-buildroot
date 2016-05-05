################################################################################
#
# MAME2010
#
################################################################################
LIBRETRO_MAME2010_VERSION = a4537c34e89dd0e1402ee1a79943104dbe47c90f
LIBRETRO_MAME2010_SITE = $(call github,libretro,mame2010-libretro,$(LIBRETRO_MAME2010_VERSION))



define LIBRETRO_MAME2010_BUILD_CMDS
	mkdir -p $(@D)/obj/mame/cpu/ccpu
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_CC)" RANLIB="$(TARGET_RANLIB)" PTR64=0 AR="$(TARGET_AR)" -C $(@D)/ -f Makefile ARCH="$(TARGET_CFLAGS) -fsigned-char"

endef

define LIBRETRO_MAME2010_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/mame139_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/mame139_libretro.so
endef

$(eval $(generic-package))
