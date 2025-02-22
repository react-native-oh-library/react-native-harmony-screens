# This file was generated by RNOH autolinking.
# DO NOT modify it manually, your changes WILL be overwritten.
cmake_minimum_required(VERSION 3.5)

# @api
function(autolink_libraries target)
    add_subdirectory("${OH_MODULES_DIR}/@rnoh/react-native-openharmony-gesture-handler/src/main/cpp" ./rnoh_gesture_handler)
    add_subdirectory("${OH_MODULES_DIR}/@rnoh/react-native-openharmony-safe-area-context/src/main/cpp" ./rnoh_safe_area_context)
    add_subdirectory("${OH_MODULES_DIR}/@rnoh/react-native-openharmony-screens/src/main/cpp" ./rnoh_screens)

    set(AUTOLINKED_LIBRARIES
        rnoh_gesture_handler
        rnoh_safe_area_context
        rnoh_screens
    )

    foreach(lib ${AUTOLINKED_LIBRARIES})
        target_link_libraries(${target} PUBLIC ${lib})
    endforeach()
endfunction()
