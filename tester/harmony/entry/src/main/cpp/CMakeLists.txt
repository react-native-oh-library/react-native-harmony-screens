project(rnapp)
cmake_minimum_required(VERSION 3.5)
set(RNOH_APP_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set(NODE_MODULES "${CMAKE_CURRENT_SOURCE_DIR}/../../../../../node_modules")
set(RNOH_CPP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../../oh_modules/@rnoh/react-native-openharmony/src/main/cpp")
set(RNOH_GENERATED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/generated")
set(LOG_VERBOSITY_LEVEL 1)
set(CMAKE_ASM_FLAGS "-Wno-error=unused-command-line-argument -Qunused-arguments")
set(WITH_HITRACE_SYSTRACE ON)
set(WITH_HITRACE_REACT_MARKER ON)
#set(OH_MODULES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../../oh_modules") # required by 'autolink_libraries'
set(OH_MODULES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../oh_modules")

add_subdirectory("${RNOH_CPP_DIR}" ./rn)

#include("${CMAKE_CURRENT_SOURCE_DIR}/autolinking.cmake")

# RNOH_BEGIN: manual_package_linking_1
#add_subdirectory("${OH_MODULES_DIR}/@rnoh/react-native-openharmony-screens/src/main/cpp" ./rnoh_screens) # <=
add_subdirectory("${OH_MODULES_DIR}/@react-native-oh-tpl/react-native-openharmony-screens/src/main/cpp" ./rnoh_screens)
add_subdirectory("${OH_MODULES_DIR}/@react-native-oh-tpl/react-native-gesture-handler/src/main/cpp" ./gesture-handler)
add_subdirectory("${OH_MODULES_DIR}/@react-native-oh-tpl/react-native-safe-area-context/src/main/cpp" ./safe-area)
# RNOH_END: manual_package_linking_1

file(GLOB GENERATED_CPP_FILES "${CMAKE_CURRENT_SOURCE_DIR}/generated/*.cpp") # this line is needed by codegen v1
add_library(rnoh_app SHARED
    ${GENERATED_CPP_FILES}
    "./PackageProvider.cpp"
    "${RNOH_CPP_DIR}/RNOHAppNapiBridge.cpp"
)
target_link_libraries(rnoh_app PUBLIC rnoh)

#autolink_libraries(rnoh_app)

# RNOH_BEGIN: manual_package_linking_2
#target_link_libraries(rnoh_app PUBLIC rnoh_screens)
target_link_libraries(rnoh_app PUBLIC rnoh_screens)
target_link_libraries(rnoh_app PUBLIC rnoh_gesture_handler)
target_link_libraries(rnoh_app PUBLIC rnoh_safe_area)
# RNOH_END: manual_package_linking_2