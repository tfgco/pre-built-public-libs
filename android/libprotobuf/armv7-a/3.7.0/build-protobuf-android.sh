export PREFIX=$HOME/dev/android/protobuf-3.7.0/
export PATH=$HOME/dev/android/arm-16-toolchain-clang/bin:$PATH
export SYSROOT=$HOME/dev/android/arm-16-toolchain-clang/sysroot
export CC="arm-linux-androideabi-clang --sysroot $SYSROOT"
export CXX="arm-linux-androideabi-clang++ --sysroot $SYSROOT"

../configure \
--prefix=$PREFIX \
--host=arm-linux-androideabi \
--with-sysroot="${SYSROOT}" \
--enable-shared \
--enable-cross-compile \
--with-protoc=protoc \
CFLAGS="-march=armv64-v8 -D__ANDROID_API__=16" \
CXXFLAGS="-fPIC -frtti -fexceptions -march=arm64-v8 -D__ANDROID_API__=16 -Os" \
LIBS="-llog -lz -lc++_static"

make -j 4
