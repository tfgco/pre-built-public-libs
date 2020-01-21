export PREFIX=$PROTOBUF_PATH
export PATH=$TOOLCHAIN_PATH/bin:$PATH
export sysroot=$TOOLCHAIN_PATH/sysroot
export CC="arm-linux-androideabi-clang --sysroot $SYSROOT"
export CXX="arm-linux-androideabi-clang++ --sysroot $SYSROOT"
export build_dir=`pwd`/../libprotobuf/android


./configure \
--host=arm-linux-androideabi \
--with-protoc=protoc \
--with-sysroot="$sysroot" \
--disable-shared \
--prefix="$build_dir/armeabi-v7a" \
--enable-cross-compile \
CFLAGS="-march=armv7-a -D__ANDROID_API__=16" \
CXXFLAGS="-frtti -fexceptions -march=armv7-a -D__ANDROID_API__=16" \
LIBS="-llog -lz -lc++_static"

make -j$(nproc)
make install

make distclean

./configure \
--host=arm-linux-androideabi \
--with-protoc=protoc \
--with-sysroot="$sysroot" \
--disable-shared \
--prefix="$build_dir/arm64-v8a" \
--enable-cross-compile \
CFLAGS="-march=armv8-a -D__ANDROID_API__=16" \
CXXFLAGS="-frtti -fexceptions -march=armv8-a -D__ANDROID_API__=16" \
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