PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 0

ifeq ($(HAVOC_VERSION_APPEND_TIME_OF_DAY),true)
    HAVOC_BUILD_DATE := $(shell date -u +%Y%m%d_%H%M%S)
else
    HAVOC_BUILD_DATE := $(shell date -u +%Y%m%d)
endif

# Set HAVOC_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef HAVOC_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "HAVOC_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^HAVOC_||g')
        HAVOC_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(HAVOC_BUILDTYPE)),)
    HAVOC_BUILDTYPE := UNOFFICIAL
    HAVOC_EXTRAVERSION :=
endif

ifeq ($(HAVOC_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        HAVOC_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

HAVOC_VERSION_SUFFIX := $(HAVOC_BUILD_DATE)-$(HAVOC_BUILDTYPE)$(HAVOC_EXTRAVERSION)-$(HAVOC_BUILD)

# Internal version
HAVOC_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(HAVOC_VERSION_SUFFIX)

# Display version
HAVOC_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR)-$(HAVOC_VERSION_SUFFIX)

# HavocOOS version properties
PRODUCT_PRODUCT_PROPERTIES += \
    ro.havoc.version=$(HAVOC_VERSION) \
    ro.havoc.display.version=$(HAVOC_DISPLAY_VERSION) \
    ro.havoc.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.havoc.releasetype=$(HAVOC_BUILDTYPE)
