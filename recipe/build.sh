#!/bin/bash

echo "Configuring and building Thirdparty/DBoW2 ..."

cd Thirdparty/DBoW2
mkdir build
cd build
cmake -G "Ninja" \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_LIBRARY_ARCHITECTURE=x86_64-linux-gnu \
      ..

ninja

for d in DBoW2 DUtils; do
      mkdir -p $PREFIX/include/Thirdparty/DBoW2/$d
      cp ../$d/*.h* $PREFIX/include/Thirdparty/DBoW2/$d
done
cp -R ../lib $PREFIX

cd ../../g2o

echo "Configuring and building Thirdparty/g2o ..."

mkdir build
cd build
cmake -G "Ninja" \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_LIBRARY_ARCHITECTURE=x86_64-linux-gnu \
      ..
ninja

mkdir -p $PREFIX/include/Thirdparty/g2o
cp ../*.h* $PREFIX/include/Thirdparty/g2o
for d in core solvers stuff types; do
      mkdir -p $PREFIX/include/Thirdparty/g2o/g2o/$d
      cp ../g2o/$d/*.h* $PREFIX/include/Thirdparty/g2o/g2o/$d
done
cp -R ../lib $PREFIX

cd ../../../

echo "Uncompress vocabulary ..."

cd Vocabulary
tar -xf ORBvoc.txt.tar.gz

mkdir -p $PREFIX/Vocabulary
cp ORBvoc.txt $PREFIX/Vocabulary

cd ..

echo "Configuring and building ORB_SLAM2 ..."

export CFLAGS="$CFLAGS -idirafter /usr/include"
export CXXFLAGS="$CXXFLAGS -idirafter /usr/include"
export LDFLAGS="$LDFLAGS -L/usr/lib/x86_64-linux-gnu -fuse-ld=gold"

mkdir build
cd build
cmake -G "Ninja" \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_LIBRARY_ARCHITECTURE=x86_64-linux-gnu \
      ..
ninja ORB_SLAM2

cd ..

cp -R include $PREFIX
cp -R lib $PREFIX
