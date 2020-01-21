#!/bin/sh
./autogen.sh
rm -rf `pwd`/../libprotobuf
mkdir -p `pwd`/../libprotobuf/android
ANDROID64_API_LEVEL="21"
ANDROID32_API_LEVEL="16"

#You just need to specify your NDK Folder
export NDK_PATH=/Users/fulvioabrahao/Documents/tfg/github/android-ndk-r20b

export PREFIX=`pwd`
export build_dir=`pwd`/../libprotobuf/android

$NDK_PATH/build/tools/make-standalone-toolchain.sh --arch=arm --platform=android-$ANDROID64_API_LEVEL --toolchain=arm-linux-android-clang5.0 --install-dir=`pwd`/arm-toolchain-$ANDROID64_API_LEVEL-clang/ --use-llvm --stl=libc++
$NDK_PATH/build/tools/make-standalone-toolchain.sh --arch=arm --platform=android-$ANDROID32_API_LEVEL --toolchain=arm-linux-android-clang5.0 --install-dir=`pwd`/arm-toolchain-$ANDROID32_API_LEVEL-clang/ --use-llvm --stl=libc++

export PATH=`pwd`/arm-toolchain-$ANDROID32_API_LEVEL-clang/bin:$PATH
export sysroot=`pwd`/arm-toolchain-$ANDROID32_API_LEVEL-clang/sysroot
export CC="arm-linux-androideabi-clang --sysroot $sysroot"
export CXX="arm-linux-androideabi-clang++ --sysroot $sysroot"


./configure \
--host=arm-linux-androideabi \
--with-protoc=protoc \
--with-sysroot="$sysroot" \
--disable-shared \
--prefix="$build_dir/armeabi-v7a" \
--enable-cross-compile \
--verbose \
CFLAGS="-march=armv7-a -D__ANDROID_API__=$ANDROID32_API_LEVEL" \
CXXFLAGS="-fPIC -frtti -fexceptions -march=armv7-a -D__ANDROID_API__=$ANDROID32_API_LEVEL" \
LIBS="-llog -lz -lc++_static"

make -j$(nproc)
make install

make distclean

export PATH=`pwd`/arm-toolchain-$ANDROID64_API_LEVEL-clang/bin:$PATH
export sysroot=`pwd`/arm-toolchain-$ANDROID64_API_LEVEL-clang/sysroot
export CC="aarch64-linux-android$ANDROID64_API_LEVEL-clang --sysroot $sysroot"
export CXX="aarch64-linux-android$ANDROID64_API_LEVEL-clang++ --sysroot $sysroot"

./configure \
--host=aarch64-linux-android \
--with-protoc=protoc \
--with-sysroot="$sysroot" \
--disable-shared \
--prefix="$build_dir/arm64-v8a" \
--enable-cross-compile \
CFLAGS="-march=armv8-a -D__ANDROID_API__=$ANDROID64_API_LEVEL" \
CXXFLAGS="-fPIC -frtti -fexceptions -march=armv8-a -D__ANDROID_API__=$ANDROID64_API_LEVEL" \
LIBS="-llog -lz -lc++_static"

make -j$(nproc)
make install

mkdir -p ../libprotobuf/android/lib/armeabi-v7a
mkdir -p ../libprotobuf/android/lib/arm64-v8a
cp ../libprotobuf/android/armeabi-v7a/lib/libprotobuf-lite.a ../libprotobuf/android/lib/armeabi-v7a
cp ../libprotobuf/android/arm64-v8a/lib/libprotobuf-lite.a ../libprotobuf/android/lib/arm64-v8a
cp -r ../libprotobuf/android/armeabi-v7a/include ../libprotobuf/android/include
rm -rf ../libprotobuf/android/armeabi-v7a
rm -rf ../libprotobuf/android/arm64-v8a

make distclean
rm -rf arm-toolchain-$ANDROID64_API_LEVEL-clang
rm -rf arm-toolchain-$ANDROID32_API_LEVEL-clang