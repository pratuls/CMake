SET(CMAKE_SHARED_LIBRARY_PREFIX "lib")
SET(CMAKE_SHARED_LIBRARY_SUFFIX ".dylib")
SET(CMAKE_SHARED_MODULE_PREFIX "lib")
SET(CMAKE_SHARED_MODULE_SUFFIX ".so")
SET(CMAKE_MODULE_EXISTS 1)
SET(CMAKE_DL_LIBS "")
SET(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-dynamiclib")
SET(CMAKE_SHARED_MODULE_CREATE_C_FLAGS "-bundle")

IF("${CMAKE_BACKWARDS_COMPATIBILITY}" MATCHES "^1\\.[0-6]$")
  SET(CMAKE_SHARED_MODULE_CREATE_C_FLAGS
    "${CMAKE_SHARED_MODULE_CREATE_C_FLAGS} -flat_namespace -undefined suppress")
ENDIF("${CMAKE_BACKWARDS_COMPATIBILITY}" MATCHES "^1\\.[0-6]$")

# Enable shared library versioning.
SET(CMAKE_SHARED_LIBRARY_SONAME_C_FLAG "-install_name")
SET(CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG "-install_name")

# OSX does not really implement an rpath, but it does allow a path to
# be specified in the soname field of a dylib.
IF(CMAKE_SKIP_RPATH)
  # No rpath requested.  Just use the soname directly.
  SET(CMAKE_C_CREATE_SHARED_LIBRARY
    "<CMAKE_C_COMPILER> <CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS> <LINK_FLAGS> -o <TARGET> <CMAKE_SHARED_LIBRARY_SONAME_C_FLAG> <TARGET_SONAME> <OBJECTS> <LINK_LIBRARIES>")
  SET(CMAKE_CXX_CREATE_SHARED_LIBRARY
    "<CMAKE_CXX_COMPILER> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> <LINK_FLAGS> -o <TARGET> <CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG> <TARGET_SONAME> <OBJECTS> <LINK_LIBRARIES>")
ELSE(CMAKE_SKIP_RPATH)
  # Support for rpath is requested.  Approximate it by putting the
  # full path to the library in the soname field.  Then when executables
  # link the library they will copy this full path as the name to use
  # to find the library.  We can get the directory containing the library
  # by using the dirname of the <TARGET>.  It may be a relative path
  # so we use a "cd ...;pwd" trick to convert it to a full path at
  # build time.
  SET(CMAKE_C_CREATE_SHARED_LIBRARY
    "<CMAKE_C_COMPILER> <CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS> <LINK_FLAGS> -o <TARGET> <CMAKE_SHARED_LIBRARY_SONAME_C_FLAG> \"`cd \\`dirname <TARGET>\\`\;pwd`/<TARGET_SONAME>\" <OBJECTS> <LINK_LIBRARIES>")
  SET(CMAKE_CXX_CREATE_SHARED_LIBRARY
    "<CMAKE_CXX_COMPILER> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> <LINK_FLAGS> -o <TARGET> <CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG> \"`cd \\`dirname <TARGET>\\`\;pwd`/<TARGET_SONAME>\" <OBJECTS> <LINK_LIBRARIES>")
ENDIF(CMAKE_SKIP_RPATH)

SET(CMAKE_CXX_CREATE_SHARED_MODULE
      "<CMAKE_CXX_COMPILER> <CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS> <LINK_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")

SET(CMAKE_C_CREATE_SHARED_MODULE
      "<CMAKE_C_COMPILER> <CMAKE_SHARED_MODULE_CREATE_C_FLAGS> <LINK_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")


SET(CMAKE_PLATFORM_IMPLICIT_INCLUDE_DIRECTORIES /usr/local/include)
