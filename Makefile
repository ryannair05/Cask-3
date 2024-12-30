TARGET := iphone:clang:latest:14.0

THEOS_DEVICE_IP = 192.168.1.253
INSTALL_TARGET_PROCESSES = SpringBoard

FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Cask3

Cask3_FILES = $(shell find Sources -name '*.swift') $(shell find Sources -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Cask3_CFLAGS = -fobjc-arc
Cask3_SWIFT_BRIDGING_HEADER = Sources/Tweak.h

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += cask3prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
