TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = cask3prefs

cask3prefs_FILES = $(shell find Sources -name '*.swift')
cask3prefs_INSTALL_PATH = /Library/PreferenceBundles
cask3prefs_PRIVATE_FRAMEWORKS = SpringBoardServices

include $(THEOS_MAKE_PATH)/bundle.mk
