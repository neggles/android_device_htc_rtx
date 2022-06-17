#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from htc_rtx device
$(call inherit-product, device/htc/htc_rtx/device.mk)

PRODUCT_DEVICE := htc_rtx
PRODUCT_NAME := lineage_htc_rtx
PRODUCT_BRAND := htc
PRODUCT_MODEL := HTC 5G Hub
PRODUCT_MANUFACTURER := htc

PRODUCT_GMS_CLIENTID_BASE := android-telstra-au-revc

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="1.30.841.3 10.0_g CL1106658 release-keys"

BUILD_FINGERPRINT := htc/rtx_00841/htc_rtx:9/PPRL.190605.003/1106658.3:user/release-keys
