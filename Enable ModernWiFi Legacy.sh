#!/bin/bash

#Installing a fresh copy of OCLP Drivers if exist in TMP
if [ "$KERNEL_MAJOR" -ge 21 ]; then # Sonoma & above
	#Start of OCLPBroadcomWifi
	if [ -e "$TEMP_DIR"/OCLPBroadcomWifi14.kext ]; then
		OCLP_BROADCOM_WIFI_FOLDER_14=Yes
		cp -Rf "$OEM_DIR"/OCLP/OCLPWifi/BrcmIntel/OCLPBroadcomWifi.kext "$CLOVER_EFI"/CLOVER/kexts/14
		rm -Rf "$TEMP_DIR"/OCLPBroadcomWifi14.kext
	fi
	if [ -e "$TEMP_DIR"/OCLPBroadcomWifi15.kext ]; then
		OCLP_BROADCOM_WIFI_FOLDER_15=Yes
		cp -Rf "$OEM_DIR"/OCLP/OCLPWifi/BrcmIntel/OCLPBroadcomWifi.kext "$CLOVER_EFI"/CLOVER/kexts/15
		rm -Rf "$TEMP_DIR"/OCLPBroadcomWifi15.kext
	fi
	if [ -e "$TEMP_DIR"/OCLPBroadcomWifi26.kext ]; then
		OCLP_BROADCOM_WIFI_FOLDER_26=Yes
		cp -Rf "$OEM_DIR"/OCLP/OCLPWifi/BrcmIntel/OCLPBroadcomWifi.kext "$CLOVER_EFI"/CLOVER/kexts/26
		rm -Rf "$TEMP_DIR"/OCLPBroadcomWifi26.kext
	fi
	#End of OCLPBroadcomWifi
	#Start of OCLPIntelWifi
	if [ -e "$TEMP_DIR"/OCLPIntelWifi15.kext ]; then
		OCLP_INTEL_WIFI_FOLDER_15=Yes
		cp -Rf "$OEM_DIR"/OCLP/OCLPWifi/BrcmIntel/OCLPIntelWifi.kext "$CLOVER_EFI"/CLOVER/kexts/15
		rm -Rf "$CLOVER_EFI"/CLOVER/kexts/15/itlwm.kext
		rm -Rf "$TEMP_DIR"/OCLPIntelWifi15.kext
	fi
	if [ -e "$TEMP_DIR"/OCLPIntelWifi26.kext ]; then
		OCLP_INTEL_WIFI_FOLDER_26=Yes
		cp -Rf "$OEM_DIR"/OCLP/OCLPWifi/BrcmIntel/OCLPIntelWifi.kext "$CLOVER_EFI"/CLOVER/kexts/26
		rm -Rf "$CLOVER_EFI"/CLOVER/kexts/26/itlwm.kext
		rm -Rf "$TEMP_DIR"/OCLPIntelWifi26.kext
	fi
	#End of OCLPIntelWifi
	if [ -e "$TEMP_DIR"/AMFIPass14.kext ]; then
		cp -Rf "$CLOVER_DIR"/CLOVER/kexts/Off/AMFIPass.kext "$CLOVER_EFI"/CLOVER/kexts/14
		rm -Rf "$TEMP_DIR"/AMFIPass14.kext
	fi
	if [ -e "$TEMP_DIR"/AMFIPass15.kext ]; then
		cp -Rf "$CLOVER_DIR"/CLOVER/kexts/Off/AMFIPass.kext "$CLOVER_EFI"/CLOVER/kexts/15
		rm -Rf "$TEMP_DIR"/AMFIPass15.kext
	fi
	if [ -e "$TEMP_DIR"/AMFIPass26.kext ]; then
		cp -Rf "$CLOVER_DIR"/CLOVER/kexts/Off/AMFIPass.kext "$CLOVER_EFI"/CLOVER/kexts/26
		rm -Rf "$TEMP_DIR"/AMFIPass26.kext
	fi
	if [ "$OCLP_BROADCOM_WIFI_FOLDER_14" == "Yes" ]; then
		"$PlistBuddy" -c "Set :KernelAndKextPatches:KextsToBlock:0:Disabled false" "$CLOVER_EFI"/CLOVER/config.plist
	fi
	if [ "$OCLP_BROADCOM_WIFI_FOLDER_15" == "Yes" ]; then
		"$PlistBuddy" -c "Set :KernelAndKextPatches:KextsToBlock:1:Disabled false" "$CLOVER_EFI"/CLOVER/config.plist
	fi
	if [ "$OCLP_BROADCOM_WIFI_FOLDER_26" == "Yes" ]; then
		"$PlistBuddy" -c "Set :KernelAndKextPatches:KextsToBlock:2:Disabled false" "$CLOVER_EFI"/CLOVER/config.plist
		"$PlistBuddy" -c "Set :KernelAndKextPatches:KextsToBlock:3:Disabled false" "$CLOVER_EFI"/CLOVER/config.plist
	fi
	if [ -e "$CLOVER_EFI_KEXT_FOLDER"/OCLPBroadcomWifi.kext ]; then
		echo "Restoring OCLP Broadcom Wi-Fi Driver"
	fi
	if [ "$OCLP_INTEL_WIFI_FOLDER_15" == "Yes" ]; then
		"$PlistBuddy" -c "Set :KernelAndKextPatches:KextsToBlock:1:Disabled false" "$CLOVER_EFI"/CLOVER/config.plist
	fi
	if [ "$OCLP_INTEL_WIFI_FOLDER_26" == "Yes" ]; then
		"$PlistBuddy" -c "Set :KernelAndKextPatches:KextsToBlock:2:Disabled false" "$CLOVER_EFI"/CLOVER/config.plist
		"$PlistBuddy" -c "Set :KernelAndKextPatches:KextsToBlock:3:Disabled false" "$CLOVER_EFI"/CLOVER/config.plist
	fi
	if [[ -e "$CLOVER_EFI"/CLOVER/kexts/26/AMFIPass.kext ]]; then # if AMFIPass exist in 26 Folder
		BOOT_FLAGS=$("$PlistBuddy" -c "print :Boot:Arguments" "$CLOVER_EFI"/CLOVER/config.plist)
		if [[ ! `grep -i '\-amfipassbeta' "$CLOVER_EFI"/CLOVER/config.plist` ]]; then
			echo "Enabling AMFIPass Flag"
			"$PlistBuddy" -c "Set :Boot:Arguments ${BOOT_FLAGS} -amfipassbeta" "$CLOVER_EFI"/CLOVER/config.plist
		fi
	else
		if [[ `grep -i '\-amfipassbeta' "$CLOVER_EFI"/CLOVER/config.plist` ]]; then
			echo "Removing AMFIPass Flag"
			perl -pi -e 's|-amfipassbeta||g' "$CLOVER_EFI"/CLOVER/config.plist
		fi

	fi
fi
#Done Installing a fresh copy of OCLP Drivers if exist in TMP

exit 0

