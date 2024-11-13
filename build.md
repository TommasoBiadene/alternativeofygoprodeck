run flutter build ios --release --no-codesign. you will have Runner.app in dir build/ios/archive/Runner.xcarchive/Product/Applications/
create Payload directory.
move Runner.app to Payload.
run zip -qq -r -9 filename.ipa Payload

poi invia l'ipa zippato al telefeno e apri con e apri con alt store 