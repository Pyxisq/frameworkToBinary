read -p "Enter path to framework " Path
read -p "Enter library name " LibraryName

LibrarySim="${LibraryName}_sim"
LibraryDevice="${LibraryName}_device"
cp -a $Path "$LibrarySim"
cp -a $Path "$LibraryDevice"

cd "${LibrarySim}/${LibraryName}.framework/Versions/A"

lipo -thin x86_64 "${LibraryName}" -output "${LibraryName}_x86_64"
lipo -create "${LibraryName}_x86_64" -output "${LibrarySim}"

rm -rf "${LibraryName}" "${LibraryName}_x86_64"
mv "${LibrarySim}" "${LibraryName}"

cd ../../../..

cd "${LibraryDevice}/${LibraryName}.framework/Versions/A"

lipo -thin arm64 "${LibraryName}" -output "${LibraryName}_arm64"
lipo -create "${LibraryName}_arm64" -output "${LibraryDevice}"

rm -rf "${LibraryName}" "${LibraryName}_arm64"
mv "${LibraryDevice}" "${LibraryName}"

cd ../../../..

xcodebuild -create-xcframework -framework "${LibrarySim}/${LibraryName}.framework" -framework "${LibraryDevice}/${LibraryName}.framework" -output "${LibraryName}.xcframework"

